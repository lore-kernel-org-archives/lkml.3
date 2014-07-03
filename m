Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbaGCJXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52109 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbaGCJX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
        Charalampos Pournaris <charpour@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/198] target: Set CMD_T_ACTIVE bit for Task Management Requests
Date: Thu,  3 Jul 2014 10:19:13 +0100
Message-Id: <1404379241-8590-111-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2050727dc954..67e6bcf845e6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2871,6 +2871,12 @@ static void target_tmr_work(struct work_struct *work)
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

