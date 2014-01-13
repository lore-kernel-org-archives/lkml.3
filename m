Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaAMP6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:58:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaAMP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:58:34 -0500
Date: Mon, 13 Jan 2014 07:58:04 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-v55fgqj3nnyqnngmvuu8ep6h@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock: Fix up clear_sched_clock_stable()
Git-Commit-ID: 6577e42a3e1633afe762f47da9e00061ee4b9a5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:58:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6577e42a3e1633afe762f47da9e00061ee4b9a5e
Gitweb:     http://git.kernel.org/tip/6577e42a3e1633afe762f47da9e00061ee4b9a5e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Dec 2013 18:55:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 15:13:15 +0100

sched/clock: Fix up clear_sched_clock_stable()

The below tells us the static_key conversion has a problem; since the
exact point of clearing that flag isn't too important, delay the flip
and use a workqueue to process it.

[ ] TSC synchronization [CPU#0 -> CPU#22]:
[ ] Measured 8 cycles TSC warp between CPUs, turning off TSC clock.
[ ]
[ ] ======================================================
[ ] [ INFO: possible circular locking dependency detected ]
[ ] 3.13.0-rc3-01745-g848b0d0322cb-dirty #637 Not tainted
[ ] -------------------------------------------------------
[ ] swapper/0/1 is trying to acquire lock:
[ ]  (jump_label_mutex){+.+...}, at: [<ffffffff8115a637>] jump_label_lock+0x17/0x20
[ ]
[ ] but task is already holding lock:
[ ]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8109408b>] cpu_hotplug_begin+0x2b/0x60
[ ]
[ ] which lock already depends on the new lock.
[ ]
[ ]
[ ] the existing dependency chain (in reverse order) is:
[ ]
[ ] -> #1 (cpu_hotplug.lock){+.+.+.}:
[ ]        [<ffffffff810def00>] lock_acquire+0x90/0x130
[ ]        [<ffffffff81661f83>] mutex_lock_nested+0x63/0x3e0
[ ]        [<ffffffff81093fdc>] get_online_cpus+0x3c/0x60
[ ]        [<ffffffff8104cc67>] arch_jump_label_transform+0x37/0x130
[ ]        [<ffffffff8115a3cf>] __jump_label_update+0x5f/0x80
[ ]        [<ffffffff8115a48d>] jump_label_update+0x9d/0xb0
[ ]        [<ffffffff8115aa6d>] static_key_slow_inc+0x9d/0xb0
[ ]        [<ffffffff810c0f65>] sched_feat_set+0xf5/0x100
[ ]        [<ffffffff810c5bdc>] set_numabalancing_state+0x2c/0x30
[ ]        [<ffffffff81d12f3d>] numa_policy_init+0x1af/0x1b7
[ ]        [<ffffffff81cebdf4>] start_kernel+0x35d/0x41f
[ ]        [<ffffffff81ceb5a5>] x86_64_start_reservations+0x2a/0x2c
[ ]        [<ffffffff81ceb6a2>] x86_64_start_kernel+0xfb/0xfe
[ ]
[ ] -> #0 (jump_label_mutex){+.+...}:
[ ]        [<ffffffff810de141>] __lock_acquire+0x1701/0x1eb0
[ ]        [<ffffffff810def00>] lock_acquire+0x90/0x130
[ ]        [<ffffffff81661f83>] mutex_lock_nested+0x63/0x3e0
[ ]        [<ffffffff8115a637>] jump_label_lock+0x17/0x20
[ ]        [<ffffffff8115aa3b>] static_key_slow_inc+0x6b/0xb0
[ ]        [<ffffffff810ca775>] clear_sched_clock_stable+0x15/0x20
[ ]        [<ffffffff810503b3>] mark_tsc_unstable+0x23/0x70
[ ]        [<ffffffff810772cb>] check_tsc_sync_source+0x14b/0x150
[ ]        [<ffffffff81076612>] native_cpu_up+0x3a2/0x890
[ ]        [<ffffffff810941cb>] _cpu_up+0xdb/0x160
[ ]        [<ffffffff810942c9>] cpu_up+0x79/0x90
[ ]        [<ffffffff81d0af6b>] smp_init+0x60/0x8c
[ ]        [<ffffffff81cebf42>] kernel_init_freeable+0x8c/0x197
[ ]        [<ffffffff8164e32e>] kernel_init+0xe/0x130
[ ]        [<ffffffff8166beec>] ret_from_fork+0x7c/0xb0
[ ]
[ ] other info that might help us debug this:
[ ]
[ ]  Possible unsafe locking scenario:
[ ]
[ ]        CPU0                    CPU1
[ ]        ----                    ----
[ ]   lock(cpu_hotplug.lock);
[ ]                                lock(jump_label_mutex);
[ ]                                lock(cpu_hotplug.lock);
[ ]   lock(jump_label_mutex);
[ ]
[ ]  *** DEADLOCK ***
[ ]
[ ] 2 locks held by swapper/0/1:
[ ]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81094037>] cpu_maps_update_begin+0x17/0x20
[ ]  #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8109408b>] cpu_hotplug_begin+0x2b/0x60
[ ]
[ ] stack backtrace:
[ ] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc3-01745-g848b0d0322cb-dirty #637
[ ] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[ ]  ffffffff82c9c270 ffff880236843bb8 ffffffff8165c5f5 ffffffff82c9c270
[ ]  ffff880236843bf8 ffffffff81658c02 ffff880236843c80 ffff8802368586a0
[ ]  ffff880236858678 0000000000000001 0000000000000002 ffff880236858000
[ ] Call Trace:
[ ]  [<ffffffff8165c5f5>] dump_stack+0x4e/0x7a
[ ]  [<ffffffff81658c02>] print_circular_bug+0x1f9/0x207
[ ]  [<ffffffff810de141>] __lock_acquire+0x1701/0x1eb0
[ ]  [<ffffffff816680ff>] ? __atomic_notifier_call_chain+0x8f/0xb0
[ ]  [<ffffffff810def00>] lock_acquire+0x90/0x130
[ ]  [<ffffffff8115a637>] ? jump_label_lock+0x17/0x20
[ ]  [<ffffffff8115a637>] ? jump_label_lock+0x17/0x20
[ ]  [<ffffffff81661f83>] mutex_lock_nested+0x63/0x3e0
[ ]  [<ffffffff8115a637>] ? jump_label_lock+0x17/0x20
[ ]  [<ffffffff8115a637>] jump_label_lock+0x17/0x20
[ ]  [<ffffffff8115aa3b>] static_key_slow_inc+0x6b/0xb0
[ ]  [<ffffffff810ca775>] clear_sched_clock_stable+0x15/0x20
[ ]  [<ffffffff810503b3>] mark_tsc_unstable+0x23/0x70
[ ]  [<ffffffff810772cb>] check_tsc_sync_source+0x14b/0x150
[ ]  [<ffffffff81076612>] native_cpu_up+0x3a2/0x890
[ ]  [<ffffffff810941cb>] _cpu_up+0xdb/0x160
[ ]  [<ffffffff810942c9>] cpu_up+0x79/0x90
[ ]  [<ffffffff81d0af6b>] smp_init+0x60/0x8c
[ ]  [<ffffffff81cebf42>] kernel_init_freeable+0x8c/0x197
[ ]  [<ffffffff8164e320>] ? rest_init+0xd0/0xd0
[ ]  [<ffffffff8164e32e>] kernel_init+0xe/0x130
[ ]  [<ffffffff8166beec>] ret_from_fork+0x7c/0xb0
[ ]  [<ffffffff8164e320>] ? rest_init+0xd0/0xd0
[ ] ------------[ cut here ]------------
[ ] WARNING: CPU: 0 PID: 1 at /usr/src/linux-2.6/kernel/smp.c:374 smp_call_function_many+0xad/0x300()
[ ] Modules linked in:
[ ] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc3-01745-g848b0d0322cb-dirty #637
[ ] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[ ]  0000000000000009 ffff880236843be0 ffffffff8165c5f5 0000000000000000
[ ]  ffff880236843c18 ffffffff81093d8c 0000000000000000 0000000000000000
[ ]  ffffffff81ccd1a0 ffffffff810ca951 0000000000000000 ffff880236843c28
[ ] Call Trace:
[ ]  [<ffffffff8165c5f5>] dump_stack+0x4e/0x7a
[ ]  [<ffffffff81093d8c>] warn_slowpath_common+0x8c/0xc0
[ ]  [<ffffffff810ca951>] ? sched_clock_tick+0x1/0xa0
[ ]  [<ffffffff81093dda>] warn_slowpath_null+0x1a/0x20
[ ]  [<ffffffff8110b72d>] smp_call_function_many+0xad/0x300
[ ]  [<ffffffff8104f200>] ? arch_unregister_cpu+0x30/0x30
[ ]  [<ffffffff8104f200>] ? arch_unregister_cpu+0x30/0x30
[ ]  [<ffffffff810ca951>] ? sched_clock_tick+0x1/0xa0
[ ]  [<ffffffff8110ba96>] smp_call_function+0x46/0x80
[ ]  [<ffffffff8104f200>] ? arch_unregister_cpu+0x30/0x30
[ ]  [<ffffffff8110bb3c>] on_each_cpu+0x3c/0xa0
[ ]  [<ffffffff810ca950>] ? sched_clock_idle_sleep_event+0x20/0x20
[ ]  [<ffffffff810ca951>] ? sched_clock_tick+0x1/0xa0
[ ]  [<ffffffff8104f964>] text_poke_bp+0x64/0xd0
[ ]  [<ffffffff810ca950>] ? sched_clock_idle_sleep_event+0x20/0x20
[ ]  [<ffffffff8104ccde>] arch_jump_label_transform+0xae/0x130
[ ]  [<ffffffff8115a3cf>] __jump_label_update+0x5f/0x80
[ ]  [<ffffffff8115a48d>] jump_label_update+0x9d/0xb0
[ ]  [<ffffffff8115aa6d>] static_key_slow_inc+0x9d/0xb0
[ ]  [<ffffffff810ca775>] clear_sched_clock_stable+0x15/0x20
[ ]  [<ffffffff810503b3>] mark_tsc_unstable+0x23/0x70
[ ]  [<ffffffff810772cb>] check_tsc_sync_source+0x14b/0x150
[ ]  [<ffffffff81076612>] native_cpu_up+0x3a2/0x890
[ ]  [<ffffffff810941cb>] _cpu_up+0xdb/0x160
[ ]  [<ffffffff810942c9>] cpu_up+0x79/0x90
[ ]  [<ffffffff81d0af6b>] smp_init+0x60/0x8c
[ ]  [<ffffffff81cebf42>] kernel_init_freeable+0x8c/0x197
[ ]  [<ffffffff8164e320>] ? rest_init+0xd0/0xd0
[ ]  [<ffffffff8164e32e>] kernel_init+0xe/0x130
[ ]  [<ffffffff8166beec>] ret_from_fork+0x7c/0xb0
[ ]  [<ffffffff8164e320>] ? rest_init+0xd0/0xd0
[ ] ---[ end trace 6ff1df5620c49d26 ]---
[ ] tsc: Marking TSC unstable due to check_tsc_sync_source failed

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-v55fgqj3nnyqnngmvuu8ep6h@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/clock.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c9b34c4..6bd6a67 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -59,6 +59,7 @@
 #include <linux/ktime.h>
 #include <linux/sched.h>
 #include <linux/static_key.h>
+#include <linux/workqueue.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -90,13 +91,23 @@ void set_sched_clock_stable(void)
 		static_key_slow_dec(&__sched_clock_stable);
 }
 
-void clear_sched_clock_stable(void)
+static void __clear_sched_clock_stable(struct work_struct *work)
 {
 	/* XXX worry about clock continuity */
 	if (sched_clock_stable())
 		static_key_slow_inc(&__sched_clock_stable);
 }
 
+static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
+
+void clear_sched_clock_stable(void)
+{
+	if (keventd_up())
+		schedule_work(&sched_clock_work);
+	else
+		__clear_sched_clock_stable(&sched_clock_work);
+}
+
 struct sched_clock_data {
 	u64			tick_raw;
 	u64			tick_gtod;
