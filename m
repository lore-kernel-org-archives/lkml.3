Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985Ab3BHCFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:05:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:19966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab3BHCFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:05:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,626,1355126400"; 
   d="log'?scan'208";a="284283204"
Date: Fri, 8 Feb 2013 10:05:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: cpufreq.c:1779 suspicious rcu_dereference_check() usage!
Message-ID: <20130208020522.GD5224@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below oops and the first bad commit is

commit 9d55504e3e713c03c5260302497a72cc10f87149
Author: Nathan Zimmer <nzimmer@sgi.com>
Date:   Tue Feb 5 20:04:50 2013 -0600

    cpufreq: Convert the cpufreq_driver_lock to use the rcu
    
    In general rwlocks are discourged so we are moving it to use the rcu instead.
    
    Cc: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>

[    1.572224] 
[    1.572419] ===============================
[    1.572933] [ INFO: suspicious RCU usage. ]
[    1.573464] 3.8.0-rc6-00407-gfe1080a #40 Not tainted
[    1.574059] -------------------------------
[    1.574559] /c/kernel-tests/src/stable/drivers/cpufreq/cpufreq.c:1779 suspicious rcu_dereference_check() usage!
[    1.575759] 
[    1.575759] other info that might help us debug this:
[    1.575759] 
[    1.576720] 
[    1.576720] rcu_scheduler_active = 1, debug_locks = 0
[    1.577498] no locks held by swapper/0/1.
[    1.577982] 
[    1.577982] stack backtrace:
[    1.578533] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc6-00407-gfe1080a #40
[    1.579373] Call Trace:
[    1.579712]  [<ffffffff8109d4ed>] lockdep_rcu_suspicious+0xfd/0x130
[    1.580472]  [<ffffffff81339528>] cpufreq_update_policy+0x168/0x1b0
[    1.581233]  [<ffffffff81027bb8>] ? kvm_clock_read+0x38/0x50
[    1.581934]  [<ffffffff8100aae9>] ? sched_clock+0x9/0x10
[    1.582584]  [<ffffffff81080925>] ? sched_clock_local+0x25/0xa0
[    1.583297]  [<ffffffff81080ad8>] ? sched_clock_cpu+0xa8/0x120
[    1.584004]  [<ffffffff813beec3>] ? mutex_lock_nested+0x2a3/0x380
[    1.584739]  [<ffffffff8109ae3d>] ? trace_hardirqs_off+0xd/0x10
[    1.585444]  [<ffffffff81080d0f>] ? local_clock+0x6f/0x80
[    1.586104]  [<ffffffff813bfc03>] ? __mutex_unlock_slowpath+0xd3/0x170
[    1.586893]  [<ffffffff8183da07>] ? cpufreq_core_init+0xc1/0xc1
[    1.587603]  [<ffffffff8109acdd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[    1.588421]  [<ffffffff8109ad7d>] ? trace_hardirqs_on+0xd/0x10
[    1.589132]  [<ffffffff813bfca9>] ? mutex_unlock+0x9/0x10
[    1.589792]  [<ffffffff81051b20>] ? cpu_maps_update_done+0x10/0x20
[    1.590534]  [<ffffffff8183da07>] ? cpufreq_core_init+0xc1/0xc1
[    1.591252]  [<ffffffff8183da66>] cpufreq_stats_init+0x5f/0xe5
[    1.591970]  [<ffffffff81812c91>] do_one_initcall+0x7a/0x139
[    1.592660]  [<ffffffff81812e53>] kernel_init_freeable+0x103/0x18d
[    1.593393]  [<ffffffff81812566>] ? do_early_param+0x8c/0x8c
[    1.594086]  [<ffffffff813a8a00>] ? rest_init+0x150/0x150
[    1.594736]  [<ffffffff813a8a09>] kernel_init+0x9/0xe0
[    1.595389]  [<ffffffff813c353c>] ret_from_fork+0x7c/0xb0
[    1.596056]  [<ffffffff813a8a00>] ? rest_init+0x150/0x150
[    1.596707] cpuidle: using governor ladder
[    1.597202] cpuidle: using governor menu

git bisect start fe1080a91b378aa68f16b377e048e9ae7bf9aa2d 1589a3e7777631ff56dd58cd7dcdf275185e62b5 --
git bisect good 4b794a03dc679a3ae545f683e47a6ef5e5e21d33  #    10  2013-02-06 20:22:16  Merge branch 'acpi-assorted' into linux-next
git bisect  bad 39391e788192294c9fe58cd47ec7eb8ef5091b79  #     0  2013-02-06 20:37:42  Merge remote-tracking branch 'vireshk/cpufreq-updates' into devel-hive-x86_64-2013-02-06-17-16
git bisect good 16a44f82674ddd8d5b5b2527979ac22a25c55c50  #    10  2013-02-06 20:54:28  cpufreq: TEGRA: Set policy->cpus from driver->init()
git bisect good 6d50036dbaae080a1fb9376d4c4600b53b058d21  #    10  2013-02-06 21:24:44  Merge branch 'acpi-cleanup-next' into linux-next
git bisect good 85ada2c52ecce7963c0858eedead2063b9f18e75  #    10  2013-02-06 21:55:07  Merge branch 'pm-tools-next' into bleeding-edge
git bisect  bad e62536d7877396c59e9eb5c52b470db6dbaf8ea1  #     0  2013-02-06 22:10:06  cpufreq: Add per policy governor-init/exit infrastructure
git bisect  bad 9d55504e3e713c03c5260302497a72cc10f87149  #     0  2013-02-06 22:11:52  cpufreq: Convert the cpufreq_driver_lock to use the rcu
git bisect good 1184c024165b1e8de45f6fc9eb0cde336c2fa1f5  #    10  2013-02-06 22:29:14  cpufreq: Convert the cpufreq_driver_lock to a rwlock
git bisect good 1184c024165b1e8de45f6fc9eb0cde336c2fa1f5  #    30  2013-02-06 23:14:39  cpufreq: Convert the cpufreq_driver_lock to a rwlock
git bisect good 164708bec016c6ceb76a2bb2e29b086bf0ad4e37  #    30  2013-02-06 23:59:52  Add linux-next specific files for 20130204

Thanks,
Fengguang

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-61167-2013-02-06-17-26-08-3.8.0-rc6-00407-gfe1080a-40"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc6-00407-gfe1080a (kbuild@hive) (gcc version 4.7.1 (GCC) ) #40 SMP Wed Feb 6 17:24:36 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=devel-hive-x86_64-2013-02-06-17-16 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-02-06-17-25-46-devel-hive-x86_64-2013-02-06-17-16:fe1080a-fe1080a-x86_64-randconfig-h123-4-inn BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-h123/fe1080a/vmlinuz-3.8.0-rc6-00407-gfe1080a
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128968(98%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e014001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60478 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 472 pages/cpu @ffff88000da00000 s1909696 r0 d23616 u2097152
[    0.000000] pcpu-alloc: s1909696 r0 d23616 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:e014001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da0cec0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=devel-hive-x86_64-2013-02-06-17-16 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-02-06-17-25-46-devel-hive-x86_64-2013-02-06-17-16:fe1080a-fe1080a-x86_64-randconfig-h123-4-inn BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-h123/fe1080a/vmlinuz-3.8.0-rc6-00407-gfe1080a
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 200692k/262136k available (3866k kernel code, 500k absent, 60944k reserved, 2524k data, 2260k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 11 of 11 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.560 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.12 BogoMIPS (lpj=2693560)
[    0.003006] pid_max: default: 4096 minimum: 301
[    0.003646] Security Framework initialized
[    0.004031] Mount-cache hash table entries: 256
[    0.005410] mce: CPU supports 10 MCE banks
[    0.006063] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006063] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006063] tlb_flushall_shift: 6
[    0.007025] debug: unmapping init [mem 0xffffffff81874000-0xffffffff81876fff]
[    0.010781] ACPI: Core revision 20130117
[    0.012695] ACPI: All ACPI Tables successfully acquired
[    0.013238] Getting VERSION: 50014
[    0.014010] Getting VERSION: 50014
[    0.014424] Getting ID: 0
[    0.014750] Getting ID: ff000000
[    0.015023] Getting LVT0: 8700
[    0.015403] Getting LVT1: 8400
[    0.016047] enabled ExtINT on CPU#0
[    0.017248] ENABLING IO-APIC IRQs
[    0.017648] init IO_APIC IRQs
[    0.018006]  apic 2 pin 0 not connected
[    0.018475] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.019021] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.020020] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.021019] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.022019] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.023019] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.024018] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.025019] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.026019] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.027019] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.028019] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.029019] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.030019] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.031020] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.032019] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.033016]  apic 2 pin 16 not connected
[    0.033497]  apic 2 pin 17 not connected
[    0.034004]  apic 2 pin 18 not connected
[    0.034484]  apic 2 pin 19 not connected
[    0.035004]  apic 2 pin 20 not connected
[    0.035494]  apic 2 pin 21 not connected
[    0.036004]  apic 2 pin 22 not connected
[    0.036484]  apic 2 pin 23 not connected
[    0.037149] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.038004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.039516] Using local APIC timer interrupts.
[    0.039516] calibrating APIC timer ...
[    0.041000] ... lapic delta = 6249957
[    0.041000] ... PM-Timer delta = 357952
[    0.041000] ... PM-Timer result ok
[    0.041000] ..... delta 6249957
[    0.041000] ..... mult: 268433609
[    0.041000] ..... calibration result: 999993
[    0.041000] ..... CPU clock speed is 2693.0487 MHz.
[    0.041000] ..... host bus clock speed is 999.0993 MHz.
[    0.041055] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.043098] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.044311] SMP alternatives: lockdep: fixing up alternatives
[    0.045014] smpboot: Booting Node   0, Processors  #1 OK
[    0.003000] kvm-clock: cpu 1, msr 0:e014041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.059062] Brought up 2 CPUs
[    0.059012] KVM setup async PF for cpu 1
[    0.059012] kvm-stealtime: cpu 1, msr dc0cec0
[    0.060007] ----------------
[    0.060347] | NMI testsuite:
[    0.060724] --------------------
[    0.061003]   remote IPI:  ok  |
[    0.062003]    local IPI:  ok  |
[    0.063027] --------------------
[    0.063416] Good, all   2 testcases passed! |
[    0.063952] ---------------------------------
[    0.064004] smpboot: Total of 2 processors activated (10774.24 BogoMIPS)
[    0.066274] devtmpfs: initialized
[    0.066451] device: 'platform': device_add
[    0.067038] bus: 'platform': registered
[    0.067514] bus: 'cpu': registered
[    0.068004] device: 'cpu': device_add
[    0.068480] bus: 'memory': registered
[    0.069004] device: 'memory': device_add
[    0.069487] device: 'memory0': device_add
[    0.070014] bus: 'memory': add device memory0
[    0.070585] device: 'memory1': device_add
[    0.071007] bus: 'memory': add device memory1
[    0.072295] bus: 'virtio': registered
[    0.072611] device class 'regulator': registering
[    0.073092] Registering platform device 'reg-dummy'. Parent at platform
[    0.074004] device: 'reg-dummy': device_add
[    0.074522] bus: 'platform': add device reg-dummy
[    0.075021] bus: 'platform': add driver reg-dummy
[    0.076011] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.077003] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.078041] device: 'regulator.0': device_add
[    0.078650] regulator-dummy: no parameters
[    0.079043] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.080013] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.081132] NET: Registered protocol family 16
[    0.081748] device class 'bdi': registering
[    0.082056] device class 'pci_bus': registering
[    0.083022] bus: 'pci': registered
[    0.083455] device class 'lcd': registering
[    0.083977] device class 'backlight': registering
[    0.084009] device class 'tty': registering
[    0.085036] bus: 'spi': registered
[    0.085451] device class 'spi_master': registering
[    0.086020] bus: 'hsi': registered
[    0.086443] bus: 'i2c': registered
[    0.087004] bus: 'i2c': add driver dummy
[    0.087693] ACPI: bus type pci registered
[    0.088041] PCI: Using configuration type 1 for base access
[    0.088756] device: 'cpu0': device_add
[    0.089007] bus: 'cpu': add device cpu0
[    0.089520] device: 'cpu1': device_add
[    0.090007] bus: 'cpu': add device cpu1
[    0.092939] device: 'default': device_add
[    0.093109] ACPI: Added _OSI(Module Device)
[    0.094005] ACPI: Added _OSI(Processor Device)
[    0.094543] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.095004] ACPI: Added _OSI(Processor Aggregator Device)
[    0.097922] ACPI: EC: Look up EC in DSDT
[    0.101748] ACPI: Interpreter enabled
[    0.102003] ACPI: (supports S0 S5)
[    0.102452] ACPI: Using IOAPIC for interrupt routing
[    0.103020] bus: 'acpi': registered
[    0.103439] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.104037] device: 'LNXSYSTM:00': device_add
[    0.105021] bus: 'acpi': add device LNXSYSTM:00
[    0.106086] device: 'LNXSYBUS:00': device_add
[    0.106645] bus: 'acpi': add device LNXSYBUS:00
[    0.107061] device: 'PNP0A03:00': device_add
[    0.107585] bus: 'acpi': add device PNP0A03:00
[    0.109034] device: 'device:00': device_add
[    0.109539] bus: 'acpi': add device device:00
[    0.110072] device: 'device:01': device_add
[    0.110577] bus: 'acpi': add device device:01
[    0.111064] device: 'PNP0B00:00': device_add
[    0.111582] bus: 'acpi': add device PNP0B00:00
[    0.112113] device: 'PNP0303:00': device_add
[    0.112641] bus: 'acpi': add device PNP0303:00
[    0.113080] device: 'PNP0F13:00': device_add
[    0.114008] bus: 'acpi': add device PNP0F13:00
[    0.114608] device: 'PNP0700:00': device_add
[    0.115011] bus: 'acpi': add device PNP0700:00
[    0.115679] device: 'PNP0400:00': device_add
[    0.116009] bus: 'acpi': add device PNP0400:00
[    0.117119] device: 'PNP0501:00': device_add
[    0.117635] bus: 'acpi': add device PNP0501:00
[    0.118107] device: 'device:02': device_add
[    0.118620] bus: 'acpi': add device device:02
[    0.119097] device: 'device:03': device_add
[    0.119607] bus: 'acpi': add device device:03
[    0.120066] device: 'device:04': device_add
[    0.121008] bus: 'acpi': add device device:04
[    0.121603] device: 'device:05': device_add
[    0.122008] bus: 'acpi': add device device:05
[    0.122601] device: 'device:06': device_add
[    0.123012] bus: 'acpi': add device device:06
[    0.123612] device: 'device:07': device_add
[    0.124008] bus: 'acpi': add device device:07
[    0.125039] device: 'device:08': device_add
[    0.125545] bus: 'acpi': add device device:08
[    0.126083] device: 'device:09': device_add
[    0.126602] bus: 'acpi': add device device:09
[    0.127079] device: 'device:0a': device_add
[    0.127602] bus: 'acpi': add device device:0a
[    0.128074] device: 'device:0b': device_add
[    0.128588] bus: 'acpi': add device device:0b
[    0.129074] device: 'device:0c': device_add
[    0.130008] bus: 'acpi': add device device:0c
[    0.130633] device: 'device:0d': device_add
[    0.131008] bus: 'acpi': add device device:0d
[    0.131607] device: 'device:0e': device_add
[    0.132008] bus: 'acpi': add device device:0e
[    0.132614] device: 'device:0f': device_add
[    0.133007] bus: 'acpi': add device device:0f
[    0.134069] device: 'device:10': device_add
[    0.134578] bus: 'acpi': add device device:10
[    0.135074] device: 'device:11': device_add
[    0.135581] bus: 'acpi': add device device:11
[    0.136076] device: 'device:12': device_add
[    0.136599] bus: 'acpi': add device device:12
[    0.137093] device: 'device:13': device_add
[    0.137608] bus: 'acpi': add device device:13
[    0.138075] device: 'device:14': device_add
[    0.139008] bus: 'acpi': add device device:14
[    0.139597] device: 'device:15': device_add
[    0.140008] bus: 'acpi': add device device:15
[    0.140629] device: 'device:16': device_add
[    0.141008] bus: 'acpi': add device device:16
[    0.141611] device: 'device:17': device_add
[    0.142008] bus: 'acpi': add device device:17
[    0.143074] device: 'device:18': device_add
[    0.143581] bus: 'acpi': add device device:18
[    0.144084] device: 'device:19': device_add
[    0.144590] bus: 'acpi': add device device:19
[    0.145074] device: 'device:1a': device_add
[    0.145596] bus: 'acpi': add device device:1a
[    0.146076] device: 'device:1b': device_add
[    0.146583] bus: 'acpi': add device device:1b
[    0.147074] device: 'device:1c': device_add
[    0.148017] bus: 'acpi': add device device:1c
[    0.148636] device: 'device:1d': device_add
[    0.149008] bus: 'acpi': add device device:1d
[    0.149606] device: 'device:1e': device_add
[    0.150008] bus: 'acpi': add device device:1e
[    0.150629] device: 'device:1f': device_add
[    0.151018] bus: 'acpi': add device device:1f
[    0.152076] device: 'device:20': device_add
[    0.152583] bus: 'acpi': add device device:20
[    0.153086] device: 'device:21': device_add
[    0.153597] bus: 'acpi': add device device:21
[    0.154183] device: 'PNP0103:00': device_add
[    0.154708] bus: 'acpi': add device PNP0103:00
[    0.155188] device: 'PNP0C0F:00': device_add
[    0.156009] bus: 'acpi': add device PNP0C0F:00
[    0.156681] device: 'PNP0C0F:01': device_add
[    0.157008] bus: 'acpi': add device PNP0C0F:01
[    0.158131] device: 'PNP0C0F:02': device_add
[    0.158673] bus: 'acpi': add device PNP0C0F:02
[    0.159143] device: 'PNP0C0F:03': device_add
[    0.159671] bus: 'acpi': add device PNP0C0F:03
[    0.160131] device: 'PNP0C0F:04': device_add
[    0.161008] bus: 'acpi': add device PNP0C0F:04
[    0.161632] device: 'LNXCPU:00': device_add
[    0.162008] bus: 'acpi': add device LNXCPU:00
[    0.162626] device: 'LNXCPU:01': device_add
[    0.163008] bus: 'acpi': add device LNXCPU:01
[    0.164048] device: 'LNXSYBUS:01': device_add
[    0.164570] bus: 'acpi': add device LNXSYBUS:01
[    0.165112] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.166008] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.167144] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.168040] device: 'pci0000:00': device_add
[    0.168595] device: '0000:00': device_add
[    0.169061] PCI host bridge to bus 0000:00
[    0.169604] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.170004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.171006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.172004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.172822] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.173061] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.174321] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.176032] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.178505] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.180022] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.181179] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.182015] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.183046] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.184414] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.186039] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.191041] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.192137] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.193620] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.194602] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.198592] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.199116] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.200668] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.202007] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.206207] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.207619] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.208626] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.212829] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.214321] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.215627] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.219520] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.221004] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.222320] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.226515] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.227669] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.229004] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.233205] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.234657] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.236004] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.240060] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.241004] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.244094] pci_bus 0000:00: on NUMA node 0
[    0.244607] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.245020] device: '0000:00:00.0': device_add
[    0.246228] bus: 'pci': add device 0000:00:00.0
[    0.246961] device: '0000:00:01.0': device_add
[    0.247041] bus: 'pci': add device 0000:00:01.0
[    0.248045] device: '0000:00:01.1': device_add
[    0.248738] bus: 'pci': add device 0000:00:01.1
[    0.249033] device: '0000:00:01.3': device_add
[    0.250047] bus: 'pci': add device 0000:00:01.3
[    0.250620] device: '0000:00:02.0': device_add
[    0.251029] bus: 'pci': add device 0000:00:02.0
[    0.251676] device: '0000:00:03.0': device_add
[    0.252051] bus: 'pci': add device 0000:00:03.0
[    0.253051] device: '0000:00:04.0': device_add
[    0.253635] bus: 'pci': add device 0000:00:04.0
[    0.254043] device: '0000:00:05.0': device_add
[    0.254648] bus: 'pci': add device 0000:00:05.0
[    0.255043] device: '0000:00:06.0': device_add
[    0.256058] bus: 'pci': add device 0000:00:06.0
[    0.256634] device: '0000:00:07.0': device_add
[    0.257066] bus: 'pci': add device 0000:00:07.0
[    0.257655] device: '0000:00:08.0': device_add
[    0.258066] bus: 'pci': add device 0000:00:08.0
[    0.259042] device: '0000:00:09.0': device_add
[    0.259641] bus: 'pci': add device 0000:00:09.0
[    0.260043] device: '0000:00:0a.0': device_add
[    0.260653] bus: 'pci': add device 0000:00:0a.0
[    0.262436] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.263327] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.264188] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.265109] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.265982] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.266341] device: 'LNXPWRBN:00': device_add
[    0.267012] bus: 'acpi': add device LNXPWRBN:00
[    0.268199] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.268828] bus: 'acpi': add driver ec
[    0.269126] bus: 'pnp': registered
[    0.269562] bus: 'platform': add driver 88pm860x-regulator
[    0.270020] bus: 'platform': add driver da9052-regulator
[    0.271028] bus: 'platform': add driver da9055-regulator
[    0.271688] bus: 'i2c': add driver isl6271a
[    0.272021] bus: 'i2c': add driver lp3972
[    0.272535] bus: 'platform': add driver lp8788-buck
[    0.273014] bus: 'platform': add driver lp8788-dldo
[    0.274023] bus: 'platform': add driver lp8788-aldo
[    0.274627] bus: 'i2c': add driver max8649
[    0.275016] bus: 'platform': add driver max8907-regulator
[    0.275683] bus: 'i2c': add driver max8952
[    0.276017] bus: 'platform': add driver max8998-pmic
[    0.277017] bus: 'platform': add driver s2mps11-pmic
[    0.277627] bus: 'i2c': add driver tps62360
[    0.278014] bus: 'i2c': add driver tps65023
[    0.278537] bus: 'platform': add driver tps65090-pmic
[    0.279017] bus: 'platform': add driver tps80031-pmic
[    0.280017] bus: 'platform': add driver wm8350-regulator
[    0.280662] bus: 'platform': add driver wm8400-regulator
[    0.281014] bus: 'platform': add driver wm8994-ldo
[    0.281605] device class 'misc': registering
[    0.282051] device: 'vga_arbiter': device_add
[    0.283261] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.284014] vgaarb: loaded
[    0.284346] vgaarb: bridge control possible 0000:00:02.0
[    0.285011] bus: 'i2c': add driver 88PM860x
[    0.285536] bus: 'i2c': add driver 88PM80X
[    0.286025] Error: Driver '88PM80X' is already registered, aborting...
[    0.287010] bus: 'spi': add driver stmpe-spi
[    0.287535] bus: 'i2c': add driver WM8400
[    0.288018] bus: 'i2c': add driver wm831x
[    0.288544] bus: 'spi': add driver wm831x
[    0.289013] bus: 'i2c': add driver wm8350
[    0.289529] bus: 'i2c': add driver tps65217
[    0.290015] bus: 'i2c': add driver tps80031
[    0.290556] bus: 'i2c': add driver twl
[    0.291014] bus: 'i2c': add driver da903x
[    0.291531] bus: 'spi': add driver da9052
[    0.292013] bus: 'i2c': add driver da9052
[    0.292538] bus: 'i2c': add driver lp8788
[    0.293017] bus: 'i2c': add driver da9055
[    0.293516] bus: 'i2c': add driver max77693
[    0.294014] bus: 'i2c': add driver max8907
[    0.294524] bus: 'i2c': add driver max8998
[    0.295032] bus: 'i2c': add driver tps6586x
[    0.296011] bus: 'i2c': add driver tps65090
[    0.296524] bus: 'i2c': add driver palmas
[    0.297014] bus: 'i2c': add driver sec_pmic
[    0.297534] device class 'pcmcia_socket': registering
[    0.298036] bus: 'serio': registered
[    0.298480] bus: 'gameport': registered
[    0.299006] device class 'input': registering
[    0.299541] bus: 'i2c': add driver tca8418_keypad
[    0.300015] device class 'rtc': registering
[    0.300527] Linux video capture interface: v2.00
[    0.301007] device class 'video4linux': registering
[    0.301608] device class 'dvb': registering
[    0.302009] device class 'pps': registering
[    0.302544] pps_core: LinuxPPS API ver. 1 registered
[    0.303003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.304003] device class 'ptp': registering
[    0.305011] PTP clock support registered
[    0.305496] device class 'power_supply': registering
[    0.306038] bus: 'mmc': registered
[    0.306458] device class 'mmc_host': registering
[    0.307032] bus: 'sdio': registered
[    0.307467] device class 'leds': registering
[    0.308013] PCI: Using ACPI for IRQ routing
[    0.308529] PCI: pci_cache_line_size set to 64 bytes
[    0.309268] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.310007] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.311015] device class 'net': registering
[    0.311584] device: 'lo': device_add
[    0.312440] Switching to clocksource kvm-clock
[    0.313231] bus: 'pnp': add driver system
[    0.313764] pnp: PnP ACPI init
[    0.314134] device: 'pnp0': device_add
[    0.314623] ACPI: bus type pnp registered
[    0.315207] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.316193] device: '00:00': device_add
[    0.316688] bus: 'pnp': add device 00:00
[    0.317206] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.318064] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.319038] device: '00:01': device_add
[    0.319537] bus: 'pnp': add device 00:01
[    0.320040] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.320867] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.321877] device: '00:02': device_add
[    0.322365] bus: 'pnp': add device 00:02
[    0.322867] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.323694] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.324658] pnp 00:03: [dma 2]
[    0.325067] device: '00:03': device_add
[    0.325555] bus: 'pnp': add device 00:03
[    0.326055] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.326895] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.327880] device: '00:04': device_add
[    0.328373] bus: 'pnp': add device 00:04
[    0.328873] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.329749] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.330737] device: '00:05': device_add
[    0.331231] bus: 'pnp': add device 00:05
[    0.331739] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.332770] device: '00:06': device_add
[    0.333282] bus: 'pnp': add device 00:06
[    0.333772] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.334732] pnp: PnP ACPI: found 7 devices
[    0.335264] ACPI: ACPI bus type pnp unregistered
[    0.335839] device class 'mem': registering
[    0.336359] device: 'mem': device_add
[    0.336940] device: 'kmem': device_add
[    0.337581] device: 'null': device_add
[    0.338208] device: 'port': device_add
[    0.338807] device: 'zero': device_add
[    0.339368] device: 'full': device_add
[    0.339933] device: 'random': device_add
[    0.340524] device: 'urandom': device_add
[    0.341107] device: 'kmsg': device_add
[    0.341677] device: 'tty': device_add
[    0.342279] device: 'console': device_add
[    0.342892] device class 'firmware': registering
[    0.343454] device class 'thermal': registering
[    0.348683] bus: 'ssb': registered
[    0.349149] bus: 'bcma': registered
[    0.349622] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.350278] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.350951] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.351720] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.352487] NET: Registered protocol family 1
[    0.353030] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.353767] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.354483] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.355269] pci 0000:00:02.0: Boot video device
[    0.355904] PCI: CLS 0 bytes, default 64
[    0.356539] Unpacking initramfs...
[    1.095870] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.097382] Registering platform device 'pcspkr'. Parent at platform
[    1.098202] device: 'pcspkr': device_add
[    1.098728] bus: 'platform': add device pcspkr
[    1.099343] Registering platform device 'microcode'. Parent at platform
[    1.100178] device: 'microcode': device_add
[    1.100707] bus: 'platform': add device microcode
[    1.101397] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    1.102125] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    1.102835] device: 'microcode': device_add
[    1.103450] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.104563] AVX instructions are not detected.
[    1.105409] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    1.106643] AVX instructions are not detected.
[    1.107213] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.108069] bus: 'clocksource': registered
[    1.108592] device: 'clocksource': device_add
[    1.109149] device: 'clocksource0': device_add
[    1.109721] bus: 'clocksource': add device clocksource0
[    1.110415] bus: 'platform': add driver alarmtimer
[    1.111068] Registering platform device 'alarmtimer'. Parent at platform
[    1.111898] device: 'alarmtimer': device_add
[    1.112448] bus: 'platform': add device alarmtimer
[    1.113080] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.114186] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.115213] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.116067] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.117086] bus: 'rttest': registered
[    1.117535] device: 'rttest': device_add
[    1.118234] device: 'rttest0': device_add
[    1.118762] bus: 'rttest': add device rttest0
[    1.119551] device: 'rttest1': device_add
[    1.120085] bus: 'rttest': add device rttest1
[    1.120841] device: 'rttest2': device_add
[    1.121371] bus: 'rttest': add device rttest2
[    1.122135] device: 'rttest3': device_add
[    1.122657] bus: 'rttest': add device rttest3
[    1.123484] device: 'rttest4': device_add
[    1.123986] bus: 'rttest': add device rttest4
[    1.124813] device: 'rttest5': device_add
[    1.125337] bus: 'rttest': add device rttest5
[    1.126106] device: 'rttest6': device_add
[    1.126627] bus: 'rttest': add device rttest6
[    1.127369] device: 'rttest7': device_add
[    1.127890] bus: 'rttest': add device rttest7
[    1.128473] Initializing RT-Tester: OK
[    1.129193] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    1.135927] bus: 'event_source': registered
[    1.136509] device: 'breakpoint': device_add
[    1.137047] bus: 'event_source': add device breakpoint
[    1.137708] device: 'software': device_add
[    1.138222] bus: 'event_source': add device software
[    1.139277] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.143074] jffs2: version 2.2. 
[    1.143978] device: 'autofs': device_add
[    1.149216] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    1.149840] crc32: self tests passed, processed 225944 bytes in 246427 nsec
[    1.150914] crc32c: CRC_LE_BITS = 32
[    1.151350] crc32c: self tests passed, processed 225944 bytes in 122187 nsec
[    1.152576] xz_dec_test: module loaded
[    1.153051] xz_dec_test: Create a device node with 'mknod xz_dec_test c 252 0' and write .xz files to it.
[    1.154182] bus: 'spi': add driver ltv350qv
[    1.154708] bus: 'platform': add driver platform-lcd
[    1.155340] bus: 'spi': add driver VGG2432A4
[    1.155844] bus: 'spi': add driver tdo24m
[    1.156332] bus: 'spi': add driver s6e63m0
[    1.156847] bus: 'platform': add driver generic-bl
[    1.157421] bus: 'i2c': add driver lm3630_bl
[    1.157928] bus: 'i2c': add driver lm3639_bl
[    1.158511] bus: 'i2c': add driver lp855x
[    1.159043] bus: 'platform': add driver da903x-backlight
[    1.159687] bus: 'platform': add driver wm831x-backlight
[    1.160317] bus: 'i2c': add driver adp8860_bl
[    1.160863] bus: 'platform': add driver 88pm860x-backlight
[    1.161534] bus: 'platform': add driver ipmi
[    1.162086] ipmi message handler version 39.2
[    1.162621] ipmi device interface
[    1.163032] device class 'ipmi': registering
[    1.163548] bus: 'acpi': add driver ac
[    1.164041] bus: 'acpi': add driver button
[    1.164570] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    1.165563] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    1.166481] device: 'input0': device_add
[    1.167037] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.167900] ACPI: Power Button [PWRF]
[    1.168416] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    1.169261] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    1.170137] bus: 'acpi': add driver fan
[    1.170616] bus: 'acpi': add driver processor
[    1.171156] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    1.172143] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    1.173281] device: 'cooling_device0': device_add
[    1.173868] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    1.174673] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    1.175563] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    1.176527] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    1.177520] device: 'cooling_device1': device_add
[    1.178100] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    1.178905] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    1.181512] bus: 'acpi': add driver container
[    1.183205] bus: 'acpi': add driver thermal
[    1.183763] bus: 'platform': add driver virtio-mmio
[    1.183921] bus: 'acpi': add driver battery
[    1.184841] bus: 'virtio': add driver virtio_balloon
[    1.185435] bus: 'platform': add driver reg-virt-consumer
[    1.186082] bus: 'platform': add driver reg-userspace-consumer
[    1.186764] bus: 'i2c': add driver fan53555-regulator
[    1.187364] bus: 'i2c': add driver LP3971
[    1.187851] bus: 'i2c': add driver lp872x
[    1.188396] bus: 'spi': add driver tps6524x
[    1.188916] device: 'ptmx': device_add
[    1.189453] HDLC line discipline maxframe=4096
[    1.189983] N_HDLC line discipline registered.
[    1.190531] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.191304] bus: 'pnp': add driver serial
[    1.191817] bus: 'pnp': driver_probe_device: matched device 00:05 with driver serial
[    1.192763] bus: 'pnp': really_probe: probing driver serial with device 00:05
[    1.215267] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.215968] device: 'ttyS0': device_add
[    1.216577] driver: '00:05': driver_bound: bound to device 'serial'
[    1.217321] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[    1.218155] Registering platform device 'serial8250'. Parent at platform
[    1.218939] device: 'serial8250': device_add
[    1.219443] bus: 'platform': add device serial8250
[    1.220098] device: 'ttyS1': device_add
[    1.220642] device: 'ttyS2': device_add
[    1.221223] device: 'ttyS3': device_add
[    1.221742] bus: 'platform': add driver serial8250
[    1.222323] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    1.223349] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    1.224308] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    1.225123] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    1.226055] bus: 'pci': add driver serial
[    1.226573] bus: 'spi': add driver max3100
[    1.227123] bus: 'platform': add driver uart-sccnxp
[    1.227696] bus: 'platform': add driver altera_uart
[    1.228310] bus: 'platform': add driver altera_jtaguart
[    1.228965] device: 'ttyprintk': device_add
[    1.229527] device class 'virtio-ports': registering
[    1.230145] bus: 'virtio': add driver virtio_console
[    1.230712] bus: 'virtio': add driver virtio_rproc_serial
[    1.231364] device class 'printer': registering
[    1.231929] lp: driver loaded but no devices found
[    1.232504] device: 'nvram': device_add
[    1.232986] Non-volatile memory driver v1.3
[    1.233647] bus: 'virtio': add driver virtio_rng
[    1.234211] device class 'ppdev': registering
[    1.234723] ppdev: user-space parallel port driver
[    1.235292] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    1.235901] smapi::smapi_init, ERROR invalid usSmapiID
[    1.236504] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    1.237574] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    1.238423] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.239184] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.240210] Hangcheck: Using getrawmonotonic().
[    1.240743] bus: 'i2c': add driver tpm_i2c_infineon
[    1.241327] bus: 'platform': add driver tpm_atmel
[    1.241952] bus: 'platform': remove driver tpm_atmel
[    1.242547] driver: 'tpm_atmel': driver_release
[    1.243091] device class 'drm': registering
[    1.243589] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    1.244287] device class 'drm': unregistering
[    1.244799] class 'drm': release.
[    1.245194] class_create_release called for drm
[    1.245719] bus: 'platform': add driver parport_pc
[    1.246301] bus: 'pnp': add driver parport_pc
[    1.246809] bus: 'pnp': driver_probe_device: matched device 00:04 with driver parport_pc
[    1.247733] bus: 'pnp': really_probe: probing driver parport_pc with device 00:04
[    1.248631] parport_pc 00:04: reported by Plug and Play ACPI
[    1.249348] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    1.250177] device: 'parport0': device_add
[    1.250773] device: 'lp0': device_add
[    1.251271] lp0: using parport0 (interrupt-driven).
[    1.251867] driver: '00:04': driver_bound: bound to device 'parport_pc'
[    1.252635] bus: 'pnp': really_probe: bound device 00:04 to driver parport_pc
[    1.253470] Registering platform device 'parport_pc.956'. Parent at platform
[    1.254291] device: 'parport_pc.956': device_add
[    1.254832] bus: 'platform': add device parport_pc.956
[    1.255471] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[    1.256543] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[    1.257543] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[    1.258421] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[    1.259458] bus: 'platform': remove device parport_pc.956
[    1.260129] Registering platform device 'parport_pc.888'. Parent at platform
[    1.260931] device: 'parport_pc.888': device_add
[    1.261476] bus: 'platform': add device parport_pc.888
[    1.262120] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[    1.263181] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[    1.264180] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[    1.265030] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[    1.265984] bus: 'platform': remove device parport_pc.888
[    1.266628] Registering platform device 'parport_pc.632'. Parent at platform
[    1.267434] device: 'parport_pc.632': device_add
[    1.267969] bus: 'platform': add device parport_pc.632
[    1.268614] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[    1.269715] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[    1.270720] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[    1.271587] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[    1.272629] bus: 'platform': remove device parport_pc.632
[    1.273271] bus: 'pci': add driver parport_pc
[    1.273817] bus: 'i2c': add driver bh1780
[    1.274306] bus: 'i2c': add driver bh1770glc
[    1.274811] bus: 'i2c': add driver apds9802als
[    1.275353] bus: 'spi': add driver dac7512
[    1.275840] bus: 'i2c': add driver at24
[    1.276306] bus: 'i2c': add driver lis3lv02d_i2c
[    1.276850] bus: 'spi': add driver arizona
[    1.277342] bus: 'i2c': add driver wm8994
[    1.277822] bus: 'i2c': add driver retu-mfd
[    1.278356] device class 'mtd': registering
[    1.278899] device: 'mtd-unmap': device_add
[    1.279486] device: 'mtd-romap': device_add
[    1.280051] device: 'mtd-rwmap': device_add
[    1.280585] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.281362] Could not find PAR responsible for SC520CDP Flash Bank #0
[    1.282135] Trying default address 0x8400000
[    1.282628] Could not find PAR responsible for SC520CDP Flash Bank #1
[    1.283367] Trying default address 0x8c00000
[    1.283858] Could not find PAR responsible for SC520CDP DIL Flash
[    1.284563] Trying default address 0x9400000
[    1.285189] SC520 CDP flash device: 0x800000 at 0x8400000
[    1.285795] Failed to ioremap_nocache
[    1.286230] NetSc520 flash device: 0x100000 at 0x200000
[    1.286830] Failed to ioremap_nocache
[    1.287268] bus: 'platform': add driver docg3
[    1.287802] bus: 'platform': remove driver docg3
[    1.288373] driver: 'docg3': driver_release
[    1.289573] No recognised DiskOnChip devices found
[    1.290121] slram: not enough parameters.
[    1.291975] device: 'mtd0': device_add
[    1.295308] bus: 'spi': add driver m25p80
[    1.295802] bus: 'spi': add driver sst25l
[    1.320364] No valid DiskOnChip devices found
[    1.320932] bus: 'platform': add driver gen_nand
[    1.359025] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    1.359715] OneNAND Manufacturer: Samsung (0xec)
[    1.360272] OneNAND 16MB 1.8V 16-bit (0x04)
[    1.360773] OneNAND version = 0x001e
[    1.361211] Lock scheme is Continuous Lock
[    1.361732] Scanning device for bad blocks
[    1.362882] Creating 1 MTD partitions on "OneNAND simulator":
[    1.363589] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    1.364668] device: 'mtd1': device_add
[    1.365181] bus: 'platform': add driver spi_altera
[    1.472243] device: 'spi42': device_add
[    1.472860] parport_pc 00:04: master is unqueued, this is deprecated
[    1.473721] device: 'spi42.1': device_add
[    1.474231] bus: 'spi': add device spi42.1
[    1.474778] parport0: AVR Butterfly
[    1.475219] bus: 'hsi': add driver hsi_char
[    1.475738] HSI/SSI char device loaded
[    1.476207] device class 'uio': registering
[    1.476727] bus: 'platform': add driver uio_pdrv_genirq
[    1.477377] bus: 'bcma': add driver bcma_hcd
[    1.477912] bus: 'pnp': add driver i8042 kbd
[    1.478471] bus: 'pnp': driver_probe_device: matched device 00:01 with driver i8042 kbd
[    1.479454] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:01
[    1.480365] driver: '00:01': driver_bound: bound to device 'i8042 kbd'
[    1.481156] bus: 'pnp': really_probe: bound device 00:01 to driver i8042 kbd
[    1.482058] bus: 'pnp': add driver i8042 aux
[    1.482588] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 aux
[    1.483554] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:02
[    1.484443] driver: '00:02': driver_bound: bound to device 'i8042 aux'
[    1.485255] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 aux
[    1.486117] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.487112] Registering platform device 'i8042'. Parent at platform
[    1.487874] device: 'i8042': device_add
[    1.488375] bus: 'platform': add device i8042
[    1.488967] bus: 'platform': add driver i8042
[    1.489525] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    1.490493] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    1.492070] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.492705] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.493346] driver: 'i8042': driver_bound: bound to device 'i8042'
[    1.494114] device: 'serio0': device_add
[    1.494614] bus: 'serio': add device serio0
[    1.495182] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    1.495203] device: 'serio1': device_add
[    1.495214] bus: 'serio': add device serio1
[    1.497039] bus: 'serio': add driver ps2mult
[    1.497592] bus: 'platform': add driver arc_ps2
[    1.498249] device: 'mice': device_add
[    1.498918] device: 'psaux': device_add
[    1.499556] mousedev: PS/2 mouse device common for all mice
[    1.500290] device: 'event0': device_add
[    1.500949] bus: 'i2c': add driver adp5588_keys
[    1.501526] bus: 'i2c': add driver adp5589_keys
[    1.502085] bus: 'serio': add driver atkbd
[    1.502606] bus: 'i2c': add driver lm8323
[    1.503113] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    1.504048] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    1.505075] bus: 'i2c': add driver lm8333
[    1.505660] bus: 'platform': add driver opencores-kbd
[    1.506331] bus: 'i2c': add driver qt2160
[    1.506875] bus: 'platform': add driver stmpe-keypad
[    1.507554] bus: 'serio': add driver stowaway
[    1.508164] bus: 'serio': add driver sunkbd
[    1.508708] device: 'input1': device_add
[    1.509250] bus: 'platform': add driver twl4030_keypad
[    1.509305] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.509320] device: 'event1': device_add
[    1.511891] bus: 'i2c': add driver synaptics_i2c
[    1.511916] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    1.511920] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    1.511924] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    1.511924] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    1.515917] bus: 'platform': add driver 88pm860x-touch
[    1.516030] atkbd: probe of serio1 rejects match -19
[    1.517159] bus: 'spi': add driver ad7877
[    1.517670] bus: 'i2c': add driver bu21013_tp
[    1.518211] bus: 'platform': add driver da9052-tsi
[    1.518824] bus: 'serio': add driver dynapro
[    1.519379] bus: 'i2c': add driver edt_ft5x06
[    1.519949] bus: 'serio': add driver hampshire
[    1.520515] bus: 'i2c': add driver eeti_ts
[    1.521061] bus: 'serio': add driver fujitsu_ts
[    1.521635] bus: 'serio': add driver inexio
[    1.522196] bus: 'serio': add driver mtouch
[    1.522740] bus: 'serio': add driver serio-penmount
[    1.523358] bus: 'i2c': add driver pixcir_ts
[    1.523904] bus: 'platform': add driver stmpe-ts
[    1.524482] bus: 'serio': add driver touchit213
[    1.525077] bus: 'serio': add driver touchright
[    1.525666] bus: 'serio': add driver tsc40
[    1.526206] bus: 'platform': add driver wm831x-touch
[    1.526837] bus: 'platform': add driver tps6507x-ts
[    1.527441] bus: 'platform': add driver 88pm860x-onkey
[    1.528099] bus: 'i2c': add driver ad714x_captouch
[    1.528780] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    1.529538] bus: 'i2c': add driver cma3000_i2c_accl
[    1.530151] bus: 'platform': add driver da9055-onkey
[    1.530771] bus: 'i2c': add driver kxtj9
[    1.531266] bus: 'i2c': add driver mpu3050
[    1.531807] bus: 'i2c': add driver pcf8574_keypad
[    1.532404] bus: 'platform': add driver retu-pwrbutton
[    1.533075] device: 'uinput': device_add
[    1.533609] bus: 'platform': add driver 88pm860x-rtc
[    1.534235] bus: 'pnp': add driver rtc_cmos
[    1.534756] bus: 'pnp': driver_probe_device: matched device 00:00 with driver rtc_cmos
[    1.535708] bus: 'pnp': really_probe: probing driver rtc_cmos with device 00:00
[    1.536636] rtc_cmos 00:00: RTC can wake from S4
[    1.537402] rtc (null): alarm rollover: day
[    1.537973] device: 'rtc0': device_add
[    1.538517] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.539366] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    1.540169] driver: '00:00': driver_bound: bound to device 'rtc_cmos'
[    1.540950] bus: 'pnp': really_probe: bound device 00:00 to driver rtc_cmos
[    1.541837] bus: 'platform': add driver rtc-ds1286
[    1.542456] bus: 'i2c': add driver rtc-ds1307
[    1.543031] bus: 'i2c': add driver rtc-ds1374
[    1.543598] bus: 'platform': add driver ds1511
[    1.544158] bus: 'platform': add driver rtc-ds1553
[    1.544767] bus: 'platform': add driver rtc-ds1742
[    1.545344] bus: 'spi': add driver ds3234
[    1.545877] bus: 'i2c': add driver rtc-em3027
[    1.546414] bus: 'i2c': add driver rtc-fm3130
[    1.546971] bus: 'i2c': add driver rtc-isl12022
[    1.547547] bus: 'spi': add driver rtc-m41t93
[    1.548091] bus: 'platform': add driver rtc-m48t35
[    1.548716] bus: 'platform': add driver max8907-rtc
[    1.549318] bus: 'platform': add driver max8998-rtc
[    1.549929] bus: 'spi': add driver rtc-max6902
[    1.550484] bus: 'platform': add driver rtc-msm6242
[    1.551106] bus: 'platform': remove driver rtc-msm6242
[    1.551749] driver: 'rtc-msm6242': driver_release
[    1.552322] bus: 'spi': add driver rtc-pcf2123
[    1.552879] bus: 'platform': add driver rtc-rp5c01
[    1.553495] bus: 'platform': remove driver rtc-rp5c01
[    1.554127] driver: 'rtc-rp5c01': driver_release
[    1.554691] bus: 'spi': add driver rtc-rs5c348
[    1.555295] bus: 'i2c': add driver rtc-rx8025
[    1.555850] bus: 'i2c': add driver rtc-rx8581
[    1.556392] bus: 'platform': add driver stk17ta8
[    1.556971] bus: 'platform': add driver twl_rtc
[    1.557542] bus: 'platform': add driver tps6586x-rtc
[    1.558163] bus: 'platform': add driver v3020
[    1.558750] bus: 'platform': add driver wm831x-rtc
[    1.559346] bus: 'platform': add driver wm8350-rtc
[    1.559954] bus: 'i2c': add driver rtc-x1205
[    1.560494] bus: 'i2c': add driver smbus_alert
[    1.561058] bus: 'platform': add driver ocores-i2c
[    1.561665] i2c-parport-light: adapter type unspecified
[    1.562295] bus: 'i2c': add driver pca954x
[    1.562822] pps_ldisc: PPS line discipline registered
[    1.563431] pps_parport: parallel port PPS client
[    1.564021] parport0: cannot grant exclusive access for device pps_parport
[    1.564840] pps_parport: couldn't register with parport0
[    1.565484] Driver for 1-wire Dallas network protocol.
[    1.566131] bus: 'w1': registered
[    1.566536] bus: 'w1': add driver w1_master_driver
[    1.567132] bus: 'w1': add driver w1_slave_driver
[    1.567718] bus: 'i2c': add driver ds2482
[    1.568227] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.568958] bus: 'platform': add driver ds1wm
[    1.569555] EDAC MC: Ver: 3.0.0
[    1.570223] bus: 'edac': registered
[    1.570681] device: 'edac': device_add
[    1.571169] device: 'mc': device_add
[    1.571619] bus: 'edac': add device mc
[    1.572224] 
[    1.572419] ===============================
[    1.572933] [ INFO: suspicious RCU usage. ]
[    1.573464] 3.8.0-rc6-00407-gfe1080a #40 Not tainted
[    1.574059] -------------------------------
[    1.574559] /c/kernel-tests/src/stable/drivers/cpufreq/cpufreq.c:1779 suspicious rcu_dereference_check() usage!
[    1.575759] 
[    1.575759] other info that might help us debug this:
[    1.575759] 
[    1.576720] 
[    1.576720] rcu_scheduler_active = 1, debug_locks = 0
[    1.577498] no locks held by swapper/0/1.
[    1.577982] 
[    1.577982] stack backtrace:
[    1.578533] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc6-00407-gfe1080a #40
[    1.579373] Call Trace:
[    1.579712]  [<ffffffff8109d4ed>] lockdep_rcu_suspicious+0xfd/0x130
[    1.580472]  [<ffffffff81339528>] cpufreq_update_policy+0x168/0x1b0
[    1.581233]  [<ffffffff81027bb8>] ? kvm_clock_read+0x38/0x50
[    1.581934]  [<ffffffff8100aae9>] ? sched_clock+0x9/0x10
[    1.582584]  [<ffffffff81080925>] ? sched_clock_local+0x25/0xa0
[    1.583297]  [<ffffffff81080ad8>] ? sched_clock_cpu+0xa8/0x120
[    1.584004]  [<ffffffff813beec3>] ? mutex_lock_nested+0x2a3/0x380
[    1.584739]  [<ffffffff8109ae3d>] ? trace_hardirqs_off+0xd/0x10
[    1.585444]  [<ffffffff81080d0f>] ? local_clock+0x6f/0x80
[    1.586104]  [<ffffffff813bfc03>] ? __mutex_unlock_slowpath+0xd3/0x170
[    1.586893]  [<ffffffff8183da07>] ? cpufreq_core_init+0xc1/0xc1
[    1.587603]  [<ffffffff8109acdd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[    1.588421]  [<ffffffff8109ad7d>] ? trace_hardirqs_on+0xd/0x10
[    1.589132]  [<ffffffff813bfca9>] ? mutex_unlock+0x9/0x10
[    1.589792]  [<ffffffff81051b20>] ? cpu_maps_update_done+0x10/0x20
[    1.590534]  [<ffffffff8183da07>] ? cpufreq_core_init+0xc1/0xc1
[    1.591252]  [<ffffffff8183da66>] cpufreq_stats_init+0x5f/0xe5
[    1.591970]  [<ffffffff81812c91>] do_one_initcall+0x7a/0x139
[    1.592660]  [<ffffffff81812e53>] kernel_init_freeable+0x103/0x18d
[    1.593393]  [<ffffffff81812566>] ? do_early_param+0x8c/0x8c
[    1.594086]  [<ffffffff813a8a00>] ? rest_init+0x150/0x150
[    1.594736]  [<ffffffff813a8a09>] kernel_init+0x9/0xe0
[    1.595389]  [<ffffffff813c353c>] ret_from_fork+0x7c/0xb0
[    1.596056]  [<ffffffff813a8a00>] ? rest_init+0x150/0x150
[    1.596707] cpuidle: using governor ladder
[    1.597202] cpuidle: using governor menu
[    1.597687] bus: 'sdio': add driver sdio_uart
[    1.598221] bus: 'spi': add driver mmc_spi
[    1.598746] bus: 'platform': add driver 88pm860x-led
[    1.599350] bus: 'i2c': add driver BD2802
[    1.599867] bus: 'i2c': add driver leds-pca953x
[    1.600425] bus: 'i2c': add driver lp5523x
[    1.600933] bus: 'i2c': add driver leds-tca6507
[    1.601503] bus: 'platform': add driver leds-ot200
[    1.602116] bus: 'platform': add driver da903x-led
[    1.602705] bus: 'platform': add driver da9052-leds
[    1.603297] bus: 'platform': add driver wm831x-status
[    1.603924] bus: 'platform': add driver leds-regulator
[    1.604557] bus: 'i2c': add driver blinkm
[    1.605088] bus: 'platform': add driver dcdbas
[    1.605649] Registering platform device 'dcdbas'. Parent at platform
[    1.606404] device: 'dcdbas': device_add
[    1.606886] bus: 'platform': add device dcdbas
[    1.607443] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[    1.608452] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[    1.609396] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    1.610315] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[    1.611079] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[    1.611977] bus: 'platform': add driver ste-modem
[    1.612601] bus: 'machinecheck': registered
[    1.613117] device: 'machinecheck': device_add
[    1.613657] device: 'machinecheck0': device_add
[    1.614207] bus: 'machinecheck': add device machinecheck0
[    1.614875] device: 'machinecheck1': device_add
[    1.615431] bus: 'machinecheck': add device machinecheck1
[    1.616107] device: 'mcelog': device_add
[    1.616670] 
[    1.616670] printing PIC contents
[    1.617256] ... PIC  IMR: ffff
[    1.617632] ... PIC  IRR: 1113
[    1.618012] ... PIC  ISR: 0000
[    1.618401] ... PIC ELCR: 0c00
[    1.618814] printing local APIC contents on CPU#0/0:
[    1.619435] ... APIC ID:      00000000 (0)
[    1.619805] ... APIC VERSION: 00050014
[    1.619805] ... APIC TASKPRI: 00000000 (00)
[    1.619805] ... APIC PROCPRI: 00000000
[    1.619805] ... APIC LDR: 01000000
[    1.619805] ... APIC DFR: ffffffff
[    1.619805] ... APIC SPIV: 000001ff
[    1.619805] ... APIC ISR field:
[    1.619805] 0000000000000000000000000000000000000000000000000000000000000000
[    1.619805] ... APIC TMR field:
[    1.619805] 0000000000000000000000000000000000000000000000000000000000000000
[    1.619805] ... APIC IRR field:
[    1.619805] 0000000000000000000000000000000000000000000000000000000000000000
[    1.619805] ... APIC ESR: 00000000
[    1.619805] ... APIC ICR: 000008fd
[    1.619805] ... APIC ICR2: 02000000
[    1.619805] ... APIC LVTT: 000000ef
[    1.619805] ... APIC LVTPC: 00010000
[    1.619805] ... APIC LVT0: 00010700
[    1.619805] ... APIC LVT1: 00000400
[    1.619805] ... APIC LVTERR: 000000fe
[    1.619805] ... APIC TMICT: 04362210
[    1.619805] ... APIC TMCCT: 03ffb3af
[    1.619805] ... APIC TDCR: 00000003
[    1.619805] 
[    1.631610] number of MP IRQ sources: 15.
[    1.632107] number of IO-APIC #2 registers: 24.
[    1.632647] testing the IO APIC.......................
[    1.633270] IO APIC #2......
[    1.633621] .... register #00: 00000000
[    1.634083] .......    : physical APIC id: 00
[    1.634599] .......    : Delivery Type: 0
[    1.635085] .......    : LTS          : 0
[    1.635562] .... register #01: 00170011
[    1.636023] .......     : max redirection entries: 17
[    1.636617] .......     : PRQ implemented: 0
[    1.637128] .......     : IO APIC version: 11
[    1.637645] .... register #02: 00000000
[    1.638105] .......     : arbitration: 00
[    1.638602] .... IRQ redirection table:
[    1.639065]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.639726]  00 00  1    0    0   0   0    0    0    00
[    1.640373]  01 03  0    0    0   0   0    1    1    31
[    1.641018]  02 03  0    0    0   0   0    1    1    30
[    1.641676]  03 03  0    0    0   0   0    1    1    33
[    1.642323]  04 03  1    0    0   0   0    1    1    34
[    1.642963]  05 03  1    1    0   0   0    1    1    35
[    1.643613]  06 03  0    0    0   0   0    1    1    36
[    1.644255]  07 03  0    0    0   0   0    1    1    37
[    1.644894]  08 03  0    0    0   0   0    1    1    38
[    1.645541]  09 03  0    1    0   0   0    1    1    39
[    1.646181]  0a 03  1    1    0   0   0    1    1    3A
[    1.646817]  0b 03  1    1    0   0   0    1    1    3B
[    1.647466]  0c 03  0    0    0   0   0    1    1    3C
[    1.648107]  0d 03  0    0    0   0   0    1    1    3D
[    1.648797]  0e 03  0    0    0   0   0    1    1    3E
[    1.649444]  0f 03  0    0    0   0   0    1    1    3F
[    1.650098]  10 00  1    0    0   0   0    0    0    00
[    1.650737]  11 00  1    0    0   0   0    0    0    00
[    1.651380]  12 00  1    0    0   0   0    0    0    00
[    1.652054]  13 00  1    0    0   0   0    0    0    00
[    1.652697]  14 00  1    0    0   0   0    0    0    00
[    1.653353]  15 00  1    0    0   0   0    0    0    00
[    1.653979]  16 00  1    0    0   0   0    0    0    00
[    1.654640]  17 00  1    0    0   0   0    0    0    00
[    1.655289] IRQ to pin mappings:
[    1.655670] IRQ0 -> 0:2
[    1.656050] IRQ1 -> 0:1
[    1.656382] IRQ3 -> 0:3
[    1.656703] IRQ4 -> 0:4
[    1.657027] IRQ5 -> 0:5
[    1.657342] IRQ6 -> 0:6
[    1.657663] IRQ7 -> 0:7
[    1.657976] IRQ8 -> 0:8
[    1.658355] IRQ9 -> 0:9
[    1.658677] IRQ10 -> 0:10
[    1.659023] IRQ11 -> 0:11
[    1.659360] IRQ12 -> 0:12
[    1.659706] IRQ13 -> 0:13
[    1.660053] IRQ14 -> 0:14
[    1.660388] IRQ15 -> 0:15
[    1.660753] .................................... done.
[    1.661367] device: 'cpu_dma_latency': device_add
[    1.661984] device: 'network_latency': device_add
[    1.662577] device: 'network_throughput': device_add
[    1.663684] bus: 'i2c': add driver wl1273-fm
[    1.664230] device class 'ubi': registering
[    1.664732] device: 'ubi_ctrl': device_add
[    1.665311] rtc_cmos 00:00: setting system clock to 2013-02-06 09:25:53 UTC (1360142753)
[    1.666508] debug: unmapping init [mem 0xffffffff8163f000-0xffffffff81873fff]
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[    2.100096] tsc: Refined TSC clocksource calibration: 2693.490 MHz

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fe1080a-bisect.log"

git checkout 1589a3e7777631ff56dd58cd7dcdf275185e62b5
Previous HEAD position was fe1080a... Merge remote-tracking branch 'asoc/topic/wm2200' into devel-hive-x86_64-2013-02-06-17-16
HEAD is now at 1589a3e... Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media

2013-02-06-19:35:12 1589a3e7777631ff56dd58cd7dcdf275185e62b5 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-19:36:24 detecting boot state 3.8.0-rc6-bisect3-00098-g1589a3e #33 	8............................	9 SUCCESS
bisect: good commit 1589a3e7777631ff56dd58cd7dcdf275185e62b5
git bisect start fe1080a91b378aa68f16b377e048e9ae7bf9aa2d 1589a3e7777631ff56dd58cd7dcdf275185e62b5 --
Previous HEAD position was 1589a3e... Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
HEAD is now at 3c0eee3f... Linux 2.6.37
Bisecting: 155 revisions left to test after this (roughly 7 steps)
[4b794a03dc679a3ae545f683e47a6ef5e5e21d33] Merge branch 'acpi-assorted' into linux-next
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-19:52:26 4b794a03dc679a3ae545f683e47a6ef5e5e21d33 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-19:53:45 detecting boot state 3.8.0-rc6-bisect3-00153-g4b794a0 #34 .........................	6	10............................	12 SUCCESS
Bisecting: 86 revisions left to test after this (roughly 6 steps)
[39391e788192294c9fe58cd47ec7eb8ef5091b79] Merge remote-tracking branch 'vireshk/cpufreq-updates' into devel-hive-x86_64-2013-02-06-17-16
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-20:22:17 39391e788192294c9fe58cd47ec7eb8ef5091b79 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-20:23:11 detecting boot state 3.8.0-rc6-bisect3-00320-g39391e7 #35 ...........................	10 TEST FAILURE
Bisecting: 34 revisions left to test after this (roughly 5 steps)
[16a44f82674ddd8d5b5b2527979ac22a25c55c50] cpufreq: TEGRA: Set policy->cpus from driver->init()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-20:37:43 16a44f82674ddd8d5b5b2527979ac22a25c55c50 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-20:38:57 detecting boot state 3.8.0-rc6-bisect3-00034-g16a44f8 #36 	5............................	6 SUCCESS
Bisecting: 15 revisions left to test after this (roughly 4 steps)
[6d50036dbaae080a1fb9376d4c4600b53b058d21] Merge branch 'acpi-cleanup-next' into linux-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-20:54:29 6d50036dbaae080a1fb9376d4c4600b53b058d21 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-20:55:41 detecting boot state 3.8.0-rc6-bisect3-00206-g6d50036 #37 ..........................	4	10............................	11 SUCCESS
Bisecting: 7 revisions left to test after this (roughly 3 steps)
[85ada2c52ecce7963c0858eedead2063b9f18e75] Merge branch 'pm-tools-next' into bleeding-edge
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-21:24:45 85ada2c52ecce7963c0858eedead2063b9f18e75 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-21:26:03 detecting boot state 3.8.0-rc6-bisect3-00214-g85ada2c #38 ..........................	6	10............................	15 SUCCESS
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[e62536d7877396c59e9eb5c52b470db6dbaf8ea1] cpufreq: Add per policy governor-init/exit infrastructure
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-21:55:08 e62536d7877396c59e9eb5c52b470db6dbaf8ea1 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-21:56:34 detecting boot state 3.8.0-rc6-bisect3-00218-ge62536d #39 .........................	1 TEST FAILURE
Bisecting: 1 revision left to test after this (roughly 1 step)
[9d55504e3e713c03c5260302497a72cc10f87149] cpufreq: Convert the cpufreq_driver_lock to use the rcu
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-22:10:07 9d55504e3e713c03c5260302497a72cc10f87149 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-22:11:22 detecting boot state 3.8.0-rc6-bisect3-00216-g9d55504 #40  TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[1184c024165b1e8de45f6fc9eb0cde336c2fa1f5] cpufreq: Convert the cpufreq_driver_lock to a rwlock
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-06-22:11:53 1184c024165b1e8de45f6fc9eb0cde336c2fa1f5 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect3': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect3': Operation not permitted
/home/wfg/mm

2013-02-06-22:13:13 detecting boot state 3.8.0-rc6-bisect3-00215-g1184c02 #41 	8............................	9	17 SUCCESS
9d55504e3e713c03c5260302497a72cc10f87149 is the first bad commit
commit 9d55504e3e713c03c5260302497a72cc10f87149
Author: Nathan Zimmer <nzimmer@sgi.com>
Date:   Tue Feb 5 20:04:50 2013 -0600

    cpufreq: Convert the cpufreq_driver_lock to use the rcu
    
    In general rwlocks are discourged so we are moving it to use the rcu instead.
    
    Cc: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>

:040000 040000 8a3efe48177bfc1469380ead93026f529558d6bf 7f03387350cc9170179c4925fd3e283543910800 M	drivers
bisect run success

2013-02-06-22:29:15 1184c024165b1e8de45f6fc9eb0cde336c2fa1f5 compiling
/home/wfg/mm

2013-02-06-22:29:35 detecting boot state 3.8.0-rc6-bisect3-00215-g1184c02 #41 ...........................	4	10............................	12	20............................	21	28 SUCCESS

========= linux-next =========

2013-02-06-23:14:45 164708bec016c6ceb76a2bb2e29b086bf0ad4e37 compiling
/home/wfg/mm

2013-02-06-23:15:49 detecting boot state 3.8.0-rc6-bisect3-next-20130204 #41 .........................	1	9	10............................	17	20............................	26 SUCCESS

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.8.0-rc6 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_GENERIC_SIGALTSTACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
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
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
# CONFIG_M25PXX_USE_FAST_READ is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_DOCPROBE_HIGH=y
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_VIBRA is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
# CONFIG_IPMI_SI is not set
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX8998 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_FAIR_SHARE is not set
CONFIG_STEP_WISE=y
CONFIG_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_AS3711 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ARIZONA is not set
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8998=y
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=y
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_TLBFLUSH=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_VHOST_NET is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--0OAP2g/MAC+5xKAE--
