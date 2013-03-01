Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3CAGAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:00:15 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:59672 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3CAGAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:00:13 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [V2 PATCH -rt] futex: fix unbalanced spin_lock/spin_unlock() in exit_pi_state_list()
Date: Fri,  1 Mar 2013 14:00:03 +0800
Message-Id: <1362117603-9480-1-git-send-email-yong.zhang0@gmail.com>
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
 kernel/futex.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 9e26e87..daada3d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -568,7 +568,9 @@ void exit_pi_state_list(struct task_struct *curr)
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
+			raw_spin_unlock_irq(&curr->pi_lock);
 			spin_unlock(&hb->lock);
+			raw_spin_lock_irq(&curr->pi_lock);
 			continue;
 		}
 
-- 
1.7.9.5

