Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaFWBgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:36:38 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39745 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaFWBcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:47 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "Alexander.Boyko" <alexander_boyko@xyratex.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 08/18] staging/lustre/ptlrpc: race at req processing
Date: Sun, 22 Jun 2014 21:32:12 -0400
Message-Id: <1403487142-4880-9-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander.Boyko" <alexander_boyko@xyratex.com>

Race between ptlrpc_resend_req() and ptlrpc_check_set().
1 thread do ptlrpc_check_set()->after_reply()
2 thread do ptlrpc_resend_req()
The result is request with rq_resend = 1 and MSG_REPLY flag.
When this request will came to server it will cause client eviction.
The patch skip ptlrpc_resend_req logic if rq_replied is set,
and clear rq_resend flag at reply_in_callback() when client got
reply.

Signed-off-by: Alexander Boyko <alexander_boyko@xyratex.com>
Xyratex-bug-id: MRP-1888
Reviewed-on: http://review.whamcloud.com/10471
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5116
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Chris Horn <hornc@cray.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 11 ++++++++++-
 drivers/staging/lustre/lustre/ptlrpc/events.c |  2 ++
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c |  2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 7246e8c..d806257 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -2530,10 +2530,19 @@ EXPORT_SYMBOL(ptlrpc_cleanup_client);
 void ptlrpc_resend_req(struct ptlrpc_request *req)
 {
 	DEBUG_REQ(D_HA, req, "going to resend");
+	spin_lock(&req->rq_lock);
+
+	/* Request got reply but linked to the import list still.
+	   Let ptlrpc_check_set() to process it. */
+	if (ptlrpc_client_replied(req)) {
+		spin_unlock(&req->rq_lock);
+		DEBUG_REQ(D_HA, req, "it has reply, so skip it");
+		return;
+	}
+
 	lustre_msg_set_handle(req->rq_reqmsg, &(struct lustre_handle){ 0 });
 	req->rq_status = -EAGAIN;
 
-	spin_lock(&req->rq_lock);
 	req->rq_resend = 1;
 	req->rq_net_err = 0;
 	req->rq_timedout = 0;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index aa85239..9f9b8d1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -145,6 +145,8 @@ void reply_in_callback(lnet_event_t *ev)
 		/* Real reply */
 		req->rq_rep_swab_mask = 0;
 		req->rq_replied = 1;
+		/* Got reply, no resend required */
+		req->rq_resend = 0;
 		req->rq_reply_off = ev->offset;
 		req->rq_nob_received = ev->mlength;
 		/* LNetMDUnlink can't be called under the LNET_LOCK,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index ef18639..f760504 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -505,6 +505,8 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 	/* If this is a re-transmit, we're required to have disengaged
 	 * cleanly from the previous attempt */
 	LASSERT(!request->rq_receiving_reply);
+	LASSERT(!((lustre_msg_get_flags(request->rq_reqmsg) & MSG_REPLAY) &&
+		(request->rq_import->imp_state == LUSTRE_IMP_FULL)));
 
 	if (unlikely(obd != NULL && obd->obd_fail)) {
 		CDEBUG(D_HA, "muting rpc for failed imp obd %s\n",
-- 
1.9.0

