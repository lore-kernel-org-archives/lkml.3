Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3I0XKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:10:23 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:39767 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3I0XKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:10:20 -0400
Date: Sat, 28 Sep 2013 02:10:12 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12-rc2 - MIPS regression
Message-ID: <20130927231012.GB4572@blackmetal.musicnaut.iki.fi>
References: <CA+55aFxoF75RJfkp0vnm-b9B0h7PGMitrQiLyTt315tKvG-wTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxoF75RJfkp0vnm-b9B0h7PGMitrQiLyTt315tKvG-wTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

3.12-rc2 breaks the boot (BUG: scheduling while atomic, see logs below)
on Lemote Mini-PC (MIPS). According to git bisect, this is caused by:

ff522058bd717506b2fa066fa564657f2b86477e is the first bad commit
commit ff522058bd717506b2fa066fa564657f2b86477e
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Tue Sep 17 12:44:31 2013 +0200

    MIPS: Fix accessing to per-cpu data when flushing the cache

Reverting the commit from v3.12-rc2 makes the board boot fine.

Here's the console log from the problem situation (vanilla 3.12-rc2),
it seems the logging is never stopping, so just the first few screenfuls:

[    0.000000] Linux version 3.12.0-rc2-lemote-los.git-5318619-dirty (aaro@blackmetal) (gcc version 4.8.1 (GCC) ) #1 PREEMPT Sat Sep 28 01:52:37 EEST 2013
[    0.000000] busclock=66000000, cpuclock=797780000, memsize=256, highmemsize=256
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU revision is: 00006303 (ICT Loongson-2)
[    0.000000] FPU revision is: 00000501
[    0.000000] Checking for the multiply/shift bug... no.
[    0.000000] Checking for the daddiu bug... no.
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 0000000010000000 @ 0000000000000000 (usable)
[    0.000000]  memory: 0000000030000000 @ 0000000010000000 (reserved)
[    0.000000]  memory: 0000000010000000 @ 0000000090000000 (usable)
[    0.000000]  memory: 0000000010000000 @ 0000000080000000 (reserved)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0x9fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0x3fffffff]
[    0.000000]   node   0: [mem 0x80000000-0x9fffffff]
[    0.000000] Reserving 0MB of memory at 0MB for crashkernel
[    0.000000] Primary instruction cache 64kB, VIPT, direct mapped, linesize 32 bytes.
[    0.000000] Primary data cache 64kB, 4-way, VIPT, no aliases, linesize 32 bytes
[    0.000000] Unified secondary cache 512kB 4-way, linesize 32 bytes.
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 97968
[    0.000000] Kernel command line: console=tty console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 1, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 7, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 6, 1048576 bytes)
[    0.000000] Memory: 501904K/1572864K available (4091K kernel code, 264K rwdata, 884K rodata, 9824K init, 195K bss, 1070960K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:128
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.008000] Calibrating delay loop... 528.38 BogoMIPS (lpj=1056768)
[    0.044000] pid_max: default: 32768 minimum: 301
[    0.048000] Mount-cache hash table entries: 1024
[    0.052000] Checking for the daddi bug... no.
[    0.056000] devtmpfs: initialized
[    0.060000] NET: Registered protocol family 16
[    0.080000] bio: create slab <bio-0> at 0
[    0.088000] SCSI subsystem initialized
[    0.092000] usbcore: registered new interface driver usbfs
[    0.096000] usbcore: registered new interface driver hub
[    0.100000] usbcore: registered new device driver usb
[    0.104000] PCI host bridge to bus 0000:00
[    0.108000] pci_bus 0000:00: root bus resource [mem 0x40000000-0x7fffffff]
[    0.112000] pci_bus 0000:00: root bus resource [io  0x4000-0xffff]
[    0.116000] pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
[    0.124000] pci 0000:00:08.0: BAR 0: assigned [mem 0x40000000-0x4fffffff pref]
[    0.128000] pci 0000:00:08.0: BAR 1: assigned [mem 0x50000000-0x5003ffff]
[    0.132000] pci 0000:00:06.0: BAR 6: assigned [mem 0x50040000-0x5005ffff pref]
[    0.136000] pci 0000:00:08.0: BAR 6: assigned [mem 0x50060000-0x5006ffff pref]
[    0.140000] pci 0000:00:0e.4: BAR 0: assigned [mem 0x50070000-0x50070fff]
[    0.144000] pci 0000:00:0e.5: BAR 0: assigned [mem 0x50071000-0x50071fff]
[    0.148000] pci 0000:00:06.0: BAR 0: assigned [io  0x4000-0x40ff]
[    0.152000] pci 0000:00:06.0: BAR 1: assigned [mem 0x50072000-0x500720ff]
[    0.156000] pci 0000:00:0e.0: BAR 1: assigned [io  0x4400-0x44ff]
[    0.160000] pci 0000:00:08.0: BAR 2: assigned [io  0x4800-0x487f]
[    0.164000] pci 0000:00:0e.0: BAR 4: assigned [io  0x4880-0x48ff]
[    0.168000] pci 0000:00:0e.3: BAR 0: assigned [io  0x4c00-0x4c7f]
[    0.172000] pci 0000:00:0e.0: BAR 2: assigned [io  0x4c80-0x4cbf]
[    0.176000] pci 0000:00:0e.0: BAR 5: assigned [io  0x4cc0-0x4cdf]
[    0.180000] pci 0000:00:0e.2: BAR 4: assigned [io  0x4ce0-0x4cef]
[    0.184000] pci 0000:00:0e.0: BAR 0: assigned [io  0x4cf0-0x4cf7]
[    0.188000] slot: 6, pin: 1, irq: 36
[    0.192000] slot: 8, pin: 1, irq: 38
[    0.196000] Switched to clocksource mfgpt
[    0.212000] NET: Registered protocol family 2
[    0.216000] TCP established hash table entries: 16384 (order: 4, 262144 bytes)
[    0.220000] TCP bind hash table entries: 16384 (order: 3, 131072 bytes)
[    0.224000] TCP: Hash tables configured (established 16384 bind 16384)
[    0.228000] TCP: reno registered
[    0.232000] UDP hash table entries: 1024 (order: 1, 32768 bytes)
[    0.236000] UDP-Lite hash table entries: 1024 (order: 1, 32768 bytes)
[    0.240000] NET: Registered protocol family 1
[    0.244000] PCI: Enabling device 0000:00:0e.4 (0000 -> 0002)
[    0.692000] msgmni has been set to 980
[    0.704000] io scheduler noop registered
[    0.708000] io scheduler cfq registered (default)
[    0.716000] sisfb 0000:00:08.0: Invalid ROM contents
[    0.724000] sisfb: Video ROM not found
[    0.724000] sisfb: Video RAM at 0x40000000, mapped to 0x9000000040000000, size 32768k
[    0.728000] sisfb: MMIO at 0x50000000, mapped to 0x9000000050000000, size 256k
[    0.732000] sisfb: Memory heap starting at 32160K, size 32K
[    0.876000] sisfb: Detected SiS301C video bridge
[    1.108000] sisfb: CRT1 DDC supported
[    1.108000] sisfb: CRT1 DDC level: 2 
[    1.264000] sisfb: Monitor range H 31-61KHz, V 56-75Hz, Max. dotclock 78MHz
[    1.268000] sisfb: Default mode is 800x600x8 (60Hz)
[    1.300000] Console: switching to colour frame buffer device 100x37
[    1.320000] sisfb: 2D acceleration is enabled, y-panning enabled (auto-max)
[    1.324000] fb0: SiS 315PRO frame buffer device version 1.8.9
[    1.328000] sisfb: Copyright (C) 2001-2005 Thomas Winischhofer
[    1.476000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.512000] serial8250.0: ttyS0 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.524000] console [ttyS0] enabled, bootconsole disabled
[    1.524000] console [ttyS0] enabled, bootconsole disabled
[    1.608000] rtc: SRM (post-2000) epoch (2000) detected
[    1.616000] Real Time Clock Driver v1.12b
[    1.756000] brd: module loaded
[    1.832000] loop: module loaded
[    1.856000] Uniform Multi-Platform E-IDE driver
[    1.872000] amd74xx 0000:00:0e.2: UDMA100 controller
[    1.880000] amd74xx 0000:00:0e.2: IDE controller (0x1022:0x209a rev 0x01)
[    1.884000] amd74xx 0000:00:0e.2: IDE port disabled
[    1.888000] amd74xx 0000:00:0e.2: not 100% native mode: will probe irqs later
[    1.892000]     ide0: BM-DMA at 0x4ce0-0x4ce7
[    1.904000] BUG: scheduling while atomic: swapper/1/0x00000002
[    1.908000] Modules linked in:
[    1.916000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    1.920000] Stack : 0000000031aac000 ffffffff810d0000 0000000000000052 ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290000 ffffffff805f312c 980000009f05b5d8 ffffffff80233518
	  980000009f05b5e8 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    2.028000] Call Trace:
[    2.032000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    2.036000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    2.040000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    2.044000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    2.048000] [<ffffffff80240314>] msleep+0x3c/0x60
[    2.052000] [<ffffffff80495400>] do_probe+0x238/0x3a8
[    2.056000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    2.060000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    2.064000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    2.068000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    2.072000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    2.076000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    2.080000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    2.084000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    2.088000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    2.092000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    2.096000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    2.100000] 
[    2.104000] BUG: scheduling while atomic: swapper/1/0x00000002
[    2.108000] Modules linked in:
[    2.116000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    2.120000] Stack : 0000000031aac000 ffffffff810d0000 000000000000005d ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290000 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    2.228000] Call Trace:
[    2.232000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    2.236000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    2.240000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    2.244000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    2.248000] [<ffffffff80240314>] msleep+0x3c/0x60
[    2.252000] [<ffffffff80495420>] do_probe+0x258/0x3a8
[    2.256000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    2.260000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    2.264000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    2.268000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    2.272000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    2.276000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    2.280000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    2.284000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    2.288000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    2.292000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    2.296000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    2.300000] 
[    2.304000] BUG: scheduling while atomic: swapper/1/0x00000002
[    2.308000] Modules linked in:
[    2.312000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    2.316000] Stack : 0000000031aac000 ffffffff810d0000 000000000000005d ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f212e00 980000009f078000
	  980000009f290000 ffffffff805f312c 980000009f05b578 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b4c0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    2.424000] Call Trace:
[    2.428000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    2.432000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    2.436000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    2.440000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    2.444000] [<ffffffff80240314>] msleep+0x3c/0x60
[    2.448000] [<ffffffff8049505c>] ide_dev_read_id+0x254/0x3c0
[    2.452000] [<ffffffff804952a4>] do_probe+0xdc/0x3a8
[    2.456000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    2.460000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    2.464000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    2.468000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    2.472000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    2.476000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    2.480000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    2.484000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    2.488000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    2.492000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    2.496000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    2.500000] 
[    2.504000] BUG: scheduling while atomic: swapper/1/0x00000002
[    2.508000] Modules linked in:
[    2.516000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    2.520000] Stack : 0000000031aac000 ffffffff810d0000 000000000000005d ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f212e00 980000009f078000
	  980000009f290000 ffffffff805f312c 980000009f05b548 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b490 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    2.636000] Call Trace:
[    2.640000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    2.644000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    2.648000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    2.652000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    2.656000] [<ffffffff80240314>] msleep+0x3c/0x60
[    2.660000] [<ffffffff80494d88>] ide_busy_sleep+0x78/0xf8
[    2.664000] [<ffffffff80494fec>] ide_dev_read_id+0x1e4/0x3c0
[    2.668000] [<ffffffff804952a4>] do_probe+0xdc/0x3a8
[    2.672000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    2.676000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    2.680000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    2.684000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    2.688000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    2.692000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    2.696000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    2.700000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    2.704000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    2.708000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    2.712000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    2.716000] 
[    2.720000] BUG: scheduling while atomic: swapper/1/0x00000002
[    2.724000] Modules linked in:
[    2.732000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    2.736000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f212e00 980000009f078000
	  980000009f290000 ffffffff805f312c 980000009f05b578 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b4c0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    2.848000] Call Trace:
[    2.852000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    2.856000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    2.860000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    2.864000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    2.868000] [<ffffffff80240314>] msleep+0x3c/0x60
[    2.872000] [<ffffffff8049506c>] ide_dev_read_id+0x264/0x3c0
[    2.876000] [<ffffffff804952a4>] do_probe+0xdc/0x3a8
[    2.880000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    2.884000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    2.888000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    2.892000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    2.896000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    2.900000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    2.904000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    2.908000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    2.912000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    2.916000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    2.920000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    2.924000] 
[    2.928000] hda: WDC WD1600BEVS-00VAT0, ATA DISK drive
[    2.932000] BUG: scheduling while atomic: swapper/1/0x00000002
[    2.936000] Modules linked in:
[    2.944000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    2.948000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    3.060000] Call Trace:
[    3.064000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    3.068000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    3.072000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    3.076000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    3.080000] [<ffffffff80240314>] msleep+0x3c/0x60
[    3.084000] [<ffffffff80495400>] do_probe+0x238/0x3a8
[    3.088000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    3.092000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    3.096000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    3.100000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    3.104000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    3.108000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    3.112000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    3.116000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    3.120000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    3.124000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    3.128000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    3.132000] 
[    3.136000] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.140000] Modules linked in:
[    3.148000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    3.152000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    3.268000] Call Trace:
[    3.272000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    3.276000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    3.280000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    3.284000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    3.288000] [<ffffffff80240314>] msleep+0x3c/0x60
[    3.292000] [<ffffffff80495420>] do_probe+0x258/0x3a8
[    3.296000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    3.300000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    3.304000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    3.308000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    3.312000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    3.316000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    3.320000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    3.324000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    3.328000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    3.332000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    3.336000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    3.340000] 
[    3.344000] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.348000] Modules linked in:
[    3.356000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    3.360000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    3.468000] Call Trace:
[    3.472000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    3.476000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    3.480000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    3.484000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    3.488000] [<ffffffff80240314>] msleep+0x3c/0x60
[    3.492000] [<ffffffff80495318>] do_probe+0x150/0x3a8
[    3.496000] [<ffffffff804958b0>] ide_probe_port+0x340/0x7e8
[    3.500000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    3.504000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    3.508000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    3.512000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    3.516000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    3.520000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    3.524000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    3.528000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    3.532000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    3.536000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    3.540000] 
[    3.544000] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.548000] Modules linked in:
[    3.556000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    3.560000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    3.668000] Call Trace:
[    3.672000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    3.676000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    3.680000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    3.684000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    3.688000] [<ffffffff80240314>] msleep+0x3c/0x60
[    3.692000] [<ffffffff80495400>] do_probe+0x238/0x3a8
[    3.696000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    3.700000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    3.704000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    3.708000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    3.712000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    3.716000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    3.720000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    3.724000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    3.728000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    3.732000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    3.736000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    3.740000] 
[    3.744000] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.748000] Modules linked in:
[    3.756000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    3.760000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 ffffffff806b0000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    3.868000] Call Trace:
[    3.872000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    3.876000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    3.880000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    3.884000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    3.888000] [<ffffffff80240314>] msleep+0x3c/0x60
[    3.892000] [<ffffffff80495420>] do_probe+0x258/0x3a8
[    3.896000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    3.900000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    3.904000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    3.908000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    3.912000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    3.916000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    3.920000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    3.924000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    3.928000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    3.932000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    3.936000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    3.940000] 
[    3.944000] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.948000] Modules linked in:
[    3.952000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    3.956000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f213000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b578 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b4c0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    4.064000] Call Trace:
[    4.068000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    4.072000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    4.076000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    4.080000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    4.084000] [<ffffffff80240314>] msleep+0x3c/0x60
[    4.088000] [<ffffffff8049505c>] ide_dev_read_id+0x254/0x3c0
[    4.092000] [<ffffffff804952a4>] do_probe+0xdc/0x3a8
[    4.096000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    4.100000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    4.104000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    4.108000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    4.112000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    4.116000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    4.120000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    4.124000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    4.128000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    4.132000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    4.136000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    4.140000] 
[    4.144000] BUG: scheduling while atomic: swapper/1/0x00000002
[    4.148000] Modules linked in:
[    4.156000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    4.160000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f213000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b548 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b490 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    4.268000] Call Trace:
[    4.272000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    4.276000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    4.280000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    4.284000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    4.288000] [<ffffffff80240314>] msleep+0x3c/0x60
[    4.292000] [<ffffffff80494d88>] ide_busy_sleep+0x78/0xf8
[    4.296000] [<ffffffff80494fec>] ide_dev_read_id+0x1e4/0x3c0
[    4.300000] [<ffffffff804952a4>] do_probe+0xdc/0x3a8
[    4.304000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    4.308000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    4.312000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    4.316000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    4.320000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    4.324000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    4.328000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    4.332000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    4.336000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    4.340000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    4.344000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    4.348000] 
[    4.352000] BUG: scheduling while atomic: swapper/1/0x00000002
[    4.356000] Modules linked in:
[    4.364000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    4.368000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f213000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b578 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b4c0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    4.472000] Call Trace:
[    4.476000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    4.480000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    4.484000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    4.488000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    4.492000] [<ffffffff80240314>] msleep+0x3c/0x60
[    4.496000] [<ffffffff8049506c>] ide_dev_read_id+0x264/0x3c0
[    4.500000] [<ffffffff804952a4>] do_probe+0xdc/0x3a8
[    4.504000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    4.508000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    4.512000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    4.516000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    4.520000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    4.524000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    4.528000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    4.532000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    4.536000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    4.540000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    4.544000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    4.548000] 
[    4.552000] BUG: scheduling while atomic: swapper/1/0x00000002
[    4.556000] Modules linked in:
[    4.564000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    4.568000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f213000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b578 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b4c0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    4.680000] Call Trace:
[    4.684000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    4.688000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    4.692000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    4.696000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    4.700000] [<ffffffff80240314>] msleep+0x3c/0x60
[    4.704000] [<ffffffff8049505c>] ide_dev_read_id+0x254/0x3c0
[    4.708000] [<ffffffff8049538c>] do_probe+0x1c4/0x3a8
[    4.712000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    4.716000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    4.720000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    4.724000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    4.728000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    4.732000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    4.736000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    4.740000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    4.744000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    4.748000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    4.752000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    4.756000] 
[    4.760000] BUG: scheduling while atomic: swapper/1/0x00000002
[    4.764000] Modules linked in:
[    4.772000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    4.776000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f213000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b548 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b490 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    4.884000] Call Trace:
[    4.888000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    4.892000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    4.896000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    4.900000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    4.904000] [<ffffffff80240314>] msleep+0x3c/0x60
[    4.908000] [<ffffffff80494d88>] ide_busy_sleep+0x78/0xf8
[    4.912000] [<ffffffff80494fec>] ide_dev_read_id+0x1e4/0x3c0
[    4.916000] [<ffffffff8049538c>] do_probe+0x1c4/0x3a8
[    4.920000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    4.924000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    4.928000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    4.932000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    4.936000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    4.940000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    4.944000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    4.948000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    4.952000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    4.956000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    4.960000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    4.964000] 
[    4.968000] BUG: scheduling while atomic: swapper/1/0x00000002
[    4.972000] Modules linked in:
[    4.980000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    4.984000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 980000009f213000 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b578 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b4c0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    5.092000] Call Trace:
[    5.096000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    5.100000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    5.104000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    5.108000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    5.112000] [<ffffffff80240314>] msleep+0x3c/0x60
[    5.116000] [<ffffffff8049506c>] ide_dev_read_id+0x264/0x3c0
[    5.120000] [<ffffffff8049538c>] do_probe+0x1c4/0x3a8
[    5.124000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    5.128000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    5.132000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    5.136000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    5.140000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    5.144000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    5.148000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    5.152000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    5.156000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    5.160000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    5.164000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    5.168000] 
[    5.172000] BUG: scheduling while atomic: swapper/1/0x00000002
[    5.176000] Modules linked in:
[    5.184000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    5.188000] Stack : 0000000031aac000 ffffffff810d0000 0000000010008400 ffffffff803da854
	  0000000000000000 ffffffff803da854 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 0000000000000001 980000009f078000
	  980000009f290800 ffffffff805f312c 980000009f05b5d8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b520 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 ffffffff80700000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    5.300000] Call Trace:
[    5.304000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    5.308000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    5.312000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    5.316000] [<ffffffff805f8a58>] schedule_timeout+0x128/0x1f0
[    5.320000] [<ffffffff80240314>] msleep+0x3c/0x60
[    5.324000] [<ffffffff80495318>] do_probe+0x150/0x3a8
[    5.328000] [<ffffffff804958c8>] ide_probe_port+0x358/0x7e8
[    5.332000] [<ffffffff80496028>] ide_host_register+0x2d0/0x7a8
[    5.336000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    5.340000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    5.344000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    5.348000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    5.352000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    5.356000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    5.360000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    5.364000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    5.368000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    5.372000] 
[    5.376000] BUG: scheduling while atomic: swapper/1/0x00000002
[    5.380000] Modules linked in:
[    5.388000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    5.392000] Stack : 0000000031aac000 ffffffff810d0000 000000000000005d ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 0000000000000000 980000009f078000
	  980000009f4bd010 ffffffff805f312c 980000009f05b488 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b3d0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 0000000000000000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    5.496000] Call Trace:
[    5.500000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    5.504000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    5.508000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    5.512000] [<ffffffff805f8aa0>] schedule_timeout+0x170/0x1f0
[    5.516000] [<ffffffff805faf5c>] wait_for_common+0xec/0x1f8
[    5.520000] [<ffffffff8024abd0>] call_usermodehelper_exec+0x120/0x190
[    5.524000] [<ffffffff803d0da4>] kobject_uevent_env+0x56c/0x5b8
[    5.528000] [<ffffffff80475790>] device_add+0x410/0x700
[    5.532000] [<ffffffff80475d60>] device_create_groups_vargs+0x140/0x198
[    5.536000] [<ffffffff80475e00>] device_create+0x30/0x48
[    5.540000] [<ffffffff804960dc>] ide_host_register+0x384/0x7a8
[    5.544000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    5.548000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    5.552000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    5.556000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    5.560000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    5.564000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    5.568000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    5.572000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    5.576000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    5.580000] 
[    5.588000] hda: UDMA/100 mode selected
[    5.592000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.600000] BUG: scheduling while atomic: swapper/1/0x00000002
[    5.604000] Modules linked in:
[    5.612000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    5.616000] Stack : 0000000031aac000 ffffffff810d0000 000000000000005d ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 0000000000000000 980000009f078000
	  980000009f2900d8 ffffffff805f312c 980000009f05b4c8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b410 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 0000000000000000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    5.740000] Call Trace:
[    5.744000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    5.748000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    5.752000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    5.756000] [<ffffffff805f8aa0>] schedule_timeout+0x170/0x1f0
[    5.760000] [<ffffffff805faf5c>] wait_for_common+0xec/0x1f8
[    5.764000] [<ffffffff8024abd0>] call_usermodehelper_exec+0x120/0x190
[    5.768000] [<ffffffff803d0da4>] kobject_uevent_env+0x56c/0x5b8
[    5.772000] [<ffffffff80475790>] device_add+0x410/0x700
[    5.776000] [<ffffffff80494150>] hwif_register_devices+0x100/0x128
[    5.780000] [<ffffffff80496374>] ide_host_register+0x61c/0x7a8
[    5.784000] [<ffffffff8049c65c>] ide_pci_init_two+0x4e4/0x790
[    5.788000] [<ffffffff8049f9b8>] amd74xx_probe+0x148/0x2c8
[    5.792000] [<ffffffff803f571c>] pci_device_probe+0xc4/0x130
[    5.796000] [<ffffffff80478f60>] driver_probe_device+0x98/0x270
[    5.800000] [<ffffffff80479298>] __driver_attach+0xe0/0xe8
[    5.804000] [<ffffffff80476ab0>] bus_for_each_dev+0x78/0xe0
[    5.808000] [<ffffffff80478468>] bus_add_driver+0x230/0x310
[    5.812000] [<ffffffff80479b44>] driver_register+0x84/0x158
[    5.816000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    5.824000] 
[    5.828000] BUG: scheduling while atomic: swapper/1/0x00000002
[    5.832000] Modules linked in:
[    5.840000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    5.844000] Stack : 0000000031aac000 ffffffff810d0000 000000000000005d ffffffff802730a4
	  0000000000000000 0000000000000001 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80720000 0000000000000000 980000009f078000
	  980000009f36c100 ffffffff805f312c 980000009f05b9a8 ffffffff80233474
	  ffffffff810d3238 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05b8f0 0000000000000000 ffffffff805f2f6c
	  0000000000000000 ffffffff80700000 0000000000000000 ffffffff806fc758
	  ffffffff80700000 ffffffff8020be98 ffffffff806fceb0 ffffffff805f2f6c
	  ...
[    5.952000] Call Trace:
[    5.956000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    5.960000] [<ffffffff805f2f6c>] __schedule_bug+0x44/0x6c
[    5.964000] [<ffffffff805fac58>] __schedule+0x518/0x5b0
[    5.968000] [<ffffffff805f8aa0>] schedule_timeout+0x170/0x1f0
[    5.972000] [<ffffffff805faf5c>] wait_for_common+0xec/0x1f8
[    5.976000] [<ffffffff8024abd0>] call_usermodehelper_exec+0x120/0x190
[    5.980000] [<ffffffff803d0da4>] kobject_uevent_env+0x56c/0x5b8
[    5.984000] [<ffffffff80479b90>] driver_register+0xd0/0x158
[    5.988000] [<ffffffff80200504>] do_one_initcall+0x104/0x160
[    5.992000] 
[    6.008000] ------------[ cut here ]------------
[    6.012000] WARNING: CPU: 0 PID: 1 at init/main.c:701 do_one_initcall+0x158/0x160()
[    6.016000] initcall amd74xx_ide_init+0x0/0x18 returned with preemption imbalance 
[    6.020000] Modules linked in:
[    6.024000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.0-rc2-lemote-los.git-5318619-dirty #1
[    6.028000] Stack : 0000000000000006 ffffffff805fae48 000000000000005d ffffffff802730a4
	  0000000000000000 ffffffff802730a4 ffffffff810cdf90 ffffffff810d0000
	  ffffffff8068b968 ffffffff806f5537 ffffffff810cdf90 980000009f0782e8
	  0000000000000001 ffffffff80728238 ffffffff80747598 ffffffff80753658
	  ffffffff806e0000 ffffffff805f312c 980000009f05bcb8 ffffffff80233474
	  980000009f078048 ffffffff80274b7c 980000009f078000 ffffffff8068b968
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 980000009f05bc00 0000000000000000 ffffffff802336a4
	  0000000000000000 0000000000000000 00000000000002bd 980000009f05bd70
	  0000000000000009 ffffffff8020be98 ffffffff80689be8 ffffffff802336a4
	  ...
[    6.140000] Call Trace:
[    6.144000] [<ffffffff8020be98>] show_stack+0x80/0x98
[    6.148000] [<ffffffff802336a4>] warn_slowpath_common+0x84/0xb8
[    6.152000] [<ffffffff80233710>] warn_slowpath_fmt+0x38/0x50
[    6.156000] [<ffffffff80200558>] do_one_initcall+0x158/0x160
[    6.160000] 
[    6.164000] ---[ end trace aacf0254215b6f4f ]---
[    6.168000] ide-gd driver 1.18
[    6.176000] hda: max request size: 512KiB
[    6.532000] hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
[    6.544000] hda: cache flushes supported

[...]

A.
