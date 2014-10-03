Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaJCDHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 23:07:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbaJCDH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 23:07:29 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH V5 5/5] Revert "fixup! audit: clean simple fsnotify implementation"
Date: Thu,  2 Oct 2014 23:06:56 -0400
Message-Id: <412e6c103e8efc095a82164a70af2d0a7ad96781.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 826a3dbd65f0fdb1d7ddfa2849de700f360e1494.

"Let audit_free_rule() take care of calling audit_remove_mark()."

It was causing a group mark deadlock.

With kernel locking debugging config options enabled, I get the following
output.  Could I get some help interpreting it?

I thought I had done a fairly careful job of justifying to myself that the mark
remove should be moved from audit_free_rule() to audit_del_rule(), but
evidently it wasn't happy.

[root@c1-f18 ~]# killall auditd;sleep 1;/usr/local/sbin/auditd 
[root@c1-f18 ~]# /usr/local/sbin/auditctl -l
No rules
[root@c1-f18 ~]# /usr/local/sbin/auditctl -a always,exit -F dir=/tmp -F exe=/usr/sbin/touch -F key=touch_tmp
[root@c1-f18 ~]# /usr/local/sbin/auditctl -l
-a always,exit -S all -F dir=/tmp -F exe=/usr/sbin/touch -F key=touch_tmp
[root@c1-f18 ~]# /usr/local/sbin/auditctl -d always,exit -F dir=/tmp -F exe=/usr/sbin/touch -F key=touch_tmp
[root@c1-f18 ~]# [   53.824114] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
[   53.825152] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/3
[   53.826154] 
[   53.826349] =================================
[   53.826854] [ INFO: inconsistent lock state ]
[   53.827108] 3.14.0-bz837856-audit-filter-name-v2+ #280 Not tainted
[   53.827108] ---------------------------------
[   53.827108] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   53.827108] swapper/3/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[   53.827108]  (&group->mark_mutex/1){+.?...}, at: [<ffffffff8128ebf3>] fsnotify_destroy_mark+0x33/0x60
[   53.827108] {SOFTIRQ-ON-W} state was registered at:
[   53.827108]   [<ffffffff810ef0c3>] __lock_acquire+0x7d3/0x1890
[   53.827108]   [<ffffffff810f022a>] lock_acquire+0xaa/0x180
[   53.827108]   [<ffffffff817ec3dd>] mutex_lock_nested+0x6d/0x4e0
[   53.827108]   [<ffffffff8128eb1b>] fsnotify_clear_marks_by_group_flags+0x3b/0xc0
[   53.827108]   [<ffffffff8128ebb3>] fsnotify_clear_marks_by_group+0x13/0x20
[   53.827108]   [<ffffffff8128db66>] fsnotify_destroy_group+0x16/0x50
[   53.827108]   [<ffffffff812901b8>] inotify_release+0x68/0x80
[   53.827108]   [<ffffffff81240705>] __fput+0x115/0x2a0
[   53.827108]   [<ffffffff8124095e>] ____fput+0xe/0x10
[   53.827108]   [<ffffffff810b391d>] task_work_run+0xad/0xe0
[   53.827108]   [<ffffffff81018df7>] do_notify_resume+0x97/0xd0
[   53.827108]   [<ffffffff817fb622>] int_signal+0x12/0x17
[   53.827108] irq event stamp: 2397788
[   53.827108] hardirqs last  enabled at (2397788): [<ffffffff81101739>] vprintk_emit+0x119/0x630
[   53.827108] hardirqs last disabled at (2397787): [<ffffffff811016c4>] vprintk_emit+0xa4/0x630
[   53.827108] softirqs last  enabled at (2397606): [<ffffffff8108e40c>] _local_bh_enable+0x9c/0xd0
[   53.827108] softirqs last disabled at (2397607): [<ffffffff8108f465>] irq_exit+0x105/0x110
[   53.827108] 
[   53.827108] other info that might help us debug this:
[   53.827108]  Possible unsafe locking scenario:
[   53.827108] 
[   53.827108]        CPU0
[   53.827108]        ----
[   53.827108]   lock(&group->mark_mutex/1);
[   53.827108]   <Interrupt>
[   53.827108]     lock(&group->mark_mutex/1);
[   53.827108] 
[   53.827108]  *** DEADLOCK ***
[   53.827108] 
[   53.827108] 1 lock held by swapper/3/0:
[   53.827108]  #0:  (rcu_callback){.+....}, at: [<ffffffff81114247>] rcu_process_callbacks+0x577/0xd00
[   53.827108] 
[   53.827108] stack backtrace:
[   53.827108] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.14.0-bz837856-audit-filter-name-v2+ #280
[   53.827108] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[   53.827108]  ffffffff825e90a0 ffff88003e403b18 ffffffff817e8908 ffff88003d2e0000
[   53.827108]  ffff88003d2e0000 ffff88003e403b68 ffffffff810ecf4f 0000000000000001
[   53.827108]  ffffffff00000001 0000000000000000 ffffffff825e9138 ffff88003d2e0848
[   53.827108] Call Trace:
[   53.827108]  <IRQ>  [<ffffffff817e8908>] dump_stack+0x51/0x71
[   53.827108]  [<ffffffff810ecf4f>] print_usage_bug+0x22f/0x280
[   53.827108]  [<ffffffff810edec2>] mark_lock+0x392/0x470
[   53.827108]  [<ffffffff810ef078>] __lock_acquire+0x788/0x1890
[   53.827108]  [<ffffffff8101b696>] ? show_stack_log_lvl+0xb6/0x1a0
[   53.827108]  [<ffffffff810f022a>] lock_acquire+0xaa/0x180
[   53.827108]  [<ffffffff8128ebf3>] ? fsnotify_destroy_mark+0x33/0x60
[   53.827108]  [<ffffffff8128ebf3>] ? fsnotify_destroy_mark+0x33/0x60
[   53.827108]  [<ffffffff817ec3dd>] mutex_lock_nested+0x6d/0x4e0
[   53.827108]  [<ffffffff8128ebf3>] ? fsnotify_destroy_mark+0x33/0x60
[   53.827108]  [<ffffffff810cfe93>] ? sched_clock_local+0x43/0xb0
[   53.827108]  [<ffffffff810d0028>] ? sched_clock_cpu+0x128/0x130
[   53.827108]  [<ffffffff8128ebf3>] fsnotify_destroy_mark+0x33/0x60
[   53.827108]  [<ffffffff811579f1>] audit_remove_mark+0x21/0x30
[   53.827108]  [<ffffffff8114fff8>] audit_free_rule_rcu+0x38/0xc0
[   53.827108]  [<ffffffff81114924>] rcu_process_callbacks+0xc54/0xd00
[   53.827108]  [<ffffffff81114247>] ? rcu_process_callbacks+0x577/0xd00
[   53.827108]  [<ffffffff817f0460>] ? _raw_spin_unlock_irq+0x30/0x50
[   53.827108]  [<ffffffff81097fe0>] ? run_timer_softirq+0x1c0/0x350
[   53.827108]  [<ffffffff8114ffc0>] ? audit_filter_type+0x260/0x260
[   53.827108]  [<ffffffff8108eee4>] __do_softirq+0x134/0x530
[   53.827108]  [<ffffffff8108f465>] irq_exit+0x105/0x110
[   53.827108]  [<ffffffff817fd65a>] smp_apic_timer_interrupt+0x4a/0x60
[   53.827108]  [<ffffffff817fbf72>] apic_timer_interrupt+0x72/0x80
[   53.827108]  <EOI>  [<ffffffff81110f34>] ? rcu_eqs_enter_common+0x1c4/0x410
[   53.827108]  [<ffffffff8105cd96>] ? native_safe_halt+0x6/0x10
[   53.827108]  [<ffffffff810ee5bd>] ? trace_hardirqs_on+0xd/0x10
[   53.827108]  [<ffffffff81023ec4>] default_idle+0x24/0x240
[   53.827108]  [<ffffffff8102377e>] arch_cpu_idle+0x2e/0x40
[   53.827108]  [<ffffffff8110371b>] cpu_startup_entry+0x2db/0x430
[   53.827108]  [<ffffffff8104e27f>] start_secondary+0x22f/0x2f0

---
 kernel/auditfilter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 570e79a..c4b89d0 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -97,8 +97,6 @@ static inline void audit_free_rule(struct audit_entry *e)
 	/* some rules don't have associated watches */
 	if (erule->watch)
 		audit_put_watch(erule->watch);
-	if (erule->exe)
-		audit_remove_mark(erule->exe);
 	if (erule->fields)
 		for (i = 0; i < erule->field_count; i++)
 			audit_free_lsm_field(&erule->fields[i]);
@@ -1020,6 +1018,9 @@ int audit_del_rule(struct audit_entry *entry)
 	if (e->rule.tree)
 		audit_remove_tree_rule(&e->rule);
 
+	if (e->rule.exe)
+		audit_remove_mark(e->rule.exe);
+
 	list_del_rcu(&e->list);
 	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
-- 
1.7.1

