Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaDALRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaDALQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 045/144] iscsi/iser-target: Use list_del_init for ->i_conn_node
Date: Tue,  1 Apr 2014 12:14:09 +0100
Message-Id: <1396350948-29910-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 5159d763f60af693a3fcec45dce2021f66e528a4 upstream.

There are a handful of uses of list_empty() for cmd->i_conn_node
within iser-target code that expect to return false once a cmd
has been removed from the per connect list.

This patch changes all uses of list_del -> list_del_init in order
to ensure that list_empty() returns false as expected.

Acked-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c  |  6 +++---
 drivers/target/iscsi/iscsi_target.c      |  6 +++---
 drivers/target/iscsi/iscsi_target_erl2.c | 16 ++++++++--------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e0a95b8..58968e7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1278,7 +1278,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 	case ISCSI_OP_SCSI_CMD:
 		spin_lock_bh(&conn->cmd_lock);
 		if (!list_empty(&cmd->i_conn_node))
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		if (cmd->data_direction == DMA_TO_DEVICE)
@@ -1290,7 +1290,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 	case ISCSI_OP_SCSI_TMFUNC:
 		spin_lock_bh(&conn->cmd_lock);
 		if (!list_empty(&cmd->i_conn_node))
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -1300,7 +1300,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 	case ISCSI_OP_TEXT:
 		spin_lock_bh(&conn->cmd_lock);
 		if (!list_empty(&cmd->i_conn_node))
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		/*
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f6de529..832e08f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -797,7 +797,7 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 	spin_unlock_bh(&conn->cmd_lock);
 
 	list_for_each_entry_safe(cmd, cmd_p, &ack_list, i_conn_node) {
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		iscsit_free_cmd(cmd, false);
 	}
 }
@@ -3718,7 +3718,7 @@ iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state
 		break;
 	case ISTATE_REMOVE:
 		spin_lock_bh(&conn->cmd_lock);
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_free_cmd(cmd, false);
@@ -4163,7 +4163,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_conn_node) {
 
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 45a5afd..0d2d013 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -140,7 +140,7 @@ void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
 		list_for_each_entry_safe(cmd, cmd_tmp,
 				&cr->conn_recovery_cmd_list, i_conn_node) {
 
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
 			iscsit_free_cmd(cmd, true);
@@ -162,7 +162,7 @@ void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
 		list_for_each_entry_safe(cmd, cmd_tmp,
 				&cr->conn_recovery_cmd_list, i_conn_node) {
 
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
 			iscsit_free_cmd(cmd, true);
@@ -218,7 +218,7 @@ int iscsit_remove_cmd_from_connection_recovery(
 	}
 	cr = cmd->cr;
 
-	list_del(&cmd->i_conn_node);
+	list_del_init(&cmd->i_conn_node);
 	return --cr->cmd_count;
 }
 
@@ -299,7 +299,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN))
 			continue;
 
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 
 		spin_unlock_bh(&conn->cmd_lock);
 		iscsit_free_cmd(cmd, true);
@@ -337,7 +337,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 	/*
 	 * Only perform connection recovery on ISCSI_OP_SCSI_CMD or
 	 * ISCSI_OP_NOOP_OUT opcodes.  For all other opcodes call
-	 * list_del(&cmd->i_conn_node); to release the command to the
+	 * list_del_init(&cmd->i_conn_node); to release the command to the
 	 * session pool and remove it from the connection's list.
 	 *
 	 * Also stop the DataOUT timer, which will be restarted after
@@ -353,7 +353,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 				" CID: %hu\n", cmd->iscsi_opcode,
 				cmd->init_task_tag, cmd->cmd_sn, conn->cid);
 
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd, true);
 			spin_lock_bh(&conn->cmd_lock);
@@ -373,7 +373,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 		 */
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
 		     iscsi_sna_gte(cmd->cmd_sn, conn->sess->exp_cmd_sn)) {
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd, true);
 			spin_lock_bh(&conn->cmd_lock);
@@ -395,7 +395,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 
 		cmd->sess = conn->sess;
 
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_free_all_datain_reqs(cmd);
-- 
1.9.1

