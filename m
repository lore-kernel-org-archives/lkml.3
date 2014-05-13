Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbaEMKCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:02:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60819 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/182] iser-target: Match FRMR descriptors to available session tags
Date: Tue, 13 May 2014 11:25:55 +0200
Message-Id: <ce2a2e7f7a4d8cfbe16bc248b325fccc983d752d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f46d6a8a01d6bbd83a97140f30a72a89b038807b upstream.

This patch changes isert_conn_create_fastreg_pool() to follow
logic in iscsi_target_locate_portal() for determining how many
FRMR descriptors to allocate based upon the number of possible
per-session command slots that are available.

This addresses an OOPs in isert_reg_rdma() where due to the
use of ISCSI_DEF_XMIT_CMDS_MAX could end up returning a bogus
fast_reg_descriptor when the number of active tags exceeded
the original hardcoded max.

Note this also includes moving isert_conn_create_fastreg_pool()
from isert_connect_request() to isert_put_login_tx() before
posting the final Login Response PDU in order to determine the
se_nacl->queue_depth (eg: number of tags) per session the target
will be enforcing.

v2 changes:
  - Move isert_conn->conn_fr_pool list_head init into
    isert_conn_request()
v3 changes:
  - Drop unnecessary list_empty() check in isert_reg_rdma()
    (Sagi)

(Fix up v3.12.y context changes - nab)

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: <stable@vger.kernel.org> #3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 34 +++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 09c71293ab4b..65f979979005 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -426,11 +426,18 @@ isert_conn_create_frwr_pool(struct isert_conn *isert_conn)
 {
 	struct fast_reg_descriptor *fr_desc;
 	struct isert_device *device = isert_conn->conn_device;
-	int i, ret;
+	struct se_session *se_sess = isert_conn->conn->sess->se_sess;
+	struct se_node_acl *se_nacl = se_sess->se_node_acl;
+	int i, ret, tag_num;
+	/*
+	 * Setup the number of FRMRs based upon the number of tags
+	 * available to session in iscsi_target_locate_portal().
+	 */
+	tag_num = max_t(u32, ISCSIT_MIN_TAGS, se_nacl->queue_depth);
+	tag_num = (tag_num * 2) + ISCSIT_EXTRA_TAGS;
 
-	INIT_LIST_HEAD(&isert_conn->conn_frwr_pool);
 	isert_conn->conn_frwr_pool_size = 0;
-	for (i = 0; i < ISCSI_DEF_XMIT_CMDS_MAX; i++) {
+	for (i = 0; i < tag_num; i++) {
 		fr_desc = kzalloc(sizeof(*fr_desc), GFP_KERNEL);
 		if (!fr_desc) {
 			pr_err("Failed to allocate fast_reg descriptor\n");
@@ -502,6 +509,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	kref_get(&isert_conn->conn_kref);
 	mutex_init(&isert_conn->conn_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
+	INIT_LIST_HEAD(&isert_conn->conn_frwr_pool);
 
 	cma_id->context = isert_conn;
 	isert_conn->conn_cm_id = cma_id;
@@ -559,14 +567,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_conn->conn_pd = device->dev_pd;
 	isert_conn->conn_mr = device->dev_mr;
 
-	if (device->use_frwr) {
-		ret = isert_conn_create_frwr_pool(isert_conn);
-		if (ret) {
-			pr_err("Conn: %p failed to create frwr_pool\n", isert_conn);
-			goto out_frwr;
-		}
-	}
-
 	ret = isert_conn_setup_qp(isert_conn, cma_id);
 	if (ret)
 		goto out_conn_dev;
@@ -580,9 +580,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	return 0;
 
 out_conn_dev:
-	if (device->use_frwr)
-		isert_conn_free_frwr_pool(isert_conn);
-out_frwr:
 	isert_device_try_release(device);
 out_rsp_dma_map:
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
@@ -930,6 +927,15 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
+			if (isert_conn->conn_device->use_frwr) {
+				ret = isert_conn_create_frwr_pool(isert_conn);
+				if (ret) {
+					pr_err("Conn: %p failed to create"
+					       " frwr_pool\n", isert_conn);
+					return ret;
+				}
+			}
+
 			ret = isert_alloc_rx_descriptors(isert_conn);
 			if (ret)
 				return ret;
-- 
1.9.3

