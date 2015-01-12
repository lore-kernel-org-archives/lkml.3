Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbbALSrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:47:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbbALSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 172/216] iser-target: Fix NULL dereference in SW mode DIF
Date: Mon, 12 Jan 2015 18:29:10 +0000
Message-Id: <1421087394-2712-60-git-send-email-luis.henriques@canonical.com>
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

commit 302cc7c3ca14d21ccdffdebdb61c4fe028f2d5ad upstream.

Fallback to software mode DIF if HCA does not support
PI (without crashing obviously). It is still possible to
run with backend protection and an unprotected frontend,
so looking at the command prot_op is not enough. Check
device PI capability on a per-IO basis (isert_prot_cmd
inline static) to determine if we need to handle protection
information.

Trace:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffffa037f8b1>] isert_reg_sig_mr+0x351/0x3b0 [ib_isert]
Call Trace:
 [<ffffffff812b003a>] ? swiotlb_map_sg_attrs+0x7a/0x130
 [<ffffffffa038184d>] isert_reg_rdma+0x2fd/0x370 [ib_isert]
 [<ffffffff8108f2ec>] ? idle_balance+0x6c/0x2c0
 [<ffffffffa0382b68>] isert_put_datain+0x68/0x210 [ib_isert]
 [<ffffffffa02acf5b>] lio_queue_data_in+0x2b/0x30 [iscsi_target_mod]
 [<ffffffffa02306eb>] target_complete_ok_work+0x21b/0x310 [target_core_mod]
 [<ffffffff8106ece2>] process_one_work+0x182/0x3b0
 [<ffffffff8106fda0>] worker_thread+0x120/0x3c0
 [<ffffffff8106fc80>] ? maybe_create_worker+0x190/0x190
 [<ffffffff8107594e>] kthread+0xce/0xf0
 [<ffffffff81075880>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff8159a22c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81075880>] ? kthread_freezable_should_stop+0x70/0x70

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 703c957683b1..8a25ebee717a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -61,6 +61,14 @@ static int
 isert_rdma_accept(struct isert_conn *isert_conn);
 struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 
+static inline bool
+isert_prot_cmd(struct isert_conn *conn, struct se_cmd *cmd)
+{
+	return (conn->conn_device->pi_capable &&
+		cmd->prot_op != TARGET_PROT_NORMAL);
+}
+
+
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
 {
@@ -2930,8 +2938,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (ret)
 		return ret;
 
-	if (wr->data.dma_nents != 1 ||
-	    se_cmd->prot_op != TARGET_PROT_NORMAL) {
+	if (wr->data.dma_nents != 1 || isert_prot_cmd(isert_conn, se_cmd)) {
 		spin_lock_irqsave(&isert_conn->conn_lock, flags);
 		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
 					   struct fast_reg_descriptor, list);
@@ -2945,7 +2952,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (ret)
 		goto unmap_cmd;
 
-	if (se_cmd->prot_op != TARGET_PROT_NORMAL) {
+	if (isert_prot_cmd(isert_conn, se_cmd)) {
 		ret = isert_handle_prot_cmd(isert_conn, isert_cmd, wr);
 		if (ret)
 			goto unmap_cmd;
@@ -2970,7 +2977,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		send_wr->opcode = IB_WR_RDMA_WRITE;
 		send_wr->wr.rdma.remote_addr = isert_cmd->read_va;
 		send_wr->wr.rdma.rkey = isert_cmd->read_stag;
-		send_wr->send_flags = se_cmd->prot_op == TARGET_PROT_NORMAL ?
+		send_wr->send_flags = !isert_prot_cmd(isert_conn, se_cmd) ?
 				      0 : IB_SEND_SIGNALED;
 	} else {
 		send_wr->opcode = IB_WR_RDMA_READ;
@@ -3012,7 +3019,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		return rc;
 	}
 
-	if (se_cmd->prot_op == TARGET_PROT_NORMAL) {
+	if (!isert_prot_cmd(isert_conn, se_cmd)) {
 		/*
 		 * Build isert_conn->tx_desc for iSCSI response PDU and attach
 		 */
@@ -3035,7 +3042,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 	}
 
-	if (se_cmd->prot_op == TARGET_PROT_NORMAL)
+	if (!isert_prot_cmd(isert_conn, se_cmd))
 		pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data "
 			 "READ\n", isert_cmd);
 	else
-- 
2.1.4

