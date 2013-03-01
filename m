Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3CABhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:37:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56550 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3CABhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:37:05 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] futex: fix unbalanced spin_lock/spin_unlock() in exit_pi_state_list()
Date: Fri,  1 Mar 2013 09:36:55 +0800
Message-Id: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Otherwise, below warning is shown somtimes when running some test:

WARNING: at kernel/sched/core.c:3423 migrate_disable+0xbf/0xd0()
Hardware name: OptiPlex 755
Modules linked in: floppy parport parport_pc minix
Pid: 1800, comm: tst-robustpi8 Tainted: G        W    3.4.28-rt40 #1
Call Trace:
 [<ffffffff81031f3f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81031f9a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81066eaf>] migrate_disable+0xbf/0xd0
 [<ffffffff81085d95>] exit_pi_state_list+0xa5/0x170
 [<ffffffff8102f71f>] mm_release+0x12f/0x170
 [<ffffffff81036906>] exit_mm+0x26/0x140
 [<ffffffff81090fc6>] ? acct_collect+0x186/0x1c0
 [<ffffffff81036b66>] do_exit+0x146/0x930
 [<ffffffff810658d1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8103760d>] do_group_exit+0x4d/0xc0
 [<ffffffff8104828f>] get_signal_to_deliver+0x23f/0x6a0
 [<ffffffff810019e5>] do_signal+0x65/0x5e0
 [<ffffffff81047816>] ? group_send_sig_info+0x76/0x80
 [<ffffffff81002018>] do_notify_resume+0x98/0xd0
 [<ffffffff8165779b>] int_signal+0x12/0x17
---[ end trace 0000000000000004 ]---

The reason is that spin_lock() is taken in atomic context, but
spin_unlock() is not.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 9e26e87..2b676a2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -562,16 +562,17 @@ void exit_pi_state_list(struct task_struct *curr)
 
 		spin_lock(&hb->lock);
 
-		raw_spin_lock_irq(&curr->pi_lock);
 		/*
 		 * We dropped the pi-lock, so re-check whether this
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
 			spin_unlock(&hb->lock);
+			raw_spin_lock_irq(&curr->pi_lock);
 			continue;
 		}
 
+		raw_spin_lock_irq(&curr->pi_lock);
 		WARN_ON(pi_state->owner != curr);
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
-- 
1.7.9.5

