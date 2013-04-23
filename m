Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3DWRR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:17:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34349 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3DWRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:17:53 -0400
Date: Tue, 23 Apr 2013 10:01:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: linux-next: Tree for Apr 23 [ Call-Traces: lib/debugobjects.c |
 kernel/rcupdate.c | kernel/rcutree.c ]
Message-ID: <20130423170129.GB3427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+icZUWXpaXi9GwB37hLaPbZaAi2aOMXez1f79DDtb_22ZY1jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWXpaXi9GwB37hLaPbZaAi2aOMXez1f79DDtb_22ZY1jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042317-3620-0000-0000-0000022712FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:49:35PM +0200, Sedat Dilek wrote:
> On Tue, Apr 23, 2013 at 10:00 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > Changes since 20130422:
> >
> > The net-next tree lost its build failure but gained another for which I
> > applied a patch.
> >
> > The akpm tree gained a conflict against the tip tree.
> >
> > ----------------------------------------------------------------------------
> >
> 
> Can't say this is related to the ipc-sem-next issue I have seen or the
> real trouble-causer.
> 
> [  168.609273] WARNING: at lib/debugobjects.c:260 debug_print_object+0x8e/0xb0()
> [  168.609492] WARNING: at kernel/rcupdate.c:309
> rcuhead_fixup_activate+0x5a/0x70()
> [  168.609672] WARNING: at lib/debugobjects.c:260 debug_print_object+0x8e/0xb0()
> [  168.784401] WARNING: at kernel/rcutree.c:2105
> rcu_process_callbacks+0x54d/0x5b0()
> 
> For details see attached dmesg and kernel-config files.
> 
> Paul?

The trick is to look at the line immediately following the first warning:

[  168.609273] WARNING: at lib/debugobjects.c:260 debug_print_object+0x8e/0xb0()
[  168.609277] ODEBUG: activate active (active state 1) object type: rcu_head hint:           (null)

This happens when someone invokes kfree_rcu() or call_rcu() on an object
that had already been either kfree_rcu()ed or call_rcu()ed and whose
grace period has not yet ended.

So let's look at the stack trace:

[  168.609371] Call Trace:
[  168.609379]  [<ffffffff816c1956>] dump_stack+0x19/0x1b
[  168.609384]  [<ffffffff81059680>] warn_slowpath_common+0x70/0xa0
[  168.609389]  [<ffffffff81059766>] warn_slowpath_fmt+0x46/0x50
[  168.609394]  [<ffffffff8134e12e>] ? radix_tree_lookup_slot+0xe/0x10
[  168.609399]  [<ffffffff8135e50e>] debug_print_object+0x8e/0xb0
[  168.609404]  [<ffffffff8135eb23>] debug_object_activate+0xf3/0x170
[  168.609410]  [<ffffffff810f1de6>] __call_rcu.constprop.54+0x46/0x250
[  168.609415]  [<ffffffff810f204a>] kfree_call_rcu+0x1a/0x20
[  168.609421]  [<ffffffff812bb064>] ipc_rcu_putref+0x34/0x60
[  168.609425]  [<ffffffff812bec33>] SYSC_semtimedop+0xb23/0xc90
[  168.609433]  [<ffffffff81159d21>] ? handle_mm_fault+0x251/0x360
[  168.609439]  [<ffffffff816cc698>] ? __do_page_fault+0x2a8/0x560
[  168.609445]  [<ffffffff812d2289>] ? security_ipc_permission+0x19/0x20
[  168.609450]  [<ffffffff812bb13c>] ? ipcperms+0xac/0x130
[  168.609455]  [<ffffffff8135deed>] ? do_raw_spin_unlock+0x5d/0xb0
[  168.609460]  [<ffffffff816c851e>] ? _raw_spin_unlock+0xe/0x10
[  168.609465]  [<ffffffff812bb4e3>] ? ipcget+0x113/0x1b0
[  168.609469]  [<ffffffff8119a4e5>] ? SYSC_newfstat+0x25/0x30
[  168.609474]  [<ffffffff812bfa4e>] SyS_semtimedop+0xe/0x10
[  168.609478]  [<ffffffff812bfa60>] SyS_semop+0x10/0x20
[  168.609482]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f

It appears that ipc_rcu_putref() is the culprit, maybe with the help
of the semtimedop() system call.  The remaining warnings are due to
RCU's lists getting tangled.

The output would probably be less confusing if RCU simply leaked callbacks
that the debug-objects facility complained about.  This would not be
perfect, but better a memory leak or even an hang than memory corruption.
Though of course even memory corruption preceded by warnings is better
than silent memory corruption.

I will take a look at that.

							Thanx, Paul

> - Sedat -

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.9.0-rc8-next20130423-1-iniza-small (sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Tue Apr 23 17:32:44 CEST 2013
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-rc8-next20130423-1-iniza-small root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000d9c9efff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000d9c9f000-0x00000000dae7efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dae7f000-0x00000000daf9efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fdfffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.6 present.
> [    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x11fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 base 0C0000000 mask FE0000000 write-back
> [    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
> [    0.000000]   4 base 0DB000000 mask FFF000000 uncachable
> [    0.000000]   5 base 100000000 mask FE0000000 write-back
> [    0.000000]   6 base 11FE00000 mask FFFE00000 uncachable
> [    0.000000]   7 base 0FFC00000 mask FFFC00000 write-protect
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f00e0-0x000f00ef] mapped at [ffff8800000f00e0]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] reserving inaccessible SNB gfx pages
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0202e000, 0x0202efff] PGTABLE
> [    0.000000] BRK [0x0202f000, 0x0202ffff] PGTABLE
> [    0.000000] BRK [0x02030000, 0x02030fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x11fc00000-0x11fdfffff]
> [    0.000000]  [mem 0x11fc00000-0x11fdfffff] page 2M
> [    0.000000] BRK [0x02031000, 0x02031fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fbfffff]
> [    0.000000]  [mem 0x11c000000-0x11fbfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
> [    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
> [    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x40200000-0xd9c9efff]
> [    0.000000]  [mem 0x40200000-0xd9bfffff] page 2M
> [    0.000000]  [mem 0xd9c00000-0xd9c9efff] page 4k
> [    0.000000] BRK [0x02032000, 0x02032fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
> [    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
> [    0.000000] RAMDISK: [mem 0x379ae000-0x37ccefff]
> [    0.000000] ACPI: RSDP 00000000000f0100 00024 (v02 SECCSD)
> [    0.000000] ACPI: XSDT 00000000daffe170 0008C (v01 SECCSD LH43STAR 00000002 PTEC 00000002)
> [    0.000000] ACPI: FACP 00000000dafef000 0010C (v05 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: DSDT 00000000daff2000 083AC (v02 SECCSD  SNB-CPT 00000000 INTL 20061109)
> [    0.000000] ACPI: FACS 00000000daf47000 00040
> [    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 SECCSD LH43STAR 00000002 PTEC 00000001)
> [    0.000000] ACPI: SSDT 00000000daffb000 01068 (v01 SECCSD PtidDevc 00001000 INTL 20061109)
> [    0.000000] ACPI: ASF! 00000000daff1000 000A5 (v32 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: HPET 00000000dafee000 00038 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: APIC 00000000dafed000 00098 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: MCFG 00000000dafec000 0003C (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafeb000 00804 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
> [    0.000000] ACPI: SSDT 00000000dafea000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
> [    0.000000] ACPI: UEFI 00000000dafe9000 0003E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: UEFI 00000000dafe8000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
> [    0.000000] ACPI: UEFI 00000000dafe7000 0026A (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafe6000 000D0 (v01   Iffs  IffsAsl 00003000 INTL 20061109)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fdfffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fdfffff]
> [    0.000000]   NODE_DATA [mem 0x11fdf7000-0x11fdfbfff]
> [    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011b400000-ffff88011edfffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x11fdfffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
> [    0.000000]   node   0: [mem 0x40200000-0xd9c9efff]
> [    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x11fdfffff]
> [    0.000000] On node 0 totalpages: 1021500
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 156 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 12127 pages used for memmap
> [    0.000000]   DMA32 zone: 886944 pages, LIFO batch:31
> [    0.000000]   Normal zone: 1785 pages used for memmap
> [    0.000000]   Normal zone: 130560 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 00000000d9c9f000 - 00000000dae7f000
> [    0.000000] PM: Registered nosave memory: 00000000dae7f000 - 00000000daf9f000
> [    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
> [    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
> [    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
> [    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
> [    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
> [    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fa00000 s86208 r8192 d24384 u262144
> [    0.000000] pcpu-alloc: s86208 r8192 d24384 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1007376
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-rc8-next20130423-1-iniza-small root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 3938732k/4716544k available (6996k kernel code, 630544k absent, 147268k reserved, 6308k data, 1312k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 16777216 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] ODEBUG: 0 of 0 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 1596.428 MHz processor
> [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.85 BogoMIPS (lpj=6385712)
> [    0.000009] pid_max: default: 32768 minimum: 301
> [    0.000140] Security Framework initialized
> [    0.000152] AppArmor: AppArmor initialized
> [    0.000155] Yama: becoming mindful.
> [    0.000539] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.001601] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.002069] Mount-cache hash table entries: 256
> [    0.002608] Initializing cgroup subsys memory
> [    0.002676] Initializing cgroup subsys devices
> [    0.002681] Initializing cgroup subsys freezer
> [    0.002684] Initializing cgroup subsys blkio
> [    0.002687] Initializing cgroup subsys perf_event
> [    0.002692] Initializing cgroup subsys hugetlb
> [    0.002775] Disabled fast string operations
> [    0.002779] CPU: Physical Processor ID: 0
> [    0.002782] CPU: Processor Core ID: 0
> [    0.002788] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.002788] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.002795] mce: CPU supports 7 MCE banks
> [    0.002813] CPU0: Thermal monitoring enabled (TM1)
> [    0.002824] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.002824] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.002824] tlb_flushall_shift: 5
> [    0.002918] Freeing SMP alternatives: 24k freed
> [    0.003889] ACPI: Core revision 20130328
> [    0.014615] ACPI: All ACPI Tables successfully acquired
> [    0.016156] ftrace: allocating 26438 entries in 104 pages
> [    0.031111] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.070774] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz (fam: 06, model: 2a, stepping: 07)
> [    0.070786] TSC deadline timer enabled
> [    0.070799] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
> [    0.070811] ... version:                3
> [    0.070814] ... bit width:              48
> [    0.070816] ... generic registers:      4
> [    0.070818] ... value mask:             0000ffffffffffff
> [    0.070821] ... max period:             000000007fffffff
> [    0.070824] ... fixed-purpose events:   3
> [    0.070826] ... event mask:             000000070000000f
> [    0.083865] Disabled fast string operations
> [    0.087045] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.098588] Disabled fast string operations
> [    0.112243] Disabled fast string operations
> [    0.072831] smpboot: Booting Node   0, Processors  #1 #2 #3
> [    0.114375] Brought up 4 CPUs
> [    0.114384] smpboot: Total of 4 processors activated (12771.42 BogoMIPS)
> [    0.118396] devtmpfs: initialized
> [    0.120381] EVM: security.selinux
> [    0.120385] EVM: security.SMACK64
> [    0.120387] EVM: security.capability
> [    0.120473] PM: Registering ACPI NVS region [mem 0xdae7f000-0xdaf9efff] (1179648 bytes)
> [    0.121944] regulator-dummy: no parameters
> [    0.122096] NET: Registered protocol family 16
> [    0.122442] ACPI: bus type PCI registered
> [    0.122560] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.122566] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.129331] PCI: Using configuration type 1 for base access
> [    0.132644] bio: create slab <bio-0> at 0
> [    0.133045] ACPI: Added _OSI(Module Device)
> [    0.133050] ACPI: Added _OSI(Processor Device)
> [    0.133054] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.133057] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.134832] ACPI: EC: Look up EC in DSDT
> [    0.162447] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.168364] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.179885] ACPI: SSDT 00000000dae70718 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.180383] ACPI: Dynamic OEM Table Load:
> [    0.180387] ACPI: SSDT           (null) 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.190866] ACPI: SSDT 00000000dae71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.191441] ACPI: Dynamic OEM Table Load:
> [    0.191446] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.202553] ACPI: SSDT 00000000dae6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.203023] ACPI: Dynamic OEM Table Load:
> [    0.203027] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.216787] ACPI: Interpreter enabled
> [    0.216805] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
> [    0.216829] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.216832] ACPI: Using IOAPIC for interrupt routing
> [    0.216890] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.240637] ACPI: Power Resource [FN00] (off)
> [    0.240823] ACPI: Power Resource [FN01] (off)
> [    0.241007] ACPI: Power Resource [FN02] (off)
> [    0.241188] ACPI: Power Resource [FN03] (off)
> [    0.241374] ACPI: Power Resource [FN04] (off)
> [    0.242473] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.242816] \_SB_.PCI0:_OSC invalid UUID
> [    0.242818] _OSC request data:1 8 0 
> [    0.243804] PCI host bridge to bus 0000:00
> [    0.243810] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.243814] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.243818] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.243822] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.243826] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
> [    0.243829] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    0.243848] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
> [    0.244008] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
> [    0.244021] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
> [    0.244029] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.244034] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
> [    0.244221] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
> [    0.244246] pci 0000:00:16.0: reg 10: [mem 0xf0705000-0xf070500f 64bit]
> [    0.244332] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.244496] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
> [    0.244521] pci 0000:00:1a.0: reg 10: [mem 0xf070a000-0xf070a3ff]
> [    0.244622] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.244728] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
> [    0.244748] pci 0000:00:1b.0: reg 10: [mem 0xf0700000-0xf0703fff 64bit]
> [    0.244826] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.244871] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.244942] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
> [    0.245035] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.245084] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.245158] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
> [    0.245248] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.245305] pci 0000:00:1c.3: System wakeup disabled by ACPI
> [    0.245379] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
> [    0.245510] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.245644] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
> [    0.245669] pci 0000:00:1d.0: reg 10: [mem 0xf0709000-0xf07093ff]
> [    0.245770] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.245871] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
> [    0.246076] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
> [    0.246097] pci 0000:00:1f.2: reg 10: [io  0x3088-0x308f]
> [    0.246108] pci 0000:00:1f.2: reg 14: [io  0x3094-0x3097]
> [    0.246118] pci 0000:00:1f.2: reg 18: [io  0x3080-0x3087]
> [    0.246128] pci 0000:00:1f.2: reg 1c: [io  0x3090-0x3093]
> [    0.246137] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
> [    0.246147] pci 0000:00:1f.2: reg 24: [mem 0xf0708000-0xf07087ff]
> [    0.246200] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.246320] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
> [    0.246339] pci 0000:00:1f.3: reg 10: [mem 0xf0704000-0xf07040ff 64bit]
> [    0.246363] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
> [    0.246746] pci 0000:01:00.0: [8086:0091] type 00 class 0x028000
> [    0.246942] pci 0000:01:00.0: reg 10: [mem 0xf0600000-0xf0601fff 64bit]
> [    0.247667] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> [    0.247837] pci 0000:01:00.0: System wakeup disabled by ACPI
> [    0.254550] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.254559] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
> [    0.254728] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
> [    0.254798] pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
> [    0.254921] pci 0000:02:00.0: reg 18: [mem 0xf0404000-0xf0404fff 64bit pref]
> [    0.254997] pci 0000:02:00.0: reg 20: [mem 0xf0400000-0xf0403fff 64bit pref]
> [    0.255329] pci 0000:02:00.0: supports D1 D2
> [    0.255331] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.255458] pci 0000:02:00.0: System wakeup disabled by ACPI
> [    0.262468] pci 0000:00:1c.3: PCI bridge to [bus 02]
> [    0.262482] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.262504] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.262705] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
> [    0.262742] pci 0000:03:00.0: reg 10: [mem 0xf0500000-0xf0507fff 64bit]
> [    0.262941] pci 0000:03:00.0: PME# supported from D3hot D3cold
> [    0.270461] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.270481] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
> [    0.270678] \_SB_.PCI0:_OSC invalid UUID
> [    0.270680] _OSC request data:1 1f 0 
> [    0.270685] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> [    0.270690] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.271513] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
> [    0.271632] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.271750] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
> [    0.271866] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
> [    0.271981] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
> [    0.272096] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.272212] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
> [    0.272327] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
> [    0.272881] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.272891] acpi root: \_SB_.PCI0 notify handler is installed
> [    0.272952] Found 1 acpi root devices
> [    0.273019] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    0.273226] ACPI: No dock devices found.
> [    0.273430] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.273436] vgaarb: loaded
> [    0.273438] vgaarb: bridge control possible 0000:00:02.0
> [    0.274114] SCSI subsystem initialized
> [    0.274119] ACPI: bus type ATA registered
> [    0.274233] libata version 3.00 loaded.
> [    0.274293] ACPI: bus type USB registered
> [    0.274343] usbcore: registered new interface driver usbfs
> [    0.274369] usbcore: registered new interface driver hub
> [    0.274427] usbcore: registered new device driver usb
> [    0.274745] PCI: Using ACPI for IRQ routing
> [    0.276413] PCI: pci_cache_line_size set to 64 bytes
> [    0.276524] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.276527] e820: reserve RAM buffer [mem 0xd9c9f000-0xdbffffff]
> [    0.276529] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
> [    0.276531] e820: reserve RAM buffer [mem 0x11fe00000-0x11fffffff]
> [    0.276814] NetLabel: Initializing
> [    0.276817] NetLabel:  domain hash size = 128
> [    0.276819] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.276868] NetLabel:  unlabeled traffic allowed by default
> [    0.276953] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.276962] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.278977] Switching to clocksource hpet
> [    0.296058] AppArmor: AppArmor Filesystem Enabled
> [    0.296117] pnp: PnP ACPI init
> [    0.296135] ACPI: bus type PNP registered
> [    0.296489] pnp 00:00: [dma 4]
> [    0.296532] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.296576] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.296745] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.296799] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.296876] system 00:04: [io  0x0680-0x069f] has been reserved
> [    0.296881] system 00:04: [io  0x1000-0x100f] has been reserved
> [    0.296885] system 00:04: [io  0x5000-0x5003] has been reserved
> [    0.296889] system 00:04: [io  0xffff] has been reserved
> [    0.296893] system 00:04: [io  0x0400-0x0453] has been reserved
> [    0.296898] system 00:04: [io  0x0458-0x047f] has been reserved
> [    0.296902] system 00:04: [io  0x0500-0x057f] has been reserved
> [    0.296906] system 00:04: [io  0x0a00-0x0a0f] has been reserved
> [    0.296910] system 00:04: [io  0x164e-0x164f] has been reserved
> [    0.296915] system 00:04: [io  0x5000-0x500f] could not be reserved
> [    0.296920] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.296968] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.297062] system 00:06: [io  0x0454-0x0457] has been reserved
> [    0.297068] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    0.297126] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.297216] pnp 00:08: Plug and Play ACPI device, IDs ETD0b00 SYN0002 PNP0f13 (active)
> [    0.297529] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.297534] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.297539] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.297543] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.297547] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.297551] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.297555] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
> [    0.297560] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.297565] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
> [    0.297569] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.297574] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.298220] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.298258] pnp: PnP ACPI: found 11 devices
> [    0.298261] ACPI: bus type PNP unregistered
> [    0.305833] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.305843] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
> [    0.305855] pci 0000:00:1c.3: PCI bridge to [bus 02]
> [    0.305860] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.305871] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.305882] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.305889] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
> [    0.306327] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.306329] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.306331] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.306333] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
> [    0.306335] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
> [    0.306337] pci_bus 0000:01: resource 1 [mem 0xf0600000-0xf06fffff]
> [    0.306339] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> [    0.306342] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.306344] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
> [    0.306461] NET: Registered protocol family 2
> [    0.306804] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.306997] TCP bind hash table entries: 32768 (order: 8, 1048576 bytes)
> [    0.307281] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.307541] TCP: reno registered
> [    0.307562] UDP hash table entries: 2048 (order: 5, 196608 bytes)
> [    0.307627] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
> [    0.307869] NET: Registered protocol family 1
> [    0.307890] pci 0000:00:02.0: Boot video device
> [    0.308660] PCI: CLS 64 bytes, default 64
> [    0.308872] Trying to unpack rootfs image as initramfs...
> [    0.379902] Freeing initrd memory: 3204k freed
> [    0.380585] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.380595] software IO TLB [mem 0xd5c9f000-0xd9c9f000] (64MB) mapped at [ffff8800d5c9f000-ffff8800d9c9efff]
> [    0.380931] Scanning for low memory corruption every 60 seconds
> [    0.381298] Initialise module verification
> [    0.381362] audit: initializing netlink socket (disabled)
> [    0.381382] type=2000 audit(1366738562.376:1): initialized
> [    0.410723] bounce pool size: 64 pages
> [    0.410751] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.411381] VFS: Disk quotas dquot_6.5.2
> [    0.411425] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.412147] fuse init (API version 7.21)
> [    0.412244] msgmni has been set to 7699
> [    0.412789] Key type asymmetric registered
> [    0.412793] Asymmetric key parser 'x509' registered
> [    0.412843] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.412897] io scheduler noop registered
> [    0.412901] io scheduler deadline registered (default)
> [    0.412933] io scheduler cfq registered
> [    0.413326] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.413371] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.413464] intel_idle: MWAIT substates: 0x21120
> [    0.413466] intel_idle: v0.4 model 0x2A
> [    0.413467] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.413918] ACPI: AC Adapter [ADP1] (on-line)
> [    0.414300] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    0.414326] ACPI: Lid Switch [LID0]
> [    0.414393] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    0.414400] ACPI: Power Button [PWRB]
> [    0.414464] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.414470] ACPI: Power Button [PWRF]
> [    0.414570] ACPI: Fan [FAN0] (off)
> [    0.414624] ACPI: Fan [FAN1] (off)
> [    0.414678] ACPI: Fan [FAN2] (off)
> [    0.414730] ACPI: Fan [FAN3] (off)
> [    0.414785] ACPI: Fan [FAN4] (off)
> [    0.414879] ACPI: Requesting acpi_cpufreq
> [    0.422078] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.422083] ACPI: Thermal Zone [TZ00] (66 C)
> [    0.422505] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.422509] ACPI: Thermal Zone [TZ01] (30 C)
> [    0.422572] GHES: HEST is not enabled!
> [    0.422785] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    0.427492] ACPI: Battery Slot [BAT1] (battery present)
> [    0.427514] Linux agpgart interface v0.103
> [    0.429936] brd: module loaded
> [    0.431170] loop: module loaded
> [    0.431396] mei_me 0000:00:16.0: setting latency timer to 64
> [    0.431462] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
> [    0.435390] ahci 0000:00:1f.2: version 3.0
> [    0.435575] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
> [    0.435777] ahci: SSS flag set, parallel bus scan disabled
> [    0.450903] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
> [    0.450909] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
> [    0.450918] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.475692] scsi0 : ahci
> [    0.475852] scsi1 : ahci
> [    0.475965] scsi2 : ahci
> [    0.476077] scsi3 : ahci
> [    0.476191] scsi4 : ahci
> [    0.476342] scsi5 : ahci
> [    0.476416] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708100 irq 41
> [    0.476422] ata2: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708180 irq 41
> [    0.476426] ata3: DUMMY
> [    0.476430] ata4: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708280 irq 41
> [    0.476435] ata5: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708300 irq 41
> [    0.476439] ata6: DUMMY
> [    0.477348] libphy: Fixed MDIO Bus: probed
> [    0.477614] tun: Universal TUN/TAP device driver, 1.6
> [    0.477617] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.477692] PPP generic driver version 2.4.2
> [    0.477801] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.477805] ehci-pci: EHCI PCI platform driver
> [    0.477987] ehci-pci 0000:00:1a.0: setting latency timer to 64
> [    0.477996] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    0.478006] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    0.478029] ehci-pci 0000:00:1a.0: debug port 2
> [    0.481953] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    0.482000] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf070a000
> [    0.490854] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    0.490899] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.490903] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.490908] usb usb1: Product: EHCI Host Controller
> [    0.490911] usb usb1: Manufacturer: Linux 3.9.0-rc8-next20130423-1-iniza-small ehci_hcd
> [    0.490915] usb usb1: SerialNumber: 0000:00:1a.0
> [    0.491072] hub 1-0:1.0: USB hub found
> [    0.491081] hub 1-0:1.0: 2 ports detected
> [    0.491360] ehci-pci 0000:00:1d.0: setting latency timer to 64
> [    0.491367] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    0.491378] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    0.491400] ehci-pci 0000:00:1d.0: debug port 2
> [    0.495309] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    0.495355] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0709000
> [    0.506844] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.506882] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.506885] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.506889] usb usb2: Product: EHCI Host Controller
> [    0.506893] usb usb2: Manufacturer: Linux 3.9.0-rc8-next20130423-1-iniza-small ehci_hcd
> [    0.506897] usb usb2: SerialNumber: 0000:00:1d.0
> [    0.507041] hub 2-0:1.0: USB hub found
> [    0.507049] hub 2-0:1.0: 2 ports detected
> [    0.507178] ehci-platform: EHCI generic platform driver
> [    0.507199] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.507235] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.507361] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.507370] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
> [    0.517146] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [    0.517154] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [    0.517161] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [    0.517170] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [    0.517177] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
> [    0.517462] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.517466] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.517470] usb usb3: Product: xHCI Host Controller
> [    0.517473] usb usb3: Manufacturer: Linux 3.9.0-rc8-next20130423-1-iniza-small xhci_hcd
> [    0.517477] usb usb3: SerialNumber: 0000:03:00.0
> [    0.517582] xHCI xhci_add_endpoint called for root hub
> [    0.517584] xHCI xhci_check_bandwidth called for root hub
> [    0.517619] hub 3-0:1.0: USB hub found
> [    0.517634] hub 3-0:1.0: 2 ports detected
> [    0.517745] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.517752] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
> [    0.517808] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    0.517812] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.517816] usb usb4: Product: xHCI Host Controller
> [    0.517819] usb usb4: Manufacturer: Linux 3.9.0-rc8-next20130423-1-iniza-small xhci_hcd
> [    0.517823] usb usb4: SerialNumber: 0000:03:00.0
> [    0.517923] xHCI xhci_add_endpoint called for root hub
> [    0.517925] xHCI xhci_check_bandwidth called for root hub
> [    0.517960] hub 4-0:1.0: USB hub found
> [    0.517972] hub 4-0:1.0: 2 ports detected
> [    0.534896] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
> [    0.542148] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.542157] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.542370] mousedev: PS/2 mouse device common for all mice
> [    0.542828] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    0.542866] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    0.542924] device-mapper: uevent: version 1.0.3
> [    0.543001] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
> [    0.543195] cpuidle: using governor ladder
> [    0.543204] ledtrig-cpu: registered to indicate activity on CPUs
> [    0.543207] EFI Variables Facility v0.08 2004-May-17
> [    0.543417] ashmem: initialized
> [    0.543597] TCP: cubic registered
> [    0.543690] NET: Registered protocol family 10
> [    0.544112] NET: Registered protocol family 17
> [    0.544129] Key type dns_resolver registered
> [    0.544540] PM: Hibernation image not present or could not be loaded.
> [    0.544542] Loading module verification certificates
> [    0.545637] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 158da1ea05b4bffc2d4fcbdee5f3eb9a27598d31'
> [    0.545667] registered taskstats version 1
> [    0.548963] Key type trusted registered
> [    0.551205] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    0.552282] Key type encrypted registered
> [    0.583767] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    0.583773] EDD information not available.
> [    0.794742] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.795926] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
> [    0.795946] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    0.796980] ata1.00: configured for UDMA/133
> [    0.797277] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 GG2O PQ: 0 ANSI: 5
> [    0.797530] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    0.797539] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    0.797632] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.797651] sd 0:0:0:0: [sda] Write Protect is off
> [    0.797657] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.797703] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.802713] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    0.808556]  sda: sda1 sda2 sda3
> [    0.809583] sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.935304] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    0.935324] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    0.935688] hub 1-1:1.0: USB hub found
> [    0.935893] hub 1-1:1.0: 6 ports detected
> [    1.046573] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    1.114520] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.115102] ata2.00: ATA-8: SanDisk iSSD P4 16GB, SSD 9.14, max UDMA/133
> [    1.115121] ata2.00: 31277232 sectors, multi 1: LBA48 
> [    1.115781] ata2.00: configured for UDMA/133
> [    1.116160] scsi 1:0:0:0: Direct-Access     ATA      SanDisk iSSD P4  SSD  PQ: 0 ANSI: 5
> [    1.116403] sd 1:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
> [    1.116421] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    1.116591] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.116601] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.116734] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.117970]  sdb: sdb1 sdb2
> [    1.118451] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.179136] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.179157] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.179506] hub 2-1:1.0: USB hub found
> [    1.179573] hub 2-1:1.0: 6 ports detected
> [    1.254566] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
> [    1.356710] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
> [    1.356729] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.356740] usb 1-1.2: Product: USB-PS/2 Optical Mouse
> [    1.356748] usb 1-1.2: Manufacturer: Logitech
> [    1.382244] tsc: Refined TSC clocksource calibration: 1596.373 MHz
> [    1.382262] Switching to clocksource tsc
> [    1.430441] usb 1-1.4: new high-speed USB device number 4 using ehci-pci
> [    1.434260] ata4: SATA link down (SStatus 0 SControl 300)
> [    1.686544] usb 1-1.4: New USB device found, idVendor=2232, idProduct=1018
> [    1.686565] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.686577] usb 1-1.4: Product: WebCam SC-13HDL11431N
> [    1.686585] usb 1-1.4: Manufacturer: 123
> [    1.758060] ata5: SATA link down (SStatus 0 SControl 300)
> [    1.759125] Freeing unused kernel memory: 1312k freed
> [    1.759341] Write protecting the kernel read-only data: 12288k
> [    1.762417] Freeing unused kernel memory: 1184k freed
> [    1.764880] Freeing unused kernel memory: 1052k freed
> [    1.785733] udevd[120]: starting version 175
> [    1.902180] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    1.902618] r8169 0000:02:00.0: irq 47 for MSI/MSI-X
> [    1.903046] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000620000, e8:03:9a:36:17:a9, XID 0c900800 IRQ 47
> [    1.903058] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    1.909776] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.917379] usbcore: registered new interface driver usbhid
> [    1.917387] usbhid: USB HID core driver
> [    1.934026] usb 2-1.5: new full-speed USB device number 3 using ehci-pci
> [    1.967140] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
> [    1.967387] hid-generic 0003:046D:C00E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.2/input0
> [    2.030723] usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
> [    2.030742] usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.770832] EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
> [   24.002949] Adding 262140k swap on /host/ubuntu/disks/swap.disk.  Priority:-1 extents:1 across:262140k FS
> [   24.023641] EXT4-fs (loop0): re-mounted. Opts: errors=remount-ro
> [   24.046366] udevd[593]: starting version 175
> [   24.214268] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130328/utaddress-251)
> [   24.214280] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   24.214287] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)
> [   24.214292] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   24.214294] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)
> [   24.214300] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   24.214302] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)
> [   24.214307] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   24.214309] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   24.462809] lp: driver loaded but no devices found
> [   24.630555] wmi: Mapper loaded
> [   24.645633] samsung_laptop: detected SABI interface: SwSmi@
> [   24.645639] samsung_laptop: Backlight controlled by ACPI video driver
> [   24.669842] Bluetooth: Core ver 2.16
> [   24.669907] NET: Registered protocol family 31
> [   24.669909] Bluetooth: HCI device and connection manager initialized
> [   24.669928] Bluetooth: HCI socket layer initialized
> [   24.669940] Bluetooth: L2CAP socket layer initialized
> [   24.669964] Bluetooth: SCO socket layer initialized
> [   24.702662] cfg80211: Calling CRDA to update world regulatory domain
> [   24.783255] cfg80211: World regulatory domain updated:
> [   24.783261] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   24.783265] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   24.783268] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   24.783271] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   24.783274] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   24.783276] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   24.809598] ppdev: user-space parallel port driver
> [   24.833489] Linux video capture interface: v2.00
> [   24.908516] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   24.908521] Bluetooth: BNEP filters: protocol multicast
> [   24.908534] Bluetooth: BNEP socket layer initialized
> [   25.043177] Bluetooth: RFCOMM TTY layer initialized
> [   25.043201] Bluetooth: RFCOMM socket layer initialized
> [   25.043203] Bluetooth: RFCOMM ver 1.11
> [   25.055420] usbcore: registered new interface driver btusb
> [   25.377238] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x28
> [   25.486427] type=1400 audit(1366731387.498:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=763 comm="apparmor_parser"
> [   25.486617] type=1400 audit(1366731387.498:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=890 comm="apparmor_parser"
> [   25.487280] type=1400 audit(1366731387.498:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=763 comm="apparmor_parser"
> [   25.487470] type=1400 audit(1366731387.498:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=890 comm="apparmor_parser"
> [   25.487818] type=1400 audit(1366731387.498:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=763 comm="apparmor_parser"
> [   25.488008] type=1400 audit(1366731387.498:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=890 comm="apparmor_parser"
> [   25.498499] [drm] Initialized drm 1.1.0 20060810
> [   25.540775] init: failsafe main process (961) killed by TERM signal
> [   25.656384] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x28
> [   25.658617] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x28
> [   25.660690] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x28
> [   25.662863] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   25.678808] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f00)
> [   25.693830] psmouse serio1: elantech: Synaptics capabilities query result 0x08, 0x17, 0x0c.
> [   25.777052] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input5
> [   25.843516] type=1400 audit(1366731387.854:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1075 comm="apparmor_parser"
> [   25.844355] type=1400 audit(1366731387.854:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1075 comm="apparmor_parser"
> [   25.844840] type=1400 audit(1366731387.854:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1075 comm="apparmor_parser"
> [   25.917693] type=1400 audit(1366731387.930:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=948 comm="apparmor_parser"
> [   26.068418] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [   26.068424] Copyright(c) 2003-2013 Intel Corporation
> [   26.068893] iwlwifi 0000:01:00.0: irq 48 for MSI/MSI-X
> [   26.069627] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
> [   26.400116] uvcvideo: Found UVC 1.00 device WebCam SC-13HDL11431N (2232:1018)
> [   26.419814] input: WebCam SC-13HDL11431N as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input6
> [   26.420033] usbcore: registered new interface driver uvcvideo
> [   26.420037] USB Video Class driver (1.1.1)
> [   26.483578] [drm] Memory usable by graphics device = 2048M
> [   26.483590] i915 0000:00:02.0: setting latency timer to 64
> [   26.516959] i915 0000:00:02.0: irq 49 for MSI/MSI-X
> [   26.516983] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   26.516985] [drm] Driver supports precise vblank timestamp query.
> [   26.517139] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [   26.530390] [drm] Wrong MCH_SSKPD value: 0x16040307
> [   26.530395] [drm] This can cause pipe underruns and display issues.
> [   26.530397] [drm] Please upgrade your BIOS to fix this.
> [   26.536428] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   26.536434] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   26.536438] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
> [   26.536440] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
> [   26.536443] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
> [   26.536447] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
> [   26.536499] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   26.547253] fbcon: inteldrmfb (fb0) is primary device
> [   26.595109] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   26.620078] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   26.626780] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   27.001059] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   27.007663] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   27.205914] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   27.503959] Console: switching to colour frame buffer device 170x48
> [   27.506873] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [   27.506876] i915 0000:00:02.0: registered panic notifier
> [   27.530390] acpi device:33: registered as cooling_device9
> [   27.530878] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [   27.530990] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
> [   27.531168] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [   27.531528] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [   27.548114] init: alsa-restore main process (1173) terminated with status 19
> [   27.599986] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [   27.600344] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [   27.600607] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [   27.791749] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [   33.551845] wlan0: authenticate with 00:04:0e:e4:00:3d
> [   33.557000] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [   33.558829] wlan0: authenticated
> [   33.558984] iwlwifi 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
> [   33.558989] iwlwifi 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [   33.559460] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [   33.563351] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
> [   33.569179] wlan0: associated
> [   33.569249] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   87.927083] cpufreq_ondemand: od_init: tuners ffff880076822700
> [  104.870657] usb 2-1.5: USB disconnect, device number 3
> [  168.609260] ------------[ cut here ]------------
> [  168.609273] WARNING: at lib/debugobjects.c:260 debug_print_object+0x8e/0xb0()
> [  168.609277] ODEBUG: activate active (active state 1) object type: rcu_head hint:           (null)
> [  168.609280] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.609348] CPU: 1 PID: 9296 Comm: fixdep Not tainted 3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.609351] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.609354]  ffffffff81a4e2ea ffff8800211bfb28 ffffffff816c1956 ffff8800211bfb68
> [  168.609360]  ffffffff81059680 ffff88002e068780 ffffffff81a281e9 ffff880022be7468
> [  168.609365]  ffffffff81c43280 0000000000000292 ffffffff82010040 ffff8800211bfbc8
> [  168.609371] Call Trace:
> [  168.609379]  [<ffffffff816c1956>] dump_stack+0x19/0x1b
> [  168.609384]  [<ffffffff81059680>] warn_slowpath_common+0x70/0xa0
> [  168.609389]  [<ffffffff81059766>] warn_slowpath_fmt+0x46/0x50
> [  168.609394]  [<ffffffff8134e12e>] ? radix_tree_lookup_slot+0xe/0x10
> [  168.609399]  [<ffffffff8135e50e>] debug_print_object+0x8e/0xb0
> [  168.609404]  [<ffffffff8135eb23>] debug_object_activate+0xf3/0x170
> [  168.609410]  [<ffffffff810f1de6>] __call_rcu.constprop.54+0x46/0x250
> [  168.609415]  [<ffffffff810f204a>] kfree_call_rcu+0x1a/0x20
> [  168.609421]  [<ffffffff812bb064>] ipc_rcu_putref+0x34/0x60
> [  168.609425]  [<ffffffff812bec33>] SYSC_semtimedop+0xb23/0xc90
> [  168.609433]  [<ffffffff81159d21>] ? handle_mm_fault+0x251/0x360
> [  168.609439]  [<ffffffff816cc698>] ? __do_page_fault+0x2a8/0x560
> [  168.609445]  [<ffffffff812d2289>] ? security_ipc_permission+0x19/0x20
> [  168.609450]  [<ffffffff812bb13c>] ? ipcperms+0xac/0x130
> [  168.609455]  [<ffffffff8135deed>] ? do_raw_spin_unlock+0x5d/0xb0
> [  168.609460]  [<ffffffff816c851e>] ? _raw_spin_unlock+0xe/0x10
> [  168.609465]  [<ffffffff812bb4e3>] ? ipcget+0x113/0x1b0
> [  168.609469]  [<ffffffff8119a4e5>] ? SYSC_newfstat+0x25/0x30
> [  168.609474]  [<ffffffff812bfa4e>] SyS_semtimedop+0xe/0x10
> [  168.609478]  [<ffffffff812bfa60>] SyS_semop+0x10/0x20
> [  168.609482]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  168.609486] ---[ end trace 3e44636bb23b7e4c ]---
> [  168.609488] ------------[ cut here ]------------
> [  168.609492] WARNING: at kernel/rcupdate.c:309 rcuhead_fixup_activate+0x5a/0x70()
> [  168.609494] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.609550] CPU: 1 PID: 9296 Comm: fixdep Tainted: G        W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.609553] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.609555]  ffffffff81a22269 ffff8800211bfb98 ffffffff816c1956 ffff8800211bfbd8
> [  168.609559]  ffffffff81059680 ffff8800211bfbe8 ffff8800910262c0 ffffffff81c43280
> [  168.609564]  ffffffff82010048 0000000000000292 0000000000000003 ffff8800211bfbe8
> [  168.609569] Call Trace:
> [  168.609574]  [<ffffffff816c1956>] dump_stack+0x19/0x1b
> [  168.609578]  [<ffffffff81059680>] warn_slowpath_common+0x70/0xa0
> [  168.609582]  [<ffffffff810596ca>] warn_slowpath_null+0x1a/0x20
> [  168.609586]  [<ffffffff8107c43a>] rcuhead_fixup_activate+0x5a/0x70
> [  168.609592]  [<ffffffff8135eb4a>] debug_object_activate+0x11a/0x170
> [  168.609597]  [<ffffffff810f1de6>] __call_rcu.constprop.54+0x46/0x250
> [  168.609602]  [<ffffffff810f204a>] kfree_call_rcu+0x1a/0x20
> [  168.609607]  [<ffffffff812bb064>] ipc_rcu_putref+0x34/0x60
> [  168.609611]  [<ffffffff812bec33>] SYSC_semtimedop+0xb23/0xc90
> [  168.609616]  [<ffffffff81159d21>] ? handle_mm_fault+0x251/0x360
> [  168.609621]  [<ffffffff816cc698>] ? __do_page_fault+0x2a8/0x560
> [  168.609627]  [<ffffffff812d2289>] ? security_ipc_permission+0x19/0x20
> [  168.609632]  [<ffffffff812bb13c>] ? ipcperms+0xac/0x130
> [  168.609637]  [<ffffffff8135deed>] ? do_raw_spin_unlock+0x5d/0xb0
> [  168.609641]  [<ffffffff816c851e>] ? _raw_spin_unlock+0xe/0x10
> [  168.609645]  [<ffffffff812bb4e3>] ? ipcget+0x113/0x1b0
> [  168.609649]  [<ffffffff8119a4e5>] ? SYSC_newfstat+0x25/0x30
> [  168.609654]  [<ffffffff812bfa4e>] SyS_semtimedop+0xe/0x10
> [  168.609658]  [<ffffffff812bfa60>] SyS_semop+0x10/0x20
> [  168.609662]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  168.609665] ---[ end trace 3e44636bb23b7e4d ]---
> [  168.609667] ------------[ cut here ]------------
> [  168.609672] WARNING: at lib/debugobjects.c:260 debug_print_object+0x8e/0xb0()
> [  168.609675] ODEBUG: active_state active (active state 1) object type: rcu_head hint:           (null)
> [  168.609677] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.609731] CPU: 1 PID: 9296 Comm: fixdep Tainted: G        W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.609734] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.609736]  ffffffff81a4e2ea ffff8800211bfb28 ffffffff816c1956 ffff8800211bfb68
> [  168.609741]  ffffffff81059680 ffffffff81a07a62 ffffffff81a4e317 ffff880022be7468
> [  168.609746]  ffffffff81c43280 ffffffff82010048 0000000000000001 ffff8800211bfbc8
> [  168.609752] Call Trace:
> [  168.609756]  [<ffffffff816c1956>] dump_stack+0x19/0x1b
> [  168.609761]  [<ffffffff81059680>] warn_slowpath_common+0x70/0xa0
> [  168.609765]  [<ffffffff81059766>] warn_slowpath_fmt+0x46/0x50
> [  168.609769]  [<ffffffff8105968e>] ? warn_slowpath_common+0x7e/0xa0
> [  168.609774]  [<ffffffff8135e50e>] debug_print_object+0x8e/0xb0
> [  168.609779]  [<ffffffff8135f052>] debug_object_active_state+0x92/0xf0
> [  168.609785]  [<ffffffff810f1dfc>] __call_rcu.constprop.54+0x5c/0x250
> [  168.609790]  [<ffffffff810f204a>] kfree_call_rcu+0x1a/0x20
> [  168.609794]  [<ffffffff812bb064>] ipc_rcu_putref+0x34/0x60
> [  168.609798]  [<ffffffff812bec33>] SYSC_semtimedop+0xb23/0xc90
> [  168.609804]  [<ffffffff81159d21>] ? handle_mm_fault+0x251/0x360
> [  168.609809]  [<ffffffff816cc698>] ? __do_page_fault+0x2a8/0x560
> [  168.609814]  [<ffffffff812d2289>] ? security_ipc_permission+0x19/0x20
> [  168.609819]  [<ffffffff812bb13c>] ? ipcperms+0xac/0x130
> [  168.609824]  [<ffffffff8135deed>] ? do_raw_spin_unlock+0x5d/0xb0
> [  168.609828]  [<ffffffff816c851e>] ? _raw_spin_unlock+0xe/0x10
> [  168.609832]  [<ffffffff812bb4e3>] ? ipcget+0x113/0x1b0
> [  168.609837]  [<ffffffff8119a4e5>] ? SYSC_newfstat+0x25/0x30
> [  168.609841]  [<ffffffff812bfa4e>] SyS_semtimedop+0xe/0x10
> [  168.609845]  [<ffffffff812bfa60>] SyS_semop+0x10/0x20
> [  168.609849]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  168.609852] ---[ end trace 3e44636bb23b7e4e ]---
> [  168.633393] BUG: unable to handle kernel paging request at ffffffffffffffd9
> [  168.633460] IP: [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.633512] PGD 1c10067 PUD 1c12067 PMD 0 
> [  168.634686] Oops: 0000 [#1] SMP 
> [  168.635820] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.641607] CPU: 2 PID: 9296 Comm: fixdep Tainted: G        W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.643137] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.644671] task: ffff88002e068780 ti: ffff8800211be000 task.ti: ffff8800211be000
> [  168.646239] RIP: 0010:[<ffffffff8135dd47>]  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.647879] RSP: 0018:ffff8800211bfde8  EFLAGS: 00010286
> [  168.649549] RAX: ffffffffffffffd5 RBX: ffffffffffffffd5 RCX: 00000000ffffffff
> [  168.651224] RDX: ffffffffffffffd5 RSI: 0000000000000004 RDI: ffffffffffffffd5
> [  168.652868] RBP: ffff8800211bfe18 R08: ffff88002edaa630 R09: 0000000000000000
> [  168.654540] R10: 0000000000000001 R11: 0000000000000024 R12: ffffffffffffffd5
> [  168.656217] R13: ffff88002e068780 R14: ffff8800729a1720 R15: ffff8800729a1700
> [  168.657935] FS:  0000000000000000(0000) GS:ffff88011fa80000(0000) knlGS:0000000000000000
> [  168.659683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  168.661387] CR2: ffffffffffffffd9 CR3: 0000000001c0d000 CR4: 00000000000407e0
> [  168.663105] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  168.664850] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  168.666545] Stack:
> [  168.668256]  ffff88002ed1e1f8 ffff88002ef1acb8 ffff880092e14800 ffff88002e068780
> [  168.670029]  ffffffffffffffd5 ffff88002e068780 ffff8800211bfe28 ffffffff816c855e
> [  168.671775]  ffff8800211bfea8 ffffffff812bfbfa ffff88002e068780 ffff880092e14800
> [  168.673536] Call Trace:
> [  168.675324]  [<ffffffff816c855e>] _raw_spin_lock+0xe/0x10
> [  168.677154]  [<ffffffff812bfbfa>] exit_sem+0xaa/0x350
> [  168.678986]  [<ffffffff8105f2e0>] do_exit+0x290/0xa70
> [  168.680817]  [<ffffffff811971a1>] ? __sb_end_write+0x41/0x80
> [  168.682644]  [<ffffffff8105fb54>] do_group_exit+0x44/0xa0
> [  168.684537]  [<ffffffff8105fbc7>] SyS_exit_group+0x17/0x20
> [  168.686433]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  168.688188] Code: 89 47 08 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 75 58 65 48 8b 04 25 80 c7 00 00 48 39 43 
> [  168.692194] RIP  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.694159]  RSP <ffff8800211bfde8>
> [  168.696116] CR2: ffffffffffffffd9
> [  168.707087] ---[ end trace 3e44636bb23b7e4f ]---
> [  168.707093] BUG: unable to handle kernel paging request at ffffffffffffffd9
> [  168.707100] IP: [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.707102] PGD 1c10067 PUD 1c12067 PMD 0 
> [  168.707104] Oops: 0000 [#2] SMP 
> [  168.707130] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.707133] CPU: 0 PID: 9248 Comm: cc1 Tainted: G      D W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.707134] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.707135] task: ffff880034856040 ti: ffff8800222e2000 task.ti: ffff8800222e2000
> [  168.707138] RIP: 0010:[<ffffffff8135dd47>]  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.707139] RSP: 0018:ffff8800222e3de8  EFLAGS: 00010286
> [  168.707140] RAX: ffffffffffffffd5 RBX: ffffffffffffffd5 RCX: 0000000000000000
> [  168.707141] RDX: ffffffffffffffd5 RSI: 0000000000000004 RDI: ffffffffffffffd5
> [  168.707141] RBP: ffff8800222e3e18 R08: 0000000000000004 R09: 0000000000000000
> [  168.707142] R10: 0000000000000001 R11: ffff88002e046d80 R12: ffffffffffffffd5
> [  168.707143] R13: ffff880034856040 R14: ffff88009102fae0 R15: ffff88009102fac0
> [  168.707144] FS:  00002aaaaaae9f00(0000) GS:ffff88011fa00000(0000) knlGS:0000000000000000
> [  168.707145] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  168.707146] CR2: ffffffffffffffd9 CR3: 000000008b61f000 CR4: 00000000000407f0
> [  168.707146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  168.707147] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  168.707147] Stack:
> [  168.707150]  ffff8800953a8400 0000000000000282 ffff88011f02c200 ffff880034856040
> [  168.707152]  ffffffffffffffd5 ffff880034856040 ffff8800222e3e28 ffffffff816c855e
> [  168.707153]  ffff8800222e3ea8 ffffffff812bfbfa ffff880034856040 0000000000000003
> [  168.707154] Call Trace:
> [  168.707158]  [<ffffffff816c855e>] _raw_spin_lock+0xe/0x10
> [  168.707160]  [<ffffffff812bfbfa>] exit_sem+0xaa/0x350
> [  168.707164]  [<ffffffff8105f2e0>] do_exit+0x290/0xa70
> [  168.707167]  [<ffffffff8115f080>] ? do_munmap+0x270/0x3e0
> [  168.707169]  [<ffffffff8105fb54>] do_group_exit+0x44/0xa0
> [  168.707171]  [<ffffffff8105fbc7>] SyS_exit_group+0x17/0x20
> [  168.707173]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  168.707189] Code: 89 47 08 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 75 58 65 48 8b 04 25 80 c7 00 00 48 39 43 
> [  168.707191] RIP  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.707192]  RSP <ffff8800222e3de8>
> [  168.707192] CR2: ffffffffffffffd9
> [  168.707194] ---[ end trace 3e44636bb23b7e50 ]---
> [  168.707195] Fixing recursive fault but reboot is needed!
> [  168.707313] Fixing recursive fault but reboot is needed!
> [  168.707904] BUG: unable to handle kernel paging request at ffffffffffffffd9
> [  168.709687] IP: [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.711395] PGD 1c10067 PUD 1c12067 PMD 0 
> [  168.713235] Oops: 0000 [#3] SMP 
> [  168.715004] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.722955] CPU: 2 PID: 9294 Comm: cc1 Tainted: G      D W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.724981] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.727053] task: ffff88002e334140 ti: ffff8800210c4000 task.ti: ffff8800210c4000
> [  168.729107] RIP: 0010:[<ffffffff8135dd47>]  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.731124] RSP: 0018:ffff8800210c5de8  EFLAGS: 00010286
> [  168.733115] RAX: ffffffffffffffd5 RBX: ffffffffffffffd5 RCX: 00000000ffffffff
> [  168.735057] RDX: ffffffffffffffd5 RSI: 0000000000000004 RDI: ffffffffffffffd5
> [  168.736981] RBP: ffff8800210c5e18 R08: ffff88002ef5a150 R09: 0000000000000000
> [  168.738840] R10: 0000000000000001 R11: ffff88002ed528a0 R12: ffffffffffffffd5
> [  168.740676] R13: ffff88002e334140 R14: ffff8800586b0720 R15: ffff8800586b0700
> [  168.742477] FS:  00002aaaaaae9f00(0000) GS:ffff88011fa80000(0000) knlGS:0000000000000000
> [  168.744309] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  168.746092] CR2: ffffffffffffffd9 CR3: 0000000001c0d000 CR4: 00000000000407e0
> [  168.747941] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  168.749751] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  168.751506] Stack:
> [  168.753334]  ffff880092e2fb78 ffff88002ee0a228 ffff88009518ac00 ffff88002e334140
> [  168.755152]  ffffffffffffffd5 ffff88002e334140 ffff8800210c5e28 ffffffff816c855e
> [  168.756996]  ffff8800210c5ea8 ffffffff812bfbfa ffff88002e334140 ffff88009518ac00
> [  168.758819] Call Trace:
> [  168.760642]  [<ffffffff816c855e>] _raw_spin_lock+0xe/0x10
> [  168.762506]  [<ffffffff812bfbfa>] exit_sem+0xaa/0x350
> [  168.764320]  [<ffffffff8105f2e0>] do_exit+0x290/0xa70
> [  168.766106]  [<ffffffff8105fb54>] do_group_exit+0x44/0xa0
> [  168.767900]  [<ffffffff8105fbc7>] SyS_exit_group+0x17/0x20
> [  168.769647]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  168.771378] Code: 89 47 08 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 75 58 65 48 8b 04 25 80 c7 00 00 48 39 43 
> [  168.775168] RIP  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  168.777073]  RSP <ffff8800210c5de8>
> [  168.778915] CR2: ffffffffffffffd9
> [  168.780802] ---[ end trace 3e44636bb23b7e51 ]---
> [  168.780806] Fixing recursive fault but reboot is needed!
> [  168.784390] ------------[ cut here ]------------
> [  168.784401] WARNING: at kernel/rcutree.c:2105 rcu_process_callbacks+0x54d/0x5b0()
> [  168.784403] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  168.784450] CPU: 1 PID: 13 Comm: ksoftirqd/1 Tainted: G      D W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  168.784452] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  168.784454]  ffffffff81a26d50 ffff880119fc1ce8 ffffffff816c1956 ffff880119fc1d28
> [  168.784458]  ffffffff81059680 0000000000000000 0000000000000246 0000000000000000
> [  168.784461]  ffff88011fa4ea00 0000000000000009 ffffffff81c50fc0 ffff880119fc1d38
> [  168.784465] Call Trace:
> [  168.784470]  [<ffffffff816c1956>] dump_stack+0x19/0x1b
> [  168.784474]  [<ffffffff81059680>] warn_slowpath_common+0x70/0xa0
> [  168.784477]  [<ffffffff810596ca>] warn_slowpath_null+0x1a/0x20
> [  168.784480]  [<ffffffff810f261d>] rcu_process_callbacks+0x54d/0x5b0
> [  168.784484]  [<ffffffff81061db8>] __do_softirq+0xd8/0x270
> [  168.784488]  [<ffffffff81061f88>] run_ksoftirqd+0x38/0x50
> [  168.784491]  [<ffffffff8108706d>] smpboot_thread_fn+0xfd/0x180
> [  168.784494]  [<ffffffff81086f70>] ? lg_global_lock+0x70/0x70
> [  168.784498]  [<ffffffff8107fa98>] kthread+0xd8/0xe0
> [  168.784501]  [<ffffffff8107f9c0>] ? flush_kthread_worker+0xe0/0xe0
> [  168.784505]  [<ffffffff816d0fec>] ret_from_fork+0x7c/0xb0
> [  168.784508]  [<ffffffff8107f9c0>] ? flush_kthread_worker+0xe0/0xe0
> [  168.784510] ---[ end trace 3e44636bb23b7e52 ]---
> [  169.463187] BUG: unable to handle kernel paging request at ffffffffffffffd9
> [  169.464802] IP: [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  169.466496] PGD 1c10067 PUD 1c12067 PMD 0 
> [  169.467988] Oops: 0000 [#4] SMP 
> [  169.469393] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4 snd_hda_intel iwldvm snd_hda_codec ghash_clmulni_intel snd_hwdep aesni_intel i915 mac80211 aes_x86_64 glue_helper snd_pcm lrw gf128mul snd_page_alloc uvcvideo ablk_helper cryptd snd_seq_midi snd_seq_midi_event iwlwifi snd_rawmidi i2c_algo_bit joydev videobuf2_vmalloc drm_kms_helper snd_seq videobuf2_memops drm snd_timer videobuf2_core microcode parport_pc snd_seq_device btusb rfcomm bnep videodev ppdev psmouse cfg80211 bluetooth snd samsung_laptop wmi soundcore lp serio_raw video mac_hid lpc_ich parport hid_generic usbhid hid r8169
> [  169.475100] CPU: 3 PID: 9211 Comm: cc1 Tainted: G      D W    3.9.0-rc8-next20130423-1-iniza-small #1
> [  169.476521] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [  169.477936] task: ffff8800348d0240 ti: ffff880022258000 task.ti: ffff880022258000
> [  169.479390] RIP: 0010:[<ffffffff8135dd47>]  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  169.480834] RSP: 0018:ffff880022259de8  EFLAGS: 00010286
> [  169.482241] RAX: ffffffffffffffd5 RBX: ffffffffffffffd5 RCX: 00000000ffffffff
> [  169.483652] RDX: ffffffffffffffd5 RSI: 0000000000000004 RDI: ffffffffffffffd5
> [  169.485004] RBP: ffff880022259e18 R08: ffff88002ed52b10 R09: ffff88006b7f6cb0
> [  169.486320] R10: 0000000000000001 R11: ffff88006f5042f0 R12: ffffffffffffffd5
> [  169.487639] R13: ffff8800348d0240 R14: ffff8800586b03a0 R15: ffff8800586b0380
> [  169.488910] FS:  0000000000000000(0000) GS:ffff88011fac0000(0000) knlGS:0000000000000000
> [  169.490179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  169.491490] CR2: ffffffffffffffd9 CR3: 0000000001c0d000 CR4: 00000000000407e0
> [  169.492773] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  169.494029] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  169.495304] Stack:
> [  169.496542]  ffff88008d365238 ffff88005f9ed228 ffff88002e245480 ffff8800348d0240
> [  169.497816]  ffffffffffffffd5 ffff8800348d0240 ffff880022259e28 ffffffff816c855e
> [  169.499100]  ffff880022259ea8 ffffffff812bfbfa ffff8800348d0240 ffff88002e245480
> [  169.500389] Call Trace:
> [  169.501646]  [<ffffffff816c855e>] _raw_spin_lock+0xe/0x10
> [  169.502902]  [<ffffffff812bfbfa>] exit_sem+0xaa/0x350
> [  169.504159]  [<ffffffff8105f2e0>] do_exit+0x290/0xa70
> [  169.505394]  [<ffffffff8115f080>] ? do_munmap+0x270/0x3e0
> [  169.506621]  [<ffffffff8105fb54>] do_group_exit+0x44/0xa0
> [  169.507935]  [<ffffffff8105fbc7>] SyS_exit_group+0x17/0x20
> [  169.509275]  [<ffffffff816d109d>] system_call_fastpath+0x1a/0x1f
> [  169.510654] Code: 89 47 08 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 75 58 65 48 8b 04 25 80 c7 00 00 48 39 43 
> [  169.513601] RIP  [<ffffffff8135dd47>] do_raw_spin_lock+0x17/0x120
> [  169.514951]  RSP <ffff880022259de8>
> [  169.516290] CR2: ffffffffffffffd9
> [  169.517638] ---[ end trace 3e44636bb23b7e53 ]---
> [  169.517639] Fixing recursive fault but reboot is needed!


