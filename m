Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaFWBcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:47 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39737 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaFWBcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 05/18] staging/lustre/ptlrpc: fix NULL pointer dereference of {exp,imp}_obd
Date: Sun, 22 Jun 2014 21:32:09 -0400
Message-Id: <1403487142-4880-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Pointer 'obd' checked for NULL at line 694 may be dereferenced at
line 813.

Pointer 'req->rq_export->exp_obd' checked for NULL at line 1155
may be dereferenced at line 1164. Also there is one similar error
on line 1170.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/10062
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c  |  7 +++----
 drivers/staging/lustre/lustre/ptlrpc/service.c | 10 +++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index a47a8d8..ef18639 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -506,10 +506,9 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 	 * cleanly from the previous attempt */
 	LASSERT(!request->rq_receiving_reply);
 
-	if (request->rq_import->imp_obd &&
-	    request->rq_import->imp_obd->obd_fail) {
+	if (unlikely(obd != NULL && obd->obd_fail)) {
 		CDEBUG(D_HA, "muting rpc for failed imp obd %s\n",
-		       request->rq_import->imp_obd->obd_name);
+			obd->obd_name);
 		/* this prevents us from waiting in ptlrpc_queue_wait */
 		spin_lock(&request->rq_lock);
 		request->rq_err = 1;
@@ -625,7 +624,7 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 
 	/* add references on request for request_out_callback */
 	ptlrpc_request_addref(request);
-	if (obd->obd_svc_stats != NULL)
+	if (obd != NULL && obd->obd_svc_stats != NULL)
 		lprocfs_counter_add(obd->obd_svc_stats, PTLRPC_REQACTIVE_CNTR,
 			atomic_read(&request->rq_import->imp_inflight));
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index d278f2e..214daa2 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -1100,6 +1100,7 @@ static void ptlrpc_update_export_timer(struct obd_export *exp, long extra_delay)
  */
 static int ptlrpc_check_req(struct ptlrpc_request *req)
 {
+	struct obd_device *obd = req->rq_export->exp_obd;
 	int rc = 0;
 
 	if (unlikely(lustre_msg_get_conn_cnt(req->rq_reqmsg) <
@@ -1110,24 +1111,23 @@ static int ptlrpc_check_req(struct ptlrpc_request *req)
 			  req->rq_export->exp_conn_cnt);
 		return -EEXIST;
 	}
-	if (unlikely(req->rq_export->exp_obd &&
-		     req->rq_export->exp_obd->obd_fail)) {
+	if (unlikely(obd == NULL || obd->obd_fail)) {
 		/*
 		 * Failing over, don't handle any more reqs, send
 		 * error response instead.
 		 */
 		CDEBUG(D_RPCTRACE, "Dropping req %p for failed obd %s\n",
-		       req, req->rq_export->exp_obd->obd_name);
+		       req, (obd != NULL) ? obd->obd_name : "unknown");
 		rc = -ENODEV;
 	} else if (lustre_msg_get_flags(req->rq_reqmsg) &
 		   (MSG_REPLAY | MSG_REQ_REPLAY_DONE) &&
-		   !(req->rq_export->exp_obd->obd_recovering)) {
+		   !obd->obd_recovering) {
 			DEBUG_REQ(D_ERROR, req,
 				  "Invalid replay without recovery");
 			class_fail_export(req->rq_export);
 			rc = -ENODEV;
 	} else if (lustre_msg_get_transno(req->rq_reqmsg) != 0 &&
-		   !(req->rq_export->exp_obd->obd_recovering)) {
+		   !obd->obd_recovering) {
 			DEBUG_REQ(D_ERROR, req, "Invalid req with transno "
 				  LPU64" without recovery",
 				  lustre_msg_get_transno(req->rq_reqmsg));
-- 
1.9.0

