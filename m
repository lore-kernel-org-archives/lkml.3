Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaF3Ma5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722AbaF3May (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 149/181] Target/iser: Fix hangs in connection teardown
Date: Mon, 30 Jun 2014 13:52:50 +0200
Message-Id: <8e746fb7e23d63ff7dcca47e7ddd0b2ee06d5f6d.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 31 ++++++++++---------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 -
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index c09d2f0cae49..9d3dec3a5235 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -688,14 +688,10 @@ isert_disconnect_work(struct work_struct *work)
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
@@ -1581,11 +1577,8 @@ isert_do_control_comp(struct work_struct *work)
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
@@ -1699,6 +1692,8 @@ isert_cq_rx_comp_err(struct isert_conn *isert_conn)
 	isert_conn->state = ISER_CONN_DOWN;
 	mutex_unlock(&isert_conn->conn_mutex);
 
+	iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+
 	complete(&isert_conn->conn_wait_comp_err);
 }
 
@@ -2690,15 +2685,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
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
index ba695c33a2df..f0ed44c89b71 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -90,7 +90,6 @@ struct isert_device;
 
 struct isert_conn {
 	enum iser_conn_state	state;
-	bool			logout_posted;
 	int			post_recv_buf_count;
 	atomic_t		post_send_buf_count;
 	u32			responder_resources;
-- 
2.0.0

