Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbaEMJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:58:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60817 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760070AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/182] iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err
Date: Tue, 13 May 2014 11:25:56 +0200
Message-Id: <1c5c8cebd7ab71c77debc63e74ec51fa3c63f9be.1399973152.git.jslaby@suse.cz>
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

(Fix up v3.12.y context changes - nab)

Acked-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: <stable@vger.kernel.org> #3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 65f979979005..02e4d2efa208 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1420,7 +1420,7 @@ isert_unreg_rdma_frwr(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn
 }
 
 static void
-isert_put_cmd(struct isert_cmd *isert_cmd)
+isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
@@ -1436,8 +1436,21 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
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
@@ -1492,7 +1505,7 @@ isert_unmap_tx_desc(struct iser_tx_desc *tx_desc, struct ib_device *ib_dev)
 
 static void
 isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
-		     struct ib_device *ib_dev)
+		     struct ib_device *ib_dev, bool comp_err)
 {
 	if (isert_cmd->pdu_buf_dma != 0) {
 		pr_debug("Calling ib_dma_unmap_single for isert_cmd->pdu_buf_dma\n");
@@ -1502,7 +1515,7 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 	}
 
 	isert_unmap_tx_desc(tx_desc, ib_dev);
-	isert_put_cmd(isert_cmd);
+	isert_put_cmd(isert_cmd, comp_err);
 }
 
 static void
@@ -1546,14 +1559,14 @@ isert_do_control_comp(struct work_struct *work)
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
@@ -1567,7 +1580,7 @@ isert_do_control_comp(struct work_struct *work)
 	case ISTATE_SEND_TEXTRSP:
 		atomic_dec(&isert_conn->post_send_buf_count);
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	default:
 		pr_err("Unknown do_control_comp i_state %d\n", cmd->i_state);
@@ -1598,7 +1611,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
-	isert_completion_put(tx_desc, isert_cmd, ib_dev);
+	isert_completion_put(tx_desc, isert_cmd, ib_dev, false);
 }
 
 static void
@@ -1652,7 +1665,7 @@ isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn
 	if (!isert_cmd)
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 	else
-		isert_completion_put(tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(tx_desc, isert_cmd, ib_dev, true);
 }
 
 static void
-- 
1.9.3

