Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaF1TG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:06:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaF1Rs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 51/77] Target/iser: Fix hangs in connection teardown
Date: Sat, 28 Jun 2014 10:46:44 -0700
Message-Id: <20140628174524.196011072@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 9d49f5e284e700576f3b65f1e28dea8539da6661 upstream.

In ungraceful teardowns isert close flows seem racy such that
isert_wait_conn hangs as RDMA_CM_EVENT_DISCONNECTED never
gets invoked (no one called rdma_disconnect).

Both graceful and ungraceful teardowns will have rx flush errors
(isert posts a batch once connection is established). Once all
flush errors are consumed we invoke isert_wait_conn and it will
be responsible for calling rdma_disconnect. This way it can be
sure that rdma_disconnect was called and it won't wait forever.

This patch also removes the logout_posted indicator. either the
logout completion was consumed and no problem decrementing the
post_send_buf_count, or it was consumed as a flush error. no point
of keeping it for isert_wait_conn as there is no danger that
isert_conn will be accidentally removed while it is running.

(Drop unnecessary sleep_on_conn_wait_comp check in
 isert_cq_rx_comp_err - nab)

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   31 ++++++++++---------------------
 drivers/infiniband/ulp/isert/ib_isert.h |    1 -
 2 files changed, 10 insertions(+), 22 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -572,14 +572,10 @@ isert_disconnect_work(struct work_struct
 		isert_put_conn(isert_conn);
 		return;
 	}
-	if (!isert_conn->logout_posted) {
-		pr_debug("Calling rdma_disconnect for !logout_posted from"
-			 " isert_disconnect_work\n");
-		rdma_disconnect(isert_conn->conn_cm_id);
-		mutex_unlock(&isert_conn->conn_mutex);
-		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
-		goto wake_up;
-	}
+
+	/* Send DREQ/DREP towards our initiator */
+	rdma_disconnect(isert_conn->conn_cm_id);
+
 	mutex_unlock(&isert_conn->conn_mutex);
 
 wake_up:
@@ -1371,11 +1367,8 @@ isert_do_control_comp(struct work_struct
 		break;
 	case ISTATE_SEND_LOGOUTRSP:
 		pr_debug("Calling iscsit_logout_post_handler >>>>>>>>>>>>>>\n");
-		/*
-		 * Call atomic_dec(&isert_conn->post_send_buf_count)
-		 * from isert_wait_conn()
-		 */
-		isert_conn->logout_posted = true;
+
+		atomic_dec(&isert_conn->post_send_buf_count);
 		iscsit_logout_post_handler(cmd, cmd->conn);
 		break;
 	default:
@@ -1483,6 +1476,8 @@ isert_cq_rx_comp_err(struct isert_conn *
 	isert_conn->state = ISER_CONN_DOWN;
 	mutex_unlock(&isert_conn->conn_mutex);
 
+	iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+
 	complete(&isert_conn->conn_wait_comp_err);
 }
 
@@ -2247,15 +2242,9 @@ static void isert_wait_conn(struct iscsi
 	struct isert_conn *isert_conn = conn->context;
 
 	pr_debug("isert_wait_conn: Starting \n");
-	/*
-	 * Decrement post_send_buf_count for special case when called
-	 * from isert_do_control_comp() -> iscsit_logout_post_handler()
-	 */
-	mutex_lock(&isert_conn->conn_mutex);
-	if (isert_conn->logout_posted)
-		atomic_dec(&isert_conn->post_send_buf_count);
 
-	if (isert_conn->conn_cm_id && isert_conn->state != ISER_CONN_DOWN) {
+	mutex_lock(&isert_conn->conn_mutex);
+	if (isert_conn->conn_cm_id) {
 		pr_debug("Calling rdma_disconnect from isert_wait_conn\n");
 		rdma_disconnect(isert_conn->conn_cm_id);
 	}
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -78,7 +78,6 @@ struct isert_device;
 
 struct isert_conn {
 	enum iser_conn_state	state;
-	bool			logout_posted;
 	int			post_recv_buf_count;
 	atomic_t		post_send_buf_count;
 	u32			responder_resources;


