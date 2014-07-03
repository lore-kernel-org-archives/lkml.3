Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321AbaGCJwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:52:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074AbaGCJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
        Charalampos Pournaris <charpour@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 111/198] target: Use complete_all for se_cmd->t_transport_stop_comp
Date: Thu,  3 Jul 2014 10:19:14 +0100
Message-Id: <1404379241-8590-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 67e6bcf845e6..f7909afd1bf0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -495,7 +495,7 @@ static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists,
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return 1;
 	}
 
@@ -617,7 +617,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	if (cmd->transport_state & CMD_T_ABORTED &&
 	    cmd->transport_state & CMD_T_STOP) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	} else if (cmd->transport_state & CMD_T_FAILED) {
 		INIT_WORK(&cmd->work, target_complete_failure_work);
@@ -1684,7 +1684,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 			cmd->se_tfo->get_task_tag(cmd));
 
 		spin_unlock_irq(&cmd->t_state_lock);
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	}
 
-- 
1.9.1

