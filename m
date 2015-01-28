Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbbA2Cim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbbA2Cii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 121/139] iser-target: Parallelize CM connection establishment
Date: Wed, 28 Jan 2015 14:21:04 -0800
Message-Id: <1422483682-15393-122-git-send-email-kamal@canonical.com>
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

commit 2371e5da8cfe91443339b54444dec6254fdd6dfc upstream.

There is no point in accepting a new CM request only
when we are completely done with the last iscsi login.
Instead we accept immediately, this will also cause the
CM connection to reach connected state and the initiator
is allowed to send the first login. We mark that we got
the initial login and let iscsi layer pick it up when it
gets there.

This reduces the parallel login sequence by a factor of
more then 4 (and more for multi-login) and also prevents
the initiator (who does all logins in parallel) from
giving up on login timeout expiration.

In order to support multiple login requests sequence (CHAP)
we call isert_rx_login_req from isert_rx_completion insead
of letting isert_get_login_rx call it.

Squashed:

iser-target: Use kref_get_unless_zero in connected_handler
iser-target: Acquire conn_mutex when changing connection state
iser-target: Reject connect request in failure path

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 84 +++++++++++++++++++++++----------
 drivers/infiniband/ulp/isert/ib_isert.h |  2 +
 2 files changed, 62 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 989f773..a073124 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -52,6 +52,10 @@ isert_unreg_rdma_frwr(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn
 static int
 isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		    struct isert_rdma_wr *wr);
+static int
+isert_rdma_post_recvl(struct isert_conn *isert_conn);
+static int
+isert_rdma_accept(struct isert_conn *isert_conn);
 
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
@@ -505,6 +509,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_conn->state = ISER_CONN_INIT;
 	INIT_LIST_HEAD(&isert_conn->conn_accept_node);
 	init_completion(&isert_conn->conn_login_comp);
+	init_completion(&isert_conn->login_req_comp);
 	init_completion(&isert_conn->conn_wait);
 	init_completion(&isert_conn->conn_wait_comp_err);
 	kref_init(&isert_conn->conn_kref);
@@ -579,6 +584,14 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	if (ret)
 		goto out_conn_dev;
 
+	ret = isert_rdma_post_recvl(isert_conn);
+	if (ret)
+		goto out_conn_dev;
+
+	ret = isert_rdma_accept(isert_conn);
+	if (ret)
+		goto out_conn_dev;
+
 	mutex_lock(&isert_np->np_accept_mutex);
 	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
@@ -602,6 +615,7 @@ out_login_buf:
 	kfree(isert_conn->login_buf);
 out:
 	kfree(isert_conn);
+	rdma_reject(cma_id, NULL, 0);
 	return ret;
 }
 
@@ -652,8 +666,15 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
 
 	pr_info("conn %p\n", isert_conn);
 
-	isert_conn->state = ISER_CONN_UP;
-	kref_get(&isert_conn->conn_kref);
+	if (!kref_get_unless_zero(&isert_conn->conn_kref)) {
+		pr_warn("conn %p connect_release is running\n", isert_conn);
+		return;
+	}
+
+	mutex_lock(&isert_conn->conn_mutex);
+	if (isert_conn->state != ISER_CONN_FULL_FEATURE)
+		isert_conn->state = ISER_CONN_UP;
+	mutex_unlock(&isert_conn->conn_mutex);
 }
 
 static void
@@ -998,7 +1019,9 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 				return ret;
 
 			/* Now we are in FULL_FEATURE phase */
+			mutex_lock(&isert_conn->conn_mutex);
 			isert_conn->state = ISER_CONN_FULL_FEATURE;
+			mutex_unlock(&isert_conn->conn_mutex);
 			goto post_send;
 		}
 
@@ -1015,18 +1038,17 @@ post_send:
 }
 
 static void
-isert_rx_login_req(struct iser_rx_desc *rx_desc, int rx_buflen,
-		   struct isert_conn *isert_conn)
+isert_rx_login_req(struct isert_conn *isert_conn)
 {
+	struct iser_rx_desc *rx_desc = (void *)isert_conn->login_req_buf;
+	int rx_buflen = isert_conn->login_req_len;
 	struct iscsi_conn *conn = isert_conn->conn;
 	struct iscsi_login *login = conn->conn_login;
 	int size;
 
-	if (!login) {
-		pr_err("conn->conn_login is NULL\n");
-		dump_stack();
-		return;
-	}
+	pr_info("conn %p\n", isert_conn);
+
+	WARN_ON_ONCE(!login);
 
 	if (login->first_request) {
 		struct iscsi_login_req *login_req =
@@ -1389,11 +1411,20 @@ isert_rx_completion(struct iser_rx_desc *desc, struct isert_conn *isert_conn,
 		 hdr->opcode, hdr->itt, hdr->flags,
 		 (int)(xfer_len - ISER_HEADERS_LEN));
 
-	if ((char *)desc == isert_conn->login_req_buf)
-		isert_rx_login_req(desc, xfer_len - ISER_HEADERS_LEN,
-				   isert_conn);
-	else
+	if ((char *)desc == isert_conn->login_req_buf) {
+		isert_conn->login_req_len = xfer_len - ISER_HEADERS_LEN;
+		if (isert_conn->conn) {
+			struct iscsi_login *login = isert_conn->conn->conn_login;
+
+			if (login && !login->first_request)
+				isert_rx_login_req(isert_conn);
+		}
+		mutex_lock(&isert_conn->conn_mutex);
+		complete(&isert_conn->login_req_comp);
+		mutex_unlock(&isert_conn->conn_mutex);
+	} else {
 		isert_rx_do_work(desc, isert_conn);
+	}
 
 	ib_dma_sync_single_for_device(ib_dev, rx_dma, rx_buflen,
 				      DMA_FROM_DEVICE);
@@ -2674,7 +2705,15 @@ isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	int ret;
 
-	pr_debug("isert_get_login_rx before conn_login_comp conn: %p\n", conn);
+	pr_info("before login_req comp conn: %p\n", isert_conn);
+	ret = wait_for_completion_interruptible(&isert_conn->login_req_comp);
+	if (ret) {
+		pr_err("isert_conn %p interrupted before got login req\n",
+			  isert_conn);
+		return ret;
+	}
+	reinit_completion(&isert_conn->login_req_comp);
+
 	/*
 	 * For login requests after the first PDU, isert_rx_login_req() will
 	 * kick schedule_delayed_work(&conn->login_work) as the packet is
@@ -2684,11 +2723,15 @@ isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 	if (!login->first_request)
 		return 0;
 
+	isert_rx_login_req(isert_conn);
+
+	pr_info("before conn_login_comp conn: %p\n", conn);
 	ret = wait_for_completion_interruptible(&isert_conn->conn_login_comp);
 	if (ret)
 		return ret;
 
-	pr_debug("isert_get_login_rx processing login->req: %p\n", login->req);
+	pr_info("processing login->req: %p\n", login->req);
+
 	return 0;
 }
 
@@ -2766,17 +2809,10 @@ accept_wait:
 	isert_conn->conn = conn;
 	max_accept = 0;
 
-	ret = isert_rdma_post_recvl(isert_conn);
-	if (ret)
-		return ret;
-
-	ret = isert_rdma_accept(isert_conn);
-	if (ret)
-		return ret;
-
 	isert_set_conn_info(np, conn, isert_conn);
 
-	pr_debug("Processing isert_accept_np: isert_conn: %p\n", isert_conn);
+	pr_debug("Processing isert_conn: %p\n", isert_conn);
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index cf87cc3..e3812ec 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -103,6 +103,7 @@ struct isert_conn {
 	char			*login_req_buf;
 	char			*login_rsp_buf;
 	u64			login_req_dma;
+	int			login_req_len;
 	u64			login_rsp_dma;
 	unsigned int		conn_rx_desc_head;
 	struct iser_rx_desc	*conn_rx_descs;
@@ -110,6 +111,7 @@ struct isert_conn {
 	struct iscsi_conn	*conn;
 	struct list_head	conn_accept_node;
 	struct completion	conn_login_comp;
+	struct completion	login_req_comp;
 	struct iser_tx_desc	conn_login_tx_desc;
 	struct rdma_cm_id	*conn_cm_id;
 	struct ib_pd		*conn_pd;
-- 
1.9.1

