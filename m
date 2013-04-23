Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3DWWZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:25:40 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58328 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab3DWWZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:25:36 -0400
Date: Wed, 24 Apr 2013 01:25:29 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: regression in 3.9-rc7-00074: irq 10: nobody cared 
Message-ID: <alpine.SOC.1.00.1304240056300.897@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I decided to test 3.9-rc on my Fujitsu Lifebook P1120. 3.8 worked 
(modulo existing radeon acceleration problem) but 3.9-rc8 gets
irq 10: nobody cared
message with long acpi backtrace while registering some diver (between 
yenta and wifi in dmesg).

/proc/interrupts:
           CPU0       
  0:    8555282    XT-PIC-XT-PIC    timer
  1:        960    XT-PIC-XT-PIC    i8042
  2:          0    XT-PIC-XT-PIC    cascade
  3:          1    XT-PIC-XT-PIC  
  4:          1    XT-PIC-XT-PIC  
  5:          1    XT-PIC-XT-PIC  
  6:          1    XT-PIC-XT-PIC  
  7:          1    XT-PIC-XT-PIC  
  8:          0    XT-PIC-XT-PIC    rtc0
  9:          2    XT-PIC-XT-PIC    acpi
 10:     242811    XT-PIC-XT-PIC    yenta, wifi0, snd_ali5451, radeon, eth0
 11:        739    XT-PIC-XT-PIC    ohci_hcd:usb1
 12:       3926    XT-PIC-XT-PIC    i8042
 14:     188710    XT-PIC-XT-PIC    pata_ali
 15:          0    XT-PIC-XT-PIC    pata_ali
NMI:          0   Non-maskable interrupts
ERR:          0

Of these, eth0 works, audio works, wifi gives a lot of scan 
failure messages (rather success but lenght=0), I do not know about 
radeon (KMS works, window borders are sometimes missing). Yenta notices 
card insertions so probably also works.

In 3.8.0, wifi behaves the same (does not find anything while scanning 
and logs to dmesg
Scan result translation succeeded (length=0)
but there is no IRQ error message.

3.9-rc7+ with irqpoll option does not change anything - the IRQ is 
probably re-enabled when loading some next driver.

Since yenta is the only driver registered so far, probably some other 
device pulls irq before driver load?

[    0.000000] Linux version 3.9.0-rc7-00074-ga86d526 (mroos@raamat) (gcc version 4.4.5 (Debian 4.4.5-8) ) #76 Sun Apr 21 18:03:56 EEST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000efdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000efe0000-0x000000000efefbff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000000efefc00-0x000000000efeffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000eff0000-0x000000000f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: FUJITSU LifeBook P Series/FJNB164, BIOS Version 1.08  02/24/2005
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xefe0 max_arch_pfn = 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
[    0.000000] Base memory trampoline at [c0098000] 98000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0ebfffff]
[    0.000000]  [mem 0x0e800000-0x0ebfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0e7fffff]
[    0.000000]  [mem 0x08000000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0ec00000-0x0efdffff]
[    0.000000]  [mem 0x0ec00000-0x0efdffff] page 4k
[    0.000000] BRK [0x0139a000, 0x0139afff] PGTABLE
[    0.000000] ACPI: RSDP 000f70a0 00014 (v00 FUJ   )
[    0.000000] ACPI: RSDT 0efedad0 0002C (v01 FUJ    MOMUS3   01080000 FUJ  00001000)
[    0.000000] ACPI: FACP 0efefa92 00074 (v01 FUJ    MOMUS3   01080000 FUJ  00001000)
[    0.000000] ACPI: DSDT 0efedafc 01F96 (v01 FUJ    MOMUS3   01080000 MSFT 01000007)
[    0.000000] ACPI: FACS 0efeffc0 00040
[    0.000000] ACPI: SSDT 0efefb06 000FA (v01 PTLTD  ACPIPST1 00000001 PTL  00000001)
[    0.000000] 239MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0efe0000
[    0.000000]   low ram: 0 - 0efe0000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0efdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0x0efdffff]
[    0.000000] On node 0 totalpages: 61307
[    0.000000] free_area_init_node: node 0, pgdat c12fedbc, node_mem_map cee00020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   Normal zone: 448 pages used for memmap
[    0.000000]   Normal zone: 57312 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xff08
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] e820: [mem 0x0f100000-0xffefffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 60827
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-rc7-00074-ga86d526 root=/dev/sda1 ro debug radeon.modeset=1
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 239288k/245632k available (2063k kernel code, 5940k reserved, 1024k data, 288k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe4000 - 0xfffff000   ( 108 kB)
[    0.000000]     vmalloc : 0xcf7e0000 - 0xfffe2000   ( 776 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcefe0000   ( 239 MB)
[    0.000000]       .init : 0xc1304000 - 0xc134c000   ( 288 kB)
[    0.000000]       .data : 0xc1203eda - 0xc1303fc0   (1024 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1203eda   (2063 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=ce806000 soft=ce808000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 793.282 MHz processor
[    0.020035] Calibrating delay loop (skipped), value calculated using timer frequency.. 1586.56 BogoMIPS (lpj=7932820)
[    0.020271] pid_max: default: 32768 minimum: 301
[    0.030736] Mount-cache hash table entries: 512
[    0.041013] CPU: Processor revision 1.4.1.0, 800 MHz
[    0.041177] CPU: Code Morphing Software revision 4.3.2-9-566
[    0.041283] CPU: 20030108 13:03 official release 28.0.3-4.3.2#1
[    0.041777] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.041777] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.041777] tlb_flushall_shift: -1
[    0.041958] CPU: Transmeta(tm) Crusoe(tm) Processor TM5800 (fam: 05, model: 04, stepping: 03)
[    0.043374] ACPI: Core revision 20130117
[    0.093789] ACPI: All ACPI Tables successfully acquired
[    0.094200] ACPI: setting ELCR to 0200 (from 0c00)
[    0.101834] Performance Events: 
[    0.130306] PM: Registering ACPI NVS region [mem 0x0efefc00-0x0efeffff] (1024 bytes)
[    0.133856] NET: Registered protocol family 16
[    0.152569] ACPI: bus type PCI registered
[    0.176974] PCI: PCI BIOS revision 2.10 entry at 0xfd8ae, last bus=1
[    0.177110] PCI: Using configuration type 1 for base access
[    0.283147] bio: create slab <bio-0> at 0
[    0.284544] ACPI: Added _OSI(Module Device)
[    0.284984] ACPI: Added _OSI(Processor Device)
[    0.285101] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.285201] ACPI: Added _OSI(Processor Aggregator Device)
[    0.289885] ACPI: EC: Look up EC in DSDT
[    0.333787] ACPI: Interpreter enabled
[    0.334001] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.334290] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.334695] ACPI: (supports S0 S3 S4 S5)
[    0.334794] ACPI: Using PIC for interrupt routing
[    0.335512] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.393542] ACPI: Power Resource [USBP] (on)
[    0.416921] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.429850] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.430145] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.430299] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.430474] acpi PNP0A03:00: host bridge window [mem 0x000d0000-0x000e7fff] (ignored)
[    0.430643] acpi PNP0A03:00: host bridge window [mem 0x0f100000-0xffefffff] (ignored)
[    0.430777] PCI: root bus 00: using default resources
[    0.430905] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.432191] PCI host bridge to bus 0000:00
[    0.432491] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.432647] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.432777] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.432974] pci 0000:00:00.0: [1279:0395] type 00 class 0x060000
[    0.433670] pci 0000:00:00.0: reg 10: [mem 0xe8100000-0xe81fffff]
[    0.436136] pci 0000:00:00.1: [1279:0396] type 00 class 0x050000
[    0.440408] pci 0000:00:00.2: [1279:0397] type 00 class 0x050000
[    0.442859] pci 0000:00:02.0: [10b9:5237] type 00 class 0x0c0310
[    0.443295] pci 0000:00:02.0: reg 10: [mem 0xe8010000-0xe8010fff]
[    0.447721] pci 0000:00:04.0: [10b9:5451] type 00 class 0x040100
[    0.448576] pci 0000:00:04.0: reg 10: [io  0x1000-0x10ff]
[    0.448966] pci 0000:00:04.0: reg 14: [mem 0xe8011000-0xe8011fff]
[    0.449439] pci 0000:00:04.0: supports D1 D2
[    0.449553] pci 0000:00:04.0: PME# supported from D2 D3hot D3cold
[    0.451328] pci 0000:00:06.0: [10b9:7101] type 00 class 0x068000
[    0.452118] pci 0000:00:06.0: quirk: [io  0xff00-0xff3f] claimed by ali7101 ACPI
[    0.452290] pci 0000:00:06.0: quirk: [io  0xff80-0xff9f] claimed by ali7101 SMB
[    0.453285] pci 0000:00:07.0: [10b9:1533] type 00 class 0x060100
[    0.454556] pci 0000:00:0c.0: [104c:ac50] type 02 class 0x060700
[    0.454774] pci 0000:00:0c.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.454932] pci 0000:00:0c.0: supports D1 D2
[    0.455320] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.456650] pci 0000:00:0f.0: [10b9:5229] type 00 class 0x0101ee
[    0.457230] pci 0000:00:0f.0: reg 18: [io  0x0170-0x0177]
[    0.457598] pci 0000:00:0f.0: reg 1c: [io  0x0374-0x0377]
[    0.457721] pci 0000:00:0f.0: reg 20: [io  0x1800-0x180f]
[    0.458712] pci 0000:00:10.0: [10ec:8139] type 00 class 0x020000
[    0.458882] pci 0000:00:10.0: reg 10: [io  0x8000-0x80ff]
[    0.459001] pci 0000:00:10.0: reg 14: [mem 0xe8012000-0xe80120ff]
[    0.459427] pci 0000:00:10.0: supports D1 D2
[    0.459529] pci 0000:00:10.0: PME# supported from D1 D2 D3hot D3cold
[    0.461296] pci 0000:00:12.0: [1260:3873] type 00 class 0x028000
[    0.461586] pci 0000:00:12.0: reg 10: [mem 0xe8013000-0xe8013fff pref]
[    0.461777] pci 0000:00:12.0: supports D1 D2
[    0.461865] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot
[    0.462968] pci 0000:00:14.0: [1002:4c59] type 00 class 0x030000
[    0.463144] pci 0000:00:14.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.463263] pci 0000:00:14.0: reg 14: [io  0x1400-0x14ff]
[    0.463482] pci 0000:00:14.0: reg 18: [mem 0xe8000000-0xe800ffff]
[    0.463758] pci 0000:00:14.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.463900] pci 0000:00:14.0: supports D1 D2
[    0.466227] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 04
[    0.466980] pci_bus 0000:00: on NUMA node 0
[    0.467207] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.471439] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *10 11)
[    0.473488] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11)
[    0.476087] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11) *0, disabled.
[    0.479547] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11)
[    0.482601] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *10 11)
[    0.484117] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11) *0, disabled.
[    0.486061] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11) *0, disabled.
[    0.490792] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *10 11)
[    0.495219] ACPI: PCI Interrupt Link [LNKU] (IRQs 3 4 5 7 10 *11)
[    0.501069] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.501368] acpi root: \_SB_.PCI0 notify handler is installed
[    0.502528] Found 1 acpi root devices
[    0.503016] ACPI: EC: GPE = 0x0, I/O: command/status = 0x66, data = 0x62
[    0.505328] ACPI: No dock devices found.
[    0.506448] vgaarb: device added: PCI:0000:00:14.0,decodes=io+mem,owns=io+mem,locks=none
[    0.506585] vgaarb: loaded
[    0.506653] vgaarb: bridge control possible 0000:00:14.0
[    0.509153] SCSI subsystem initialized
[    0.509267] ACPI: bus type ATA registered
[    0.510159] libata version 3.00 loaded.
[    0.511318] PCI: Using ACPI for IRQ routing
[    0.511634] PCI: pci_cache_line_size set to 32 bytes
[    0.512355] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    0.512457] e820: reserve RAM buffer [mem 0x0efe0000-0x0fffffff]
[    0.516483] Switching to clocksource pit
[    0.518484] pnp: PnP ACPI init
[    0.518656] ACPI: bus type PNP registered
[    0.518656] system 00:00: [io  0x040b] has been reserved
[    0.518656] system 00:00: [io  0x0480-0x048f] has been reserved
[    0.518656] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.518656] system 00:00: [io  0x04d6] has been reserved
[    0.518656] system 00:00: [io  0xf800-0xf87f] has been reserved
[    0.518656] system 00:00: [io  0xf880-0xf8ff] has been reserved
[    0.518656] system 00:00: [io  0xfd60-0xfd67] has been reserved
[    0.518656] system 00:00: [io  0xfe00] has been reserved
[    0.518656] system 00:00: [io  0xff00-0xff3f] has been reserved
[    0.518656] system 00:00: [io  0xff80-0xff9f] has been reserved
[    0.518656] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.518656] pnp 00:01: [dma 4]
[    0.518873] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.520489] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.521976] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.522924] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.524532] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.525630] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.527959] pnp: PnP ACPI: found 7 devices
[    0.528056] ACPI: bus type PNP unregistered
[    0.589803] Switching to clocksource acpi_pm
[    0.590409] pci 0000:00:0c.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.590547] pci 0000:00:0c.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.590665] pci 0000:00:0c.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.590775] pci 0000:00:0c.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.590978] pci 0000:00:0c.0: BAR 0: assigned [mem 0x10000000-0x10000fff]
[    0.591313] pci 0000:00:0c.0: BAR 9: assigned [mem 0x14000000-0x17ffffff pref]
[    0.591883] pci 0000:00:0c.0: BAR 10: assigned [mem 0x18000000-0x1bffffff]
[    0.592032] pci 0000:00:14.0: BAR 6: assigned [mem 0x10020000-0x1003ffff pref]
[    0.593003] pci 0000:00:0c.0: BAR 7: assigned [io  0x1c00-0x1cff]
[    0.593261] pci 0000:00:0c.0: BAR 8: assigned [io  0x2000-0x20ff]
[    0.593710] pci 0000:00:0c.0: CardBus bridge to [bus 01-04]
[    0.593811] pci 0000:00:0c.0:   bridge window [io  0x1c00-0x1cff]
[    0.593914] pci 0000:00:0c.0:   bridge window [io  0x2000-0x20ff]
[    0.594012] pci 0000:00:0c.0:   bridge window [mem 0x14000000-0x17ffffff pref]
[    0.594132] pci 0000:00:0c.0:   bridge window [mem 0x18000000-0x1bffffff]
[    0.595737] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.595849] PCI: setting IRQ 10 as level-triggered
[    0.596012] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.596107] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.596208] pci_bus 0000:01: resource 0 [io  0x1c00-0x1cff]
[    0.596294] pci_bus 0000:01: resource 1 [io  0x2000-0x20ff]
[    0.596382] pci_bus 0000:01: resource 2 [mem 0x14000000-0x17ffffff pref]
[    0.596472] pci_bus 0000:01: resource 3 [mem 0x18000000-0x1bffffff]
[    0.596909] NET: Registered protocol family 2
[    0.602220] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.602526] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
[    0.602735] TCP: Hash tables configured (established 2048 bind 2048)
[    0.603053] TCP: reno registered
[    0.603170] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.603538] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.604882] NET: Registered protocol family 1
[    0.607047] ACPI: PCI Interrupt Link [LNKU] enabled at IRQ 11
[    0.607155] PCI: setting IRQ 11 as level-triggered
[    0.661537] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    0.661726] pci 0000:00:14.0: Boot video device
[    0.661824] PCI: CLS 32 bytes, default 32
[    0.669114] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.672715] msgmni has been set to 467
[    0.674937] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.675083] io scheduler noop registered
[    0.675184] io scheduler cfq registered (default)
[    0.675257] list_sort_test: start testing list_sort()
[    0.680916] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.687758] pata_ali 0000:00:0f.0: can't derive routing for PCI INT A
[    0.688014] pata_ali 0000:00:0f.0: PCI INT A: no GSI
[    0.693384] scsi0 : pata_ali
[    0.694970] scsi1 : pata_ali
[    0.695647] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0x1800 irq 14
[    0.695750] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x374 bmdma 0x1808 irq 15
[    0.698778] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.702343] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.702498] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.703778] mousedev: PS/2 mouse device common for all mice
[    0.704529] rtc_cmos 00:03: RTC can wake from S4
[    0.706130] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.706344] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram
[    0.706855] cpuidle: using governor ladder
[    0.706954] cpuidle: using governor menu
[    0.714005] TCP: cubic registered
[    0.714120] NET: Registered protocol family 17
[    0.746351] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.278435] ata1.00: ATA-4: TOSHIBA MK6014MAP, N2.14 G, max UDMA/66
[    1.278619] ata1.00: 11733120 sectors, multi 16: LBA 
[    1.282980] ata1.00: configured for UDMA/66
[    1.286607] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK6014MA N2.1 PQ: 0 ANSI: 5
[    1.289532] sd 0:0:0:0: [sda] 11733120 512-byte logical blocks: (6.00 GB/5.59 GiB)
[    1.293205] sd 0:0:0:0: [sda] Write Protect is off
[    1.293326] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.294586] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.660490] tsc: Refined TSC clocksource calibration: 793.226 MHz
[    1.660841] Switching to clocksource tsc
[    1.806236]  sda: sda1 sda2 < sda5 >
[    1.841226] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.894605] kjournald starting.  Commit interval 5 seconds
[    1.895624] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    1.895902] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    1.898848] Freeing unused kernel memory: 288k freed
[    1.901519] Write protecting the kernel text: 2064k
[    1.901726] Write protecting the kernel read-only data: 828k
[    9.429879] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    9.431705] ACPI: AC Adapter [AC] (on-line)
[    9.491088] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    9.491294] ACPI: Battery Slot [CMB1] (battery present)
[    9.510688] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    9.511063] ACPI: Power Button [PWRB]
[    9.511847] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    9.512331] ACPI: Lid Switch [LID]
[    9.513386] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    9.513580] ACPI: Power Button [PWRF]
[    9.662676] yenta_cardbus 0000:00:0c.0: CardBus bridge found [10cf:10c6]
[    9.662873] yenta_cardbus 0000:00:0c.0: adjusting diagnostic: 41 -> 61
[    9.662973] yenta_cardbus 0000:00:0c.0: Using CSCINT to route CSC interrupts to PCI
[    9.663085] yenta_cardbus 0000:00:0c.0: Routing CardBus interrupts to PCI
[    9.663172] yenta_cardbus 0000:00:0c.0: TI: mfunc 0x00c61d22, devctl 0x46
[    9.851706] lib80211: common routines for IEEE802.11 drivers
[    9.851837] lib80211_crypt: registered algorithm 'NULL'
[    9.911004] yenta_cardbus 0000:00:0c.0: ISA IRQ mask 0x08f8, PCI irq 10
[    9.911130] yenta_cardbus 0000:00:0c.0: Socket status: 30000006
[   10.373431] Linux agpgart interface v0.103
[   10.867359] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   10.948238] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   10.948738] 8139cp 0000:00:10.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[   10.994523] ali1535_smbus 0000:00:06.0: enabling device (0000 -> 0001)
[   11.000571] apanel: unknown device 11 found
[   11.046210] tsc: Marking TSC unstable due to TSC halts in idle
[   11.046531] ACPI: acpi_idle registered with cpuidle
[   11.057597] Switching to clocksource acpi_pm
[   11.092274] 8139too: 8139too Fast Ethernet driver 0.9.28
[   11.094578] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   11.099306] 8139too 0000:00:10.0 eth0: RealTek RTL8139 at 0xcf7e4000, 00:0b:5d:48:63:fb, IRQ 10
[   11.153613] input: Fujitsu FUJ02B1 as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:01/FUJ02B1:00/input/input5
[   11.154240] fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
[   11.165890] fujitsu_laptop: driver 0.6.0 successfully loaded
[   11.260599] ACPI: bus type USB registered
[   11.261372] usbcore: registered new interface driver usbfs
[   11.261840] usbcore: registered new interface driver hub
[   11.412080] usbcore: registered new device driver usb
[   11.845290] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   11.865515] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.867745] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   11.868022] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[   11.868613] ohci_hcd 0000:00:02.0: irq 11, io mem 0xe8010000
[   11.926627] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   11.926772] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.926896] usb usb1: Product: OHCI Host Controller
[   11.926988] usb usb1: Manufacturer: Linux 3.9.0-rc7-00074-ga86d526 ohci_hcd
[   11.927082] usb usb1: SerialNumber: 0000:00:02.0
[   11.929071] hub 1-0:1.0: USB hub found
[   11.929551] hub 1-0:1.0: 3 ports detected
[   12.562287] irq 10: nobody cared (try booting with the "irqpoll" option)
[   12.562443] Pid: 471, comm: modprobe Not tainted 3.9.0-rc7-00074-ga86d526 #76
[   12.562523] Call Trace:
[   12.562939]  [<c10494c3>] ? __report_bad_irq+0x14/0x7c
[   12.563303]  [<c10494ca>] ? __report_bad_irq+0x1b/0x7c
[   12.563486]  [<c1049646>] ? note_interrupt+0x11b/0x184
[   12.563614]  [<c10482a2>] ? handle_irq_event_percpu+0xef/0x100
[   12.564027]  [<c1049a98>] ? handle_fasteoi_irq+0x95/0x95
[   12.564140]  [<c10482cc>] ? handle_irq_event+0x19/0x22
[   12.564635]  [<c1049b0f>] ? handle_level_irq+0x77/0x97
[   12.564718]  <IRQ>  [<c1002efc>] ? do_IRQ+0x2b/0x68
[   12.564998]  [<c120318c>] ? common_interrupt+0x2c/0x31
[   12.565284]  [<c101eaa3>] ? __do_softirq+0x51/0x116
[   12.565583]  [<c101ebbf>] ? irq_exit+0x2f/0x62
[   12.565690]  [<c1002f29>] ? do_IRQ+0x58/0x68
[   12.566297]  [<c120318c>] ? common_interrupt+0x2c/0x31
[   12.566419]  [<c118ac19>] ? pci_conf1_write+0x94/0xa1
[   12.569342]  [<c118cab7>] ? raw_pci_write+0x3a/0x46
[   12.569777]  [<c111110c>] ? acpi_os_write_pci_configuration+0x5b/0x6b
[   12.569981]  [<c111f780>] ? acpi_ev_address_space_dispatch+0x17d/0x1c3
[   12.570013]  [<c1124ae1>] ? acpi_ex_data_table_space_handler+0x2f/0x2f
[   12.570013]  [<c1121f31>] ? acpi_ex_access_region+0x1f5/0x200
[   12.570013]  [<c120207d>] ? __schedule+0x31a/0x344
[   12.570013]  [<c1122043>] ? acpi_ex_field_datum_io+0x107/0x1be
[   12.570013]  [<c11223f3>] ? acpi_ex_write_with_update_rule+0xdf/0xe8
[   12.570013]  [<c11226bd>] ? acpi_ex_insert_into_field+0x2c1/0x2e0
[   12.570013]  [<c1121bf7>] ? acpi_ex_write_data_to_field+0x18b/0x1a0
[   12.570013]  [<c112578e>] ? acpi_ex_store_object_to_node+0x8a/0xf9
[   12.570013]  [<c111dbd0>] ? acpi_ds_result_pop+0xb3/0xbf
[   12.570013]  [<c1125898>] ? acpi_ex_store+0x9b/0x1e7
[   12.570013]  [<c1123593>] ? acpi_ex_opcode_1A_1T_1R+0x3ed/0x524
[   12.570013]  [<c1125487>] ? acpi_ex_resolve_operands+0x17a/0x3f7
[   12.570013]  [<c111ca92>] ? acpi_ds_exec_end_op+0xc5/0x34b
[   12.570013]  [<c112b577>] ? acpi_ps_parse_loop+0x467/0x4cc
[   12.570013]  [<c112bcc5>] ? acpi_ps_parse_aml+0x7e/0x220
[   12.570013]  [<c112c53e>] ? acpi_ps_execute_method+0x18b/0x241
[   12.570013]  [<c1127b44>] ? acpi_ns_evaluate+0xc0/0x16e
[   12.570013]  [<c112d617>] ? acpi_rs_set_srs_method_data+0xbd/0xd9
[   12.570013]  [<c112db83>] ? acpi_set_current_resources+0x2a/0x34
[   12.570013]  [<c11181e0>] ? acpi_pci_link_set+0xf7/0x197
[   12.570013]  [<c1118444>] ? acpi_pci_link_allocate_irq+0x112/0x1ca
[   12.570013]  [<c111883c>] ? acpi_pci_irq_enable+0x75/0x165
[   12.570013]  [<c118ccf9>] ? pcibios_enable_device+0x14/0x16
[   12.570013]  [<c10fce82>] ? do_pci_enable_device+0x1f/0x34
[   12.570013]  [<c10fcf21>] ? pci_enable_device_flags+0x8a/0x9b
[   12.570013]  [<cf961e65>] ? prism2_pci_probe+0x37/0x7e2 [hostap_pci]
[   12.570013]  [<c10b2318>] ? sysfs_do_create_link_sd+0xf9/0x144
[   12.570013]  [<c10fd1ad>] ? local_pci_probe+0x11/0x1e
[   12.570013]  [<c10fdcaf>] ? pci_device_probe+0x40/0x5e
[   12.570013]  [<c1153fcd>] ? driver_probe_device+0x7d/0x153
[   12.570013]  [<c11540e3>] ? __driver_attach+0x40/0x5b
[   12.570013]  [<c11540a3>] ? driver_probe_device+0x153/0x153
[   12.570013]  [<c115303b>] ? bus_for_each_dev+0x36/0x65
[   12.570013]  [<c1153e86>] ? driver_attach+0x11/0x13
[   12.570013]  [<c11540a3>] ? driver_probe_device+0x153/0x153
[   12.570013]  [<c11534e7>] ? bus_add_driver+0x97/0x199
[   12.570013]  [<cf7f0000>] ? 0xcf7effff
[   12.570013]  [<c11544fe>] ? driver_register+0x6f/0xd1
[   12.570013]  [<cf7f0000>] ? 0xcf7effff
[   12.570013]  [<c100114f>] ? do_one_initcall+0x67/0x105
[   12.570013]  [<c1046f4f>] ? load_module+0xeeb/0x1153
[   12.570013]  [<c104729e>] ? sys_init_module+0x85/0x89
[   12.570013]  [<cf8a4000>] ? 0xcf8a3fff
[   12.570013]  [<c1202840>] ? syscall_call+0x7/0xb
[   12.570013] handlers:
[   12.570013] [<cf8287ab>] yenta_interrupt [yenta_socket]
[   12.570013] Disabling IRQ #10
[   12.577175] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
[   12.579533] hostap_pci: Registered netdevice wifi0
[   12.580424] wifi0: Original COR value: 0x0
[   12.785516] prism2_hw_init: initialized in 200 ms
[   12.786870] wifi0: NIC: id=0x8013 v1.0.0
[   12.788703] wifi0: PRI: id=0x15 v1.1.0
[   12.789032] wifi0: STA: id=0x1f v1.4.1
[   12.791077] wifi0: defaulting to host-based encryption as a workaround for firmware bug in Host AP mode WEP
[   12.791208] wifi0: defaulting to bogus WDS frame as a workaround for firmware bug in Host AP mode WDS
[   12.804446] wifi0: Intersil Prism2.5 PCI: mem=0xe8013000, irq=10
[   12.805996] wifi0: registered netdevice wlan0
[   12.888112] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[   12.888887]  excluding 0xc0000-0xcffff 0xe8000-0xfffff
[   12.894408] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[   12.895392]  clean.
[   12.898148] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[   12.898323]  clean.
[   12.920664] usb 1-3: new low-speed USB device number 2 using ohci_hcd
[   13.050201] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.073389] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input6
[   13.097797] [drm] Initialized drm 1.1.0 20060810
[   13.143548] usb 1-3: New USB device found, idVendor=0430, idProduct=0508
[   13.143907] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   13.144636] usb 1-3: Product: USB Touch Panel
[   13.144725] usb 1-3: Manufacturer: Fujitsu Takamisawa
[   13.225380] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[   13.546576] Error: Driver 'pcspkr' is already registered, aborting...
[   14.451103] hidraw: raw HID events driver (C) Jiri Kosina
[   14.873225] usbcore: registered new interface driver usbhid
[   14.873410] usbhid: USB HID core driver
[   15.091737] input: Fujitsu Takamisawa USB Touch Panel as /devices/pci0000:00/0000:00:02.0/usb1/1-3/1-3:1.0/input/input7
[   15.092835] hid-generic 0003:0430:0508.0001: input,hidraw0: USB HID v1.00 Mouse [Fujitsu Takamisawa USB Touch Panel] on usb-0000:00:02.0-3/input0
[   16.031457] [drm] radeon kernel modesetting enabled.
[   18.319368] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[   18.322085] [drm] initializing kernel modesetting (RV100 0x1002:0x4C59 0x10CF:0x11C8).
[   18.323583] [drm] register mmio base: 0xE8000000
[   18.323682] [drm] register mmio size: 65536
[   18.329107] radeon 0000:00:14.0: VRAM: 128M 0x00000000F0000000 - 0x00000000F7FFFFFF (8M used)
[   18.329272] radeon 0000:00:14.0: GTT: 512M 0x00000000D0000000 - 0x00000000EFFFFFFF
[   18.331478] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   18.331594] [drm] Driver supports precise vblank timestamp query.
[   18.331838] [drm] radeon: irq initialized.
[   18.331934] [drm] Detected VRAM RAM=128M, BAR=128M
[   18.332019] [drm] RAM width 32bits DDR
[   18.405416] [TTM] Zone  kernel: Available graphics memory: 119788 kiB
[   18.405539] [TTM] Initializing pool allocator
[   18.406726] [drm] radeon: 8M of VRAM memory ready
[   18.406841] [drm] radeon: 512M of GTT memory ready.
[   18.407396] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   18.443662] [drm] PCI GART of 512M enabled (table at 0x000000000CC80000).
[   18.445404] radeon 0000:00:14.0: WB disabled
[   18.445558] radeon 0000:00:14.0: fence driver on ring 0 use gpu addr 0x00000000d0000000 and cpu addr 0xccc20000
[   18.446650] [drm] Loading R100 Microcode
[   18.614447] [drm] radeon: ring at 0x00000000D0001000
[   18.615593] [drm] ring test succeeded in 0 usecs
[   18.617121] [drm] ib test succeeded in 0 usecs
[   18.622956] [drm] Panel ID String: Toshiba LTM07C382  XSGA 
[   18.623072] [drm] Panel Size 1024x600
[   18.666557] [drm] radeon legacy LVDS backlight initialized
[   18.666669] [drm] Radeon Display Connectors
[   18.666741] [drm] Connector 0:
[   18.666807] [drm]   VGA-1
[   18.666879] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   18.666949] [drm]   Encoders:
[   18.667014] [drm]     CRT1: INTERNAL_DAC1
[   18.667082] [drm] Connector 1:
[   18.667147] [drm]   LVDS-1
[   18.667207] [drm]   Encoders:
[   18.667273] [drm]     LCD1: INTERNAL_LVDS
[   18.811231] [drm] fb mappable at 0xF0040000
[   18.811336] [drm] vram apper at 0xF0000000
[   18.811399] [drm] size 614400
[   18.811459] [drm] fb depth is 8
[   18.811518] [drm]    pitch is 1024
[   18.812170] fbcon: radeondrmfb (fb0) is primary device
[   18.898405] Console: switching to colour frame buffer device 128x37
[   18.906467] radeon 0000:00:14.0: fb0: radeondrmfb frame buffer device
[   18.906653] radeon 0000:00:14.0: registered panic notifier
[   18.907190] [drm] Initialized radeon 2.30.0 20080528 for 0000:00:14.0 on minor 0
[   21.692334] Adding 305196k swap on /dev/sda5.  Priority:-1 extents:1 across:305196k 
[   22.392398] EXT3-fs (sda1): using internal journal
[   23.078332] loop: module loaded
[   27.315465] 8139too 0000:00:10.0 eth0: link down
[   94.066867] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input8
[   99.368814] Bluetooth: Core ver 2.16
[   99.373964] NET: Registered protocol family 31
[   99.378629] Bluetooth: HCI device and connection manager initialized
[   99.383444] Bluetooth: HCI socket layer initialized
[   99.387633] Bluetooth: L2CAP socket layer initialized
[   99.391240] Bluetooth: SCO socket layer initialized
[   99.626805] Bluetooth: RFCOMM TTY layer initialized
[   99.629710] Bluetooth: RFCOMM socket layer initialized
[   99.632499] Bluetooth: RFCOMM ver 1.11
[  100.382523] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  100.388479] Bluetooth: BNEP filters: protocol multicast
[  100.393041] Bluetooth: BNEP socket layer initialized
[  100.785012] NET: Registered protocol family 10
[  100.797352] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  100.885075] Bridge firewalling registered

-- 
Meelis Roos (mroos@linux.ee)
