Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab3GPUFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:05:10 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49300 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab3GPUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:05:07 -0400
Date: Tue, 16 Jul 2013 23:04:27 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: cpufreq: possible circular locking detected on suspend
Message-ID: <20130716200427.GA2997@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
extracted as a new thread from https://lkml.org/lkml/2013/7/16/344

cpufreq midifications are:
> Srivatsa S. Bhat wrote:
>
> 1. Patch given in:  https://lkml.org/lkml/2013/7/11/661
>    (Just apply patch 1, not the entire patchset).
>
> 2. Apply the patch shown below, on top of the above patch:
>
[2: is a revert of commit 2f7021a815f20f3481c10884fe9735ce2a56db35]


	# for i in {1..5}; do \
	echo 0 > /sys/devices/system/cpu/cpu3/online; \
	echo 0 > /sys/devices/system/cpu/cpu2/online; \
	echo 1 > /sys/devices/system/cpu/cpu3/online; \
	echo 0 > /sys/devices/system/cpu/cpu1/online; \
	echo 1 > /sys/devices/system/cpu/cpu1/online; \
	echo 1 > /sys/devices/system/cpu/cpu2/online; \
	done
	# systemctl suspend
	->	resume


 [  227.329656] ACPI: Preparing to enter system sleep state S3
 [  227.353334] PM: Saving platform NVS memory

 [  227.355403] ======================================================
 [  227.355404] [ INFO: possible circular locking dependency detected ]
 [  227.355407] 3.11.0-rc1-dbg-01398-gf537e41-dirty #1838 Not tainted
 [  227.355408] -------------------------------------------------------
 [  227.355411] systemd-sleep/2280 is trying to acquire lock:
 [  227.355426]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8104dab4>] disable_nonboot_cpus+0x24/0x120
 [  227.355427] 
 but task is already holding lock:
 [  227.355434]  (console_lock){+.+.+.}, at: [<ffffffff8104c956>] suspend_console+0x26/0x40
 [  227.355435] 
 which lock already depends on the new lock.

 [  227.355436] 
 the existing dependency chain (in reverse order) is:
 [  227.355441] 
 -> #2 (console_lock){+.+.+.}:
 [  227.355448]        [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
 [  227.355452]        [<ffffffff8104b197>] console_lock+0x77/0x80
 [  227.355456]        [<ffffffff8104cf91>] console_cpu_notify+0x31/0x40
 [  227.355462]        [<ffffffff8107cd6d>] notifier_call_chain+0x5d/0x110
 [  227.355466]        [<ffffffff8107ce2e>] __raw_notifier_call_chain+0xe/0x10
 [  227.355469]        [<ffffffff8104d5a3>] cpu_notify+0x23/0x50
 [  227.355473]        [<ffffffff8104d5de>] cpu_notify_nofail+0xe/0x20
 [  227.355482]        [<ffffffff815fafad>] _cpu_down+0x1ad/0x330
 [  227.355486]        [<ffffffff815fb166>] cpu_down+0x36/0x50
 [  227.355493]        [<ffffffff814ad8cd>] cpu_subsys_offline+0x1d/0x30
 [  227.355498]        [<ffffffff814a8de5>] device_offline+0x95/0xc0
 [  227.355502]        [<ffffffff814a8ee2>] store_online+0x42/0x90
 [  227.355506]        [<ffffffff814a64f8>] dev_attr_store+0x18/0x30
 [  227.355513]        [<ffffffff811ec71b>] sysfs_write_file+0xdb/0x150
 [  227.355517]        [<ffffffff8117a68d>] vfs_write+0xbd/0x1e0
 [  227.355522]        [<ffffffff8117ad7c>] SyS_write+0x4c/0xa0
 [  227.355527]        [<ffffffff8160cbfe>] tracesys+0xd0/0xd5
 [  227.355531] 
 -> #1 (cpu_hotplug.lock){+.+.+.}:
 [  227.355535]        [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
 [  227.355541]        [<ffffffff81605b47>] mutex_lock_nested+0x67/0x410
 [  227.355545]        [<ffffffff8104d54b>] cpu_hotplug_begin+0x2b/0x60
 [  227.355549]        [<ffffffff8104d61a>] _cpu_up+0x2a/0x170
 [  227.355552]        [<ffffffff8104d7b9>] cpu_up+0x59/0x80
 [  227.355558]        [<ffffffff81cf51b6>] smp_init+0x64/0x95
 [  227.355566]        [<ffffffff81cdaf21>] kernel_init_freeable+0x84/0x191
 [  227.355570]        [<ffffffff815fa34e>] kernel_init+0xe/0x180
 [  227.355574]        [<ffffffff8160c9ac>] ret_from_fork+0x7c/0xb0
 [  227.355578] 
 -> #0 (cpu_add_remove_lock){+.+.+.}:
 [  227.355582]        [<ffffffff810b8106>] __lock_acquire+0x1766/0x1d30
 [  227.355586]        [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
 [  227.355590]        [<ffffffff81605b47>] mutex_lock_nested+0x67/0x410
 [  227.355594]        [<ffffffff8104dab4>] disable_nonboot_cpus+0x24/0x120
 [  227.355601]        [<ffffffff810a0973>] suspend_devices_and_enter+0x1f3/0x680
 [  227.355605]        [<ffffffff810a0fd2>] pm_suspend+0x1d2/0x240
 [  227.355609]        [<ffffffff8109fa19>] state_store+0x79/0xf0
 [  227.355614]        [<ffffffff81312dbf>] kobj_attr_store+0xf/0x20
 [  227.355618]        [<ffffffff811ec71b>] sysfs_write_file+0xdb/0x150
 [  227.355621]        [<ffffffff8117a68d>] vfs_write+0xbd/0x1e0
 [  227.355624]        [<ffffffff8117ad7c>] SyS_write+0x4c/0xa0
 [  227.355628]        [<ffffffff8160cbfe>] tracesys+0xd0/0xd5
 [  227.355629] 
 other info that might help us debug this:

 [  227.355635] Chain exists of:
   cpu_add_remove_lock --> cpu_hotplug.lock --> console_lock

 [  227.355637]  Possible unsafe locking scenario:

  [  227.355638]        CPU0                    CPU1
  [  227.355639]        ----                    ----
  [  227.355642]   lock(console_lock);
  [  227.355644]                                lock(cpu_hotplug.lock);
  [  227.355647]                                lock(console_lock);
  [  227.355650]   lock(cpu_add_remove_lock);
  [  227.355651] 
   *** DEADLOCK ***

    [  227.355653] 5 locks held by systemd-sleep/2280:
    [  227.355661]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff8117a78b>]   vfs_write+0x1bb/0x1e0
    [  227.355668]  #1:  (&buffer->mutex){+.+.+.}, at:   [<ffffffff811ec67c>] sysfs_write_file+0x3c/0x150
    [  227.355676]  #2:  (s_active#110){.+.+.+}, at: [<ffffffff811ec703>]   sysfs_write_file+0xc3/0x150
    [  227.355683]  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff810a0e32>]   pm_suspend+0x32/0x240
    [  227.355690]  #4:  (console_lock){+.+.+.}, at: [<ffffffff8104c956>]   suspend_console+0x26/0x40
    [  227.355691] 
    stack backtrace:
    [  227.355695] CPU: 0 PID: 2280 Comm: systemd-sleep Not tainted   3.11.0-rc1-dbg-01398-gf537e41-dirty #1838
    [  227.355697] Hardware name: Acer             Aspire 5741G   /Aspire 5741G    , BIOS V1.20 02/08/2011
    [  227.355703]  ffffffff82208680 ffff88015151bbc8 ffffffff81603038   ffffffff822073f0
    [  227.355707]  ffff88015151bc08 ffffffff815ffdaa ffff880153389fa0   ffff88015338a788
    [  227.355712]  1d81e4832c04c441 ffff88015338a760 ffff88015338a788   ffff880153389fa0
    [  227.355713] Call Trace:
    [  227.355719]  [<ffffffff81603038>] dump_stack+0x4e/0x82
    [  227.355723]  [<ffffffff815ffdaa>] print_circular_bug+0x2b6/0x2c5
    [  227.355727]  [<ffffffff810b8106>] __lock_acquire+0x1766/0x1d30
    [  227.355733]  [<ffffffff81054aec>] ?   walk_system_ram_range+0x5c/0x140
    [  227.355737]  [<ffffffff810b63f4>] ? mark_held_locks+0x94/0x140
    [  227.355741]  [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
    [  227.355745]  [<ffffffff8104dab4>] ?   disable_nonboot_cpus+0x24/0x120
    [  227.355749]  [<ffffffff8104dab4>] ?   disable_nonboot_cpus+0x24/0x120
    [  227.355753]  [<ffffffff81605b47>] mutex_lock_nested+0x67/0x410
    [  227.355757]  [<ffffffff8104dab4>] ?   disable_nonboot_cpus+0x24/0x120
    [  227.355761]  [<ffffffff81607e9e>] ? mutex_unlock+0xe/0x10
    [  227.355768]  [<ffffffff8135bd2f>] ? acpi_os_get_iomem+0x4c/0x54
    [  227.355772]  [<ffffffff8104dab4>] disable_nonboot_cpus+0x24/0x120
    [  227.355777]  [<ffffffff810a0973>]   suspend_devices_and_enter+0x1f3/0x680
    [  227.355780]  [<ffffffff815fefc6>] ? printk+0x67/0x69
    [  227.355785]  [<ffffffff810a0fd2>] pm_suspend+0x1d2/0x240
    [  227.355789]  [<ffffffff8109fa19>] state_store+0x79/0xf0
    [  227.355792]  [<ffffffff81312dbf>] kobj_attr_store+0xf/0x20
    [  227.355796]  [<ffffffff811ec71b>] sysfs_write_file+0xdb/0x150
    [  227.355799]  [<ffffffff8117a68d>] vfs_write+0xbd/0x1e0
    [  227.355804]  [<ffffffff81198490>] ? fget_light+0x320/0x4b0
    [  227.355808]  [<ffffffff8117ad7c>] SyS_write+0x4c/0xa0
    [  227.355811]  [<ffffffff8160cbfe>] tracesys+0xd0/0xd5
    [  227.355814] Disabling non-boot CPUs ...
    [  227.357731] smpboot: CPU 1 is now offline
    [  227.461072] smpboot: CPU 2 is now offline
    [  227.565119] smpboot: CPU 3 is now offline




Local midifications are:

git diff -u -p drivers/cpufreq/

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0937b8d..7dcfa68 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1942,13 +1942,15 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 	if (dev) {
 		switch (action) {
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			cpufreq_add_dev(dev, NULL);
 			break;
 		case CPU_DOWN_PREPARE:
-		case CPU_UP_CANCELED_FROZEN:
+		case CPU_DOWN_PREPARE_FROZEN:
 			__cpufreq_remove_dev(dev, NULL);
 			break;
 		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
 			cpufreq_add_dev(dev, NULL);
 			break;
 		}
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 4645876..7b839a8 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
-#include <linux/cpu.h>
 
 #include "cpufreq_governor.h"
 
@@ -137,10 +136,8 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 	if (!all_cpus) {
 		__gov_queue_work(smp_processor_id(), dbs_data, delay);
 	} else {
-		get_online_cpus();
 		for_each_cpu(i, policy->cpus)
 			__gov_queue_work(i, dbs_data, delay);
-		put_online_cpus();
 	}
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index cd9e817..12225d1 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -353,13 +353,11 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
-		cpufreq_stats_free_table(cpu);
-		break;
-	case CPU_UP_CANCELED_FROZEN:
-		cpufreq_stats_free_sysfs(cpu);
+	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
 		break;
 	}



	-ss
