Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaLOPRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:17:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaLOO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 018/168] iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly
Date: Mon, 15 Dec 2014 14:24:32 +0000
Message-Id: <1418653622-21105-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@dev.mellanox.co.il>

commit 3b726ae2de02a406cc91903f80132daee37b6f1b upstream.

In this case the cm_id->context is the isert_np, and the cm_id->qp
is NULL, so use that to distinct the cases.

Since we don't expect any other events on this cm_id we can
just return -1 for explicit termination of the cm_id by the
cma layer.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 33556f980b45..1e2c7ad50992 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -804,14 +804,25 @@ wake_up:
 	complete(&isert_conn->conn_wait);
 }
 
-static void
+static int
 isert_disconnected_handler(struct rdma_cm_id *cma_id, bool disconnect)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
+	struct isert_conn *isert_conn;
+
+	if (!cma_id->qp) {
+		struct isert_np *isert_np = cma_id->context;
+
+		isert_np->np_cm_id = NULL;
+		return -1;
+	}
+
+	isert_conn = (struct isert_conn *)cma_id->context;
 
 	isert_conn->disconnect = disconnect;
 	INIT_WORK(&isert_conn->conn_logout_work, isert_disconnect_work);
 	schedule_work(&isert_conn->conn_logout_work);
+
+	return 0;
 }
 
 static int
@@ -826,6 +837,9 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		ret = isert_connect_request(cma_id, event);
+		if (ret)
+			pr_err("isert_cma_handler failed RDMA_CM_EVENT: 0x%08x %d\n",
+				event->event, ret);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		isert_connected_handler(cma_id);
@@ -835,7 +849,7 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
 		disconnect = true;
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-		isert_disconnected_handler(cma_id, disconnect);
+		ret = isert_disconnected_handler(cma_id, disconnect);
 		break;
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	default:
@@ -843,12 +857,6 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		break;
 	}
 
-	if (ret != 0) {
-		pr_err("isert_cma_handler failed RDMA_CM_EVENT: 0x%08x %d\n",
-		       event->event, ret);
-		dump_stack();
-	}
-
 	return ret;
 }
 
@@ -3205,7 +3213,8 @@ isert_free_np(struct iscsi_np *np)
 {
 	struct isert_np *isert_np = (struct isert_np *)np->np_context;
 
-	rdma_destroy_id(isert_np->np_cm_id);
+	if (isert_np->np_cm_id)
+		rdma_destroy_id(isert_np->np_cm_id);
 
 	np->np_context = NULL;
 	kfree(isert_np);
-- 
2.1.3

