Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3GHP1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:27:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32233 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3GHP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:27:00 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-b6-51dada42c324
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [v3.10 regression] deadlock on cpu hotplug
Date: Mon, 08 Jul 2013 17:26:55 +0200
Message-id: <1443144.WnBWEpaopK@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQV2nW7cCDc5PkLf4vOEfm8XuOYtZ
	LC7vmsNm8bn3CKPF4xVv2S3Wz3jNYrHxq4fFoadzWBw4PL639rF4LN7zksnjzrU9bB4PDm1m
	8ejbsorR48yCI+wenzfJBbBHcdmkpOZklqUW6dslcGUsezmFtaA3pGLb9kmMDYwf3LoYOTkk
	BEwkLm15zwJhi0lcuLeerYuRi0NIYDqjxOJVL9ghnBYmiZkL3jKCVLEJWElMbF8FZosI6Ers
	+v0MrINZ4DejxMnrnWCjhAWMJWZd/w1UxMHBIqAqsfRZMkiYV0BTYn7HRLBeUQF7iW3v3rJB
	xAUlfky+B9bKLCAvsW//VFYIW0ti/c7jTBMY+WYhKZuFpGwWkrIFjMyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYJD+pn0DsZVDRaHGAU4GJV4eD9cvhUoxJpYVlyZe4hRgoNZSYR30zGg
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkb+0q6alMw5
	jhW/NjUc+CN+cqlnwKFsmeurZwaGbBbgnDP5bGnDl9ivohOPfryl/rlAJ5fzeYjx3Xlh9SIM
	25K6/0x6Gvvb25rtscOVyN+/rr0195A2i06de2LiPkOLxbtn3sjsviXnWHXn8byb06bEZd32
	nJMW9GvdpyOLy4OalrrOs2e3eHtXiaU4I9FQi7moOBEA8HNJ4GUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Commit 2f7021a8 ("cpufreq: protect 'policy->cpus' from offlining during
__gov_queue_work()") causes the following deadlock for me when using kernel
v3.10 on ARM EXYNOS4412:

[  960.380000] INFO: task kworker/0:1:34 blocked for more than 120 seconds.
[  960.385000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  960.390000] kworker/0:1     D c0613d88     0    34      2 0x00000000
[  960.395000] Workqueue: events od_dbs_timer
[  960.400000] [<c0613d88>] (__schedule+0x39c/0x7ec) from [<c06145e8>] (schedule_preempt_disabled+0x24/0x34)
[  960.410000] [<c06145e8>] (schedule_preempt_disabled+0x24/0x34) from [<c0612fe4>] (__mutex_lock_slowpath+0x15c/0x21c)
[  960.420000] [<c0612fe4>] (__mutex_lock_slowpath+0x15c/0x21c) from [<c06130ec>] (mutex_lock+0x48/0x4c)
[  960.430000] [<c06130ec>] (mutex_lock+0x48/0x4c) from [<c0027cdc>] (get_online_cpus+0x2c/0x48)
[  960.440000] [<c0027cdc>] (get_online_cpus+0x2c/0x48) from [<c03b059c>] (gov_queue_work+0x1c/0xb8)
[  960.450000] [<c03b059c>] (gov_queue_work+0x1c/0xb8) from [<c03afabc>] (od_dbs_timer+0xa8/0x12c)
[  960.455000] [<c03afabc>] (od_dbs_timer+0xa8/0x12c) from [<c003ecdc>] (process_one_work+0x138/0x43c)
[  960.465000] [<c003ecdc>] (process_one_work+0x138/0x43c) from [<c003f3d8>] (worker_thread+0x134/0x3b8)
[  960.475000] [<c003f3d8>] (worker_thread+0x134/0x3b8) from [<c0044df8>] (kthread+0xa4/0xb0)
[  960.485000] [<c0044df8>] (kthread+0xa4/0xb0) from [<c000ead8>] (ret_from_fork+0x14/0x3c)
[  960.490000] INFO: task bash:2497 blocked for more than 120 seconds.
[  960.495000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  960.505000] bash            D c0613d88     0  2497   2496 0x00000001
[  960.510000] [<c0613d88>] (__schedule+0x39c/0x7ec) from [<c061244c>] (schedule_timeout+0x14c/0x20c)
[  960.520000] [<c061244c>] (schedule_timeout+0x14c/0x20c) from [<c0613774>] (wait_for_common+0xac/0x150)
[  960.530000] [<c0613774>] (wait_for_common+0xac/0x150) from [<c003deb8>] (flush_work+0xa4/0x130)
[  960.540000] [<c003deb8>] (flush_work+0xa4/0x130) from [<c003f9d4>] (__cancel_work_timer+0x74/0x100)
[  960.545000] [<c003f9d4>] (__cancel_work_timer+0x74/0x100) from [<c03b0dc8>] (cpufreq_governor_dbs+0x4dc/0x630)
[  960.555000] [<c03b0dc8>] (cpufreq_governor_dbs+0x4dc/0x630) from [<c03ac70c>] (__cpufreq_governor+0x60/0x120)
[  960.565000] [<c03ac70c>] (__cpufreq_governor+0x60/0x120) from [<c03ad1cc>] (cpufreq_add_dev+0x2f4/0x4d8)
[  960.575000] [<c03ad1cc>] (cpufreq_add_dev+0x2f4/0x4d8) from [<c060dcd8>] (cpufreq_cpu_callback+0x54/0x5c)
[  960.585000] [<c060dcd8>] (cpufreq_cpu_callback+0x54/0x5c) from [<c004a280>] (notifier_call_chain+0x44/0x84)
[  960.595000] [<c004a280>] (notifier_call_chain+0x44/0x84) from [<c0027c94>] (__cpu_notify+0x2c/0x48)
[  960.605000] [<c0027c94>] (__cpu_notify+0x2c/0x48) from [<c060b914>] (_cpu_up+0x10c/0x15c)
[  960.615000] [<c060b914>] (_cpu_up+0x10c/0x15c) from [<c060b9c8>] (cpu_up+0x64/0x80)
[  960.620000] [<c060b9c8>] (cpu_up+0x64/0x80) from [<c060a704>] (store_online+0x4c/0x74)
[  960.630000] [<c060a704>] (store_online+0x4c/0x74) from [<c02b88b4>] (dev_attr_store+0x18/0x24)
[  960.635000] [<c02b88b4>] (dev_attr_store+0x18/0x24) from [<c014f43c>] (sysfs_write_file+0xfc/0x164)
[  960.645000] [<c014f43c>] (sysfs_write_file+0xfc/0x164) from [<c00f6e70>] (vfs_write+0xbc/0x184)
[  960.655000] [<c00f6e70>] (vfs_write+0xbc/0x184) from [<c00f7208>] (SyS_write+0x40/0x68)
[  960.665000] [<c00f7208>] (SyS_write+0x40/0x68) from [<c000ea40>] (ret_fast_syscall+0x0/0x30)

Tomek has also managed to got a lockdep info for the problem:

[   36.570161] 
[   36.570233] ======================================================
[   36.576376] [ INFO: possible circular locking dependency detected ]
[   36.582637] 3.10.0-rc5-00336-g6905065-dirty #1069 Not tainted
[   36.588355] -------------------------------------------------------
[   36.594608] bash/2783 is trying to acquire lock:
[   36.599205]  ((&(&j_cdbs->work)->work)){+.+.+.}, at: [<c0042138>] flush_work+0x0/0x27c
[   36.607104] 
[   36.607104] but task is already holding lock:
[   36.612917]  (cpu_hotplug.lock){+.+.+.}, at: [<c0028cb0>] cpu_hotplug_begin+0x2c/0x58
[   36.620731] 
[   36.620731] which lock already depends on the new lock.
[   36.620731] 
[   36.628890] 
[   36.628890] the existing dependency chain (in reverse order) is:
[   36.636355] 
-> #2 (cpu_hotplug.lock){+.+.+.}:
[   36.640867]        [<c007c828>] lock_acquire+0x9c/0x130
[   36.646075]        [<c0643dc4>] mutex_lock_nested+0x68/0x3ec
[   36.651716]        [<c0028db0>] get_online_cpus+0x40/0x60
[   36.657097]        [<c03c2810>] gov_queue_work+0x1c/0xac
[   36.662392]        [<c03c18c4>] od_dbs_timer+0xb8/0x16c
[   36.667600]        [<c00415f8>] process_one_work+0x198/0x4d8
[   36.673242]        [<c0042998>] worker_thread+0x134/0x3e8
[   36.678624]        [<c0048ad8>] kthread+0xa8/0xb4
[   36.683311]        [<c000ee88>] ret_from_fork+0x14/0x2c
[   36.688522] 
-> #1 (&j_cdbs->timer_mutex){+.+.+.}:
[   36.693380]        [<c007c828>] lock_acquire+0x9c/0x130
[   36.698588]        [<c0643dc4>] mutex_lock_nested+0x68/0x3ec
[   36.704229]        [<c03c184c>] od_dbs_timer+0x40/0x16c
[   36.709438]        [<c00415f8>] process_one_work+0x198/0x4d8
[   36.715080]        [<c0042998>] worker_thread+0x134/0x3e8
[   36.720461]        [<c0048ad8>] kthread+0xa8/0xb4
[   36.725148]        [<c000ee88>] ret_from_fork+0x14/0x2c
[   36.730360] 
-> #0 ((&(&j_cdbs->work)->work)){+.+.+.}:
[   36.735565]        [<c007bb70>] __lock_acquire+0x17c0/0x1e64
[   36.741206]        [<c007c828>] lock_acquire+0x9c/0x130
[   36.746414]        [<c0042170>] flush_work+0x38/0x27c
[   36.751449]        [<c00424e8>] __cancel_work_timer+0x84/0x120
[   36.757265]        [<c03c3040>] cpufreq_governor_dbs+0x4f4/0x674
[   36.763254]        [<c03bdeac>] __cpufreq_governor+0x60/0x120
[   36.768983]        [<c03bfaa0>] __cpufreq_remove_dev.clone.4+0x7c/0x480
[   36.775579]        [<c06421d0>] cpufreq_cpu_callback+0x48/0x5c
[   36.781396]        [<c004e688>] notifier_call_chain+0x44/0x84
[   36.787124]        [<c0028c30>] __cpu_notify+0x2c/0x48
[   36.792245]        [<c063de9c>] _cpu_down+0xb4/0x238
[   36.797193]        [<c063e048>] cpu_down+0x28/0x3c
[   36.801966]        [<c063e9c0>] store_online+0x30/0x74
[   36.807088]        [<c02c9bbc>] dev_attr_store+0x18/0x24
[   36.812382]        [<c0166e08>] sysfs_write_file+0x104/0x18c
[   36.818025]        [<c010b704>] vfs_write+0xc8/0x194
[   36.822973]        [<c010bac0>] SyS_write+0x44/0x70
[   36.827833]        [<c000edc0>] ret_fast_syscall+0x0/0x48
[   36.833218] 
[   36.833218] other info that might help us debug this:
[   36.833218] 
[   36.841203] Chain exists of:
  (&(&j_cdbs->work)->work) --> &j_cdbs->timer_mutex --> cpu_hotplug.lock

[   36.850663]  Possible unsafe locking scenario:
[   36.850663] 
[   36.856565]        CPU0                    CPU1
[   36.861079]        ----                    ----
[   36.865591]   lock(cpu_hotplug.lock);
[   36.869237]                                lock(&j_cdbs->timer_mutex);
[   36.875746]                                lock(cpu_hotplug.lock);
[   36.881909]   lock((&(&j_cdbs->work)->work));
[   36.886250] 
[   36.886250]  *** DEADLOCK ***
[   36.886250] 
[   36.892163] 5 locks held by bash/2783:
[   36.895886]  #0:  (sb_writers#7){.+.+.+}, at: [<c010b7cc>] vfs_write+0x190/0x194
[   36.903264]  #1:  (&buffer->mutex){+.+.+.}, at: [<c0166d2c>] sysfs_write_file+0x28/0x18c
[   36.911336]  #2:  (s_active#50){.+.+..}, at: [<c0166de4>] sysfs_write_file+0xe0/0x18c
[   36.919148]  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<c063e02c>] cpu_down+0xc/0x3c
[   36.926787]  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<c0028cb0>] cpu_hotplug_begin+0x2c/0x58
[   36.935032] 
[   36.935032] stack backtrace:
[   36.939394] CPU: 1 PID: 2783 Comm: bash Not tainted 3.10.0-rc5-00336-g6905065-dirty #1069
[   36.947591] [<c0015ed0>] (unwind_backtrace+0x0/0x13c) from [<c0012e58>] (show_stack+0x10/0x14)
[   36.956164] [<c0012e58>] (show_stack+0x10/0x14) from [<c0078a9c>] (print_circular_bug+0x1c8/0x304)
[   36.965105] [<c0078a9c>] (print_circular_bug+0x1c8/0x304) from [<c007bb70>] (__lock_acquire+0x17c0/0x1e64)
[   36.974735] [<c007bb70>] (__lock_acquire+0x17c0/0x1e64) from [<c007c828>] (lock_acquire+0x9c/0x130)
[   36.983767] [<c007c828>] (lock_acquire+0x9c/0x130) from [<c0042170>] (flush_work+0x38/0x27c)
[   36.992187] [<c0042170>] (flush_work+0x38/0x27c) from [<c00424e8>] (__cancel_work_timer+0x84/0x120)
[   37.001225] [<c00424e8>] (__cancel_work_timer+0x84/0x120) from [<c03c3040>] (cpufreq_governor_dbs+0x4f4/0x674)
[   37.011196] [<c03c3040>] (cpufreq_governor_dbs+0x4f4/0x674) from [<c03bdeac>] (__cpufreq_governor+0x60/0x120)
[   37.021087] [<c03bdeac>] (__cpufreq_governor+0x60/0x120) from [<c03bfaa0>] (__cpufreq_remove_dev.clone.4+0x7c/0x480)
[   37.031607] [<c03bfaa0>] (__cpufreq_remove_dev.clone.4+0x7c/0x480) from [<c06421d0>] (cpufreq_cpu_callback+0x48/0x5c)
[   37.042207] [<c06421d0>] (cpufreq_cpu_callback+0x48/0x5c) from [<c004e688>] (notifier_call_chain+0x44/0x84)
[   37.051910] [<c004e688>] (notifier_call_chain+0x44/0x84) from [<c0028c30>] (__cpu_notify+0x2c/0x48)
[   37.060931] [<c0028c30>] (__cpu_notify+0x2c/0x48) from [<c063de9c>] (_cpu_down+0xb4/0x238)
[   37.069177] [<c063de9c>] (_cpu_down+0xb4/0x238) from [<c063e048>] (cpu_down+0x28/0x3c)
[   37.077074] [<c063e048>] (cpu_down+0x28/0x3c) from [<c063e9c0>] (store_online+0x30/0x74)
[   37.085147] [<c063e9c0>] (store_online+0x30/0x74) from [<c02c9bbc>] (dev_attr_store+0x18/0x24)
[   37.093740] [<c02c9bbc>] (dev_attr_store+0x18/0x24) from [<c0166e08>] (sysfs_write_file+0x104/0x18c)
[   37.102852] [<c0166e08>] (sysfs_write_file+0x104/0x18c) from [<c010b704>] (vfs_write+0xc8/0x194)
[   37.111616] [<c010b704>] (vfs_write+0xc8/0x194) from [<c010bac0>] (SyS_write+0x44/0x70)
[   37.119613] [<c010bac0>] (SyS_write+0x44/0x70) from [<c000edc0>] (ret_fast_syscall+0x0/0x48)

Reproducing the issue is very easy, i.e.:

# echo 0 > /sys/devices/system/cpu/cpu3/online
# echo 0 > /sys/devices/system/cpu/cpu2/online
# echo 0 > /sys/devices/system/cpu/cpu1/online
# while true;do echo 1 > /sys/devices/system/cpu/cpu1/online;echo 0 > /sys/devices/system/cpu/cpu1/online;done

The commit in question (2f7021a8) was merged in v3.10-rc5 as a fix for
commit 031299b ("cpufreq: governors: Avoid unnecessary per cpu timer
interrupts") which was causing a kernel warning to show up.

Michael/Viresh: do you have some idea how to fix the issue?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
