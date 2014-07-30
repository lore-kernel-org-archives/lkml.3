Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaG3GXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:23:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:22897 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020AbaG3GXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:23:06 -0400
X-IronPort-AV: E=Sophos;i="5.00,993,1396972800"; 
   d="scan'208";a="33948587"
Message-ID: <53D88C5B.4060302@cn.fujitsu.com>
Date: Wed, 30 Jul 2014 14:10:35 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: <rafael.j.wysocki@intel.com>
CC: Tejun Heo <tj@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: ACPI/cpu hotplug: possible lockdep
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
A lockdep warning occurs when hot removing a cpu via sysfs:
echo 1 > /sys/bus/acpi/devices/LNXCPU\:02/eject
The kernel is latest upstream, and the test box is a kvm vm,
detail info as following.

[  221.755113] ======================================================
[  221.756189] [ INFO: possible circular locking dependency detected ]
[  221.756189] 3.16.0-rc7+ #118 Not tainted
[  221.756189] -------------------------------------------------------
[  221.756189] kworker/u8:3/62 is trying to acquire lock:
[  221.756189]  (s_active#50){++++.+}, at: [<ffffffff811d4ad8>] kernfs_remove_by_name_ns+0x70/0x8c
[  221.756189] 
[  221.756189] but task is already holding lock:
[  221.756189]  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810628f9>] cpu_hotplug_begin+0x4f/0x79
[  221.756189] 
[  221.756189] which lock already depends on the new lock.
[  221.756189] 
[  221.756189] 
[  221.756189] the existing dependency chain (in reverse order) is:
[  221.756189] 
-> #3 (cpu_hotplug.lock#2){+.+.+.}:
[  221.756189]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  221.756189]        [<ffffffff81596187>] mutex_lock_nested+0x6d/0x37a
[  221.756189]        [<ffffffff810628f9>] cpu_hotplug_begin+0x4f/0x79
[  221.756189]        [<ffffffff81062992>] _cpu_up+0x35/0x126
[  221.756189]        [<ffffffff81062af2>] cpu_up+0x6f/0x81
[  221.756189]        [<ffffffff81d11804>] smp_init+0x4e/0x89
[  221.756189]        [<ffffffff81cf5fe2>] kernel_init_freeable+0x13d/0x24b
[  221.756189]        [<ffffffff8158557a>] kernel_init+0xe/0xdf
[  221.756189]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  221.756189] 
-> #2 (cpu_hotplug.lock){++++++}:
[  221.756189]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  221.756189]        [<ffffffff810628eb>] cpu_hotplug_begin+0x41/0x79
[  221.756189]        [<ffffffff81062992>] _cpu_up+0x35/0x126
[  221.756189]        [<ffffffff81062af2>] cpu_up+0x6f/0x81
[  221.756189]        [<ffffffff81d11804>] smp_init+0x4e/0x89
[  221.756189]        [<ffffffff81cf5fe2>] kernel_init_freeable+0x13d/0x24b
[  221.819219]        [<ffffffff8158557a>] kernel_init+0xe/0xdf
[  221.819219]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  221.819219] 
[  221.819219] -> #1 (cpu_add_remove_lock){+.+.+.}:
[  221.819219]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  221.819219]        [<ffffffff815988ab>] _raw_spin_lock_irqsave+0x4d/0x87
[  221.819219]        [<ffffffff81171959>] __delete_object+0x8e/0xab
[  221.819219]        [<ffffffff81171998>] delete_object_full+0x22/0x2e
[  221.819219]        [<ffffffff81587f84>] kmemleak_free+0x56/0x77
[  221.819219]        [<ffffffff81164dee>] slab_free_hook+0x1e/0x5b
[  221.819219]        [<ffffffff81166e21>] kfree+0xac/0x111
[  221.819219]        [<ffffffff812f0768>] acpi_hotplug_work_fn+0x28/0x2d
[  221.819219]        [<ffffffff81078ff5>] process_one_work+0x207/0x375
[  221.819219]        [<ffffffff8107944f>] worker_thread+0x2bd/0x329
[  221.819219]        [<ffffffff8107ef6e>] kthread+0xba/0xc2
[  221.819219]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  221.819219] 
[  221.819219] -> #0 (s_active#50){++++.+}:
[  221.819219]        [<ffffffff810a088a>] __lock_acquire+0xb3b/0xe41
[  221.819219]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  221.819219]        [<ffffffff811d3f97>] __kernfs_remove+0x169/0x2be
[  221.819219]        [<ffffffff811d4ad8>] kernfs_remove_by_name_ns+0x70/0x8c
[  221.819219]        [<ffffffff811d604c>] sysfs_remove_file_ns+0x15/0x17
[  221.819219]        [<ffffffff8138143e>] device_remove_file+0x19/0x1b
[  221.819219]        [<ffffffff813814f6>] device_remove_attrs+0x2e/0x68
[  221.819219]        [<ffffffff81381658>] device_del+0x128/0x187
[  221.819219]        [<ffffffff813816ff>] device_unregister+0x48/0x54
[  221.819219]        [<ffffffff81387366>] unregister_cpu+0x39/0x55
[  221.819219]        [<ffffffff81008c03>] arch_unregister_cpu+0x23/0x28
[  221.819219]        [<ffffffff812f7a75>] acpi_processor_remove+0x91/0xca
[  221.819219]        [<ffffffff812f51d1>] acpi_bus_trim+0x5a/0x8d
[  221.819219]        [<ffffffff812f71c6>] acpi_device_hotplug+0x301/0x3ff
[  221.819219]        [<ffffffff812f0760>] acpi_hotplug_work_fn+0x20/0x2d
[  221.819219]        [<ffffffff81078ff5>] process_one_work+0x207/0x375
[  221.819219]        [<ffffffff8107944f>] worker_thread+0x2bd/0x329
[  221.819219]        [<ffffffff8107ef6e>] kthread+0xba/0xc2
[  221.819219]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  221.819219] 
[  221.819219] other info that might help us debug this:
[  221.819219] 
[  221.819219] Chain exists of:
[  221.819219]   s_active#50 --> cpu_hotplug.lock --> cpu_hotplug.lock#2
[  221.819219] 
[  221.819219]  Possible unsafe locking scenario:
[  221.819219] 
[  221.819219]        CPU0                    CPU1
[  221.819219]        ----                    ----
[  221.819219]   lock(cpu_hotplug.lock#2);
[  221.819219]                                lock(cpu_hotplug.lock);
[  221.819219]                                lock(cpu_hotplug.lock#2);
[  221.819219]   lock(s_active#50);
[  221.819219] 
[  221.819219]  *** DEADLOCK ***
[  221.819219] 
[  221.819219] 7 locks held by kworker/u8:3/62:
[  221.819219]  #0:  ("kacpi_hotplug"){.+.+.+}, at: [<ffffffff81078f4d>] process_one_work+0x15f/0x375
[  221.819219]  #1:  ((&hpw->work)){+.+.+.}, at: [<ffffffff81078f4d>] process_one_work+0x15f/0x375
[  221.819219]  #2:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff81381f7a>] lock_device_hotplug+0x17/0x19
[  221.819219]  #3:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff812f6ef2>] acpi_device_hotplug+0x2d/0x3ff
[  221.819219]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81062722>] cpu_maps_update_begin+0x17/0x19
[  221.819219]  #5:  (cpu_hotplug.lock){++++++}, at: [<ffffffff810628af>] cpu_hotplug_begin+0x5/0x79
[  221.819219]  #6:  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810628f9>] cpu_hotplug_begin+0x4f/0x79
[  221.819219] 
[  221.819219] stack backtrace:
[  221.819219] CPU: 1 PID: 62 Comm: kworker/u8:3 Not tainted 3.16.0-rc7+ #118
[  221.819219] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  221.819219] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  221.819219]  ffffffff8209cc80 ffff8800372eb968 ffffffff8159266c 00000000000011cf
[  221.819219]  ffffffff820f2840 ffff8800372eb9b8 ffffffff8158e0ce ffff8800372eb9a8
[  221.819219]  ffffffff82485ff0 ffff8800372e2490 ffff8800372e2e68 ffff8800372e2490
[  221.819219] Call Trace:
[  221.819219]  [<ffffffff8159266c>] dump_stack+0x4e/0x68
[  221.819219]  [<ffffffff8158e0ce>] print_circular_bug+0x1f8/0x209
[  221.819219]  [<ffffffff810a088a>] __lock_acquire+0xb3b/0xe41
[  221.819219]  [<ffffffff811d4ad8>] ? kernfs_remove_by_name_ns+0x70/0x8c
[  221.819219]  [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  221.819219]  [<ffffffff811d4ad8>] ? kernfs_remove_by_name_ns+0x70/0x8c
[  221.819219]  [<ffffffff811d3f97>] __kernfs_remove+0x169/0x2be
[  221.819219]  [<ffffffff811d4ad8>] ? kernfs_remove_by_name_ns+0x70/0x8c
[  221.819219]  [<ffffffff811d3412>] ? kernfs_find_ns+0xdc/0x104
[  221.819219]  [<ffffffff811d4ad8>] kernfs_remove_by_name_ns+0x70/0x8c
[  221.819219]  [<ffffffff811d604c>] sysfs_remove_file_ns+0x15/0x17
[  221.819219]  [<ffffffff8138143e>] device_remove_file+0x19/0x1b
[  221.819219]  [<ffffffff813814f6>] device_remove_attrs+0x2e/0x68
[  221.819219]  [<ffffffff81381658>] device_del+0x128/0x187
[  221.819219]  [<ffffffff813816ff>] device_unregister+0x48/0x54
[  221.819219]  [<ffffffff81387366>] unregister_cpu+0x39/0x55
[  221.819219]  [<ffffffff81008c03>] arch_unregister_cpu+0x23/0x28
[  221.819219]  [<ffffffff812f7a75>] acpi_processor_remove+0x91/0xca
[  221.819219]  [<ffffffff812f51d1>] acpi_bus_trim+0x5a/0x8d
[  221.819219]  [<ffffffff812f71c6>] acpi_device_hotplug+0x301/0x3ff
[  221.819219]  [<ffffffff812f0760>] acpi_hotplug_work_fn+0x20/0x2d
[  221.819219]  [<ffffffff81078ff5>] process_one_work+0x207/0x375
[  221.819219]  [<ffffffff81078f4d>] ? process_one_work+0x15f/0x375
[  221.819219]  [<ffffffff8107944f>] worker_thread+0x2bd/0x329
[  221.819219]  [<ffffffff81079192>] ? process_scheduled_works+0x2f/0x2f
[  221.819219]  [<ffffffff8107ef6e>] kthread+0xba/0xc2
[  221.819219]  [<ffffffff810a1511>] ? trace_hardirqs_on+0xd/0xf
[  221.819219]  [<ffffffff8107eeb4>] ? __init_kthread_worker+0x59/0x59
[  221.819219]  [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  221.819219]  [<ffffffff8107eeb4>] ? __init_kthread_worker+0x59/0x59
