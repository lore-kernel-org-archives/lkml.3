Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3KGBvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:51:50 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:45892 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3KGBvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:51:41 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 20:51:38 EST
Date: Wed, 6 Nov 2013 21:42:15 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] PCI: Introduce two new MSI infrastructure calls for masking/unmasking.
Message-ID: <20131107014215.GA27725@andromeda.dapyr.net>
References: <1383772616-23060-1-git-send-email-konrad.wilk@oracle.com> <CAErSpo4rdHwhuF=SM6WT3EP3TGoUFnwxVdx5919qxea3On7MRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAErSpo4rdHwhuF=SM6WT3EP3TGoUFnwxVdx5919qxea3On7MRw@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:51:52PM -0700, Bjorn Helgaas wrote:
> [+cc Thomas, Ingo, Peter, x86 list]
> 
> On Wed, Nov 6, 2013 at 2:16 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > Certain platforms do not allow writes in the MSI-X bars
> > to setup or tear down vector values. To combat against
> > the generic code trying to write to that and either silently
> > being ignored or crashing due to the pagetables being marked r/o
> > this patch introduces a platform over-write.
> >
> > Note that we keep two separate, non-weak, functions
> > default_mask_msi_irqs() and default_mask_msix_irqs() for the
> > behavior of the arch_mask_msi_irqs() and arch_mask_msix_irqs(),
> > as the default behavior is needed by x86 PCI code.
> >
> > For Xen, which does not allow the guest to write to MSI-X
> > tables - as the hypervisor is solely responsible for setting
> > the vector values - we implement two nops.
> >
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> > CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> I think this is safe, and I'd like to squeeze it into the v3.13 merge
> window next week, since it supersedes three patches Zhenzhong has been
> trying to get in since July [1], and this patch is much simpler to
> understand.
> 
> I *think* this also fixes an actual bug on Xen.  Konrad, is there a
> bugzilla or any kind of email problem description that we can include
> here as a reference?  I think there's a lost interrupt with qlcnic,
> but I don't know the details or what the failure looks like to a user.

It is pretty catastrophic. Here is the console log when I pass in
a PCI device (with MSI-X) to the guest:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.0upstream (konrad@build-external.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Wed Nov 6 20:09:36 EST 2013
[    0.000000] Command line: console=hvc0 debug  kgdboc=hvc0 nokgdbroundup  initcall_debug debug 
[    0.000000] Disabled fast string operations
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] Freeing 20000-40000 pfn range: 131072 pages freed
[    0.000000] 1-1 mapping on 20000->100000
[    0.000000] Released 131072 pages of unused memory
[    0.000000] Set 917504 page(s) to 1-1 mapping
[    0.000000] Populating 100000-120000 pfn range: 131072 pages added
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] Xen: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] Xen: [mem 0x0000000020200000-0x000000003fffffff] unusable
[    0.000000] Xen: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] Xen: [mem 0x0000000040200000-0x00000000bc557fff] unusable
[    0.000000] Xen: [mem 0x00000000bc558000-0x00000000bc560fff] ACPI data
[    0.000000] Xen: [mem 0x00000000bc561000-0x00000000bc5abfff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000bc5ac000-0x00000000bc5b3fff] unusable
[    0.000000] Xen: [mem 0x00000000bc5b4000-0x00000000bc8c4fff] reserved
[    0.000000] Xen: [mem 0x00000000bc8c5000-0x00000000bc8c5fff] unusable
[    0.000000] Xen: [mem 0x00000000bc8c6000-0x00000000bc8d5fff] reserved
[    0.000000] Xen: [mem 0x00000000bc8d6000-0x00000000bc8f4fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000bc8f5000-0x00000000bc918fff] reserved
[    0.000000] Xen: [mem 0x00000000bc919000-0x00000000bc95bfff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000bc95c000-0x00000000bcb7bfff] reserved
[    0.000000] Xen: [mem 0x00000000bcb7c000-0x00000000bccfffff] unusable
[    0.000000] Xen: [mem 0x00000000bcd00000-0x00000000bcffffff] reserved
[    0.000000] Xen: [mem 0x00000000bd800000-0x00000000bf9fffff] reserved
[    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000015fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x160000 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x20000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 4k
[    0.000000] BRK [0x01fdb000, 0x01fdbfff] PGTABLE
[    0.000000] BRK [0x01fdc000, 0x01fdcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 4k
[    0.000000] BRK [0x01fdd000, 0x01fddfff] PGTABLE
[    0.000000] BRK [0x01fde000, 0x01fdefff] PGTABLE
[    0.000000] BRK [0x01fdf000, 0x01fdffff] PGTABLE
[    0.000000] BRK [0x01fe0000, 0x01fe0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x1fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x120000000-0x15fffffff]
[    0.000000]  [mem 0x120000000-0x15fffffff] page 4k
[    0.000000] RAMDISK: [mem 0x023e9000-0x072bffff]
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000015fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x15fffffff]
[    0.000000]   NODE_DATA [mem 0x11fc3c000-0x11fc3ffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x15fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x100000000-0x15fffffff]
[    0.000000] On node 0 totalpages: 524191
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1736 pages used for memmap
[    0.000000]   DMA32 zone: 126976 pages, LIFO batch:31
[    0.000000]   Normal zone: 5376 pages used for memmap
[    0.000000]   Normal zone: 393216 pages, LIFO batch:31
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20200000-0x3fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40200000-0xbc557fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc558000-0xbc560fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc561000-0xbc5abfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc5ac000-0xbc5b3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc5b4000-0xbc8c4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc8c5000-0xbc8c5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc8c6000-0xbc8d5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc8d6000-0xbc8f4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc8f5000-0xbc918fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc919000-0xbc95bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc95c000-0xbcb7bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcb7c000-0xbccfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcd00000-0xbcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd000000-0xbd7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd800000-0xbf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfa00000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed3ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed40000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xbfa00000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.4-unstable (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011f600000 s85376 r8192 d21120 u262144
[    0.000000] pcpu-alloc: s85376 r8192 d21120 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517002
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: console=hvc0 debug  kgdboc=hvc0 nokgdbroundup  initcall_debug debug 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 914964K/2096764K available (6913K kernel code, 753K rwdata, 2156K rodata, 1708K init, 1364K bss, 1181800K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:33024 nr_irqs:336 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] tsc: Detected 3292.562 MHz processor
[    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6585.12 BogoMIPS (lpj=3292562)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001080] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001256] Mount-cache hash table entries: 256
[    0.002316] Initializing cgroup subsys freezer
[    0.002397] Disabled fast string operations
[    0.002407] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002407] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002413] CPU: Physical Processor ID: 0
[    0.002416] CPU: Processor Core ID: 1
[    0.002421] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.002421] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.002421] tlb_flushall_shift: 5
[    0.026322] cpu 0 spinlock event irq 17
[    0.026458] calling  xen_init_spinlocks_jump+0x0/0x1d @ 1
[    0.032467] initcall xen_init_spinlocks_jump+0x0/0x1d returned 0 after 5859 usecs
[    0.032473] calling  set_real_mode_permissions+0x0/0xa9 @ 1
[    0.032494] initcall set_real_mode_permissions+0x0/0xa9 returned 0 after 0 usecs
[    0.032499] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.032503] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.032507] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.032510] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.032515] calling  init_hw_perf_events+0x0/0x53b @ 1
[    0.032517] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
[    0.032523] initcall init_hw_perf_events+0x0/0x53b returned 0 after 0 usecs
[    0.032527] calling  register_trigger_all_cpu_backtrace+0x0/0x16 @ 1
[    0.032531] initcall register_trigger_all_cpu_backtrace+0x0/0x16 returned 0 after 0 usecs
[    0.032535] calling  kvm_spinlock_init_jump+0x0/0x5a @ 1
[    0.032631] initcall kvm_spinlock_init_jump+0x0/0x5a returned 0 after 0 usecs
[    0.032636] calling  spawn_ksoftirqd+0x0/0x28 @ 1
[    0.032678] initcall spawn_ksoftirqd+0x0/0x28 returned 0 after 0 usecs
[    0.032683] calling  init_workqueues+0x0/0x557 @ 1
[    0.032974] initcall init_workqueues+0x0/0x557 returned 0 after 0 usecs
[    0.032980] calling  check_cpu_stall_init+0x0/0x1b @ 1
[    0.032983] initcall check_cpu_stall_init+0x0/0x1b returned 0 after 0 usecs
[    0.032994] calling  migration_init+0x0/0x71 @ 1
[    0.032997] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.033000] calling  cpu_stop_init+0x0/0x76 @ 1
[    0.033000] initcall cpu_stop_init+0x0/0x76 returned 0 after 0 usecs
[    0.033000] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.033000] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.033000] calling  rcu_spawn_gp_kthread+0x0/0x90 @ 1
[    0.033041] initcall rcu_spawn_gp_kthread+0x0/0x90 returned 0 after 976 usecs
[    0.033046] calling  relay_init+0x0/0x14 @ 1
[    0.033049] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.033053] calling  tracer_alloc_buffers+0x0/0x1bd @ 1
[    0.033102] initcall tracer_alloc_buffers+0x0/0x1bd returned 0 after 0 usecs
[    0.033106] calling  init_events+0x0/0x61 @ 1
[    0.033110] initcall init_events+0x0/0x61 returned 0 after 0 usecs
[    0.033113] calling  init_trace_printk+0x0/0x12 @ 1
[    0.033117] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.033121] calling  event_trace_memsetup+0x0/0x52 @ 1
[    0.033159] initcall event_trace_memsetup+0x0/0x52 returned 0 after 0 usecs
[    0.033163] calling  jump_label_init_module+0x0/0x12 @ 1
[    0.033167] initcall jump_label_init_module+0x0/0x12 returned 0 after 0 usecs
[    0.033171] calling  balloon_clear+0x0/0x4f @ 1
[    0.033175] initcall balloon_clear+0x0/0x4f returned 0 after 0 usecs
[    0.033179] calling  mce_amd_init+0x0/0x165 @ 1
[    0.033182] initcall mce_amd_init+0x0/0x165 returned 0 after 0 usecs
[    0.033381] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.033826] installing Xen timer for CPU 1
[    0.033890] cpu 1 spinlock event irq 24
[    0.033951] SMP alternatives: switching to SMP code
[    0.001000] Disabled fast string operations
[    0.057512] installing Xen timer for CPU 2
[    0.057575] cpu 2 spinlock event irq 31
[    0.058327] installing Xen timer for CPU 3
[    0.058387] cpu 3 spinlock event irq 38
[    0.059181] installing Xen timer for CPU 4
[    0.059241] cpu 4 spinlock event irq 45
[    0.060000] installing Xen timer for CPU 5
[    0.060030] cpu 5 spinlock event irq 52
[    0.001000] Disabled fast string operations
[    0.061868] installing Xen timer for CPU 6
[    0.061932] cpu 6 spinlock event irq 59
[    0.062744] installing Xen timer for CPU 7
[    0.062807] cpu 7 spinlock event irq 66
[    0.063070] Brought up 8 CPUs
[    0.066882] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.066890] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.066895] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.066898] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.066902] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.066922] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.066929] calling  net_ns_init+0x0/0x104 @ 1
[    0.067031] initcall net_ns_init+0x0/0x104 returned 0 after 976 usecs
[    0.067052] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.067059] PM: Registering ACPI NVS region [mem 0xbc561000-0xbc5abfff] (307200 bytes)
[    0.067174] PM: Registering ACPI NVS region [mem 0xbc8d6000-0xbc8f4fff] (126976 bytes)
[    0.067224] PM: Registering ACPI NVS region [mem 0xbc919000-0xbc95bfff] (274432 bytes)
[    0.067324] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
[    0.067329] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.067332] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.067337] calling  reboot_init+0x0/0x1d @ 1
[    0.067341] initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
[    0.067345] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.067349] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.067353] calling  cpu_hotplug_pm_sync_init+0x0/0x2f @ 1
[    0.067357] initcall cpu_hotplug_pm_sync_init+0x0/0x2f returned 0 after 0 usecs
[    0.067361] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.067365] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.067369] calling  wq_sysfs_init+0x0/0x14 @ 1
[    0.067404] kworker/u16:0 (49) used greatest stack depth: 6032 bytes left
[    0.067410] initcall wq_sysfs_init+0x0/0x14 returned 0 after 0 usecs
[    0.067410] calling  ksysfs_init+0x0/0x94 @ 1
[    0.067410] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.067410] calling  pm_init+0x0/0x4e @ 1
[    0.067410] initcall pm_init+0x0/0x4e returned 0 after 0 usecs
[    0.067410] calling  pm_disk_init+0x0/0x19 @ 1
[    0.067410] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.067410] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.067410] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.067410] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.067410] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.067410] calling  event_trace_enable+0x0/0x173 @ 1
[    0.068377] initcall event_trace_enable+0x0/0x173 returned 0 after 976 usecs
[    0.068383] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.068386] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.068390] calling  fsnotify_init+0x0/0x26 @ 1
[    0.068408] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.068412] calling  filelock_init+0x0/0x84 @ 1
[    0.068476] initcall filelock_init+0x0/0x84 returned 0 after 0 usecs
[    0.068480] calling  init_misc_binfmt+0x0/0x31 @ 1
[    0.068484] initcall init_misc_binfmt+0x0/0x31 returned 0 after 0 usecs
[    0.068488] calling  init_script_binfmt+0x0/0x16 @ 1
[    0.068491] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.068495] calling  init_elf_binfmt+0x0/0x16 @ 1
[    0.068498] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.068502] calling  init_compat_elf_binfmt+0x0/0x16 @ 1
[    0.068506] initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.068510] calling  debugfs_init+0x0/0x5c @ 1
[    0.068524] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.068528] calling  securityfs_init+0x0/0x53 @ 1
[    0.068541] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.068544] calling  prandom_init+0x0/0xd9 @ 1
[    0.068548] initcall prandom_init+0x0/0xd9 returned 0 after 0 usecs
[    0.068554] calling  virtio_init+0x0/0x30 @ 1
[    0.068583] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    0.068583] calling  __gnttab_init+0x0/0x30 @ 1
[    0.068583] xen:grant_table: Grant tables using version 2 layout
[    0.068583] Grant table initialized
[    0.068583] initcall __gnttab_init+0x0/0x30 returned 0 after 0 usecs
[    0.068583] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.087814] RTC time: 165:165:165, date: 165/165/65
[    0.087818] initcall early_resume_init+0x0/0x1d0 returned 0 after 18554 usecs
[    0.087823] calling  cpufreq_core_init+0x0/0x9a @ 1
[    0.087826] initcall cpufreq_core_init+0x0/0x9a returned -19 after 0 usecs
[    0.088007] calling  cpuidle_init+0x0/0x40 @ 1
[    0.088021] initcall cpuidle_init+0x0/0x40 returned -19 after 0 usecs
[    0.088025] calling  bsp_pm_check_init+0x0/0x14 @ 1
[    0.088029] initcall bsp_pm_check_init+0x0/0x14 returned 0 after 0 usecs
[    0.088033] calling  sock_init+0x0/0x8b @ 1
[    0.088492] initcall sock_init+0x0/0x8b returned 0 after 0 usecs
[    0.088498] calling  net_inuse_init+0x0/0x26 @ 1
[    0.088518] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.088523] calling  netpoll_init+0x0/0x31 @ 1
[    0.088526] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.088530] calling  netlink_proto_init+0x0/0x1f7 @ 1
[    0.088583] NET: Registered protocol family 16
[    0.088618] initcall netlink_proto_init+0x0/0x1f7 returned 0 after 0 usecs
[    0.088635] calling  bdi_class_init+0x0/0x4d @ 1
[    0.088680] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.088680] calling  kobject_uevent_init+0x0/0x12 @ 1
[    0.088680] initcall kobject_uevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.088680] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.089042] initcall pcibus_class_init+0x0/0x19 returned 0 after 976 usecs
[    0.089042] calling  pci_driver_init+0x0/0x12 @ 1
[    0.089051] kworker/u16:0 (53) used greatest stack depth: 5600 bytes left
[    0.089054] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.089054] calling  backlight_class_init+0x0/0x55 @ 1
[    0.089063] initcall backlight_class_init+0x0/0x55 returned 0 after 0 usecs
[    0.089063] calling  video_output_class_init+0x0/0x19 @ 1
[    0.089063] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.089063] calling  xenbus_init+0x0/0x26f @ 1
[    0.089095] initcall xenbus_init+0x0/0x26f returned 0 after 0 usecs
[    0.089095] calling  tty_class_init+0x0/0x38 @ 1
[    0.089095] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.089095] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.090034] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 976 usecs
[    0.090034] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.090034] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.090035] calling  register_node_type+0x0/0x34 @ 1
[    0.090060] initcall register_node_type+0x0/0x34 returned 0 after 0 usecs
[    0.090065] calling  i2c_init+0x0/0x70 @ 1
[    0.090086] initcall i2c_init+0x0/0x70 returned 0 after 0 usecs
[    0.090086] calling  init_ladder+0x0/0x12 @ 1
[    0.090086] initcall init_ladder+0x0/0x12 returned -19 after 0 usecs
[    0.090086] calling  init_menu+0x0/0x12 @ 1
[    0.090086] initcall init_menu+0x0/0x12 returned -19 after 0 usecs
[    0.090086] calling  amd_postcore_init+0x0/0x143 @ 1
[    0.090086] initcall amd_postcore_init+0x0/0x143 returned 0 after 0 usecs
[    0.090086] calling  arch_kdebugfs_init+0x0/0x256 @ 1
[    0.090089] initcall arch_kdebugfs_init+0x0/0x256 returned 0 after 0 usecs
[    0.090094] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.090097] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.090101] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.090119] initcall ffh_cstate_init+0x0/0x2a returned 0 after 0 usecs
[    0.090123] calling  activate_jump_labels+0x0/0x32 @ 1
[    0.090127] initcall activate_jump_labels+0x0/0x32 returned 0 after 0 usecs
[    0.090131] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.090134] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.090138] calling  dma_bus_init+0x0/0x19 @ 1
[    0.090165] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
[    0.090165] calling  dma_channel_table_init+0x0/0xde @ 1
[    0.090165] initcall dma_channel_table_init+0x0/0xde returned 0 after 0 usecs
[    0.090165] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.223125] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 129882 usecs
[    0.223135] calling  register_xen_pci_notifier+0x0/0x38 @ 1
[    0.223147] initcall register_xen_pci_notifier+0x0/0x38 returned 0 after 0 usecs
[    0.223151] calling  xen_pcpu_init+0x0/0xcc @ 1
[    0.223155] initcall xen_pcpu_init+0x0/0xcc returned -19 after 0 usecs
[    0.223159] calling  dmi_id_init+0x0/0x31d @ 1
[    0.223163] initcall dmi_id_init+0x0/0x31d returned -19 after 0 usecs
[    0.223167] calling  dca_init+0x0/0x20 @ 1
[    0.223169] dca service started, version 1.12.1
[    0.223209] initcall dca_init+0x0/0x20 returned 0 after 0 usecs
[    0.223209] calling  iommu_init+0x0/0x58 @ 1
[    0.223209] initcall iommu_init+0x0/0x58 returned 0 after 0 usecs
[    0.223209] calling  pci_arch_init+0x0/0x69 @ 1
[    0.223416] PCI: setting up Xen PCI frontend stub
[    0.223420] PCI: pci_cache_line_size set to 64 bytes
[    0.223424] initcall pci_arch_init+0x0/0x69 returned 0 after 0 usecs
[    0.223443] calling  topology_init+0x0/0x98 @ 1
[    0.224068] initcall topology_init+0x0/0x98 returned 0 after 976 usecs
[    0.224068] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.224068] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.224068] calling  init_vdso+0x0/0x135 @ 1
[    0.224068] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
[    0.224068] calling  sysenter_setup+0x0/0x2dd @ 1
[    0.224068] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
[    0.224068] calling  param_sysfs_init+0x0/0x1b5 @ 1
[    0.225034] kworker/u16:0 (86) used greatest stack depth: 5528 bytes left
[    0.245036] initcall param_sysfs_init+0x0/0x1b5 returned 0 after 20507 usecs
[    0.245036] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.245036] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.245036] calling  default_bdi_init+0x0/0x65 @ 1
[    0.245217] initcall default_bdi_init+0x0/0x65 returned 0 after 976 usecs
[    0.245217] calling  init_bio+0x0/0xe9 @ 1
[    0.245281] bio: create slab <bio-0> at 0
[    0.246026] initcall init_bio+0x0/0xe9 returned 0 after 0 usecs
[    0.246026] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.246112] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.246119] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.246123] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.246127] calling  blk_settings_init+0x0/0x2c @ 1
[    0.246131] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.246135] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.246170] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.246175] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.246180] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.246184] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.246187] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.246191] calling  genhd_device_init+0x0/0x85 @ 1
[    0.246217] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
[    0.246217] calling  pci_slot_init+0x0/0x50 @ 1
[    0.246217] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.246217] calling  fbmem_init+0x0/0x98 @ 1
[    0.246217] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.246217] calling  acpi_init+0x0/0x27a @ 1
[    0.246217] ACPI: Interpreter disabled.
[    0.246217] initcall acpi_init+0x0/0x27a returned -19 after 0 usecs
[    0.246217] calling  pnp_init+0x0/0x12 @ 1
[    0.247035] initcall pnp_init+0x0/0x12 returned 0 after 976 usecs
[    0.247042] calling  balloon_init+0x0/0x1dd @ 1
[    0.247046] xen:balloon: Initialising balloon driver
[    0.249047] initcall balloon_init+0x0/0x1dd returned 0 after 1953 usecs
[    0.249058] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    0.249073] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 0 usecs
[    0.249073] calling  xenbus_probe_backend_init+0x0/0x2d @ 1
[    0.249073] initcall xenbus_probe_backend_init+0x0/0x2d returned 0 after 0 usecs
[    0.249073] calling  xenbus_probe_frontend_init+0x0/0x72 @ 1
[    0.250070] initcall xenbus_probe_frontend_init+0x0/0x72 returned 0 after 976 usecs
[    0.250070] calling  xen_acpi_pad_init+0x0/0x47 @ 1
[    0.250070] initcall xen_acpi_pad_init+0x0/0x47 returned -19 after 0 usecs
[    0.250070] calling  balloon_init+0x0/0xfa @ 1
[    0.250070] xen_balloon: Initialising balloon driver
[    0.250087] initcall balloon_init+0x0/0xfa returned 0 after 0 usecs
[    0.250087] calling  misc_init+0x0/0xba @ 1
[    0.251041] initcall misc_init+0x0/0xba returned 0 after 976 usecs
[    0.251041] calling  vga_arb_device_init+0x0/0xde @ 1
[    0.251093] vgaarb: loaded
[    0.251093] initcall vga_arb_device_init+0x0/0xde returned 0 after 0 usecs
[    0.251093] calling  cn_init+0x0/0xc0 @ 1
[    0.251093] initcall cn_init+0x0/0xc0 returned 0 after 0 usecs
[    0.251093] calling  dma_buf_init+0x0/0x75 @ 1
[    0.251093] initcall dma_buf_init+0x0/0x75 returned 0 after 0 usecs
[    0.251093] calling  phy_init+0x0/0x2e @ 1
[    0.251100] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.251100] calling  init_pcmcia_cs+0x0/0x3d @ 1
[    0.251100] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
[    0.251100] calling  usb_init+0x0/0x169 @ 1
[    0.251111] usbcore: registered new interface driver usbfs
[    0.252068] usbcore: registered new interface driver hub
[    0.252068] usbcore: registered new device driver usb
[    0.252068] initcall usb_init+0x0/0x169 returned 0 after 976 usecs
[    0.252068] calling  serio_init+0x0/0x31 @ 1
[    0.252068] initcall serio_init+0x0/0x31 returned 0 after 0 usecs
[    0.252068] calling  input_init+0x0/0x103 @ 1
[    0.411057] initcall input_init+0x0/0x103 returned 0 after 0 usecs
[    0.411057] calling  rtc_init+0x0/0x5b @ 1
[    0.411059] initcall rtc_init+0x0/0x5b returned 0 after 0 usecs
[    0.411059] calling  pps_init+0x0/0xb7 @ 1
[    0.411059] pps_core: LinuxPPS API ver. 1 registered
[    0.411059] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.411059] initcall pps_init+0x0/0xb7 returned 0 after 976 usecs
[    0.411059] calling  ptp_init+0x0/0xa4 @ 1
[    0.412038] PTP clock support registered
[    0.412038] initcall ptp_init+0x0/0xa4 returned 0 after 0 usecs
[    0.412038] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.412048] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.412048] calling  hwmon_init+0x0/0xf6 @ 1
[    0.412048] initcall hwmon_init+0x0/0xf6 returned 0 after 0 usecs
[    0.412048] calling  leds_init+0x0/0x40 @ 1
[    0.412048] initcall leds_init+0x0/0x40 returned 0 after 0 usecs
[    0.412048] calling  efisubsys_init+0x0/0x12c @ 1
[    0.412048] initcall efisubsys_init+0x0/0x12c returned 0 after 0 usecs
[    0.412048] calling  pci_subsys_init+0x0/0x4f @ 1
[    0.412048] PCI: System does not support PCI
[    0.412048] PCI: System does not support PCI
[    0.412048] initcall pci_subsys_init+0x0/0x4f returned 0 after 0 usecs
[    0.412048] calling  proto_init+0x0/0x12 @ 1
[    0.412053] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.412058] calling  net_dev_init+0x0/0x1c6 @ 1
[    0.413051] initcall net_dev_init+0x0/0x1c6 returned 0 after 976 usecs
[    0.413051] calling  neigh_init+0x0/0x80 @ 1
[    0.413051] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.413051] calling  fib_rules_init+0x0/0xaf @ 1
[    0.413051] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
[    0.413053] calling  pktsched_init+0x0/0x10a @ 1
[    0.413066] initcall pktsched_init+0x0/0x10a returned 0 after 0 usecs
[    0.413070] calling  tc_filter_init+0x0/0x55 @ 1
[    0.413074] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    0.413078] calling  tc_action_init+0x0/0x55 @ 1
[    0.413081] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    0.413085] calling  genl_init+0x0/0x80 @ 1
[    0.413120] initcall genl_init+0x0/0x80 returned 0 after 0 usecs
[    0.413125] calling  cipso_v4_init+0x0/0x61 @ 1
[    0.413131] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    0.413135] calling  netlbl_init+0x0/0x81 @ 1
[    0.413137] NetLabel: Initializing
[    0.413140] NetLabel:  domain hash size = 128
[    0.413142] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.413190] NetLabel:  unlabeled traffic allowed by default
[    0.413194] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.413199] calling  rfkill_init+0x0/0x79 @ 1
[    0.413221] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    0.413221] calling  xen_p2m_debugfs+0x0/0x4a @ 1
[    0.413221] initcall xen_p2m_debugfs+0x0/0x4a returned 0 after 0 usecs
[    0.413221] calling  xen_spinlock_debugfs+0x0/0x13a @ 1
[    0.413221] initcall xen_spinlock_debugfs+0x0/0x13a returned 0 after 0 usecs
[    0.413221] calling  nmi_warning_debugfs+0x0/0x27 @ 1
[    0.413221] initcall nmi_warning_debugfs+0x0/0x27 returned 0 after 0 usecs
[    0.413221] calling  hpet_late_init+0x0/0x101 @ 1
[    0.413221] initcall hpet_late_init+0x0/0x101 returned -19 after 0 usecs
[    0.413221] calling  init_amd_nbs+0x0/0xb8 @ 1
[    0.413221] initcall init_amd_nbs+0x0/0xb8 returned 0 after 0 usecs
[    0.413221] calling  clocksource_done_booting+0x0/0x42 @ 1
[    0.413221] Switched to clocksource xen
[    0.413221] initcall clocksource_done_booting+0x0/0x42 returned 0 after 6 usecs
[    0.413221] calling  tracer_init_debugfs+0x0/0x1b2 @ 1
[    0.413842] initcall tracer_init_debugfs+0x0/0x1b2 returned 0 after 656 usecs
[    0.413842] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.413842] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 6 usecs
[    0.413842] calling  event_trace_init+0x0/0x206 @ 1
[    0.430557] initcall event_trace_init+0x0/0x206 returned 0 after 16445 usecs
[    0.430566] calling  init_kprobe_trace+0x0/0x93 @ 1
[    0.430583] initcall init_kprobe_trace+0x0/0x93 returned 0 after 12 usecs
[    0.430588] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.430717] initcall init_pipe_fs+0x0/0x4c returned 0 after 123 usecs
[    0.430722] calling  eventpoll_init+0x0/0xda @ 1
[    0.430869] initcall eventpoll_init+0x0/0xda returned 0 after 140 usecs
[    0.430873] calling  anon_inode_init+0x0/0x5b @ 1
[    0.430997] initcall anon_inode_init+0x0/0x5b returned 0 after 117 usecs
[    0.431001] calling  blk_scsi_ioctl_init+0x0/0x2c5 @ 1
[    0.431005] initcall blk_scsi_ioctl_init+0x0/0x2c5 returned 0 after 0 usecs
[    0.431009] calling  acpi_event_init+0x0/0x5d @ 1
[    0.431013] initcall acpi_event_init+0x0/0x5d returned 0 after 0 usecs
[    0.431017] calling  pnp_system_init+0x0/0x12 @ 1
[    0.611471] initcall pnp_system_init+0x0/0x12 returned 0 after 280 usecs
[    0.611479] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.611482] pnp: PnP ACPI: disabled
[    0.611493] initcall pnpacpi_init+0x0/0x8c returned 0 after 2 usecs
[    0.611497] calling  pcistub_init+0x0/0x29f @ 1
[    0.611716] initcall pcistub_init+0x0/0x29f returned 0 after 207 usecs
[    0.611724] calling  chr_dev_init+0x0/0xc6 @ 1
[    0.622355] initcall chr_dev_init+0x0/0xc6 returned 0 after 10376 usecs
[    0.622363] calling  firmware_class_init+0x0/0xec @ 1
[    0.622601] initcall firmware_class_init+0x0/0xec returned 0 after 227 usecs
[    0.622614] calling  init_pcmcia_bus+0x0/0x65 @ 1
[    0.622757] kworker/u16:0 (420) used greatest stack depth: 5392 bytes left
[    0.622805] initcall init_pcmcia_bus+0x0/0x65 returned 0 after 181 usecs
[    0.622813] calling  thermal_init+0x0/0xb0 @ 1
[    0.622965] initcall thermal_init+0x0/0xb0 returned 0 after 144 usecs
[    0.622971] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.622976] initcall cpufreq_gov_performance_init+0x0/0x12 returned -19 after 0 usecs
[    0.622981] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
[    0.622985] initcall init_acpi_pm_clocksource+0x0/0xec returned -19 after 0 usecs
[    0.622989] calling  pcibios_assign_resources+0x0/0xbd @ 1
[    0.622994] initcall pcibios_assign_resources+0x0/0xbd returned 0 after 0 usecs
[    0.622999] calling  sysctl_core_init+0x0/0x2c @ 1
[    0.623021] initcall sysctl_core_init+0x0/0x2c returned 0 after 18 usecs
[    0.623025] calling  inet_init+0x0/0x2a1 @ 1
[    0.623245] NET: Registered protocol family 2
[    0.623869] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.623952] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.623985] TCP: Hash tables configured (established 16384 bind 16384)
[    0.624028] TCP: reno registered
[    0.624046] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.624077] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.624508] initcall inet_init+0x0/0x2a1 returned 0 after 1443 usecs
[    0.624514] calling  ipv4_offload_init+0x0/0x50 @ 1
[    0.624518] initcall ipv4_offload_init+0x0/0x50 returned 0 after 0 usecs
[    0.624522] calling  af_unix_init+0x0/0x55 @ 1
[    0.624563] NET: Registered protocol family 1
[    0.624584] initcall af_unix_init+0x0/0x55 returned 0 after 57 usecs
[    0.624589] calling  ipv6_offload_init+0x0/0x6e @ 1
[    0.624594] initcall ipv6_offload_init+0x0/0x6e returned 0 after 0 usecs
[    0.624598] calling  init_sunrpc+0x0/0x69 @ 1
[    0.624915] RPC: Registered named UNIX socket transport module.
[    0.624920] RPC: Registered udp transport module.
[    0.624923] RPC: Registered tcp transport module.
[    0.624925] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.624930] initcall init_sunrpc+0x0/0x69 returned 0 after 320 usecs
[    0.624934] calling  pci_apply_final_quirks+0x0/0x117 @ 1
[    0.624938] PCI: CLS 0 bytes, default 64
[    0.624941] initcall pci_apply_final_quirks+0x0/0x117 returned 0 after 3 usecs
[    0.624946] calling  populate_rootfs+0x0/0x112 @ 1
[    0.625096] Unpacking initramfs...
[    1.887681] Freeing initrd memory: 80732K (ffff8800023e9000 - ffff8800072c0000)
[    1.887706] initcall populate_rootfs+0x0/0x112 returned 0 after 1233150 usecs
[    1.887712] calling  pci_iommu_init+0x0/0x41 @ 1
[    1.887716] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    1.887721] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
[    1.887725] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
[    1.887747] calling  i8259A_init_ops+0x0/0x21 @ 1
[    1.887752] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
[    1.887755] calling  vsyscall_init+0x0/0x27 @ 1
[    1.887806] initcall vsyscall_init+0x0/0x27 returned 0 after 46 usecs
[    1.887810] calling  sbf_init+0x0/0xf6 @ 1
[    1.887813] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
[    1.887817] calling  init_tsc_clocksource+0x0/0xc2 @ 1
[    1.887830] initcall init_tsc_clocksource+0x0/0xc2 returned 0 after 1 usecs
[    1.887834] calling  add_rtc_cmos+0x0/0x96 @ 1
[    1.888120] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.888127] initcall add_rtc_cmos+0x0/0x96 returned 0 after 282 usecs
[    1.888131] calling  i8237A_init_ops+0x0/0x14 @ 1
[    1.888134] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.888138] calling  cache_sysfs_init+0x0/0x65 @ 1
[    1.888599] initcall cache_sysfs_init+0x0/0x65 returned 0 after 445 usecs
[    1.888604] calling  amd_uncore_init+0x0/0x130 @ 1
[    1.888608] initcall amd_uncore_init+0x0/0x130 returned -19 after 0 usecs
[    1.888612] calling  amd_iommu_pc_init+0x0/0x150 @ 1
[    1.888615] initcall amd_iommu_pc_init+0x0/0x150 returned -19 after 0 usecs
[    1.888619] calling  intel_uncore_init+0x0/0x3ad @ 1
[    1.888623] initcall intel_uncore_init+0x0/0x3ad returned -19 after 0 usecs
[    1.888628] calling  inject_init+0x0/0x30 @ 1
[    1.888631] Machine check injector initialized
[    1.888635] initcall inject_init+0x0/0x30 returned 0 after 3 usecs
[    1.888639] calling  thermal_throttle_init_device+0x0/0x9c @ 1
[    1.888643] initcall thermal_throttle_init_device+0x0/0x9c returned 0 after 0 usecs
[    1.888648] calling  amd_ibs_init+0x0/0x48d @ 1
[    1.888651] initcall amd_ibs_init+0x0/0x48d returned -19 after 0 usecs
[    1.888656] calling  msr_init+0x0/0x162 @ 1
[    1.889508] initcall msr_init+0x0/0x162 returned 0 after 827 usecs
[    1.889516] calling  cpuid_init+0x0/0x162 @ 1
[    1.890094] initcall cpuid_init+0x0/0x162 returned 0 after 558 usecs
[    1.890101] calling  ioapic_init_ops+0x0/0x14 @ 1
[    1.890105] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.890109] calling  add_pcspkr+0x0/0x40 @ 1
[    1.890271] initcall add_pcspkr+0x0/0x40 returned 0 after 153 usecs
[    1.890277] calling  microcode_init+0x0/0x1b1 @ 1
[    1.890449] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x17
[    1.890469] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x17
[    1.890495] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x17
[    1.890676] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.890686] initcall microcode_init+0x0/0x1b1 returned 0 after 394 usecs
[    1.890692] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    1.890695] Scanning for low memory corruption every 60 seconds
[    1.890701] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 5 usecs
[    1.890706] calling  sysfb_init+0x0/0x6f @ 1
[    1.890863] initcall sysfb_init+0x0/0x6f returned 0 after 149 usecs
[    1.890869] calling  audit_classes_init+0x0/0xaf @ 1
[    1.890889] initcall audit_classes_init+0x0/0xaf returned 0 after 15 usecs
[    1.890894] calling  pt_dump_init+0x0/0x30 @ 1
[    1.890912] initcall pt_dump_init+0x0/0x30 returned 0 after 14 usecs
[    1.890916] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    1.890930] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 9 usecs
[    1.890935] calling  proc_execdomains_init+0x0/0x22 @ 1
[    1.890946] initcall proc_execdomains_init+0x0/0x22 returned 0 after 7 usecs
[    1.890951] calling  ioresources_init+0x0/0x3c @ 1
[    1.890964] initcall ioresources_init+0x0/0x3c returned 0 after 9 usecs
[    1.890968] calling  uid_cache_init+0x0/0x85 @ 1
[    1.891021] initcall uid_cache_init+0x0/0x85 returned 0 after 46 usecs
[    1.891026] calling  init_posix_timers+0x0/0x240 @ 1
[    1.891083] initcall init_posix_timers+0x0/0x240 returned 0 after 52 usecs
[    1.891088] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    1.891092] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    1.891096] calling  proc_schedstat_init+0x0/0x22 @ 1
[    1.891105] initcall proc_schedstat_init+0x0/0x22 returned 0 after 5 usecs
[    1.891109] calling  snapshot_device_init+0x0/0x12 @ 1
[    1.891271] initcall snapshot_device_init+0x0/0x12 returned 0 after 154 usecs
[    1.891276] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    1.891279] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.891284] calling  create_proc_profile+0x0/0x300 @ 1
[    1.891287] initcall create_proc_profile+0x0/0x300 returned 0 after 0 usecs
[    1.891291] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    1.891294] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.891298] calling  init_clocksource_sysfs+0x0/0x69 @ 1
[    1.891572] initcall init_clocksource_sysfs+0x0/0x69 returned 0 after 263 usecs
[    1.891577] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    1.891586] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 5 usecs
[    1.891590] calling  alarmtimer_init+0x0/0x15f @ 1
[    1.891837] initcall alarmtimer_init+0x0/0x15f returned 0 after 236 usecs
[    1.891841] calling  clockevents_init_sysfs+0x0/0xd2 @ 1
[    1.893121] initcall clockevents_init_sysfs+0x0/0xd2 returned 0 after 1245 usecs
[    1.893127] calling  init_tstats_procfs+0x0/0x2c @ 1
[    1.893136] initcall init_tstats_procfs+0x0/0x2c returned 0 after 5 usecs
[    1.893139] calling  futex_init+0x0/0x65 @ 1
[    1.893148] initcall futex_init+0x0/0x65 returned 0 after 4 usecs
[    1.893151] calling  proc_dma_init+0x0/0x22 @ 1
[    1.893162] initcall proc_dma_init+0x0/0x22 returned 0 after 7 usecs
[    1.893166] calling  proc_modules_init+0x0/0x22 @ 1
[    1.893174] initcall proc_modules_init+0x0/0x22 returned 0 after 4 usecs
[    1.893178] calling  kallsyms_init+0x0/0x25 @ 1
[    1.893185] initcall kallsyms_init+0x0/0x25 returned 0 after 4 usecs
[    2.087365] calling  crash_save_vmcoreinfo_init+0x0/0x53f @ 1
[    2.087389] initcall crash_save_vmcoreinfo_init+0x0/0x53f returned 0 after 18 usecs
[    2.087394] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    2.087419] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 20 usecs
[    2.087425] calling  pid_namespaces_init+0x0/0x2d @ 1
[    2.087471] initcall pid_namespaces_init+0x0/0x2d returned 0 after 41 usecs
[    2.087476] calling  ikconfig_init+0x0/0x3c @ 1
[    2.087499] initcall ikconfig_init+0x0/0x3c returned 0 after 19 usecs
[    2.087503] calling  audit_init+0x0/0x141 @ 1
[    2.087506] audit: initializing netlink socket (disabled)
[    2.087544] type=2000 audit(1383788098.155:1): initialized
[    2.087558] initcall audit_init+0x0/0x141 returned 0 after 49 usecs
[    2.087561] calling  audit_watch_init+0x0/0x3a @ 1
[    2.087567] initcall audit_watch_init+0x0/0x3a returned 0 after 1 usecs
[    2.087571] calling  audit_tree_init+0x0/0x49 @ 1
[    2.087576] initcall audit_tree_init+0x0/0x49 returned 0 after 1 usecs
[    2.087580] calling  init_kprobes+0x0/0x19f @ 1
[    2.099491] initcall init_kprobes+0x0/0x19f returned 0 after 11628 usecs
[    2.099497] calling  hung_task_init+0x0/0x56 @ 1
[    2.099631] initcall hung_task_init+0x0/0x56 returned 0 after 125 usecs
[    2.099639] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    2.099655] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    2.099661] calling  init_tracepoints+0x0/0x20 @ 1
[    2.099665] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    2.099669] calling  init_blk_tracer+0x0/0x5a @ 1
[    2.099681] initcall init_blk_tracer+0x0/0x5a returned 0 after 8 usecs
[    2.099685] calling  irq_work_init_cpu_notifier+0x0/0x29 @ 1
[    2.099689] initcall irq_work_init_cpu_notifier+0x0/0x29 returned 0 after 0 usecs
[    2.099694] calling  perf_event_sysfs_init+0x0/0x93 @ 1
[    2.100308] initcall perf_event_sysfs_init+0x0/0x93 returned 0 after 594 usecs
[    2.100316] calling  init_per_zone_wmark_min+0x0/0xa9 @ 1
[    2.100397] initcall init_per_zone_wmark_min+0x0/0xa9 returned 0 after 74 usecs
[    2.100404] calling  kswapd_init+0x0/0x76 @ 1
[    2.100548] initcall kswapd_init+0x0/0x76 returned 0 after 135 usecs
[    2.100553] calling  extfrag_debug_init+0x0/0x7e @ 1
[    2.100585] initcall extfrag_debug_init+0x0/0x7e returned 0 after 26 usecs
[    2.100590] calling  setup_vmstat+0x0/0xc1 @ 1
[    2.100616] initcall setup_vmstat+0x0/0xc1 returned 0 after 22 usecs
[    2.100621] calling  mm_sysfs_init+0x0/0x29 @ 1
[    2.100636] initcall mm_sysfs_init+0x0/0x29 returned 0 after 10 usecs
[    2.100640] calling  mm_compute_batch_init+0x0/0x19 @ 1
[    2.100644] initcall mm_compute_batch_init+0x0/0x19 returned 0 after 0 usecs
[    2.100649] calling  slab_proc_init+0x0/0x25 @ 1
[    2.100657] initcall slab_proc_init+0x0/0x25 returned 0 after 4 usecs
[    2.100662] calling  init_reserve_notifier+0x0/0x26 @ 1
[    2.100665] initcall init_reserve_notifier+0x0/0x26 returned 0 after 0 usecs
[    2.100670] calling  init_admin_reserve+0x0/0x40 @ 1
[    2.100674] initcall init_admin_reserve+0x0/0x40 returned 0 after 0 usecs
[    2.100678] calling  init_user_reserve+0x0/0x40 @ 1
[    2.100681] initcall init_user_reserve+0x0/0x40 returned 0 after 0 usecs
[    2.100685] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    2.100694] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 4 usecs
[    2.100698] calling  procswaps_init+0x0/0x22 @ 1
[    2.100706] initcall procswaps_init+0x0/0x22 returned 0 after 4 usecs
[    2.100710] calling  init_frontswap+0x0/0x96 @ 1
[    2.100751] initcall init_frontswap+0x0/0x96 returned 0 after 37 usecs
[    2.100755] calling  hugetlb_init+0x0/0x456 @ 1
[    2.100759] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.100830] initcall hugetlb_init+0x0/0x456 returned 0 after 69 usecs
[    2.100834] calling  mmu_notifier_init+0x0/0x12 @ 1
[    2.100853] initcall mmu_notifier_init+0x0/0x12 returned 0 after 15 usecs
[    2.100857] calling  slab_proc_init+0x0/0x8 @ 1
[    2.100860] initcall slab_proc_init+0x0/0x8 returned 0 after 0 usecs
[    2.100863] calling  cpucache_init+0x0/0x4b @ 1
[    2.100869] initcall cpucache_init+0x0/0x4b returned 0 after 2 usecs
[    2.100872] calling  hugepage_init+0x0/0x145 @ 1
[    2.100876] initcall hugepage_init+0x0/0x145 returned -22 after 0 usecs
[    2.100880] calling  init_cleancache+0x0/0xbc @ 1
[    2.100920] initcall init_cleancache+0x0/0xbc returned 0 after 36 usecs
[    2.100924] calling  fcntl_init+0x0/0x2a @ 1
[    2.100965] initcall fcntl_init+0x0/0x2a returned 0 after 36 usecs
[    2.100969] calling  proc_filesystems_init+0x0/0x22 @ 1
[    2.100977] initcall proc_filesystems_init+0x0/0x22 returned 0 after 5 usecs
[    2.100982] calling  dio_init+0x0/0x2d @ 1
[    2.101020] initcall dio_init+0x0/0x2d returned 0 after 33 usecs
[    2.101024] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    2.101141] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 110 usecs
[    2.101146] calling  dnotify_init+0x0/0x7b @ 1
[    2.101217] initcall dnotify_init+0x0/0x7b returned 0 after 66 usecs
[    2.101222] calling  inotify_user_setup+0x0/0x70 @ 1
[    2.101284] initcall inotify_user_setup+0x0/0x70 returned 0 after 57 usecs
[    2.101288] calling  aio_setup+0x0/0x52 @ 1
[    2.101351] initcall aio_setup+0x0/0x52 returned 0 after 57 usecs
[    2.101355] calling  proc_locks_init+0x0/0x22 @ 1
[    2.101363] initcall proc_locks_init+0x0/0x22 returned 0 after 4 usecs
[    2.101367] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    2.101425] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 53 usecs
[    2.288065] calling  dquot_init+0x0/0x121 @ 1
[    2.288069] VFS: Disk quotas dquot_6.5.2
[    2.288268] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.288276] initcall dquot_init+0x0/0x121 returned 0 after 200 usecs
[    2.288280] calling  init_v2_quota_format+0x0/0x22 @ 1
[    2.288283] initcall init_v2_quota_format+0x0/0x22 returned 0 after 0 usecs
[    2.288287] calling  quota_init+0x0/0x31 @ 1
[    2.288307] initcall quota_init+0x0/0x31 returned 0 after 16 usecs
[    2.288311] calling  proc_cmdline_init+0x0/0x22 @ 1
[    2.288320] initcall proc_cmdline_init+0x0/0x22 returned 0 after 5 usecs
[    2.288324] calling  proc_consoles_init+0x0/0x22 @ 1
[    2.288334] initcall proc_consoles_init+0x0/0x22 returned 0 after 5 usecs
[    2.288338] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    2.288346] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 4 usecs
[    2.288350] calling  proc_devices_init+0x0/0x22 @ 1
[    2.288358] initcall proc_devices_init+0x0/0x22 returned 0 after 4 usecs
[    2.288362] calling  proc_interrupts_init+0x0/0x22 @ 1
[    2.288369] initcall proc_interrupts_init+0x0/0x22 returned 0 after 4 usecs
[    2.288373] calling  proc_loadavg_init+0x0/0x22 @ 1
[    2.288381] initcall proc_loadavg_init+0x0/0x22 returned 0 after 4 usecs
[    2.288385] calling  proc_meminfo_init+0x0/0x22 @ 1
[    2.288393] initcall proc_meminfo_init+0x0/0x22 returned 0 after 4 usecs
[    2.288397] calling  proc_stat_init+0x0/0x22 @ 1
[    2.288404] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
[    2.288408] calling  proc_uptime_init+0x0/0x22 @ 1
[    2.288415] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
[    2.288419] calling  proc_version_init+0x0/0x22 @ 1
[    2.288427] initcall proc_version_init+0x0/0x22 returned 0 after 4 usecs
[    2.288431] calling  proc_softirqs_init+0x0/0x22 @ 1
[    2.288439] initcall proc_softirqs_init+0x0/0x22 returned 0 after 4 usecs
[    2.288443] calling  proc_kcore_init+0x0/0xb5 @ 1
[    2.288463] initcall proc_kcore_init+0x0/0xb5 returned 0 after 16 usecs
[    2.288468] calling  vmcore_init+0x0/0x60e @ 1
[    2.288472] initcall vmcore_init+0x0/0x60e returned 0 after 0 usecs
[    2.288475] calling  proc_kmsg_init+0x0/0x25 @ 1
[    2.288484] initcall proc_kmsg_init+0x0/0x25 returned 0 after 5 usecs
[    2.288488] calling  proc_page_init+0x0/0x42 @ 1
[    2.288507] initcall proc_page_init+0x0/0x42 returned 0 after 15 usecs
[    2.288512] calling  init_devpts_fs+0x0/0x62 @ 1
[    2.288669] initcall init_devpts_fs+0x0/0x62 returned 0 after 149 usecs
[    2.288674] calling  init_ramfs_fs+0x0/0x4d @ 1
[    2.288756] initcall init_ramfs_fs+0x0/0x4d returned 0 after 77 usecs
[    2.288761] calling  init_hugetlbfs_fs+0x0/0x180 @ 1
[    2.289039] initcall init_hugetlbfs_fs+0x0/0x180 returned 0 after 267 usecs
[    2.289045] calling  init_fat_fs+0x0/0x4f @ 1
[    2.289133] initcall init_fat_fs+0x0/0x4f returned 0 after 81 usecs
[    2.289137] calling  init_vfat_fs+0x0/0x12 @ 1
[    2.289141] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    2.289145] calling  init_msdos_fs+0x0/0x12 @ 1
[    2.289149] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    2.289153] calling  init_iso9660_fs+0x0/0x70 @ 1
[    2.289209] initcall init_iso9660_fs+0x0/0x70 returned 0 after 50 usecs
[    2.289213] calling  init_nfs_fs+0x0/0x16c @ 1
[    2.289623] initcall init_nfs_fs+0x0/0x16c returned 0 after 395 usecs
[    2.289630] calling  init_nfs_v2+0x0/0x14 @ 1
[    2.289635] initcall init_nfs_v2+0x0/0x14 returned 0 after 0 usecs
[    2.289639] calling  init_nfs_v3+0x0/0x14 @ 1
[    2.289642] initcall init_nfs_v3+0x0/0x14 returned 0 after 0 usecs
[    2.289646] calling  init_nfs_v4+0x0/0x3b @ 1
[    2.289649] NFS: Registering the id_resolver key type
[    2.289668] Key type id_resolver registered
[    2.289671] Key type id_legacy registered
[    2.289680] initcall init_nfs_v4+0x0/0x3b returned 0 after 29 usecs
[    2.289685] calling  init_nlm+0x0/0x4c @ 1
[    2.289697] initcall init_nlm+0x0/0x4c returned 0 after 9 usecs
[    2.289701] calling  init_nls_cp437+0x0/0x12 @ 1
[    2.289705] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    2.289709] calling  init_nls_ascii+0x0/0x12 @ 1
[    2.289713] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    2.289717] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    2.289720] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    2.289724] calling  init_nls_utf8+0x0/0x2b @ 1
[    2.289728] initcall init_nls_utf8+0x0/0x2b returned 0 after 0 usecs
[    2.289732] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    2.289734] NTFS driver 2.1.30 [Flags: R/W].
[    2.289880] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 140 usecs
[    2.289885] calling  init_autofs4_fs+0x0/0x2a @ 1
[    2.290044] initcall init_autofs4_fs+0x0/0x2a returned 0 after 151 usecs
[    2.290051] calling  init_pstore_fs+0x0/0x53 @ 1
[    2.488405] initcall init_pstore_fs+0x0/0x53 returned 0 after 19 usecs
[    2.488410] calling  ipc_init+0x0/0x2f @ 1
[    2.488429] msgmni has been set to 1944
[    2.488445] initcall ipc_init+0x0/0x2f returned 0 after 30 usecs
[    2.488456] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    2.488471] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    2.488476] calling  init_mqueue_fs+0x0/0xa2 @ 1
[    2.488693] initcall init_mqueue_fs+0x0/0xa2 returned 0 after 208 usecs
[    2.488699] calling  key_proc_init+0x0/0x5e @ 1
[    2.488720] initcall key_proc_init+0x0/0x5e returned 0 after 16 usecs
[    2.488724] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    2.488727] SELinux:  Registering netfilter hooks
[    2.489371] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 627 usecs
[    2.489377] calling  init_sel_fs+0x0/0xa5 @ 1
[    2.489880] initcall init_sel_fs+0x0/0xa5 returned 0 after 486 usecs
[    2.489886] calling  selnl_init+0x0/0x56 @ 1
[    2.489909] initcall selnl_init+0x0/0x56 returned 0 after 18 usecs
[    2.489914] calling  sel_netif_init+0x0/0x5c @ 1
[    2.489921] initcall sel_netif_init+0x0/0x5c returned 0 after 3 usecs
[    2.489925] calling  sel_netnode_init+0x0/0x6a @ 1
[    2.489932] initcall sel_netnode_init+0x0/0x6a returned 0 after 2 usecs
[    2.489936] calling  sel_netport_init+0x0/0x6a @ 1
[    2.489942] initcall sel_netport_init+0x0/0x6a returned 0 after 2 usecs
[    2.489946] calling  aurule_init+0x0/0x2d @ 1
[    2.489951] initcall aurule_init+0x0/0x2d returned 0 after 1 usecs
[    2.489956] calling  crypto_wq_init+0x0/0x33 @ 1
[    2.490055] initcall crypto_wq_init+0x0/0x33 returned 0 after 91 usecs
[    2.490063] calling  crypto_algapi_init+0x0/0xd @ 1
[    2.490076] initcall crypto_algapi_init+0x0/0xd returned 0 after 9 usecs
[    2.490081] calling  skcipher_module_init+0x0/0x35 @ 1
[    2.490085] initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
[    2.490089] calling  chainiv_module_init+0x0/0x12 @ 1
[    2.490093] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.490097] calling  eseqiv_module_init+0x0/0x12 @ 1
[    2.490101] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.490106] calling  hmac_module_init+0x0/0x12 @ 1
[    2.490109] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.490113] calling  md5_mod_init+0x0/0x12 @ 1
[    2.490195] initcall md5_mod_init+0x0/0x12 returned 0 after 74 usecs
[    2.490203] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    2.490286] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 75 usecs
[    2.490293] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    2.490298] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.490302] calling  des_generic_mod_init+0x0/0x17 @ 1
[    2.490474] initcall des_generic_mod_init+0x0/0x17 returned 0 after 161 usecs
[    2.490482] calling  aes_init+0x0/0x12 @ 1
[    2.490555] initcall aes_init+0x0/0x12 returned 0 after 66 usecs
[    2.490562] calling  zlib_mod_init+0x0/0x12 @ 1
[    2.490641] initcall zlib_mod_init+0x0/0x12 returned 0 after 71 usecs
[    2.490646] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    2.490651] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.490655] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    2.490660] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.490664] calling  krng_mod_init+0x0/0x12 @ 1
[    2.490734] initcall krng_mod_init+0x0/0x12 returned 0 after 64 usecs
[    2.490738] calling  proc_genhd_init+0x0/0x3c @ 1
[    2.490752] initcall proc_genhd_init+0x0/0x3c returned 0 after 10 usecs
[    2.490756] calling  bsg_init+0x0/0x12e @ 1
[    2.490921] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    2.490927] initcall bsg_init+0x0/0x12e returned 0 after 163 usecs
[    2.490930] calling  noop_init+0x0/0x12 @ 1
[    2.490933] io scheduler noop registered
[    2.490936] initcall noop_init+0x0/0x12 returned 0 after 2 usecs
[    2.490939] calling  deadline_init+0x0/0x12 @ 1
[    2.490942] io scheduler deadline registered
[    2.490945] initcall deadline_init+0x0/0x12 returned 0 after 2 usecs
[    2.490948] calling  cfq_init+0x0/0x8b @ 1
[    2.491010] io scheduler cfq registered (default)
[    2.491014] initcall cfq_init+0x0/0x8b returned 0 after 61 usecs
[    2.491018] calling  percpu_counter_startup+0x0/0x38 @ 1
[    2.491022] initcall percpu_counter_startup+0x0/0x38 returned 0 after 1 usecs
[    2.491027] calling  pci_proc_init+0x0/0x6a @ 1
[    2.491041] initcall pci_proc_init+0x0/0x6a returned 0 after 11 usecs
[    2.491045] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    2.491305] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 249 usecs
[    2.491310] calling  aer_service_init+0x0/0x2b @ 1
[    2.491413] initcall aer_service_init+0x0/0x2b returned 0 after 96 usecs
[    2.491417] calling  pci_hotplug_init+0x0/0x1d @ 1
[    2.491420] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.491423] initcall pci_hotplug_init+0x0/0x1d returned 0 after 2 usecs
[    2.688890] calling  pcifront_init+0x0/0x3f @ 1
[    2.691414] initcall pcifront_init+0x0/0x3f returned 0 after 2459 usecs
[    2.691421] calling  genericbl_driver_init+0x0/0x14 @ 1
[    2.691563] initcall genericbl_driver_init+0x0/0x14 returned 0 after 133 usecs
[    2.691571] calling  cirrusfb_init+0x0/0xcc @ 1
[    2.691715] initcall cirrusfb_init+0x0/0xcc returned 0 after 135 usecs
[    2.691721] calling  efifb_driver_init+0x0/0x14 @ 1
[    2.691853] initcall efifb_driver_init+0x0/0x14 returned 0 after 123 usecs
[    2.691861] calling  intel_idle_init+0x0/0x338 @ 1
[    2.691864] intel_idle: does not run on family 6 model 42
[    2.691868] initcall intel_idle_init+0x0/0x338 returned -19 after 3 usecs
[    2.691872] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    2.691876] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 usecs
[    2.691880] calling  acpi_ac_init+0x0/0x28 @ 1
[    2.691884] initcall acpi_ac_init+0x0/0x28 returned -19 after 0 usecs
[    2.691888] calling  acpi_button_driver_init+0x0/0x12 @ 1
[    2.691891] initcall acpi_button_driver_init+0x0/0x12 returned -19 after 0 usecs
[    2.691896] calling  acpi_fan_driver_init+0x0/0x12 @ 1
[    2.691900] initcall acpi_fan_driver_init+0x0/0x12 returned -19 after 0 usecs
[    2.691904] calling  acpi_processor_driver_init+0x0/0x43 @ 1
[    2.691908] initcall acpi_processor_driver_init+0x0/0x43 returned 0 after 0 usecs
[    2.691912] calling  acpi_thermal_init+0x0/0x42 @ 1
[    2.691916] initcall acpi_thermal_init+0x0/0x42 returned -19 after 0 usecs
[    2.691920] calling  acpi_battery_init+0x0/0x16 @ 1
[    2.691929] initcall acpi_battery_init+0x0/0x16 returned 0 after 5 usecs
[    2.691933] calling  acpi_hed_driver_init+0x0/0x12 @ 1
[    2.691937] initcall acpi_hed_driver_init+0x0/0x12 returned -19 after 0 usecs
[    2.691941] calling  erst_init+0x0/0x2fc @ 1
[    2.691945] initcall erst_init+0x0/0x2fc returned 0 after 0 usecs
[    2.691949] calling  ghes_init+0x0/0x173 @ 1
[    2.691952] initcall ghes_init+0x0/0x173 returned -19 after 0 usecs
[    2.691956] calling  einj_init+0x0/0x4a2 @ 1
[    2.691960] initcall einj_init+0x0/0x4a2 returned -19 after 0 usecs
[    2.691964] calling  ioat_init_module+0x0/0x80 @ 1
[    2.691967] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.692003] calling  1_acpi_battery_init_async+0x0/0x1b @ 6
[    2.692010] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 0 usecs
[    2.692222] initcall ioat_init_module+0x0/0x80 returned 0 after 247 usecs
[    2.692229] calling  virtio_mmio_init+0x0/0x14 @ 1
[    2.692379] initcall virtio_mmio_init+0x0/0x14 returned 0 after 141 usecs
[    2.692386] calling  virtio_balloon_driver_init+0x0/0x12 @ 1
[    2.692523] initcall virtio_balloon_driver_init+0x0/0x12 returned 0 after 128 usecs
[    2.692530] calling  xenbus_probe_initcall+0x0/0x39 @ 1
[    2.692535] initcall xenbus_probe_initcall+0x0/0x39 returned 0 after 0 usecs
[    2.692539] calling  xenbus_init+0x0/0x3d @ 1
[    2.692705] initcall xenbus_init+0x0/0x3d returned 0 after 157 usecs
[    2.692711] calling  xenbus_backend_init+0x0/0x51 @ 1
[    2.692715] initcall xenbus_backend_init+0x0/0x51 returned -19 after 0 usecs
[    2.692720] calling  gntdev_init+0x0/0x4d @ 1
[    2.692734] pcifront pci-0: Installing PCI frontend
[    2.692748] xen:swiotlb_xen: Warning: only able to allocate 4 MB for software IO TLB
[    2.696257] initcall gntdev_init+0x0/0x4d returned 0 after 3441 usecs
[    2.696272] calling  gntalloc_init+0x0/0x3d @ 1
[    2.696282] software IO TLB [mem 0x06800000-0x06c00000] (4MB) mapped at [ffff880006800000-ffff880006bfffff]
[    2.696463] initcall gntalloc_init+0x0/0x3d returned 0 after 181 usecs
[    2.696468] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    2.696472] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    2.696480] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    2.696499] pcifront pci-0: Creating PCI Frontend Bus 0000:00
[    2.696531] initcall hyper_sysfs_init+0x0/0xfb returned 0 after 45 usecs
[    2.696536] calling  platform_pci_module_init+0x0/0x1b @ 1
[    2.696672] initcall platform_pci_module_init+0x0/0x1b returned 0 after 127 usecs
[    2.696679] calling  xen_late_init_mcelog+0x0/0x3d @ 1
[    2.696683] initcall xen_late_init_mcelog+0x0/0x3d returned -19 after 0 usecs
[    2.696688] calling  xen_pcibk_init+0x0/0x13f @ 1
[    2.696691] initcall xen_pcibk_init+0x0/0x13f returned -19 after 0 usecs
[    2.696696] calling  xen_acpi_processor_init+0x0/0x24b @ 1
[    2.696700] initcall xen_acpi_processor_init+0x0/0x24b returned -19 after 0 usecs
[    2.696704] calling  pty_init+0x0/0x453 @ 1
[    2.696796] pcifront pci-0: PCI host bridge to bus 0000:00
[    2.696803] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    2.696810] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    2.696817] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.696999] pci 0000:00:00.0: [8086:10c9] type 00 class 0x020000
[    2.697109] pci 0000:00:00.0: reg 0x10: [mem 0xfbc20000-0xfbc3ffff]
[    2.697167] pci 0000:00:00.0: reg 0x14: [mem 0xfb800000-0xfbbfffff]
[    2.697224] pci 0000:00:00.0: reg 0x18: [io  0xe020-0xe03f]
[    2.697283] pci 0000:00:00.0: reg 0x1c: [mem 0xfbc44000-0xfbc47fff]
[    2.843783] pci 0000:00:00.0: reg 0x184: [mem 0xfbc48000-0xfbc4ffff 64bit]
[    2.843928] pci 0000:00:00.0: reg 0x190: [mem 0xfbc68000-0xfbc6ffff 64bit]
[    2.880239] initcall pty_init+0x0/0x453 returned 0 after 179225 usecs
[    2.880241] calling  sysrq_init+0x0/0xb0 @ 1
[    2.880252] initcall sysrq_init+0x0/0xb0 returned 0 after 10 usecs
[    2.880254] calling  xen_hvc_init+0x0/0x228 @ 1
[    2.881523] initcall xen_hvc_init+0x0/0x228 returned 0 after 1236 usecs
[    2.881524] calling  serial8250_init+0x0/0x1ab @ 1
[    2.881525] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.882715] initcall serial8250_init+0x0/0x1ab returned 0 after 1160 usecs
[    2.882717] calling  serial_pci_driver_init+0x0/0x1b @ 1
[    2.882823] initcall serial_pci_driver_init+0x0/0x1b returned 0 after 101 usecs
[    2.882824] calling  init_kgdboc+0x0/0x16 @ 1
[    2.882827] kgdb: Registered I/O driver kgdboc.
[    2.889300] initcall init_kgdboc+0x0/0x16 returned 0 after 6322 usecs
[    2.889308] calling  rand_initialize+0x0/0x30 @ 1
[    2.889320] initcall rand_initialize+0x0/0x30 returned 0 after 8 usecs
[    2.889325] calling  init+0x0/0x10f @ 1
[    2.889785] initcall init+0x0/0x10f returned 0 after 444 usecs
[    2.889792] calling  hpet_init+0x0/0x6a @ 1
[    2.890097] initcall hpet_init+0x0/0x6a returned -19 after 291 usecs
[    2.890104] calling  nvram_init+0x0/0x82 @ 1
[    2.890269] Non-volatile memory driver v1.3
[    2.890276] initcall nvram_init+0x0/0x82 returned 0 after 162 usecs
[    2.890297] calling  mod_init+0x0/0x5a @ 1
[    2.890302] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    2.890306] calling  rng_init+0x0/0x12 @ 1
[    2.890499] initcall rng_init+0x0/0x12 returned 0 after 183 usecs
[    2.890506] calling  agp_init+0x0/0x26 @ 1
[    2.890509] Linux agpgart interface v0.103
[    2.890512] initcall agp_init+0x0/0x26 returned 0 after 2 usecs
[    2.890518] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    2.890769] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 240 usecs
[    2.890775] calling  agp_intel_init+0x0/0x29 @ 1
[    2.890973] initcall agp_intel_init+0x0/0x29 returned 0 after 188 usecs
[    2.890980] calling  agp_sis_init+0x0/0x29 @ 1
[    2.891128] initcall agp_sis_init+0x0/0x29 returned 0 after 138 usecs
[    2.891135] calling  agp_via_init+0x0/0x29 @ 1
[    2.891275] initcall agp_via_init+0x0/0x29 returned 0 after 131 usecs
[    2.891282] calling  drm_core_init+0x0/0x10c @ 1
[    2.891439] [drm] Initialized drm 1.1.0 20060810
[    2.891446] initcall drm_core_init+0x0/0x10c returned 0 after 156 usecs
[    2.891450] calling  cn_proc_init+0x0/0x3d @ 1
[    2.891456] initcall cn_proc_init+0x0/0x3d returned 0 after 2 usecs
[    2.891462] calling  topology_sysfs_init+0x0/0x70 @ 1
[    2.891524] initcall topology_sysfs_init+0x0/0x70 returned 0 after 56 usecs
[    2.891529] calling  loop_init+0x0/0x14e @ 1
[    2.891894] pcifront pci-0: claiming resource 0000:00:00.0/0
[    2.891900] pcifront pci-0: claiming resource 0000:00:00.0/1
[    2.891903] pcifront pci-0: claiming resource 0000:00:00.0/2
[    2.891907] pcifront pci-0: claiming resource 0000:00:00.0/3
[    2.891910] pcifront pci-0: claiming resource 0000:00:00.0/7
[    2.891913] pcifront pci-0: claiming resource 0000:00:00.0/10
[    2.891918] pci 0000:00:00.0: address space collision: [mem 0xfbc68000-0xfbca7fff 64bit] conflicts with 0000:00:00.0 [mem 0xfbc48000-0xfbc87fff 64bit]
[    2.891924] pcifront pci-0: Could not claim resource 0000:00:00.0/10! Device offline. Try using e820_host=1 in the guest config.
[    2.899037] loop: module loaded
[    2.899048] initcall loop_init+0x0/0x14e returned 0 after 7336 usecs
[    2.899059] calling  xen_blkif_init+0x0/0x22 @ 1
[    2.899209] initcall xen_blkif_init+0x0/0x22 returned 0 after 142 usecs
[    2.899214] calling  mac_hid_init+0x0/0x22 @ 1
[    2.899227] initcall mac_hid_init+0x0/0x22 returned 0 after 9 usecs
[    2.899231] calling  macvlan_init_module+0x0/0x3d @ 1
[    2.899237] initcall macvlan_init_module+0x0/0x3d returned 0 after 2 usecs
[    2.899242] calling  macvtap_init+0x0/0x100 @ 1
[    2.899346] initcall macvtap_init+0x0/0x100 returned 0 after 98 usecs
[    2.899351] calling  net_olddevs_init+0x0/0xb5 @ 1
[    2.899356] initcall net_olddevs_init+0x0/0xb5 returned 0 after 1 usecs
[    2.899359] calling  fixed_mdio_bus_init+0x0/0x105 @ 1
[    2.899621] libphy: Fixed MDIO Bus: probed
[    2.899625] initcall fixed_mdio_bus_init+0x0/0x105 returned 0 after 255 usecs
[    2.899629] calling  tun_init+0x0/0x93 @ 1
[    2.899632] tun: Universal TUN/TAP device driver, 1.6
[    2.899634] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.899775] initcall tun_init+0x0/0x93 returned 0 after 139 usecs
[    2.899779] calling  tg3_driver_init+0x0/0x1b @ 1
[    2.899913] initcall tg3_driver_init+0x0/0x1b returned 0 after 126 usecs
[    2.899917] calling  ixgbevf_init_module+0x0/0x4c @ 1
[    3.090007] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
[    3.090012] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.090218] initcall ixgbevf_init_module+0x0/0x4c returned 0 after 203 usecs
[    3.090226] calling  forcedeth_pci_driver_init+0x0/0x1b @ 1
[    3.090368] initcall forcedeth_pci_driver_init+0x0/0x1b returned 0 after 134 usecs
[    3.090375] calling  netback_init+0x0/0x48 @ 1
[    3.090504] initcall netback_init+0x0/0x48 returned 0 after 121 usecs
[    3.090510] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    3.090514] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 0 usecs
[    3.090518] calling  yenta_socket_init+0x0/0x1b @ 1
[    3.090691] initcall yenta_socket_init+0x0/0x1b returned 0 after 163 usecs
[    3.090698] calling  mon_init+0x0/0xfe @ 1
[    3.091022] initcall mon_init+0x0/0xfe returned 0 after 312 usecs
[    3.091029] calling  ehci_hcd_init+0x0/0xb7 @ 1
[    3.091033] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.091036] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    3.091058] initcall ehci_hcd_init+0x0/0xb7 returned 0 after 24 usecs
[    3.091063] calling  ehci_pci_init+0x0/0x69 @ 1
[    3.091066] ehci-pci: EHCI PCI platform driver
[    3.091220] initcall ehci_pci_init+0x0/0x69 returned 0 after 147 usecs
[    3.091226] calling  ohci_hcd_mod_init+0x0/0x83 @ 1
[    3.091230] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.091233] ohci_hcd: block sizes: ed 80 td 96
[    3.091246] initcall ohci_hcd_mod_init+0x0/0x83 returned 0 after 15 usecs
[    3.091250] calling  ohci_pci_init+0x0/0x69 @ 1
[    3.091253] ohci-pci: OHCI PCI platform driver
[    3.091384] initcall ohci_pci_init+0x0/0x69 returned 0 after 126 usecs
[    3.091391] calling  uhci_hcd_init+0x0/0x129 @ 1
[    3.091394] uhci_hcd: USB Universal Host Controller Interface driver
[    3.091603] initcall uhci_hcd_init+0x0/0x129 returned 0 after 202 usecs
[    3.091609] calling  usblp_driver_init+0x0/0x1b @ 1
[    3.091765] usbcore: registered new interface driver usblp
[    3.091772] initcall usblp_driver_init+0x0/0x1b returned 0 after 155 usecs
[    3.091776] calling  kgdbdbgp_start_thread+0x0/0x4f @ 1
[    3.091780] initcall kgdbdbgp_start_thread+0x0/0x4f returned 0 after 0 usecs
[    3.091784] calling  i8042_init+0x0/0x3c5 @ 1
[    3.092305] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    4.101468] i8042: No controller found
[    4.101473] initcall i8042_init+0x0/0x3c5 returned -19 after 986020 usecs
[    4.101477] calling  serport_init+0x0/0x34 @ 1
[    4.101480] initcall serport_init+0x0/0x34 returned 0 after 0 usecs
[    4.101484] calling  mousedev_init+0x0/0x62 @ 1
[    4.101745] mousedev: PS/2 mouse device common for all mice
[    4.101751] initcall mousedev_init+0x0/0x62 returned 0 after 257 usecs
[    4.101755] calling  evdev_init+0x0/0x12 @ 1
[    4.101758] initcall evdev_init+0x0/0x12 returned 0 after 0 usecs
[    4.101762] calling  atkbd_init+0x0/0x27 @ 1
[    4.101929] initcall atkbd_init+0x0/0x27 returned 0 after 158 usecs
[    4.101935] calling  psmouse_init+0x0/0x82 @ 1
[    4.102248] initcall psmouse_init+0x0/0x82 returned 0 after 301 usecs
[    4.102254] calling  cmos_init+0x0/0x6a @ 1
[    4.162770] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    4.162938] rtc_cmos: probe of rtc_cmos failed with error -38
[    4.163323] initcall cmos_init+0x0/0x6a returned -19 after 59632 usecs
[    4.163331] calling  i2c_i801_init+0x0/0xd0 @ 1
[    4.163483] initcall i2c_i801_init+0x0/0xd0 returned 0 after 143 usecs
[    4.163491] calling  cpufreq_gov_dbs_init+0x0/0x12 @ 1
[    4.163496] initcall cpufreq_gov_dbs_init+0x0/0x12 returned -19 after 0 usecs
[    4.163501] calling  efivars_sysfs_init+0x0/0x220 @ 1
[    4.163505] initcall efivars_sysfs_init+0x0/0x220 returned -19 after 0 usecs
[    4.163509] calling  efivars_pstore_init+0x0/0xa2 @ 1
[    4.163513] initcall efivars_pstore_init+0x0/0xa2 returned 0 after 0 usecs
[    4.163517] calling  vhost_net_init+0x0/0x30 @ 1
[    4.163669] initcall vhost_net_init+0x0/0x30 returned 0 after 144 usecs
[    4.163674] calling  vhost_init+0x0/0x8 @ 1
[    4.163678] initcall vhost_init+0x0/0x8 returned 0 after 0 usecs
[    4.163682] calling  staging_init+0x0/0x8 @ 1
[    4.163685] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    4.163689] calling  zram_init+0x0/0x2fd @ 1
[    4.164297] zram: Created 1 device(s) ...
[    4.164304] initcall zram_init+0x0/0x2fd returned 0 after 596 usecs
[    4.164309] calling  zs_init+0x0/0x90 @ 1
[    4.164316] initcall zs_init+0x0/0x90 returned 0 after 3 usecs
[    4.164321] calling  eeepc_laptop_init+0x0/0x5a @ 1
[    4.164541] initcall eeepc_laptop_init+0x0/0x5a returned -19 after 210 usecs
[    4.164549] calling  sock_diag_init+0x0/0x12 @ 1
[    4.164575] initcall sock_diag_init+0x0/0x12 returned 0 after 21 usecs
[    4.164580] calling  flow_cache_init_global+0x0/0x19a @ 1
[    4.164675] initcall flow_cache_init_global+0x0/0x19a returned 0 after 87 usecs
[    4.164682] calling  llc_init+0x0/0x20 @ 1
[    4.164686] initcall llc_init+0x0/0x20 returned 0 after 0 usecs
[    4.164690] calling  snap_init+0x0/0x38 @ 1
[    4.164699] initcall snap_init+0x0/0x38 returned 0 after 5 usecs
[    4.164703] calling  blackhole_module_init+0x0/0x12 @ 1
[    4.164707] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.164712] calling  nfnetlink_init+0x0/0x59 @ 1
[    4.164715] Netfilter messages via NETLINK v0.30.
[    4.164738] initcall nfnetlink_init+0x0/0x59 returned 0 after 21 usecs
[    4.164743] calling  nfnetlink_log_init+0x0/0xb6 @ 1
[    4.164760] initcall nfnetlink_log_init+0x0/0xb6 returned 0 after 13 usecs
[    4.164765] calling  nf_conntrack_standalone_init+0x0/0x82 @ 1
[    4.164769] nf_conntrack version 0.5.0 (7778 buckets, 31112 max)
[    4.164970] initcall nf_conntrack_standalone_init+0x0/0x82 returned 0 after 195 usecs
[    4.164977] calling  ctnetlink_init+0x0/0xa4 @ 1
[    4.164980] ctnetlink v0.93: registering with nfnetlink.
[    4.164984] initcall ctnetlink_init+0x0/0xa4 returned 0 after 3 usecs
[    4.164988] calling  nf_conntrack_ftp_init+0x0/0x1ca @ 1
[    4.164998] initcall nf_conntrack_ftp_init+0x0/0x1ca returned 0 after 6 usecs
[    4.165003] calling  nf_conntrack_irc_init+0x0/0x173 @ 1
[    4.165012] initcall nf_conntrack_irc_init+0x0/0x173 returned 0 after 5 usecs
[    4.165017] calling  nf_conntrack_sip_init+0x0/0x215 @ 1
[    4.165021] initcall nf_conntrack_sip_init+0x0/0x215 returned 0 after 0 usecs
[    4.165025] calling  xt_init+0x0/0x118 @ 1
[    4.165035] initcall xt_init+0x0/0x118 returned 0 after 5 usecs
[    4.165039] calling  tcpudp_mt_init+0x0/0x17 @ 1
[    4.165043] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
[    4.165047] calling  connsecmark_tg_init+0x0/0x12 @ 1
[    4.165051] initcall connsecmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    4.165062] calling  nflog_tg_init+0x0/0x12 @ 1
[    4.165066] initcall nflog_tg_init+0x0/0x12 returned 0 after 0 usecs
[    4.165069] calling  secmark_tg_init+0x0/0x12 @ 1
[    4.165076] initcall secmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    4.165079] calling  tcpmss_tg_init+0x0/0x17 @ 1
[    4.165083] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
[    4.165086] calling  conntrack_mt_init+0x0/0x17 @ 1
[    4.165090] initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
[    4.165093] calling  policy_mt_init+0x0/0x17 @ 1
[    4.165096] initcall policy_mt_init+0x0/0x17 returned 0 after 0 usecs
[    4.165100] calling  state_mt_init+0x0/0x12 @ 1
[    4.165103] initcall state_mt_init+0x0/0x12 returned 0 after 0 usecs
[    4.165106] calling  sysctl_ipv4_init+0x0/0x92 @ 1
[    4.165146] initcall sysctl_ipv4_init+0x0/0x92 returned 0 after 35 usecs
[    4.165150] calling  init_syncookies+0x0/0x19 @ 1
[    4.165164] initcall init_syncookies+0x0/0x19 returned 0 after 10 usecs
[    4.165168] calling  tunnel4_init+0x0/0x72 @ 1
[    4.165171] initcall tunnel4_init+0x0/0x72 returned 0 after 0 usecs
[    4.165175] calling  ipv4_netfilter_init+0x0/0x12 @ 1
[    4.302226] initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 0 usecs
[    4.302231] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x17c @ 1
[    4.302522] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x17c returned 0 after 279 usecs
[    4.302528] calling  nf_defrag_init+0x0/0x17 @ 1
[    4.302532] initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
[    4.302535] calling  ip_tables_init+0x0/0xaa @ 1
[    4.302554] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.302558] initcall ip_tables_init+0x0/0xaa returned 0 after 19 usecs
[    4.302562] calling  iptable_filter_init+0x0/0x51 @ 1
[    4.302655] initcall iptable_filter_init+0x0/0x51 returned 0 after 87 usecs
[    4.302660] calling  iptable_mangle_init+0x0/0x51 @ 1
[    4.302754] initcall iptable_mangle_init+0x0/0x51 returned 0 after 88 usecs
[    4.302759] calling  reject_tg_init+0x0/0x12 @ 1
[    4.302762] initcall reject_tg_init+0x0/0x12 returned 0 after 0 usecs
[    4.302766] calling  ulog_tg_init+0x0/0x85 @ 1
[    4.302793] initcall ulog_tg_init+0x0/0x85 returned 0 after 22 usecs
[    4.302797] calling  cubictcp_register+0x0/0x5c @ 1
[    4.302800] TCP: cubic registered
[    4.302803] initcall cubictcp_register+0x0/0x5c returned 0 after 2 usecs
[    4.302806] calling  xfrm_user_init+0x0/0x4a @ 1
[    4.302809] Initializing XFRM netlink socket
[    4.302830] initcall xfrm_user_init+0x0/0x4a returned 0 after 20 usecs
[    4.302834] calling  inet6_init+0x0/0x37b @ 1
[    4.303099] NET: Registered protocol family 10
[    4.303781] initcall inet6_init+0x0/0x37b returned 0 after 920 usecs
[    4.303789] calling  ah6_init+0x0/0x79 @ 1
[    4.303792] initcall ah6_init+0x0/0x79 returned 0 after 0 usecs
[    4.303796] calling  esp6_init+0x0/0x79 @ 1
[    4.303800] initcall esp6_init+0x0/0x79 returned 0 after 0 usecs
[    4.303803] calling  xfrm6_transport_init+0x0/0x17 @ 1
[    4.303807] initcall xfrm6_transport_init+0x0/0x17 returned 0 after 0 usecs
[    4.303811] calling  xfrm6_mode_tunnel_init+0x0/0x17 @ 1
[    4.303815] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 0 usecs
[    4.303819] calling  xfrm6_beet_init+0x0/0x17 @ 1
[    4.303822] initcall xfrm6_beet_init+0x0/0x17 returned 0 after 0 usecs
[    4.303826] calling  ip6_tables_init+0x0/0xaa @ 1
[    4.303847] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.303851] initcall ip6_tables_init+0x0/0xaa returned 0 after 21 usecs
[    4.303855] calling  ip6table_filter_init+0x0/0x51 @ 1
[    4.304196] initcall ip6table_filter_init+0x0/0x51 returned 0 after 328 usecs
[    4.304201] calling  ip6table_mangle_init+0x0/0x51 @ 1
[    4.304357] initcall ip6table_mangle_init+0x0/0x51 returned 0 after 147 usecs
[    4.304363] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x154 @ 1
[    4.304378] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x154 returned 0 after 10 usecs
[    4.304383] calling  nf_defrag_init+0x0/0x54 @ 1
[    4.304413] initcall nf_defrag_init+0x0/0x54 returned 0 after 26 usecs
[    4.304418] calling  ipv6header_mt6_init+0x0/0x12 @ 1
[    4.304422] initcall ipv6header_mt6_init+0x0/0x12 returned 0 after 0 usecs
[    4.304426] calling  reject_tg6_init+0x0/0x12 @ 1
[    4.304429] initcall reject_tg6_init+0x0/0x12 returned 0 after 0 usecs
[    4.304433] calling  sit_init+0x0/0xcf @ 1
[    4.304435] sit: IPv6 over IPv4 tunneling driver
[    4.305202] initcall sit_init+0x0/0xcf returned 0 after 746 usecs
[    4.305207] calling  packet_init+0x0/0x47 @ 1
[    4.305210] NET: Registered protocol family 17
[    4.305221] initcall packet_init+0x0/0x47 returned 0 after 9 usecs
[    4.305225] calling  br_init+0x0/0xa2 @ 1
[    4.305267] initcall br_init+0x0/0xa2 returned 0 after 38 usecs
[    4.305272] calling  init_rpcsec_gss+0x0/0x64 @ 1
[    4.305326] initcall init_rpcsec_gss+0x0/0x64 returned 0 after 49 usecs
[    4.305330] calling  dcbnl_init+0x0/0x4d @ 1
[    4.305333] initcall dcbnl_init+0x0/0x4d returned 0 after 0 usecs
[    4.305337] calling  init_dns_resolver+0x0/0xe4 @ 1
[    4.305354] Key type dns_resolver registered
[    4.305358] initcall init_dns_resolver+0x0/0xe4 returned 0 after 16 usecs
[    4.305363] calling  mcheck_init_device+0x0/0x123 @ 1
[    4.305367] initcall mcheck_init_device+0x0/0x123 returned -5 after 0 usecs
[    4.305388] calling  tboot_late_init+0x0/0x243 @ 1
[    4.305392] initcall tboot_late_init+0x0/0x243 returned 0 after 0 usecs
[    4.305396] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    4.305417] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 17 usecs
[    4.305422] calling  severities_debugfs_init+0x0/0x3c @ 1
[    4.305434] initcall severities_debugfs_init+0x0/0x3c returned 0 after 8 usecs
[    4.305439] calling  threshold_init_device+0x0/0x50 @ 1
[    4.305443] initcall threshold_init_device+0x0/0x50 returned 0 after 0 usecs
[    4.305447] calling  hpet_insert_resource+0x0/0x23 @ 1
[    4.305451] initcall hpet_insert_resource+0x0/0x23 returned 1 after 0 usecs
[    4.305456] calling  update_mp_table+0x0/0x596 @ 1
[    4.305459] initcall update_mp_table+0x0/0x596 returned 0 after 0 usecs
[    4.305463] calling  lapic_insert_resource+0x0/0x3f @ 1
[    4.305468] initcall lapic_insert_resource+0x0/0x3f returned 0 after 1 usecs
[    4.305472] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    4.305475] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    4.305479] calling  print_ICs+0x0/0x466 @ 1
[    4.502749] initcall print_ICs+0x0/0x466 returned 0 after 0 usecs
[    4.502754] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    4.502758] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    4.502762] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    4.502765] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 0 usecs
[    4.502770] calling  init_oops_id+0x0/0x40 @ 1
[    4.502775] initcall init_oops_id+0x0/0x40 returned 0 after 1 usecs
[    4.502779] calling  pm_qos_power_init+0x0/0x7b @ 1
[    4.503292] initcall pm_qos_power_init+0x0/0x7b returned 0 after 495 usecs
[    4.503299] calling  pm_debugfs_init+0x0/0x24 @ 1
[    4.503313] initcall pm_debugfs_init+0x0/0x24 returned 0 after 9 usecs
[    4.503317] calling  printk_late_init+0x0/0x5a @ 1
[    4.503338] initcall printk_late_init+0x0/0x5a returned 0 after 17 usecs
[    4.503343] calling  tk_debug_sleep_time_init+0x0/0x3d @ 1
[    4.503354] initcall tk_debug_sleep_time_init+0x0/0x3d returned 0 after 7 usecs
[    4.503360] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[    4.503386] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 21 usecs
[    4.503391] calling  taskstats_init+0x0/0xa0 @ 1
[    4.503407] registered taskstats version 1
[    4.503411] initcall taskstats_init+0x0/0xa0 returned 0 after 16 usecs
[    4.503415] calling  clear_boot_tracer+0x0/0x2d @ 1
[    4.503419] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    4.503423] calling  kdb_ftrace_register+0x0/0x2f @ 1
[    4.503428] initcall kdb_ftrace_register+0x0/0x2f returned 0 after 1 usecs
[    4.503433] calling  max_swapfiles_check+0x0/0x8 @ 1
[    4.503436] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    4.503442] calling  set_recommended_min_free_kbytes+0x0/0xa0 @ 1
[    4.503446] initcall set_recommended_min_free_kbytes+0x0/0xa0 returned 0 after 0 usecs
[    4.503451] calling  kmemleak_late_init+0x0/0x93 @ 1
[    4.503521] kmemleak: Kernel memory leak detector initialized
[    4.503525] kmemleak: Automatic memory scanning thread started
[    4.503527] initcall kmemleak_late_init+0x0/0x93 returned 0 after 69 usecs
[    4.503530] calling  fail_make_request_debugfs+0x0/0x2a @ 1
[    4.503587] initcall fail_make_request_debugfs+0x0/0x2a returned 0 after 53 usecs
[    4.503592] calling  prandom_reseed+0x0/0xb4 @ 1
[    4.503609] initcall prandom_reseed+0x0/0xb4 returned 0 after 13 usecs
[    4.503613] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    4.503621] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 3 usecs
[    4.503625] calling  pci_sysfs_init+0x0/0x51 @ 1
[    4.503668] initcall pci_sysfs_init+0x0/0x51 returned 0 after 38 usecs
[    4.503673] calling  boot_wait_for_devices+0x0/0x30 @ 1
[    4.503679] initcall boot_wait_for_devices+0x0/0x30 returned 0 after 1 usecs
[    4.503684] calling  deferred_probe_initcall+0x0/0x70 @ 1
[    4.503787] initcall deferred_probe_initcall+0x0/0x70 returned 0 after 96 usecs
[    4.503794] calling  late_resume_init+0x0/0x1d0 @ 1
[    4.503797]   Magic number: 1:252:3141
[    4.503866] initcall late_resume_init+0x0/0x1d0 returned 0 after 66 usecs
[    4.503871] calling  firmware_memmap_init+0x0/0x38 @ 1
[    4.504225] initcall firmware_memmap_init+0x0/0x38 returned 0 after 341 usecs
[    4.504231] calling  pci_mmcfg_late_insert_resources+0x0/0x50 @ 1
[    4.504236] initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 usecs
[    4.504240] calling  tcp_congestion_default+0x0/0x12 @ 1
[    4.504244] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    4.504248] calling  tcp_fastopen_init+0x0/0x53 @ 1
[    4.504261] initcall tcp_fastopen_init+0x0/0x53 returned 0 after 9 usecs
[    4.504265] calling  ip_auto_config+0x0/0xf50 @ 1
[    4.504277] initcall ip_auto_config+0x0/0xf50 returned 0 after 8 usecs
[    4.504283] calling  software_resume+0x0/0x290 @ 1
[    4.504286] PM: Hibernation image not present or could not be loaded.
[    4.504290] initcall software_resume+0x0/0x290 returned -2 after 3 usecs
[    4.504294] calling  initialize_hashrnd+0x0/0x19 @ 1
[    4.504299] initcall initialize_hashrnd+0x0/0x19 returned 0 after 1 usecs
[    4.504478] async_waiting @ 1
[    4.504482] async_continuing @ 1 after 0 usec
[    4.505031] Freeing unused kernel memory: 1708K (ffffffff81cbe000 - ffffffff81e69000)
[    4.505036] Write protecting the kernel read-only data: 12288k
[    4.508265] Freeing unused kernel memory: 1268K (ffff8800016c3000 - ffff880001800000)
[    4.508936] Freeing unused kernel memory: 1940K (ffff880001a1b000 - ffff880001c00000)
init started: BusyBox v1.14.3 (2013-11-06 20:12:08 EST)
Mounting directories  [  OK  ]
mount: mount point /proc/bus/usb does not exist
[    4.669934] calling  privcmd_init+0x0/0x1000 [xen_privcmd] @ 1122
[    4.670155] initcall privcmd_init+0x0/0x1000 [xen_privcmd] returned 0 after 206 usecs
[    4.670631] calling  xenfs_init+0x0/0x1000 [xenfs] @ 1122
[    4.670638] initcall xenfs_init+0x0/0x1000 [xenfs] returned 0 after 1 usecs
mount: mount point /sys/kernel/config does not exist
[    4.681024] core_filesystem (1094) used greatest stack depth: 5176 bytes left
[    4.689668] calling  xenkbd_init+0x0/0x1000 [xen_kbdfront] @ 1133
[    4.689813] initcall xenkbd_init+0x0/0x1000 [xen_kbdfront] returned 0 after 134 usecs
[    4.693744] calling  xenfb_init+0x0/0x1000 [xen_fbfront] @ 1136
[    4.693884] initcall xenfb_init+0x0/0x1000 [xen_fbfront] returned 0 after 129 usecs
[    4.696586] calling  netif_init+0x0/0x1000 [xen_netfront] @ 1143
[    4.696591] xen_netfront: Initialising Xen virtual ethernet driver
[    4.696729] initcall netif_init+0x0/0x1000 [xen_netfront] returned 0 after 132 usecs
[    4.699476] calling  xlblk_init+0x0/0x1000 [xen_blkfront] @ 1146
[    4.699623] initcall xlblk_init+0x0/0x1000 [xen_blkfront] returned 0 after 136 usecs
[    4.710425] udevd (1152): /proc/1152/oom_adj is deprecated, please use /proc/1152/oom_score_adj instead.
[    4.751145] calling  igb_init_module+0x0/0x1000 [igb] @ 1164
[    4.751156] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    4.751159] igb: Copyright (c) 2007-2013 Intel Corporation.
[    4.751358] igb 0000:00:00.0: enabling device (0000 -> 0002)
[    4.830711] igb 0000:00:00.0: Xen PCI mapped GSI16 to IRQ39
udevd-work[1158]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory

[    4.832317] BUG: unable to handle kernel paging request at ffffc9000030600c
[    4.832325] IP: [<ffffffff8135f83d>] pci_enable_msix+0x35d/0x400
[    4.832333] PGD 11f287067 PUD 11f288067 PMD 11f38c067 PTE 80100000fbc44465
[    4.832341] Oops: 0003 [#1] SMP 

Entering kdb (current=0xffff88011c4b8ee0, pid 1164) on processor 0 Oops: (null)
due to oops @ 0xffffffff8135f83d
dCPU: 0 PID: 1164 Comm: modprobe Not tainted 3.12.0upstream #1
dtask: ffff88011c4b8ee0 ti: ffff88010a7e4000 task.ti: ffff88010a7e4000
dRIP: e030:[<ffffffff8135f83d>]  [<ffffffff8135f83d>] pci_enable_msix+0x35d/0x400
dRSP: e02b:ffff88010a7e5a58  EFLAGS: 00010286
dRAX: ffffc9000030600c RBX: ffff880006164d40 RCX: 0000000000000001
dRDX: 00000000000c000a RSI: ffff880006da0200 RDI: ffff880006da0200
dRBP: ffff88010a7e5ab8 R08: 000000009b808093 R09: 00000000527aee44
dR10: 00000000000dc034 R11: 00000000000dc026 R12: 0000000000000000
dR13: ffff880006c20600 R14: ffff88010a485000 R15: 0000000000000000
dFS:  00007fac5f69a700(0000) GS:ffff88011f600000(0000) knlGS:0000000000000000
dCS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
dCR2: ffff8000007de220 CR3: 0000000006e99000 CR4: 0000000000042660
dStack:
 ffff88010a7e5ab8 ffff88010a485798 ffff88010a485798 ffffc9000000000c
 00000010000080d0 c009ffff00000000 0000000000000000 ffff88011ccb8740
 0000000000000007 ffff88010a485000 ffff88011ccb8000 0000000000000000
dCall Trace:
d [<ffffffffa005435e>] igb_init_interrupt_scheme+0xde/0x450 [igb]
d [<ffffffff816a8571>] ? kmemleak_alloc+0x21/0x50
d [<ffffffff81344925>] ? pci_bus_read_config_word+0x75/0x90
more> [    4.855454] input_id (1259) used greatest stack depth: 4952 bytes left
[    4.908919] ip (1311) used greatest stack depth: 3064 bytes left
Parsing config from vm-pv.cfg

The BARs are:
-bash-4.1# lspci -s 01:00.0 -v | grep Memo
        Memory at fbc20000 (32-bit, non-prefetchable) [size=128K]
        Memory at fb800000 (32-bit, non-prefetchable) [size=4M]
        Memory at fbc44000 (32-bit, non-prefetchable) [size=16K]

And the fbc44 is where the MSI-X values are set.

And the guest config:

[konrad@build-external ~]$ more /mnt/lab/latest/vm-pv.cfg
extra="console=hvc0 debug  kgdboc=hvc0 nokgdbroundup  initcall_debug debug "
kernel="/mnt/lab/latest/vmlinuz"
ramdisk="/mnt/lab/latest/initramfs.cpio.gz"
memory=1024
maxmem=2048
vcpus=3
maxvcpus=8
name="latest"
on_crash="preserve"
vnc=1
vnclisten="0.0.0.0"
pci=["01:00.0"]
e820_host=1

Thank you!
