Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaBIJs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:48:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:48:53 -0500
Message-ID: <52F74EF8.9050407@redhat.com>
Date: Sun, 09 Feb 2014 10:48:40 +0100
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: rjw@rjwysocki.net
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, viresh.kumar@linaro.org,
        dirk.j.brandewie@intel.com, linux-pm@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH] intel_pstate: fix race condition in intel_pstate_init()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition in the intel pstate driver initialization:
the cpufreq_register_driver() function creates a timer that makes use of the
energy_divisor variable (intel_pstate_timer_func), the problem is that energy_divisor is initialized
*after* the call to cpufreq_register_driver().

This patch fixes the bug by initializing energy_divisor before the
call to cpufreq_register_driver().


[    2.351047] Intel pstate controlling: cpu 2
[    2.355271] divide error: 0000 [#1] SMP
[    2.359222] Modules linked in:
[    2.362291] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-linux-mainline+ #7
[    2.369933] Hardware name: wortmann To be filled by O.E.M./P8B-M Series, BIOS 6103 12/06/2012
[    2.378441] task: ffff880223948000 ti: ffff880223944000 task.ti: ffff880223944000
[    2.385912] RIP: 0010:[<ffffffff81548b07>]  [<ffffffff81548b07>] intel_pstate_timer_func+0x2b7/0x430
[    2.395060] RSP: 0000:ffff880226e03d58  EFLAGS: 00010246
[    2.400363] RAX: 0000000006130063 RBX: ffff88022191b800 RCX: 0000000000000199
[    2.407486] RDX: 0000000000000000 RSI: 0000000000002000 RDI: 0000000000000199
[    2.414608] RBP: ffff880226e03dd8 R08: ffff88022191b850 R09: ffff880223948cc8
[    2.421731] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[    2.428854] R13: 0000000006130063 R14: 0000003b3a91a54e R15: ffff880226e03da4
[    2.435984] FS:  0000000000000000(0000) GS:ffff880226e00000(0000) knlGS:0000000000000000
[    2.444060] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.449794] CR2: ffff88022ffff000 CR3: 0000000001a0e000 CR4: 00000000000407f0
[    2.456917] Stack:
[    2.458927]  ffff880226e03dd8 0000000000000246 0000000000000000 ffffffff8108a0c0
[    2.466380]  0000000000000000 ffffffff82dc18d0 ffff880226e03d98 0000000000000246
[    2.473832]  0000000026e03da8 0000000026e03e08 0000000000000038 ffff88022191b848
[    2.481281] Call Trace:
[    2.483725]  <IRQ>
[    2.485651]  [<ffffffff8108a0c0>] ? cascade+0xb0/0xb0
[    2.490912]  [<ffffffff81548850>] ? intel_pstate_platform_pwr_mgmt_exists+0x1e0/0x1e0
[    2.498736]  [<ffffffff8108a158>] call_timer_fn+0x98/0x260
[    2.504218]  [<ffffffff8108a0c0>] ? cascade+0xb0/0xb0
[    2.509263]  [<ffffffff816de600>] ? _raw_spin_unlock_irq+0x30/0x50
[    2.515439]  [<ffffffff8108bc78>] run_timer_softirq+0x298/0x310
[    2.521351]  [<ffffffff81100eef>] ? rcu_irq_exit+0x8f/0xe0
[    2.526833]  [<ffffffff816debf3>] ? retint_restore_args+0x13/0x13
[    2.532919]  [<ffffffff81548850>] ? intel_pstate_platform_pwr_mgmt_exists+0x1e0/0x1e0
[    2.540741]  [<ffffffff81082584>] __do_softirq+0x144/0x4f0
[    2.546217]  [<ffffffff81082ebd>] irq_exit+0x14d/0x180
[    2.551346]  [<ffffffff816eb2da>] smp_apic_timer_interrupt+0x4a/0x60
[    2.557688]  [<ffffffff816e9bf2>] apic_timer_interrupt+0x72/0x80
[    2.563685]  <EOI>
[    2.565608]  [<ffffffff810e2ff0>] ? mark_held_locks+0x90/0x150
[    2.571639]  [<ffffffff810f5070>] ? vprintk_emit+0x1c0/0x610
[    2.577299]  [<ffffffff816de660>] ? _raw_spin_unlock_irqrestore+0x40/0x80
[    2.584083]  [<ffffffff816d74ea>] printk+0x77/0x79
[    2.588873]  [<ffffffff815479bc>] ? core_get_turbo_pstate+0x3c/0x60
[    2.595139]  [<ffffffff815481a5>] intel_pstate_init_cpu+0x395/0x3a0
[    2.601404]  [<ffffffff815481cb>] intel_pstate_cpu_init+0x1b/0x100
[    2.607580]  [<ffffffff81543933>] __cpufreq_add_dev+0x213/0x780
[    2.613491]  [<ffffffff816cd6fe>] ? klist_next+0x8e/0x120
[    2.618887]  [<ffffffff81543eb0>] cpufreq_add_dev+0x10/0x20
[    2.624451]  [<ffffffff8145d921>] subsys_interface_register+0xb1/0xe0
[    2.630880]  [<ffffffff810e345d>] ? trace_hardirqs_on+0xd/0x10
[    2.636711]  [<ffffffff81541a1e>] cpufreq_register_driver+0xfe/0x2a0
[    2.643055]  [<ffffffff81ddd383>] intel_pstate_init+0x14a/0x310
[    2.648972]  [<ffffffff816d9cbe>] ? mutex_unlock+0xe/0x10
[    2.654361]  [<ffffffff81ddd239>] ? intel_pstate_setup+0x2e/0x2e
[    2.660357]  [<ffffffff810020da>] do_one_initcall+0xda/0x180
[    2.666008]  [<ffffffff81d8ed9b>] ? kernel_init_freeable+0x31a/0x31a
[    2.672357]  [<ffffffff81d8ea5e>] do_basic_setup+0x9d/0xc0
[    2.677833]  [<ffffffff81d8ed9b>] ? kernel_init_freeable+0x31a/0x31a
[    2.684176]  [<ffffffff81d8ed18>] kernel_init_freeable+0x297/0x31a
[    2.690345]  [<ffffffff816cddce>] ? kernel_init+0xe/0xf0
[    2.695648]  [<ffffffff810e3385>] ? trace_hardirqs_on_caller+0x105/0x1d0
[    2.702339]  [<ffffffff816cddc0>] ? rest_init+0x170/0x170
[    2.707734]  [<ffffffff816cddce>] kernel_init+0xe/0xf0
[    2.712866]  [<ffffffff816e8e3c>] ret_from_fork+0x7c/0xb0
[    2.718262]  [<ffffffff816cddc0>] ? rest_init+0x170/0x170
[    2.723651] Code: c8 00 00 00 48 89 df 01 d6 e8 b6 f1 ff ff eb 0e 0f 1f 40 00 29 d6 48 89 df e8 a6 f1 ff ff 4b 8d 04 a4 31 d2 4c 8d 04 c3 4c 89 e8 <48> f7 35 fa 8d 9b 01 45 8b b8 40 01 00 00 41 89 c1 49 8b 80 28
[    2.743596] RIP  [<ffffffff81548b07>] intel_pstate_timer_func+0x2b7/0x430
[    2.750390]  RSP <ffff880226e03d58>
[    2.751934] tsc: Refined TSC clocksource calibration: 3092.975 MHz
[    2.760048] divide error: 0000 [#2] [    2.760064] ---[ end trace b87c91b37801378a ]---
[    2.761931] Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/cpufreq/intel_pstate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 79606f4..bc04e73 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -956,13 +956,13 @@ static int __init intel_pstate_init(void)
 	if (!all_cpu_data)
 		return -ENOMEM;

+	rdmsrl(MSR_RAPL_POWER_UNIT, units);
+	energy_divisor = 1 << ((units >> 8) & 0x1f); /* bits{12:8} */
+
 	rc = cpufreq_register_driver(&intel_pstate_driver);
 	if (rc)
 		goto out;

-	rdmsrl(MSR_RAPL_POWER_UNIT, units);
-	energy_divisor = 1 << ((units >> 8) & 0x1f); /* bits{12:8} */
-
 	intel_pstate_debug_expose_params();
 	intel_pstate_sysfs_expose_params();

-- 
Maurizio Lombardi
