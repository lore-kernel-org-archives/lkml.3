Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbaGOWWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:22:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbaGOVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
        Charalampos Pournaris <charpour@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 113/198] target: Set CMD_T_ACTIVE bit for Task Management Requests
Date: Tue, 15 Jul 2014 14:29:43 -0700
Message-Id: <1405459868-15089-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f15e9cd910c4d9da7de43f2181f362082fc45f0f upstream.

This patch fixes a bug where se_cmd descriptors associated with a
Task Management Request (TMR) where not setting CMD_T_ACTIVE before
being dispatched into target_tmr_work() process context.

This is required in order for transport_generic_free_cmd() ->
transport_wait_for_tasks() to wait on se_cmd->t_transport_stop_comp
if a session reset event occurs while an ABORT_TASK is outstanding
waiting for another I/O to complete.

Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Charalampos Pournaris <charpour@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9095aef..453690f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2784,6 +2784,12 @@ static void target_tmr_work(struct work_struct *work)
 int transport_generic_handle_tmr(
 	struct se_cmd *cmd)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	cmd->transport_state |= CMD_T_ACTIVE;
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
 	INIT_WORK(&cmd->work, target_tmr_work);
 	queue_work(cmd->se_dev->tmr_wq, &cmd->work);
 	return 0;
-- 
1.9.1

