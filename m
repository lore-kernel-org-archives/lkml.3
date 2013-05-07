Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3EGTAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:00:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18000 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3EGTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:00:46 -0400
Date: Tue, 7 May 2013 15:00:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, fenghua.yu@intel.com
Cc: xen-devel@lists.xensource.com
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
Message-ID: <20130507190024.GA4303@phenom.dumpdata.com>
References: <20130506125937.GA14036@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506125937.GA14036@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 08:59:37AM -0400, Konrad Rzeszutek Wilk wrote:
> 
> Hey,
> 
> As I was fixing the PV HVM's broken CPU hotplug mechanism I discovered
> a deadlock in the microcode and generic code.
> 
> I am not sure if the ACPI generic mechanism would expose this, but
> looking at the flow (arch_register_cpu, then expecting user-space to call
> cpu_up), it should trigger this.

Fenghua,

I dug deeper in how QEMU does it and it looks to be actually doing
the right thing. It triggers the ACPI SCI, the method that figures out
the CPU online/offline bits kicks off the right OSPM notification and
everything is going through ACPI (so _STA is on the processor is checked,
returns 0x2 (ACPI_STA_DEVICE_PRESENT), MADT has now the CPU marked as enabled).

I am now 99% sure you would be able to reproduce this on baremetal with
ACPI hotplug where the CPUs at bootup are marked as disabled in MADT.
(lapic->lapic_flags == 0).

The comment for calling save_mc_for_early says:

         /*                                                                      
          * If early loading microcode is supported, save this mc into           
          * permanent memory. So it will be loaded early when a CPU is hot added 
          * or resumes.                                                          
          */           

Do you by any chance recall the testing you did on that? And how the
ACPI CPU hotplug mechanism worked such that this deadlock would not
have occured?

Thanks.
> 
> Anyhow, this can easily be triggered if a new CPU is added and
> from user-space do:
> 
> echo 1 > /sys/devices/system/cpu/cpu3/online
> 
> on a newly appeared CPU. The deadlock is that the "store_online" in
> drivers/base/cpu.c takes the cpu_hotplug_driver_lock() lock, then
> calls "cpu_up". "cpu_up" eventually ends up calling "save_mc_for_early"
> which also takes the cpu_hotplug_driver_lock() lock.
> 
> And here is that kernel thinks of it:
> 
> smpboot: Stack at about ffff880075c39f44
> smpboot: CPU3: has booted.
> microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0upstream-10129-g167af0e #1 Not tainted
> ---------------------------------------------
> sh/2487 is trying to acquire lock:
>  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
> 
> but task is already holding lock:
>  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(x86_cpu_hotplug_driver_mutex);
>   lock(x86_cpu_hotplug_driver_mutex);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 6 locks held by sh/2487:
>  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff811ca48d>] vfs_write+0x17d/0x190
>  #1:  (&buffer->mutex){+.+.+.}, at: [<ffffffff812464ef>] sysfs_write_file+0x3f/0x160
>  #2:  (s_active#20){.+.+.+}, at: [<ffffffff81246578>] sysfs_write_file+0xc8/0x160
>  #3:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
>  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810961c2>] cpu_maps_update_begin+0x12/0x20
>  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810962a7>] cpu_hotplug_begin+0x27/0x60
> 
> stack backtrace:
> CPU: 1 PID: 2487 Comm: sh Not tainted 3.9.0upstream-10129-g167af0e #1
> Hardware name: Xen HVM domU, BIOS 4.3-unstable 05/03/2013
>  ffffffff8229b710 ffff880064e75538 ffffffff816fe47e ffff880064e75608
>  ffffffff81100cb6 ffff880064e75560 ffff88006670e290 ffff880064e75588
>  ffffffff00000000 ffff88006670e9b8 21710c800c83a1f5 ffff880064e75598
> Call Trace:
>  [<ffffffff816fe47e>] dump_stack+0x19/0x1b
>  [<ffffffff81100cb6>] __lock_acquire+0x726/0x1890
>  [<ffffffff8110b352>] ? is_module_text_address+0x22/0x40
>  [<ffffffff810bbff8>] ? __kernel_text_address+0x58/0x80
>  [<ffffffff81101eca>] lock_acquire+0xaa/0x190
>  [<ffffffff81075512>] ? cpu_hotplug_driver_lock+0x12/0x20
>  [<ffffffff816fee1e>] __mutex_lock_common+0x5e/0x450
>  [<ffffffff81075512>] ? cpu_hotplug_driver_lock+0x12/0x20
>  [<ffffffff810d4225>] ? sched_clock_local+0x25/0x90
>  [<ffffffff81075512>] ? cpu_hotplug_driver_lock+0x12/0x20
>  [<ffffffff816ff340>] mutex_lock_nested+0x40/0x50
>  [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
>  [<ffffffff81080757>] save_mc_for_early+0x27/0xf0
>  [<ffffffff810ffd30>] ? mark_held_locks+0x90/0x150
>  [<ffffffff81176a5d>] ? get_page_from_freelist+0x46d/0x8e0
>  [<ffffffff8110029d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81056a39>] ? sched_clock+0x9/0x10
>  [<ffffffff81177275>] ? __alloc_pages_nodemask+0x165/0xa30
>  [<ffffffff810d4225>] ? sched_clock_local+0x25/0x90
>  [<ffffffff810d4348>] ? sched_clock_cpu+0xb8/0x110
>  [<ffffffff810fb88d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff811a5e79>] ? vmap_page_range_noflush+0x279/0x370
>  [<ffffffff811a5f9d>] ? map_vm_area+0x2d/0x50
>  [<ffffffff811a7dce>] ? __vmalloc_node_range+0x18e/0x260
>  [<ffffffff810812a8>] ? generic_load_microcode+0xb8/0x1c0
>  [<ffffffff8108135c>] generic_load_microcode+0x16c/0x1c0
>  [<ffffffff8110917e>] ? generic_exec_single+0x7e/0xb0
>  [<ffffffff81081470>] ? request_microcode_user+0x20/0x20
>  [<ffffffff8108142f>] request_microcode_fw+0x7f/0xa0
>  [<ffffffff813356ab>] ? kobject_uevent+0xb/0x10
>  [<ffffffff81081004>] microcode_init_cpu+0xf4/0x110
>  [<ffffffff816f6b8c>] mc_cpu_callback+0x5b/0xb3
>  [<ffffffff81706d7c>] notifier_call_chain+0x5c/0x120
>  [<ffffffff810c6359>] __raw_notifier_call_chain+0x9/0x10
>  [<ffffffff8109616b>] __cpu_notify+0x1b/0x30
>  [<ffffffff816f72e1>] _cpu_up+0x103/0x14b
>  [<ffffffff816f7404>] cpu_up+0xdb/0xee
>  [<ffffffff816eda0a>] store_online+0xba/0x120
>  [<ffffffff8145f08b>] dev_attr_store+0x1b/0x20
>  [<ffffffff81246591>] sysfs_write_file+0xe1/0x160
>  [<ffffffff811ca3ef>] vfs_write+0xdf/0x190
>  [<ffffffff811ca96d>] SyS_write+0x5d/0xa0
>  [<ffffffff8133f4fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8170b7a9>] system_call_fastpath+0x16/0x1b
> 
> Thoughts? 
