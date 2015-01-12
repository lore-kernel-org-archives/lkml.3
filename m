Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbbALSaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58252 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbbALSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 168/216] iser-target: Fix connected_handler + teardown flow race
Date: Mon, 12 Jan 2015 18:29:06 +0000
Message-Id: <1421087394-2712-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e8e8ae256bac..22d877f96f47 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -141,12 +141,18 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id,
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
@@ -602,7 +608,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	spin_lock_init(&isert_conn->conn_lock);
 	INIT_LIST_HEAD(&isert_conn->conn_fr_pool);
 
-	cma_id->context = isert_conn;
 	isert_conn->conn_cm_id = cma_id;
 	isert_conn->responder_resources = event->param.conn.responder_resources;
 	isert_conn->initiator_depth = event->param.conn.initiator_depth;
@@ -732,18 +737,20 @@ isert_connect_release(struct isert_conn *isert_conn)
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
 
@@ -766,7 +773,7 @@ isert_connect_release(struct isert_conn *isert_conn)
 static void
 isert_connected_handler(struct rdma_cm_id *cma_id)
 {
-	struct isert_conn *isert_conn = cma_id->context;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
 	pr_info("conn %p\n", isert_conn);
 
@@ -844,16 +851,16 @@ isert_conn_terminate(struct isert_conn *isert_conn)
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
@@ -868,7 +875,7 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id)
 static void
 isert_connect_error(struct rdma_cm_id *cma_id)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
 	isert_put_conn(isert_conn);
 }
-- 
2.1.4

