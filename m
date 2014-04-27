Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaD0RYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:24:32 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47964 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaD0RHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:42 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Patrick Farrell <paf@cray.com>, Li Xi <lixi@ddn.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 01/47] staging/lustre/ptlrpc: Fix assertion failure of null_alloc_rs()
Date: Sun, 27 Apr 2014 13:06:25 -0400
Message-Id: <1398618431-29757-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Farrell <paf@cray.com>

lustre_get_emerg_rs() set the size of the reply buffer to zero
by mistake, which will cause LBUG in null_alloc_rs() when memory
pressure is high. This patch fix this problem and adds a size
check to avoid the problem of insufficient buffer size.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Patrick Farrell <paf@cray.com>
Reviewed-on: http://review.whamcloud.com/8200
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3680
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/pack_generic.c |  1 +
 drivers/staging/lustre/lustre/ptlrpc/sec.c          | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 45c0b84..cddeeb6 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -300,6 +300,7 @@ lustre_get_emerg_rs(struct ptlrpc_service_part *svcpt)
 	spin_unlock(&svcpt->scp_rep_lock);
 
 	memset(rs, 0, svcpt->scp_service->srv_max_reply_size);
+	rs->rs_size = svcpt->scp_service->srv_max_reply_size;
 	rs->rs_svcpt = svcpt;
 	rs->rs_prealloc = 1;
 out:
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index b0a1c5a..5e75392 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -2086,8 +2086,18 @@ int sptlrpc_svc_alloc_rs(struct ptlrpc_request *req, int msglen)
 
 	rc = policy->sp_sops->alloc_rs(req, msglen);
 	if (unlikely(rc == -ENOMEM)) {
+		struct ptlrpc_service_part *svcpt = req->rq_rqbd->rqbd_svcpt;
+		if (svcpt->scp_service->srv_max_reply_size <
+		   msglen + sizeof(struct ptlrpc_reply_state)) {
+			/* Just return failure if the size is too big */
+			CERROR("size of message is too big (%zd), %d allowed",
+				msglen + sizeof(struct ptlrpc_reply_state),
+				svcpt->scp_service->srv_max_reply_size);
+			return -ENOMEM;
+		}
+
 		/* failed alloc, try emergency pool */
-		rs = lustre_get_emerg_rs(req->rq_rqbd->rqbd_svcpt);
+		rs = lustre_get_emerg_rs(svcpt);
 		if (rs == NULL)
 			return -ENOMEM;
 
-- 
1.8.5.3

