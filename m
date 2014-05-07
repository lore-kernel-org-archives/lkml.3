Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaEGNPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:15:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbaEGNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:15:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 66/70] iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err
Date: Wed,  7 May 2014 14:13:09 +0100
Message-Id: <1399468393-10140-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: based on nab's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 5430b4a..0e28266 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1266,7 +1266,7 @@ isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 }
 
 static void
-isert_put_cmd(struct isert_cmd *isert_cmd)
+isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 {
 	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
@@ -1281,8 +1281,21 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
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
 
 		isert_unmap_cmd(isert_cmd, isert_conn);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -1337,7 +1350,7 @@ isert_unmap_tx_desc(struct iser_tx_desc *tx_desc, struct ib_device *ib_dev)
 
 static void
 isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
-		     struct ib_device *ib_dev)
+		     struct ib_device *ib_dev, bool comp_err)
 {
 	if (isert_cmd->pdu_buf_dma != 0) {
 		pr_debug("Calling ib_dma_unmap_single for isert_cmd->pdu_buf_dma\n");
@@ -1347,7 +1360,7 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 	}
 
 	isert_unmap_tx_desc(tx_desc, ib_dev);
-	isert_put_cmd(isert_cmd);
+	isert_put_cmd(isert_cmd, comp_err);
 }
 
 static void
@@ -1402,14 +1415,14 @@ isert_do_control_comp(struct work_struct *work)
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
@@ -1423,7 +1436,7 @@ isert_do_control_comp(struct work_struct *work)
 	case ISTATE_SEND_TEXTRSP:
 		atomic_dec(&isert_conn->post_send_buf_count);
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	default:
 		pr_err("Unknown do_control_comp i_state %d\n", cmd->i_state);
@@ -1454,7 +1467,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
-	isert_completion_put(tx_desc, isert_cmd, ib_dev);
+	isert_completion_put(tx_desc, isert_cmd, ib_dev, false);
 }
 
 static void
@@ -1508,7 +1521,7 @@ isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn
 	if (!isert_cmd)
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 	else
-		isert_completion_put(tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(tx_desc, isert_cmd, ib_dev, true);
 }
 
 static void
-- 
1.9.1

