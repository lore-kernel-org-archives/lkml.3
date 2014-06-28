Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaF1Sht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:37:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaF1Rub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Charalampos Pournaris <charpour@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 077/110] target: Use complete_all for se_cmd->t_transport_stop_comp
Date: Sat, 28 Jun 2014 10:47:14 -0700
Message-Id: <20140628174550.100679000@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -560,7 +560,7 @@ static int transport_cmd_check_stop(stru
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return 1;
 	}
 
@@ -676,7 +676,7 @@ void target_complete_cmd(struct se_cmd *
 	if (cmd->transport_state & CMD_T_ABORTED &&
 	    cmd->transport_state & CMD_T_STOP) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	} else if (!success) {
 		INIT_WORK(&cmd->work, target_complete_failure_work);
@@ -1748,7 +1748,7 @@ void target_execute_cmd(struct se_cmd *c
 			cmd->se_tfo->get_task_tag(cmd));
 
 		spin_unlock_irq(&cmd->t_state_lock);
-		complete(&cmd->t_transport_stop_comp);
+		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	}
 


