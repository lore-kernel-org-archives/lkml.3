Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaF3MbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbaF3MbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Charalampos Pournaris <charpour@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 153/181] target: Use complete_all for se_cmd->t_transport_stop_comp
Date: Mon, 30 Jun 2014 13:52:54 +0200
Message-Id: <bc213cd17c41a7566af0910e101bc7e1b616def3.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a95d6511303b848da45ee27b35018bb58087bdc6 upstream.

This patch fixes a bug where multiple waiters on ->t_transport_stop_comp
occurs due to a concurrent ABORT_TASK and session reset both invoking
transport_wait_for_tasks(), while waiting for the associated se_cmd
descriptor backend processing to complete.

For this case, complete_all() should be invoked in order to wake up
both waiters in core_tmr_abort_task() + transport_generic_free_cmd()
process contexts.

Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Charalampos Pournaris <charpour@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7756d069dcee..66c0541ee910 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -552,7 +552,7 @@ static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists,
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return 1;
 	}
 
@@ -674,7 +674,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	if (cmd->transport_state & CMD_T_ABORTED &&
 	    cmd->transport_state & CMD_T_STOP) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	} else if (cmd->transport_state & CMD_T_FAILED) {
 		INIT_WORK(&cmd->work, target_complete_failure_work);
@@ -1749,7 +1749,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 			cmd->se_tfo->get_task_tag(cmd));
 
 		spin_unlock_irq(&cmd->t_state_lock);
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	}
 
-- 
2.0.0

