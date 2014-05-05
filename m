Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaEESFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:05:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:42277 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaEESFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,990,1389772800"; 
   d="scan'208";a="533866864"
Date: Mon, 5 May 2014 21:05:30 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [regression 3.15-rc3] Resume from s4 broken by
 1f81b6d22a5980955b01e08cf27fb745dc9b686f
Message-ID: <20140505180530.GA18465@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

My IVB machine can no longer resume from S4. I bisected the problem down
to this commit:

commit 1f81b6d22a5980955b01e08cf27fb745dc9b686f
Author: Julius Werner <jwerner@chromium.org>
Date:   Fri Apr 25 19:20:13 2014 +0300

    usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb


The machine has the following USB controllers:

00:14.0 0c03: 8086:1e31 (rev 04) (prog-if 30 [XHCI])
	Subsystem: 8086:2040
	Flags: bus master, medium devsel, latency 0, IRQ 44
	Memory at f7f20000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [70] Power Management version 2
	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
	Kernel driver in use: xhci_hcd

00:1a.0 0c03: 8086:1e2d (rev 04) (prog-if 20 [EHCI])
	Subsystem: 8086:2040
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at f7f38000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci-pci

00:1d.0 0c03: 8086:1e26 (rev 04) (prog-if 20 [EHCI])
	Subsystem: 8086:2040
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f7f37000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci-pci

04:00.0 0c03: 1033:0194 (rev 04) (prog-if 30 [XHCI])
	Subsystem: 8086:2040
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f7d00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [50] Power Management version 3
	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150] Latency Tolerance Reporting
	Kernel driver in use: xhci_hcd


And here's a dmesg across from boot+hibernate+resume with v3.15-rc4
with the bad commit reverted:

[    0.000000] Linux version 3.15.0-rc4-hang+ (user@ivybridge) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #15 SMP PREEMPT Mon May 5 20:57:52 EEST 2014
[    0.000000] Command line: root=/dev/sda1 resume=/dev/sda3 video=VGA-1:d drm.debug=0 i915.enable_cmd_parser=0 i915.enable_ppgtt=1
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d9b28fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9b29000-0x00000000da277fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da278000-0x00000000da287fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da288000-0x00000000da398fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da399000-0x00000000da68afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da68b000-0x00000000da68bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da68c000-0x00000000da6cefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da6cf000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /DZ77BH-55K, BIOS BHZ7710H.86A.0100.2013.0517.0942 05/17/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024b7000, 0x024b7fff] PGTABLE
[    0.000000] BRK [0x024b8000, 0x024b8fff] PGTABLE
[    0.000000] BRK [0x024b9000, 0x024b9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x024ba000, 0x024bafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x024bb000, 0x024bbfff] PGTABLE
[    0.000000] BRK [0x024bc000, 0x024bcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xd9b28fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xd99fffff] page 2M
[    0.000000]  [mem 0xd9a00000-0xd9b28fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda68b000-0xda68bfff]
[    0.000000]  [mem 0xda68b000-0xda68bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda6cf000-0xdaffffff]
[    0.000000]  [mem 0xda6cf000-0xda7fffff] page 4k
[    0.000000]  [mem 0xda800000-0xdaffffff] page 2M
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000DA27C070 000064 (v01 INTEL  DZ77BH   01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DA285E78 00010C (v05 INTEL  DZ77BH   01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DA27C168 009D0C (v02 INTEL  DZ77BH   00000100 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000DA397080 000040
[    0.000000] ACPI: APIC 0x00000000DA285F88 000092 (v03 INTEL  DZ77BH   01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DA286020 000044 (v01 INTEL  DZ77BH   01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000DA286068 00003C (v01 INTEL  DZ77BH   01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DA2860A8 000038 (v01 INTEL  DZ77BH   01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DA2860E0 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DA286450 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DA286E00 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ac00000-ffff88011ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd9b28fff]
[    0.000000]   node   0: [mem 0xda68b000-0xda68bfff]
[    0.000000]   node   0: [mem 0xda6cf000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 1021942
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13898 pages used for memmap
[    0.000000]   DMA32 zone: 889434 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
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
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd9b29000-0xda277fff]
[    0.000000] PM: Registered nosave memory: [mem 0xda278000-0xda287fff]
[    0.000000] PM: Registered nosave memory: [mem 0xda288000-0xda398fff]
[    0.000000] PM: Registered nosave memory: [mem 0xda399000-0xda68afff]
[    0.000000] PM: Registered nosave memory: [mem 0xda68c000-0xda6cefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdb7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011f200000 s82688 r8192 d23808 u262144
[    0.000000] pcpu-alloc: s82688 r8192 d23808 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1005951
[    0.000000] Kernel command line: root=/dev/sda1 resume=/dev/sda3 video=VGA-1:d drm.debug=0 i915.enable_cmd_parser=0 i915.enable_ppgtt=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3927512K/4087768K available (5190K kernel code, 762K rwdata, 2248K rodata, 1016K init, 9164K bss, 160256K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3491.869 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6983.73 BogoMIPS (lpj=3491869)
[    0.000139] pid_max: default: 32768 minimum: 301
[    0.000265] ACPI: Core revision 20140214
[    0.188806] ACPI: All ACPI Tables successfully acquired
[    0.192441] Security Framework initialized
[    0.192570] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.192640] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.193907] CPU: Physical Processor ID: 0
[    0.193976] CPU: Processor Core ID: 0
[    0.194044] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.194398] mce: CPU supports 9 MCE banks
[    0.194477] CPU0: Thermal monitoring enabled (TM1)
[    0.194552] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 2
[    0.194822] Freeing SMP alternatives memory: 16K (ffffffff81bbe000 - ffffffff81bc2000)
[    0.194958] ftrace: allocating 19283 entries in 76 pages
[    0.202341] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.212422] smpboot: CPU0: Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz (fam: 06, model: 3a, stepping: 09)
[    0.212677] TSC deadline timer enabled
[    0.212688] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.213027] ... version:                3
[    0.213110] ... bit width:              48
[    0.213196] ... generic registers:      4
[    0.213282] ... value mask:             0000ffffffffffff
[    0.213370] ... max period:             0000ffffffffffff
[    0.213459] ... fixed-purpose events:   3
[    0.213544] ... event mask:             000000070000000f
[    0.220012] x86: Booting SMP configuration:
[    0.221285] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.328899] x86: Booted up 1 node, 8 CPUs
[    0.329070] smpboot: Total of 8 processors activated (55869.90 BogoMIPS)
[    0.335654] devtmpfs: initialized
[    0.337642] PM: Registering ACPI NVS region [mem 0xda288000-0xda398fff] (1118208 bytes)
[    0.338459] PM: Registering ACPI NVS region [mem 0xda68c000-0xda6cefff] (274432 bytes)
[    0.339234] kworker/u16:0 (42) used greatest stack depth: 5408 bytes left
[    0.343771] NET: Registered protocol family 16
[    0.344970] cpuidle: using governor ladder
[    0.345058] cpuidle: using governor menu
[    0.345270] ACPI: bus type PCI registered
[    0.345355] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.346028] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.346165] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.352166] PCI: Using configuration type 1 for base access
[    0.354204] kworker/u16:0 (65) used greatest stack depth: 4976 bytes left
[    0.369734] ACPI: Added _OSI(Module Device)
[    0.369820] ACPI: Added _OSI(Processor Device)
[    0.369909] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.369997] ACPI: Added _OSI(Processor Aggregator Device)
[    0.383882] ACPI: Executed 1 blocks of module-level executable AML code
[    0.470786] ACPI: SSDT 0x00000000DA225018 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.474045] ACPI: Dynamic OEM Table Load:
[    0.474207] ACPI: SSDT 0x0000000000000000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.482435] ACPI: SSDT 0x00000000DA226A98 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.489916] ACPI: Dynamic OEM Table Load:
[    0.490082] ACPI: SSDT 0x0000000000000000 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.494165] ACPI: SSDT 0x00000000DA227C18 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.497506] ACPI: Dynamic OEM Table Load:
[    0.497668] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.536743] ACPI: Interpreter enabled
[    0.536847] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.537074] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.537374] ACPI: (supports S0 S3 S4 S5)
[    0.537461] ACPI: Using IOAPIC for interrupt routing
[    0.537873] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.721185] ACPI: Power Resource [FN00] (off)
[    0.723135] ACPI: Power Resource [FN01] (off)
[    0.725016] ACPI: Power Resource [FN02] (off)
[    0.726888] ACPI: Power Resource [FN03] (off)
[    0.728744] ACPI: Power Resource [FN04] (off)
[    0.740553] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.740664] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.759606] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.778018] PCI host bridge to bus 0000:00
[    0.778112] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.778205] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.778300] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.778392] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.778485] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.778578] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.778671] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.778766] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.778861] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.778955] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.779052] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.779164] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.780769] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.780782] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.780789] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.780794] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.782496] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.782523] pci 0000:00:14.0: reg 0x10: [mem 0xf7f20000-0xf7f2ffff 64bit]
[    0.782606] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.783827] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.784574] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.784601] pci 0000:00:16.0: reg 0x10: [mem 0xf7f3b000-0xf7f3b00f 64bit]
[    0.784687] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.786387] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.786408] pci 0000:00:19.0: reg 0x10: [mem 0xf7f00000-0xf7f1ffff]
[    0.786419] pci 0000:00:19.0: reg 0x14: [mem 0xf7f39000-0xf7f39fff]
[    0.786429] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.786503] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.787692] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.788443] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.788469] pci 0000:00:1a.0: reg 0x10: [mem 0xf7f38000-0xf7f383ff]
[    0.788573] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.790024] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.790768] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.790788] pci 0000:00:1b.0: reg 0x10: [mem 0xf7f30000-0xf7f33fff 64bit]
[    0.790886] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.792085] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.792833] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.792935] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.794177] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.794927] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.795031] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.796254] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.797003] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.797103] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.798323] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.799076] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.799102] pci 0000:00:1d.0: reg 0x10: [mem 0xf7f37000-0xf7f373ff]
[    0.799205] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.800677] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.801417] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
[    0.803166] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.803189] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.803199] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.803208] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.803217] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.803226] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.803236] pci 0000:00:1f.2: reg 0x24: [mem 0xf7f36000-0xf7f367ff]
[    0.803290] pci 0000:00:1f.2: PME# supported from D3hot
[    0.805047] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.805066] pci 0000:00:1f.3: reg 0x10: [mem 0xf7f35000-0xf7f350ff 64bit]
[    0.805091] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.807195] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.807892] pci 0000:02:00.0: [1283:8892] type 01 class 0x060401
[    0.808104] pci 0000:02:00.0: supports D1 D2
[    0.808105] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.808440] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.809248] pci 0000:00:1c.2: PCI bridge to [bus 02-03]
[    0.809342] pci 0000:00:1c.2:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.810071] pci 0000:03:02.0: [104c:8023] type 00 class 0x0c0010
[    0.810121] pci 0000:03:02.0: reg 0x10: [mem 0xf7e04000-0xf7e047ff]
[    0.810147] pci 0000:03:02.0: reg 0x14: [mem 0xf7e00000-0xf7e03fff]
[    0.810346] pci 0000:03:02.0: supports D1 D2
[    0.810347] pci 0000:03:02.0: PME# supported from D0 D1 D2 D3hot
[    0.811304] pci 0000:02:00.0: PCI bridge to [bus 03] (subtractive decode)
[    0.811415] pci 0000:02:00.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.811435] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.811441] pci 0000:02:00.0:   bridge window [mem 0xf7e00000-0xf7efffff] (subtractive decode)
[    0.811449] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.811456] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.812019] pci 0000:04:00.0: [1033:0194] type 00 class 0x0c0330
[    0.812052] pci 0000:04:00.0: reg 0x10: [mem 0xf7d00000-0xf7d01fff 64bit]
[    0.812292] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.812561] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.814629] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.814724] pci 0000:00:1c.4:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.814759] pci_bus 0000:00: on NUMA node 0
[    0.822660] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.824386] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.826228] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.827944] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.829671] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.831378] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.833216] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.834940] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.837244] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.838183] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.838322] vgaarb: loaded
[    0.838406] vgaarb: bridge control possible 0000:00:02.0
[    0.839387] SCSI subsystem initialized
[    0.839689] libata version 3.00 loaded.
[    0.839752] ACPI: bus type USB registered
[    0.840123] usbcore: registered new interface driver usbfs
[    0.840355] usbcore: registered new interface driver hub
[    0.840563] usbcore: registered new device driver usb
[    0.840922] pps_core: LinuxPPS API ver. 1 registered
[    0.841010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.841185] PTP clock support registered
[    0.841429] PCI: Using ACPI for IRQ routing
[    0.843206] PCI: pci_cache_line_size set to 64 bytes
[    0.843276] e820: reserve RAM buffer [mem 0x0009d400-0x0009ffff]
[    0.843287] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.843294] e820: reserve RAM buffer [mem 0xd9b29000-0xdbffffff]
[    0.843299] e820: reserve RAM buffer [mem 0xda68c000-0xdbffffff]
[    0.843305] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.843312] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    0.845129] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.845564] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.847696] Switched to clocksource hpet
[    0.914594] pnp: PnP ACPI init
[    0.914824] ACPI: bus type PNP registered
[    0.915723] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.915857] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.915970] pnp 00:01: [dma 4]
[    0.916271] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.916649] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.918068] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.918599] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.918720] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.918817] system 00:04: [io  0xffff] has been reserved
[    0.918914] system 00:04: [io  0xffff] has been reserved
[    0.919022] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.919120] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.919220] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.919320] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.919413] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.919807] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.920589] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.920698] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.922195] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.922292] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.926417] pnp 00:08: [dma 0 disabled]
[    0.926827] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.928497] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.928595] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.928985] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.933730] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.933836] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.933936] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.934035] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.934136] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.934236] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.934336] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.934437] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.934534] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.934652] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.934751] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.934842] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.938114] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.938219] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.938311] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.938555] pnp: PnP ACPI: found 13 devices
[    0.938655] ACPI: bus type PNP unregistered
[    0.962322] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.962425] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.962521] pci 0000:02:00.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.962641] pci 0000:00:1c.2: PCI bridge to [bus 02-03]
[    0.962732] pci 0000:00:1c.2:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.962831] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.962922] pci 0000:00:1c.4:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.963019] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.963020] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.963022] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.963023] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.963025] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.963026] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.963027] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.963029] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.963030] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.963032] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.963033] pci_bus 0000:02: resource 1 [mem 0xf7e00000-0xf7efffff]
[    0.963035] pci_bus 0000:03: resource 1 [mem 0xf7e00000-0xf7efffff]
[    0.963036] pci_bus 0000:03: resource 5 [mem 0xf7e00000-0xf7efffff]
[    0.963038] pci_bus 0000:04: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    0.963154] NET: Registered protocol family 2
[    0.963737] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.963917] TCP bind hash table entries: 32768 (order: 9, 2097152 bytes)
[    0.965382] TCP: Hash tables configured (established 32768 bind 32768)
[    0.965521] TCP: reno registered
[    0.965623] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.965896] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.966478] NET: Registered protocol family 1
[    0.966604] pci 0000:00:02.0: Boot video device
[    1.011075] PCI: CLS 64 bytes, default 64
[    1.011389] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.011480] software IO TLB [mem 0xd5b29000-0xd9b29000] (64MB) mapped at [ffff8800d5b29000-ffff8800d9b28fff]
[    1.016395] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    1.017124] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x17
[    1.017259] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x17
[    1.017390] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x17
[    1.017520] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x17
[    1.017659] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x17
[    1.017790] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x17
[    1.017925] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x17
[    1.018055] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x17
[    1.018481] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.023275] Scanning for low memory corruption every 60 seconds
[    1.026522] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    1.026770] audit: initializing netlink subsys (disabled)
[    1.026953] audit: type=2000 audit(1399312746.003:1): initialized
[    1.028913] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.082197] msgmni has been set to 7670
[    1.083673] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    1.085030] io scheduler noop registered
[    1.085116] io scheduler deadline registered
[    1.086079] io scheduler cfq registered (default)
[    1.088686] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.091100] pcieport 0000:00:1c.2: irq 41 for MSI/MSI-X
[    1.091481] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    1.092127] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    1.092223] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    1.092364] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    1.092456] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    1.092564] pci 0000:03:02.0: Signaling PME through PCIe PME interrupt
[    1.092658] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    1.092797] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    1.092888] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.092982] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    1.093032] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.093363] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.094533] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.094713] ACPI: Power Button [PWRB]
[    1.095379] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.095550] ACPI: Power Button [PWRF]
[    1.096259] ACPI: Fan [FAN0] (off)
[    1.096814] ACPI: Fan [FAN1] (off)
[    1.097345] ACPI: Fan [FAN2] (off)
[    1.097893] ACPI: Fan [FAN3] (off)
[    1.098424] ACPI: Fan [FAN4] (off)
[    1.112969] Monitor-Mwait will be used to enter C-1 state
[    1.113010] Monitor-Mwait will be used to enter C-2 state
[    1.113042] ACPI: acpi_idle registered with cpuidle
[    1.152410] thermal LNXTHERM:00: registered as thermal_zone0
[    1.152514] ACPI: Thermal Zone [TZ00] (28 C)
[    1.158849] thermal LNXTHERM:01: registered as thermal_zone1
[    1.158940] ACPI: Thermal Zone [TZ01] (30 C)
[    1.159421] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.164156] Linux agpgart interface v0.103
[    1.165816] ahci 0000:00:1f.2: version 3.0
[    1.167956] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.178486] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x31 impl SATA mode
[    1.178623] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    1.193440] scsi0 : ahci
[    1.195887] scsi1 : ahci
[    1.197079] scsi2 : ahci
[    1.198239] scsi3 : ahci
[    1.199388] scsi4 : ahci
[    1.200536] scsi5 : ahci
[    1.201509] ata1: SATA max UDMA/133 abar m2048@0xf7f36000 port 0xf7f36100 irq 43
[    1.201643] ata2: DUMMY
[    1.201727] ata3: DUMMY
[    1.201812] ata4: DUMMY
[    1.201898] ata5: SATA max UDMA/133 abar m2048@0xf7f36000 port 0xf7f36300 irq 43
[    1.202032] ata6: SATA max UDMA/133 abar m2048@0xf7f36000 port 0xf7f36380 irq 43
[    1.202548] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.202671] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.204914] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.205093] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    1.470304] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.470406] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:22:4d:7f:86:a9
[    1.470544] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.470665] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    1.471067] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.471169] ehci-pci: EHCI PCI platform driver
[    1.473343] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.473543] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.473709] ehci-pci 0000:00:1a.0: debug port 2
[    1.477743] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.477865] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7f38000
[    1.483235] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.485573] hub 1-0:1.0: USB hub found
[    1.485738] hub 1-0:1.0: 2 ports detected
[    1.490688] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.490813] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.490967] ehci-pci 0000:00:1d.0: debug port 2
[    1.494972] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.495080] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7f37000
[    1.501207] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.503174] hub 2-0:1.0: USB hub found
[    1.503332] hub 2-0:1.0: 2 ports detected
[    1.506130] uhci_hcd: USB Universal Host Controller Interface driver
[    1.506204] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.509098] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.509238] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.509573] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.509637] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[    1.512914] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.513053] ata6: SATA link down (SStatus 0 SControl 300)
[    1.513174] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.513177] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.513316] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.514439] hub 3-0:1.0: USB hub found
[    1.514615] hub 3-0:1.0: 4 ports detected
[    1.521453] ata1.00: ATA-9: INTEL SSDSC2CW240A3, 400i, max UDMA/133
[    1.521551] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.523913] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.523916] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.524058] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.524462] ata5.00: ATAPI: ATAPI   iHAS124   C, LL08, max UDMA/100
[    1.536193] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.536197] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.536339] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.536514] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.536517] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.536653] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.540226] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.540333] ata5.00: configured for UDMA/100
[    1.540340] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.542418] hub 4-0:1.0: USB hub found
[    1.542581] hub 4-0:1.0: 4 ports detected
[    1.547472] ata1.00: configured for UDMA/133
[    1.548175] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW24 400i PQ: 0 ANSI: 5
[    1.550503] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/223 GiB)
[    1.551138] sd 0:0:0:0: [sda] Write Protect is off
[    1.551236] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.551422] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.552683] scsi 4:0:0:0: CD-ROM            ATAPI    iHAS124   C      LL08 PQ: 0 ANSI: 5
[    1.553958]  sda: sda1 sda2 sda3
[    1.556417] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    1.556593] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 5
[    1.557266] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
[    1.557301] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[    1.557334] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[    1.557368] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
[    1.557401] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
[    1.557435] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
[    1.557468] xhci_hcd 0000:04:00.0: irq 52 for MSI/MSI-X
[    1.557501] xhci_hcd 0000:04:00.0: irq 53 for MSI/MSI-X
[    1.558830] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.561044] hub 5-0:1.0: USB hub found
[    1.561240] hub 5-0:1.0: 2 ports detected
[    1.562836] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    1.562941] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 6
[    1.565128] hub 6-0:1.0: USB hub found
[    1.565304] hub 6-0:1.0: 2 ports detected
[    1.567431] usbcore: registered new interface driver usb-storage
[    1.567795] usbcore: registered new interface driver usbserial
[    1.568219] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.572026] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.572614] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.573449] mousedev: PS/2 mouse device common for all mice
[    1.573892] rtc_cmos 00:05: RTC can wake from S4
[    1.574747] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.574906] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.575157] TCP: cubic registered
[    1.575248] NET: Registered protocol family 17
[    1.579882] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.579895] registered taskstats version 1
[    1.580131] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.582355] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    1.582917] console [netcon0] enabled
[    1.583005] netconsole: network logging started
[    1.583186] rtc_cmos 00:05: setting system clock to 2014-05-05 17:59:07 UTC (1399312747)
[    1.617918] EXT3-fs (sda1): error: couldn't mount because of unsupported optional features (240)
[    1.619120] EXT2-fs (sda1): error: couldn't mount because of unsupported optional features (240)
[    1.633775] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.633949] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.634777] Freeing unused kernel memory: 1016K (ffffffff81ac0000 - ffffffff81bbe000)
[    1.634916] Write protecting the kernel read-only data: 10240k
[    1.636724] Freeing unused kernel memory: 944K (ffff880001514000 - ffff880001600000)
[    1.639688] Freeing unused kernel memory: 1848K (ffff880001832000 - ffff880001a00000)
[    1.772520] kbd_mode (895) used greatest stack depth: 4760 bytes left
[    1.789029] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.795423] loadkeys (897) used greatest stack depth: 4040 bytes left
[    1.796143] init-early.sh (894) used greatest stack depth: 3504 bytes left
[    1.911440] hub 1-1:1.0: USB hub found
[    1.911830] hub 1-1:1.0: 6 ports detected
[    2.012859] tsc: Refined TSC clocksource calibration: 3492.067 MHz
[    2.026833] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.144378] hub 2-1:1.0: USB hub found
[    2.144754] hub 2-1:1.0: 8 ports detected
[    2.318654] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[    2.445400] random: nonblocking pool is initialized
[    2.486812] hub 3-1:1.0: USB hub found
[    2.487152] hub 3-1:1.0: 4 ports detected
[    2.524369] sort (1046) used greatest stack depth: 3392 bytes left
[    2.705481] systemd-udevd[1081]: starting version 208
[    2.765454] usb 3-1.1: new low-speed USB device number 3 using xhci_hcd
[    2.834019] wmi: Mapper loaded
[    2.866980] usb 3-1.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.935317] usb 3-1.2: new low-speed USB device number 4 using xhci_hcd
[    2.936803] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    2.936814] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.948887] [drm] Initialized drm 1.1.0 20060810
[    2.965113] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    3.012255] Switched to clocksource tsc
[    3.012890] AVX version of gcm_enc/dec engaged.
[    3.017036] usb 3-1.2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    3.017325] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.017436] snd_hda_intel 0000:00:1b.0: irq 54 for MSI/MSI-X
[    3.017495] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    3.019431] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.045840] sound hdaudioC0D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    3.045844] sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.045845] sound hdaudioC0D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.045846] sound hdaudioC0D2:    mono: mono_out=0x0
[    3.045848] sound hdaudioC0D2:    dig-out=0x11/0x1e
[    3.045849] sound hdaudioC0D2:    inputs:
[    3.045850] sound hdaudioC0D2:      Front Mic=0x19
[    3.045852] sound hdaudioC0D2:      Rear Mic=0x18
[    3.045853] sound hdaudioC0D2:      Line=0x1a
[    3.077131] usbcore: registered new interface driver usbhid
[    3.077135] usbhid: USB HID core driver
[    3.079857] [drm] Memory usable by graphics device = 2048M
[    3.083019] input: CHICONY HP Basic USB Keyboard as /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1.1/3-1.1:1.0/0003:03F0:0024.0001/input/input15
[    3.084162] hid-generic 0003:03F0:0024.0001: input: USB HID v1.10 Keyboard [CHICONY HP Basic USB Keyboard] on usb-0000:00:14.0-1.1/input0
[    3.085498] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1.2/3-1.2:1.0/0003:046D:C03D.0002/input/input16
[    3.086841] hid-generic 0003:046D:C03D.0002: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:14.0-1.2/input0
[    3.094638] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    3.096082] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    3.097417] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    3.099154] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    3.100686] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    3.102066] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    3.103135] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    3.104244] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    3.105319] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    3.129902] i915 0000:00:02.0: irq 55 for MSI/MSI-X
[    3.130009] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.130011] [drm] Driver supports precise vblank timestamp query.
[    3.131696] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.145731] [drm] forcing VGA-1 connector OFF
[    3.220280] fbcon: inteldrmfb (fb0) is primary device
[    3.355017] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[    3.380396] Console: switching to colour frame buffer device 240x67
[    3.385079] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.385080] i915 0000:00:02.0: registered panic notifier
[    3.406063] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.412915] acpi device:4c: registered as cooling_device13
[    3.415258] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input17
[    3.416377] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.481630] EXT4-fs (sda1): warning: maximal mount count reached, running e2fsck is recommended
[    4.481924] EXT4-fs (sda1): re-mounted. Opts: data=ordered,commit=0
[    4.523233] mount (1250) used greatest stack depth: 3360 bytes left
[    4.722981] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    5.620454] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x17
[    5.620938] microcode: CPU0 updated to revision 0x19, date = 2013-06-13
[    5.621213] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x17
[    5.621439] microcode: CPU1 updated to revision 0x19, date = 2013-06-13
[    5.621732] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x17
[    5.621949] microcode: CPU2 updated to revision 0x19, date = 2013-06-13
[    5.622250] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x17
[    5.622468] microcode: CPU3 updated to revision 0x19, date = 2013-06-13
[    5.622759] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x17
[    5.622976] microcode: CPU4 updated to revision 0x19, date = 2013-06-13
[    5.623248] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x17
[    5.623466] microcode: CPU5 updated to revision 0x19, date = 2013-06-13
[    5.623760] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x17
[    5.623977] microcode: CPU6 updated to revision 0x19, date = 2013-06-13
[    5.624283] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x17
[    5.624500] microcode: CPU7 updated to revision 0x19, date = 2013-06-13
[    7.231335] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    7.332944] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    8.167408] EXT4-fs (sda1): re-mounted. Opts: data=ordered,commit=0
[    8.243927] udevd (1118) used greatest stack depth: 2944 bytes left
[    9.963174] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   23.630734] Adding 14229076k swap on /dev/sda3.  Priority:-1 extents:1 across:14229076k SS
[   24.536584] PM: Syncing filesystems ... done.
[   24.544928] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   24.547994] PM: Preallocating image memory... done (allocated 98806 pages)
[   24.637941] PM: Allocated 395224 kbytes in 0.09 seconds (4391.37 MB/s)
[   24.637943] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   24.639846] Suspending console(s) (use no_console_suspend to debug)
[   24.645241] serial 00:08: disabled
[   24.690768] PM: freeze of devices complete after 50.932 msecs
[   24.694229] PM: late freeze of devices complete after 3.459 msecs
[   24.697960] PM: noirq freeze of devices complete after 3.731 msecs
[   24.698664] ACPI: Preparing to enter system sleep state S4
[   24.708020] PM: Saving platform NVS memory
[   24.717938] Disabling non-boot CPUs ...
[   24.721634] kvm: disabling virtualization on CPU1
[   24.721666] smpboot: CPU 1 is now offline
[   24.725525] kvm: disabling virtualization on CPU2
[   24.725535] smpboot: CPU 2 is now offline
[   24.727938] kvm: disabling virtualization on CPU3
[   24.727949] smpboot: CPU 3 is now offline
[   24.730338] kvm: disabling virtualization on CPU4
[   24.730618] smpboot: CPU 4 is now offline
[   24.733037] kvm: disabling virtualization on CPU5
[   24.733044] smpboot: CPU 5 is now offline
[   24.735259] kvm: disabling virtualization on CPU6
[   24.735708] smpboot: CPU 6 is now offline
[   24.738993] kvm: disabling virtualization on CPU7
[   24.739000] smpboot: CPU 7 is now offline
[   24.739928] PM: Creating hibernation image:
[   24.779968] PM: Need to copy 96926 pages
[   24.741612] PM: Restoring platform NVS memory
[   24.742154] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x19
[   24.742543] Enabling non-boot CPUs ...
[   24.743781] x86: Booting SMP configuration:
[   24.743783] smpboot: Booting Node 0 Processor 1 APIC 0x2
[   24.755309] CPU1 microcode updated early to revision 0x19, date = 2013-06-13
[   24.755965] kvm: enabling virtualization on CPU1
[   24.760122] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x19
[   24.766521] CPU1 is up
[   24.766898] smpboot: Booting Node 0 Processor 2 APIC 0x4
[   24.777975] CPU2 microcode updated early to revision 0x19, date = 2013-06-13
[   24.778653] kvm: enabling virtualization on CPU2
[   24.782680] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x19
[   24.788945] CPU2 is up
[   24.789301] smpboot: Booting Node 0 Processor 3 APIC 0x6
[   24.800168] CPU3 microcode updated early to revision 0x19, date = 2013-06-13
[   24.800959] kvm: enabling virtualization on CPU3
[   24.805187] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x19
[   24.811670] CPU3 is up
[   24.812035] smpboot: Booting Node 0 Processor 4 APIC 0x1
[   24.823325] CPU4 microcode updated early to revision 0x19, date = 2013-06-13
[   24.824204] kvm: enabling virtualization on CPU4
[   24.828543] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x19
[   24.835023] CPU4 is up
[   24.835395] smpboot: Booting Node 0 Processor 5 APIC 0x3
[   24.847040] kvm: enabling virtualization on CPU5
[   24.851461] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x19
[   24.857950] CPU5 is up
[   24.858311] smpboot: Booting Node 0 Processor 6 APIC 0x5
[   24.870125] kvm: enabling virtualization on CPU6
[   24.874692] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x19
[   24.881215] CPU6 is up
[   24.881577] smpboot: Booting Node 0 Processor 7 APIC 0x7
[   24.893252] kvm: enabling virtualization on CPU7
[   24.897902] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x19
[   24.904534] CPU7 is up
[   24.916982] ACPI: Waking up from system sleep state S4
[   24.948875] PM: noirq restore of devices complete after 10.930 msecs
[   24.951295] PM: early restore of devices complete after 2.266 msecs
[   25.029103] usb usb3: root hub lost power or was reset
[   25.029104] usb usb4: root hub lost power or was reset
[   25.029128] usb usb1: root hub lost power or was reset
[   25.029330] xhci_hcd 0000:00:14.0: Slot 1 endpoint 2 not removed from BW list!
[   25.029387] xhci_hcd 0000:00:14.0: Slot 2 endpoint 2 not removed from BW list!
[   25.029437] xhci_hcd 0000:00:14.0: Slot 3 endpoint 2 not removed from BW list!
[   25.029877] xhci_hcd 0000:00:14.0: irq 44 for MSI/MSI-X
[   25.030266] usb usb2: root hub lost power or was reset
[   25.031696] usb usb5: root hub lost power or was reset
[   25.031698] usb usb6: root hub lost power or was reset
[   25.032889] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   25.033038] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   25.033646] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
[   25.033690] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[   25.033730] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[   25.033772] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
[   25.033816] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
[   25.033863] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
[   25.033906] xhci_hcd 0000:04:00.0: irq 52 for MSI/MSI-X
[   25.033950] xhci_hcd 0000:04:00.0: irq 53 for MSI/MSI-X
[   25.034154] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   25.040322] sd 0:0:0:0: [sda] Starting disk
[   25.070535] serial 00:08: activated
[   25.181769] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[   25.189229] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[   25.337040] usb 1-1: reset high-speed USB device number 2 using ehci-pci
[   25.338385] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   25.338437] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   25.340381] ata6: SATA link down (SStatus 0 SControl 300)
[   25.358022] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[   25.358025] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[   25.358028] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[   25.358065] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[   25.358068] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[   25.358070] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[   25.371549] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[   25.371553] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[   25.371555] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[   25.371818] ata5.00: configured for UDMA/100
[   25.388914] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[   25.388917] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[   25.388919] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[   25.398858] ata1.00: configured for UDMA/133
[   25.553456] usb 2-1: reset high-speed USB device number 2 using ehci-pci
[   25.820328] usb 3-1: reset high-speed USB device number 2 using xhci_hcd
[   25.984543] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880119a26cb8
[   26.442097] usb 3-1.2: reset low-speed USB device number 4 using xhci_hcd
[   26.707634] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[   26.708627] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800d320e470
[   26.708682] usb 3-1.2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[   26.959626] usb 3-1.1: reset low-speed USB device number 3 using xhci_hcd
[   27.227518] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800d320c000
[   27.227572] usb 3-1.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[   27.234136] PM: restore of devices complete after 2206.923 msecs
[   27.235131] Restarting tasks ... 
[   27.235727] pci_bus 0000:03: Allocating resources
[   27.235765] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[   27.235772] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[   27.235791] pci 0000:02:00.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   27.235792] pci 0000:02:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   27.235802] pci 0000:02:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   27.235808] pci 0000:02:00.0: BAR 7: can't assign io (size 0x1000)
[   27.235880] pci 0000:02:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   27.235894] pci 0000:02:00.0: BAR 7: can't assign io (size 0x1000)
[   27.235906] pci 0000:02:00.0: PCI bridge to [bus 03]
[   27.235918] pci 0000:02:00.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[   27.236182] done.
[   27.236196] video LNXVIDEO:00: Restoring backlight state
[   28.145896] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

-- 
Ville Syrjälä
Intel OTC
