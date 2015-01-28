Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbbA2Czs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:55:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47028 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965467AbbA2CiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 120/139] iser-target: Fix flush + disconnect completion handling
Date: Wed, 28 Jan 2015 14:21:03 -0800
Message-Id: <1422483682-15393-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 128e9cc84566a84146baea2335b3824288eed817 upstream.

ISER_CONN_UP state is not sufficient to know if
we should wait for completion of flush errors and
disconnected_handler event.

Instead, split it to 2 states:
- ISER_CONN_UP: Got to CM connected phase, This state
indicates that we need to wait for a CM disconnect
event before going to teardown.

- ISER_CONN_FULL_FEATURE: Got to full feature phase
after we posted login response, This state indicates
that we posted recv buffers and we need to wait for
flush completions before going to teardown.

Also avoid deffering disconnected handler to a work,
and handle it within disconnected handler.
More work here is needed to handle DEVICE_REMOVAL event
correctly (cleanup all resources).

Squashed:

iser-target: Don't deffer disconnected handler to a work

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 52 +++++++++++++++++++--------------
 drivers/infiniband/ulp/isert/ib_isert.h |  2 +-
 2 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4dbf5e0..989f773 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -650,6 +650,9 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->context;
 
+	pr_info("conn %p\n", isert_conn);
+
+	isert_conn->state = ISER_CONN_UP;
 	kref_get(&isert_conn->conn_kref);
 }
 
@@ -676,8 +679,9 @@ isert_put_conn(struct isert_conn *isert_conn)
  * @isert_conn: isert connection struct
  *
  * Notes:
- * In case the connection state is UP, move state
+ * In case the connection state is FULL_FEATURE, move state
  * to TEMINATING and start teardown sequence (rdma_disconnect).
+ * In case the connection state is UP, complete flush as well.
  *
  * This routine must be called with conn_mutex held. Thus it is
  * safe to call multiple times.
@@ -687,32 +691,31 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 {
 	int err;
 
-	if (isert_conn->state == ISER_CONN_UP) {
-		isert_conn->state = ISER_CONN_TERMINATING;
+	switch (isert_conn->state) {
+	case ISER_CONN_TERMINATING:
+		break;
+	case ISER_CONN_UP:
+		/*
+		 * No flush completions will occur as we didn't
+		 * get to ISER_CONN_FULL_FEATURE yet, complete
+		 * to allow teardown progress.
+		 */
+		complete(&isert_conn->conn_wait_comp_err);
+	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
 		pr_info("Terminating conn %p state %d\n",
 			   isert_conn, isert_conn->state);
+		isert_conn->state = ISER_CONN_TERMINATING;
 		err = rdma_disconnect(isert_conn->conn_cm_id);
 		if (err)
 			pr_warn("Failed rdma_disconnect isert_conn %p\n",
 				   isert_conn);
+		break;
+	default:
+		pr_warn("conn %p teminating in state %d\n",
+			   isert_conn, isert_conn->state);
 	}
 }
 
-static void
-isert_disconnect_work(struct work_struct *work)
-{
-	struct isert_conn *isert_conn = container_of(work,
-				struct isert_conn, conn_logout_work);
-
-	pr_debug("isert_disconnect_work(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
-	mutex_lock(&isert_conn->conn_mutex);
-	isert_conn_terminate(isert_conn);
-	mutex_unlock(&isert_conn->conn_mutex);
-
-	pr_info("conn %p completing conn_wait\n", isert_conn);
-	complete(&isert_conn->conn_wait);
-}
-
 static int
 isert_disconnected_handler(struct rdma_cm_id *cma_id)
 {
@@ -727,8 +730,12 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id)
 
 	isert_conn = (struct isert_conn *)cma_id->context;
 
-	INIT_WORK(&isert_conn->conn_logout_work, isert_disconnect_work);
-	schedule_work(&isert_conn->conn_logout_work);
+	mutex_lock(&isert_conn->conn_mutex);
+	isert_conn_terminate(isert_conn);
+	mutex_unlock(&isert_conn->conn_mutex);
+
+	pr_info("conn %p completing conn_wait\n", isert_conn);
+	complete(&isert_conn->conn_wait);
 
 	return 0;
 }
@@ -903,7 +910,7 @@ isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 	 * bit for every ISERT_COMP_BATCH_COUNT number of ib_post_send() calls.
 	 */
 	mutex_lock(&isert_conn->conn_mutex);
-	if (coalesce && isert_conn->state == ISER_CONN_UP &&
+	if (coalesce && isert_conn->state == ISER_CONN_FULL_FEATURE &&
 	    ++isert_conn->conn_comp_batch < ISERT_COMP_BATCH_COUNT) {
 		tx_desc->llnode_active = true;
 		llist_add(&tx_desc->comp_llnode, &isert_conn->conn_comp_llist);
@@ -990,7 +997,8 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 			if (ret)
 				return ret;
 
-			isert_conn->state = ISER_CONN_UP;
+			/* Now we are in FULL_FEATURE phase */
+			isert_conn->state = ISER_CONN_FULL_FEATURE;
 			goto post_send;
 		}
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index abbc331..cf87cc3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -23,6 +23,7 @@ enum iser_ib_op_code {
 enum iser_conn_state {
 	ISER_CONN_INIT,
 	ISER_CONN_UP,
+	ISER_CONN_FULL_FEATURE,
 	ISER_CONN_TERMINATING,
 	ISER_CONN_DOWN,
 };
@@ -115,7 +116,6 @@ struct isert_conn {
 	struct ib_mr		*conn_mr;
 	struct ib_qp		*conn_qp;
 	struct isert_device	*conn_device;
-	struct work_struct	conn_logout_work;
 	struct mutex		conn_mutex;
 	struct completion	conn_wait;
 	struct completion	conn_wait_comp_err;
-- 
1.9.1

