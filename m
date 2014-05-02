Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaEBQVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:21:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaEBPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 136/151] iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err
Date: Fri,  2 May 2014 08:38:44 -0700
Message-Id: <1399045139-4531-137-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 03e7848a64ed535a30f5d7fc6dede2d5a6a2534b upstream.

This patch fixes a bug where outstanding RDMA_READs with WRITE_PENDING
status require an extra target_put_sess_cmd() in isert_put_cmd() code
when called from isert_cq_tx_comp_err() + isert_cq_drain_comp_llist()
context during session shutdown.

The extra kref PUT is required so that transport_generic_free_cmd()
invokes the last target_put_sess_cmd() -> target_release_cmd_kref(),
which will complete(&se_cmd->cmd_wait_comp) the outstanding se_cmd
descriptor with WRITE_PENDING status, and awake the completion in
target_wait_for_sess_cmds() to invoke TFO->release_cmd().

The bug was manifesting itself in target_wait_for_sess_cmds() where
a se_cmd descriptor with WRITE_PENDING status would end up sleeping
indefinately.

Acked-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ kamal: backport to 3.13 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 37 +++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3b7bfc7..3e3b2a1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1434,7 +1434,7 @@ isert_unreg_rdma_frwr(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn
 }
 
 static void
-isert_put_cmd(struct isert_cmd *isert_cmd)
+isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
@@ -1450,8 +1450,21 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
-		if (cmd->data_direction == DMA_TO_DEVICE)
+		if (cmd->data_direction == DMA_TO_DEVICE) {
 			iscsit_stop_dataout_timer(cmd);
+			/*
+			 * Check for special case during comp_err where
+			 * WRITE_PENDING has been handed off from core,
+			 * but requires an extra target_put_sess_cmd()
+			 * before transport_generic_free_cmd() below.
+			 */
+			if (comp_err &&
+			    cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
+				struct se_cmd *se_cmd = &cmd->se_cmd;
+
+				target_put_sess_cmd(se_cmd->se_sess, se_cmd);
+			}
+		}
 
 		device->unreg_rdma_mem(isert_cmd, isert_conn);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -1506,7 +1519,7 @@ isert_unmap_tx_desc(struct iser_tx_desc *tx_desc, struct ib_device *ib_dev)
 
 static void
 isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
-		     struct ib_device *ib_dev)
+		     struct ib_device *ib_dev, bool comp_err)
 {
 	if (isert_cmd->pdu_buf_dma != 0) {
 		pr_debug("Calling ib_dma_unmap_single for isert_cmd->pdu_buf_dma\n");
@@ -1516,7 +1529,7 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 	}
 
 	isert_unmap_tx_desc(tx_desc, ib_dev);
-	isert_put_cmd(isert_cmd);
+	isert_put_cmd(isert_cmd, comp_err);
 }
 
 static void
@@ -1560,14 +1573,14 @@ isert_do_control_comp(struct work_struct *work)
 		iscsit_tmr_post_handler(cmd, cmd->conn);
 
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	case ISTATE_SEND_REJECT:
 		pr_debug("Got isert_do_control_comp ISTATE_SEND_REJECT: >>>\n");
 		atomic_dec(&isert_conn->post_send_buf_count);
 
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	case ISTATE_SEND_LOGOUTRSP:
 		pr_debug("Calling iscsit_logout_post_handler >>>>>>>>>>>>>>\n");
@@ -1581,7 +1594,7 @@ isert_do_control_comp(struct work_struct *work)
 	case ISTATE_SEND_TEXTRSP:
 		atomic_dec(&isert_conn->post_send_buf_count);
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	default:
 		pr_err("Unknown do_control_comp i_state %d\n", cmd->i_state);
@@ -1612,7 +1625,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
-	isert_completion_put(tx_desc, isert_cmd, ib_dev);
+	isert_completion_put(tx_desc, isert_cmd, ib_dev, false);
 }
 
 static void
@@ -1693,7 +1706,8 @@ isert_cq_drain_comp_llist(struct isert_conn *isert_conn, struct ib_device *ib_de
 		wr = &t->isert_cmd->rdma_wr;
 
 		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
-		isert_completion_put(t, t->isert_cmd, ib_dev);
+
+		isert_completion_put(t, t->isert_cmd, ib_dev, true);
 	}
 }
 
@@ -1712,14 +1726,15 @@ isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn
 		wr = &t->isert_cmd->rdma_wr;
 
 		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
-		isert_completion_put(t, t->isert_cmd, ib_dev);
+
+		isert_completion_put(t, t->isert_cmd, ib_dev, true);
 	}
 	tx_desc->comp_llnode_batch = NULL;
 
 	if (!isert_cmd)
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 	else
-		isert_completion_put(tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(tx_desc, isert_cmd, ib_dev, true);
 }
 
 static void
-- 
1.9.1

