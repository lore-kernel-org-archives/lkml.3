Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbbAYSvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:51:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbbAYSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.18 074/183] iser-target: Fix connected_handler + teardown flow race
Date: Sun, 25 Jan 2015 10:06:36 -0800
Message-Id: <20150125180813.394650542@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 19e2090fb246ca21b3e569ead51a6a7a1748eadd upstream.

Take isert_conn pointer from cm_id->qp->qp_context. This
will allow us to know that the cm_id context is always
the network portal. This will make the cm_id event check
(connection or network portal) more reliable.

In order to avoid a NULL dereference in cma_id->qp->qp_context
we destroy the qp after we destroy the cm_id (and make the
dereference safe). session stablishment/teardown sequences
can happen in parallel, we should take into account that
connected_handler might race with connection teardown flow.

Also, protect isert_conn->conn_device->active_qps decrement
within the error patch during QP creation failure and the
normal teardown path in isert_connect_release().

Squashed:

iser-target: Decrement completion context active_qps in error flow

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -141,12 +141,18 @@ isert_conn_setup_qp(struct isert_conn *i
 	ret = rdma_create_qp(cma_id, isert_conn->conn_pd, &attr);
 	if (ret) {
 		pr_err("rdma_create_qp failed for cma_id %d\n", ret);
-		return ret;
+		goto err;
 	}
 	isert_conn->conn_qp = cma_id->qp;
 	pr_debug("rdma_create_qp() returned success >>>>>>>>>>>>>>>>>>>>>>>>>.\n");
 
 	return 0;
+err:
+	mutex_lock(&device_list_mutex);
+	device->cq_active_qps[min_index]--;
+	mutex_unlock(&device_list_mutex);
+
+	return ret;
 }
 
 static void
@@ -602,7 +608,6 @@ isert_connect_request(struct rdma_cm_id
 	spin_lock_init(&isert_conn->conn_lock);
 	INIT_LIST_HEAD(&isert_conn->conn_fr_pool);
 
-	cma_id->context = isert_conn;
 	isert_conn->conn_cm_id = cma_id;
 
 	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
@@ -734,18 +739,20 @@ isert_connect_release(struct isert_conn
 	if (device && device->use_fastreg)
 		isert_conn_free_fastreg_pool(isert_conn);
 
+	isert_free_rx_descriptors(isert_conn);
+	rdma_destroy_id(isert_conn->conn_cm_id);
+
 	if (isert_conn->conn_qp) {
 		cq_index = ((struct isert_cq_desc *)
 			isert_conn->conn_qp->recv_cq->cq_context)->cq_index;
 		pr_debug("isert_connect_release: cq_index: %d\n", cq_index);
+		mutex_lock(&device_list_mutex);
 		isert_conn->conn_device->cq_active_qps[cq_index]--;
+		mutex_unlock(&device_list_mutex);
 
-		rdma_destroy_qp(isert_conn->conn_cm_id);
+		ib_destroy_qp(isert_conn->conn_qp);
 	}
 
-	isert_free_rx_descriptors(isert_conn);
-	rdma_destroy_id(isert_conn->conn_cm_id);
-
 	ib_dereg_mr(isert_conn->conn_mr);
 	ib_dealloc_pd(isert_conn->conn_pd);
 
@@ -768,7 +775,7 @@ isert_connect_release(struct isert_conn
 static void
 isert_connected_handler(struct rdma_cm_id *cma_id)
 {
-	struct isert_conn *isert_conn = cma_id->context;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
 	pr_info("conn %p\n", isert_conn);
 
@@ -846,16 +853,16 @@ isert_conn_terminate(struct isert_conn *
 static int
 isert_disconnected_handler(struct rdma_cm_id *cma_id)
 {
+	struct iscsi_np *np = cma_id->context;
+	struct isert_np *isert_np = np->np_context;
 	struct isert_conn *isert_conn;
 
-	if (!cma_id->qp) {
-		struct isert_np *isert_np = cma_id->context;
-
+	if (isert_np->np_cm_id == cma_id) {
 		isert_np->np_cm_id = NULL;
 		return -1;
 	}
 
-	isert_conn = (struct isert_conn *)cma_id->context;
+	isert_conn = cma_id->qp->qp_context;
 
 	mutex_lock(&isert_conn->conn_mutex);
 	isert_conn_terminate(isert_conn);
@@ -870,7 +877,7 @@ isert_disconnected_handler(struct rdma_c
 static void
 isert_connect_error(struct rdma_cm_id *cma_id)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
 	isert_put_conn(isert_conn);
 }


