Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaICMIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:08:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbaICMIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:08:32 -0400
Date: Wed, 3 Sep 2014 14:08:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: 3.17-rc3+ CPU hotplug lockdep splat during resume from RAM
Message-ID: <alpine.LNX.2.00.1409031404110.12309@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting lockdep complaint below during resume from s2ram (this is 
with current Linus' tree, HEAD == 7505ceaf8). 

I haven't had time yet to look into this yet myself; if someone beats me 
with a fix, that'd be great, otherwise I'll try to look into it as soon as 
possible.

[ ... snip ... ]
 Freezing user space processes ... (elapsed 0.002 seconds) done.
 Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
 PM: Entering mem sleep
 Suspending console(s) (use no_console_suspend to debug)
 wlan0: deauthenticating from 00:0b:6b:3c:8c:e4 by local choice (Reason: 3=DEAUTH_LEAVING)
 cfg80211: Calling CRDA to update world regulatory domain
 sd 0:0:0:0: [sda] Synchronizing SCSI cache
 sd 0:0:0:0: [sda] Stopping disk
 e1000e: EEE TX LPI TIMER: 00000000
 PM: suspend of devices complete after 390.773 msecs
 PM: late suspend of devices complete after 15.467 msecs
 ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
 uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
 ehci-pci 0000:00:1a.7: System wakeup enabled by ACPI
 uhci_hcd 0000:00:1a.2: System wakeup enabled by ACPI
 uhci_hcd 0000:00:1a.0: System wakeup enabled by ACPI
 e1000e 0000:00:19.0: System wakeup enabled by ACPI
 PM: noirq suspend of devices complete after 16.012 msecs
 ACPI: Preparing to enter system sleep state S3
 PM: Saving platform NVS memory
 Disabling non-boot CPUs ...
 kvm: disabling virtualization on CPU1
 smpboot: CPU 1 is now offline
 ACPI: Low-level resume complete
 PM: Restoring platform NVS memory
 Enabling non-boot CPUs ...
 x86: Booting SMP configuration:
 smpboot: Booting Node 0 Processor 1 APIC 0x1
 Disabled fast string operations
 kvm: enabling virtualization on CPU1
 CPU1 is up
 ACPI: Waking up from system sleep state S3
 
 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.17.0-rc3-91270-ge5ddf7b #1 Not tainted
 -------------------------------------------------------
 kworker/0:2/16442 is trying to acquire lock:
  (cpu_hotplug.lock){++++++}, at: [<ffffffff8105095d>] get_online_cpus+0x2d/0x80
 
 but task is already holding lock:
  (cpuidle_lock){+.+.+.}, at: [<ffffffff8147af02>] cpuidle_pause_and_lock+0x12/0x40
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #2 (cpuidle_lock){+.+.+.}:
        [<ffffffff81096c81>] lock_acquire+0x91/0x110
        [<ffffffff815a1ecf>] mutex_lock_nested+0x5f/0x3c0
        [<ffffffff8147af02>] cpuidle_pause_and_lock+0x12/0x40
        [<ffffffffc0075802>] acpi_processor_hotplug+0x44/0x88 [processor]
        [<ffffffffc0073257>] acpi_cpu_soft_notify+0xaa/0xdf [processor]
        [<ffffffff8106f2d3>] notifier_call_chain+0x53/0xa0
        [<ffffffff8106f329>] __raw_notifier_call_chain+0x9/0x10
        [<ffffffff81050a6e>] cpu_notify+0x1e/0x40
        [<ffffffff81050cb8>] _cpu_up+0x148/0x160
        [<ffffffff8159093a>] enable_nonboot_cpus+0xaa/0x1a0
        [<ffffffff8109c367>] suspend_devices_and_enter+0x277/0x4d0
        [<ffffffff8109c6ad>] pm_suspend+0xed/0x390
        [<ffffffff8109b464>] state_store+0x74/0xf0
        [<ffffffff812f0bef>] kobj_attr_store+0xf/0x20
        [<ffffffff8121311f>] sysfs_kf_write+0x3f/0x50
        [<ffffffff81212a47>] kernfs_fop_write+0xe7/0x170
        [<ffffffff8119cbd2>] vfs_write+0xb2/0x1f0
        [<ffffffff8119d734>] SyS_write+0x44/0xb0
        [<ffffffff815a6796>] system_call_fastpath+0x1a/0x1f
 
 -> #1 (cpu_hotplug.lock#2){+.+.+.}:
        [<ffffffff81096c81>] lock_acquire+0x91/0x110
        [<ffffffff815a1ecf>] mutex_lock_nested+0x5f/0x3c0
        [<ffffffff81050afa>] cpu_hotplug_begin+0x4a/0x80
        [<ffffffff81050b9f>] _cpu_up+0x2f/0x160
        [<ffffffff81050d51>] cpu_up+0x81/0xa0
        [<ffffffff81b1137d>] smp_init+0x86/0x88
        [<ffffffff81af414e>] kernel_init_freeable+0x151/0x260
        [<ffffffff8158fb29>] kernel_init+0x9/0xf0
        [<ffffffff815a66ec>] ret_from_fork+0x7c/0xb0
 
 -> #0 (cpu_hotplug.lock){++++++}:
        [<ffffffff810961cd>] __lock_acquire+0x171d/0x1a30
        [<ffffffff81096c81>] lock_acquire+0x91/0x110
        [<ffffffff81050983>] get_online_cpus+0x53/0x80
        [<ffffffffc00758b3>] acpi_processor_cst_has_changed+0x6d/0x176 [processor]
        [<ffffffffc00733c4>] acpi_processor_notify+0x8a/0x126 [processor]
        [<ffffffff81368574>] acpi_ev_notify_dispatch+0x44/0x5c
        [<ffffffff8134ee01>] acpi_os_execute_deferred+0xf/0x1b
        [<ffffffff81068cea>] process_one_work+0x1da/0x4f0
        [<ffffffff81069113>] worker_thread+0x113/0x480
        [<ffffffff8106e1f8>] kthread+0xe8/0x100
        [<ffffffff815a66ec>] ret_from_fork+0x7c/0xb0
 
 other info that might help us debug this:
 
 Chain exists of:
   cpu_hotplug.lock --> cpu_hotplug.lock#2 --> cpuidle_lock
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(cpuidle_lock);
                                lock(cpu_hotplug.lock#2);
                                lock(cpuidle_lock);
   lock(cpu_hotplug.lock);
 
  *** DEADLOCK ***
 
 3 locks held by kworker/0:2/16442:
  #0:  ("kacpi_notify"){++++.+}, at: [<ffffffff81068c88>] process_one_work+0x178/0x4f0
  #1:  ((&dpc->work)#2){+.+.+.}, at: [<ffffffff81068c88>] process_one_work+0x178/0x4f0
  #2:  (cpuidle_lock){+.+.+.}, at: [<ffffffff8147af02>] cpuidle_pause_and_lock+0x12/0x40
 
 stack backtrace:
 CPU: 0 PID: 16442 Comm: kworker/0:2 Not tainted 3.17.0-rc3-91270-ge5ddf7b #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
 Workqueue: kacpi_notify acpi_os_execute_deferred
  ffffffff823e2a30 ffff880037b97b68 ffffffff8159e93f ffffffff823e2880
  ffff880037b97ba8 ffffffff8159982f ffff880037b97c00 ffff880078c04c20
  0000000000000002 0000000000000003 ffff880078c04c20 ffff880078c04350
 Call Trace:
  [<ffffffff8159e93f>] dump_stack+0x4d/0x66
  [<ffffffff8159982f>] print_circular_bug+0x201/0x20f
  [<ffffffff810961cd>] __lock_acquire+0x171d/0x1a30
  [<ffffffff810cb5c9>] ? generic_exec_single+0xf9/0x170
  [<ffffffff81096c81>] lock_acquire+0x91/0x110
  [<ffffffff8105095d>] ? get_online_cpus+0x2d/0x80
  [<ffffffff81050983>] get_online_cpus+0x53/0x80
  [<ffffffff8105095d>] ? get_online_cpus+0x2d/0x80
  [<ffffffffc00758b3>] acpi_processor_cst_has_changed+0x6d/0x176 [processor]
  [<ffffffffc00733c4>] acpi_processor_notify+0x8a/0x126 [processor]
  [<ffffffff81368574>] acpi_ev_notify_dispatch+0x44/0x5c
  [<ffffffff8134ee01>] acpi_os_execute_deferred+0xf/0x1b
  [<ffffffff81068cea>] process_one_work+0x1da/0x4f0
  [<ffffffff81068c88>] ? process_one_work+0x178/0x4f0
  [<ffffffff81069113>] worker_thread+0x113/0x480
  [<ffffffff81069000>] ? process_one_work+0x4f0/0x4f0
  [<ffffffff8106e1f8>] kthread+0xe8/0x100
  [<ffffffff8106e110>] ? kthread_create_on_node+0x1f0/0x1f0
  [<ffffffff815a66ec>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106e110>] ? kthread_create_on_node+0x1f0/0x1f0


-- 
Jiri Kosina
SUSE Labs
