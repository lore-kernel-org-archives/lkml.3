Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaCACRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:32 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42625 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaCACR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:29 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Sebastien Buisson <sebastien.buisson@bull.net>,
        Oeg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 13/17] lustre/ptlrpc: fix 'data race condition' issues
Date: Fri, 28 Feb 2014 21:16:42 -0500
Message-Id: <1393640206-20286-14-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'data race condition' defects found by Coverity version
6.5.0:
Data race condition (MISSING_LOCK)
Accessing variable without holding lock. Elsewhere,
this variable is accessed with lock held.

Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-on: http://review.whamcloud.com/6575
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2744
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oeg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 6 ++++++
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 98041e8..7b97c64 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -1190,7 +1190,9 @@ static int after_reply(struct ptlrpc_request *req)
 		 * will roundup it */
 		req->rq_replen       = req->rq_nob_received;
 		req->rq_nob_received = 0;
+		spin_lock(&req->rq_lock);
 		req->rq_resend       = 1;
+		spin_unlock(&req->rq_lock);
 		return 0;
 	}
 
@@ -1412,7 +1414,9 @@ static int ptlrpc_send_new_req(struct ptlrpc_request *req)
 			req->rq_status = rc;
 			return 1;
 		} else {
+			spin_lock(&req->rq_lock);
 			req->rq_wait_ctx = 1;
+			spin_unlock(&req->rq_lock);
 			return 0;
 		}
 	}
@@ -1427,7 +1431,9 @@ static int ptlrpc_send_new_req(struct ptlrpc_request *req)
 	rc = ptl_send_rpc(req, 0);
 	if (rc) {
 		DEBUG_REQ(D_HA, req, "send failed (%d); expect timeout", rc);
+		spin_lock(&req->rq_lock);
 		req->rq_net_err = 1;
+		spin_unlock(&req->rq_lock);
 		return rc;
 	}
 	return 0;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index 1e94597..a47a8d8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -511,7 +511,9 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 		CDEBUG(D_HA, "muting rpc for failed imp obd %s\n",
 		       request->rq_import->imp_obd->obd_name);
 		/* this prevents us from waiting in ptlrpc_queue_wait */
+		spin_lock(&request->rq_lock);
 		request->rq_err = 1;
+		spin_unlock(&request->rq_lock);
 		request->rq_status = -ENODEV;
 		return -ENODEV;
 	}
@@ -553,7 +555,9 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 			if (rc) {
 				/* this prevents us from looping in
 				 * ptlrpc_queue_wait */
+				spin_lock(&request->rq_lock);
 				request->rq_err = 1;
+				spin_unlock(&request->rq_lock);
 				request->rq_status = rc;
 				GOTO(cleanup_bulk, rc);
 			}
-- 
1.8.5.3

