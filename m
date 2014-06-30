Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaF3Mpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:45:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbaF3Ma5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Charalampos Pournaris <charpour@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 152/181] target: Set CMD_T_ACTIVE bit for Task Management Requests
Date: Mon, 30 Jun 2014 13:52:53 +0200
Message-Id: <4993301605b1aa1d09be6567a709ff3bca966caa.1404128998.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index edacb8d0d6b8..7756d069dcee 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3001,6 +3001,12 @@ static void target_tmr_work(struct work_struct *work)
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
2.0.0

