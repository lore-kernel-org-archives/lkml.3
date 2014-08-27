Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaH0C1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:27:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:56189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602AbaH0C06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:26:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,408,1406617200"; 
   d="scan'208";a="582161998"
Date: Wed, 27 Aug 2014 10:27:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [acpi/osl] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
Message-ID: <20140827022709.GA22064@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

commit b11bc0be2f115a90949f1c26379f1288c8cde531
Author:     Lan Tianyu <tianyu.lan@intel.com>
AuthorDate: Tue Aug 26 01:54:34 2014 +0200
Commit:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
CommitDate: Tue Aug 26 01:54:34 2014 +0200

    ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
    
    Deadlock is possible when CPU hotplug and evaluating ACPI method happen
    at the same time.
    
    During CPU hotplug, acpi_cpu_soft_notify() is called under the CPU hotplug
    lock.  Then, acpi_cpu_soft_notify() calls acpi_bus_get_device() to obtain
    the struct acpi_device attached to the given ACPI handle.  The ACPICA's
    namespace lock will be acquired by acpi_bus_get_device() in the process.
    Thus it is possible to hold the ACPICA's namespace lock under the CPU
    hotplug lock.
    
    Evaluating an ACPI method may involve accessing an operation region in
    system memory and the associated address space will be unmapped under
    the ACPICA's namespace lock after completing the access. Currently, osl.c
    uses RCU to protect memory ranges used by AML.  When unmapping them it
    calls synchronize_rcu() in acpi_os_map_cleanup(), but that blocks
    CPU hotplug by acquiring the CPU hotplug lock.  Thus it is possible to
    hold the CPU hotplug lock under the ACPICA's namespace lock.
    
    This leads to deadlocks like the following one if AML accessing operation
    regions in memory is executed in parallel with CPU hotplug.
    
    INFO: task bash:741 blocked for more than 30 seconds.
          Not tainted 3.16.0-rc5+ #671
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    bash            D ffff88014e214140     0   741    716 0x00000080
     ffff88009b9f3a10 0000000000000086 ffff88009dcfb840 ffff88009b9f3fd8
     0000000000014140 0000000000014140 ffffffff81c18460 ffffffff81c40fc8
     ffffffff81c40fcc ffff88009dcfb840 00000000ffffffff ffffffff81c40fd0
    Call Trace:
     [<ffffffff817a1b29>] schedule_preempt_disabled+0x29/0x70
     [<ffffffff817a34fa>] __mutex_lock_slowpath+0xca/0x1c0
     [<ffffffff817a360f>] mutex_lock+0x1f/0x2f
     [<ffffffff810bc8cc>] get_online_cpus+0x2c/0x50
     [<ffffffff8111bbd4>] synchronize_sched_expedited+0x64/0x1c0
     [<ffffffff8111bb65>] synchronize_sched+0x45/0x50
     [<ffffffff81431498>] acpi_os_map_cleanup.part.7+0x14/0x3e
     [<ffffffff81795c54>] acpi_os_unmap_iomem+0xe2/0xea
     [<ffffffff81795c6a>] acpi_os_unmap_memory+0xe/0x14
     [<ffffffff814459bc>] acpi_ev_system_memory_region_setup+0x2d/0x97
     [<ffffffff81459504>] acpi_ut_update_ref_count+0x24d/0x2de
     [<ffffffff814596af>] acpi_ut_update_object_reference+0x11a/0x18b
     [<ffffffff81459282>] acpi_ut_remove_reference+0x2e/0x31
     [<ffffffff8144ffdf>] acpi_ns_detach_object+0x7b/0x80
     [<ffffffff8144ef11>] acpi_ns_delete_namespace_subtree+0x47/0x81
     [<ffffffff81440488>] acpi_ds_terminate_control_method+0x85/0x11b
     [<ffffffff81454625>] acpi_ps_parse_aml+0x164/0x289
     [<ffffffff81454da6>] acpi_ps_execute_method+0x1c1/0x26c
     [<ffffffff8144f764>] acpi_ns_evaluate+0x1c1/0x258
     [<ffffffff81451f86>] acpi_evaluate_object+0x126/0x22f
     [<ffffffff8144d1ac>] acpi_hw_execute_sleep_method+0x3d/0x68
     [<ffffffff8144d5cf>] ? acpi_hw_enable_all_runtime_gpes+0x17/0x19
     [<ffffffff8144deb0>] acpi_hw_legacy_wake+0x4d/0x9d
     [<ffffffff8144e599>] acpi_hw_sleep_dispatch+0x2a/0x2c
     [<ffffffff8144e5cb>] acpi_leave_sleep_state+0x17/0x19
     [<ffffffff8143335c>] acpi_pm_finish+0x3f/0x99
     [<ffffffff81108c49>] suspend_devices_and_enter+0x139/0x560
     [<ffffffff81109162>] pm_suspend+0xf2/0x370
     [<ffffffff81107e69>] state_store+0x79/0xf0
     [<ffffffff813bc4af>] kobj_attr_store+0xf/0x20
     [<ffffffff81284f3d>] sysfs_kf_write+0x3d/0x50
     [<ffffffff81284580>] kernfs_fop_write+0xe0/0x160
     [<ffffffff81210f47>] vfs_write+0xb7/0x1f0
     [<ffffffff81211ae6>] SyS_write+0x46/0xb0
     [<ffffffff8114d986>] ? __audit_syscall_exit+0x1f6/0x2a0
     [<ffffffff817a4ea9>] system_call_fastpath+0x16/0x1b
    INFO: task async-enable-no:749 blocked for more than 30 seconds.
          Not tainted 3.16.0-rc5+ #671
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    async-enable-no D ffff88014e254140     0   749      2 0x00000080
     ffff88009de83bf0 0000000000000046 ffff88009b850000 ffff88009de83fd8
     0000000000014140 0000000000014140 ffff880148305dc0 ffff880149804160
     7fffffffffffffff 0000000000000002 0000000000000000 ffff88009b850000
    Call Trace:
     [<ffffffff817a1689>] schedule+0x29/0x70
     [<ffffffff817a0b49>] schedule_timeout+0x1f9/0x270
     [<ffffffff81284bfe>] ? __kernfs_create_file+0x7e/0xa0
     [<ffffffff8128546b>] ? sysfs_add_file_mode_ns+0x9b/0x160
     [<ffffffff817a36b2>] __down_common+0x93/0xd8
     [<ffffffff817a376a>] __down_timeout+0x16/0x18
     [<ffffffff8110546c>] down_timeout+0x4c/0x60
     [<ffffffff81431f97>] acpi_os_wait_semaphore+0x43/0x57
     [<ffffffff8145a8f4>] acpi_ut_acquire_mutex+0x48/0x88
     [<ffffffff81435d1b>] ? acpi_match_device+0x4f/0x4f
     [<ffffffff8145250f>] acpi_get_data_full+0x3a/0x8e
     [<ffffffff81435b30>] acpi_bus_get_device+0x23/0x40
     [<ffffffff8145d839>] acpi_cpu_soft_notify+0x50/0xe6
     [<ffffffff810e1ddc>] notifier_call_chain+0x4c/0x70
     [<ffffffff810e1eee>] __raw_notifier_call_chain+0xe/0x10
     [<ffffffff810bc993>] cpu_notify+0x23/0x50
     [<ffffffff810bcb98>] _cpu_up+0x168/0x180
     [<ffffffff810bcc5c>] _cpu_up_with_trace+0x2c/0xe0
     [<ffffffff810bd050>] ? disable_nonboot_cpus+0x1c0/0x1c0
     [<ffffffff810bd06f>] async_enable_nonboot_cpus+0x1f/0x70
     [<ffffffff810dda02>] kthread+0xd2/0xf0
     [<ffffffff810dd930>] ? insert_kthread_work+0x40/0x40
     [<ffffffff817a4dfc>] ret_from_fork+0x7c/0xb0
    
    To avoid such deadlocks, modify acpi_os_map_cleanup() to use call_rcu()
    for the unmapping of memory regions that aren't used any more.
    
    Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
    [rjw: Subject and changelog.]
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

+----------------------------------------------+-----------+------------+
|                                              | v3.17-rc2 | b11bc0be2f |
+----------------------------------------------+-----------+------------+
| boot_successes                               | 60        | 0          |
| boot_failures                                | 0         | 20         |
| inconsistent_SOFTIRQ-ON-W-IN-SOFTIRQ-R_usage | 0         | 20         |
| backtrace:pci_arch_init                      | 0         | 20         |
| backtrace:kernel_init_freeable               | 0         | 20         |
| backtrace:smpboot_thread_fn                  | 0         | 18         |
| backtrace:bdi_register                       | 0         | 1          |
| backtrace:default_bdi_init                   | 0         | 1          |
| backtrace:register_sysrq_key                 | 0         | 1          |
| backtrace:pm_sysrq_init                      | 0         | 1          |
+----------------------------------------------+-----------+------------+

[    0.079000] 3.17.0-rc2-00001-gb11bc0b #7 Not tainted
[    0.079000] ---------------------------------
[    0.079000] ---------------------------------
[    0.079000] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
[    0.079000] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
[    0.079000] ksoftirqd/0/3 [HC0[0]:SC1[3]:HE1:SE0] takes:
[    0.079000] ksoftirqd/0/3 [HC0[0]:SC1[3]:HE1:SE0] takes:
[    0.079000]  (
[    0.079000]  (resource_lockresource_lock){+++?..}){+++?..}, at: , at: [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[    0.079000] {SOFTIRQ-ON-W} state was registered at:
[    0.079000] {SOFTIRQ-ON-W} state was registered at:
[    0.079000]   
[    0.079000]   [<ffffffff810ee014>] __lock_acquire+0x584/0x20d0
[<ffffffff810ee014>] __lock_acquire+0x584/0x20d0
[    0.079000]   
[    0.079000]   [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[    0.079000]   
[    0.079000]   [<ffffffff81997e78>] _raw_write_lock+0x38/0x70
[<ffffffff81997e78>] _raw_write_lock+0x38/0x70
[    0.079000]   
[    0.079000]   [<ffffffff810c3c9d>] __request_region+0xad/0x170
[<ffffffff810c3c9d>] __request_region+0xad/0x170
[    0.079000]   
[    0.079000]   [<ffffffff8235cee4>] pci_direct_probe+0x36/0x20f
[<ffffffff8235cee4>] pci_direct_probe+0x36/0x20f
[    0.079000]   
[    0.079000]   [<ffffffff8235cd65>] pci_arch_init+0xa/0x5a
[<ffffffff8235cd65>] pci_arch_init+0xa/0x5a
[    0.079000]   
[    0.079000]   [<ffffffff8232412a>] do_one_initcall+0x193/0x1a7
[<ffffffff8232412a>] do_one_initcall+0x193/0x1a7
[    0.079000]   
[    0.079000]   [<ffffffff82324238>] kernel_init_freeable+0xfa/0x17f
[<ffffffff82324238>] kernel_init_freeable+0xfa/0x17f
[    0.079000]   
[    0.079000]   [<ffffffff81979ee9>] kernel_init+0x9/0xf0
[<ffffffff81979ee9>] kernel_init+0x9/0xf0
[    0.079000]   
[    0.079000]   [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[    0.079000] irq event stamp: 26
[    0.079000] irq event stamp: 26
[    0.079000] hardirqs last  enabled at (26): 
[    0.079000] hardirqs last  enabled at (26): [<ffffffff810fd53e>] __rcu_process_callbacks+0x6e/0x170
[<ffffffff810fd53e>] __rcu_process_callbacks+0x6e/0x170
[    0.079000] hardirqs last disabled at (25): 
[    0.079000] hardirqs last disabled at (25): [<ffffffff810fd500>] __rcu_process_callbacks+0x30/0x170
[<ffffffff810fd500>] __rcu_process_callbacks+0x30/0x170
[    0.079000] softirqs last  enabled at (0): 
[    0.079000] softirqs last  enabled at (0): [<ffffffff810bcd7a>] copy_process.part.55+0x2ca/0x18f0
[<ffffffff810bcd7a>] copy_process.part.55+0x2ca/0x18f0
[    0.079000] softirqs last disabled at (23): 
[    0.079000] softirqs last disabled at (23): [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[    0.079000] 
[    0.079000] other info that might help us debug this:
[    0.079000] 
[    0.079000] other info that might help us debug this:
[    0.079000]  Possible unsafe locking scenario:
[    0.079000] 
[    0.079000]  Possible unsafe locking scenario:
[    0.079000] 
[    0.079000]        CPU0
[    0.079000]        CPU0
[    0.079000]        ----
[    0.079000]        ----
[    0.079000]   lock(
[    0.079000]   lock(resource_lockresource_lock);
);
[    0.079000]   <Interrupt>
[    0.079000]   <Interrupt>
[    0.079000]     lock(
[    0.079000]     lock(resource_lockresource_lock);
);
[    0.079000] 
[    0.079000]  *** DEADLOCK ***
[    0.079000] 
[    0.079000] 
[    0.079000]  *** DEADLOCK ***
[    0.079000] 
[    0.079000] 1 lock held by ksoftirqd/0/3:
[    0.079000] 1 lock held by ksoftirqd/0/3:
[    0.079000]  #0: 
[    0.079000]  #0:  ( (rcu_callbackrcu_callback){......}){......}, at: , at: [<ffffffff810fd594>] __rcu_process_callbacks+0xc4/0x170
[<ffffffff810fd594>] __rcu_process_callbacks+0xc4/0x170
[    0.079000] 
[    0.079000] stack backtrace:
[    0.079000] 
[    0.079000] stack backtrace:
[    0.079000] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc2-00001-gb11bc0b #7
[    0.079000] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc2-00001-gb11bc0b #7
[    0.079000]  ffffffff82b4b7b0
[    0.079000]  ffffffff82b4b7b0 ffff880000063aa0 ffff880000063aa0 ffffffff81983dbe ffffffff81983dbe ffff880000063af0 ffff880000063af0

[    0.079000]  ffffffff819822d2
[    0.079000]  ffffffff819822d2 0000000000000003 0000000000000003 ffff880000000001 ffff880000000001 ffff880000000000 ffff880000000000

[    0.079000]  0000000000000006
[    0.079000]  0000000000000006 ffff88000005c7a8 ffff88000005c7a8 ffffffff810ea390 ffffffff810ea390 0000000000000005 0000000000000005

[    0.079000] Call Trace:
[    0.079000] Call Trace:
[    0.079000]  [<ffffffff81983dbe>] dump_stack+0x19/0x1b
[    0.079000]  [<ffffffff81983dbe>] dump_stack+0x19/0x1b
[    0.079000]  [<ffffffff819822d2>] print_usage_bug.part.39+0x283/0x292
[    0.079000]  [<ffffffff819822d2>] print_usage_bug.part.39+0x283/0x292
[    0.079000]  [<ffffffff810ea390>] ? check_usage_backwards+0x150/0x150
[    0.079000]  [<ffffffff810ea390>] ? check_usage_backwards+0x150/0x150
[    0.079000]  [<ffffffff810eaf97>] mark_lock+0x267/0x6d0
[    0.079000]  [<ffffffff810eaf97>] mark_lock+0x267/0x6d0
[    0.079000]  [<ffffffff810edf12>] __lock_acquire+0x482/0x20d0
[    0.079000]  [<ffffffff810edf12>] __lock_acquire+0x482/0x20d0
[    0.079000]  [<ffffffff810049b5>] ? dump_trace+0x185/0x2f0
[    0.079000]  [<ffffffff810049b5>] ? dump_trace+0x185/0x2f0
[    0.079000]  [<ffffffff81010025>] ? save_stack_trace+0x25/0x40
[    0.079000]  [<ffffffff81010025>] ? save_stack_trace+0x25/0x40
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[    0.079000]  [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff81997afb>] _raw_read_lock+0x3b/0x70
[    0.079000]  [<ffffffff81997afb>] _raw_read_lock+0x3b/0x70
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810c34ff>] walk_system_ram_range+0x7f/0xd0
[    0.079000]  [<ffffffff810c34ff>] walk_system_ram_range+0x7f/0xd0
[    0.079000]  [<ffffffff813f80a8>] ? acpi_os_execute_deferred+0x1b/0x1b
[    0.079000]  [<ffffffff813f80a8>] ? acpi_os_execute_deferred+0x1b/0x1b
[    0.079000]  [<ffffffff810c3567>] page_is_ram+0x17/0x40
[    0.079000]  [<ffffffff810c3567>] page_is_ram+0x17/0x40
[    0.079000]  [<ffffffff813f80c4>] acpi_os_map_reclaim+0x1c/0x35
[    0.079000]  [<ffffffff813f80c4>] acpi_os_map_reclaim+0x1c/0x35
[    0.079000]  [<ffffffff810fd5e7>] __rcu_process_callbacks+0x117/0x170
[    0.079000]  [<ffffffff810fd5e7>] __rcu_process_callbacks+0x117/0x170
[    0.079000]  [<ffffffff810fd594>] ? __rcu_process_callbacks+0xc4/0x170
[    0.079000]  [<ffffffff810fd594>] ? __rcu_process_callbacks+0xc4/0x170
[    0.079000]  [<ffffffff810fd650>] rcu_process_callbacks+0x10/0x20
[    0.079000]  [<ffffffff810fd650>] rcu_process_callbacks+0x10/0x20
[    0.079000]  [<ffffffff810c21f1>] __do_softirq+0x121/0x2b0
[    0.079000]  [<ffffffff810c21f1>] __do_softirq+0x121/0x2b0
[    0.079000]  [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[    0.079000]  [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[    0.079000]  [<ffffffff810df1e5>] smpboot_thread_fn+0xf5/0x180
[    0.079000]  [<ffffffff810df1e5>] smpboot_thread_fn+0xf5/0x180
[    0.079000]  [<ffffffff810df0f0>] ? in_egroup_p+0x40/0x40
[    0.079000]  [<ffffffff810df0f0>] ? in_egroup_p+0x40/0x40
[    0.079000]  [<ffffffff810db808>] kthread+0xf8/0x110
[    0.079000]  [<ffffffff810db808>] kthread+0xf8/0x110
[    0.079000]  [<ffffffff81993dfa>] ? wait_for_common+0x11a/0x160
[    0.079000]  [<ffffffff81993dfa>] ? wait_for_common+0x11a/0x160
[    0.079000]  [<ffffffff810e03e5>] ? finish_task_switch.constprop.50+0x45/0x100
[    0.079000]  [<ffffffff810e03e5>] ? finish_task_switch.constprop.50+0x45/0x100
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079000]  [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[    0.079000]  [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079372] Running resizable hashtable tests...
[    0.079372] Running resizable hashtable tests...
[    0.080012]   Adding 2048 keys

git bisect start bf040f9c8492b6e7aaaa5bc593c7e9693a9c606a 52addcf9d6669fa439387610bc65c92fa0980cef --
git bisect  bad 5cfd0a20f8c8b6f192aebd9c3f536319e106e433  # 02:06      0-      1  Merge 'stericsson/msm-cleanup' into devel-hourly-2014082622
git bisect good e39c483fdb0adda238e37d2bc80c20f7fe183600  # 02:10     20+      0  Merge 'luto/checkpatch' into devel-hourly-2014082622
git bisect good 49c47bbe5cc0366fa83f53898cdd87d0c1c01b34  # 02:32     20+      0  Merge 'pwm/for-next' into devel-hourly-2014082622
git bisect  bad b998605a177da25ec3c5285b9cdad0cc5aaf6fa3  # 02:37      0-     20  Merge 'pm/bleeding-edge' into devel-hourly-2014082622
git bisect good 3afd0fcabfcec5e0d9164c91508eedd495674974  # 02:42     20+      0  Merge 'm68knommu/for-next' into devel-hourly-2014082622
git bisect good 21a6f663b9172a50b0634a889501a520964b8155  # 02:47     20+      0  Merge 'char-misc/char-misc-linus' into devel-hourly-2014082622
git bisect good ab3c20f55f3e8fc487f8db1fd83a43c429524789  # 02:51     20+      0  Merge 'cifs/for-linus' into devel-hourly-2014082622
git bisect  bad 90bf325c80978287390e17c24d84e909fc138c8c  # 02:54      0-      5  Merge branches 'acpi-scan', 'acpi-osl', 'acpi-ec' and 'acpi-lpss' into bleeding-edge
git bisect good 236105db632c6279a020f78c83e22eaef746006b  # 03:02     20+      0  ACPI: Run fixed event device notifications in process context
git bisect good 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4  # 03:04     20+      0  ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC
git bisect  bad b11bc0be2f115a90949f1c26379f1288c8cde531  # 03:07      0-     20  ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
# first bad commit: [b11bc0be2f115a90949f1c26379f1288c8cde531] ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
git bisect good 52addcf9d6669fa439387610bc65c92fa0980cef  # 03:09     60+      0  Linux 3.17-rc2
git bisect  bad bf040f9c8492b6e7aaaa5bc593c7e9693a9c606a  # 03:09      0-     11  0day head guard for 'devel-hourly-2014082622'
git bisect good 52addcf9d6669fa439387610bc65c92fa0980cef  # 03:09     60+      0  Linux 3.17-rc2
git bisect good 1c9e4561f3b2afffcda007eae9d0ddd25525f50e  # 03:17     60+      0  Add linux-next specific files for 20140826


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-14:20140827030448:x86_64-randconfig-hsxa0-08270944:3.17.0-rc2-00001-gb11bc0b:7"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.17.0-rc2-00001-gb11bc0b (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #7 Wed Aug 27 11:05:42 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsxa0-08270944/linux-devel:devel-hourly-2014082622:b11bc0be2f115a90949=
f1c26379f1288c8cde531:bisect-linux/.vmlinuz-b11bc0be2f115a90949f1c26379f128=
8c8cde531-20140827110549-10-kbuild branch=3Dlinux-devel/devel-hourly-201408=
2622 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa0-08270944/b11bc0be2f115a90=
949f1c26379f1288c8cde531/vmlinuz-3.17.0-rc2-00001-gb11bc0b drbd.minor_count=
=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x031a0000, 0x031a0fff] PGTABLE
[    0.000000] BRK [0x031a1000, 0x031a1fff] PGTABLE
[    0.000000] BRK [0x031a2000, 0x031a2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x031a3000, 0x031a3fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD9A0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2037ec0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsxa0-08270944/linux-devel:devel-hourly-2014082622:b11bc0be2f11=
5a90949f1c26379f1288c8cde531:bisect-linux/.vmlinuz-b11bc0be2f115a90949f1c26=
379f1288c8cde531-20140827110549-10-kbuild branch=3Dlinux-devel/devel-hourly=
-2014082622 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa0-08270944/b11bc0be2=
f115a90949f1c26379f1288c8cde531/vmlinuz-3.17.0-rc2-00001-gb11bc0b drbd.mino=
r_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 282280K/327280K available (9843K kernel code, 3207K =
rwdata, 4176K rodata, 736K init, 14100K bss, 45000K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Linux version 3.17.0-rc2-00001-gb11bc0b (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #7 Wed Aug 27 11:05:42 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsxa0-08270944/linux-devel:devel-hourly-2014082622:b11bc0be2f115a90949=
f1c26379f1288c8cde531:bisect-linux/.vmlinuz-b11bc0be2f115a90949f1c26379f128=
8c8cde531-20140827110549-10-kbuild branch=3Dlinux-devel/devel-hourly-201408=
2622 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa0-08270944/b11bc0be2f115a90=
949f1c26379f1288c8cde531/vmlinuz-3.17.0-rc2-00001-gb11bc0b drbd.minor_count=
=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x031a0000, 0x031a0fff] PGTABLE
[    0.000000] BRK [0x031a1000, 0x031a1fff] PGTABLE
[    0.000000] BRK [0x031a2000, 0x031a2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x031a3000, 0x031a3fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD9A0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2037ec0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsxa0-08270944/linux-devel:devel-hourly-2014082622:b11bc0be2f11=
5a90949f1c26379f1288c8cde531:bisect-linux/.vmlinuz-b11bc0be2f115a90949f1c26=
379f1288c8cde531-20140827110549-10-kbuild branch=3Dlinux-devel/devel-hourly=
-2014082622 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa0-08270944/b11bc0be2=
f115a90949f1c26379f1288c8cde531/vmlinuz-3.17.0-rc2-00001-gb11bc0b drbd.mino=
r_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 282280K/327280K available (9843K kernel code, 3207K =
rwdata, 4176K rodata, 736K init, 14100K bss, 45000K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5386.90 Bogo=
MIPS (lpj=3D2693452)
5386.90 BogoMIPS (lpj=3D2693452)
[    0.004004] pid_max: default: 32768 minimum: 301
[    0.004004] pid_max: default: 32768 minimum: 301
[    0.005034] ACPI: Core revision 20140724
[    0.005034] ACPI: Core revision 20140724
[    0.007759] ACPI:=20
[    0.007759] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.008732] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.008732] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.009009] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.009009] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.010460] mce: CPU supports 10 MCE banks
[    0.010460] mce: CPU supports 10 MCE banks
[    0.011045] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.011045] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.011045] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.011045] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.012004] CPU:=20
[    0.012004] CPU: Intel Core Processor (Haswell)Intel Core Processor (Has=
well) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
, stepping: 01)
[    0.018117] Performance Events:=20
[    0.018117] Performance Events: unsupported p6 CPU model 60 unsupported =
p6 CPU model 60 no PMU driver, software events only.
no PMU driver, software events only.
[    0.021378] Getting VERSION: 1050014
[    0.021378] Getting VERSION: 1050014
[    0.022014] Getting VERSION: 1050014
[    0.022014] Getting VERSION: 1050014
[    0.023013] Getting ID: 0
[    0.023013] Getting ID: 0
[    0.024012] Getting ID: ff000000
[    0.024012] Getting ID: ff000000
[    0.024616] Getting LVT0: 8700
[    0.024616] Getting LVT0: 8700
[    0.025006] Getting LVT1: 8400
[    0.025006] Getting LVT1: 8400
[    0.026012] enabled ExtINT on CPU#0
[    0.026012] enabled ExtINT on CPU#0
[    0.027859] ENABLING IO-APIC IRQs
[    0.027859] ENABLING IO-APIC IRQs
[    0.028023] init IO_APIC IRQs
[    0.028023] init IO_APIC IRQs
[    0.029007]  apic 0 pin 0 not connected
[    0.029007]  apic 0 pin 0 not connected
[    0.030042] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.030042] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.031043] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.031043] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.032061] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.032061] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.033035] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.033035] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.034023] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.034023] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.035037] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.035037] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.036022] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.036022] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.037020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.037020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.038020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.038020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.039021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.039021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.040020] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.040020] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.041020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.041020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.042020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.042020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.043020] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.043020] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045010] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.045010] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046017]  apic 0 pin 16 not connected
[    0.046017]  apic 0 pin 16 not connected
[    0.047003]  apic 0 pin 17 not connected
[    0.047003]  apic 0 pin 17 not connected
[    0.048003]  apic 0 pin 18 not connected
[    0.048003]  apic 0 pin 18 not connected
[    0.048714]  apic 0 pin 19 not connected
[    0.048714]  apic 0 pin 19 not connected
[    0.049003]  apic 0 pin 20 not connected
[    0.049003]  apic 0 pin 20 not connected
[    0.050003]  apic 0 pin 21 not connected
[    0.050003]  apic 0 pin 21 not connected
[    0.051003]  apic 0 pin 22 not connected
[    0.051003]  apic 0 pin 22 not connected
[    0.052003]  apic 0 pin 23 not connected
[    0.052003]  apic 0 pin 23 not connected
[    0.052860] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.052860] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.053037] TSC deadline timer enabled
[    0.053037] TSC deadline timer enabled
[    0.054000] devtmpfs: initialized
[    0.054000] devtmpfs: initialized
[    0.057050] regulator-dummy: no parameters
[    0.057050] regulator-dummy: no parameters
[    0.058400] NET: Registered protocol family 16
[    0.058400] NET: Registered protocol family 16
[    0.059623] cpuidle: using governor menu
[    0.059623] cpuidle: using governor menu
[    0.060436] ACPI: bus type PCI registered
[    0.060436] ACPI: bus type PCI registered
[    0.061079] PCI: Using configuration type 1 for base access
[    0.061079] PCI: Using configuration type 1 for base access
[    0.078675]=20
[    0.078675]=20
[    0.078965] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.078965] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.079000] [ INFO: inconsistent lock state ]
[    0.079000] [ INFO: inconsistent lock state ]
[    0.079000] 3.17.0-rc2-00001-gb11bc0b #7 Not tainted
[    0.079000] 3.17.0-rc2-00001-gb11bc0b #7 Not tainted
[    0.079000] ---------------------------------
[    0.079000] ---------------------------------
[    0.079000] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
[    0.079000] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
[    0.079000] ksoftirqd/0/3 [HC0[0]:SC1[3]:HE1:SE0] takes:
[    0.079000] ksoftirqd/0/3 [HC0[0]:SC1[3]:HE1:SE0] takes:
[    0.079000]  (
[    0.079000]  (resource_lockresource_lock){+++?..}){+++?..}, at: , at: [<=
ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[    0.079000] {SOFTIRQ-ON-W} state was registered at:
[    0.079000] {SOFTIRQ-ON-W} state was registered at:
[    0.079000]  =20
[    0.079000]   [<ffffffff810ee014>] __lock_acquire+0x584/0x20d0
[<ffffffff810ee014>] __lock_acquire+0x584/0x20d0
[    0.079000]  =20
[    0.079000]   [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[    0.079000]  =20
[    0.079000]   [<ffffffff81997e78>] _raw_write_lock+0x38/0x70
[<ffffffff81997e78>] _raw_write_lock+0x38/0x70
[    0.079000]  =20
[    0.079000]   [<ffffffff810c3c9d>] __request_region+0xad/0x170
[<ffffffff810c3c9d>] __request_region+0xad/0x170
[    0.079000]  =20
[    0.079000]   [<ffffffff8235cee4>] pci_direct_probe+0x36/0x20f
[<ffffffff8235cee4>] pci_direct_probe+0x36/0x20f
[    0.079000]  =20
[    0.079000]   [<ffffffff8235cd65>] pci_arch_init+0xa/0x5a
[<ffffffff8235cd65>] pci_arch_init+0xa/0x5a
[    0.079000]  =20
[    0.079000]   [<ffffffff8232412a>] do_one_initcall+0x193/0x1a7
[<ffffffff8232412a>] do_one_initcall+0x193/0x1a7
[    0.079000]  =20
[    0.079000]   [<ffffffff82324238>] kernel_init_freeable+0xfa/0x17f
[<ffffffff82324238>] kernel_init_freeable+0xfa/0x17f
[    0.079000]  =20
[    0.079000]   [<ffffffff81979ee9>] kernel_init+0x9/0xf0
[<ffffffff81979ee9>] kernel_init+0x9/0xf0
[    0.079000]  =20
[    0.079000]   [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[    0.079000] irq event stamp: 26
[    0.079000] irq event stamp: 26
[    0.079000] hardirqs last  enabled at (26):=20
[    0.079000] hardirqs last  enabled at (26): [<ffffffff810fd53e>] __rcu_p=
rocess_callbacks+0x6e/0x170
[<ffffffff810fd53e>] __rcu_process_callbacks+0x6e/0x170
[    0.079000] hardirqs last disabled at (25):=20
[    0.079000] hardirqs last disabled at (25): [<ffffffff810fd500>] __rcu_p=
rocess_callbacks+0x30/0x170
[<ffffffff810fd500>] __rcu_process_callbacks+0x30/0x170
[    0.079000] softirqs last  enabled at (0):=20
[    0.079000] softirqs last  enabled at (0): [<ffffffff810bcd7a>] copy_pro=
cess.part.55+0x2ca/0x18f0
[<ffffffff810bcd7a>] copy_process.part.55+0x2ca/0x18f0
[    0.079000] softirqs last disabled at (23):=20
[    0.079000] softirqs last disabled at (23): [<ffffffff810c23bd>] run_kso=
ftirqd+0x3d/0x70
[<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[    0.079000]=20
[    0.079000] other info that might help us debug this:
[    0.079000]=20
[    0.079000] other info that might help us debug this:
[    0.079000]  Possible unsafe locking scenario:
[    0.079000]=20
[    0.079000]  Possible unsafe locking scenario:
[    0.079000]=20
[    0.079000]        CPU0
[    0.079000]        CPU0
[    0.079000]        ----
[    0.079000]        ----
[    0.079000]   lock(
[    0.079000]   lock(resource_lockresource_lock);
);
[    0.079000]   <Interrupt>
[    0.079000]   <Interrupt>
[    0.079000]     lock(
[    0.079000]     lock(resource_lockresource_lock);
);
[    0.079000]=20
[    0.079000]  *** DEADLOCK ***
[    0.079000]=20
[    0.079000]=20
[    0.079000]  *** DEADLOCK ***
[    0.079000]=20
[    0.079000] 1 lock held by ksoftirqd/0/3:
[    0.079000] 1 lock held by ksoftirqd/0/3:
[    0.079000]  #0:=20
[    0.079000]  #0:  ( (rcu_callbackrcu_callback){......}){......}, at: , a=
t: [<ffffffff810fd594>] __rcu_process_callbacks+0xc4/0x170
[<ffffffff810fd594>] __rcu_process_callbacks+0xc4/0x170
[    0.079000]=20
[    0.079000] stack backtrace:
[    0.079000]=20
[    0.079000] stack backtrace:
[    0.079000] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc2-00001=
-gb11bc0b #7
[    0.079000] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc2-00001=
-gb11bc0b #7
[    0.079000]  ffffffff82b4b7b0
[    0.079000]  ffffffff82b4b7b0 ffff880000063aa0 ffff880000063aa0 ffffffff=
81983dbe ffffffff81983dbe ffff880000063af0 ffff880000063af0

[    0.079000]  ffffffff819822d2
[    0.079000]  ffffffff819822d2 0000000000000003 0000000000000003 ffff8800=
00000001 ffff880000000001 ffff880000000000 ffff880000000000

[    0.079000]  0000000000000006
[    0.079000]  0000000000000006 ffff88000005c7a8 ffff88000005c7a8 ffffffff=
810ea390 ffffffff810ea390 0000000000000005 0000000000000005

[    0.079000] Call Trace:
[    0.079000] Call Trace:
[    0.079000]  [<ffffffff81983dbe>] dump_stack+0x19/0x1b
[    0.079000]  [<ffffffff81983dbe>] dump_stack+0x19/0x1b
[    0.079000]  [<ffffffff819822d2>] print_usage_bug.part.39+0x283/0x292
[    0.079000]  [<ffffffff819822d2>] print_usage_bug.part.39+0x283/0x292
[    0.079000]  [<ffffffff810ea390>] ? check_usage_backwards+0x150/0x150
[    0.079000]  [<ffffffff810ea390>] ? check_usage_backwards+0x150/0x150
[    0.079000]  [<ffffffff810eaf97>] mark_lock+0x267/0x6d0
[    0.079000]  [<ffffffff810eaf97>] mark_lock+0x267/0x6d0
[    0.079000]  [<ffffffff810edf12>] __lock_acquire+0x482/0x20d0
[    0.079000]  [<ffffffff810edf12>] __lock_acquire+0x482/0x20d0
[    0.079000]  [<ffffffff810049b5>] ? dump_trace+0x185/0x2f0
[    0.079000]  [<ffffffff810049b5>] ? dump_trace+0x185/0x2f0
[    0.079000]  [<ffffffff81010025>] ? save_stack_trace+0x25/0x40
[    0.079000]  [<ffffffff81010025>] ? save_stack_trace+0x25/0x40
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[    0.079000]  [<ffffffff810f04f6>] lock_acquire+0x86/0xe0
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff81997afb>] _raw_read_lock+0x3b/0x70
[    0.079000]  [<ffffffff81997afb>] _raw_read_lock+0x3b/0x70
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] ? find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2ed3>] find_next_iomem_res+0x43/0x130
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810c2aa0>] ? __request_resource+0x50/0x50
[    0.079000]  [<ffffffff810c34ff>] walk_system_ram_range+0x7f/0xd0
[    0.079000]  [<ffffffff810c34ff>] walk_system_ram_range+0x7f/0xd0
[    0.079000]  [<ffffffff813f80a8>] ? acpi_os_execute_deferred+0x1b/0x1b
[    0.079000]  [<ffffffff813f80a8>] ? acpi_os_execute_deferred+0x1b/0x1b
[    0.079000]  [<ffffffff810c3567>] page_is_ram+0x17/0x40
[    0.079000]  [<ffffffff810c3567>] page_is_ram+0x17/0x40
[    0.079000]  [<ffffffff813f80c4>] acpi_os_map_reclaim+0x1c/0x35
[    0.079000]  [<ffffffff813f80c4>] acpi_os_map_reclaim+0x1c/0x35
[    0.079000]  [<ffffffff810fd5e7>] __rcu_process_callbacks+0x117/0x170
[    0.079000]  [<ffffffff810fd5e7>] __rcu_process_callbacks+0x117/0x170
[    0.079000]  [<ffffffff810fd594>] ? __rcu_process_callbacks+0xc4/0x170
[    0.079000]  [<ffffffff810fd594>] ? __rcu_process_callbacks+0xc4/0x170
[    0.079000]  [<ffffffff810fd650>] rcu_process_callbacks+0x10/0x20
[    0.079000]  [<ffffffff810fd650>] rcu_process_callbacks+0x10/0x20
[    0.079000]  [<ffffffff810c21f1>] __do_softirq+0x121/0x2b0
[    0.079000]  [<ffffffff810c21f1>] __do_softirq+0x121/0x2b0
[    0.079000]  [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[    0.079000]  [<ffffffff810c23bd>] run_ksoftirqd+0x3d/0x70
[    0.079000]  [<ffffffff810df1e5>] smpboot_thread_fn+0xf5/0x180
[    0.079000]  [<ffffffff810df1e5>] smpboot_thread_fn+0xf5/0x180
[    0.079000]  [<ffffffff810df0f0>] ? in_egroup_p+0x40/0x40
[    0.079000]  [<ffffffff810df0f0>] ? in_egroup_p+0x40/0x40
[    0.079000]  [<ffffffff810db808>] kthread+0xf8/0x110
[    0.079000]  [<ffffffff810db808>] kthread+0xf8/0x110
[    0.079000]  [<ffffffff81993dfa>] ? wait_for_common+0x11a/0x160
[    0.079000]  [<ffffffff81993dfa>] ? wait_for_common+0x11a/0x160
[    0.079000]  [<ffffffff810e03e5>] ? finish_task_switch.constprop.50+0x45=
/0x100
[    0.079000]  [<ffffffff810e03e5>] ? finish_task_switch.constprop.50+0x45=
/0x100
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079000]  [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[    0.079000]  [<ffffffff819986ba>] ret_from_fork+0x7a/0xb0
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079000]  [<ffffffff810db710>] ? __kthread_parkme+0x70/0x70
[    0.079372] Running resizable hashtable tests...
[    0.079372] Running resizable hashtable tests...
[    0.080012]   Adding 2048 keys
[    0.080012]   Adding 2048 keys
[    0.080978]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.080978]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.081082]   Table expansion iteration 0...
[    0.081082]   Table expansion iteration 0...
[    0.081989]   Verifying lookups...
[    0.081989]   Verifying lookups...
[    0.082070]   Table expansion iteration 1...
[    0.082070]   Table expansion iteration 1...
[    0.083094]   Verifying lookups...
[    0.083094]   Verifying lookups...
[    0.083773]   Table expansion iteration 2...
[    0.083773]   Table expansion iteration 2...
[    0.084397]   Verifying lookups...
[    0.084397]   Verifying lookups...
[    0.085074]   Table expansion iteration 3...
[    0.085074]   Table expansion iteration 3...
[    0.086818]   Verifying lookups...
[    0.086818]   Verifying lookups...
[    0.087087]   Table shrinkage iteration 0...
[    0.087087]   Table shrinkage iteration 0...
[    0.087989]   Verifying lookups...
[    0.087989]   Verifying lookups...
[    0.088074]   Table shrinkage iteration 1...
[    0.088074]   Table shrinkage iteration 1...
[    0.088907]   Verifying lookups...
[    0.088907]   Verifying lookups...
[    0.089070]   Table shrinkage iteration 2...
[    0.089070]   Table shrinkage iteration 2...
[    0.089871]   Verifying lookups...
[    0.089871]   Verifying lookups...
[    0.090070]   Table shrinkage iteration 3...
[    0.090070]   Table shrinkage iteration 3...
[    0.090856]   Verifying lookups...
[    0.090856]   Verifying lookups...
[    0.091081]   Deleting 2048 keys
[    0.091081]   Deleting 2048 keys
[    0.092046] ACPI: Added _OSI(Module Device)
[    0.092046] ACPI: Added _OSI(Module Device)
[    0.092801] ACPI: Added _OSI(Processor Device)
[    0.092801] ACPI: Added _OSI(Processor Device)
[    0.093004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.093004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.093839] ACPI: Added _OSI(Processor Aggregator Device)
[    0.093839] ACPI: Added _OSI(Processor Aggregator Device)
[    0.096425] ACPI: Interpreter enabled
[    0.096425] ACPI: Interpreter enabled
[    0.097010] ACPI: (supports S0 S5)
[    0.097010] ACPI: (supports S0 S5)
[    0.097628] ACPI: Using IOAPIC for interrupt routing
[    0.097628] ACPI: Using IOAPIC for interrupt routing
[    0.098024] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.098024] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.102357] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.102357] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.103010] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.103010] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.104010] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.104010] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.105181] PCI host bridge to bus 0000:00
[    0.105181] PCI host bridge to bus 0000:00
[    0.105934] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.105934] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.106005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.106005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.107005] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.107005] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.108009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.108009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.109006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.109006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.110039] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.110039] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.111368] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.111368] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.112478] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.112478] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.115006] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.115006] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.116871] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.116871] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.117005] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.117005] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.118005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.118005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.119004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.119004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.120196] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.120196] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.121325] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.121325] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.122013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.122013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.123235] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.123235] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.125539] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.125539] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.127044] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.127044] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.133044] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.133044] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.134441] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.134441] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.135830] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.135830] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.136816] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.136816] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.140416] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.140416] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.141205] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.141205] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.142448] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.142448] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.145773] pci_bus 0000:00: on NUMA node 0
[    0.145773] pci_bus 0000:00: on NUMA node 0
[    0.146479] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.146479] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.147377] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.147377] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.148418] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.148418] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.149447] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.149447] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.150315] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.150315] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.151463] ACPI:=20
[    0.151463] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.152574] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.152574] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.153005] vgaarb: loaded
[    0.153005] vgaarb: loaded
[    0.153507] vgaarb: bridge control possible 0000:00:02.0
[    0.153507] vgaarb: bridge control possible 0000:00:02.0
[    0.154461] media: Linux media interface: v0.10
[    0.154461] media: Linux media interface: v0.10
[    0.155031] Linux video capture interface: v2.00
[    0.155031] Linux video capture interface: v2.00
[    0.155896] pps_core: LinuxPPS API ver. 1 registered
[    0.155896] pps_core: LinuxPPS API ver. 1 registered
[    0.156004] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.156004] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.157160] Advanced Linux Sound Architecture Driver Initialized.
[    0.157160] Advanced Linux Sound Architecture Driver Initialized.
[    0.158012] PCI: Using ACPI for IRQ routing
[    0.158012] PCI: Using ACPI for IRQ routing
[    0.158761] PCI: pci_cache_line_size set to 64 bytes
[    0.158761] PCI: pci_cache_line_size set to 64 bytes
[    0.159108] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.159108] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.160011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.160011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.161619] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.161619] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.162085] Switched to clocksource kvm-clock
[    0.162085] Switched to clocksource kvm-clock
[    0.162958] FS-Cache: Loaded
[    0.162958] FS-Cache: Loaded
[    0.163556] CacheFiles: Loaded
[    0.163556] CacheFiles: Loaded
[    0.164169] pnp: PnP ACPI init
[    0.164169] pnp: PnP ACPI init
[    0.164802] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.164802] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.166061] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.166061] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.167303] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.167303] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.168521] pnp 00:03: [dma 2]
[    0.168521] pnp 00:03: [dma 2]
[    0.169141] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.169141] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.170400] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.170400] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.171655] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.171655] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.172913] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.172913] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.174313] pnp: PnP ACPI: found 7 devices
[    0.174313] pnp: PnP ACPI: found 7 devices
[    0.180110] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.180110] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.181132] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.181132] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.182133] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.182133] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.183254] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.183254] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.184398] NET: Registered protocol family 1
[    0.184398] NET: Registered protocol family 1
[    0.185201] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.185201] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.186280] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.186280] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.187327] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.187327] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.188443] pci 0000:00:02.0: Boot video device
[    0.188443] pci 0000:00:02.0: Boot video device
[    0.189280] PCI: CLS 0 bytes, default 64
[    0.189280] PCI: CLS 0 bytes, default 64
[    0.190070] Unpacking initramfs...
[    0.190070] Unpacking initramfs...
[    0.244538] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.244538] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.252311] Machine check injector initialized
[    0.252311] Machine check injector initialized
[    0.253785] AVX version of gcm_enc/dec engaged.
[    0.253785] AVX version of gcm_enc/dec engaged.
[    0.254622] AES CTR mode by8 optimization enabled
[    0.254622] AES CTR mode by8 optimization enabled
[    0.255724] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    0.255724] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    0.257654] AVX2 or AES-NI instructions are not detected.
[    0.257654] AVX2 or AES-NI instructions are not detected.
[    0.258642] AVX2 instructions are not detected.
[    0.258642] AVX2 instructions are not detected.
[    0.259514] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.259514] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.262251] spin_lock-torture: Creating torture_shuffle task
[    0.262251] spin_lock-torture: Creating torture_shuffle task
[    0.263280] spin_lock-torture: Creating torture_stutter task
[    0.263280] spin_lock-torture: Creating torture_stutter task
[    0.264330] spin_lock-torture: torture_shuffle task started
[    0.264330] spin_lock-torture: torture_shuffle task started
[    0.265350] spin_lock-torture: Creating lock_torture_writer task
[    0.265350] spin_lock-torture: Creating lock_torture_writer task
[    0.266462] spin_lock-torture: torture_stutter task started
[    0.266462] spin_lock-torture: torture_stutter task started
[    0.267483] spin_lock-torture: Creating lock_torture_writer task
[    0.267483] spin_lock-torture: Creating lock_torture_writer task
[    0.268782] spin_lock-torture: lock_torture_writer task started
[    0.268782] spin_lock-torture: lock_torture_writer task started
[    0.269879] spin_lock-torture: Creating lock_torture_stats task
[    0.269879] spin_lock-torture: Creating lock_torture_stats task
[    0.270979] spin_lock-torture: lock_torture_writer task started
[    0.270979] spin_lock-torture: lock_torture_writer task started
[    0.272276] futex hash table entries: 256 (order: 2, 24576 bytes)
[    0.272276] futex hash table entries: 256 (order: 2, 24576 bytes)
[    0.273555] spin_lock-torture: lock_torture_stats task started
[    0.273555] spin_lock-torture: lock_torture_stats task started
[    0.274707] zpool: loaded
[    0.274707] zpool: loaded
[    0.275211] zbud: loaded
[    0.275211] zbud: loaded
[    0.275754] VFS: Disk quotas dquot_6.5.2
[    0.275754] VFS: Disk quotas dquot_6.5.2
[    0.276505] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.276505] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.277854] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    0.277854] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    0.278838] NILFS version 2 loaded
[    0.278838] NILFS version 2 loaded
[    0.279480] msgmni has been set to 557
[    0.279480] msgmni has been set to 557
[    0.281092] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.281092] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.282440] io scheduler noop registered (default)
[    0.282440] io scheduler noop registered (default)
[    0.283501] io scheduler deadline registered
[    0.283501] io scheduler deadline registered
[    0.284632] io scheduler cfq registered
[    0.284632] io scheduler cfq registered
[    0.285432] test_string_helpers: Running tests...
[    0.285432] test_string_helpers: Running tests...
[    0.286402] test_firmware: interface ready
[    0.286402] test_firmware: interface ready
[    0.287166] rbtree testing
[    0.287166] rbtree testing -> 9051 cycles
 -> 9051 cycles
[    0.650857] augmented rbtree testing
[    0.650857] augmented rbtree testing -> 11752 cycles
 -> 11752 cycles
[    1.134563] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.134563] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.136102] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    1.136102] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    1.137746] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    1.137746] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    1.139587] cpcihp_generic: not configured, disabling.
[    1.139587] cpcihp_generic: not configured, disabling.
[    1.140931] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.140931] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.143295] ipmi message handler version 39.2
[    1.143295] ipmi message handler version 39.2
[    1.144460] ipmi device interface
[    1.144460] ipmi device interface
[    1.145486] IPMI System Interface driver.
[    1.145486] IPMI System Interface driver.
[    1.146639] ipmi_si: Adding default-specified kcs state machine
[    1.146639] ipmi_si: Adding default-specified kcs state machine

[    1.148292] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.148292] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.150792] ipmi_si: Interface detection failed
[    1.150792] ipmi_si: Interface detection failed
[    1.152068] ipmi_si: Adding default-specified smic state machine
[    1.152068] ipmi_si: Adding default-specified smic state machine

[    1.153830] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.153830] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.156690] ipmi_si: Interface detection failed
[    1.156690] ipmi_si: Interface detection failed
[    1.157982] ipmi_si: Adding default-specified bt state machine
[    1.157982] ipmi_si: Adding default-specified bt state machine

[    1.159532] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.159532] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.162149] ipmi_si: Interface detection failed
[    1.162149] ipmi_si: Interface detection failed
[    1.163531] ipmi_si: Unable to find any System Interface(s)
[    1.163531] ipmi_si: Unable to find any System Interface(s)
[    1.165119] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.165119] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.167329] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.167329] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.169339] ACPI: Power Button [PWRF]
[    1.169339] ACPI: Power Button [PWRF]
[    1.171119] HDLC line discipline maxframe=3D4096
[    1.171119] HDLC line discipline maxframe=3D4096
[    1.172424] N_HDLC line discipline registered.
[    1.172424] N_HDLC line discipline registered.
[    1.173591] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.173591] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.175046] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.175046] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.202523] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.202523] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.205833] serial: Freescale lpuart driver
[    1.205833] serial: Freescale lpuart driver
[    1.207101] SyncLink GT
[    1.207101] SyncLink GT
[    1.207717] SyncLink GT, tty major#245
[    1.207717] SyncLink GT, tty major#245
[    1.208727] SyncLink GT no devices found
[    1.208727] SyncLink GT no devices found
[    1.209977] SyncLink MultiPort driver $Revision: 4.38 $
[    1.209977] SyncLink MultiPort driver $Revision: 4.38 $
[    1.217670] SyncLink MultiPort driver $Revision: 4.38 $, tty major#244
[    1.217670] SyncLink MultiPort driver $Revision: 4.38 $, tty major#244
[    1.219429] SyncLink serial driver $Revision: 4.38 $
[    1.219429] SyncLink serial driver $Revision: 4.38 $
[    1.227086] SyncLink serial driver $Revision: 4.38 $, tty major#243
[    1.227086] SyncLink serial driver $Revision: 4.38 $, tty major#243
[    1.228761] lp: driver loaded but no devices found
[    1.228761] lp: driver loaded but no devices found
[    1.229982] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.229982] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.231760] ac.o: No PCI boards found.
[    1.231760] ac.o: No PCI boards found.
[    1.232788] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.232788] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.234772] Non-volatile memory driver v1.3
[    1.234772] Non-volatile memory driver v1.3
[    1.236104] ppdev: user-space parallel port driver
[    1.236104] ppdev: user-space parallel port driver
[    1.237359] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.237359] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.238705] smapi::smapi_init, ERROR invalid usSmapiID
[    1.238705] smapi::smapi_init, ERROR invalid usSmapiID
[    1.240127] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.240127] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.242596] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.242596] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.244512] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.244512] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.246168] SyncLink PC Card driver $Revision: 4.34 $, tty major#242
[    1.246168] SyncLink PC Card driver $Revision: 4.34 $, tty major#242
[    1.247964] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.247964] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.250482] [drm] Initialized drm 1.1.0 20060810
[    1.250482] [drm] Initialized drm 1.1.0 20060810
[    1.251743] [drm] radeon kernel modesetting enabled.
[    1.251743] [drm] radeon kernel modesetting enabled.
[    1.253664] [TTM] Zone  kernel: Available graphics memory: 142696 kiB
[    1.253664] [TTM] Zone  kernel: Available graphics memory: 142696 kiB
[    1.255425] [TTM] Initializing pool allocator
[    1.255425] [TTM] Initializing pool allocator
[    1.256652] [TTM] Initializing DMA pool allocator
[    1.256652] [TTM] Initializing DMA pool allocator
[    1.258377] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[    1.258377] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[    1.260379] [drm] fb mappable at 0xFC000000
[    1.260379] [drm] fb mappable at 0xFC000000
[    1.261575] [drm] vram aper at 0xFC000000
[    1.261575] [drm] vram aper at 0xFC000000
[    1.262657] [drm] size 4194304
[    1.262657] [drm] size 4194304
[    1.263445] [drm] fb depth is 24
[    1.263445] [drm] fb depth is 24
[    1.264259] [drm]    pitch is 3072
[    1.264259] [drm]    pitch is 3072
[    1.265324] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.265324] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.267151] cirrus 0000:00:02.0: registered panic notifier
[    1.267151] cirrus 0000:00:02.0: registered panic notifier
[    1.268644] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    1.268644] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    1.270553] parport_pc 00:04: reported by Plug and Play ACPI
[    1.270553] parport_pc 00:04: reported by Plug and Play ACPI
[    1.271816] parport0: PC-style at 0x378
[    1.271816] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    1.354312] lp0: using parport0 (interrupt-driven).
[    1.354312] lp0: using parport0 (interrupt-driven).
[    1.355758] lp0: console ready
[    1.355758] lp0: console ready
[    1.357259] dummy-irq: no IRQ given.  Use irq=3DN
[    1.357259] dummy-irq: no IRQ given.  Use irq=3DN
[    1.358601] lkdtm: No crash points registered, enable through debugfs
[    1.358601] lkdtm: No crash points registered, enable through debugfs
[    1.360030] Phantom Linux Driver, version n0.9.8, init OK
[    1.360030] Phantom Linux Driver, version n0.9.8, init OK
[    1.361122] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.361122] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.362498] Guest personality initialized and is inactive
[    1.362498] Guest personality initialized and is inactive
[    1.363567] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    1.363567] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    1.364785] Initialized host personality
[    1.364785] Initialized host personality
[    1.365977] SSFDC read-only Flash Translation layer
[    1.365977] SSFDC read-only Flash Translation layer
[    1.367016] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    1.367016] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    1.368194] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    1.368194] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    1.369590] device id =3D 2440
[    1.369590] device id =3D 2440
[    1.370147] device id =3D 2480
[    1.370147] device id =3D 2480
[    1.370665] device id =3D 24c0
[    1.370665] device id =3D 24c0
[    1.371195] device id =3D 24d0
[    1.371195] device id =3D 24d0
[    1.371754] device id =3D 25a1
[    1.371754] device id =3D 25a1
[    1.372286] device id =3D 2670
[    1.372286] device id =3D 2670
[    1.372943] slram: not enough parameters.
[    1.372943] slram: not enough parameters.
[    1.373778] HSI/SSI char device loaded
[    1.373778] HSI/SSI char device loaded
[    1.374714] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.374714] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.376794] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.376794] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.377732] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.377732] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.427269] mousedev: PS/2 mouse device common for all mice
[    1.427269] mousedev: PS/2 mouse device common for all mice
[    1.428607] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.428607] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.430443] i2c /dev entries driver
[    1.430443] i2c /dev entries driver
[    1.431372] i2c-parport-light: adapter type unspecified
[    1.431372] i2c-parport-light: adapter type unspecified
[    1.432994] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    1.432994] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    1.434139] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    1.434139] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    1.435359] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[    1.435359] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[    1.436876] cx25821: driver version 0.0.106 loaded
[    1.436876] cx25821: driver version 0.0.106 loaded
[    1.437793] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    1.437793] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    1.440244] pps pps0: new PPS source ktimer
[    1.440244] pps pps0: new PPS source ktimer
[    1.441037] pps pps0: ktimer PPS source registered
[    1.441037] pps pps0: ktimer PPS source registered
[    1.441893] pps_parport: parallel port PPS client
[    1.441893] pps_parport: parallel port PPS client
[    1.442767] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    1.442767] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    1.444033] pps_parport: couldn't register with parport0
[    1.444033] pps_parport: couldn't register with parport0
[    1.444984] Driver for 1-wire Dallas network protocol.
[    1.444984] Driver for 1-wire Dallas network protocol.
[    1.445979] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.445979] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.449230] ledtrig-cpu: registered to indicate activity on CPUs
[    1.449230] ledtrig-cpu: registered to indicate activity on CPUs
[    1.450453] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.450453] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.453918]=20
[    1.453918] printing PIC contents
[    1.453918]=20
[    1.453918] printing PIC contents
[    1.454806] ... PIC  IMR: ffff
[    1.454806] ... PIC  IMR: ffff
[    1.455366] ... PIC  IRR: 1013
[    1.455366] ... PIC  IRR: 1013
[    1.455981] ... PIC  ISR: 0000
[    1.455981] ... PIC  ISR: 0000
[    1.456542] ... PIC ELCR: 0c00
[    1.456542] ... PIC ELCR: 0c00
[    1.457118] printing local APIC contents on CPU#0/0:
[    1.457118] printing local APIC contents on CPU#0/0:
[    1.458016] ... APIC ID:      00000000 (0)
[    1.458016] ... APIC ID:      00000000 (0)
[    1.458104] ... APIC VERSION: 01050014
[    1.458104] ... APIC VERSION: 01050014
[    1.458104] ... APIC TASKPRI: 00000000 (00)
[    1.458104] ... APIC TASKPRI: 00000000 (00)
[    1.458104] ... APIC PROCPRI: 00000000
[    1.458104] ... APIC PROCPRI: 00000000
[    1.458104] ... APIC LDR: 01000000
[    1.458104] ... APIC LDR: 01000000
[    1.458104] ... APIC DFR: ffffffff
[    1.458104] ... APIC DFR: ffffffff
[    1.458104] ... APIC SPIV: 000001ff
[    1.458104] ... APIC SPIV: 000001ff
[    1.458104] ... APIC ISR field:
[    1.458104] ... APIC ISR field:
[    1.458104] 00000000
[    1.458104] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.458104] ... APIC TMR field:
[    1.458104] ... APIC TMR field:
[    1.458104] 00000000
[    1.458104] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.458104] ... APIC IRR field:
[    1.458104] ... APIC IRR field:
[    1.458104] 00000000
[    1.458104] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    1.458104] ... APIC ESR: 00000000
[    1.458104] ... APIC ESR: 00000000
[    1.458104] ... APIC ICR: 00000831
[    1.458104] ... APIC ICR: 00000831
[    1.458104] ... APIC ICR2: 01000000
[    1.458104] ... APIC ICR2: 01000000
[    1.458104] ... APIC LVTT: 000400ef
[    1.458104] ... APIC LVTT: 000400ef
[    1.458104] ... APIC LVTPC: 00000400
[    1.458104] ... APIC LVTPC: 00000400
[    1.458104] ... APIC LVT0: 00010700
[    1.458104] ... APIC LVT0: 00010700
[    1.458104] ... APIC LVT1: 00000400
[    1.458104] ... APIC LVT1: 00000400
[    1.458104] ... APIC LVTERR: 000000fe
[    1.458104] ... APIC LVTERR: 000000fe
[    1.458104] ... APIC TMICT: 00000000
[    1.458104] ... APIC TMICT: 00000000
[    1.458104] ... APIC TMCCT: 00000000
[    1.458104] ... APIC TMCCT: 00000000
[    1.458104] ... APIC TDCR: 00000000
[    1.458104] ... APIC TDCR: 00000000
[    1.458104]=20
[    1.458104]=20
[    1.476808] number of MP IRQ sources: 15.
[    1.476808] number of MP IRQ sources: 15.
[    1.477551] number of IO-APIC #0 registers: 24.
[    1.477551] number of IO-APIC #0 registers: 24.
[    1.478456] testing the IO APIC.......................
[    1.478456] testing the IO APIC.......................
[    1.479818] IO APIC #0......
[    1.479818] IO APIC #0......
[    1.480365] .... register #00: 00000000
[    1.480365] .... register #00: 00000000
[    1.481064] .......    : physical APIC id: 00
[    1.481064] .......    : physical APIC id: 00
[    1.481861] .......    : Delivery Type: 0
[    1.481861] .......    : Delivery Type: 0
[    1.482603] .......    : LTS          : 0
[    1.482603] .......    : LTS          : 0
[    1.483365] .... register #01: 00170011
[    1.483365] .... register #01: 00170011
[    1.484091] .......     : max redirection entries: 17
[    1.484091] .......     : max redirection entries: 17
[    1.484988] .......     : PRQ implemented: 0
[    1.484988] .......     : PRQ implemented: 0
[    1.485783] .......     : IO APIC version: 11
[    1.485783] .......     : IO APIC version: 11
[    1.486592] .... register #02: 00000000
[    1.486592] .... register #02: 00000000
[    1.487298] .......     : arbitration: 00
[    1.487298] .......     : arbitration: 00
[    1.488028] .... IRQ redirection table:
[    1.488028] .... IRQ redirection table:
[    1.488745] 1    0    0   0   0    0    0    00
[    1.488745] 1    0    0   0   0    0    0    00
[    1.489585] 0    0    0   0   0    1    1    31
[    1.489585] 0    0    0   0   0    1    1    31
[    1.490435] 0    0    0   0   0    1    1    30
[    1.490435] 0    0    0   0   0    1    1    30
[    1.491258] 0    0    0   0   0    1    1    33
[    1.491258] 0    0    0   0   0    1    1    33
[    1.492110] 1    0    0   0   0    1    1    34
[    1.492110] 1    0    0   0   0    1    1    34
[    1.493078] 1    1    0   0   0    1    1    35
[    1.493078] 1    1    0   0   0    1    1    35
[    1.493911] 0    0    0   0   0    1    1    36
[    1.493911] 0    0    0   0   0    1    1    36
[    1.494748] 0    0    0   0   0    1    1    37
[    1.494748] 0    0    0   0   0    1    1    37
[    1.495574] 0    0    0   0   0    1    1    38
[    1.495574] 0    0    0   0   0    1    1    38
[    1.496405] 0    1    0   0   0    1    1    39
[    1.496405] 0    1    0   0   0    1    1    39
[    1.497296] 1    1    0   0   0    1    1    3A
[    1.497296] 1    1    0   0   0    1    1    3A
[    1.498295] 1    1    0   0   0    1    1    3B
[    1.498295] 1    1    0   0   0    1    1    3B
[    1.499154] 0    0    0   0   0    1    1    3C
[    1.499154] 0    0    0   0   0    1    1    3C
[    1.499998] 0    0    0   0   0    1    1    3D
[    1.499998] 0    0    0   0   0    1    1    3D
[    1.500861] 0    0    0   0   0    1    1    3E
[    1.500861] 0    0    0   0   0    1    1    3E
[    1.501691] 0    0    0   0   0    1    1    3F
[    1.501691] 0    0    0   0   0    1    1    3F
[    1.502528] 1    0    0   0   0    0    0    00
[    1.502528] 1    0    0   0   0    0    0    00
[    1.503391] 1    0    0   0   0    0    0    00
[    1.503391] 1    0    0   0   0    0    0    00
[    1.504250] 1    0    0   0   0    0    0    00
[    1.504250] 1    0    0   0   0    0    0    00
[    1.505083] 1    0    0   0   0    0    0    00
[    1.505083] 1    0    0   0   0    0    0    00
[    1.505917] 1    0    0   0   0    0    0    00
[    1.505917] 1    0    0   0   0    0    0    00
[    1.506776] 1    0    0   0   0    0    0    00
[    1.506776] 1    0    0   0   0    0    0    00
[    1.507619] 1    0    0   0   0    0    0    00
[    1.507619] 1    0    0   0   0    0    0    00
[    1.508451] 1    0    0   0   0    0    0    00
[    1.508451] 1    0    0   0   0    0    0    00
[    1.509299] IRQ to pin mappings:
[    1.509299] IRQ to pin mappings:
[    1.509920] IRQ0=20
[    1.509920] IRQ0 -> 0:2-> 0:2

[    1.510401] IRQ1=20
[    1.510401] IRQ1 -> 0:1-> 0:1

[    1.510872] IRQ3=20
[    1.510872] IRQ3 -> 0:3-> 0:3

[    1.511350] IRQ4=20
[    1.511350] IRQ4 -> 0:4-> 0:4

[    1.511816] IRQ5=20
[    1.511816] IRQ5 -> 0:5-> 0:5

[    1.512300] IRQ6=20
[    1.512300] IRQ6 -> 0:6-> 0:6

[    1.512793] IRQ7=20
[    1.512793] IRQ7 -> 0:7-> 0:7

[    1.513282] IRQ8=20
[    1.513282] IRQ8 -> 0:8-> 0:8

[    1.513783] IRQ9=20
[    1.513783] IRQ9 -> 0:9-> 0:9

[    1.514268] IRQ10=20
[    1.514268] IRQ10 -> 0:10-> 0:10

[    1.514765] IRQ11=20
[    1.514765] IRQ11 -> 0:11-> 0:11

[    1.515281] IRQ12=20
[    1.515281] IRQ12 -> 0:12-> 0:12

[    1.515807] IRQ13=20
[    1.515807] IRQ13 -> 0:13-> 0:13

[    1.516332] IRQ14=20
[    1.516332] IRQ14 -> 0:14-> 0:14

[    1.516826] IRQ15=20
[    1.516826] IRQ15 -> 0:15-> 0:15

[    1.517338] .................................... done.
[    1.517338] .................................... done.
[    1.518465] bootconsole [earlyser0] disabled
[    1.518465] bootconsole [earlyser0] disabled
[    1.519716] saa7134 ALSA driver for DMA sound loaded
[    1.520196] saa7134 ALSA: no saa7134 cards found
[    1.520622] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.521176] EDD information not available.
[    1.521555] ALSA device list:
[    1.521859]   No soundcards found.
[    1.523592] Freeing unused kernel memory: 736K (ffffffff82323000 - fffff=
fff823db000)
[    1.524342] Write protecting the kernel read-only data: 16384k
[    1.526155] Freeing unused kernel memory: 384K (ffff8800019a0000 - ffff8=
80001a00000)
[    1.531822] Freeing unused kernel memory: 1968K (ffff880001e14000 - ffff=
880002000000)
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
mount: mounting none on /dev failed: Invalid argument
udevd[186]: inotify_init failed: Function not implemented
error initializing inotify
udevd[186]: error initializing inotify
error sending message: Connection refused
udevadm[187]: error sending message: Connection refused
error sending message: Connection refused
udevadm[189]: error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
/etc/init.d/rc: eval: line 1: can't create /dev/tty0: No such device or add=
ress
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
sed: /lib/modules/3.17.0-rc2-00001-gb11bc0b/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
/etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: /etc/kernel-tests/90-trinity: line 16: /trini=
ty: not found
line 17: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 15: /trinity: not found
[    2.042390] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   60.274075] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
wfg: skip syslogd
Deconfiguring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting...=20
[   68.707493] Unregister pv shared memory for cpu 0
[   68.708808] spin_lock-torture: Unscheduled system shutdown detected
[   68.711459] reboot: Restarting system
[   68.712389] reboot: machine restart
Elapsed time: 75
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-hsxa0-08270944/b11bc0be2f115a90949f1c26379f1288c8cde531/vmli=
nuz-3.17.0-rc2-00001-gb11bc0b -append 'hung_task_panic=3D1 earlyprintk=3Dtt=
yS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_t=
imeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpa=
nic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtt=
y0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86=
_64-randconfig-hsxa0-08270944/linux-devel:devel-hourly-2014082622:b11bc0be2=
f115a90949f1c26379f1288c8cde531:bisect-linux/.vmlinuz-b11bc0be2f115a90949f1=
c26379f1288c8cde531-20140827110549-10-kbuild branch=3Dlinux-devel/devel-hou=
rly-2014082622 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa0-08270944/b11bc0=
be2f115a90949f1c26379f1288c8cde531/vmlinuz-3.17.0-rc2-00001-gb11bc0b drbd.m=
inor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 3=
20 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3D=
nc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kb=
oot/pid-yocto-kbuild-14 -serial file:/dev/shm/kboot/serial-yocto-kbuild-14 =
-daemonize -display none -monitor null=20

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc2-00001-gb11bc0b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc2 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_X86_16BIT is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
# CONFIG_MTD_UBI is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_MAX8998 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TWL4030_MADC is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEOBUF2_DMA_SG=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_CX25821_ALSA=y
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
# CONFIG_VIDEO_SAA7134_DVB is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
# CONFIG_DVB_PLUTO2 is not set
# CONFIG_DVB_PT1 is not set
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_SOC_CAMERA=y
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
# CONFIG_PLATFORM_SI4713 is not set
CONFIG_I2C_SI4713=y
CONFIG_RADIO_MAXIRADIO=y
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7640 is not set
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=y
CONFIG_VIDEO_AS3645A=y
CONFIG_VIDEO_LM3560=y
CONFIG_VIDEO_LM3646=y

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=y
CONFIG_SOC_CAMERA_MT9M001=y
CONFIG_SOC_CAMERA_MT9M111=y
CONFIG_SOC_CAMERA_MT9T031=y
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=y
# CONFIG_SOC_CAMERA_OV2640 is not set
CONFIG_SOC_CAMERA_OV5642=y
CONFIG_SOC_CAMERA_OV6650=y
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=y
CONFIG_SOC_CAMERA_OV9740=y
CONFIG_SOC_CAMERA_RJ54N1=y
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_SI2157 is not set
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
# CONFIG_DVB_STV090x is not set
CONFIG_DVB_STV6110x=y
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y
CONFIG_DVB_SI2165=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=y
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
# CONFIG_DVB_STB6000 is not set
CONFIG_DVB_STV0299=y
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=y
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_CX24117=y
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=y
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
# CONFIG_DVB_DRXD is not set
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=y
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set
# CONFIG_DVB_RTL2832 is not set
CONFIG_DVB_SI2168=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=y
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
# CONFIG_DVB_A8293 is not set
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=y
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_PTN3460 is not set
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_VX_LIB=y
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
# CONFIG_SND_DICE is not set
CONFIG_SND_FIREWIRE_SPEAKERS=y
# CONFIG_SND_ISIGHT is not set
CONFIG_SND_SCS1X=y
CONFIG_SND_FIREWORKS=y
# CONFIG_SND_BEBOB is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_PALMAS=y
CONFIG_EXTCON_SM5502=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_MMA8452=y
CONFIG_KXCJK1013=y

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD799X=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
# CONFIG_MCP3422 is not set
# CONFIG_MEN_Z188_ADC is not set
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
CONFIG_TWL4030_MADC=y
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Humidity sensors
#
CONFIG_DHT11=y
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_ISL29125=y
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3414=y
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL115=y
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_T5403=y

#
# Lightning sensors
#

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=y
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_ST_SPEAR1310_MIPHY=y
CONFIG_PHY_ST_SPEAR1340_MIPHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_THUNDERBOLT=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
CONFIG_TEST_RHASHTABLE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
# CONFIG_CRYPTO_DEV_CCP_CRYPTO is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

--J/dobhs11T7y2rNN--
