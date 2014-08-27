Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaH0HVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:21:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:34322 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaH0HV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:21:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="590443097"
Message-ID: <53FD8613.4050700@intel.com>
Date: Wed, 27 Aug 2014 15:17:39 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [acpi/osl] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
References: <20140827022709.GA22064@localhost>
In-Reply-To: <20140827022709.GA22064@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月27日 10:27, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

Hi Fengguang:

Thanks for report. I reworked the patch and just sent out V3 to umap
memory regions in a work to avoid the dead lock. I tested the patch with
your script and the issue doesn't reproduce.

> 
> commit b11bc0be2f115a90949f1c26379f1288c8cde531
> Author:     Lan Tianyu <tianyu.lan@intel.com>
> AuthorDate: Tue Aug 26 01:54:34 2014 +0200
> Commit:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> CommitDate: Tue Aug 26 01:54:34 2014 +0200
> 
>     ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
>     
>     Deadlock is possible when CPU hotplug and evaluating ACPI method happen
>     at the same time.
>     
>     During CPU hotplug, acpi_cpu_soft_notify() is called under the CPU hotplug
>     lock.  Then, acpi_cpu_soft_notify() calls acpi_bus_get_device() to obtain
>     the struct acpi_device attached to the given ACPI handle.  The ACPICA's
>     namespace lock will be acquired by acpi_bus_get_device() in the process.
>     Thus it is possible to hold the ACPICA's namespace lock under the CPU
>     hotplug lock.
>     
>     Evaluating an ACPI method may involve accessing an operation region in
>     system memory and the associated address space will be unmapped under
>     the ACPICA's namespace lock after completing the access. Currently, osl.c
>     uses RCU to protect memory ranges used by AML.  When unmapping them it
>     calls synchronize_rcu() in acpi_os_map_cleanup(), but that blocks
>     CPU hotplug by acquiring the CPU hotplug lock.  Thus it is possible to
>     hold the CPU hotplug lock under the ACPICA's namespace lock.
>     
>     This leads to deadlocks like the following one if AML accessing operation
>     regions in memory is executed in parallel with CPU hotplug.
>     
>     INFO: task bash:741 blocked for more than 30 seconds.
>           Not tainted 3.16.0-rc5+ #671
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     bash            D ffff88014e214140     0   741    716 0x00000080
>      ffff88009b9f3a10 0000000000000086 ffff88009dcfb840 ffff88009b9f3fd8
>      0000000000014140 0000000000014140 ffffffff81c18460 ffffffff81c40fc8
>      ffffffff81c40fcc ffff88009dcfb840 00000000ffffffff ffffffff81c40fd0
>     Call Trace:
>      [<ffffffff817a1b29>] schedule_preempt_disabled+0x29/0x70
>      [<ffffffff817a34fa>] __mutex_lock_slowpath+0xca/0x1c0
>      [<ffffffff817a360f>] mutex_lock+0x1f/0x2f
>      [<ffffffff810bc8cc>] get_online_cpus+0x2c/0x50
>      [<ffffffff8111bbd4>] synchronize_sched_expedited+0x64/0x1c0
>      [<ffffffff8111bb65>] synchronize_sched+0x45/0x50
>      [<ffffffff81431498>] acpi_os_map_cleanup.part.7+0x14/0x3e
>      [<ffffffff81795c54>] acpi_os_unmap_iomem+0xe2/0xea
>      [<ffffffff81795c6a>] acpi_os_unmap_memory+0xe/0x14
>      [<ffffffff814459bc>] acpi_ev_system_memory_region_setup+0x2d/0x97
>      [<ffffffff81459504>] acpi_ut_update_ref_count+0x24d/0x2de
>      [<ffffffff814596af>] acpi_ut_update_object_reference+0x11a/0x18b
>      [<ffffffff81459282>] acpi_ut_remove_reference+0x2e/0x31
>      [<ffffffff8144ffdf>] acpi_ns_detach_object+0x7b/0x80
>      [<ffffffff8144ef11>] acpi_ns_delete_namespace_subtree+0x47/0x81
>      [<ffffffff81440488>] acpi_ds_terminate_control_method+0x85/0x11b
>      [<ffffffff81454625>] acpi_ps_parse_aml+0x164/0x289
>      [<ffffffff81454da6>] acpi_ps_execute_method+0x1c1/0x26c
>      [<ffffffff8144f764>] acpi_ns_evaluate+0x1c1/0x258
>      [<ffffffff81451f86>] acpi_evaluate_object+0x126/0x22f
>      [<ffffffff8144d1ac>] acpi_hw_execute_sleep_method+0x3d/0x68
>      [<ffffffff8144d5cf>] ? acpi_hw_enable_all_runtime_gpes+0x17/0x19
>      [<ffffffff8144deb0>] acpi_hw_legacy_wake+0x4d/0x9d
>      [<ffffffff8144e599>] acpi_hw_sleep_dispatch+0x2a/0x2c
>      [<ffffffff8144e5cb>] acpi_leave_sleep_state+0x17/0x19
>      [<ffffffff8143335c>] acpi_pm_finish+0x3f/0x99
>      [<ffffffff81108c49>] suspend_devices_and_enter+0x139/0x560
>      [<ffffffff81109162>] pm_suspend+0xf2/0x370
>      [<ffffffff81107e69>] state_store+0x79/0xf0
>      [<ffffffff813bc4af>] kobj_attr_store+0xf/0x20
>      [<ffffffff81284f3d>] sysfs_kf_write+0x3d/0x50
>      [<ffffffff81284580>] kernfs_fop_write+0xe0/0x160
>      [<ffffffff81210f47>] vfs_write+0xb7/0x1f0
>      [<ffffffff81211ae6>] SyS_write+0x46/0xb0
>      [<ffffffff8114d986>] ? __audit_syscall_exit+0x1f6/0x2a0
>      [<ffffffff817a4ea9>] system_call_fastpath+0x16/0x1b
>     INFO: task async-enable-no:749 blocked for more than 30 seconds.
>           Not tainted 3.16.0-rc5+ #671
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     async-enable-no D ffff88014e254140     0   749      2 0x00000080
>      ffff88009de83bf0 0000000000000046 ffff88009b850000 ffff88009de83fd8
>      0000000000014140 0000000000014140 ffff880148305dc0 ffff880149804160
>      7fffffffffffffff 0000000000000002 0000000000000000 ffff88009b850000
>     Call Trace:
>      [<ffffffff817a1689>] schedule+0x29/0x70
>      [<ffffffff817a0b49>] schedule_timeout+0x1f9/0x270
>      [<ffffffff81284bfe>] ? __kernfs_create_file+0x7e/0xa0
>      [<ffffffff8128546b>] ? sysfs_add_file_mode_ns+0x9b/0x160
>      [<ffffffff817a36b2>] __down_common+0x93/0xd8
>      [<ffffffff817a376a>] __down_timeout+0x16/0x18
>      [<ffffffff8110546c>] down_timeout+0x4c/0x60
>      [<ffffffff81431f97>] acpi_os_wait_semaphore+0x43/0x57
>      [<ffffffff8145a8f4>] acpi_ut_acquire_mutex+0x48/0x88
>      [<ffffffff81435d1b>] ? acpi_match_device+0x4f/0x4f
>      [<ffffffff8145250f>] acpi_get_data_full+0x3a/0x8e
>      [<ffffffff81435b30>] acpi_bus_get_device+0x23/0x40
>      [<ffffffff8145d839>] acpi_cpu_soft_notify+0x50/0xe6
>      [<ffffffff810e1ddc>] notifier_call_chain+0x4c/0x70
>      [<ffffffff810e1eee>] __raw_notifier_call_chain+0xe/0x10
>      [<ffffffff810bc993>] cpu_notify+0x23/0x50
>      [<ffffffff810bcb98>] _cpu_up+0x168/0x180
>      [<ffffffff810bcc5c>] _cpu_up_with_trace+0x2c/0xe0
>      [<ffffffff810bd050>] ? disable_nonboot_cpus+0x1c0/0x1c0
>      [<ffffffff810bd06f>] async_enable_nonboot_cpus+0x1f/0x70
>      [<ffffffff810dda02>] kthread+0xd2/0xf0
>      [<ffffffff810dd930>] ? insert_kthread_work+0x40/0x40
>      [<ffffffff817a4dfc>] ret_from_fork+0x7c/0xb0
>     
>     To avoid such deadlocks, modify acpi_os_map_cleanup() to use call_rcu()
>     for the unmapping of memory regions that aren't used any more.
>     
>     Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>     [rjw: Subject and changelog.]
>     Cc: All applicable <stable@vger.kernel.org>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> +----------------------------------------------+-----------+------------+
> |                                              | v3.17-rc2 | b11bc0be2f |
> +----------------------------------------------+-----------+------------+
> | boot_successes                               | 60        | 0          |
> | boot_failures                                | 0         | 20         |
> | inconsistent_SOFTIRQ-ON-W-IN-SOFTIRQ-R_usage | 0         | 20         |
> | backtrace:pci_arch_init                      | 0         | 20         |
> | backtrace:kernel_init_freeable               | 0         | 20         |
> | backtrace:smpboot_thread_fn                  | 0         | 18         |
> | backtrace:bdi_register                       | 0         | 1          |
> | backtrace:default_bdi_init                   | 0         | 1          |
> | backtrace:register_sysrq_key                 | 0         | 1          |
> | backtrace:pm_sysrq_init                      | 0         | 1          |
> +----------------------------------------------+-----------+------------+
> 
> [    0.079000] 3.17.0-rc2-00001-gb11bc0b #7 Not tainted
> [    0.079000] ---------------------------------
> [    0.079000] ---------------------------------
> [    0.079000] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
> [    0.079000] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
> [    0.079000] ksoftirqd/0/3 [HC0[0]:SC1[3]:HE1:SE0] takes:
> [    0.079000] ksoftirqd/0/3 [HC0[0]:SC1[3]:HE1:SE0] takes:
> [    0.079000]  (
> [    0.079000]  (resource_lockresource_lock){+++?..}){+++?..}, at: , at: [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
> [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
> [    0.079000] {SOFTIRQ-ON-W} state was registered at:
> [    0.079000] {SOFTIRQ-ON-W} state was registered at:
> [    0.079000]   
> [    0.079000]   [<ffffffff810ee014>] __lock_acquire+0x584/0x20d0
> [<ffffffff810ee014>] __lock_acquire+0x584/0x20d0
> [    0.079000]   
> [    0.079000]   [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
> [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
> [    0.079000]   
> [    0.079000]   [<ffffffff81997e78>] _raw_write_lock+0x38/0x70
> [<ffffffff81997e78>] _raw_write_lock+0x38/0x70
> [    0.079000]   
> [    0.079000]   [<ffffffff810c3c9d>] __request_region+0xad/0x170
> [<ffffffff810c3c9d>] __request_region+0xad/0x170
> [    0.079000]   
> [    0.079000]   [<ffffffff8235cee4>] pci_direct_probe+0x36/0x20f
> [<ffffffff8235cee4>] pci_direct_probe+0x36/0x20f
> [    0.079000]   
> [    0.079000]   [<ffffffff8235cd65>] pci_arch_init+0xa/0x5a
> [<ffffffff8235cd65>] pci_arch_init+0xa/0x5a
> [    0.079000]   
> [    0.079000]   [<ffffffff8232412a>] do_one_initcall+0x193/0x1a7
> [<ffffffff8232412a>] do_one_initcall+0x193/0x1a7
> [    0.079000]   
> [    0.079000]   [<ffffffff82324238>] kernel_init_freeable+0xfa/0x17f
> [<ffffffff82324238>] kernel_init_freeable+0xfa/0x17f
> [    0.079000]   
> [    0.079000]   [<ffffffff81979ee9>] kernel_init+0x9/0xf0
> [<ffffffff81979ee9>] kernel_init+0x9/0xf0
> [    0.079000]   
> [    0.079000]   [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
> [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
> [    0.079000] irq event stamp: 26
> [    0.079000] irq event stamp: 26
> [    0.079000] hardirqs last  enabled at (26): 
> [    0.079000] hardirqs last  enabled at (26): [<ffffffff810fd53e>] __rcu_process_callbacks+0x6e/0x170
> [<ffffffff810fd53e>] __rcu_process_callbacks+0x6e/0x170
> [    0.079000] hardirqs last disabled at (25): 
> [    0.079000] hardirqs last disabled at (25): [<ffffffff810fd500>] __rcu_process_callbacks+0x30/0x170
> [<ffffffff810fd500>] __rcu_process_callbacks+0x30/0x170
> [    0.079000] softirqs last  enabled at (0): 
> [    0.079000] softirqs last  enabled at (0): [<ffffffff810bcd7a>] copy_process.part.55+0x2ca/0x18f0
> [<ffffffff810bcd7a>] copy_process.part.55+0x2ca/0x18f0
> [    0.079000] softirqs last disabled at (23): 
> [    0.079000] softirqs last disabled at (23): [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
> [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
> [    0.079000] 
> [    0.079000] other info that might help us debug this:
> [    0.079000] 
> [    0.079000] other info that might help us debug this:
> [    0.079000]  Possible unsafe locking scenario:
> [    0.079000] 
> [    0.079000]  Possible unsafe locking scenario:
> [    0.079000] 
> [    0.079000]        CPU0
> [    0.079000]        CPU0
> [    0.079000]        ----
> [    0.079000]        ----
> [    0.079000]   lock(
> [    0.079000]   lock(resource_lockresource_lock);
> );
> [    0.079000]   <Interrupt>
> [    0.079000]   <Interrupt>
> [    0.079000]     lock(
> [    0.079000]     lock(resource_lockresource_lock);
> );
> [    0.079000] 
> [    0.079000]  *** DEADLOCK ***
> [    0.079000] 
> [    0.079000] 
> [    0.079000]  *** DEADLOCK ***
> [    0.079000] 
> [    0.079000] 1 lock held by ksoftirqd/0/3:
> [    0.079000] 1 lock held by ksoftirqd/0/3:
> [    0.079000]  #0: 
> [    0.079000]  #0:  ( (rcu_callbackrcu_callback){......}){......}, at: , at: [<ffffffff810fd594>] __rcu_process_callbacks+0xc4/0x170
> [<ffffffff810fd594>] __rcu_process_callbacks+0xc4/0x170
> [    0.079000] 
> [    0.079000] stack backtrace:
> [    0.079000] 
> [    0.079000] stack backtrace:
> [    0.079000] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc2-00001-gb11bc0b #7
> [    0.079000] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc2-00001-gb11bc0b #7
> [    0.079000]  ffffffff82b4b7b0
> [    0.079000]  ffffffff82b4b7b0 ffff880000063aa0 ffff880000063aa0 ffffffff81983dbe ffffffff81983dbe ffff880000063af0 ffff880000063af0
> 
> [    0.079000]  ffffffff819822d2
> [    0.079000]  ffffffff819822d2 0000000000000003 0000000000000003 ffff880000000001 ffff880000000001 ffff880000000000 ffff880000000000
> 
> [    0.079000]  0000000000000006
> [    0.079000]  0000000000000006 ffff88000005c7a8 ffff88000005c7a8 ffffffff810ea390 ffffffff810ea390 0000000000000005 0000000000000005
> 
> [    0.079000] Call Trace:
> [    0.079000] Call Trace:
> [    0.079000]  [<ffffffff81983dbe>] dump_stack+0x19/0x1b
> [    0.079000]  [<ffffffff81983dbe>] dump_stack+0x19/0x1b
> [    0.079000]  [<ffffffff819822d2>] print_usage_bug.part.39+0x283/0x292
> [    0.079000]  [<ffffffff819822d2>] print_usage_bug.part.39+0x283/0x292
> [    0.079000]  [<ffffffff810ea390>] ? check_usage_backwards+0x150/0x150
> [    0.079000]  [<ffffffff810ea390>] ? check_usage_backwards+0x150/0x150
> [    0.079000]  [<ffffffff810eaf97>] mark_lock+0x267/0x6d0
> [    0.079000]  [<ffffffff810eaf97>] mark_lock+0x267/0x6d0
> [    0.079000]  [<ffffffff810edf12>] __lock_acquire+0x482/0x20d0
> [    0.079000]  [<ffffffff810edf12>] __lock_acquire+0x482/0x20d0
> [    0.079000]  [<ffffffff810049b5>] ? dump_trace+0x185/0x2f0
> [    0.079000]  [<ffffffff810049b5>] ? dump_trace+0x185/0x2f0
> [    0.079000]  [<ffffffff81010025>] ? save_stack_trace+0x25/0x40
> [    0.079000]  [<ffffffff81010025>] ? save_stack_trace+0x25/0x40
> [    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
> [    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
> [    0.079000]  [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
> [    0.079000]  [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
> [    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
> [    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
> [    0.079000]  [<ffffffff81997afb>] _raw_read_lock+0x3b/0x70
> [    0.079000]  [<ffffffff81997afb>] _raw_read_lock+0x3b/0x70
> [    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
> [    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
> [    0.079000]  [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
> [    0.079000]  [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
> [    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
> [    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
> [    0.079000]  [<ffffffff810c34ff>] walk_system_ram_range+0x7f/0xd0
> [    0.079000]  [<ffffffff810c34ff>] walk_system_ram_range+0x7f/0xd0
> [    0.079000]  [<ffffffff813f80a8>] ? acpi_os_execute_deferred+0x1b/0x1b
> [    0.079000]  [<ffffffff813f80a8>] ? acpi_os_execute_deferred+0x1b/0x1b
> [    0.079000]  [<ffffffff810c3567>] page_is_ram+0x17/0x40
> [    0.079000]  [<ffffffff810c3567>] page_is_ram+0x17/0x40
> [    0.079000]  [<ffffffff813f80c4>] acpi_os_map_reclaim+0x1c/0x35
> [    0.079000]  [<ffffffff813f80c4>] acpi_os_map_reclaim+0x1c/0x35
> [    0.079000]  [<ffffffff810fd5e7>] __rcu_process_callbacks+0x117/0x170
> [    0.079000]  [<ffffffff810fd5e7>] __rcu_process_callbacks+0x117/0x170
> [    0.079000]  [<ffffffff810fd594>] ? __rcu_process_callbacks+0xc4/0x170
> [    0.079000]  [<ffffffff810fd594>] ? __rcu_process_callbacks+0xc4/0x170
> [    0.079000]  [<ffffffff810fd650>] rcu_process_callbacks+0x10/0x20
> [    0.079000]  [<ffffffff810fd650>] rcu_process_callbacks+0x10/0x20
> [    0.079000]  [<ffffffff810c21f1>] __do_softirq+0x121/0x2b0
> [    0.079000]  [<ffffffff810c21f1>] __do_softirq+0x121/0x2b0
> [    0.079000]  [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
> [    0.079000]  [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
> [    0.079000]  [<ffffffff810df1e5>] smpboot_thread_fn+0xf5/0x180
> [    0.079000]  [<ffffffff810df1e5>] smpboot_thread_fn+0xf5/0x180
> [    0.079000]  [<ffffffff810df0f0>] ? in_egroup_p+0x40/0x40
> [    0.079000]  [<ffffffff810df0f0>] ? in_egroup_p+0x40/0x40
> [    0.079000]  [<ffffffff810db808>] kthread+0xf8/0x110
> [    0.079000]  [<ffffffff810db808>] kthread+0xf8/0x110
> [    0.079000]  [<ffffffff81993dfa>] ? wait_for_common+0x11a/0x160
> [    0.079000]  [<ffffffff81993dfa>] ? wait_for_common+0x11a/0x160
> [    0.079000]  [<ffffffff810e03e5>] ? finish_task_switch.constprop.50+0x45/0x100
> [    0.079000]  [<ffffffff810e03e5>] ? finish_task_switch.constprop.50+0x45/0x100
> [    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
> [    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
> [    0.079000]  [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
> [    0.079000]  [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
> [    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
> [    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
> [    0.079372] Running resizable hashtable tests...
> [    0.079372] Running resizable hashtable tests...
> [    0.080012]   Adding 2048 keys
> 
> git bisect start bf040f9c8492b6e7aaaa5bc593c7e9693a9c606a 52addcf9d6669fa439387610bc65c92fa0980cef --
> git bisect  bad 5cfd0a20f8c8b6f192aebd9c3f536319e106e433  # 02:06      0-      1  Merge 'stericsson/msm-cleanup' into devel-hourly-2014082622
> git bisect good e39c483fdb0adda238e37d2bc80c20f7fe183600  # 02:10     20+      0  Merge 'luto/checkpatch' into devel-hourly-2014082622
> git bisect good 49c47bbe5cc0366fa83f53898cdd87d0c1c01b34  # 02:32     20+      0  Merge 'pwm/for-next' into devel-hourly-2014082622
> git bisect  bad b998605a177da25ec3c5285b9cdad0cc5aaf6fa3  # 02:37      0-     20  Merge 'pm/bleeding-edge' into devel-hourly-2014082622
> git bisect good 3afd0fcabfcec5e0d9164c91508eedd495674974  # 02:42     20+      0  Merge 'm68knommu/for-next' into devel-hourly-2014082622
> git bisect good 21a6f663b9172a50b0634a889501a520964b8155  # 02:47     20+      0  Merge 'char-misc/char-misc-linus' into devel-hourly-2014082622
> git bisect good ab3c20f55f3e8fc487f8db1fd83a43c429524789  # 02:51     20+      0  Merge 'cifs/for-linus' into devel-hourly-2014082622
> git bisect  bad 90bf325c80978287390e17c24d84e909fc138c8c  # 02:54      0-      5  Merge branches 'acpi-scan', 'acpi-osl', 'acpi-ec' and 'acpi-lpss' into bleeding-edge
> git bisect good 236105db632c6279a020f78c83e22eaef746006b  # 03:02     20+      0  ACPI: Run fixed event device notifications in process context
> git bisect good 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4  # 03:04     20+      0  ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC
> git bisect  bad b11bc0be2f115a90949f1c26379f1288c8cde531  # 03:07      0-     20  ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
> # first bad commit: [b11bc0be2f115a90949f1c26379f1288c8cde531] ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
> git bisect good 52addcf9d6669fa439387610bc65c92fa0980cef  # 03:09     60+      0  Linux 3.17-rc2
> git bisect  bad bf040f9c8492b6e7aaaa5bc593c7e9693a9c606a  # 03:09      0-     11  0day head guard for 'devel-hourly-2014082622'
> git bisect good 52addcf9d6669fa439387610bc65c92fa0980cef  # 03:09     60+      0  Linux 3.17-rc2
> git bisect good 1c9e4561f3b2afffcda007eae9d0ddd25525f50e  # 03:17     60+      0  Add linux-next specific files for 20140826
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-enable-kvm
> 	-cpu Haswell,+smep,+smap
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 1
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang
> 


-- 
Best regards
Tianyu Lan
