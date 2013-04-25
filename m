Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3DYGu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:50:26 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51227 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab3DYGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:50:23 -0400
Date: Thu, 25 Apr 2013 08:50:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: oops while dumping locks
Message-ID: <20130425065018.GA7806@gmail.com>
References: <517828C0.6090802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517828C0.6090802@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> I've noticed that sometimes lockdep would spew a warning and an oops
> while dumping the list of held locks. I'm not quite sure why it happens
> and I didn't find anything that was recently changed in the code that
> could cause that:
> 
> [  855.807172] Showing all locks held in the system:
> [  855.809162] 2 locks held by khungtaskd/3552:
> [  855.809729]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff811c3563>] watchdog+0x73/0x490
> [  855.810956]  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff8118c58c>] debug_show_all_locks+0x5c/0x260
> [  855.815299] 1 lock held by ksmd/3578:
> [  855.815770]  #0:  (ksm_thread_mutex){+.+.+.}, at: [<ffffffff8126653e>] ksm_scan_thread+0x4e/0x310
> [  855.817055] 2 locks held by kpktgend_5/7480:
> [  855.817597]  #0:  (rcu_read_lock){.+.+..}, at: [<          (null)>]           (null)
> [  855.821794]  #1:
> [  855.822044] ------------[ cut here ]------------
> [  855.822677] WARNING: at kernel/lockdep.c:146 hlock_class+0x50/0x80()
> [  855.823477] DEBUG_LOCKS_WARN_ON(1)
> [  855.827953] Modules linked in:
> [  855.828423] CPU: 1 PID: 3552 Comm: khungtaskd Tainted: G        W    3.9.0-rc8-next-20130423-sasha-00014-gdf37a98 #352
> [  855.829749]  0000000000000009 ffff8800b8e05c28 ffffffff83fb6095 ffff8800b8e05c68
> [  855.830798]  ffffffff811142db 00000000b58a3000 ffff8800adee0950 0000000000000002
> [  855.835860]  0000000000000002 ffff8800b58a3000 ffff8800afa18000 ffff8800b8e05cc8
> [  855.836887] Call Trace:
> [  855.837222]  [<ffffffff83fb6095>] dump_stack+0x19/0x1b
> [  855.840950]  [<ffffffff811142db>] warn_slowpath_common+0x6b/0xa0
> [  855.841734]  [<ffffffff811143b1>] warn_slowpath_fmt+0x41/0x50
> [  855.842472]  [<ffffffff83faa137>] ? printk+0x48/0x4a
> [  855.843106]  [<ffffffff811881f0>] hlock_class+0x50/0x80
> [  855.843758]  [<ffffffff83fab453>] print_lock+0xe/0x3d
> [  855.847471]  [<ffffffff81189c92>] lockdep_print_held_locks+0xa2/0xe0
> [  855.848561]  [<ffffffff8118c64a>] debug_show_all_locks+0x11a/0x260
> [  855.849351]  [<ffffffff8115a427>] show_state_filter+0x207/0x220
> [  855.850141]  [<ffffffff8115a220>] ? sched_show_task+0x270/0x270
> [  855.853945]  [<ffffffff81189c92>] ? lockdep_print_held_locks+0xa2/0xe0
> [  855.854756]  [<ffffffff8115a052>] ? sched_show_task+0xa2/0x270
> [  855.855476]  [<ffffffff811c3803>] watchdog+0x313/0x490
> [  855.856107]  [<ffffffff811c3563>] ? watchdog+0x73/0x490
> [  855.856739]  [<ffffffff811c34f0>] ? hung_task_panic+0x20/0x20
> [  855.862510]  [<ffffffff81146673>] kthread+0xe3/0xf0
> [  855.863119]  [<ffffffff81146590>] ? kthread_create_on_node+0x160/0x160
> [  855.863917]  [<ffffffff83fff1fc>] ret_from_fork+0x7c/0xb0
> [  855.864575]  [<ffffffff81146590>] ? kthread_create_on_node+0x160/0x160
> [  855.868426] ---[ end trace 3adc9bd194fdba9a ]---
> [  855.869001] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
> [  855.869983] IP: [<ffffffff81189a70>] __print_lock_name+0xc0/0xc0
> [  855.870744] PGD 0
> [  855.872483] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  855.872483] Dumping ftrace buffer:
> [  855.872483]    (ftrace buffer empty)
> [  855.872483] Modules linked in:
> [  855.872483] CPU: 1 PID: 3552 Comm: khungtaskd Tainted: G        W    3.9.0-rc8-next-20130423-sasha-00014-gdf37a98 #352
> [  855.872483] task: ffff8800b58a3000 ti: ffff8800b8e04000 task.ti: ffff8800b8e04000
> [  855.872483] RIP: 0010:[<ffffffff81189a70>]  [<ffffffff81189a70>] __print_lock_name+0xc0/0xc0
> [  855.872483] RSP: 0018:ffff8800b8e05cb0  EFLAGS: 00010296
> [  855.872483] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000008a728a71
> [  855.872483] RDX: ffff8800b58a3000 RSI: ffff8800b8e05cc1 RDI: 0000000000000000
> [  855.872483] RBP: ffff8800b8e05cd8 R08: 0000000000000002 R09: 0000000000000000
> [  855.872483] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000002
> [  855.890101] R13: 0000000000000002 R14: ffff8800b58a3000 R15: ffff8800afa18000
> [  855.891151] FS:  0000000000000000(0000) GS:ffff8800bb600000(0000) knlGS:0000000000000000
> [  855.891151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  855.891151] CR2: 0000000000000030 CR3: 0000000005826000 CR4: 00000000000406e0
> [  855.891151] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  855.891151] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  855.891151] Stack:
> [  855.891151]  ffffffff81189bb5 0000000000000002 0000000000000002 ffff8800b8e05cd8
> [  855.891151]  ffff8800adee0950 ffff8800b8e05cf8 ffffffff83fab45b 0000000000000038
> [  855.891151]  ffff8800adee0000 ffff8800b8e05d28 ffffffff81189c92 ffff8800b8e05d28
> [  855.891151] Call Trace:
> [  855.891151]  [<ffffffff81189bb5>] ? print_lock_name+0x15/0x50
> [  855.891151]  [<ffffffff83fab45b>] print_lock+0x16/0x3d
> [  855.891151]  [<ffffffff81189c92>] lockdep_print_held_locks+0xa2/0xe0
> [  855.891151]  [<ffffffff8118c64a>] debug_show_all_locks+0x11a/0x260
> [  855.891151]  [<ffffffff8115a427>] show_state_filter+0x207/0x220
> [  855.900353]  [<ffffffff8115a220>] ? sched_show_task+0x270/0x270
> [  855.900353]  [<ffffffff81189c92>] ? lockdep_print_held_locks+0xa2/0xe0
> [  855.900353]  [<ffffffff8115a052>] ? sched_show_task+0xa2/0x270
> [  855.900353]  [<ffffffff811c3803>] watchdog+0x313/0x490
> [  855.900353]  [<ffffffff811c3563>] ? watchdog+0x73/0x490
> [  855.900353]  [<ffffffff811c34f0>] ? hung_task_panic+0x20/0x20
> [  855.900353]  [<ffffffff81146673>] kthread+0xe3/0xf0
> [  855.900353]  [<ffffffff81146590>] ? kthread_create_on_node+0x160/0x160
> [  855.900353]  [<ffffffff83fff1fc>] ret_from_fork+0x7c/0xb0
> [  855.900353]  [<ffffffff81146590>] ? kthread_create_on_node+0x160/0x160
> [  855.900353] Code: 0f 1f 00 48 8b 45 e8 65 48 33 04 25 28 00 00 00 74 09 e8 d4 a6 f8 ff 0f 1f 40 00 48 81 c4 98 00 00 00 5b 5d
> c3 66 0f 1f 44 00 00 <48> 8b 47 30 55 48 89 e5 a8 04 0f 85 a3 00 00 00 83 e0 01 f7 d8
> [  855.900353] RIP  [<ffffffff81189a70>] __print_lock_name+0xc0/0xc0
> [  855.900353]  RSP <ffff8800b8e05cb0>
> [  855.900353] CR2: 0000000000000030
> [  856.494698] ---[ end trace 3adc9bd194fdba9b ]---

Hm, apparently the 'class' passed in to 
kernel/lockdep.c:__print_lock_name() is NULL.

hlock_class() itself already warns about it - but the caller 
(print_lock()) does not handle the NULL properly.

The only case where I can see hlock->class_idx possibly being zero is when 
lockdep got already turned off before, and we are in an inconsistent 
state. (The other possibility is some sort of memory corruption, or 
lockdep bug.)

The (untested) patch below makes print_lock_name() more robust - because 
debug_show_all_locks() can be called after lockdep is off already. If the 
NULL class is a deeper problem then we might crash elsewhere as well 
though.

Thanks,

	Ingo

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e5dedda..b5f628e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -522,11 +522,15 @@ static void print_lock_name(struct lock_class *class)
 {
 	char usage[LOCK_USAGE_CHARS];
 
-	get_usage_chars(class, usage);
+	if (class) {
+		get_usage_chars(class, usage);
 
-	printk(" (");
-	__print_lock_name(class);
-	printk("){%s}", usage);
+		printk(" (");
+		__print_lock_name(class);
+		printk("){%s}", usage);
+	} else {
+		printk(" (NULL)");
+	}
 }
 
 static void print_lockdep_cache(struct lockdep_map *lock)
