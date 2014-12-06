Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaLFPUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:22 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47716 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752137AbaLFPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@dev.mellanox.co.il>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 52/66] iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly
Date: Sat,  6 Dec 2014 16:07:44 +0100
Message-Id: <0a915349e2da9a0d2a9467934234c97ce855f733.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@dev.mellanox.co.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3b726ae2de02a406cc91903f80132daee37b6f1b upstream.

In this case the cm_id->context is the isert_np, and the cm_id->qp
is NULL, so use that to distinct the cases.

Since we don't expect any other events on this cm_id we can
just return -1 for explicit termination of the cm_id by the
cma layer.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 2c14232447e4..7fb89a46d864 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -708,14 +708,25 @@ wake_up:
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
@@ -730,6 +741,9 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		ret = isert_connect_request(cma_id, event);
+		if (ret)
+			pr_err("isert_cma_handler failed RDMA_CM_EVENT: 0x%08x %d\n",
+				event->event, ret);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		isert_connected_handler(cma_id);
@@ -739,7 +753,7 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
 		disconnect = true;
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-		isert_disconnected_handler(cma_id, disconnect);
+		ret = isert_disconnected_handler(cma_id, disconnect);
 		break;
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	default:
@@ -747,12 +761,6 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
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
 
@@ -2683,7 +2691,8 @@ isert_free_np(struct iscsi_np *np)
 {
 	struct isert_np *isert_np = (struct isert_np *)np->np_context;
 
-	rdma_destroy_id(isert_np->np_cm_id);
+	if (isert_np->np_cm_id)
+		rdma_destroy_id(isert_np->np_cm_id);
 
 	np->np_context = NULL;
 	kfree(isert_np);
-- 
2.1.3

