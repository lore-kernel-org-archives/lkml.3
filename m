Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbbA2Ciz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762432AbbA2Civ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 122/139] iser-target: Fix connected_handler + teardown flow race
Date: Wed, 28 Jan 2015 14:21:05 -0800
Message-Id: <1422483682-15393-123-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a073124..6779e04 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -136,12 +136,18 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
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
@@ -516,7 +522,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	mutex_init(&isert_conn->conn_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
 
-	cma_id->context = isert_conn;
 	isert_conn->conn_cm_id = cma_id;
 	isert_conn->responder_resources = event->param.conn.responder_resources;
 	isert_conn->initiator_depth = event->param.conn.initiator_depth;
@@ -631,18 +636,20 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (device && device->use_frwr)
 		isert_conn_free_frwr_pool(isert_conn);
 
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
 	if (isert_conn->login_buf) {
 		ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 				    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
@@ -662,7 +669,7 @@ isert_connect_release(struct isert_conn *isert_conn)
 static void
 isert_connected_handler(struct rdma_cm_id *cma_id)
 {
-	struct isert_conn *isert_conn = cma_id->context;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
 	pr_info("conn %p\n", isert_conn);
 
@@ -740,16 +747,16 @@ isert_conn_terminate(struct isert_conn *isert_conn)
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
@@ -764,7 +771,7 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id)
 static void
 isert_connect_error(struct rdma_cm_id *cma_id)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
 	isert_put_conn(isert_conn);
 }
-- 
1.9.1

