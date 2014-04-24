Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbaDXTDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:03:16 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:57007 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbaDXTDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:03:09 -0400
Date: Thu, 24 Apr 2014 22:03:04 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc2: longhaul cpufreq stalls tasks for 120s+
In-Reply-To: <5358EBB9.3090809@linux.vnet.ibm.com>
Message-ID: <alpine.SOC.1.00.1404242201190.6086@math.ut.ee>
References: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee> <CAKohpoktwh=SgHTfEgT7vYRVWHssXw7==+a9qAdtmJXepjT2Tw@mail.gmail.com> <alpine.SOC.1.00.1404241316290.13595@math.ut.ee> <5358EBB9.3090809@linux.vnet.ibm.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see traces of mutex_lock_slowpath() etc in your logs.. Can you please
> enable lockdep and sleep-inside-atomic-section check and let us know if
> it complains? Specifically, enable these config options:
> 
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y

At boot, nothing special was in dmesg. After running cpufreq-info (which 
hangs indefinitely), I get the following dmesg with hangs and lock info:

[    0.000000] Linux version 3.15.0-rc2-dirty (mroos@via) (gcc version 4.8.2 (Debian 4.8.2-17) ) #37 Thu Apr 24 16:45:25 EEST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fdeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fdf0000-0x000000000fdf2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000fdf3000-0x000000000fdfffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ffff0000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.2 present.
[    0.000000] DMI: VIA TECHNOLOGIES, INC. EPIA/EPIA, BIOS 6.00 PG 11/02/2004
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfdf0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-F7FFF write-through
[    0.000000]   F8000-F8FFF uncachable
[    0.000000]   F9000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FF0000000 write-back
[    0.000000]   1 base 00FE00000 mask FFFE00000 uncachable
[    0.000000]   2 base 0D0000000 mask FF0000000 write-combining
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x01965000, 0x01965fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x01966000, 0x01966fff] PGTABLE
[    0.000000] BRK [0x01967000, 0x01967fff] PGTABLE
[    0.000000] BRK [0x01968000, 0x01968fff] PGTABLE
[    0.000000] BRK [0x01969000, 0x01969fff] PGTABLE
[    0.000000] BRK [0x0196a000, 0x0196afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fdeffff]
[    0.000000]  [mem 0x0fc00000-0x0fdeffff] page 4k
[    0.000000] ACPI: RSDP 0x000F67C0 000014 (v00 VIA601)
[    0.000000] ACPI: RSDT 0x0FDF3000 000028 (v01 VIA601 AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 0x0FDF3040 000074 (v01 VIA601 AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 0x0FDF30C0 0029BC (v01 VIA601 AWRDACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 0x0FDF0000 000040
[    0.000000] 253MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fdf0000
[    0.000000]   low ram: 0 - 0fdf0000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fdeffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x0fdeffff]
[    0.000000] On node 0 totalpages: 64911
[    0.000000] free_area_init_node: node 0, pgdat c13f45dc, node_mem_map cf9cd020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   Normal zone: 476 pages used for memmap
[    0.000000]   Normal zone: 60912 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] e820: [mem 0x0fe00000-0xfffeffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64403
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.15.0-rc2-dirty root=/dev/sda1 ro longhaul.enable=1
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 247424K/259644K available (2594K kernel code, 246K rwdata, 1224K rodata, 304K init, 5208K bss, 12220K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe4000 - 0xfffff000   ( 108 kB)
[    0.000000]     vmalloc : 0xd05f0000 - 0xfffe2000   ( 761 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfdf0000   ( 253 MB)
[    0.000000]       .init : 0xc13fb000 - 0xc1447000   ( 304 kB)
[    0.000000]       .data : 0xc1288c2d - 0xc13f98e0   (1475 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1288c2d   (2595 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=cf408000 soft=cf40a000
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 533.349 MHz processor
[    0.020278] Calibrating delay loop (skipped), value calculated using timer frequency.. 1066.69 BogoMIPS (lpj=5333490)
[    0.020545] pid_max: default: 32768 minimum: 301
[    0.020838] ACPI: Core revision 20140214
[    0.055942] ACPI: All ACPI Tables successfully acquired
[    0.056182] ACPI: setting ELCR to 0008 (from 1c28)
[    0.058512] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.058665] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.065594] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.065594] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.065594] tlb_flushall_shift: -1
[    0.065922] CPU: Centaur VIA Samuel 2 (fam: 06, model: 07, stepping: 03)
[    0.069539] Performance Events: no PMU driver, software events only.
[    0.075358] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.082209] devtmpfs: initialized
[    0.088781] NET: Registered protocol family 16
[    0.092418] cpuidle: using governor ladder
[    0.092562] cpuidle: using governor menu
[    0.093106] ACPI: bus type PCI registered
[    0.114990] PCI: PCI BIOS revision 2.10 entry at 0xfb3a0, last bus=1
[    0.115148] PCI: Using configuration type 1 for base access
[    0.145538] ACPI: Added _OSI(Module Device)
[    0.145704] ACPI: Added _OSI(Processor Device)
[    0.145842] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.145982] ACPI: Added _OSI(Processor Aggregator Device)
[    0.209723] ACPI: Interpreter enabled
[    0.209945] ACPI: (supports S0 S5)
[    0.210034] ACPI: Using PIC for interrupt routing
[    0.210570] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.277204] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.277418] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.278256] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.279931] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.279964] acpi PNP0A03:00: host bridge window [io  0x0d00-0x3fff] (ignored)
[    0.280055] acpi PNP0A03:00: host bridge window [io  0x4100-0x4fff] (ignored)
[    0.280086] acpi PNP0A03:00: host bridge window [io  0x5010-0x5fff] (ignored)
[    0.280116] acpi PNP0A03:00: host bridge window [io  0x6080-0xffff] (ignored)
[    0.280147] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.280178] acpi PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.280210] acpi PNP0A03:00: host bridge window [mem 0x0fe00000-0xffefffff] (ignored)
[    0.280236] PCI: root bus 00: using default resources
[    0.280592] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.282969] PCI host bridge to bus 0000:00
[    0.283199] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.283347] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.283499] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.284143] pci 0000:00:00.0: [1106:0601] type 00 class 0x060000
[    0.284218] pci 0000:00:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]
[    0.286642] pci 0000:00:01.0: [1106:8601] type 01 class 0x060400
[    0.286926] pci 0000:00:01.0: supports D1
[    0.288418] pci 0000:00:11.0: [1106:8231] type 00 class 0x060100
[    0.290429] pci 0000:00:11.1: [1106:0571] type 00 class 0x01018a
[    0.290696] pci 0000:00:11.1: reg 0x20: [io  0xd000-0xd00f]
[    0.290822] pci 0000:00:11.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.290988] pci 0000:00:11.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.291143] pci 0000:00:11.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.291301] pci 0000:00:11.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.292987] pci 0000:00:11.2: [1106:3038] type 00 class 0x0c0300
[    0.293254] pci 0000:00:11.2: reg 0x20: [io  0xd400-0xd41f]
[    0.294918] pci 0000:00:11.3: [1106:3038] type 00 class 0x0c0300
[    0.295182] pci 0000:00:11.3: reg 0x20: [io  0xd800-0xd81f]
[    0.296819] pci 0000:00:11.4: [1106:8235] type 00 class 0x068000
[    0.298647] pci 0000:00:11.5: [1106:3058] type 00 class 0x040100
[    0.298759] pci 0000:00:11.5: reg 0x10: [io  0xdc00-0xdcff]
[    0.298829] pci 0000:00:11.5: reg 0x14: [io  0xe000-0xe003]
[    0.298899] pci 0000:00:11.5: reg 0x18: [io  0xe400-0xe403]
[    0.300650] pci 0000:00:12.0: [1106:3065] type 00 class 0x020000
[    0.300763] pci 0000:00:12.0: reg 0x10: [io  0xe800-0xe8ff]
[    0.300835] pci 0000:00:12.0: reg 0x14: [mem 0xe4001000-0xe40010ff]
[    0.301156] pci 0000:00:12.0: supports D1 D2
[    0.301185] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.303144] pci 0000:00:14.0: [1317:0985] type 00 class 0x020000
[    0.303256] pci 0000:00:14.0: reg 0x10: [io  0xec00-0xecff]
[    0.303328] pci 0000:00:14.0: reg 0x14: [mem 0xe4000000-0xe40003ff]
[    0.303556] pci 0000:00:14.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.303681] pci 0000:00:14.0: supports D1 D2
[    0.303709] pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.305770] pci 0000:01:00.0: [1023:8500] type 00 class 0x030000
[    0.305895] pci 0000:01:00.0: reg 0x10: [mem 0xe1800000-0xe1ffffff]
[    0.305966] pci 0000:01:00.0: reg 0x14: [mem 0xe2000000-0xe201ffff]
[    0.306038] pci 0000:01:00.0: reg 0x18: [mem 0xe1000000-0xe17fffff]
[    0.306225] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.306382] pci 0000:01:00.0: supports D1 D2
[    0.307522] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.307708] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe2ffffff]
[    0.307780] pci_bus 0000:00: on NUMA node 0
[    0.311382] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
[    0.314106] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
[    0.316913] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
[    0.319713] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
[    0.333991] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.334225] vgaarb: loaded
[    0.334345] vgaarb: bridge control possible 0000:01:00.0
[    0.335884] SCSI subsystem initialized
[    0.336980] libata version 3.00 loaded.
[    0.337820] PCI: Using ACPI for IRQ routing
[    0.337977] PCI: pci_cache_line_size set to 32 bytes
[    0.338235] e820: reserve RAM buffer [mem 0x0fdf0000-0x0fffffff]
[    0.344506] Switched to clocksource pit
[    0.347793] pnp: PnP ACPI init
[    0.348174] ACPI: bus type PNP registered
[    0.348174] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.348174] system 00:00: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.348174] system 00:00: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.348174] system 00:00: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.348174] system 00:00: [mem 0x0fdf0000-0x0fdfffff] could not be reserved
[    0.348174] system 00:00: [mem 0xffff0000-0xffffffff] has been reserved
[    0.348174] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.348251] system 00:00: [mem 0x00100000-0x0fdeffff] could not be reserved
[    0.348416] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.349255] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.352025] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.352208] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.352448] pnp 00:02: [dma 4]
[    0.352967] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.353651] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.354277] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.354912] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.359092] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.362997] pnp 00:07: [dma 3]
[    0.363774] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.364356] pnp: PnP ACPI: found 8 devices
[    0.364494] ACPI: bus type PNP unregistered
[    0.447712] Switched to clocksource acpi_pm
[    0.447994] pci 0000:00:01.0: BAR 9: assigned [mem 0x10000000-0x100fffff pref]
[    0.448218] pci 0000:00:14.0: BAR 6: assigned [mem 0x10100000-0x1011ffff pref]
[    0.448447] pci 0000:01:00.0: BAR 6: assigned [mem 0x10000000-0x1000ffff pref]
[    0.448655] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.448821] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe2ffffff]
[    0.448991] pci 0000:00:01.0:   bridge window [mem 0x10000000-0x100fffff pref]
[    0.449224] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.449255] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.449287] pci_bus 0000:01: resource 1 [mem 0xe0000000-0xe2ffffff]
[    0.449318] pci_bus 0000:01: resource 2 [mem 0x10000000-0x100fffff pref]
[    0.449814] NET: Registered protocol family 2
[    0.453341] TCP established hash table entries: 2048 (order: 1, 8192 bytes)
[    0.453911] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.456853] TCP: Hash tables configured (established 2048 bind 2048)
[    0.457843] TCP: reno registered
[    0.457989] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.458718] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.461816] NET: Registered protocol family 1
[    0.462117] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.467489] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
[    0.467639] PCI: setting IRQ 5 as level-triggered
[    0.471434] pci 0000:01:00.0: Boot video device
[    0.471463] PCI: CLS 32 bytes, default 32
[    0.476562] futex hash table entries: 256 (order: 1, 11264 bytes)
[    0.485735] msgmni has been set to 483
[    0.494199] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.494630] io scheduler noop registered
[    0.494827] io scheduler cfq registered (default)
[    0.535154] Serial: 8250/16550 driver, 16 ports, IRQ sharing disabled
[    0.558976] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.596782] Non-volatile memory driver v1.3
[    0.596939] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.597150] Hangcheck: Using getrawmonotonic().
[    0.598536] pata_via 0000:00:11.1: version 0.3.4
[    0.606195] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0FFFFFFFF) is beyond end of object (length 0x4) (20140214/exoparg2-420)
[    0.606601] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_] (Node cf42bbd0), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
[    0.607058] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0._GTM] (Node cf42b258), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
[    0.607514] ata1: ACPI get timing mode failed (AE 0x300b)
[    0.618009] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0FFFFFFFF) is beyond end of object (length 0x4) (20140214/exoparg2-420)
[    0.618412] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_] (Node cf42bbd0), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
[    0.618872] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1._GTM] (Node cf42b168), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
[    0.619336] ata2: ACPI get timing mode failed (AE 0x300b)
[    0.624406] scsi0 : pata_via
[    0.628635] scsi1 : pata_via
[    0.629938] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xd000 irq 14
[    0.631118] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xd008 irq 15
[    0.633837] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.792381] ata1.00: ATA-6: WDC WD800JB-00FMA0, 13.03G13, max UDMA/100
[    0.792553] ata1.00: 156301488 sectors, multi 16: LBA 
[    0.792716] ata1.00: limited to UDMA/33 due to 40-wire cable
[    0.810758] ata1.00: configured for UDMA/33
[    0.816280] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JB-00FM 13.0 PQ: 0 ANSI: 5
[    0.829232] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    0.830310] sd 0:0:0:0: [sda] Write Protect is off
[    0.830463] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.830755] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.880761] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.884915]  sda: sda1 sda2 < sda5 >
[    0.888172] mousedev: PS/2 mouse device common for all mice
[    0.894199] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    0.895268] rtc_cmos 00:03: RTC can wake from S4
[    0.898022] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.898303] rtc_cmos 00:03: alarms up to one year, y3k, 242 bytes nvram
[    0.906453] hidraw: raw HID events driver (C) Jiri Kosina
[    0.910828] TCP: cubic registered
[    0.910984] NET: Registered protocol family 17
[    0.922152] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.930316] console [netcon0] enabled
[    0.930461] netconsole: network logging started
[    0.930708] rtc_cmos 00:03: setting system clock to 2014-04-24 14:26:24 UTC (1398349584)
[    0.980807] ata2.00: ATAPI: LTN486S, YUS5, max UDMA/33, CDB intr
[    0.981786] ata2.00: configured for UDMA/33
[    0.983434] scsi 1:0:0:0: CD-ROM            LITEON   CD-ROM LTN486S   YUS5 PQ: 0 ANSI: 5
[    1.025141] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    1.028552] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    1.142178] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.142644] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.186162] devtmpfs: mounted
[    1.189976] Freeing unused kernel memory: 304K (c13fb000 - c1447000)
[    1.191963] Write protecting the kernel text: 2596k
[    1.192879] Write protecting the kernel read-only data: 1228k
[    1.640800] tsc: Refined TSC clocksource calibration: 533.352 MHz
[    2.645763] Switched to clocksource tsc
[    3.989907] systemd-udevd[508]: starting version 204
[    4.678557] Linux agpgart interface v0.103
[    4.741938] agpgart: Detected VIA Apollo ProMedia/PLE133Ta chipset
[    4.767336] parport_pc: VIA 686A/8231 detected
[    4.767362] parport_pc: probing current configuration
[    4.767408] parport_pc: Current parallel port base: 0x378
[    4.767847] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[    4.771912] agpgart-via 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.790596] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    4.790874] ACPI: Power Button [PWRB]
[    4.792468] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.792705] ACPI: Power Button [PWRF]
[    4.886093] parport_pc: VIA parallel port: io=0x378, irq=7
[    5.070751] ACPI: Fan [FAN] (on)
[    5.284821] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    5.285002] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.322523] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.529342] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.533144] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.789712] ACPI: bus type USB registered
[    5.790808] usbcore: registered new interface driver usbfs
[    5.791708] usbcore: registered new interface driver hub
[    5.868991] tulip: Linux Tulip driver version 1.1.15-NAPI (Feb 27, 2007)
[    5.876145] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    5.876277] PCI: setting IRQ 11 as level-triggered
[    5.876500] tulip: tulip_init_one: Enabled WOL support for AN983B
[    5.877230] tulip0:  MII transceiver #1 config 1000 status 7849 advertising 05e1
[    5.883533] net eth0: ADMtek Comet rev 17 at MMIO 0xe4000000, 00:10:a7:17:5e:ce, IRQ 11
[    5.915235] usbcore: registered new device driver usb
[    5.928548] via_rhine: v1.10-LK1.5.1 2010-10-09 Written by Donald Becker
[    5.928719] via_rhine: Broken BIOS detected, avoid_D3 enabled
[    5.935934] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.936096] PCI: setting IRQ 10 as level-triggered
[    5.943770] via-rhine 0000:00:12.0 eth1: VIA Rhine II at 0xe4001000, 00:40:63:d7:94:5e, IRQ 10
[    5.944771] via-rhine 0000:00:12.0 eth1: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e1
[    6.098541] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.116497] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x0000603a-0x0000603a (\IP3_) (20140214/utaddress-258)
[    6.116874] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x00006039-0x00006039 (\IP2_) (20140214/utaddress-258)
[    6.117214] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x00006040-0x00006040 (\IP1_) (20140214/utaddress-258)
[    6.117553] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x00006020-0x00006020 (\IP0_) (20140214/utaddress-258)
[    6.117898] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.136303] uhci_hcd: USB Universal Host Controller Interface driver
[    6.139018] uhci_hcd 0000:00:11.2: UHCI Host Controller
[    6.141356] uhci_hcd 0000:00:11.2: new USB bus registered, assigned bus number 1
[    6.142423] uhci_hcd 0000:00:11.2: irq 5, io base 0x0000d400
[    6.236056] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    6.236241] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.236447] usb usb1: Product: UHCI Host Controller
[    6.236591] usb usb1: Manufacturer: Linux 3.15.0-rc2-dirty uhci_hcd
[    6.236740] usb usb1: SerialNumber: 0000:00:11.2
[    6.298449] hub 1-0:1.0: USB hub found
[    6.323304] hub 1-0:1.0: 2 ports detected
[    6.375194] uhci_hcd 0000:00:11.3: UHCI Host Controller
[    6.375469] uhci_hcd 0000:00:11.3: new USB bus registered, assigned bus number 2
[    6.375837] uhci_hcd 0000:00:11.3: irq 5, io base 0x0000d800
[    6.390859] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.391037] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.391244] usb usb2: Product: UHCI Host Controller
[    6.391386] usb usb2: Manufacturer: Linux 3.15.0-rc2-dirty uhci_hcd
[    6.391537] usb usb2: SerialNumber: 0000:00:11.3
[    6.426969] hub 2-0:1.0: USB hub found
[    6.435606] hub 2-0:1.0: 2 ports detected
[    6.467855] longhaul: VIA C3 'Samuel 2' [C5B] CPU detected.  Longhaul v2 supported.
[    6.468592] longhaul: Using northbridge support.
[    6.819191] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
[    6.819366] PCI: setting IRQ 12 as level-triggered
[    7.453676] random: nonblocking pool is initialized
[    7.583602] systemd-udevd[531]: renamed network interface eth0 to rename2
[    7.598238] systemd-udevd[532]: renamed network interface eth1 to eth0
[    7.635126] systemd-udevd[531]: renamed network interface rename2 to eth1
[   10.528892] Adding 100348k swap on /dev/sda5.  Priority:-1 extents:1 across:100348k 
[   10.745573] EXT4-fs (sda1): re-mounted. Opts: (null)
[   11.354314] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   18.003161] NET: Registered protocol family 10
[  240.140176] INFO: task kworker/0:1:116 blocked for more than 120 seconds.
[  240.140353]       Not tainted 3.15.0-rc2-dirty #37
[  240.140485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.140687] kworker/0:1     D cf6afd50     0   116      2 0x00000000
[  240.140938] Workqueue: events od_dbs_timer
[  240.141103]  cf6afd98 00000082 00000002 cf6afd50 c1040d91 cf6affec cf6ad310 cf6ad310
[  240.142479]  c1286dcb 00000002 cf6afd70 c1040f14 00000000 ce460b30 00000282 00000046
[  240.143011]  00000282 ce460b30 cf6afd78 c1040f39 cf6afd88 00000282 cf6afdb0 ce460b30
[  240.143544] Call Trace:
[  240.143706]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  240.143883]  [<c1286dcb>] ? _raw_spin_unlock_irqrestore+0x33/0x3f
[  240.144043]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  240.144203]  [<c1040f39>] ? trace_hardirqs_on+0xb/0xd
[  240.144358]  [<c1284145>] schedule+0x5d/0x5f
[  240.144527]  [<c11eaa67>] cpufreq_freq_transition_begin+0x4a/0x9d
[  240.144687]  [<c103e1b0>] ? __wake_up_sync+0x14/0x14
[  240.144860]  [<d06722d5>] longhaul_setstate+0x88/0x2f1 [longhaul]
[  240.145023]  [<c1036d43>] ? srcu_notifier_call_chain+0x1a/0x1c
[  240.145186]  [<c11eaab2>] ? cpufreq_freq_transition_begin+0x95/0x9d
[  240.145350]  [<d06725ba>] longhaul_target+0x7c/0x8b [longhaul]
[  240.145511]  [<c11eae78>] __cpufreq_driver_target+0xfe/0x148
[  240.145683]  [<c10540c6>] ? get_cpu_iowait_time_us+0x84/0xa3
[  240.145839]  [<c11ebde2>] od_check_cpu+0x75/0x79
[  240.145990]  [<c11ec75c>] dbs_check_cpu+0xbd/0xc5
[  240.146137]  [<c11ec7ce>] ? need_load_eval+0x18/0x79
[  240.146288]  [<c11ebfbf>] od_dbs_timer+0x7a/0xd9
[  240.146456]  [<c102f808>] process_one_work+0x205/0x363
[  240.146612]  [<c102f7d7>] ? process_one_work+0x1d4/0x363
[  240.146767]  [<c10300b3>] ? worker_thread+0x27/0x26f
[  240.146923]  [<c103022c>] worker_thread+0x1a0/0x26f
[  240.147077]  [<c103008c>] ? rescuer_thread+0x204/0x204
[  240.147235]  [<c10339e9>] kthread+0xa3/0xa8
[  240.147395]  [<c1287b80>] ret_from_kernel_thread+0x20/0x30
[  240.147550]  [<c1033946>] ? kthread_create_on_node+0x112/0x112
[  240.147699] 3 locks held by kworker/0:1/116:
[  240.147829]  #0:  ("events"){.+.+.+}, at: [<c102f7a0>] process_one_work+0x19d/0x363
[  240.148250]  #1:  ((&(&j_cdbs->work)->work)){+.+...}, at: [<c102f7d7>] process_one_work+0x1d4/0x363
[  240.148679]  #2:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ebf77>] od_dbs_timer+0x32/0xd9
[  240.149121] INFO: task cpufreq-set:1893 blocked for more than 120 seconds.
[  240.149268]       Not tainted 3.15.0-rc2-dirty #37
[  240.149399] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.149600] cpufreq-set     D 00000005     0  1893   1885 0x00000000
[  240.149828]  cf6e9cac 00000096 00000001 00000005 19d15905 cf6e9fec ce40a270 ce40a270
[  240.151393]  ce40a69c 00000005 ce40a270 c1696428 ce40a6b4 ce40a270 00000005 cf6e9c94
[  240.151925]  c1040d91 00000007 00000006 ce40a270 c1284aaa cf6e9cdc cf6e9cb4 c1040f14
[  240.152456] Call Trace:
[  240.152608]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  240.152773]  [<c1284aaa>] ? mutex_lock_nested+0x199/0x288
[  240.152929]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  240.153089]  [<c1284145>] schedule+0x5d/0x5f
[  240.153239]  [<c12842c5>] schedule_preempt_disabled+0xe/0x16
[  240.153397]  [<c1284a7a>] mutex_lock_nested+0x169/0x288
[  240.153552]  [<c11ecc55>] ? cpufreq_governor_dbs+0x426/0x46f
[  240.153709]  [<c11ecc55>] cpufreq_governor_dbs+0x426/0x46f
[  240.153865]  [<c11ebf36>] od_cpufreq_governor_dbs+0xf/0x11
[  240.154027]  [<c11e9eef>] __cpufreq_governor+0xc5/0x13b
[  240.154183]  [<c11ea189>] cpufreq_set_policy+0x16f/0x17c
[  240.154340]  [<c11ea891>] store_scaling_governor+0x70/0x91
[  240.154505]  [<c11ead6d>] ? cpufreq_update_policy+0x10a/0x10a
[  240.154685]  [<c11ea821>] ? cpufreq_parse_governor+0xf4/0xf4
[  240.154841]  [<c11e9924>] store+0x4e/0x72
[  240.155001]  [<c10d33ec>] sysfs_kf_write+0x31/0x3c
[  240.155152]  [<c10d33bb>] ? sysfs_file_ops+0x49/0x49
[  240.155304]  [<c10d2a2f>] kernfs_fop_write+0xb8/0xfe
[  240.155454]  [<c10d2977>] ? kernfs_vma_page_mkwrite+0x5d/0x5d
[  240.155608]  [<c108a3ae>] vfs_write+0xa4/0x144
[  240.155753]  [<c108a916>] SyS_write+0x47/0x8c
[  240.155897]  [<c128761d>] syscall_call+0x7/0xb
[  240.156033] 6 locks held by cpufreq-set/1893:
[  240.156159]  #0:  (sb_writers#7){.+.+.+}, at: [<c108a395>] vfs_write+0x8b/0x144
[  240.156607]  #1:  (&of->mutex){+.+.+.}, at: [<c10d29f0>] kernfs_fop_write+0x79/0xfe
[  240.157024]  #2:  (s_active#49){.+.+.+}, at: [<c10d29f7>] kernfs_fop_write+0x80/0xfe
[  240.157486]  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c11e98fc>] store+0x26/0x72
[  240.157848]  #4:  (&policy->rwsem){+++++.}, at: [<c11e9913>] store+0x3d/0x72
[  240.158209]  #5:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ecc55>] cpufreq_governor_dbs+0x426/0x46f
[  240.158686] INFO: task cpufreq-info:2014 blocked for more than 120 seconds.
[  240.158834]       Not tainted 3.15.0-rc2-dirty #37
[  240.158964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.159166] cpufreq-info    D ce7b1e68     0  2014   2007 0x00000000
[  240.159396]  ce7b1e5c 00000092 c16a27a8 ce7b1e68 c10422ae ce7b1fec ce792010 ce792010
[  240.159928]  ce792010 00000004 ce7b1e30 c1040d91 00000007 00000006 ce792010 c1286df9
[  240.160534]  ce460af4 ce7b1e50 c1040f14 00000000 ce460ad4 ce792010 00000046 ce460ad4
[  240.161066] Call Trace:
[  240.161207]  [<c10422ae>] ? __lock_acquire+0x115c/0x16f6
[  240.161363]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  240.161523]  [<c1286df9>] ? _raw_spin_unlock_irq+0x22/0x2c
[  240.161682]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  240.161843]  [<c1284145>] schedule+0x5d/0x5f
[  240.161993]  [<c128667d>] rwsem_down_read_failed+0x85/0x97
[  240.162167]  [<c113cd77>] call_rwsem_down_read_failed+0x7/0x10
[  240.162325]  [<c12862b6>] ? down_read+0x4f/0x55
[  240.162474]  [<c11e980d>] ? show+0x2b/0x62
[  240.162618]  [<c11e980d>] show+0x2b/0x62
[  240.162763]  [<c11e97e2>] ? show_boost+0x25/0x25
[  240.162914]  [<c10d3460>] sysfs_kf_seq_show+0x69/0xaa
[  240.163067]  [<c11e97e2>] ? show_boost+0x25/0x25
[  240.163216]  [<c10d25f3>] kernfs_seq_show+0x18/0x1c
[  240.163385]  [<c10a3a52>] seq_read+0x18c/0x342
[  240.163539]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  240.163700]  [<c10d2aa0>] kernfs_fop_read+0x2b/0x100
[  240.163854]  [<c10d2a75>] ? kernfs_fop_write+0xfe/0xfe
[  240.164002]  [<c108a288>] vfs_read+0x7b/0xfd
[  240.164151]  [<c109eecf>] ? __fdget+0xd/0xf
[  240.164295]  [<c108a88a>] SyS_read+0x47/0x8c
[  240.164441]  [<c128761d>] syscall_call+0x7/0xb
[  240.164579] 5 locks held by cpufreq-info/2014:
[  240.164709]  #0:  (&p->lock){+.+.+.}, at: [<c10a38ed>] seq_read+0x27/0x342
[  240.165074]  #1:  (&of->mutex){+.+.+.}, at: [<c10d2c89>] kernfs_seq_start+0x17/0x64
[  240.165495]  #2:  (s_active#50){.+.+.+}, at: [<c10d2c90>] kernfs_seq_start+0x1e/0x64
[  240.165955]  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c11e97f9>] show+0x17/0x62
[  240.166315]  #4:  (&policy->rwsem){+++++.}, at: [<c11e980d>] show+0x2b/0x62
[  360.160157] INFO: task kworker/0:1:116 blocked for more than 120 seconds.
[  360.160335]       Not tainted 3.15.0-rc2-dirty #37
[  360.160468] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.160671] kworker/0:1     D cf6afd50     0   116      2 0x00000000
[  360.160925] Workqueue: events od_dbs_timer
[  360.161091]  cf6afd98 00000082 00000002 cf6afd50 c1040d91 cf6affec cf6ad310 cf6ad310
[  360.161625]  c1286dcb 00000002 cf6afd70 c1040f14 00000000 ce460b30 00000282 00000046
[  360.162157]  00000282 ce460b30 cf6afd78 c1040f39 cf6afd88 00000282 cf6afdb0 ce460b30
[  360.162692] Call Trace:
[  360.162852]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  360.163030]  [<c1286dcb>] ? _raw_spin_unlock_irqrestore+0x33/0x3f
[  360.163192]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  360.163353]  [<c1040f39>] ? trace_hardirqs_on+0xb/0xd
[  360.163508]  [<c1284145>] schedule+0x5d/0x5f
[  360.163675]  [<c11eaa67>] cpufreq_freq_transition_begin+0x4a/0x9d
[  360.163836]  [<c103e1b0>] ? __wake_up_sync+0x14/0x14
[  360.164009]  [<d06722d5>] longhaul_setstate+0x88/0x2f1 [longhaul]
[  360.164171]  [<c1036d43>] ? srcu_notifier_call_chain+0x1a/0x1c
[  360.164334]  [<c11eaab2>] ? cpufreq_freq_transition_begin+0x95/0x9d
[  360.164498]  [<d06725ba>] longhaul_target+0x7c/0x8b [longhaul]
[  360.164659]  [<c11eae78>] __cpufreq_driver_target+0xfe/0x148
[  360.164831]  [<c10540c6>] ? get_cpu_iowait_time_us+0x84/0xa3
[  360.164984]  [<c11ebde2>] od_check_cpu+0x75/0x79
[  360.165134]  [<c11ec75c>] dbs_check_cpu+0xbd/0xc5
[  360.165279]  [<c11ec7ce>] ? need_load_eval+0x18/0x79
[  360.165426]  [<c11ebfbf>] od_dbs_timer+0x7a/0xd9
[  360.165589]  [<c102f808>] process_one_work+0x205/0x363
[  360.165742]  [<c102f7d7>] ? process_one_work+0x1d4/0x363
[  360.165894]  [<c10300b3>] ? worker_thread+0x27/0x26f
[  360.166048]  [<c103022c>] worker_thread+0x1a0/0x26f
[  360.166200]  [<c103008c>] ? rescuer_thread+0x204/0x204
[  360.166356]  [<c10339e9>] kthread+0xa3/0xa8
[  360.166512]  [<c1287b80>] ret_from_kernel_thread+0x20/0x30
[  360.166665]  [<c1033946>] ? kthread_create_on_node+0x112/0x112
[  360.166814] 3 locks held by kworker/0:1/116:
[  360.166943]  #0:  ("events"){.+.+.+}, at: [<c102f7a0>] process_one_work+0x19d/0x363
[  360.167367]  #1:  ((&(&j_cdbs->work)->work)){+.+...}, at: [<c102f7d7>] process_one_work+0x1d4/0x363
[  360.167797]  #2:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ebf77>] od_dbs_timer+0x32/0xd9
[  360.168237] INFO: task cpufreq-set:1893 blocked for more than 120 seconds.
[  360.168384]       Not tainted 3.15.0-rc2-dirty #37
[  360.168516] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.168717] cpufreq-set     D 00000005     0  1893   1885 0x00000000
[  360.168944]  cf6e9cac 00000096 00000001 00000005 19d15905 cf6e9fec ce40a270 ce40a270
[  360.169476]  ce40a69c 00000005 ce40a270 c1696428 ce40a6b4 ce40a270 00000005 cf6e9c94
[  360.170103]  c1040d91 00000007 00000006 ce40a270 c1284aaa cf6e9cdc cf6e9cb4 c1040f14
[  360.171549] Call Trace:
[  360.171693]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  360.171850]  [<c1284aaa>] ? mutex_lock_nested+0x199/0x288
[  360.172005]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  360.172163]  [<c1284145>] schedule+0x5d/0x5f
[  360.172312]  [<c12842c5>] schedule_preempt_disabled+0xe/0x16
[  360.172469]  [<c1284a7a>] mutex_lock_nested+0x169/0x288
[  360.172621]  [<c11ecc55>] ? cpufreq_governor_dbs+0x426/0x46f
[  360.172778]  [<c11ecc55>] cpufreq_governor_dbs+0x426/0x46f
[  360.172935]  [<c11ebf36>] od_cpufreq_governor_dbs+0xf/0x11
[  360.173094]  [<c11e9eef>] __cpufreq_governor+0xc5/0x13b
[  360.173250]  [<c11ea189>] cpufreq_set_policy+0x16f/0x17c
[  360.173406]  [<c11ea891>] store_scaling_governor+0x70/0x91
[  360.173572]  [<c11ead6d>] ? cpufreq_update_policy+0x10a/0x10a
[  360.173751]  [<c11ea821>] ? cpufreq_parse_governor+0xf4/0xf4
[  360.173908]  [<c11e9924>] store+0x4e/0x72
[  360.174068]  [<c10d33ec>] sysfs_kf_write+0x31/0x3c
[  360.174218]  [<c10d33bb>] ? sysfs_file_ops+0x49/0x49
[  360.174369]  [<c10d2a2f>] kernfs_fop_write+0xb8/0xfe
[  360.174522]  [<c10d2977>] ? kernfs_vma_page_mkwrite+0x5d/0x5d
[  360.174680]  [<c108a3ae>] vfs_write+0xa4/0x144
[  360.174829]  [<c108a916>] SyS_write+0x47/0x8c
[  360.174976]  [<c128761d>] syscall_call+0x7/0xb
[  360.175114] 6 locks held by cpufreq-set/1893:
[  360.175243]  #0:  (sb_writers#7){.+.+.+}, at: [<c108a395>] vfs_write+0x8b/0x144
[  360.175699]  #1:  (&of->mutex){+.+.+.}, at: [<c10d29f0>] kernfs_fop_write+0x79/0xfe
[  360.176118]  #2:  (s_active#49){.+.+.+}, at: [<c10d29f7>] kernfs_fop_write+0x80/0xfe
[  360.176578]  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c11e98fc>] store+0x26/0x72
[  360.176941]  #4:  (&policy->rwsem){+++++.}, at: [<c11e9913>] store+0x3d/0x72
[  360.177305]  #5:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ecc55>] cpufreq_governor_dbs+0x426/0x46f
[  360.177781] INFO: task cpufreq-info:2014 blocked for more than 120 seconds.
[  360.177928]       Not tainted 3.15.0-rc2-dirty #37
[  360.178059] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.178258] cpufreq-info    D ce7b1e68     0  2014   2007 0x00000000
[  360.178488]  ce7b1e5c 00000092 c16a27a8 ce7b1e68 c10422ae ce7b1fec ce792010 ce792010
[  360.179020]  ce792010 00000004 ce7b1e30 c1040d91 00000007 00000006 ce792010 c1286df9
[  360.179548]  ce460af4 ce7b1e50 c1040f14 00000000 ce460ad4 ce792010 00000046 ce460ad4
[  360.180141] Call Trace:
[  360.180280]  [<c10422ae>] ? __lock_acquire+0x115c/0x16f6
[  360.180433]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  360.180590]  [<c1286df9>] ? _raw_spin_unlock_irq+0x22/0x2c
[  360.180745]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  360.180902]  [<c1284145>] schedule+0x5d/0x5f
[  360.181050]  [<c128667d>] rwsem_down_read_failed+0x85/0x97
[  360.181222]  [<c113cd77>] call_rwsem_down_read_failed+0x7/0x10
[  360.181378]  [<c12862b6>] ? down_read+0x4f/0x55
[  360.181527]  [<c11e980d>] ? show+0x2b/0x62
[  360.181672]  [<c11e980d>] show+0x2b/0x62
[  360.181819]  [<c11e97e2>] ? show_boost+0x25/0x25
[  360.181971]  [<c10d3460>] sysfs_kf_seq_show+0x69/0xaa
[  360.182122]  [<c11e97e2>] ? show_boost+0x25/0x25
[  360.182272]  [<c10d25f3>] kernfs_seq_show+0x18/0x1c
[  360.182442]  [<c10a3a52>] seq_read+0x18c/0x342
[  360.182594]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  360.182752]  [<c10d2aa0>] kernfs_fop_read+0x2b/0x100
[  360.182906]  [<c10d2a75>] ? kernfs_fop_write+0xfe/0xfe
[  360.183054]  [<c108a288>] vfs_read+0x7b/0xfd
[  360.183198]  [<c109eecf>] ? __fdget+0xd/0xf
[  360.183342]  [<c108a88a>] SyS_read+0x47/0x8c
[  360.183487]  [<c128761d>] syscall_call+0x7/0xb
[  360.183625] 5 locks held by cpufreq-info/2014:
[  360.183754]  #0:  (&p->lock){+.+.+.}, at: [<c10a38ed>] seq_read+0x27/0x342
[  360.184118]  #1:  (&of->mutex){+.+.+.}, at: [<c10d2c89>] kernfs_seq_start+0x17/0x64
[  360.184535]  #2:  (s_active#50){.+.+.+}, at: [<c10d2c90>] kernfs_seq_start+0x1e/0x64
[  360.184994]  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c11e97f9>] show+0x17/0x62
[  360.185353]  #4:  (&policy->rwsem){+++++.}, at: [<c11e980d>] show+0x2b/0x62
[  480.180159] INFO: task kworker/0:1:116 blocked for more than 120 seconds.
[  480.180335]       Not tainted 3.15.0-rc2-dirty #37
[  480.180470] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.180672] kworker/0:1     D cf6afd50     0   116      2 0x00000000
[  480.180923] Workqueue: events od_dbs_timer
[  480.181089]  cf6afd98 00000082 00000002 cf6afd50 c1040d91 cf6affec cf6ad310 cf6ad310
[  480.181621]  c1286dcb 00000002 cf6afd70 c1040f14 00000000 ce460b30 00000282 00000046
[  480.182152]  00000282 ce460b30 cf6afd78 c1040f39 cf6afd88 00000282 cf6afdb0 ce460b30
[  480.182688] Call Trace:
[  480.182849]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  480.183030]  [<c1286dcb>] ? _raw_spin_unlock_irqrestore+0x33/0x3f
[  480.183190]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  480.183350]  [<c1040f39>] ? trace_hardirqs_on+0xb/0xd
[  480.183504]  [<c1284145>] schedule+0x5d/0x5f
[  480.183669]  [<c11eaa67>] cpufreq_freq_transition_begin+0x4a/0x9d
[  480.183828]  [<c103e1b0>] ? __wake_up_sync+0x14/0x14
[  480.184003]  [<d06722d5>] longhaul_setstate+0x88/0x2f1 [longhaul]
[  480.184166]  [<c1036d43>] ? srcu_notifier_call_chain+0x1a/0x1c
[  480.184329]  [<c11eaab2>] ? cpufreq_freq_transition_begin+0x95/0x9d
[  480.184495]  [<d06725ba>] longhaul_target+0x7c/0x8b [longhaul]
[  480.184658]  [<c11eae78>] __cpufreq_driver_target+0xfe/0x148
[  480.184831]  [<c10540c6>] ? get_cpu_iowait_time_us+0x84/0xa3
[  480.184984]  [<c11ebde2>] od_check_cpu+0x75/0x79
[  480.185136]  [<c11ec75c>] dbs_check_cpu+0xbd/0xc5
[  480.185283]  [<c11ec7ce>] ? need_load_eval+0x18/0x79
[  480.185431]  [<c11ebfbf>] od_dbs_timer+0x7a/0xd9
[  480.185599]  [<c102f808>] process_one_work+0x205/0x363
[  480.185755]  [<c102f7d7>] ? process_one_work+0x1d4/0x363
[  480.185911]  [<c10300b3>] ? worker_thread+0x27/0x26f
[  480.186068]  [<c103022c>] worker_thread+0x1a0/0x26f
[  480.186223]  [<c103008c>] ? rescuer_thread+0x204/0x204
[  480.186384]  [<c10339e9>] kthread+0xa3/0xa8
[  480.186543]  [<c1287b80>] ret_from_kernel_thread+0x20/0x30
[  480.186697]  [<c1033946>] ? kthread_create_on_node+0x112/0x112
[  480.186844] 3 locks held by kworker/0:1/116:
[  480.186972]  #0:  ("events"){.+.+.+}, at: [<c102f7a0>] process_one_work+0x19d/0x363
[  480.187394]  #1:  ((&(&j_cdbs->work)->work)){+.+...}, at: [<c102f7d7>] process_one_work+0x1d4/0x363
[  480.187825]  #2:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ebf77>] od_dbs_timer+0x32/0xd9
[  480.188264] INFO: task cpufreq-set:1893 blocked for more than 120 seconds.
[  480.188410]       Not tainted 3.15.0-rc2-dirty #37
[  480.188540] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.188738] cpufreq-set     D 00000005     0  1893   1885 0x00000000
[  480.188967]  cf6e9cac 00000096 00000001 00000005 19d15905 cf6e9fec ce40a270 ce40a270
[  480.189494]  ce40a69c 00000005 ce40a270 c1696428 ce40a6b4 ce40a270 00000005 cf6e9c94
[  480.190113]  c1040d91 00000007 00000006 ce40a270 c1284aaa cf6e9cdc cf6e9cb4 c1040f14
[  480.190641] Call Trace:
[  480.190781]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  480.190939]  [<c1284aaa>] ? mutex_lock_nested+0x199/0x288
[  480.191096]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  480.191255]  [<c1284145>] schedule+0x5d/0x5f
[  480.191403]  [<c12842c5>] schedule_preempt_disabled+0xe/0x16
[  480.191560]  [<c1284a7a>] mutex_lock_nested+0x169/0x288
[  480.191714]  [<c11ecc55>] ? cpufreq_governor_dbs+0x426/0x46f
[  480.191871]  [<c11ecc55>] cpufreq_governor_dbs+0x426/0x46f
[  480.192026]  [<c11ebf36>] od_cpufreq_governor_dbs+0xf/0x11
[  480.192183]  [<c11e9eef>] __cpufreq_governor+0xc5/0x13b
[  480.192341]  [<c11ea189>] cpufreq_set_policy+0x16f/0x17c
[  480.192499]  [<c11ea891>] store_scaling_governor+0x70/0x91
[  480.192667]  [<c11ead6d>] ? cpufreq_update_policy+0x10a/0x10a
[  480.192848]  [<c11ea821>] ? cpufreq_parse_governor+0xf4/0xf4
[  480.193007]  [<c11e9924>] store+0x4e/0x72
[  480.193166]  [<c10d33ec>] sysfs_kf_write+0x31/0x3c
[  480.193316]  [<c10d33bb>] ? sysfs_file_ops+0x49/0x49
[  480.193467]  [<c10d2a2f>] kernfs_fop_write+0xb8/0xfe
[  480.193619]  [<c10d2977>] ? kernfs_vma_page_mkwrite+0x5d/0x5d
[  480.193777]  [<c108a3ae>] vfs_write+0xa4/0x144
[  480.193926]  [<c108a916>] SyS_write+0x47/0x8c
[  480.194073]  [<c128761d>] syscall_call+0x7/0xb
[  480.194211] 6 locks held by cpufreq-set/1893:
[  480.194339]  #0:  (sb_writers#7){.+.+.+}, at: [<c108a395>] vfs_write+0x8b/0x144
[  480.194794]  #1:  (&of->mutex){+.+.+.}, at: [<c10d29f0>] kernfs_fop_write+0x79/0xfe
[  480.195211]  #2:  (s_active#49){.+.+.+}, at: [<c10d29f7>] kernfs_fop_write+0x80/0xfe
[  480.195669]  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c11e98fc>] store+0x26/0x72
[  480.196030]  #4:  (&policy->rwsem){+++++.}, at: [<c11e9913>] store+0x3d/0x72
[  480.196391]  #5:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ecc55>] cpufreq_governor_dbs+0x426/0x46f
[  480.196868] INFO: task cpufreq-info:2014 blocked for more than 120 seconds.
[  480.197017]       Not tainted 3.15.0-rc2-dirty #37
[  480.197150] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.197349] cpufreq-info    D ce7b1e68     0  2014   2007 0x00000000
[  480.197577]  ce7b1e5c 00000092 c16a27a8 ce7b1e68 c10422ae ce7b1fec ce792010 ce792010
[  480.198111]  ce792010 00000004 ce7b1e30 c1040d91 00000007 00000006 ce792010 c1286df9
[  480.198643]  ce460af4 ce7b1e50 c1040f14 00000000 ce460ad4 ce792010 00000046 ce460ad4
[  480.199175] Call Trace:
[  480.199316]  [<c10422ae>] ? __lock_acquire+0x115c/0x16f6
[  480.199473]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  480.200613]  [<c1286df9>] ? _raw_spin_unlock_irq+0x22/0x2c
[  480.200774]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  480.200934]  [<c1284145>] schedule+0x5d/0x5f
[  480.201083]  [<c128667d>] rwsem_down_read_failed+0x85/0x97
[  480.201256]  [<c113cd77>] call_rwsem_down_read_failed+0x7/0x10
[  480.201413]  [<c12862b6>] ? down_read+0x4f/0x55
[  480.201562]  [<c11e980d>] ? show+0x2b/0x62
[  480.201708]  [<c11e980d>] show+0x2b/0x62
[  480.201853]  [<c11e97e2>] ? show_boost+0x25/0x25
[  480.202005]  [<c10d3460>] sysfs_kf_seq_show+0x69/0xaa
[  480.202158]  [<c11e97e2>] ? show_boost+0x25/0x25
[  480.202308]  [<c10d25f3>] kernfs_seq_show+0x18/0x1c
[  480.202476]  [<c10a3a52>] seq_read+0x18c/0x342
[  480.202630]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  480.202789]  [<c10d2aa0>] kernfs_fop_read+0x2b/0x100
[  480.202942]  [<c10d2a75>] ? kernfs_fop_write+0xfe/0xfe
[  480.203090]  [<c108a288>] vfs_read+0x7b/0xfd
[  480.203235]  [<c109eecf>] ? __fdget+0xd/0xf
[  480.203379]  [<c108a88a>] SyS_read+0x47/0x8c
[  480.203525]  [<c128761d>] syscall_call+0x7/0xb
[  480.203661] 5 locks held by cpufreq-info/2014:
[  480.203787]  #0:  (&p->lock){+.+.+.}, at: [<c10a38ed>] seq_read+0x27/0x342
[  480.204148]  #1:  (&of->mutex){+.+.+.}, at: [<c10d2c89>] kernfs_seq_start+0x17/0x64
[  480.204560]  #2:  (s_active#50){.+.+.+}, at: [<c10d2c90>] kernfs_seq_start+0x1e/0x64
[  480.205014]  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c11e97f9>] show+0x17/0x62
[  480.205376]  #4:  (&policy->rwsem){+++++.}, at: [<c11e980d>] show+0x2b/0x62
[  600.200161] INFO: task kworker/0:1:116 blocked for more than 120 seconds.
[  600.200330]       Not tainted 3.15.0-rc2-dirty #37
[  600.200460] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.200656] kworker/0:1     D cf6afd50     0   116      2 0x00000000
[  600.200907] Workqueue: events od_dbs_timer
[  600.201073]  cf6afd98 00000082 00000002 cf6afd50 c1040d91 cf6affec cf6ad310 cf6ad310
[  600.201609]  c1286dcb 00000002 cf6afd70 c1040f14 00000000 ce460b30 00000282 00000046
[  600.202141]  00000282 ce460b30 cf6afd78 c1040f39 cf6afd88 00000282 cf6afdb0 ce460b30
[  600.202678] Call Trace:
[  600.202841]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
[  600.203020]  [<c1286dcb>] ? _raw_spin_unlock_irqrestore+0x33/0x3f
[  600.203180]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
[  600.203340]  [<c1040f39>] ? trace_hardirqs_on+0xb/0xd
[  600.203496]  [<c1284145>] schedule+0x5d/0x5f
[  600.203663]  [<c11eaa67>] cpufreq_freq_transition_begin+0x4a/0x9d
[  600.203825]  [<c103e1b0>] ? __wake_up_sync+0x14/0x14
[  600.203998]  [<d06722d5>] longhaul_setstate+0x88/0x2f1 [longhaul]
[  600.204163]  [<c1036d43>] ? srcu_notifier_call_chain+0x1a/0x1c
[  600.204327]  [<c11eaab2>] ? cpufreq_freq_transition_begin+0x95/0x9d
[  600.204490]  [<d06725ba>] longhaul_target+0x7c/0x8b [longhaul]
[  600.204653]  [<c11eae78>] __cpufreq_driver_target+0xfe/0x148
[  600.204824]  [<c10540c6>] ? get_cpu_iowait_time_us+0x84/0xa3
[  600.204979]  [<c11ebde2>] od_check_cpu+0x75/0x79
[  600.205129]  [<c11ec75c>] dbs_check_cpu+0xbd/0xc5
[  600.205276]  [<c11ec7ce>] ? need_load_eval+0x18/0x79
[  600.205425]  [<c11ebfbf>] od_dbs_timer+0x7a/0xd9
[  600.205592]  [<c102f808>] process_one_work+0x205/0x363
[  600.205748]  [<c102f7d7>] ? process_one_work+0x1d4/0x363
[  600.205905]  [<c10300b3>] ? worker_thread+0x27/0x26f
[  600.206061]  [<c103022c>] worker_thread+0x1a0/0x26f
[  600.206216]  [<c103008c>] ? rescuer_thread+0x204/0x204
[  600.206374]  [<c10339e9>] kthread+0xa3/0xa8
[  600.206533]  [<c1287b80>] ret_from_kernel_thread+0x20/0x30
[  600.206688]  [<c1033946>] ? kthread_create_on_node+0x112/0x112
[  600.206835] 3 locks held by kworker/0:1/116:
[  600.206965]  #0:  ("events"){.+.+.+}, at: [<c102f7a0>] process_one_work+0x19d/0x363
[  600.207389]  #1:  ((&(&j_cdbs->work)->work)){+.+...}, at: [<c102f7d7>] process_one_work+0x1d4/0x363
[  600.207819]  #2:  (&j_cdbs->timer_mutex){+.+...}, at: [<c11ebf77>] od_dbs_timer+0x32/0xd9

-- 
Meelis Roos (mroos@linux.ee)
