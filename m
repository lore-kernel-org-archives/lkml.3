Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaDALib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:38:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaDALSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/144] iscsi/iser-target: Fix isert_conn->state hung shutdown issues
Date: Tue,  1 Apr 2014 12:15:11 +0100
Message-Id: <1396350948-29910-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit defd884845297fd5690594bfe89656b01f16d87e upstream.

This patch addresses a couple of different hug shutdown issues
related to wait_event() + isert_conn->state.  First, it changes
isert_conn->conn_wait + isert_conn->conn_wait_comp_err from
waitqueues to completions, and sets ISER_CONN_TERMINATING from
within isert_disconnect_work().

Second, it splits isert_free_conn() into isert_wait_conn() that
is called earlier in iscsit_close_connection() to ensure that
all outstanding commands have completed before continuing.

Finally, it breaks isert_cq_comp_err() into seperate TX / RX
related code, and adds logic in isert_cq_rx_comp_err() to wait
for outstanding commands to complete before setting ISER_CONN_DOWN
and calling complete(&isert_conn->conn_wait_comp_err).

Acked-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.11: used Nicholas's backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 105 ++++++++++++++------------------
 drivers/infiniband/ulp/isert/ib_isert.h |   4 +-
 drivers/target/iscsi/iscsi_target.c     |   4 ++
 include/target/iscsi/iscsi_transport.h  |   1 +
 4 files changed, 54 insertions(+), 60 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 58968e7..57a01df 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -392,8 +392,8 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_conn->state = ISER_CONN_INIT;
 	INIT_LIST_HEAD(&isert_conn->conn_accept_node);
 	init_completion(&isert_conn->conn_login_comp);
-	init_waitqueue_head(&isert_conn->conn_wait);
-	init_waitqueue_head(&isert_conn->conn_wait_comp_err);
+	init_completion(&isert_conn->conn_wait);
+	init_completion(&isert_conn->conn_wait_comp_err);
 	kref_init(&isert_conn->conn_kref);
 	kref_get(&isert_conn->conn_kref);
 	mutex_init(&isert_conn->conn_mutex);
@@ -550,11 +550,11 @@ isert_disconnect_work(struct work_struct *work)
 
 	pr_debug("isert_disconnect_work(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
 	mutex_lock(&isert_conn->conn_mutex);
-	isert_conn->state = ISER_CONN_DOWN;
+	if (isert_conn->state == ISER_CONN_UP)
+		isert_conn->state = ISER_CONN_TERMINATING;
 
 	if (isert_conn->post_recv_buf_count == 0 &&
 	    atomic_read(&isert_conn->post_send_buf_count) == 0) {
-		pr_debug("Calling wake_up(&isert_conn->conn_wait);\n");
 		mutex_unlock(&isert_conn->conn_mutex);
 		goto wake_up;
 	}
@@ -574,7 +574,7 @@ isert_disconnect_work(struct work_struct *work)
 	mutex_unlock(&isert_conn->conn_mutex);
 
 wake_up:
-	wake_up(&isert_conn->conn_wait);
+	complete(&isert_conn->conn_wait);
 	isert_put_conn(isert_conn);
 }
 
@@ -1414,7 +1414,7 @@ isert_do_control_comp(struct work_struct *work)
 		pr_debug("Calling iscsit_logout_post_handler >>>>>>>>>>>>>>\n");
 		/*
 		 * Call atomic_dec(&isert_conn->post_send_buf_count)
-		 * from isert_free_conn()
+		 * from isert_wait_conn()
 		 */
 		isert_conn->logout_posted = true;
 		iscsit_logout_post_handler(cmd, cmd->conn);
@@ -1498,31 +1498,38 @@ isert_send_completion(struct iser_tx_desc *tx_desc,
 }
 
 static void
-isert_cq_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn)
+isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
 
-	if (tx_desc) {
-		struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
+	if (!isert_cmd)
+		isert_unmap_tx_desc(tx_desc, ib_dev);
+	else
+		isert_completion_put(tx_desc, isert_cmd, ib_dev);
+}
 
-		if (!isert_cmd)
-			isert_unmap_tx_desc(tx_desc, ib_dev);
-		else
-			isert_completion_put(tx_desc, isert_cmd, ib_dev);
+static void
+isert_cq_rx_comp_err(struct isert_conn *isert_conn)
+{
+	struct iscsi_conn *conn = isert_conn->conn;
+
+	if (isert_conn->post_recv_buf_count)
+		return;
+
+	if (conn->sess) {
+		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
+		target_wait_for_sess_cmds(conn->sess->se_sess);
 	}
 
-	if (isert_conn->post_recv_buf_count == 0 &&
-	    atomic_read(&isert_conn->post_send_buf_count) == 0) {
-		pr_debug("isert_cq_comp_err >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
-		pr_debug("Calling wake_up from isert_cq_comp_err\n");
+	while (atomic_read(&isert_conn->post_send_buf_count))
+		msleep(3000);
 
-		mutex_lock(&isert_conn->conn_mutex);
-		if (isert_conn->state != ISER_CONN_DOWN)
-			isert_conn->state = ISER_CONN_TERMINATING;
-		mutex_unlock(&isert_conn->conn_mutex);
+	mutex_lock(&isert_conn->conn_mutex);
+	isert_conn->state = ISER_CONN_DOWN;
+	mutex_unlock(&isert_conn->conn_mutex);
 
-		wake_up(&isert_conn->conn_wait_comp_err);
-	}
+	complete(&isert_conn->conn_wait_comp_err);
 }
 
 static void
@@ -1547,8 +1554,9 @@ isert_cq_tx_work(struct work_struct *work)
 			pr_debug("TX wc.status != IB_WC_SUCCESS >>>>>>>>>>>>>>\n");
 			pr_debug("TX wc.status: 0x%08x\n", wc.status);
 			pr_debug("TX wc.vendor_err: 0x%08x\n", wc.vendor_err);
+
 			atomic_dec(&isert_conn->post_send_buf_count);
-			isert_cq_comp_err(tx_desc, isert_conn);
+			isert_cq_tx_comp_err(tx_desc, isert_conn);
 		}
 	}
 
@@ -1592,7 +1600,7 @@ isert_cq_rx_work(struct work_struct *work)
 					 wc.vendor_err);
 			}
 			isert_conn->post_recv_buf_count--;
-			isert_cq_comp_err(NULL, isert_conn);
+			isert_cq_rx_comp_err(isert_conn);
 		}
 	}
 
@@ -2337,22 +2345,11 @@ isert_free_np(struct iscsi_np *np)
 	kfree(isert_np);
 }
 
-static int isert_check_state(struct isert_conn *isert_conn, int state)
-{
-	int ret;
-
-	mutex_lock(&isert_conn->conn_mutex);
-	ret = (isert_conn->state == state);
-	mutex_unlock(&isert_conn->conn_mutex);
-
-	return ret;
-}
-
-static void isert_free_conn(struct iscsi_conn *conn)
+static void isert_wait_conn(struct iscsi_conn *conn)
 {
 	struct isert_conn *isert_conn = conn->context;
 
-	pr_debug("isert_free_conn: Starting \n");
+	pr_debug("isert_wait_conn: Starting \n");
 	/*
 	 * Decrement post_send_buf_count for special case when called
 	 * from isert_do_control_comp() -> iscsit_logout_post_handler()
@@ -2362,38 +2359,29 @@ static void isert_free_conn(struct iscsi_conn *conn)
 		atomic_dec(&isert_conn->post_send_buf_count);
 
 	if (isert_conn->conn_cm_id && isert_conn->state != ISER_CONN_DOWN) {
-		pr_debug("Calling rdma_disconnect from isert_free_conn\n");
+		pr_debug("Calling rdma_disconnect from isert_wait_conn\n");
 		rdma_disconnect(isert_conn->conn_cm_id);
 	}
 	/*
 	 * Only wait for conn_wait_comp_err if the isert_conn made it
 	 * into full feature phase..
 	 */
-	if (isert_conn->state == ISER_CONN_UP) {
-		pr_debug("isert_free_conn: Before wait_event comp_err %d\n",
-			 isert_conn->state);
-		mutex_unlock(&isert_conn->conn_mutex);
-
-		wait_event(isert_conn->conn_wait_comp_err,
-			  (isert_check_state(isert_conn, ISER_CONN_TERMINATING)));
-
-		wait_event(isert_conn->conn_wait,
-			  (isert_check_state(isert_conn, ISER_CONN_DOWN)));
-
-		isert_put_conn(isert_conn);
-		return;
-	}
 	if (isert_conn->state == ISER_CONN_INIT) {
 		mutex_unlock(&isert_conn->conn_mutex);
-		isert_put_conn(isert_conn);
 		return;
 	}
-	pr_debug("isert_free_conn: wait_event conn_wait %d\n",
-		 isert_conn->state);
+	if (isert_conn->state == ISER_CONN_UP)
+		isert_conn->state = ISER_CONN_TERMINATING;
 	mutex_unlock(&isert_conn->conn_mutex);
 
-	wait_event(isert_conn->conn_wait,
-		  (isert_check_state(isert_conn, ISER_CONN_DOWN)));
+	wait_for_completion(&isert_conn->conn_wait_comp_err);
+
+	wait_for_completion(&isert_conn->conn_wait);
+}
+
+static void isert_free_conn(struct iscsi_conn *conn)
+{
+	struct isert_conn *isert_conn = conn->context;
 
 	isert_put_conn(isert_conn);
 }
@@ -2405,6 +2393,7 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_setup_np	= isert_setup_np,
 	.iscsit_accept_np	= isert_accept_np,
 	.iscsit_free_np		= isert_free_np,
+	.iscsit_wait_conn	= isert_wait_conn,
 	.iscsit_free_conn	= isert_free_conn,
 	.iscsit_alloc_cmd	= isert_alloc_cmd,
 	.iscsit_get_login_rx	= isert_get_login_rx,
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 191117b..eaf7682 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -103,8 +103,8 @@ struct isert_conn {
 	struct isert_device	*conn_device;
 	struct work_struct	conn_logout_work;
 	struct mutex		conn_mutex;
-	wait_queue_head_t	conn_wait;
-	wait_queue_head_t	conn_wait_comp_err;
+	struct completion	conn_wait;
+	struct completion	conn_wait_comp_err;
 	struct kref		conn_kref;
 };
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 832e08f..17229ff 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4208,6 +4208,10 @@ int iscsit_close_connection(
 	iscsit_stop_timers_for_cmds(conn);
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	iscsit_free_queue_reqs_for_conn(conn);
 
 	/*
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index e5d09d2..4bde613 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -11,6 +11,7 @@ struct iscsit_transport {
 	int (*iscsit_setup_np)(struct iscsi_np *, struct __kernel_sockaddr_storage *);
 	int (*iscsit_accept_np)(struct iscsi_np *, struct iscsi_conn *);
 	void (*iscsit_free_np)(struct iscsi_np *);
+	void (*iscsit_wait_conn)(struct iscsi_conn *);
 	void (*iscsit_free_conn)(struct iscsi_conn *);
 	struct iscsi_cmd *(*iscsit_alloc_cmd)(struct iscsi_conn *, gfp_t);
 	int (*iscsit_get_login_rx)(struct iscsi_conn *, struct iscsi_login *);
-- 
1.9.1

