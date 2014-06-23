Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaFWBe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:34:29 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39781 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbaFWBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:57 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Alexey Lyashkov <alexey_lyashkov@xyratex.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 14/18] staging/lustre/ptlrpc: unlink request buffer correctly
Date: Sun, 22 Jun 2014 21:32:18 -0400
Message-Id: <1403487142-4880-15-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Lyashkov <alexey_lyashkov@xyratex.com>

outgoning buffer may be hold by lnet and don't unlinked fast,
it's break unloading a lustre modules as request hold a
reference to the export/obd

Signed-off-by: Alexey Lyashkov <alexey_lyashkov@xyratex.com>
Xyratex-bug-id: MRP-1848
Reviewed-on: http://review.whamcloud.com/10353
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5073
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_net.h |  6 ++++--
 drivers/staging/lustre/lustre/ptlrpc/client.c      | 11 ++++++-----
 drivers/staging/lustre/lustre/ptlrpc/events.c      |  9 +++++----
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |  5 +++--
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index f6b7d10..b837d34 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -1591,7 +1591,8 @@ struct ptlrpc_request {
 		rq_replay:1,
 		rq_no_resend:1, rq_waiting:1, rq_receiving_reply:1,
 		rq_no_delay:1, rq_net_err:1, rq_wait_ctx:1,
-		rq_early:1, rq_must_unlink:1,
+		rq_early:1,
+		rq_req_unlink:1, rq_reply_unlink:1,
 		rq_memalloc:1,      /* req originated from "kswapd" */
 		/* server-side flags */
 		rq_packed_final:1,  /* packed final reply */
@@ -3039,7 +3040,8 @@ ptlrpc_client_recv_or_unlink(struct ptlrpc_request *req)
 		spin_unlock(&req->rq_lock);
 		return 1;
 	}
-	rc = req->rq_receiving_reply || req->rq_must_unlink;
+	rc = req->rq_receiving_reply;
+	rc = rc || req->rq_req_unlink || req->rq_reply_unlink;
 	spin_unlock(&req->rq_lock);
 	return rc;
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 1890482..0e0ea5c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -1202,7 +1202,7 @@ static int after_reply(struct ptlrpc_request *req)
 
 	LASSERT(obd != NULL);
 	/* repbuf must be unlinked */
-	LASSERT(!req->rq_receiving_reply && !req->rq_must_unlink);
+	LASSERT(!req->rq_receiving_reply && !req->rq_reply_unlink);
 
 	if (req->rq_reply_truncate) {
 		if (ptlrpc_no_resend(req)) {
@@ -2406,9 +2406,10 @@ int ptlrpc_unregister_reply(struct ptlrpc_request *request, int async)
 		}
 
 		LASSERT(rc == -ETIMEDOUT);
-		DEBUG_REQ(D_WARNING, request, "Unexpectedly long timeout "
-			  "rvcng=%d unlnk=%d", request->rq_receiving_reply,
-			  request->rq_must_unlink);
+		DEBUG_REQ(D_WARNING, request,
+			  "Unexpectedly long timeout rvcng=%d unlnk=%d/%d",
+			  request->rq_receiving_reply,
+			  request->rq_req_unlink, request->rq_reply_unlink);
 	}
 	return 0;
 }
@@ -3081,7 +3082,7 @@ void *ptlrpcd_alloc_work(struct obd_import *imp,
 	req->rq_interpret_reply = work_interpreter;
 	/* don't want reply */
 	req->rq_receiving_reply = 0;
-	req->rq_must_unlink = 0;
+	req->rq_req_unlink = req->rq_reply_unlink = 0;
 	req->rq_no_delay = req->rq_no_resend = 1;
 	req->rq_pill.rc_fmt = (void *)&worker_format;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index 9f9b8d1..209fcc1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -63,19 +63,20 @@ void request_out_callback(lnet_event_t *ev)
 	DEBUG_REQ(D_NET, req, "type %d, status %d", ev->type, ev->status);
 
 	sptlrpc_request_out_callback(req);
+	spin_lock(&req->rq_lock);
 	req->rq_real_sent = cfs_time_current_sec();
+	if (ev->unlinked)
+		req->rq_req_unlink = 0;
 
 	if (ev->type == LNET_EVENT_UNLINK || ev->status != 0) {
 
 		/* Failed send: make it seem like the reply timed out, just
 		 * like failing sends in client.c does currently...  */
 
-		spin_lock(&req->rq_lock);
 		req->rq_net_err = 1;
-		spin_unlock(&req->rq_lock);
-
 		ptlrpc_client_wake_req(req);
 	}
+	spin_unlock(&req->rq_lock);
 
 	ptlrpc_req_finished(req);
 }
@@ -102,7 +103,7 @@ void reply_in_callback(lnet_event_t *ev)
 	req->rq_receiving_reply = 0;
 	req->rq_early = 0;
 	if (ev->unlinked)
-		req->rq_must_unlink = 0;
+		req->rq_reply_unlink = 0;
 
 	if (ev->status)
 		goto out_wake;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index f760504..3f0ca23 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -580,8 +580,9 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 	spin_lock(&request->rq_lock);
 	/* If the MD attach succeeds, there _will_ be a reply_in callback */
 	request->rq_receiving_reply = !noreply;
+	request->rq_req_unlink = 1;
 	/* We are responsible for unlinking the reply buffer */
-	request->rq_must_unlink = !noreply;
+	request->rq_reply_unlink = !noreply;
 	/* Clear any flags that may be present from previous sends. */
 	request->rq_replied = 0;
 	request->rq_err = 0;
@@ -604,7 +605,7 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 		reply_md.user_ptr  = &request->rq_reply_cbid;
 		reply_md.eq_handle = ptlrpc_eq_h;
 
-		/* We must see the unlink callback to unset rq_must_unlink,
+		/* We must see the unlink callback to unset rq_reply_unlink,
 		   so we can't auto-unlink */
 		rc = LNetMDAttach(reply_me_h, reply_md, LNET_RETAIN,
 				  &request->rq_reply_md_h);
-- 
1.9.0

