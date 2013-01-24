Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3AXDix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:38:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3AXDaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 43/74] target: Fix use-after-free in LUN RESET handling
Date: Thu, 24 Jan 2013 01:26:55 -0200
Message-Id: <1358998046-613-44-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 72b59d6ee8adaa51f70377db0a1917ed489bead8 upstream.

If a backend IO takes a really long then an initiator might abort a
command, and then when it gives up on the abort, send a LUN reset too,
all before we process any of the original command or the abort.  (The
abort will wait for the backend IO to complete too)

When the backend IO final completes (or fails), the abort handling
will proceed and queue up a "return aborted status" operation.  Then,
while that's still pending, the LUN reset might find the original
command still on the LUN's list of commands and try to return aborted
status again, which leads to a use-after free when the first
se_tfo->queue_status call frees the command and then the second
se_tfo->queue_status call runs.

Fix this by removing a command from the LUN state_list when we first
are about to queue aborted status; we shouldn't do anything
LUN-related after we've started returning status, so this seems like
the correct thing to do.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_transport.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cf05182..d6c73e8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -586,9 +586,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
-		transport_lun_remove_cmd(cmd);
-
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
 	if (remove) {
@@ -4296,6 +4293,8 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 
+	transport_lun_remove_cmd(cmd);
+
 	pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
 		" ITT: 0x%08x\n", cmd->t_task_cdb[0],
 		cmd->se_tfo->get_task_tag(cmd));
-- 
1.7.9.5

