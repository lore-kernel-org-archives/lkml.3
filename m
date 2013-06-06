Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab3FFE0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:26:14 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49378 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3FFE0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:26:12 -0400
From: greearb@candelatech.com
To: linux-kernel@vger.kernel.org
Cc: eric.dumazet@gmail.com, tj@kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH] Fix lockup related to stop_machine being stuck in __do_softirq.
Date: Wed,  5 Jun 2013 21:25:51 -0700
Message-Id: <1370492751-6886-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

The stop machine logic can lock up if all but one of
the migration threads make it through the disable-irq
step and the one remaining thread gets stuck in
__do_softirq.  The reason __do_softirq can hang is
that it has a bail-out based on jiffies timeout, but
in the lockup case, jiffies itself is not incremented.

To work around this, re-add the max_restart counter in __do_irq
and stop processing irqs after 10 restarts.

Thanks to Tejun Heo and Rusty Russell and others for
helping me track this down.

This was introduced in 3.9 by commit:  c10d73671ad30f5469
(softirq:  reduce latencies).

It may be worth looking into ath9k to see if it has issues with
it's irq handler at a later date.

The hang stack traces look something like this:

------------[ cut here ]------------
WARNING: at kernel/watchdog.c:245 watchdog_overflow_callback+0x9c/0xa7()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 2
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd sunrpc]
Pid: 23, comm: migration/2 Tainted: G         C   3.9.4+ #11
Call Trace:
 <NMI>  [<ffffffff810977f1>] warn_slowpath_common+0x85/0x9f
 [<ffffffff810978ae>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff8110f42d>] watchdog_overflow_callback+0x9c/0xa7
 [<ffffffff8113feb6>] __perf_event_overflow+0x137/0x1cb
 [<ffffffff8101dff6>] ? x86_perf_event_set_period+0x103/0x10f
 [<ffffffff811403fa>] perf_event_overflow+0x14/0x16
 [<ffffffff81023730>] intel_pmu_handle_irq+0x2dc/0x359
 [<ffffffff815eee05>] perf_event_nmi_handler+0x19/0x1b
 [<ffffffff815ee5f3>] nmi_handle+0x7f/0xc2
 [<ffffffff815ee574>] ? oops_begin+0xa9/0xa9
 [<ffffffff815ee6f2>] do_nmi+0xbc/0x304
 [<ffffffff815edd81>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff81099fce>] ? vprintk_emit+0x40a/0x444
 [<ffffffff81104ef8>] ? stop_machine_cpu_stop+0xd8/0x274
 [<ffffffff81104ef8>] ? stop_machine_cpu_stop+0xd8/0x274
 [<ffffffff81104ef8>] ? stop_machine_cpu_stop+0xd8/0x274
 <<EOE>>  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
 [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
 [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
 [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
 [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
 [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
 [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
 [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
 [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
 [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
 [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
 [<ffffffff810b7c22>] kthread+0xc7/0xcf
 [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
 [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 4947dfa9b0a4cec3 ]---
BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:17]
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd sunrpc]
irq event stamp: 835637905
hardirqs last  enabled at (835637904): [<ffffffff8109f4c1>] __do_softirq+0x9f/0x257
hardirqs last disabled at (835637905): [<ffffffff815f48ad>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5654720): [<ffffffff8109f621>] __do_softirq+0x1ff/0x257
softirqs last disabled at (5654725): [<ffffffff8109f743>] irq_exit+0x5f/0xbb
CPU 1
Pid: 17, comm: migration/1 Tainted: G        WC   3.9.4+ #11 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109ee72>]  [<ffffffff8109ee72>] tasklet_hi_action+0xf0/0xf0
RSP: 0018:ffff88022bc83ef0  EFLAGS: 00000212
RAX: 0000000000000006 RBX: ffff880217deb710 RCX: 0000000000000006
RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffffffff81a050b0
RBP: ffff88022bc83f78 R08: ffffffff81a050b0 R09: ffff88022bc83cc8
R10: 00000000000005f2 R11: ffff8802203aaf50 R12: ffff88022bc83e68
R13: ffffffff815f48b2 R14: ffff88022bc83f78 R15: ffff88022230e000
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000430070 CR3: 00000001cbc5d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 17, threadinfo ffff88022230e000, task ffff8802223142c0)
Stack:
 ffffffff8109f539 ffff88022bc83f08 ffff88022230e010 042080402bc83f88
 000000010021bfcd 000000012bc83fa8 ffff88022230e000 ffff88022230ffd8
 0000000000000030 ffff880200000006 00000248d8cdab1c 1304da35fe841722
Call Trace:
 <IRQ>
 [<ffffffff8109f539>] ? __do_softirq+0x117/0x257
 [<ffffffff8109f743>] irq_exit+0x5f/0xbb
 [<ffffffff815f59fd>] smp_apic_timer_interrupt+0x8a/0x98
 [<ffffffff815f48b2>] apic_timer_interrupt+0x72/0x80
 <EOI>
 [<ffffffff81099fdb>] ? vprintk_emit+0x417/0x444
 [<ffffffff815e9fc0>] printk+0x4d/0x4f
 [<ffffffff81104b36>] ? cpu_stopper_thread+0x57/0x162
 [<ffffffff8110504c>] stop_machine_cpu_stop+0x22c/0x274
 [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
 [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
 [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
 [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
 [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
 [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
 [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
 [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
 [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
 [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
 [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
 [<ffffffff810b7c22>] kthread+0xc7/0xcf
 [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
 [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
Code: 1c 25 18 e2 00 00 e8 cd fe ff ff e8 ac a4 04 00 fb 66 66 90 66 66 90 4c 89 e3 48 85 db 0f 85 79 ff ff ff 5f 5b 41 5c 41 5d c9 c3 <55> 48 89 e5 41 55 41 54 53 4

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  I successfully tested something similar, but with limit of 500 and 5000.
But unless I did something really dumb, this patch should work fine.
We'll continue testing 3.9.y with this patch tomorrow.

 kernel/softirq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 14d7758..f150ad6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -204,6 +204,7 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  * should not be able to lock up the box.
  */
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
+#define MAX_SOFTIRQ_RESTART 10
 
 asmlinkage void __do_softirq(void)
 {
@@ -212,6 +213,7 @@ asmlinkage void __do_softirq(void)
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	int cpu;
 	unsigned long old_flags = current->flags;
+	int max_restart = MAX_SOFTIRQ_RESTART;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -265,7 +267,8 @@ restart:
 
 	pending = local_softirq_pending();
 	if (pending) {
-		if (time_before(jiffies, end) && !need_resched())
+		if (time_before(jiffies, end) && !need_resched()
+		    && --max_restart)
 			goto restart;
 
 		wakeup_softirqd();
-- 
1.7.3.4

