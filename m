Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbbALSrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:47:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbALSad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 173/216] iscsi,iser-target: Expose supported protection ops according to t10_pi
Date: Mon, 12 Jan 2015 18:29:11 +0000
Message-Id: <1421087394-2712-61-git-send-email-luis.henriques@canonical.com>
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

commit 23a548ee656c8ba6da8cb2412070edcd62e2ac5d upstream.

iSER will report supported protection operations based on
the tpg attribute t10_pi settings and HCA PI offload capabilities.
If the HCA does not support PI offload or tpg attribute t10_pi is
not set, we fall to SW PI mode.

In order to do that, we move iscsit_get_sup_prot_ops after connection
tpg assignment.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c   | 14 +++++++++++---
 drivers/infiniband/ulp/isert/ib_isert.h   |  1 +
 drivers/target/iscsi/iscsi_target_login.c |  7 ++++---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8a25ebee717a..3a36b8bbca33 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -64,7 +64,7 @@ struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 static inline bool
 isert_prot_cmd(struct isert_conn *conn, struct se_cmd *cmd)
 {
-	return (conn->conn_device->pi_capable &&
+	return (conn->pi_support &&
 		cmd->prot_op != TARGET_PROT_NORMAL);
 }
 
@@ -2322,8 +2322,16 @@ isert_get_sup_prot_ops(struct iscsi_conn *conn)
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct isert_device *device = isert_conn->conn_device;
 
-	if (device->pi_capable)
-		return TARGET_PROT_ALL;
+	if (conn->tpg->tpg_attrib.t10_pi) {
+		if (device->pi_capable) {
+			pr_info("conn %p PI offload enabled\n", isert_conn);
+			isert_conn->pi_support = true;
+			return TARGET_PROT_ALL;
+		}
+	}
+
+	pr_info("conn %p PI offload disabled\n", isert_conn);
+	isert_conn->pi_support = false;
 
 	return TARGET_PROT_NORMAL;
 }
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 2e7868c5ad14..141905f446dd 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -128,6 +128,7 @@ struct isert_conn {
 	atomic_t		post_send_buf_count;
 	u32			responder_resources;
 	u32			initiator_depth;
+	bool			pi_support;
 	u32			max_sge;
 	char			*login_buf;
 	char			*login_req_buf;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index e8d022d25146..dabc7e770b00 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -281,7 +281,6 @@ static int iscsi_login_zero_tsih_s1(
 {
 	struct iscsi_session *sess = NULL;
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
-	enum target_prot_op sup_pro_ops;
 	int ret;
 
 	sess = kzalloc(sizeof(struct iscsi_session), GFP_KERNEL);
@@ -343,9 +342,8 @@ static int iscsi_login_zero_tsih_s1(
 		kfree(sess);
 		return -ENOMEM;
 	}
-	sup_pro_ops = conn->conn_transport->iscsit_get_sup_prot_ops(conn);
 
-	sess->se_sess = transport_init_session(sup_pro_ops);
+	sess->se_sess = transport_init_session(TARGET_PROT_NORMAL);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -1371,6 +1369,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	login->zero_tsih = zero_tsih;
 
+	conn->sess->se_sess->sup_prot_ops =
+		conn->conn_transport->iscsit_get_sup_prot_ops(conn);
+
 	tpg = conn->tpg;
 	if (!tpg) {
 		pr_err("Unable to locate struct iscsi_conn->tpg\n");
-- 
2.1.4

