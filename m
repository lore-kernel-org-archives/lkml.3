Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaLEWxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:53:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaLEWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.17 085/122] iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly
Date: Fri,  5 Dec 2014 14:44:19 -0800
Message-Id: <20141205223318.600317256@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -810,14 +810,25 @@ wake_up:
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
@@ -832,6 +843,9 @@ isert_cma_handler(struct rdma_cm_id *cma
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		ret = isert_connect_request(cma_id, event);
+		if (ret)
+			pr_err("isert_cma_handler failed RDMA_CM_EVENT: 0x%08x %d\n",
+				event->event, ret);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		isert_connected_handler(cma_id);
@@ -841,7 +855,7 @@ isert_cma_handler(struct rdma_cm_id *cma
 	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
 		disconnect = true;
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-		isert_disconnected_handler(cma_id, disconnect);
+		ret = isert_disconnected_handler(cma_id, disconnect);
 		break;
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	default:
@@ -849,12 +863,6 @@ isert_cma_handler(struct rdma_cm_id *cma
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
 
@@ -3210,7 +3218,8 @@ isert_free_np(struct iscsi_np *np)
 {
 	struct isert_np *isert_np = (struct isert_np *)np->np_context;
 
-	rdma_destroy_id(isert_np->np_cm_id);
+	if (isert_np->np_cm_id)
+		rdma_destroy_id(isert_np->np_cm_id);
 
 	np->np_context = NULL;
 	kfree(isert_np);


