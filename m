Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162365Ab3LFXSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48736 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162192Ab3LFXSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 118/152] target: Fix delayed Task Aborted Status (TAS) handling bug
Date: Fri,  6 Dec 2013 15:10:42 -0800
Message-Id: <1386371476-2477-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e26f673..6a626ec 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2784,6 +2784,7 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 		 cmd->t_task_cdb[0], cmd->se_tfo->get_task_tag(cmd));
 
 	cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
+	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 	cmd->se_tfo->queue_status(cmd);
 
 	return 1;
@@ -2811,6 +2812,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			cmd->transport_state |= CMD_T_ABORTED;
 			smp_mb__after_atomic_inc();
+			return;
 		}
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-- 
1.8.3.2

