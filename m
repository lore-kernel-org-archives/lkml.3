Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaDXKRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:17:13 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:51185 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaDXKQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:16:59 -0400
Date: Thu, 24 Apr 2014 13:16:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc2: longhaul cpufreq stalls tasks for 120s+
In-Reply-To: <CAKohpoktwh=SgHTfEgT7vYRVWHssXw7==+a9qAdtmJXepjT2Tw@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1404241316290.13595@math.ut.ee>
References: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee> <CAKohpoktwh=SgHTfEgT7vYRVWHssXw7==+a9qAdtmJXepjT2Tw@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is VIA EPIA board with 533 MHz VIA Samuel 2 CPU. Normally, longhaul
> > is not enabled automatically but with longhaul.enable=1. It used to work
> > up to 3.14 but in 3.15-rc, different cpufreq-related codepaths block for
> > long times and cause warnings.
> 
> Probably we haven't introduced a bug here but highlighted one.
> 
> 12478c: cpufreq: Make sure frequency transitions are serialized
> 
> Above commit tried to serialize calls to ->target() routines and this
> for some reason didn't work well for you. Probably because something
> else was also trying to change freq and it left the system into unworkable
> state.
> 
> @Srivatsa: Or maybe some barrier stuff is actually required? Or the wake
> up event is missed
> 
> I don't have a longhaul board and so can't debug this. Probably need some
> help from you in debugging this :(

I can add debug to where needed and try it.

> 
> > /usr/bin/cpufreq-set --cpu 0 --governor ondemand
> > is running since boot and hangs in D state.
> > Running cpufreq-info seems to just hang too.
> >
> > [    0.000000] Linux version 3.15.0-rc2 (mroos@via) (gcc version 4.8.2 (Debian 4.8.2-17) ) #35 Mon Apr 21 13:45:07 EEST 2014
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fdeffff] usable
> > [    0.000000] BIOS-e820: [mem 0x000000000fdf0000-0x000000000fdf2fff] ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x000000000fdf3000-0x000000000fdfffff] ACPI data
> > [    0.000000] BIOS-e820: [mem 0x00000000ffff0000-0x00000000ffffffff] reserved
> > [    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
> > [    0.000000] SMBIOS 2.2 present.
> > [    0.000000] DMI: VIA TECHNOLOGIES, INC. EPIA/EPIA, BIOS 6.00 PG 11/02/2004
> > [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> > [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> > [    0.000000] e820: last_pfn = 0xfdf0 max_arch_pfn = 0x100000
> > [    0.000000] MTRR default type: uncachable
> > [    0.000000] MTRR fixed ranges enabled:
> > [    0.000000]   00000-9FFFF write-back
> > [    0.000000]   A0000-BFFFF uncachable
> > [    0.000000]   C0000-CBFFF write-protect
> > [    0.000000]   CC000-EFFFF uncachable
> > [    0.000000]   F0000-F7FFF write-through
> > [    0.000000]   F8000-F8FFF uncachable
> > [    0.000000]   F9000-FFFFF write-through
> > [    0.000000] MTRR variable ranges enabled:
> > [    0.000000]   0 base 000000000 mask FF0000000 write-back
> > [    0.000000]   1 base 00FE00000 mask FFFE00000 uncachable
> > [    0.000000]   2 base 0D0000000 mask FF0000000 write-combining
> > [    0.000000]   3 disabled
> > [    0.000000]   4 disabled
> > [    0.000000]   5 disabled
> > [    0.000000]   6 disabled
> > [    0.000000]   7 disabled
> > [    0.000000] PAT not supported by CPU.
> > [    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
> > [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> > [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> > [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> > [    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
> > [    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
> > [    0.000000] BRK [0x01442000, 0x01442fff] PGTABLE
> > [    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
> > [    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
> > [    0.000000] BRK [0x01443000, 0x01443fff] PGTABLE
> > [    0.000000] BRK [0x01444000, 0x01444fff] PGTABLE
> > [    0.000000] BRK [0x01445000, 0x01445fff] PGTABLE
> > [    0.000000] BRK [0x01446000, 0x01446fff] PGTABLE
> > [    0.000000] BRK [0x01447000, 0x01447fff] PGTABLE
> > [    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
> > [    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
> > [    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fdeffff]
> > [    0.000000]  [mem 0x0fc00000-0x0fdeffff] page 4k
> > [    0.000000] ACPI: RSDP 0x000F67C0 000014 (v00 VIA601)
> > [    0.000000] ACPI: RSDT 0x0FDF3000 000028 (v01 VIA601 AWRDACPI 42302E31 AWRD 00000000)
> > [    0.000000] ACPI: FACP 0x0FDF3040 000074 (v01 VIA601 AWRDACPI 42302E31 AWRD 00000000)
> > [    0.000000] ACPI: DSDT 0x0FDF30C0 0029BC (v01 VIA601 AWRDACPI 00001000 MSFT 0100000C)
> > [    0.000000] ACPI: FACS 0x0FDF0000 000040
> > [    0.000000] 253MB LOWMEM available.
> > [    0.000000]   mapped low ram: 0 - 0fdf0000
> > [    0.000000]   low ram: 0 - 0fdf0000
> > [    0.000000] Zone ranges:
> > [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> > [    0.000000]   Normal   [mem 0x01000000-0x0fdeffff]
> > [    0.000000] Movable zone start for each node
> > [    0.000000] Early memory node ranges
> > [    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
> > [    0.000000]   node   0: [mem 0x00100000-0x0fdeffff]
> > [    0.000000] On node 0 totalpages: 64911
> > [    0.000000] free_area_init_node: node 0, pgdat c13aaf3c, node_mem_map cf9cc020
> > [    0.000000]   DMA zone: 32 pages used for memmap
> > [    0.000000]   DMA zone: 0 pages reserved
> > [    0.000000]   DMA zone: 3999 pages, LIFO batch:0
> > [    0.000000]   Normal zone: 476 pages used for memmap
> > [    0.000000]   Normal zone: 60912 pages, LIFO batch:15
> > [    0.000000] ACPI: PM-Timer IO Port: 0x4008
> > [    0.000000] e820: [mem 0x0fe00000-0xfffeffff] available for PCI devices
> > [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> > [    0.000000] pcpu-alloc: [0] 0
> > [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64403
> > [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.15.0-rc2 root=/dev/sda1 ro longhaul.enable=1
> > [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> > [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> > [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> > [    0.000000] Initializing CPU#0
> > [    0.000000] Memory: 252688K/259644K available (2383K kernel code, 208K rwdata, 1180K rodata, 296K init, 252K bss, 6956K reserved)
> > [    0.000000] virtual kernel memory layout:
> > [    0.000000]     fixmap  : 0xfffe4000 - 0xfffff000   ( 108 kB)
> > [    0.000000]     vmalloc : 0xd05f0000 - 0xfffe2000   ( 761 MB)
> > [    0.000000]     lowmem  : 0xc0000000 - 0xcfdf0000   ( 253 MB)
> > [    0.000000]       .init : 0xc13b2000 - 0xc13fc000   ( 296 kB)
> > [    0.000000]       .data : 0xc1253f8d - 0xc13b0020   (1392 kB)
> > [    0.000000]       .text : 0xc1000000 - 0xc1253f8d   (2383 kB)
> > [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> > [    0.000000] NR_IRQS:16 nr_irqs:16 16
> > [    0.000000] CPU 0 irqstacks, hard=cf406000 soft=cf408000
> > [    0.000000] Console: colour VGA+ 80x25
> > [    0.000000] console [tty0] enabled
> > [    0.000000] tsc: Fast TSC calibration using PIT
> > [    0.000000] tsc: Detected 533.380 MHz processor
> > [    0.020028] Calibrating delay loop (skipped), value calculated using timer frequency.. 1066.76 BogoMIPS (lpj=5333800)
> > [    0.020252] pid_max: default: 32768 minimum: 301
> > [    0.020467] ACPI: Core revision 20140214
> > [    0.040132] ACPI: All ACPI Tables successfully acquired
> > [    0.040332] ACPI: setting ELCR to 0008 (from 1c28)
> > [    0.042274] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
> > [    0.042399] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
> > [    0.043938] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> > [    0.043938] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> > [    0.043938] tlb_flushall_shift: -1
> > [    0.044200] CPU: Centaur VIA Samuel 2 (fam: 06, model: 07, stepping: 03)
> > [    0.044977] Performance Events: no PMU driver, software events only.
> > [    0.046377] NMI watchdog: disabled (cpu0): hardware events not enabled
> > [    0.047118] devtmpfs: initialized
> > [    0.049111] NET: Registered protocol family 16
> > [    0.050126] cpuidle: using governor ladder
> > [    0.050240] cpuidle: using governor menu
> > [    0.050532] ACPI: bus type PCI registered
> > [    0.071255] PCI: PCI BIOS revision 2.10 entry at 0xfb3a0, last bus=1
> > [    0.071376] PCI: Using configuration type 1 for base access
> > [    0.083922] ACPI: Added _OSI(Module Device)
> > [    0.084055] ACPI: Added _OSI(Processor Device)
> > [    0.084164] ACPI: Added _OSI(3.0 _SCP Extensions)
> > [    0.084277] ACPI: Added _OSI(Processor Aggregator Device)
> > [    0.101569] ACPI: Interpreter enabled
> > [    0.101726] ACPI: (supports S0 S5)
> > [    0.101834] ACPI: Using PIC for interrupt routing
> > [    0.102152] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> > [    0.122909] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> > [    0.123081] acpi PNP0A03:00: _OSC: OS supports [Segments]
> > [    0.123231] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> > [    0.123917] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> > [    0.123944] acpi PNP0A03:00: host bridge window [io  0x0d00-0x3fff] (ignored)
> > [    0.123969] acpi PNP0A03:00: host bridge window [io  0x4100-0x4fff] (ignored)
> > [    0.123995] acpi PNP0A03:00: host bridge window [io  0x5010-0x5fff] (ignored)
> > [    0.124020] acpi PNP0A03:00: host bridge window [io  0x6080-0xffff] (ignored)
> > [    0.124046] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> > [    0.124074] acpi PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
> > [    0.124101] acpi PNP0A03:00: host bridge window [mem 0x0fe00000-0xffefffff] (ignored)
> > [    0.124117] PCI: root bus 00: using default resources
> > [    0.124147] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> > [    0.124614] PCI host bridge to bus 0000:00
> > [    0.124738] pci_bus 0000:00: root bus resource [bus 00-ff]
> > [    0.124864] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> > [    0.124992] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> > [    0.125159] pci 0000:00:00.0: [1106:0601] type 00 class 0x060000
> > [    0.125209] pci 0000:00:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]
> > [    0.125814] pci 0000:00:01.0: [1106:8601] type 01 class 0x060400
> > [    0.125894] pci 0000:00:01.0: supports D1
> > [    0.126416] pci 0000:00:11.0: [1106:8231] type 00 class 0x060100
> > [    0.127056] pci 0000:00:11.1: [1106:0571] type 00 class 0x01018a
> > [    0.127138] pci 0000:00:11.1: reg 0x20: [io  0xd000-0xd00f]
> > [    0.127184] pci 0000:00:11.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> > [    0.127317] pci 0000:00:11.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> > [    0.127443] pci 0000:00:11.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> > [    0.127570] pci 0000:00:11.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> > [    0.128243] pci 0000:00:11.2: [1106:3038] type 00 class 0x0c0300
> > [    0.128323] pci 0000:00:11.2: reg 0x20: [io  0xd400-0xd41f]
> > [    0.128920] pci 0000:00:11.3: [1106:3038] type 00 class 0x0c0300
> > [    0.129000] pci 0000:00:11.3: reg 0x20: [io  0xd800-0xd81f]
> > [    0.129568] pci 0000:00:11.4: [1106:8235] type 00 class 0x068000
> > [    0.130250] pci 0000:00:11.5: [1106:3058] type 00 class 0x040100
> > [    0.130298] pci 0000:00:11.5: reg 0x10: [io  0xdc00-0xdcff]
> > [    0.130333] pci 0000:00:11.5: reg 0x14: [io  0xe000-0xe003]
> > [    0.130367] pci 0000:00:11.5: reg 0x18: [io  0xe400-0xe403]
> > [    0.130958] pci 0000:00:12.0: [1106:3065] type 00 class 0x020000
> > [    0.131004] pci 0000:00:12.0: reg 0x10: [io  0xe800-0xe8ff]
> > [    0.131041] pci 0000:00:12.0: reg 0x14: [mem 0xe4001000-0xe40010ff]
> > [    0.131132] pci 0000:00:12.0: supports D1 D2
> > [    0.131156] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.131692] pci 0000:00:14.0: [1317:0985] type 00 class 0x020000
> > [    0.131739] pci 0000:00:14.0: reg 0x10: [io  0xec00-0xecff]
> > [    0.131775] pci 0000:00:14.0: reg 0x14: [mem 0xe4000000-0xe40003ff]
> > [    0.131845] pci 0000:00:14.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
> > [    0.131892] pci 0000:00:14.0: supports D1 D2
> > [    0.131915] pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.132666] pci 0000:01:00.0: [1023:8500] type 00 class 0x030000
> > [    0.132716] pci 0000:01:00.0: reg 0x10: [mem 0xe1800000-0xe1ffffff]
> > [    0.132751] pci 0000:01:00.0: reg 0x14: [mem 0xe2000000-0xe201ffff]
> > [    0.132787] pci 0000:01:00.0: reg 0x18: [mem 0xe1000000-0xe17fffff]
> > [    0.132846] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
> > [    0.132899] pci 0000:01:00.0: supports D1 D2
> > [    0.133306] pci 0000:00:01.0: PCI bridge to [bus 01]
> > [    0.133449] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe2ffffff]
> > [    0.133485] pci_bus 0000:00: on NUMA node 0
> > [    0.134422] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
> > [    0.135721] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
> > [    0.137039] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
> > [    0.138356] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
> > [    0.142304] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> > [    0.142486] vgaarb: loaded
> > [    0.142587] vgaarb: bridge control possible 0000:01:00.0
> > [    0.143442] SCSI subsystem initialized
> > [    0.143951] libata version 3.00 loaded.
> > [    0.144399] PCI: Using ACPI for IRQ routing
> > [    0.144525] PCI: pci_cache_line_size set to 32 bytes
> > [    0.144632] e820: reserve RAM buffer [mem 0x0fdf0000-0x0fffffff]
> > [    0.146023] Switched to clocksource pit
> > [    0.146620] pnp: PnP ACPI init
> > [    0.146763] ACPI: bus type PNP registered
> > [    0.148319] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
> > [    0.148460] system 00:00: [mem 0x000f0000-0x000f7fff] could not be reserved
> > [    0.148595] system 00:00: [mem 0x000f8000-0x000fbfff] could not be reserved
> > [    0.148731] system 00:00: [mem 0x000fc000-0x000fffff] could not be reserved
> > [    0.148865] system 00:00: [mem 0x0fdf0000-0x0fdfffff] could not be reserved
> > [    0.149000] system 00:00: [mem 0xffff0000-0xffffffff] has been reserved
> > [    0.149132] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> > [    0.149265] system 00:00: [mem 0x00100000-0x0fdeffff] could not be reserved
> > [    0.149399] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
> > [    0.149531] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> > [    0.149531] system 00:01: [io  0x04d0-0x04d1] has been reserved
> > [    0.149531] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> > [    0.149531] pnp 00:02: [dma 4]
> > [    0.149531] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
> > [    0.149531] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> > [    0.149531] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> > [    0.149531] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> > [    0.149531] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> > [    0.149958] pnp 00:07: [dma 3]
> > [    0.150412] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
> > [    0.150679] pnp: PnP ACPI: found 8 devices
> > [    0.150794] ACPI: bus type PNP unregistered
> > [    0.203199] Switched to clocksource acpi_pm
> > [    0.203445] pci 0000:00:01.0: BAR 9: assigned [mem 0x10000000-0x100fffff pref]
> > [    0.203640] pci 0000:00:14.0: BAR 6: assigned [mem 0x10100000-0x1011ffff pref]
> > [    0.203834] pci 0000:01:00.0: BAR 6: assigned [mem 0x10000000-0x1000ffff pref]
> > [    0.204057] pci 0000:00:01.0: PCI bridge to [bus 01]
> > [    0.204189] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe2ffffff]
> > [    0.204325] pci 0000:00:01.0:   bridge window [mem 0x10000000-0x100fffff pref]
> > [    0.204517] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> > [    0.204542] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
> > [    0.204571] pci_bus 0000:01: resource 1 [mem 0xe0000000-0xe2ffffff]
> > [    0.204598] pci_bus 0000:01: resource 2 [mem 0x10000000-0x100fffff pref]
> > [    0.204841] NET: Registered protocol family 2
> > [    0.205963] TCP established hash table entries: 2048 (order: 1, 8192 bytes)
> > [    0.206174] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
> > [    0.206380] TCP: Hash tables configured (established 2048 bind 2048)
> > [    0.206870] TCP: reno registered
> > [    0.206981] UDP hash table entries: 256 (order: 0, 4096 bytes)
> > [    0.207133] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
> > [    0.207611] NET: Registered protocol family 1
> > [    0.207799] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
> > [    0.209877] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
> > [    0.209995] PCI: setting IRQ 5 as level-triggered
> > [    0.211132] pci 0000:01:00.0: Boot video device
> > [    0.211150] PCI: CLS 32 bytes, default 32
> > [    0.212869] futex hash table entries: 256 (order: -1, 3072 bytes)
> > [    0.215298] msgmni has been set to 493
> > [    0.217203] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> > [    0.217391] io scheduler noop registered
> > [    0.217514] io scheduler cfq registered (default)
> > [    0.218489] Serial: 8250/16550 driver, 16 ports, IRQ sharing disabled
> > [    0.239868] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> > [    0.249205] Non-volatile memory driver v1.3
> > [    0.249343] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> > [    0.249514] Hangcheck: Using getrawmonotonic().
> > [    0.250120] pata_via 0000:00:11.1: version 0.3.4
> > [    0.252000] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0FFFFFFFF) is beyond end of object (length 0x4) (20140214/exoparg2-420)
> > [    0.252304] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_] (Node cf427bd0), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
> > [    0.252656] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0._GTM] (Node cf427258), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
> > [    0.253012] ata1: ACPI get timing mode failed (AE 0x300b)
> > [    0.255301] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0FFFFFFFF) is beyond end of object (length 0x4) (20140214/exoparg2-420)
> > [    0.255590] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_] (Node cf427bd0), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
> > [    0.255939] ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1._GTM] (Node cf427168), AE_AML_PACKAGE_LIMIT (20140214/psparse-536)
> > [    0.256294] ata2: ACPI get timing mode failed (AE 0x300b)
> > [    0.258711] scsi0 : pata_via
> > [    0.259791] scsi1 : pata_via
> > [    0.260460] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xd000 irq 14
> > [    0.260590] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xd008 irq 15
> > [    0.261507] i8042: PNP: No PS/2 controller found. Probing ports directly.
> > [    0.440599] ata1.00: ATA-6: WDC WD800JB-00FMA0, 13.03G13, max UDMA/100
> > [    0.440744] ata1.00: 156301488 sectors, multi 16: LBA
> > [    0.440884] ata1.00: limited to UDMA/33 due to 40-wire cable
> > [    0.480557] ata1.00: configured for UDMA/33
> > [    0.481320] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JB-00FM 13.0 PQ: 0 ANSI: 5
> > [    0.483802] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
> > [    0.484220] sd 0:0:0:0: [sda] Write Protect is off
> > [    0.485257] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [    0.485370] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [    0.510192] serio: i8042 KBD port at 0x60,0x64 irq 1
> > [    0.511449] mousedev: PS/2 mouse device common for all mice
> > [    0.512880] input: PC Speaker as /devices/platform/pcspkr/input/input1
> > [    0.513229] rtc_cmos 00:03: RTC can wake from S4
> > [    0.514057] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> > [    0.514246] rtc_cmos 00:03: alarms up to one year, y3k, 242 bytes nvram
> > [    0.517275] hidraw: raw HID events driver (C) Jiri Kosina
> > [    0.519237] TCP: cubic registered
> > [    0.519354] NET: Registered protocol family 17
> > [    0.521935] console [netcon0] enabled
> > [    0.522059] netconsole: network logging started
> > [    0.522254] rtc_cmos 00:03: setting system clock to 2014-04-21 16:22:39 UTC (1398097359)
> > [    0.531430]  sda: sda1 sda2 < sda5 >
> > [    0.534085] sd 0:0:0:0: [sda] Attached SCSI disk
> > [    0.640623] ata2.00: ATAPI: LTN486S, YUS5, max UDMA/33, CDB intr
> > [    0.660541] ata2.00: configured for UDMA/33
> > [    0.661601] scsi 1:0:0:0: CD-ROM            LITEON   CD-ROM LTN486S   YUS5 PQ: 0 ANSI: 5
> > [    0.697961] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
> > [    0.698658] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
> > [    0.798677] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> > [    0.798951] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> > [    0.841802] devtmpfs: mounted
> > [    0.844882] Freeing unused kernel memory: 296K (c13b2000 - c13fc000)
> > [    0.845406] Write protecting the kernel text: 2384k
> > [    0.845711] Write protecting the kernel read-only data: 1184k
> > [    1.210359] tsc: Refined TSC clocksource calibration: 533.352 MHz
> > [    2.211586] Switched to clocksource tsc
> > [    3.346782] systemd-udevd[507]: starting version 204
> > [    3.894441] Linux agpgart interface v0.103
> > [    3.920003] agpgart: Detected VIA Apollo ProMedia/PLE133Ta chipset
> > [    3.942911] parport_pc: VIA 686A/8231 detected
> > [    3.942931] parport_pc: probing current configuration
> > [    3.942962] parport_pc: Current parallel port base: 0x378
> > [    3.943064] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
> > [    3.950348] agpgart-via 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> > [    3.957956] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
> > [    3.958180] ACPI: Power Button [PWRB]
> > [    3.958998] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> > [    3.959177] ACPI: Power Button [PWRF]
> > [    4.040297] parport_pc: VIA parallel port: io=0x378, irq=7
> > [    4.111583] ACPI: Fan [FAN] (on)
> > [    4.493990] via_rhine: v1.10-LK1.5.1 2010-10-09 Written by Donald Becker
> > [    4.494161] via_rhine: Broken BIOS detected, avoid_D3 enabled
> > [    4.496816] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> > [    4.496944] PCI: setting IRQ 10 as level-triggered
> > [    4.502210] via-rhine 0000:00:12.0 eth0: VIA Rhine II at 0xe4001000, 00:40:63:d7:94:5e, IRQ 10
> > [    4.503188] via-rhine 0000:00:12.0 eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e1
> > [    4.509274] tulip: Linux Tulip driver version 1.1.15-NAPI (Feb 27, 2007)
> > [    4.511851] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> > [    4.511979] PCI: setting IRQ 11 as level-triggered
> > [    4.512115] tulip: tulip_init_one: Enabled WOL support for AN983B
> > [    4.512463] tulip0:  MII transceiver #1 config 1000 status 7849 advertising 05e1
> > [    4.515966] net eth1: ADMtek Comet rev 17 at MMIO 0xe4000000, 00:10:a7:17:5e:ce, IRQ 11
> > [    4.542870] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> > [    4.543120] cdrom: Uniform CD-ROM driver Revision: 3.20
> > [    4.544889] sr 1:0:0:0: Attached scsi CD-ROM sr0
> > [    4.572605] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > [    4.581904] sr 1:0:0:0: Attached scsi generic sg1 type 5
> > [    4.601998] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x0000603a-0x0000603a (\IP3_) (20140214/utaddress-258)
> > [    4.602307] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x00006039-0x00006039 (\IP2_) (20140214/utaddress-258)
> > [    4.602587] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x00006040-0x00006040 (\IP1_) (20140214/utaddress-258)
> > [    4.602865] ACPI Warning: SystemIO range 0x00006000-0x0000607f conflicts with OpRegion 0x00006020-0x00006020 (\IP0_) (20140214/utaddress-258)
> > [    4.603150] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> > [    4.623276] ACPI: bus type USB registered
> > [    4.623733] usbcore: registered new interface driver usbfs
> > [    4.623995] usbcore: registered new interface driver hub
> > [    4.650437] usbcore: registered new device driver usb
> > [    4.708794] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> > [    4.713729] uhci_hcd: USB Universal Host Controller Interface driver
> > [    4.714502] uhci_hcd 0000:00:11.2: UHCI Host Controller
> > [    4.714662] uhci_hcd 0000:00:11.2: new USB bus registered, assigned bus number 1
> > [    4.714911] uhci_hcd 0000:00:11.2: irq 5, io base 0x0000d400
> > [    4.729909] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> > [    4.730113] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > [    4.730289] usb usb1: Product: UHCI Host Controller
> > [    4.730406] usb usb1: Manufacturer: Linux 3.15.0-rc2 uhci_hcd
> > [    4.730525] usb usb1: SerialNumber: 0000:00:11.2
> > [    4.735737] hub 1-0:1.0: USB hub found
> > [    4.739961] hub 1-0:1.0: 2 ports detected
> > [    4.742202] uhci_hcd 0000:00:11.3: UHCI Host Controller
> > [    4.742372] uhci_hcd 0000:00:11.3: new USB bus registered, assigned bus number 2
> > [    4.742618] uhci_hcd 0000:00:11.3: irq 5, io base 0x0000d800
> > [    4.743448] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> > [    4.743650] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > [    4.743823] usb usb2: Product: UHCI Host Controller
> > [    4.743940] usb usb2: Manufacturer: Linux 3.15.0-rc2 uhci_hcd
> > [    4.744060] usb usb2: SerialNumber: 0000:00:11.3
> > [    4.746254] hub 2-0:1.0: USB hub found
> > [    4.746594] hub 2-0:1.0: 2 ports detected
> > [    4.884342] longhaul: VIA C3 'Samuel 2' [C5B] CPU detected.  Longhaul v2 supported.
> > [    4.884619] longhaul: Using northbridge support.
> > [    5.001516] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
> > [    5.001656] PCI: setting IRQ 12 as level-triggered
> > [    5.929527] random: nonblocking pool is initialized
> > [    7.543326] Adding 100348k swap on /dev/sda5.  Priority:-1 extents:1 across:100348k
> > [    7.685305] EXT4-fs (sda1): re-mounted. Opts: (null)
> > [    8.099358] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
> > [   13.339242] NET: Registered protocol family 10
> > [  240.080089] INFO: task kworker/0:2:357 blocked for more than 120 seconds.
> > [  240.080236]       Not tainted 3.15.0-rc2 #35
> > [  240.080346] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.080520] kworker/0:2     D c13ac240     0   357      2 0x00000000
> > [  240.080741] Workqueue: events od_dbs_timer
> > [  240.080881]  c0035dec 00000046 c10363ab c13ac240 f318d568 c0035fec c0031b50 c0031b50
> > [  240.081330]  00000286 d3928373 00000000 f318d568 fffffff8 46ab58db 00000001 d3928373
> > [  240.081778]  00000000 00000286 c0035e98 00000000 c13a5960 c0035de4 c1005c89 c138ac60
> > [  240.082228] Call Trace:
> > [  240.082377]  [<c10363ab>] ? sched_clock_tick+0x67/0x6b
> > [  240.082530]  [<c1005c89>] ? time_cpufreq_notifier.part.9+0xb1/0xb6
> > [  240.082683]  [<c12514c6>] schedule+0x5d/0x5f
> > [  240.082809]  [<c11c484f>] cpufreq_freq_transition_begin+0x4a/0x7c
> > [  240.082949]  [<c10389e6>] ? __wake_up_sync+0x14/0x14
> > [  240.083097]  [<d06de2c9>] longhaul_setstate+0x88/0x2af [longhaul]
> > [  240.083228]  [<c103258b>] ? srcu_notifier_call_chain+0x1a/0x1c
> > [  240.083367]  [<d06de56c>] longhaul_target+0x7c/0x8b [longhaul]
> > [  240.083498]  [<c11c4c2e>] __cpufreq_driver_target+0xfe/0x148
> > [  240.083628]  [<c1046b1b>] ? get_cpu_iowait_time_us+0x84/0xa3
> > [  240.083755]  [<c11c5ab2>] od_check_cpu+0x75/0x79
> > [  240.084730]  [<c11c6454>] dbs_check_cpu+0xbd/0xc5
> > [  240.084853]  [<c11c64c4>] ? need_load_eval+0x18/0x6d
> > [  240.084976]  [<c11c5c8d>] od_dbs_timer+0x78/0xd7
> > [  240.085117]  [<c102bc54>] process_one_work+0x165/0x253
> > [  240.085250]  [<c102c629>] worker_thread+0x194/0x25d
> > [  240.085379]  [<c102c495>] ? rescuer_thread+0x1ba/0x1ba
> > [  240.085514]  [<c102f910>] kthread+0xa3/0xa8
> > [  240.085650]  [<c1252f00>] ret_from_kernel_thread+0x20/0x30
> > [  240.085778]  [<c102f86d>] ? kthread_worker_fn+0x88/0x88
> > [  240.085916] INFO: task cpufreq-set:1872 blocked for more than 120 seconds.
> > [  240.086036]       Not tainted 3.15.0-rc2 #35
> > [  240.086146] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.086315] cpufreq-set     D 00000000     0  1872   1864 0x00000000
> > [  240.086503]  cf79bd64 00000082 0003ec1b 00000000 cf79bd24 cf79bfec c0425bd0 c0425bd0
> > [  240.086949]  00000002 c0425bd0 c1395ad4 c0425bfc cf79bd3c c1037116 00000001 c1395ad4
> > [  240.087397]  c125b254 c0425bd0 cf79bd54 c1033fa2 c003161c 00000000 c0425bd0 c00313d0
> > [  240.087845] Call Trace:
> > [  240.087964]  [<c1037116>] ? dequeue_task_fair+0xb8/0xbe
> > [  240.088091]  [<c1033fa2>] ? dequeue_task+0x23/0x29
> > [  240.088222]  [<c12514c6>] schedule+0x5d/0x5f
> > [  240.088342]  [<c12515fa>] schedule_preempt_disabled+0x8/0xa
> > [  240.088469]  [<c1251efd>] __mutex_lock_slowpath+0x4c/0x72
> > [  240.088594]  [<c1251aa2>] mutex_lock+0xc/0xe
> > [  240.088720]  [<c11c68f8>] cpufreq_governor_dbs+0x3df/0x428
> > [  240.088853]  [<c11c5c06>] od_cpufreq_governor_dbs+0xf/0x11
> > [  240.088979]  [<c11c3d5b>] __cpufreq_governor+0xc3/0x137
> > [  240.089106]  [<c11c3ff1>] cpufreq_set_policy+0x16f/0x17c
> > [  240.089233]  [<c11c4679>] store_scaling_governor+0x70/0x91
> > [  240.089367]  [<c107e800>] ? pipe_fcntl+0x160/0x1a4
> > [  240.089497]  [<c11c4b23>] ? cpufreq_update_policy+0x10a/0x10a
> > [  240.089632]  [<c11c4609>] ? cpufreq_parse_governor+0xf0/0xf0
> > [  240.089757]  [<c11c37ad>] store+0x4e/0x72
> > [  240.089882]  [<c10b916c>] sysfs_kf_write+0x32/0x38
> > [  240.090005]  [<c10b913a>] ? sysfs_kf_seq_show+0xb1/0xb1
> > [  240.090191]  [<c10b870e>] kernfs_fop_write+0xa9/0xef
> > [  240.090322]  [<c10b8665>] ? kernfs_vma_page_mkwrite+0x5a/0x5a
> > [  240.090460]  [<c1078d38>] vfs_write+0xa4/0x144
> > [  240.090585]  [<c1079276>] SyS_write+0x41/0x80
> > [  240.090709]  [<c12529dd>] syscall_call+0x7/0xb
> > [  360.090086] INFO: task kworker/0:2:357 blocked for more than 120 seconds.
> > [  360.090231]       Not tainted 3.15.0-rc2 #35
> > [  360.090343] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  360.090515] kworker/0:2     D c13ac240     0   357      2 0x00000000
> > [  360.090735] Workqueue: events od_dbs_timer
> > [  360.090876]  c0035dec 00000046 c10363ab c13ac240 f318d568 c0035fec c0031b50 c0031b50
> > [  360.091325]  00000286 d3928373 00000000 f318d568 fffffff8 46ab58db 00000001 d3928373
> > [  360.091773]  00000000 00000286 c0035e98 00000000 c13a5960 c0035de4 c1005c89 c138ac60
> > [  360.092222] Call Trace:
> > [  360.092370]  [<c10363ab>] ? sched_clock_tick+0x67/0x6b
> > [  360.092520]  [<c1005c89>] ? time_cpufreq_notifier.part.9+0xb1/0xb6
> > [  360.092674]  [<c12514c6>] schedule+0x5d/0x5f
> > [  360.092800]  [<c11c484f>] cpufreq_freq_transition_begin+0x4a/0x7c
> > [  360.092940]  [<c10389e6>] ? __wake_up_sync+0x14/0x14
> > [  360.093087]  [<d06de2c9>] longhaul_setstate+0x88/0x2af [longhaul]
> > [  360.093218]  [<c103258b>] ? srcu_notifier_call_chain+0x1a/0x1c
> > [  360.093355]  [<d06de56c>] longhaul_target+0x7c/0x8b [longhaul]
> > [  360.093483]  [<c11c4c2e>] __cpufreq_driver_target+0xfe/0x148
> > [  360.093613]  [<c1046b1b>] ? get_cpu_iowait_time_us+0x84/0xa3
> > [  360.093740]  [<c11c5ab2>] od_check_cpu+0x75/0x79
> > [  360.093866]  [<c11c6454>] dbs_check_cpu+0xbd/0xc5
> > [  360.093989]  [<c11c64c4>] ? need_load_eval+0x18/0x6d
> > [  360.094112]  [<c11c5c8d>] od_dbs_timer+0x78/0xd7
> > [  360.094250]  [<c102bc54>] process_one_work+0x165/0x253
> > [  360.094381]  [<c102c629>] worker_thread+0x194/0x25d
> > [  360.094508]  [<c102c495>] ? rescuer_thread+0x1ba/0x1ba
> > [  360.094638]  [<c102f910>] kthread+0xa3/0xa8
> > [  360.094769]  [<c1252f00>] ret_from_kernel_thread+0x20/0x30
> > [  360.094894]  [<c102f86d>] ? kthread_worker_fn+0x88/0x88
> > [  360.095028] INFO: task cpufreq-set:1872 blocked for more than 120 seconds.
> > [  360.095148]       Not tainted 3.15.0-rc2 #35
> > [  360.095256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  360.095427] cpufreq-set     D 00000000     0  1872   1864 0x00000000
> > [  360.095618]  cf79bd64 00000082 0003ec1b 00000000 cf79bd24 cf79bfec c0425bd0 c0425bd0
> > [  360.096065]  00000002 c0425bd0 c1395ad4 c0425bfc cf79bd3c c1037116 00000001 c1395ad4
> > [  360.096514]  c125b254 c0425bd0 cf79bd54 c1033fa2 c003161c 00000000 c0425bd0 c00313d0
> > [  360.096961] Call Trace:
> > [  360.097081]  [<c1037116>] ? dequeue_task_fair+0xb8/0xbe
> > [  360.097211]  [<c1033fa2>] ? dequeue_task+0x23/0x29
> > [  360.097341]  [<c12514c6>] schedule+0x5d/0x5f
> > [  360.097462]  [<c12515fa>] schedule_preempt_disabled+0x8/0xa
> > [  360.097591]  [<c1251efd>] __mutex_lock_slowpath+0x4c/0x72
> > [  360.097717]  [<c1251aa2>] mutex_lock+0xc/0xe
> > [  360.097842]  [<c11c68f8>] cpufreq_governor_dbs+0x3df/0x428
> > [  360.097973]  [<c11c5c06>] od_cpufreq_governor_dbs+0xf/0x11
> > [  360.098099]  [<c11c3d5b>] __cpufreq_governor+0xc3/0x137
> > [  360.098225]  [<c11c3ff1>] cpufreq_set_policy+0x16f/0x17c
> > [  360.098353]  [<c11c4679>] store_scaling_governor+0x70/0x91
> > [  360.098489]  [<c107e800>] ? pipe_fcntl+0x160/0x1a4
> > [  360.098622]  [<c11c4b23>] ? cpufreq_update_policy+0x10a/0x10a
> > [  360.098758]  [<c11c4609>] ? cpufreq_parse_governor+0xf0/0xf0
> > [  360.098884]  [<c11c37ad>] store+0x4e/0x72
> > [  360.099007]  [<c10b916c>] sysfs_kf_write+0x32/0x38
> > [  360.099130]  [<c10b913a>] ? sysfs_kf_seq_show+0xb1/0xb1
> > [  360.099275]  [<c10b870e>] kernfs_fop_write+0xa9/0xef
> > [  360.099405]  [<c10b8665>] ? kernfs_vma_page_mkwrite+0x5a/0x5a
> > [  360.099543]  [<c1078d38>] vfs_write+0xa4/0x144
> > [  360.099671]  [<c1079276>] SyS_write+0x41/0x80
> > [  360.099796]  [<c12529dd>] syscall_call+0x7/0xb
> > [  480.090084] INFO: task kworker/0:2:357 blocked for more than 120 seconds.
> > [  480.090225]       Not tainted 3.15.0-rc2 #35
> > [  480.090332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  480.090499] kworker/0:2     D c13ac240     0   357      2 0x00000000
> > [  480.090717] Workqueue: events od_dbs_timer
> > [  480.090858]  c0035dec 00000046 c10363ab c13ac240 f318d568 c0035fec c0031b50 c0031b50
> > [  480.091306]  00000286 d3928373 00000000 f318d568 fffffff8 46ab58db 00000001 d3928373
> > [  480.091753]  00000000 00000286 c0035e98 00000000 c13a5960 c0035de4 c1005c89 c138ac60
> > [  480.092201] Call Trace:
> > [  480.092346]  [<c10363ab>] ? sched_clock_tick+0x67/0x6b
> > [  480.092496]  [<c1005c89>] ? time_cpufreq_notifier.part.9+0xb1/0xb6
> > [  480.092649]  [<c12514c6>] schedule+0x5d/0x5f
> > [  480.092776]  [<c11c484f>] cpufreq_freq_transition_begin+0x4a/0x7c
> > [  480.092914]  [<c10389e6>] ? __wake_up_sync+0x14/0x14
> > [  480.093062]  [<d06de2c9>] longhaul_setstate+0x88/0x2af [longhaul]
> > [  480.093192]  [<c103258b>] ? srcu_notifier_call_chain+0x1a/0x1c
> > [  480.093328]  [<d06de56c>] longhaul_target+0x7c/0x8b [longhaul]
> > [  480.093459]  [<c11c4c2e>] __cpufreq_driver_target+0xfe/0x148
> > [  480.093594]  [<c1046b1b>] ? get_cpu_iowait_time_us+0x84/0xa3
> > [  480.093723]  [<c11c5ab2>] od_check_cpu+0x75/0x79
> > [  480.093852]  [<c11c6454>] dbs_check_cpu+0xbd/0xc5
> > [  480.093978]  [<c11c64c4>] ? need_load_eval+0x18/0x6d
> > [  480.094103]  [<c11c5c8d>] od_dbs_timer+0x78/0xd7
> > [  480.094245]  [<c102bc54>] process_one_work+0x165/0x253
> > [  480.094378]  [<c102c629>] worker_thread+0x194/0x25d
> > [  480.094507]  [<c102c495>] ? rescuer_thread+0x1ba/0x1ba
> > [  480.094642]  [<c102f910>] kthread+0xa3/0xa8
> > [  480.094777]  [<c1252f00>] ret_from_kernel_thread+0x20/0x30
> > [  480.094904]  [<c102f86d>] ? kthread_worker_fn+0x88/0x88
> > [  480.095038] INFO: task cpufreq-set:1872 blocked for more than 120 seconds.
> > [  480.095159]       Not tainted 3.15.0-rc2 #35
> > [  480.095269] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  480.095439] cpufreq-set     D 00000000     0  1872   1864 0x00000000
> > [  480.095628]  cf79bd64 00000082 0003ec1b 00000000 cf79bd24 cf79bfec c0425bd0 c0425bd0
> > [  480.096074]  00000002 c0425bd0 c1395ad4 c0425bfc cf79bd3c c1037116 00000001 c1395ad4
> > [  480.096522]  c125b254 c0425bd0 cf79bd54 c1033fa2 c003161c 00000000 c0425bd0 c00313d0
> > [  480.096971] Call Trace:
> > [  480.097090]  [<c1037116>] ? dequeue_task_fair+0xb8/0xbe
> > [  480.097219]  [<c1033fa2>] ? dequeue_task+0x23/0x29
> > [  480.097351]  [<c12514c6>] schedule+0x5d/0x5f
> > [  480.097472]  [<c12515fa>] schedule_preempt_disabled+0x8/0xa
> > [  480.097598]  [<c1251efd>] __mutex_lock_slowpath+0x4c/0x72
> > [  480.097722]  [<c1251aa2>] mutex_lock+0xc/0xe
> > [  480.097847]  [<c11c68f8>] cpufreq_governor_dbs+0x3df/0x428
> > [  480.097979]  [<c11c5c06>] od_cpufreq_governor_dbs+0xf/0x11
> > [  480.098106]  [<c11c3d5b>] __cpufreq_governor+0xc3/0x137
> > [  480.098233]  [<c11c3ff1>] cpufreq_set_policy+0x16f/0x17c
> > [  480.098362]  [<c11c4679>] store_scaling_governor+0x70/0x91
> > [  480.098496]  [<c107e800>] ? pipe_fcntl+0x160/0x1a4
> > [  480.098627]  [<c11c4b23>] ? cpufreq_update_policy+0x10a/0x10a
> > [  480.098761]  [<c11c4609>] ? cpufreq_parse_governor+0xf0/0xf0
> > [  480.098887]  [<c11c37ad>] store+0x4e/0x72
> > [  480.099012]  [<c10b916c>] sysfs_kf_write+0x32/0x38
> > [  480.099135]  [<c10b913a>] ? sysfs_kf_seq_show+0xb1/0xb1
> > [  480.099280]  [<c10b870e>] kernfs_fop_write+0xa9/0xef
> > [  480.099411]  [<c10b8665>] ? kernfs_vma_page_mkwrite+0x5a/0x5a
> > [  480.099551]  [<c1078d38>] vfs_write+0xa4/0x144
> > [  480.099677]  [<c1079276>] SyS_write+0x41/0x80
> > [  480.099800]  [<c12529dd>] syscall_call+0x7/0xb
> > [  600.090089] INFO: task kworker/0:2:357 blocked for more than 120 seconds.
> > [  600.090235]       Not tainted 3.15.0-rc2 #35
> > [  600.090344] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  600.091428] kworker/0:2     D c13ac240     0   357      2 0x00000000
> > [  600.091651] Workqueue: events od_dbs_timer
> > [  600.091792]  c0035dec 00000046 c10363ab c13ac240 f318d568 c0035fec c0031b50 c0031b50
> > [  600.092240]  00000286 d3928373 00000000 f318d568 fffffff8 46ab58db 00000001 d3928373
> > [  600.092688]  00000000 00000286 c0035e98 00000000 c13a5960 c0035de4 c1005c89 c138ac60
> > [  600.093135] Call Trace:
> > [  600.093282]  [<c10363ab>] ? sched_clock_tick+0x67/0x6b
> > [  600.093432]  [<c1005c89>] ? time_cpufreq_notifier.part.9+0xb1/0xb6
> > [  600.093584]  [<c12514c6>] schedule+0x5d/0x5f
> > [  600.093710]  [<c11c484f>] cpufreq_freq_transition_begin+0x4a/0x7c
> > [  600.093850]  [<c10389e6>] ? __wake_up_sync+0x14/0x14
> > [  600.093997]  [<d06de2c9>] longhaul_setstate+0x88/0x2af [longhaul]
> > [  600.094127]  [<c103258b>] ? srcu_notifier_call_chain+0x1a/0x1c
> > [  600.094262]  [<d06de56c>] longhaul_target+0x7c/0x8b [longhaul]
> > [  600.094393]  [<c11c4c2e>] __cpufreq_driver_target+0xfe/0x148
> > [  600.094528]  [<c1046b1b>] ? get_cpu_iowait_time_us+0x84/0xa3
> > [  600.094657]  [<c11c5ab2>] od_check_cpu+0x75/0x79
> > [  600.094784]  [<c11c6454>] dbs_check_cpu+0xbd/0xc5
> > [  600.094910]  [<c11c64c4>] ? need_load_eval+0x18/0x6d
> > [  600.095037]  [<c11c5c8d>] od_dbs_timer+0x78/0xd7
> > [  600.095180]  [<c102bc54>] process_one_work+0x165/0x253
> > [  600.095312]  [<c102c629>] worker_thread+0x194/0x25d
> > [  600.095442]  [<c102c495>] ? rescuer_thread+0x1ba/0x1ba
> > [  600.095575]  [<c102f910>] kthread+0xa3/0xa8
> > [  600.095712]  [<c1252f00>] ret_from_kernel_thread+0x20/0x30
> > [  600.095839]  [<c102f86d>] ? kthread_worker_fn+0x88/0x88
> > [  600.095974] INFO: task cpufreq-set:1872 blocked for more than 120 seconds.
> > [  600.096094]       Not tainted 3.15.0-rc2 #35
> > [  600.096203] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  600.096374] cpufreq-set     D 00000000     0  1872   1864 0x00000000
> > [  600.096562]  cf79bd64 00000082 0003ec1b 00000000 cf79bd24 cf79bfec c0425bd0 c0425bd0
> > [  600.097010]  00000002 c0425bd0 c1395ad4 c0425bfc cf79bd3c c1037116 00000001 c1395ad4
> > [  600.097459]  c125b254 c0425bd0 cf79bd54 c1033fa2 c003161c 00000000 c0425bd0 c00313d0
> > [  600.097907] Call Trace:
> > [  600.098028]  [<c1037116>] ? dequeue_task_fair+0xb8/0xbe
> > [  600.098157]  [<c1033fa2>] ? dequeue_task+0x23/0x29
> > [  600.098288]  [<c12514c6>] schedule+0x5d/0x5f
> > [  600.098408]  [<c12515fa>] schedule_preempt_disabled+0x8/0xa
> > [  600.098534]  [<c1251efd>] __mutex_lock_slowpath+0x4c/0x72
> > [  600.098659]  [<c1251aa2>] mutex_lock+0xc/0xe
> > [  600.098786]  [<c11c68f8>] cpufreq_governor_dbs+0x3df/0x428
> > [  600.098915]  [<c11c5c06>] od_cpufreq_governor_dbs+0xf/0x11
> > [  600.099039]  [<c11c3d5b>] __cpufreq_governor+0xc3/0x137
> > [  600.099164]  [<c11c3ff1>] cpufreq_set_policy+0x16f/0x17c
> > [  600.099288]  [<c11c4679>] store_scaling_governor+0x70/0x91
> > [  600.099420]  [<c107e800>] ? pipe_fcntl+0x160/0x1a4
> > [  600.099548]  [<c11c4b23>] ? cpufreq_update_policy+0x10a/0x10a
> > [  600.099680]  [<c11c4609>] ? cpufreq_parse_governor+0xf0/0xf0
> > [  600.099802]  [<c11c37ad>] store+0x4e/0x72
> > [  600.099924]  [<c10b916c>] sysfs_kf_write+0x32/0x38
> > [  600.100085]  [<c10b913a>] ? sysfs_kf_seq_show+0xb1/0xb1
> > [  600.100227]  [<c10b870e>] kernfs_fop_write+0xa9/0xef
> > [  600.100354]  [<c10b8665>] ? kernfs_vma_page_mkwrite+0x5a/0x5a
> > [  600.100494]  [<c1078d38>] vfs_write+0xa4/0x144
> > [  600.100622]  [<c1079276>] SyS_write+0x41/0x80
> > [  600.100745]  [<c12529dd>] syscall_call+0x7/0xb
> > [  720.100118] INFO: task kworker/0:2:357 blocked for more than 120 seconds.
> > [  720.100265]       Not tainted 3.15.0-rc2 #35
> > [  720.100374] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  720.100548] kworker/0:2     D c13ac240     0   357      2 0x00000000
> > [  720.100769] Workqueue: events od_dbs_timer
> > [  720.100910]  c0035dec 00000046 c10363ab c13ac240 f318d568 c0035fec c0031b50 c0031b50
> > [  720.101358]  00000286 d3928373 00000000 f318d568 fffffff8 46ab58db 00000001 d3928373
> > [  720.101804]  00000000 00000286 c0035e98 00000000 c13a5960 c0035de4 c1005c89 c138ac60
> > [  720.102254] Call Trace:
> > [  720.102403]  [<c10363ab>] ? sched_clock_tick+0x67/0x6b
> > [  720.102554]  [<c1005c89>] ? time_cpufreq_notifier.part.9+0xb1/0xb6
> > [  720.102705]  [<c12514c6>] schedule+0x5d/0x5f
> > [  720.102831]  [<c11c484f>] cpufreq_freq_transition_begin+0x4a/0x7c
> > [  720.102972]  [<c10389e6>] ? __wake_up_sync+0x14/0x14
> > [  720.103121]  [<d06de2c9>] longhaul_setstate+0x88/0x2af [longhaul]
> > [  720.103251]  [<c103258b>] ? srcu_notifier_call_chain+0x1a/0x1c
> > [  720.103387]  [<d06de56c>] longhaul_target+0x7c/0x8b [longhaul]
> > [  720.103520]  [<c11c4c2e>] __cpufreq_driver_target+0xfe/0x148
> > [  720.103653]  [<c1046b1b>] ? get_cpu_iowait_time_us+0x84/0xa3
> > [  720.103782]  [<c11c5ab2>] od_check_cpu+0x75/0x79
> > [  720.103911]  [<c11c6454>] dbs_check_cpu+0xbd/0xc5
> > [  720.104036]  [<c11c64c4>] ? need_load_eval+0x18/0x6d
> > [  720.104162]  [<c11c5c8d>] od_dbs_timer+0x78/0xd7
> > [  720.104306]  [<c102bc54>] process_one_work+0x165/0x253
> > [  720.104440]  [<c102c629>] worker_thread+0x194/0x25d
> > [  720.104571]  [<c102c495>] ? rescuer_thread+0x1ba/0x1ba
> > [  720.104703]  [<c102f910>] kthread+0xa3/0xa8
> > [  720.104839]  [<c1252f00>] ret_from_kernel_thread+0x20/0x30
> > [  720.104967]  [<c102f86d>] ? kthread_worker_fn+0x88/0x88
> > [  720.105102] INFO: task cpufreq-set:1872 blocked for more than 120 seconds.
> > [  720.105223]       Not tainted 3.15.0-rc2 #35
> > [  720.105331] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  720.105501] cpufreq-set     D 00000000     0  1872   1864 0x00000000
> > [  720.105691]  cf79bd64 00000082 0003ec1b 00000000 cf79bd24 cf79bfec c0425bd0 c0425bd0
> > [  720.106140]  00000002 c0425bd0 c1395ad4 c0425bfc cf79bd3c c1037116 00000001 c1395ad4
> > [  720.106591]  c125b254 c0425bd0 cf79bd54 c1033fa2 c003161c 00000000 c0425bd0 c00313d0
> > [  720.107039] Call Trace:
> > [  720.107158]  [<c1037116>] ? dequeue_task_fair+0xb8/0xbe
> > [  720.107285]  [<c1033fa2>] ? dequeue_task+0x23/0x29
> > [  720.107415]  [<c12514c6>] schedule+0x5d/0x5f
> > [  720.107535]  [<c12515fa>] schedule_preempt_disabled+0x8/0xa
> > [  720.107663]  [<c1251efd>] __mutex_lock_slowpath+0x4c/0x72
> > [  720.107789]  [<c1251aa2>] mutex_lock+0xc/0xe
> > [  720.107916]  [<c11c68f8>] cpufreq_governor_dbs+0x3df/0x428
> > [  720.108049]  [<c11c5c06>] od_cpufreq_governor_dbs+0xf/0x11
> > [  720.108174]  [<c11c3d5b>] __cpufreq_governor+0xc3/0x137
> > [  720.108302]  [<c11c3ff1>] cpufreq_set_policy+0x16f/0x17c
> > [  720.108429]  [<c11c4679>] store_scaling_governor+0x70/0x91
> > [  720.108565]  [<c107e800>] ? pipe_fcntl+0x160/0x1a4
> > [  720.108697]  [<c11c4b23>] ? cpufreq_update_policy+0x10a/0x10a
> > [  720.108829]  [<c11c4609>] ? cpufreq_parse_governor+0xf0/0xf0
> > [  720.108951]  [<c11c37ad>] store+0x4e/0x72
> > [  720.109073]  [<c10b916c>] sysfs_kf_write+0x32/0x38
> > [  720.109194]  [<c10b913a>] ? sysfs_kf_seq_show+0xb1/0xb1
> > [  720.109335]  [<c10b870e>] kernfs_fop_write+0xa9/0xef
> > [  720.109463]  [<c10b8665>] ? kernfs_vma_page_mkwrite+0x5a/0x5a
> > [  720.109598]  [<c1078d38>] vfs_write+0xa4/0x144
> > [  720.109722]  [<c1079276>] SyS_write+0x41/0x80
> > [  720.109843]  [<c12529dd>] syscall_call+0x7/0xb
> >
> > --
> > Meelis Roos (mroos@linux.ee)
> 

-- 
Meelis Roos (mroos@linux.ee)
