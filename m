Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbbA2JAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:32 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755429AbbA2JAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 131/176] iscsi,iser-target: Initiate termination only once
Date: Wed, 28 Jan 2015 15:29:21 +0100
Message-Id: <2dad3ae89db344479d42ccdad4e2f165217300dc.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 954f23722b5753305be490330cf2680b7a25f4a3 upstream.

Since commit 0fc4ea701fcf ("Target/iser: Don't put isert_conn inside
disconnected handler") we put the conn kref in isert_wait_conn, so we
need .wait_conn to be invoked also in the error path.

Introduce call to isert_conn_terminate (called under lock)
which transitions the connection state to TERMINATING and calls
rdma_disconnect. If the state is already teminating, just bail
out back (temination started).

Also, make sure to destroy the connection when getting a connect
error event if didn't get to connected (state UP). Same for the
handling of REJECTED and UNREACHABLE cma events.

Squashed:

iscsi-target: Add call to wait_conn in establishment error flow

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c   | 84 +++++++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h   |  1 -
 drivers/target/iscsi/iscsi_target_login.c |  3 ++
 3 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 7fb89a46d864..c0a5b4a85424 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -675,6 +675,33 @@ isert_put_conn(struct isert_conn *isert_conn)
 	kref_put(&isert_conn->conn_kref, isert_release_conn_kref);
 }
 
+/**
+ * isert_conn_terminate() - Initiate connection termination
+ * @isert_conn: isert connection struct
+ *
+ * Notes:
+ * In case the connection state is UP, move state
+ * to TEMINATING and start teardown sequence (rdma_disconnect).
+ *
+ * This routine must be called with conn_mutex held. Thus it is
+ * safe to call multiple times.
+ */
+static void
+isert_conn_terminate(struct isert_conn *isert_conn)
+{
+	int err;
+
+	if (isert_conn->state == ISER_CONN_UP) {
+		isert_conn->state = ISER_CONN_TERMINATING;
+		pr_info("Terminating conn %p state %d\n",
+			   isert_conn, isert_conn->state);
+		err = rdma_disconnect(isert_conn->conn_cm_id);
+		if (err)
+			pr_warn("Failed rdma_disconnect isert_conn %p\n",
+				   isert_conn);
+	}
+}
+
 static void
 isert_disconnect_work(struct work_struct *work)
 {
@@ -683,33 +710,15 @@ isert_disconnect_work(struct work_struct *work)
 
 	pr_debug("isert_disconnect_work(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
 	mutex_lock(&isert_conn->conn_mutex);
-	if (isert_conn->state == ISER_CONN_UP)
-		isert_conn->state = ISER_CONN_TERMINATING;
-
-	if (isert_conn->post_recv_buf_count == 0 &&
-	    atomic_read(&isert_conn->post_send_buf_count) == 0) {
-		mutex_unlock(&isert_conn->conn_mutex);
-		goto wake_up;
-	}
-	if (!isert_conn->conn_cm_id) {
-		mutex_unlock(&isert_conn->conn_mutex);
-		isert_put_conn(isert_conn);
-		return;
-	}
-
-	if (isert_conn->disconnect) {
-		/* Send DREQ/DREP towards our initiator */
-		rdma_disconnect(isert_conn->conn_cm_id);
-	}
-
+	isert_conn_terminate(isert_conn);
 	mutex_unlock(&isert_conn->conn_mutex);
 
-wake_up:
+	pr_info("conn %p completing conn_wait\n", isert_conn);
 	complete(&isert_conn->conn_wait);
 }
 
 static int
-isert_disconnected_handler(struct rdma_cm_id *cma_id, bool disconnect)
+isert_disconnected_handler(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn;
 
@@ -722,18 +731,24 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id, bool disconnect)
 
 	isert_conn = (struct isert_conn *)cma_id->context;
 
-	isert_conn->disconnect = disconnect;
 	INIT_WORK(&isert_conn->conn_logout_work, isert_disconnect_work);
 	schedule_work(&isert_conn->conn_logout_work);
 
 	return 0;
 }
 
+static void
+isert_connect_error(struct rdma_cm_id *cma_id)
+{
+	struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
+
+	isert_put_conn(isert_conn);
+}
+
 static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	int ret = 0;
-	bool disconnect = false;
 
 	pr_debug("isert_cma_handler: event %d status %d conn %p id %p\n",
 		 event->event, event->status, cma_id->context, cma_id);
@@ -751,11 +766,14 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_ADDR_CHANGE:    /* FALLTHRU */
 	case RDMA_CM_EVENT_DISCONNECTED:   /* FALLTHRU */
 	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
-		disconnect = true;
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-		ret = isert_disconnected_handler(cma_id, disconnect);
+		ret = isert_disconnected_handler(cma_id);
 		break;
+	case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
+	case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
 	case RDMA_CM_EVENT_CONNECT_ERROR:
+		isert_connect_error(cma_id);
+		break;
 	default:
 		pr_err("Unhandled RDMA CMA event: %d\n", event->event);
 		break;
@@ -1706,7 +1724,7 @@ isert_cq_rx_comp_err(struct isert_conn *isert_conn)
 		msleep(3000);
 
 	mutex_lock(&isert_conn->conn_mutex);
-	isert_conn->state = ISER_CONN_DOWN;
+	isert_conn_terminate(isert_conn);
 	mutex_unlock(&isert_conn->conn_mutex);
 
 	iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
@@ -2705,10 +2723,6 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	pr_debug("isert_wait_conn: Starting \n");
 
 	mutex_lock(&isert_conn->conn_mutex);
-	if (isert_conn->conn_cm_id) {
-		pr_debug("Calling rdma_disconnect from isert_wait_conn\n");
-		rdma_disconnect(isert_conn->conn_cm_id);
-	}
 	/*
 	 * Only wait for conn_wait_comp_err if the isert_conn made it
 	 * into full feature phase..
@@ -2717,13 +2731,17 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 		mutex_unlock(&isert_conn->conn_mutex);
 		return;
 	}
-	if (isert_conn->state == ISER_CONN_UP)
-		isert_conn->state = ISER_CONN_TERMINATING;
+	isert_conn_terminate(isert_conn);
 	mutex_unlock(&isert_conn->conn_mutex);
 
 	wait_for_completion(&isert_conn->conn_wait_comp_err);
-
 	wait_for_completion(&isert_conn->conn_wait);
+
+	mutex_lock(&isert_conn->conn_mutex);
+	isert_conn->state = ISER_CONN_DOWN;
+	mutex_unlock(&isert_conn->conn_mutex);
+
+	pr_info("Destroying conn %p\n", isert_conn);
 	isert_put_conn(isert_conn);
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 90e6aa3c25d2..f0ed44c89b71 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -121,7 +121,6 @@ struct isert_conn {
 	int			conn_frwr_pool_size;
 	/* lock to protect frwr_pool */
 	spinlock_t		conn_lock;
-	bool                    disconnect;
 };
 
 #define ISERT_MAX_CQ 64
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 8d44bec42e95..0c15772c5035 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1188,6 +1188,9 @@ old_sess_out:
 		conn->sock = NULL;
 	}
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	if (conn->conn_transport->iscsit_free_conn)
 		conn->conn_transport->iscsit_free_conn(conn);
 
-- 
2.2.2

