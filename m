Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3LBUDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:03:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3LBTRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 094/212] target: Fix delayed Task Aborted Status (TAS) handling bug
Date: Mon,  2 Dec 2013 11:14:45 -0800
Message-Id: <20131202191257.986652043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 29f4c090079f442ea2723d292e4e64f0b6ac1f27 upstream.

This patch fixes a bug in delayed Task Aborted Status (TAS) handling,
where transport_send_task_abort() was not returning for the case
when the se_tfo->write_pending() callback indicated that last fabric
specific WRITE PDU had not yet been received.

It also adds an explicit cmd->scsi_status = SAM_STAT_TASK_ABORTED
assignment within transport_check_aborted_status() to avoid the case
where se_tfo->queue_status() is called when the SAM_STAT_TASK_ABORTED
assignment + ->queue_status() in transport_send_task_abort() does not
occur once SCF_SENT_DELAYED_TAS has been set.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2910,6 +2910,7 @@ int transport_check_aborted_status(struc
 		 cmd->t_task_cdb[0], cmd->se_tfo->get_task_tag(cmd));
 
 	cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
+	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 	trace_target_cmd_complete(cmd);
 	cmd->se_tfo->queue_status(cmd);
 
@@ -2938,6 +2939,7 @@ void transport_send_task_abort(struct se
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			cmd->transport_state |= CMD_T_ABORTED;
 			smp_mb__after_atomic_inc();
+			return;
 		}
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;


