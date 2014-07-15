Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbaGOWCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:02:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaGOVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/198] Target/iser: Fix hangs in connection teardown
Date: Tue, 15 Jul 2014 14:28:28 -0700
Message-Id: <1405459868-15089-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 31 ++++++++++---------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 -
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9b5381c..cbd87ff 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -684,14 +684,10 @@ isert_disconnect_work(struct work_struct *work)
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
@@ -1587,11 +1583,8 @@ isert_do_control_comp(struct work_struct *work)
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
 	case ISTATE_SEND_TEXTRSP:
@@ -1763,6 +1756,8 @@ isert_cq_rx_comp_err(struct isert_conn *isert_conn)
 	isert_conn->state = ISER_CONN_DOWN;
 	mutex_unlock(&isert_conn->conn_mutex);
 
+	iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+
 	complete(&isert_conn->conn_wait_comp_err);
 }
 
@@ -2758,15 +2753,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
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
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 68d9f35..abbc331 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -93,7 +93,6 @@ struct isert_device;
 
 struct isert_conn {
 	enum iser_conn_state	state;
-	bool			logout_posted;
 	int			post_recv_buf_count;
 	atomic_t		post_send_buf_count;
 	u32			responder_resources;
-- 
1.9.1

