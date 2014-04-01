Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaDAMIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:08:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaDALQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/144] iscsi-target: Perform release of acknowledged tags from RX context
Date: Tue,  1 Apr 2014 12:14:08 +0100
Message-Id: <1396350948-29910-45-git-send-email-luis.henriques@canonical.com>
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

commit f56cbbb4b5871e5bc2838ddeeba5b29debc2a734 upstream.

This patch converts iscsit_ack_from_expstatsn() to populate a local
ack_list of commands, and call iscsit_free_cmd() directly from RX
thread context, instead of using iscsit_add_cmd_to_immediate_queue()
to queue the acknowledged commands to be released from TX thread
context.

It is helpful to release the acknowledge commands as quickly as
possible, along with the associated percpu_ida tags, in order to
prevent percpu_ida_alloc() from having to steal tags from other
CPUs while waiting for iscsit_free_cmd() to happen from TX thread
context.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9c6136e..f6de529 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -774,7 +774,8 @@ static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
 
 static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 {
-	struct iscsi_cmd *cmd;
+	LIST_HEAD(ack_list);
+	struct iscsi_cmd *cmd, *cmd_p;
 
 	conn->exp_statsn = exp_statsn;
 
@@ -782,19 +783,23 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 		return;
 
 	spin_lock_bh(&conn->cmd_lock);
-	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
+	list_for_each_entry_safe(cmd, cmd_p, &conn->conn_cmd_list, i_conn_node) {
 		spin_lock(&cmd->istate_lock);
 		if ((cmd->i_state == ISTATE_SENT_STATUS) &&
 		    iscsi_sna_lt(cmd->stat_sn, exp_statsn)) {
 			cmd->i_state = ISTATE_REMOVE;
 			spin_unlock(&cmd->istate_lock);
-			iscsit_add_cmd_to_immediate_queue(cmd, conn,
-						cmd->i_state);
+			list_move_tail(&cmd->i_conn_node, &ack_list);
 			continue;
 		}
 		spin_unlock(&cmd->istate_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
+
+	list_for_each_entry_safe(cmd, cmd_p, &ack_list, i_conn_node) {
+		list_del(&cmd->i_conn_node);
+		iscsit_free_cmd(cmd, false);
+	}
 }
 
 static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
-- 
1.9.1

