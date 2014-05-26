Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaEZJiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:38:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:60234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaEZJiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:38:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,911,1392192000"; 
   d="scan'208";a="517754973"
Date: Mon, 26 May 2014 12:37:41 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
  [systemd-udevd:1667]
Message-ID: <20140526093741.GA1765@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After v3.15-rc4 my Fedora 20 system with mainline kernel has been suffering
from the above lockup.

This is easy to reproduce:

 1) Plug in USB memory stick (to xHCI port)
 2) Unplug it

Typically only one iteration is needed and suddenly I can see
systemd-udev taking 100% CPU and eventually the whole system becomes
unusable.

I've tried to investigate and it looks like we just spin in
shrink_dentry_list() forever. Reverting following fs/dcache.c commits
the issue goes away:

60942f2f235ce7b817166cdf355eed729094834d dcache: don't need rcu in shrink_dentry_list()
9c8c10e262e0f62cb2530f1b076de979123183dd more graceful recovery in umount_collect()
fe91522a7ba82ca1a51b07e19954b3825e4aaa22 don't remove from shrink list in select_collect()

(The first two commits themselves don't seem to be related but reverting
them is needed so that the last one can be cleanly reverted).

dmesg from the system looks like below. Please let me know if I can
provide any additional info.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc7 (westeri@lahna) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #52 SMP Mon May 26 11:59:05 EEST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc7 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb LANG=en_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005573efff] usable
[    0.000000] BIOS-e820: [mem 0x000000005573f000-0x0000000055745fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000055746000-0x00000000567affff] usable
[    0.000000] BIOS-e820: [mem 0x00000000567b0000-0x0000000056d35fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000056d36000-0x0000000069b32fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000069b33000-0x0000000069d46fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000069d47000-0x0000000069d87fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000069d88000-0x0000000069e49fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000069e4a000-0x000000006affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006afff000-0x000000006affffff] usable
[    0.000000] BIOS-e820: [mem 0x000000006b800000-0x000000006f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000048f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x48f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7C00000000 write-back
[    0.000000]   1 base 0400000000 mask 7F80000000 write-back
[    0.000000]   2 base 0480000000 mask 7FF0000000 write-back
[    0.000000]   3 base 0080000000 mask 7F80000000 uncachable
[    0.000000]   4 base 0070000000 mask 7FF0000000 uncachable
[    0.000000]   5 base 006C000000 mask 7FFC000000 uncachable
[    0.000000]   6 base 006B800000 mask 7FFF800000 uncachable
[    0.000000]   7 base 048F800000 mask 7FFF800000 uncachable
[    0.000000]   8 base 048F600000 mask 7FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x6b800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x6b000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd780-0x000fd78f] mapped at [ffff8800000fd780]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ffd000, 0x01ffdfff] PGTABLE
[    0.000000] BRK [0x01ffe000, 0x01ffefff] PGTABLE
[    0.000000] BRK [0x01fff000, 0x01ffffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x48f400000-0x48f5fffff]
[    0.000000]  [mem 0x48f400000-0x48f5fffff] page 2M
[    0.000000] BRK [0x02000000, 0x02000fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x48c000000-0x48f3fffff]
[    0.000000]  [mem 0x48c000000-0x48f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x480000000-0x48bffffff]
[    0.000000]  [mem 0x480000000-0x48bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x5573efff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x555fffff] page 2M
[    0.000000]  [mem 0x55600000-0x5573efff] page 4k
[    0.000000] init_memory_mapping: [mem 0x55746000-0x567affff]
[    0.000000]  [mem 0x55746000-0x557fffff] page 4k
[    0.000000]  [mem 0x55800000-0x565fffff] page 2M
[    0.000000]  [mem 0x56600000-0x567affff] page 4k
[    0.000000] BRK [0x02001000, 0x02001fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x56d36000-0x69b32fff]
[    0.000000]  [mem 0x56d36000-0x56dfffff] page 4k
[    0.000000]  [mem 0x56e00000-0x699fffff] page 2M
[    0.000000]  [mem 0x69a00000-0x69b32fff] page 4k
[    0.000000] BRK [0x02002000, 0x02002fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x69d47000-0x69d87fff]
[    0.000000]  [mem 0x69d47000-0x69d87fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x6afff000-0x6affffff]
[    0.000000]  [mem 0x6afff000-0x6affffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x47fffffff]
[    0.000000]  [mem 0x100000000-0x47fffffff] page 1G
[    0.000000] RAMDISK: [mem 0x343b0000-0x361cffff]
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x0000000069E1F080 00007C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000069E2B6A8 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x0000000069E1F190 00C518 (v02 ALASKA A M I    00000088 INTL 20091112)
[    0.000000] ACPI: FACS 0x0000000069E48080 000040
[    0.000000] ACPI: APIC 0x0000000069E2B7B8 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000069E2B850 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x0000000069E2B898 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x0000000069E2BDD8 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x0000000069E2C8B0 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x0000000069E2C8F0 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000069E2C928 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x0000000069E2CC98 003299 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
[    0.000000] ACPI: DMAR 0x0000000069E2FF38 000090 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: MATS 0x0000000069E2FFC8 000034 (v02 ALASKA A M I    00000002 w?x2 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000048f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x48f5fffff]
[    0.000000]   NODE_DATA [mem 0x48f5e7000-0x48f5fafff]
[    0.000000]  [ffffea0000000000-ffffea00123fffff] PMD -> [ffff88047ec00000-ffff88048ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x48f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x5573efff]
[    0.000000]   node   0: [mem 0x55746000-0x567affff]
[    0.000000]   node   0: [mem 0x56d36000-0x69b32fff]
[    0.000000]   node   0: [mem 0x69d47000-0x69d87fff]
[    0.000000]   node   0: [mem 0x6afff000-0x6affffff]
[    0.000000]   node   0: [mem 0x100000000-0x48f5fffff]
[    0.000000] On node 0 totalpages: 4164484
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6680 pages used for memmap
[    0.000000]   DMA32 zone: 427496 pages, LIFO batch:31
[    0.000000]   Normal zone: 58328 pages used for memmap
[    0.000000]   Normal zone: 3732992 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0x6ba00000-0x6f9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x5573f000-0x55745fff]
[    0.000000] PM: Registered nosave memory: [mem 0x567b0000-0x56d35fff]
[    0.000000] PM: Registered nosave memory: [mem 0x69b33000-0x69d46fff]
[    0.000000] PM: Registered nosave memory: [mem 0x69d88000-0x69e49fff]
[    0.000000] PM: Registered nosave memory: [mem 0x69e4a000-0x6affefff]
[    0.000000] PM: Registered nosave memory: [mem 0x6b000000-0x6b7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6b800000-0x6f9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6fa00000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x6fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88048f200000 s86848 r8192 d23744 u262144
[    0.000000] pcpu-alloc: s86848 r8192 d23744 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4099391
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc7 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at drivers/iommu/dmar.c:761 warn_invalid_dmar+0x81/0x93()
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
BIOS vendor: American Megatrends Inc.; Ver: F4; Product Version: To be filled by O.E.M.
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc7 #52
[    0.000000] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[    0.000000]  000000000000000b ffffffff81c01e08 ffffffff8169ea22 ffffffff81c01e50
[    0.000000]  ffffffff81c01e40 ffffffff8108413d ffffffff81ffc01c ffffffff81ffc058
[    0.000000]  0000000000000000 ffffffff81dc92c0 ffffffff81c01fb0 ffffffff81c01ea0
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8169ea22>] dump_stack+0x45/0x56
[    0.000000]  [<ffffffff8108413d>] warn_slowpath_common+0x7d/0xa0
[    0.000000]  [<ffffffff810841f4>] warn_slowpath_fmt_taint+0x44/0x50
[    0.000000]  [<ffffffff813c3505>] ? acpi_tb_verify_checksum+0x24/0x5b
[    0.000000]  [<ffffffff816a06a8>] warn_invalid_dmar+0x81/0x93
[    0.000000]  [<ffffffff81d7385e>] detect_intel_iommu+0x7f/0x172
[    0.000000]  [<ffffffff81d2b265>] pci_iommu_alloc+0x4a/0x6c
[    0.000000]  [<ffffffff81d3a05e>] mem_init+0xf/0x8d
[    0.000000]  [<ffffffff81d21d00>] start_kernel+0x1cd/0x405
[    0.000000]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[    0.000000]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[    0.000000] ---[ end trace b920f43b25376825 ]---
[    0.000000] Memory: 16281128K/16657936K available (6856K kernel code, 1060K rwdata, 3008K rodata, 1412K init, 1572K bss, 376808K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3492.173 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using timer frequency.. 6984.34 BogoMIPS (lpj=3492173)
[    0.000139] pid_max: default: 32768 minimum: 301
[    0.000203] ACPI: Core revision 20140214
[    0.006698] ACPI: All ACPI Tables successfully acquired
[    0.016243] Security Framework initialized
[    0.016306] SELinux:  Initializing.
[    0.016366] SELinux:  Starting in permissive mode
[    0.017109] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.019219] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.020139] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020655] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020906] Initializing cgroup subsys memory
[    0.020967] Initializing cgroup subsys devices
[    0.021026] Initializing cgroup subsys freezer
[    0.021084] Initializing cgroup subsys net_cls
[    0.021143] Initializing cgroup subsys blkio
[    0.021201] Initializing cgroup subsys perf_event
[    0.021260] Initializing cgroup subsys hugetlb
[    0.021332] CPU: Physical Processor ID: 0
[    0.021389] CPU: Processor Core ID: 0
[    0.022156] mce: CPU supports 9 MCE banks
[    0.022222] CPU0: Thermal monitoring enabled (TM1)
[    0.022289] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
tlb_flushall_shift: 6
[    0.022491] Freeing SMP alternatives memory: 24K (ffffffff81e6c000 - ffffffff81e72000)
[    0.023214] ftrace: allocating 26174 entries in 103 pages
[    0.030327] dmar: Host address width 39
[    0.030408] dmar: DRHD base: 0x00000000000000 flags: 0x1
[    0.030492] dmar: parse DMAR table failure.
[    0.030942] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041019] smpboot: CPU0: Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz (fam: 06, model: 3c, stepping: 03)
[    0.041238] TSC deadline timer enabled
[    0.041243] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.041517] ... version:                3
[    0.041598] ... bit width:              48
[    0.041678] ... generic registers:      4
[    0.041759] ... value mask:             0000ffffffffffff
[    0.041841] ... max period:             0000ffffffffffff
[    0.041923] ... fixed-purpose events:   3
[    0.042004] ... event mask:             000000070000000f
[    0.042828] x86: Booting SMP configuration:
[    0.042909] .... node  #0, CPUs:      #1
[    0.056852] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.057102]  #2 #3 #4 #5 #6 #7
[    0.140476] x86: Booted up 1 node, 8 CPUs
[    0.140633] smpboot: Total of 8 processors activated (55874.76 BogoMIPS)
[    0.146829] devtmpfs: initialized
[    0.148701] PM: Registering ACPI NVS region [mem 0x5573f000-0x55745fff] (28672 bytes)
[    0.148836] PM: Registering ACPI NVS region [mem 0x69d88000-0x69e49fff] (794624 bytes)
[    0.149423] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.149509] pinctrl core: initialized pinctrl subsystem
[    0.149617] RTC time:  9:01:07, date: 05/26/14
[    0.149722] NET: Registered protocol family 16
[    0.149853] cpuidle: using governor menu
[    0.149952] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.150085] ACPI: bus type PCI registered
[    0.150166] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150281] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.150417] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.165991] PCI: Using configuration type 1 for base access
[    0.166992] ACPI: Added _OSI(Module Device)
[    0.167074] ACPI: Added _OSI(Processor Device)
[    0.167155] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.167237] ACPI: Added _OSI(Processor Aggregator Device)
[    0.169616] ACPI: Executed 1 blocks of module-level executable AML code
[    0.171174] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.195810] ACPI: SSDT 0x0000000069D3CC18 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.196261] ACPI: Dynamic OEM Table Load:
[    0.196396] ACPI: SSDT 0x0000000000000000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.200891] ACPI: SSDT 0x0000000069D3C618 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.201440] ACPI: Dynamic OEM Table Load:
[    0.201574] ACPI: SSDT 0x0000000000000000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.205823] ACPI: SSDT 0x0000000069D3BD98 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.206276] ACPI: Dynamic OEM Table Load:
[    0.206410] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.211480] ACPI: Interpreter enabled
[    0.211563] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.211755] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.211955] ACPI: (supports S0 S3 S4 S5)
[    0.212035] ACPI: Using IOAPIC for interrupt routing
[    0.212132] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.216808] ACPI: Power Resource [FN00] (off)
[    0.216930] ACPI: Power Resource [FN01] (off)
[    0.217048] ACPI: Power Resource [FN02] (off)
[    0.217165] ACPI: Power Resource [FN03] (off)
[    0.217281] ACPI: Power Resource [FN04] (off)
[    0.217771] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.217858] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.218112] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.218310] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.218698] PCI host bridge to bus 0000:00
[    0.218780] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.218863] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.218948] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.219034] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.219120] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.219205] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.219290] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.219376] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.219461] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.219547] pci_bus 0000:00: root bus resource [mem 0x6fa00000-0xfeafffff]
[    0.219636] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.219687] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.219709] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.219737] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.219845] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    0.219852] pci 0000:00:02.0: reg 0x10: [mem 0xde400000-0xde7fffff 64bit]
[    0.219856] pci 0000:00:02.0: reg 0x18: [mem 0x70000000-0x7fffffff 64bit pref]
[    0.219859] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.219905] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.219909] pci 0000:00:03.0: reg 0x10: [mem 0xdef34000-0xdef37fff 64bit]
[    0.219973] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.219987] pci 0000:00:14.0: reg 0x10: [mem 0xdef20000-0xdef2ffff 64bit]
[    0.220037] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.220060] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.220166] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.220181] pci 0000:00:16.0: reg 0x10: [mem 0xdef3f000-0xdef3f00f 64bit]
[    0.220232] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.220281] pci 0000:00:19.0: [8086:153b] type 00 class 0x020000
[    0.220294] pci 0000:00:19.0: reg 0x10: [mem 0xdef00000-0xdef1ffff]
[    0.220300] pci 0000:00:19.0: reg 0x14: [mem 0xdef3d000-0xdef3dfff]
[    0.220306] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.220354] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.220377] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.220483] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.220500] pci 0000:00:1a.0: reg 0x10: [mem 0xdef3c000-0xdef3c3ff]
[    0.220573] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.220604] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.220710] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.220721] pci 0000:00:1b.0: reg 0x10: [mem 0xdef30000-0xdef33fff 64bit]
[    0.220776] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.220800] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.220903] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.220963] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.220989] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.221096] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[    0.221149] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.221173] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.221276] pci 0000:00:1c.6: [8086:8c1c] type 01 class 0x060400
[    0.221329] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.221354] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.221462] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.221478] pci 0000:00:1d.0: reg 0x10: [mem 0xdef3b000-0xdef3b3ff]
[    0.221551] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.221582] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.221689] pci 0000:00:1f.0: [8086:8c44] type 00 class 0x060100
[    0.221815] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.221826] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.221832] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.221837] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.221842] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.221848] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.221853] pci 0000:00:1f.2: reg 0x24: [mem 0xdef3a000-0xdef3a7ff]
[    0.221882] pci 0000:00:1f.2: PME# supported from D3hot
[    0.221919] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.221930] pci 0000:00:1f.3: reg 0x10: [mem 0xdef39000-0xdef390ff 64bit]
[    0.221946] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.222020] pci 0000:01:00.0: [10b5:8747] type 01 class 0x060400
[    0.222027] pci 0000:01:00.0: reg 0x10: [mem 0xdee00000-0xdee3ffff]
[    0.222072] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.222087] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.224107] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.224191] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.224231] pci 0000:02:08.0: [10b5:8747] type 01 class 0x060400
[    0.224282] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    0.224316] pci 0000:02:10.0: [10b5:8747] type 01 class 0x060400
[    0.224366] pci 0000:02:10.0: PME# supported from D0 D3hot D3cold
[    0.224397] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.224511] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.272697] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.272841] acpiphp: Slot [1] registered
[    0.272924] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.273010] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.273014] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.273073] pci 0000:70:00.0: [1b4b:9230] type 00 class 0x010601
[    0.273084] pci 0000:70:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.273092] pci 0000:70:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.273100] pci 0000:70:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.273108] pci 0000:70:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.273116] pci 0000:70:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.273125] pci 0000:70:00.0: reg 0x24: [mem 0xded10000-0xded107ff]
[    0.273133] pci 0000:70:00.0: reg 0x30: [mem 0xded00000-0xded0ffff pref]
[    0.273177] pci 0000:70:00.0: PME# supported from D3hot
[    0.273197] pci 0000:70:00.0: System wakeup disabled by ACPI
[    0.274740] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.274824] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.274826] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.274889] pci 0000:71:00.0: [10b5:8605] type 01 class 0x060400
[    0.274905] pci 0000:71:00.0: reg 0x10: [mem 0xdec00000-0xdec03fff]
[    0.275029] pci 0000:71:00.0: supports D1 D2
[    0.275030] pci 0000:71:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275059] pci 0000:71:00.0: System wakeup disabled by ACPI
[    0.276742] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.276826] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.276828] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.276914] pci 0000:72:01.0: [10b5:8605] type 01 class 0x060400
[    0.277053] pci 0000:72:01.0: supports D1 D2
[    0.277054] pci 0000:72:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.277112] pci 0000:72:02.0: [10b5:8605] type 01 class 0x060400
[    0.277251] pci 0000:72:02.0: supports D1 D2
[    0.277252] pci 0000:72:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.277309] pci 0000:72:03.0: [10b5:8605] type 01 class 0x060400
[    0.277448] pci 0000:72:03.0: supports D1 D2
[    0.277449] pci 0000:72:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.277528] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.277617] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.277621] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.277689] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.277886] pci 0000:74:00.0: [8086:08b1] type 00 class 0x028000
[    0.277930] pci 0000:74:00.0: reg 0x10: [mem 0xdeb00000-0xdeb01fff 64bit]
[    0.278181] pci 0000:74:00.0: PME# supported from D0 D3hot D3cold
[    0.279794] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.279885] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.279991] pci 0000:75:00.0: [8086:1533] type 00 class 0x020000
[    0.280018] pci 0000:75:00.0: reg 0x10: [mem 0xde900000-0xde9fffff]
[    0.280055] pci 0000:75:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.280073] pci 0000:75:00.0: reg 0x1c: [mem 0xdea00000-0xdea03fff]
[    0.280128] pci 0000:75:00.0: reg 0x30: [mem 0xde800000-0xde8fffff pref]
[    0.280256] pci 0000:75:00.0: PME# supported from D0 D3hot D3cold
[    0.281789] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.281878] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.281882] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.281953] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.282371] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.282779] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.283182] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.283585] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.283990] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.284393] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.284900] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.285302] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.285796] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.285979] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.286115] vgaarb: loaded
[    0.286194] vgaarb: bridge control possible 0000:00:02.0
[    0.286307] SCSI subsystem initialized
[    0.286407] libata version 3.00 loaded.
[    0.286422] ACPI: bus type USB registered
[    0.286511] usbcore: registered new interface driver usbfs
[    0.286598] usbcore: registered new interface driver hub
[    0.286690] usbcore: registered new device driver usb
[    0.286806] PCI: Using ACPI for IRQ routing
[    0.292082] PCI: pci_cache_line_size set to 64 bytes
[    0.292139] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.292140] e820: reserve RAM buffer [mem 0x5573f000-0x57ffffff]
[    0.292141] e820: reserve RAM buffer [mem 0x567b0000-0x57ffffff]
[    0.292141] e820: reserve RAM buffer [mem 0x69b33000-0x6bffffff]
[    0.292142] e820: reserve RAM buffer [mem 0x69d88000-0x6bffffff]
[    0.292143] e820: reserve RAM buffer [mem 0x6b000000-0x6bffffff]
[    0.292144] e820: reserve RAM buffer [mem 0x48f600000-0x48fffffff]
[    0.292192] NetLabel: Initializing
[    0.292271] NetLabel:  domain hash size = 128
[    0.292352] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.292442] NetLabel:  unlabeled traffic allowed by default
[    0.292547] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.292875] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.294973] Switched to clocksource hpet
[    0.298295] pnp: PnP ACPI init
[    0.298382] ACPI: bus type PNP registered
[    0.298503] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.298590] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.298596] pnp 00:01: [dma 4]
[    0.298605] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.298615] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.298664] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.298730] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.298815] system 00:04: [io  0xffff] has been reserved
[    0.298898] system 00:04: [io  0xffff] has been reserved
[    0.298985] system 00:04: [io  0xffff] has been reserved
[    0.299068] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    0.299153] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    0.299236] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    0.299321] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    0.299405] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    0.299489] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.299574] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.299590] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.299616] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.299700] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.299766] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.299850] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.301360] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.301445] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.301581] pnp 00:08: [dma 0 disabled]
[    0.301605] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.301634] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.301719] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.301732] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.301969] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.302055] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.302140] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.302225] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.302310] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.302395] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.302480] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.302565] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.302650] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.302736] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.302822] system 00:0b: [mem 0xdffef000-0xdffeffff] has been reserved
[    0.302907] system 00:0b: [mem 0xdfff0000-0xdfff0fff] has been reserved
[    0.302995] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.303125] pnp: PnP ACPI: found 12 devices
[    0.303206] ACPI: bus type PNP unregistered
[    0.308892] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 05-6f] add_size 1000
[    0.308907] pci 0000:72:01.0: bridge window [io  0x1000-0x0fff] to [bus 73] add_size 1000
[    0.308909] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 73] add_size 200000
[    0.308910] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff] to [bus 73] add_size 200000
[    0.308939] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308940] pci 0000:71:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 72-75] add_size 200000
[    0.308945] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308946] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 71-75] add_size 200000
[    0.308949] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308950] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.308954] pci 0000:00:1c.6: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.309091] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.309176] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.309264] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.309351] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.309439] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.309523] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.309610] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.309694] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.309781] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.309867] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.310007] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.310090] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.310176] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.310266] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.310267] pci 0000:71:00.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310402] pci 0000:72:01.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.310403] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.310404] pci 0000:72:01.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.310405] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.310490] pci 0000:72:01.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310624] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.310709] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.310794] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.310878] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.310971] pci 0000:72:01.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311111] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.311198] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.311293] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.311377] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.311466] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.311560] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.311644] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.311733] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.311822] pci 0000:71:00.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311964] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.312048] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.312134] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.312221] pci 0000:00:1c.6:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.312358] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.312358] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.312359] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.312360] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.312361] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.312362] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.312363] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.312363] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.312364] pci_bus 0000:00: resource 12 [mem 0x6fa00000-0xfeafffff]
[    0.312365] pci_bus 0000:01: resource 1 [mem 0xdee00000-0xdeefffff]
[    0.312366] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.312367] pci_bus 0000:05: resource 1 [mem 0xc0000000-0xde0fffff]
[    0.312368] pci_bus 0000:05: resource 2 [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.312368] pci_bus 0000:70: resource 0 [io  0xe000-0xefff]
[    0.312369] pci_bus 0000:70: resource 1 [mem 0xded00000-0xdedfffff]
[    0.312370] pci_bus 0000:71: resource 0 [io  0xd000-0xdfff]
[    0.312371] pci_bus 0000:71: resource 1 [mem 0xde800000-0xdecfffff]
[    0.312372] pci_bus 0000:71: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.312373] pci_bus 0000:72: resource 0 [io  0xd000-0xdfff]
[    0.312373] pci_bus 0000:72: resource 1 [mem 0xde800000-0xdebfffff]
[    0.312374] pci_bus 0000:72: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.312375] pci_bus 0000:73: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.312376] pci_bus 0000:74: resource 1 [mem 0xdeb00000-0xdebfffff]
[    0.312377] pci_bus 0000:75: resource 0 [io  0xd000-0xdfff]
[    0.312378] pci_bus 0000:75: resource 1 [mem 0xde800000-0xdeafffff]
[    0.312392] NET: Registered protocol family 2
[    0.312585] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.312854] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.313033] TCP: Hash tables configured (established 131072 bind 65536)
[    0.313127] TCP: reno registered
[    0.313217] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.313336] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.313472] NET: Registered protocol family 1
[    0.313560] pci 0000:00:02.0: Boot video device
[    0.328005] PCI: CLS mismatch (64 != 128), using 64 bytes
[    0.339018] Unpacking initramfs...
[    0.634092] Freeing initrd memory: 30848K (ffff8800343b0000 - ffff8800361d0000)
[    0.634228] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.634314] software IO TLB [mem 0x65b33000-0x69b33000] (64MB) mapped at [ffff880065b33000-ffff880069b32fff]
[    0.634667] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.635099] AVX2 version of gcm_enc/dec engaged.
[    0.636343] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.636633] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.636746] Initialise system trusted keyring
[    0.636833] audit: initializing netlink subsys (disabled)
[    0.636924] audit: type=2000 audit(1401094867.560:1): initialized
[    0.650958] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.651775] zbud: loaded
[    0.651942] VFS: Disk quotas dquot_6.5.2
[    0.652039] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.652291] msgmni has been set to 31859
[    0.652398] Key type big_key registered
[    0.652479] SELinux:  Registering netfilter hooks
[    0.653066] alg: No test for stdrng (krng)
[    0.653151] NET: Registered protocol family 38
[    0.653232] Key type asymmetric registered
[    0.653313] Asymmetric key parser 'x509' registered
[    0.653412] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.653570] io scheduler noop registered
[    0.653650] io scheduler deadline registered
[    0.653759] io scheduler cfq registered (default)
[    0.653948] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.654177] pcieport 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.654255] pcieport 0000:02:08.0: irq 42 for MSI/MSI-X
[    0.654333] pcieport 0000:02:10.0: irq 43 for MSI/MSI-X
[    0.654436] pcieport 0000:71:00.0: irq 44 for MSI/MSI-X
[    0.654578] pcieport 0000:72:01.0: irq 45 for MSI/MSI-X
[    0.654736] pcieport 0000:72:02.0: irq 46 for MSI/MSI-X
[    0.654879] pcieport 0000:72:03.0: irq 47 for MSI/MSI-X
[    0.654985] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.655076] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.655179] intel_idle: MWAIT substates: 0x42120
[    0.655179] intel_idle: v0.4 model 0x3C
[    0.655180] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.655382] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.655519] ACPI: Power Button [PWRB]
[    0.655619] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.655769] ACPI: Power Button [PWRF]
[    0.655883] ACPI: Fan [FAN0] (off)
[    0.655976] ACPI: Fan [FAN1] (off)
[    0.656069] ACPI: Fan [FAN2] (off)
[    0.656162] ACPI: Fan [FAN3] (off)
[    0.656253] ACPI: Fan [FAN4] (off)
[    0.656612] thermal LNXTHERM:00: registered as thermal_zone0
[    0.656716] ACPI: Thermal Zone [TZ00] (28 C)
[    0.656910] thermal LNXTHERM:01: registered as thermal_zone1
[    0.656993] ACPI: Thermal Zone [TZ01] (30 C)
[    0.657088] GHES: HEST is not enabled!
[    0.657195] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.677795] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.678163] Non-volatile memory driver v1.3
[    0.678245] Linux agpgart interface v0.103
[    0.678394] ahci 0000:00:1f.2: version 3.0
[    0.678449] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    0.678480] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x29 impl SATA mode
[    0.678615] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.683001] scsi0 : ahci
[    0.683245] scsi1 : ahci
[    0.683404] scsi2 : ahci
[    0.683563] scsi3 : ahci
[    0.683731] scsi4 : ahci
[    0.683893] scsi5 : ahci
[    0.684000] ata1: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a100 irq 48
[    0.684132] ata2: DUMMY
[    0.684210] ata3: DUMMY
[    0.684288] ata4: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a280 irq 48
[    0.684420] ata5: DUMMY
[    0.684498] ata6: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a380 irq 48
[    0.684712] ahci 0000:70:00.0: controller can do FBS, turning on CAP_FBS
[    0.684885] ahci 0000:70:00.0: irq 49 for MSI/MSI-X
[    0.695685] ahci 0000:70:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    0.695819] ahci 0000:70:00.0: flags: 64bit ncq fbs pio 
[    0.696364] scsi6 : ahci
[    0.696524] scsi7 : ahci
[    0.696692] scsi8 : ahci
[    0.696826] scsi9 : ahci
[    0.696960] scsi10 : ahci
[    0.697097] scsi11 : ahci
[    0.697231] scsi12 : ahci
[    0.697366] scsi13 : ahci
[    0.697466] ata7: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10100 irq 49
[    0.697600] ata8: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10180 irq 49
[    0.697738] ata9: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10200 irq 49
[    0.697872] ata10: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10280 irq 49
[    0.698007] ata11: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10300 irq 49
[    0.698141] ata12: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10380 irq 49
[    0.698276] ata13: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10400 irq 49
[    0.698410] ata14: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10480 irq 49
[    0.698582] libphy: Fixed MDIO Bus: probed
[    0.698839] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.699059] ehci-pci: EHCI PCI platform driver
[    0.699341] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.699502] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.699689] ehci-pci 0000:00:1a.0: debug port 2
[    0.703669] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.703677] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdef3c000
[    0.709628] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.709739] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.709824] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.709956] usb usb1: Product: EHCI Host Controller
[    0.710038] usb usb1: Manufacturer: Linux 3.15.0-rc7 ehci_hcd
[    0.711542] usb usb1: SerialNumber: 0000:00:1a.0
[    0.711722] hub 1-0:1.0: USB hub found
[    0.711804] hub 1-0:1.0: 2 ports detected
[    0.711989] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.712109] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.712259] ehci-pci 0000:00:1d.0: debug port 2
[    0.716230] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.716238] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdef3b000
[    0.721618] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.721720] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.721805] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.721937] usb usb2: Product: EHCI Host Controller
[    0.722018] usb usb2: Manufacturer: Linux 3.15.0-rc7 ehci_hcd
[    0.722101] usb usb2: SerialNumber: 0000:00:1d.0
[    0.722263] hub 2-0:1.0: USB hub found
[    0.722346] hub 2-0:1.0: 2 ports detected
[    0.722481] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.722566] ohci-pci: OHCI PCI platform driver
[    0.722678] uhci_hcd: USB Universal Host Controller Interface driver
[    0.722823] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.722948] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    0.723180] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.723190] xhci_hcd 0000:00:14.0: irq 50 for MSI/MSI-X
[    0.723223] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.723308] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.723440] usb usb3: Product: xHCI Host Controller
[    0.723521] usb usb3: Manufacturer: Linux 3.15.0-rc7 xhci_hcd
[    0.723605] usb usb3: SerialNumber: 0000:00:14.0
[    0.723793] hub 3-0:1.0: USB hub found
[    0.723885] hub 3-0:1.0: 14 ports detected
[    0.725335] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.725457] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    0.725619] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.725713] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.725845] usb usb4: Product: xHCI Host Controller
[    0.725927] usb usb4: Manufacturer: Linux 3.15.0-rc7 xhci_hcd
[    0.726010] usb usb4: SerialNumber: 0000:00:14.0
[    0.726169] hub 4-0:1.0: USB hub found
[    0.726257] hub 4-0:1.0: 6 ports detected
[    0.726974] usbcore: registered new interface driver usbserial
[    0.727060] usbcore: registered new interface driver usbserial_generic
[    0.727147] usbserial: USB Serial support registered for generic
[    0.727244] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.727699] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.727782] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.727928] mousedev: PS/2 mouse device common for all mice
[    0.728221] rtc_cmos 00:05: RTC can wake from S4
[    0.728424] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.728529] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.728710] device-mapper: uevent: version 1.0.3
[    0.728844] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.729044] Intel P-state driver initializing.
[    0.729129] Intel pstate controlling: cpu 0
[    0.729218] Intel pstate controlling: cpu 1
[    0.729304] Intel pstate controlling: cpu 2
[    0.729390] Intel pstate controlling: cpu 3
[    0.729477] Intel pstate controlling: cpu 4
[    0.729563] Intel pstate controlling: cpu 5
[    0.729676] Intel pstate controlling: cpu 6
[    0.729763] Intel pstate controlling: cpu 7
[    0.730022] hidraw: raw HID events driver (C) Jiri Kosina
[    0.730150] usbcore: registered new interface driver usbhid
[    0.730233] usbhid: USB HID core driver
[    0.730322] drop_monitor: Initializing network drop monitor service
[    0.730438] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.730579] TCP: cubic registered
[    0.730690] Initializing XFRM netlink socket
[    0.730821] NET: Registered protocol family 10
[    0.731073] mip6: Mobile IPv6
[    0.731152] NET: Registered protocol family 17
[    0.731432] Loading compiled-in X.509 certificates
[    0.731971] Loaded X.509 cert 'Magrathea: Glacier signing key: b2d725434700af2dc331734897eb86db6cc53062'
[    0.732110] registered taskstats version 1
[    0.732778]   Magic number: 14:860:20
[    0.732902] memory memory60: hash matches
[    0.733038] rtc_cmos 00:05: setting system clock to 2014-05-26 09:01:08 UTC (1401094868)
[    0.733214] PM: Hibernation image not present or could not be loaded.
[    0.989431] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.989529] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.989635] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.989902] ata1.00: ATA-9: INTEL SSDSC2BB480G4, D2010370, max UDMA/133
[    0.989988] ata1.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.990416] ata1.00: configured for UDMA/133
[    0.990698] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB48 D201 PQ: 0 ANSI: 5
[    0.991076] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.991143] sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    0.991144] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.991295] sd 0:0:0:0: [sda] Write Protect is off
[    0.991296] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.991313] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.991553] ata4.00: ATA-8: WDC WD5000AAKX-753CA0, 15.01H15, max UDMA/133
[    0.991554] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.991910]  sda: sda1 sda2
[    0.992072] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.992074] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.992074] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.992221] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.992777] ata4.00: configured for UDMA/133
[    0.993022] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKX-7 15.0 PQ: 0 ANSI: 5
[    0.993308] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.993312] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    0.993589] ata6.00: ATAPI: ATAPI   iHAS124   W, HL0G, max UDMA/100
[    0.993770] sd 3:0:0:0: [sdb] Write Protect is off
[    0.993770] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.993851] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.996509] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.996511] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.996645] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.998332] ata6.00: configured for UDMA/100
[    0.999510] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS124   W      HL0G PQ: 0 ANSI: 5
[    1.002430] ata8: SATA link down (SStatus 0 SControl 300)
[    1.003408] ata12: SATA link down (SStatus 0 SControl 300)
[    1.003516] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.003618] ata11: SATA link down (SStatus 0 SControl 300)
[    1.003715] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.003975] ata14.00: configured for UDMA/66
[    1.004418] ata9: SATA link down (SStatus 0 SControl 300)
[    1.005434] ata10: SATA link down (SStatus 0 SControl 300)
[    1.005555] ata13: SATA link down (SStatus 0 SControl 300)
[    1.005683] ata7: SATA link down (SStatus 0 SControl 300)
[    1.013417] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.022973] sr0: scsi3-mmc drive: 188x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.023107] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.023346] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    1.023470] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    1.024165] scsi 13:0:0:0: Processor         Marvell  Console          1.01 PQ: 0 ANSI: 5
[    1.031734]  sdb: sdb1 sdb2 < sdb5 sdb6 >
[    1.032360] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.036384] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.036470] ata14.00: irq_stat 0x40000001
[    1.036551] scsi 13:0:0:0: CDB: 
[    1.036629] Inquiry: 12 01 00 00 ff 00
[    1.036924] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 dma 16640 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[    1.037163] ata14: hard resetting link
[    1.127715] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    1.127801] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.128105] hub 1-1:1.0: USB hub found
[    1.128340] hub 1-1:1.0: 6 ports detected
[    1.231212] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.343131] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.343481] ata14.00: configured for UDMA/66
[    1.343644] ata14: EH complete
[    1.343811] scsi 13:0:0:0: Attached scsi generic sg3 type 3
[    1.344649] Freeing unused kernel memory: 1412K (ffffffff81d0b000 - ffffffff81e6c000)
[    1.344783] Write protecting the kernel read-only data: 12288k
[    1.345504] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    1.345590] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.345898] hub 2-1:1.0: USB hub found
[    1.346128] hub 2-1:1.0: 8 ports detected
[    1.347026] Freeing unused kernel memory: 1324K (ffff8800016b5000 - ffff880001800000)
[    1.348606] Freeing unused kernel memory: 1088K (ffff880001af0000 - ffff880001c00000)
[    1.350172] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.350414] systemd[1]: Running in initial RAM disk.
[    1.350857] systemd[1]: Set hostname to <lahna>.
[    1.351207] random: systemd urandom read with 88 bits of entropy available
[    1.365882] systemd[1]: Expecting device dev-mapper-fedora\x2droot.device...
[    1.367727] systemd[1]: Starting -.slice.
[    1.368242] systemd[1]: Created slice -.slice.
[    1.368336] systemd[1]: Starting System Slice.
[    1.368704] systemd[1]: Created slice System Slice.
[    1.368797] systemd[1]: Starting Slices.
[    1.369149] systemd[1]: Reached target Slices.
[    1.369241] systemd[1]: Starting Timers.
[    1.369569] systemd[1]: Reached target Timers.
[    1.369663] systemd[1]: Starting udev Kernel Socket.
[    1.370005] systemd[1]: Listening on udev Kernel Socket.
[    1.370112] systemd[1]: Starting udev Control Socket.
[    1.370461] systemd[1]: Listening on udev Control Socket.
[    1.370556] systemd[1]: Starting Journal Socket.
[    1.370908] systemd[1]: Listening on Journal Socket.
[    1.371057] systemd[1]: Starting dracut cmdline hook...
[    1.371553] systemd[1]: Starting Apply Kernel Variables...
[    1.372047] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.372587] systemd[1]: Starting Sockets.
[    1.372927] systemd[1]: Reached target Sockets.
[    1.373025] systemd[1]: Starting Setup Virtual Console...
[    1.373498] systemd[1]: Starting Journal Service...
[    1.374258] systemd[1]: Started Journal Service.
[    1.500049] usb 3-9: new high-speed USB device number 2 using xhci_hcd
[    1.526561] systemd-udevd[317]: starting version 208
[    1.587703] pps_core: LinuxPPS API ver. 1 registered
[    1.587805] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.593521] PTP clock support registered
[    1.597147] dca service started, version 1.12.1
[    1.617403] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    1.617492] igb: Copyright (c) 2007-2014 Intel Corporation.
[    1.625353] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.625441] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.625638] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.625792] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    1.627723] [drm] Initialized drm 1.1.0 20060810
[    1.633863] tsc: Refined TSC clocksource calibration: 3491.909 MHz
[    1.646414] random: nonblocking pool is initialized
[    1.665043] usb 3-9: New USB device found, idVendor=045b, idProduct=0209
[    1.665135] usb 3-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.665500] hub 3-9:1.0: USB hub found
[    1.665603] hub 3-9:1.0: 4 ports detected
[    1.726264] igb 0000:75:00.0: irq 52 for MSI/MSI-X
[    1.726267] igb 0000:75:00.0: irq 53 for MSI/MSI-X
[    1.726269] igb 0000:75:00.0: irq 54 for MSI/MSI-X
[    1.726271] igb 0000:75:00.0: irq 55 for MSI/MSI-X
[    1.726272] igb 0000:75:00.0: irq 56 for MSI/MSI-X
[    1.755293] igb 0000:75:00.0: added PHC on eth0
[    1.755389] igb 0000:75:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.755485] igb 0000:75:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 74:d4:35:1b:fc:39
[    1.755643] igb 0000:75:00.0: eth0: PBA No: 000200-000
[    1.755754] igb 0000:75:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.770794] systemd-udevd[326]: renamed network interface eth0 to p4p1
[    1.794381] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.794541] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 74:d4:35:1b:fc:26
[    1.794820] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.794979] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    1.797048] [drm] Memory usable by graphics device = 2048M
[    1.819722] usb 3-10: new high-speed USB device number 3 using xhci_hcd
[    1.853768] i915 0000:00:02.0: irq 57 for MSI/MSI-X
[    1.853778] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.853882] [drm] Driver supports precise vblank timestamp query.
[    1.854006] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.859881] systemd-udevd[322]: renamed network interface eth0 to em1
[    1.903489] fbcon: inteldrmfb (fb0) is primary device
[    1.956490] Console: switching to colour frame buffer device 240x75
[    1.969111] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.969166] i915 0000:00:02.0: registered panic notifier
[    1.977826] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.978925] acpi device:70: registered as cooling_device13
[    1.979219] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    1.979441] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.983858] usb 3-10: New USB device found, idVendor=045b, idProduct=0209
[    1.983943] usb 3-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.984501] hub 3-10:1.0: USB hub found
[    1.984603] hub 3-10:1.0: 4 ports detected
[    2.086762] usb 4-5: new SuperSpeed USB device number 2 using xhci_hcd
[    2.099207] usb 4-5: New USB device found, idVendor=045b, idProduct=0210
[    2.099257] usb 4-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.099898] hub 4-5:1.0: USB hub found
[    2.100187] hub 4-5:1.0: 4 ports detected
[    2.204851] usb 4-6: new SuperSpeed USB device number 3 using xhci_hcd
[    2.217286] usb 4-6: New USB device found, idVendor=045b, idProduct=0210
[    2.217296] usb 4-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.218201] hub 4-6:1.0: USB hub found
[    2.218496] hub 4-6:1.0: 4 ports detected
[    2.274606] PM: Starting manual resume from disk
[    2.274617] PM: Hibernation image partition 253:1 present
[    2.274620] PM: Looking for hibernation image.
[    2.274876] PM: Image not found (code -22)
[    2.274883] PM: Hibernation image not present or could not be loaded.
[    2.293367] usb 3-10.1: new low-speed USB device number 4 using xhci_hcd
[    2.297970] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    2.385176] usb 3-10.1: New USB device found, idVendor=046d, idProduct=c52a
[    2.385184] usb 3-10.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.385187] usb 3-10.1: Product: 2.4GHz Cordless Desktop
[    2.385190] usb 3-10.1: Manufacturer: Logitech
[    2.385405] usb 3-10.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.385411] usb 3-10.1: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.390743] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.0/0003:046D:C52A.0001/input/input6
[    2.390896] hid-generic 0003:046D:C52A.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input0
[    2.399551] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.1/0003:046D:C52A.0002/input/input7
[    2.399872] hid-generic 0003:046D:C52A.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input1
[    2.472220] usb 3-10.2: new high-speed USB device number 5 using xhci_hcd
[    2.556245] usb 3-10.2: New USB device found, idVendor=0409, idProduct=005a
[    2.556254] usb 3-10.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.556909] hub 3-10.2:1.0: USB hub found
[    2.556941] hub 3-10.2:1.0: 4 ports detected
[    2.595650] systemd-journald[176]: Received SIGTERM
[    2.598490] systemd-cgroups-agent[528]: Failed to get D-Bus connection: Failed to connect to socket /run/systemd/private: No such file or directory
[    2.633187] Switched to clocksource tsc
[    2.668260] audit: type=1404 audit(1401094870.435:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.705176] SELinux: 2048 avtab hash slots, 100018 rules.
[    2.738117] SELinux: 2048 avtab hash slots, 100018 rules.
[    2.778341] SELinux:  8 users, 86 roles, 4805 types, 281 bools, 1 sens, 1024 cats
[    2.778345] SELinux:  83 classes, 100018 rules
[    2.783880] SELinux:  Completing initialization.
[    2.783881] SELinux:  Setting up existing superblocks.
[    2.783889] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    2.783899] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    2.783906] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    2.783940] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.784006] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    2.785351] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    2.786517] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    2.786520] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    2.786525] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    2.786528] SELinux: initialized (dev aio, type aio), not configured for labeling
[    2.786531] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    2.786554] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    2.786564] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    2.786574] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    2.786590] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.787197] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    2.787200] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.787212] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.787364] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.787415] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787421] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    2.787423] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787425] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787428] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787437] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787442] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787444] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787446] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787454] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787457] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.787460] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    2.787463] SELinux: initialized (dev drm, type drm), not configured for labeling
[    2.787471] SELinux: initialized (dev dm-0, type ext4), uses xattr
[    2.805064] audit: type=1403 audit(1401094870.572:3): policy loaded auid=4294967295 ses=4294967295
[    2.818103] systemd[1]: Successfully loaded SELinux policy in 151.509ms.
[    2.888748] systemd[1]: Relabelled /dev and /run in 41.266ms.
[    3.083021] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.086747] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.125337] systemd-udevd[575]: starting version 208
[    3.134673] EXT4-fs (dm-0): re-mounted. Opts: (null)
[    3.158497] wmi: Mapper loaded
[    3.220277] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    3.220359] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    3.220363] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.221309] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.231890] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.239603] mei_me 0000:00:16.0: irq 58 for MSI/MSI-X
[    3.246116] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.247511] microcode: CPU0 updated to revision 0x17, date = 2013-08-16
[    3.247521] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.247549] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.248282] microcode: CPU1 updated to revision 0x17, date = 2013-08-16
[    3.248289] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.248313] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.249043] microcode: CPU2 updated to revision 0x17, date = 2013-08-16
[    3.249052] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.249074] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.249806] microcode: CPU3 updated to revision 0x17, date = 2013-08-16
[    3.249813] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.249840] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.250573] microcode: CPU4 updated to revision 0x17, date = 2013-08-16
[    3.250580] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.250603] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.251332] microcode: CPU5 updated to revision 0x17, date = 2013-08-16
[    3.251337] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.251354] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.252048] microcode: CPU6 updated to revision 0x17, date = 2013-08-16
[    3.252059] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.252081] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.252816] microcode: CPU7 updated to revision 0x17, date = 2013-08-16
[    3.253159] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.293439] alg: No test for crc32 (crc32-pclmul)
[    3.351299] iTCO_vendor_support: vendor-support=0
[    3.355377] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.355406] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    3.372767] snd_hda_intel 0000:00:03.0: irq 59 for MSI/MSI-X
[    3.372871] snd_hda_intel 0000:00:1b.0: irq 60 for MSI/MSI-X
[    3.400760] Adding 8200188k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:8200188k SSFS
[    3.405216] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.405321] SELinux: initialized (dev sda1, type ext4), uses xattr
[    3.441605] sound hdaudioC1D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    3.441607] sound hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.441608] sound hdaudioC1D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.441609] sound hdaudioC1D2:    mono: mono_out=0x0
[    3.441610] sound hdaudioC1D2:    dig-out=0x11/0x1e
[    3.441610] sound hdaudioC1D2:    inputs:
[    3.441612] sound hdaudioC1D2:      Front Mic=0x19
[    3.441613] sound hdaudioC1D2:      Rear Mic=0x18
[    3.441614] sound hdaudioC1D2:      Line=0x1a
[    3.441614] sound hdaudioC1D2:    dig-in=0x1f
[    3.483722] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[    3.483835] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[    3.483930] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    3.486482] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    3.486574] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[    3.487002] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[    3.487065] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
[    3.487154] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
[    3.487277] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
[    3.488032] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
[    3.768113] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    3.875437] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    3.875451] SELinux: initialized (dev dm-2, type ext4), uses xattr
[    4.705566] systemd-journald[568]: Received request to flush runtime journal from PID 1
[    4.711764] audit: type=1305 audit(1401094872.480:4): audit_pid=837 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    5.076795] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.119398] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.170590] Ebtables v2.0 registered
[    5.228206] Bridge firewalling registered
[    5.407148] cfg80211: Calling CRDA to update world regulatory domain
[    5.411114] cfg80211: World regulatory domain updated:
[    5.411119] cfg80211:  DFS Master region: unset
[    5.411120] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.411123] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    5.411125] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    5.411126] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    5.411128] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    5.411130] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    5.411132] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    5.678172] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[    5.774372] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.875323] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.875441] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[    6.026656] Bluetooth: Core ver 2.19
[    6.026736] NET: Registered protocol family 31
[    6.026737] Bluetooth: HCI device and connection manager initialized
[    6.026745] Bluetooth: HCI socket layer initialized
[    6.026747] Bluetooth: L2CAP socket layer initialized
[    6.026753] Bluetooth: SCO socket layer initialized
[    6.043845] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.043849] Bluetooth: BNEP filters: protocol multicast
[    6.043856] Bluetooth: BNEP socket layer initialized
[   12.882998] e1000e: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   12.883045] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   15.678671] fuse init (API version 7.23)
[   15.683383] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   15.710210] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   33.485833] usb 3-10.3: new high-speed USB device number 6 using xhci_hcd
[   33.578914] usb 3-10.3: New USB device found, idVendor=8564, idProduct=1000
[   33.578923] usb 3-10.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   33.578928] usb 3-10.3: Product: Mass Storage Device
[   33.578931] usb 3-10.3: Manufacturer: JetFlash
[   33.578935] usb 3-10.3: SerialNumber: 9EAOZJ51
[   33.653901] usb-storage 3-10.3:1.0: USB Mass Storage device detected
[   33.654026] scsi14 : usb-storage 3-10.3:1.0
[   33.654168] usbcore: registered new interface driver usb-storage
[   34.668024] scsi 14:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[   34.669161] sd 14:0:0:0: Attached scsi generic sg4 type 0
[   34.669189] sd 14:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[   34.669884] sd 14:0:0:0: [sdc] Write Protect is off
[   34.669891] sd 14:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   34.670621] sd 14:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   34.675162]  sdc: sdc1
[   34.677783] sd 14:0:0:0: [sdc] Attached SCSI removable disk
[   46.606679] usb 3-10.3: USB disconnect, device number 6
[   72.491252] BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
[   72.491255] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_intel snd_hda_controller iTCO_wdt snd_hda_codec mxm_wmi iTCO_vendor_support snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul snd_seq_device crc32c_intel snd_pcm ghash_clmulni_intel snd_timer snd mei_me microcode mei lpc_ich joydev serio_raw shpchp i2c_i801
[   72.491286]  mfd_core soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[   72.491294] CPU: 5 PID: 1667 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[   72.491295] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[   72.491296] task: ffff880472f453d0 ti: ffff8804741ee000 task.ti: ffff8804741ee000
[   72.491297] RIP: 0010:[<ffffffff816a50f5>]  [<ffffffff816a50f5>] _raw_spin_trylock+0x25/0x40
[   72.491302] RSP: 0018:ffff8804741efbd0  EFLAGS: 00000246
[   72.491303] RAX: 000000000000dddd RBX: ffffffff81246036 RCX: 000000000000dedd
[   72.491304] RDX: 000000000000dddd RSI: 0000000000000000 RDI: ffff880476af7d48
[   72.491305] RBP: ffff8804741efbd0 R08: ffff88045a8e3740 R09: 0000000180240013
[   72.491306] R10: ffffffff81246036 R11: ffffea0000d77500 R12: ffff8804783b04d8
[   72.491307] R13: ffff8804741efbe0 R14: ffff88047e84cf00 R15: ffff880035dd4310
[   72.491309] FS:  00007fdbfb7de880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[   72.491310] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.491311] CR2: 00007fffc5fe5f78 CR3: 0000000472a23000 CR4: 00000000001407e0
[   72.491312] Stack:
[   72.491313]  ffff8804741efc00 ffffffff811e74e6 ffff88045a8e3740 ffff88045a8e3600
[   72.491315]  ffff8804741efc48 ffff88045a8e36c0 ffff8804741efc30 ffffffff811e793a
[   72.491317]  ffff8804741efc48 ffff880477b92540 0000000000000043 ffff8804741efe60
[   72.491319] Call Trace:
[   72.491323]  [<ffffffff811e74e6>] dentry_kill+0x36/0x280
[   72.491325]  [<ffffffff811e793a>] shrink_dentry_list+0x8a/0x110
[   72.491327]  [<ffffffff811e81c4>] check_submounts_and_drop+0x74/0xa0
[   72.491330]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[   72.491332]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[   72.491334]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[   72.491337]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[   72.491340]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[   72.491342]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[   72.491344]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[   72.491347]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[   72.491349]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[   72.491351]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[   72.491353]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[   72.491355]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[   72.491358]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[   72.491360]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[   72.491361] Code: a2 42 9e ff 5d c3 0f 1f 44 00 00 55 48 89 e5 0f b7 17 38 d6 74 08 31 c0 5d c3 0f 1f 40 00 8d 8a 00 01 00 00 89 d0 f0 66 0f b1 0f <66> 39 d0 75 e6 b8 01 00 00 00 5d c3 66 66 66 66 66 66 2e 0f 1f 
[  100.453705] BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
[  100.453708] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_intel snd_hda_controller iTCO_wdt snd_hda_codec mxm_wmi iTCO_vendor_support snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul snd_seq_device crc32c_intel snd_pcm ghash_clmulni_intel snd_timer snd mei_me microcode mei lpc_ich joydev serio_raw shpchp i2c_i801
[  100.453738]  mfd_core soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  100.453745] CPU: 5 PID: 1667 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  100.453747] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  100.453748] task: ffff880472f453d0 ti: ffff8804741ee000 task.ti: ffff8804741ee000
[  100.453749] RIP: 0010:[<ffffffff811e78fc>]  [<ffffffff811e78fc>] shrink_dentry_list+0x4c/0x110
[  100.453753] RSP: 0018:ffff8804741efc10  EFLAGS: 00000202
[  100.453754] RAX: ffff88044e9d1a40 RBX: 0000000000006766 RCX: dead000000200200
[  100.453755] RDX: ffff8804741efc48 RSI: ffff8804741efc48 RDI: ffff88044e9d1200
[  100.453756] RBP: ffff8804741efc30 R08: ffff88044e9d1200 R09: 0000000180240013
[  100.453757] R10: ffffffff81246036 R11: ffffea0000d77500 R12: ffff880477b92ec0
[  100.453758] R13: 0000000180240013 R14: ffffffff81246036 R15: ffffea0000d77500
[  100.453760] FS:  00007fdbfb7de880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  100.453761] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.453762] CR2: 00007fffc5fe5f78 CR3: 0000000472a23000 CR4: 00000000001407e0
[  100.453763] Stack:
[  100.453764]  ffff8804741efc48 ffff880477b92540 0000000000000043 ffff8804741efe60
[  100.453766]  ffff8804741efc78 ffffffff811e81c4 ffff880477b92540 ffff88044e9d1bc0
[  100.453768]  ffff88044e9d1a40 ffffffff00000043 ffff880477b92540 ffff880473d6b9a0
[  100.453770] Call Trace:
[  100.453773]  [<ffffffff811e81c4>] check_submounts_and_drop+0x74/0xa0
[  100.453776]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  100.453778]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  100.453780]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  100.453783]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  100.453786]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  100.453788]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  100.453790]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  100.453793]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  100.453795]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  100.453797]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  100.453799]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  100.453801]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  100.453804]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  100.453807]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  100.453808] Code: e8 da d8 4b 00 8b 43 80 25 00 04 08 00 3d 00 04 08 00 0f 85 93 00 00 00 48 89 df 4c 8d 73 80 e8 6b a1 15 00 81 63 80 ff fb f7 ff <48> 89 1b 65 48 ff 0c 25 60 0a 01 00 8b 43 dc 48 89 5b 08 85 c0 
[  106.544263] INFO: rcu_sched self-detected stall on CPU { 5}  (t=60001 jiffies g=1126 c=1125 q=9446)
[  106.544267] sending NMI to all CPUs:
[  106.544270] NMI backtrace for cpu 1
[  106.544272] CPU: 1 PID: 1668 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544274] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544275] task: ffff880472f437e0 ti: ffff880470ce2000 task.ti: ffff880470ce2000
[  106.544276] RIP: 0010:[<ffffffff816a51ce>]  [<ffffffff816a51ce>] _raw_spin_lock+0x1e/0x30
[  106.544280] RSP: 0018:ffff880470ce3bb0  EFLAGS: 00000297
[  106.544281] RAX: 00000000000000ad RBX: ffff880470ce3c48 RCX: ffffffff811e7440
[  106.544282] RDX: 00000000000000ae RSI: ffff880470ce3c40 RDI: ffff880477b92598
[  106.544284] RBP: ffff880470ce3bb0 R08: ffff880470ce2000 R09: 0000000000000001
[  106.544285] R10: 0000000000000000 R11: 0000000000001000 R12: ffff880477b92540
[  106.544286] R13: 000000000000001d R14: ffff880470ce3e60 R15: 0000000000000001
[  106.544287] FS:  00007fdbfb7de880(0000) GS:ffff88048f240000(0000) knlGS:0000000000000000
[  106.544288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544289] CR2: 00007f9d4e178190 CR3: 00000004709f8000 CR4: 00000000001407e0
[  106.544291] Stack:
[  106.544292]  ffff880470ce3c30 ffffffff811e7d9c ffffffff811e7440 01ffffff816a1d2a
[  106.544294]  ffff880477b92598 ffff880477b92598 ffff880477b92540 ffff880477b925e0
[  106.544296]  ffffffff811e6eb0 ffff880470ce3c40 0000053a00000000 ffff880470ce3c48
[  106.544298] Call Trace:
[  106.544301]  [<ffffffff811e7d9c>] d_walk+0x5c/0x280
[  106.544304]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  106.544306]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  106.544308]  [<ffffffff811e81b2>] check_submounts_and_drop+0x62/0xa0
[  106.544311]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544313]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544315]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544318]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  106.544321]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  106.544323]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544325]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  106.544329]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544331]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544333]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544335]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544337]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544340]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544342]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544343] Code: e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 
[  106.544365] NMI backtrace for cpu 4
[  106.544368] CPU: 4 PID: 1669 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544369] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544370] task: ffff880472f42e90 ti: ffff880473c6c000 task.ti: ffff880473c6c000
[  106.544372] RIP: 0010:[<ffffffff816a51ce>]  [<ffffffff816a51ce>] _raw_spin_lock+0x1e/0x30
[  106.544375] RSP: 0018:ffff880473c6dbb0  EFLAGS: 00000283
[  106.544376] RAX: 00000000000000ad RBX: ffff880473c6dc48 RCX: ffffffff811e7440
[  106.544377] RDX: 00000000000000b0 RSI: ffff880473c6dc40 RDI: ffff880477b92598
[  106.544378] RBP: ffff880473c6dbb0 R08: ffff880473c6c000 R09: 0000000000000001
[  106.544379] R10: dfed4b4078b105a0 R11: 0000000000000000 R12: ffff880477b92540
[  106.544380] R13: 000000000000001d R14: ffff880473c6de60 R15: 0000000000000001
[  106.544382] FS:  00007fdbfb7de880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  106.544383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544384] CR2: 00007f7fcc212000 CR3: 0000000473a87000 CR4: 00000000001407e0
[  106.544385] Stack:
[  106.544386]  ffff880473c6dc30 ffffffff811e7d9c ffffffff811e7440 01ffffff816a1d2a
[  106.544388]  ffff880477b92598 ffff880477b92598 ffff880477b92540 ffff880477b925e0
[  106.544390]  ffffffff811e6eb0 ffff880473c6dc40 0000053a00000000 ffff880473c6dc48
[  106.544392] Call Trace:
[  106.544395]  [<ffffffff811e7d9c>] d_walk+0x5c/0x280
[  106.544397]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  106.544399]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  106.544401]  [<ffffffff811e81b2>] check_submounts_and_drop+0x62/0xa0
[  106.544404]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544406]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544408]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544410]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  106.544412]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  106.544414]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544416]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  106.544419]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544420]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544422]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544424]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544426]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544429]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544431]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544432] Code: e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 
[  106.544454] NMI backtrace for cpu 3
[  106.544457] CPU: 3 PID: 1671 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544458] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544459] task: ffff880472f40950 ti: ffff88047709c000 task.ti: ffff88047709c000
[  106.544460] RIP: 0010:[<ffffffff816a51d1>]  [<ffffffff816a51d1>] _raw_spin_lock+0x21/0x30
[  106.544463] RSP: 0018:ffff88047709dbb0  EFLAGS: 00000283
[  106.544464] RAX: 00000000000000ad RBX: ffff88047709dc48 RCX: ffffffff811e7440
[  106.544466] RDX: 00000000000000b2 RSI: ffff88047709dc40 RDI: ffff880477b92598
[  106.544467] RBP: ffff88047709dbb0 R08: ffff88047709c000 R09: 0000000000000001
[  106.544468] R10: 0000000000000001 R11: 0000000000000246 R12: ffff880477b92540
[  106.544469] R13: 000000000000001d R14: ffff88047709de60 R15: 0000000000000001
[  106.544470] FS:  00007fdbfb7de880(0000) GS:ffff88048f2c0000(0000) knlGS:0000000000000000
[  106.544472] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544473] CR2: 00007f32dce61000 CR3: 0000000470dac000 CR4: 00000000001407e0
[  106.544474] Stack:
[  106.544475]  ffff88047709dc30 ffffffff811e7d9c ffffffff811e7440 01ffffff816a1d2a
[  106.544477]  ffff880477b92598 ffff880477b92598 ffff880477b92540 ffff880477b925e0
[  106.544479]  ffffffff811e6eb0 ffff88047709dc40 0000053a00000000 ffff88047709dc48
[  106.544481] Call Trace:
[  106.544483]  [<ffffffff811e7d9c>] d_walk+0x5c/0x280
[  106.544485]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  106.544488]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  106.544489]  [<ffffffff811e81b2>] check_submounts_and_drop+0x62/0xa0
[  106.544492]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544494]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544496]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544498]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  106.544500]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544502]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  106.544504]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544506]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544507]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544509]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544512]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544514]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544517]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  106.544519]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544520] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  106.544542] NMI backtrace for cpu 5
[  106.544543] CPU: 5 PID: 1667 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544544] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544545] task: ffff880472f453d0 ti: ffff8804741ee000 task.ti: ffff8804741ee000
[  106.544546] RIP: 0010:[<ffffffff81336a12>]  [<ffffffff81336a12>] __const_udelay+0x12/0x30
[  106.544550] RSP: 0018:ffff88048f343df0  EFLAGS: 00000086
[  106.544551] RAX: 0000000001062560 RBX: 0000000000002710 RCX: 00000000ff000000
[  106.544552] RDX: 000000000035494d RSI: ffffffff81c27ec0 RDI: 0000000000418958
[  106.544553] RBP: ffff88048f343e08 R08: 000000000000000a R09: 00000000000004c6
[  106.544554] R10: 0000000000000000 R11: ffff88048f343b3e R12: ffffffff81c4f7c0
[  106.544555] R13: ffffffff81cfdb38 R14: ffffffff81c4f7c0 R15: 0000000000000005
[  106.544556] FS:  00007fdbfb7de880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  106.544557] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544558] CR2: 00007fffc5fe5f78 CR3: 0000000472a23000 CR4: 00000000001407e0
[  106.544559] Stack:
[  106.544560]  ffff88048f343e08 ffffffff810448ce ffff88048f34eac0 ffff88048f343e60
[  106.544562]  ffffffff810e415e ffff88048f343e60 ffffffff810b8a01 00000018b96ad131
[  106.544564]  00000000000024e6 ffff880472f453d0 0000000000000000 0000000000000005
[  106.544566] Call Trace:
[  106.544567]  <IRQ> 

[  106.544570]  [<ffffffff810448ce>] ? arch_trigger_all_cpu_backtrace+0x5e/0x80
[  106.544574]  [<ffffffff810e415e>] rcu_check_callbacks+0x3fe/0x660
[  106.544577]  [<ffffffff810b8a01>] ? account_process_tick+0x121/0x1b0
[  106.544579]  [<ffffffff81091627>] update_process_times+0x47/0x70
[  106.544582]  [<ffffffff810ee935>] tick_sched_handle.isra.16+0x25/0x60
[  106.544584]  [<ffffffff810ee9b1>] tick_sched_timer+0x41/0x60
[  106.544587]  [<ffffffff810a8493>] __run_hrtimer+0x73/0x1d0
[  106.544589]  [<ffffffff810ee970>] ? tick_sched_handle.isra.16+0x60/0x60
[  106.544591]  [<ffffffff810a8c67>] hrtimer_interrupt+0xf7/0x240
[  106.544594]  [<ffffffff81042c37>] local_apic_timer_interrupt+0x37/0x60
[  106.544596]  [<ffffffff816b00ef>] smp_apic_timer_interrupt+0x3f/0x60
[  106.544598]  [<ffffffff816aeadd>] apic_timer_interrupt+0x6d/0x80
[  106.544599]  <EOI> 

[  106.544601]  [<ffffffff81246036>] ? kernfs_put+0x106/0x1d0
[  106.544603]  [<ffffffff816a51c3>] ? _raw_spin_lock+0x13/0x30
[  106.544605]  [<ffffffff811e78d6>] shrink_dentry_list+0x26/0x110
[  106.544606]  [<ffffffff811e81c4>] check_submounts_and_drop+0x74/0xa0
[  106.544608]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544610]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544612]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544614]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  106.544616]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  106.544618]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544619]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  106.544621]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544623]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544625]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544627]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544629]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544631]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544633]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544634] Code: 89 e5 ff 15 c9 1b 96 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 60 3e 01 00 <48> 89 e5 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 90 1b 96 
[  106.544654] NMI backtrace for cpu 7
[  106.544656] CPU: 7 PID: 1666 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544657] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544659] task: ffff880472f45d20 ti: ffff8804740d4000 task.ti: ffff8804740d4000
[  106.544660] RIP: 0010:[<ffffffff816a51d1>]  [<ffffffff816a51d1>] _raw_spin_lock+0x21/0x30
[  106.544662] RSP: 0018:ffff8804740d5bb0  EFLAGS: 00000297
[  106.544663] RAX: 00000000000000cd RBX: ffff880477b925e0 RCX: ffff880477b92598
[  106.544664] RDX: 00000000000000ce RSI: ffff88006387da80 RDI: ffff88006387de98
[  106.544665] RBP: ffff8804740d5bb0 R08: ffff8804740d4000 R09: 0000000000000001
[  106.544666] R10: dfed4b1078bd05a0 R11: 0000000000000304 R12: ffff88006387de40
[  106.544667] R13: ffff88006387de98 R14: ffff880477b92540 R15: ffff88006387ded0
[  106.544668] FS:  00007fdbfb7de880(0000) GS:ffff88048f3c0000(0000) knlGS:0000000000000000
[  106.544670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544671] CR2: 00007f32dce61000 CR3: 0000000470d5f000 CR4: 00000000001407e0
[  106.544671] Stack:
[  106.544672]  ffff8804740d5c30 ffffffff811e7e0f ffffffff811e7440 01ffffff816a1d2a
[  106.544674]  ffff880477b92598 ffff880477b92598 ffff880477b92540 ffff88006387de10
[  106.544676]  ffffffff811e6eb0 ffff8804740d5c40 0000053a00000000 ffff8804740d5c48
[  106.544678] Call Trace:
[  106.544679]  [<ffffffff811e7e0f>] d_walk+0xcf/0x280
[  106.544681]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  106.544684]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  106.544685]  [<ffffffff811e81b2>] check_submounts_and_drop+0x62/0xa0
[  106.544687]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544689]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544691]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544693]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  106.544695]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  106.544697]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544699]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  106.544701]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544702]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544704]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544706]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544708]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544710]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544712]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544713] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  106.544733] NMI backtrace for cpu 2
[  106.544736] CPU: 2 PID: 1670 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544737] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544739] task: ffff880472f46fc0 ti: ffff880473c6a000 task.ti: ffff880473c6a000
[  106.544740] RIP: 0010:[<ffffffff816a51ce>]  [<ffffffff816a51ce>] _raw_spin_lock+0x1e/0x30
[  106.544743] RSP: 0018:ffff880473c6bbb0  EFLAGS: 00000287
[  106.544744] RAX: 00000000000000ad RBX: ffff880473c6bc48 RCX: ffffffff811e7440
[  106.544745] RDX: 00000000000000b1 RSI: ffff880473c6bc40 RDI: ffff880477b92598
[  106.544746] RBP: ffff880473c6bbb0 R08: ffff880473c6a000 R09: 0000000000000001
[  106.544747] R10: ffffea0011e3c840 R11: ffffffff8144ccd9 R12: ffff880477b92540
[  106.544749] R13: 000000000000001d R14: ffff880473c6be60 R15: 0000000000000001
[  106.544750] FS:  00007fdbfb7de880(0000) GS:ffff88048f280000(0000) knlGS:0000000000000000
[  106.544751] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544752] CR2: 00007fdbfcaa9210 CR3: 0000000473785000 CR4: 00000000001407e0
[  106.544753] Stack:
[  106.544754]  ffff880473c6bc30 ffffffff811e7d9c ffffffff811e7440 0100000000000001
[  106.544756]  ffff880477b92598 ffff880477b92598 ffff880477b92540 ffff880477b925e0
[  106.544758]  ffffffff811e6eb0 ffff880473c6bc40 0000053a00000000 ffff880473c6bc48
[  106.544761] Call Trace:
[  106.544763]  [<ffffffff811e7d9c>] d_walk+0x5c/0x280
[  106.544765]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  106.544767]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  106.544769]  [<ffffffff811e81b2>] check_submounts_and_drop+0x62/0xa0
[  106.544772]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544773]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544775]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544777]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  106.544779]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544781]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  106.544783]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544785]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544787]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544789]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544791]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544794]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544796]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  106.544798]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544799] Code: e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 
[  106.544821] NMI backtrace for cpu 6
[  106.544823] CPU: 6 PID: 1672 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #52
[  106.544824] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544825] task: ffff880472f44a80 ti: ffff880475eb6000 task.ti: ffff880475eb6000
[  106.544826] RIP: 0010:[<ffffffff816a51d1>]  [<ffffffff816a51d1>] _raw_spin_lock+0x21/0x30
[  106.544828] RSP: 0018:ffff880475eb7bb0  EFLAGS: 00000293
[  106.544829] RAX: 00000000000000ad RBX: ffff880475eb7c48 RCX: ffffffff811e7440
[  106.544830] RDX: 00000000000000af RSI: ffff880475eb7c40 RDI: ffff880477b92598
[  106.544831] RBP: ffff880475eb7bb0 R08: ffff880475eb6000 R09: 0000000000000001
[  106.544832] R10: dfed4b2078b905a0 R11: 0000000000000246 R12: ffff880477b92540
[  106.544833] R13: 000000000000001d R14: ffff880475eb7e60 R15: 0000000000000001
[  106.544835] FS:  00007fdbfb7de880(0000) GS:ffff88048f380000(0000) knlGS:0000000000000000
[  106.544836] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544837] CR2: 00007fff80b32100 CR3: 00000004754d0000 CR4: 00000000001407e0
[  106.544838] Stack:
[  106.544838]  ffff880475eb7c30 ffffffff811e7d9c ffffffff811e7440 0100000000000246
[  106.544840]  ffff880477b92598 ffff880477b92598 ffff880477b92540 ffff880477b925e0
[  106.544842]  ffffffff811e6eb0 ffff880475eb7c40 0000053a00000000 ffff880475eb7c48
[  106.544844] Call Trace:
[  106.544846]  [<ffffffff811e7d9c>] d_walk+0x5c/0x280
[  106.544848]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  106.544850]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  106.544852]  [<ffffffff811e81b2>] check_submounts_and_drop+0x62/0xa0
[  106.544854]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  106.544856]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  106.544857]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  106.544860]  [<ffffffff81161d0a>] ? unlock_page+0x2a/0x40
[  106.544862]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  106.544863]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  106.544865]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  106.544867]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  106.544869]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  106.544871]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  106.544873]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  106.544875]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  106.544877]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  106.544877] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  106.544898] NMI backtrace for cpu 0
[  106.544900] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G          I   3.15.0-rc7 #52
[  106.544901] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  106.544902] task: ffffffff81c16460 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[  106.544903] RIP: 0010:[<ffffffff8139d5fa>]  [<ffffffff8139d5fa>] intel_idle+0xda/0x160
[  106.544906] RSP: 0018:ffffffff81c01e60  EFLAGS: 00000046
[  106.544907] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  106.544908] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000000
[  106.544909] RBP: ffffffff81c01e88 R08: 00000000ffffffff R09: 0000000000001aaf
[  106.544910] R10: 00000000000019f4 R11: 0000000000000008 R12: 0000000000000005
[  106.544911] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  106.544912] FS:  0000000000000000(0000) GS:ffff88048f200000(0000) knlGS:0000000000000000
[  106.544914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.544915] CR2: 00007f826c8621d0 CR3: 0000000001c0f000 CR4: 00000000001407f0
[  106.544915] Stack:
[  106.544916]  0000000081c01e88 ffff88048f21a840 ffffffff81c9c9a0 00000018b97a1ee6
[  106.544918]  0000000000000005 ffffffff81c01ec0 ffffffff815463b0 ffffffff81cfdb30
[  106.544920]  ffff88048f21a840 ffffffff81c9c9a0 ffffffff81c01fd8 ffffffff81c00000
[  106.544922] Call Trace:
[  106.544925]  [<ffffffff815463b0>] cpuidle_enter_state+0x40/0xc0
[  106.544927]  [<ffffffff81546467>] cpuidle_enter+0x17/0x20
[  106.544929]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  106.544932]  [<ffffffff81690127>] rest_init+0x77/0x80
[  106.544935]  [<ffffffff81d21f2d>] start_kernel+0x3fa/0x405
[  106.544937]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[  106.544939]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[  106.544941]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[  106.544942]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[  106.544943] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  106.545263] INFO: rcu_sched detected stalls on CPUs/tasks: { 5} (detected by 0, t=60002 jiffies, g=1126, c=1125, q=9446)
