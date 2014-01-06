Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaAFJzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:55:15 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55457 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAFJzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:55:09 -0500
Date: Mon, 6 Jan 2014 17:54:26 +0800
From: walimis <walimisdev@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Will Deacon <will.deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>,
        Robert Richter <rric@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jed Davis <jld@mozilla.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
 [OT]
Message-ID: <20140106095426.GB8455@pek-lwang0-d1>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
 <20130722185234.GA14519@localhost.localdomain>
 <20130729212140.GB12681@mozilla.com>
 <20130730092517.GB2478@localhost.localdomain>
 <20130730113853.46cbb00a@armhf>
 <20130730094904.GH11527@mudshark.cambridge.arm.com>
 <20130731110309.758cf0aa@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130731110309.758cf0aa@armhf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:03:09AM +0200, Jean-Francois Moine wrote:
>On Tue, 30 Jul 2013 10:49:04 +0100
>Will Deacon <will.deacon@arm.com> wrote:
>
>> On Tue, Jul 30, 2013 at 10:38:53AM +0100, Jean-Francois Moine wrote:
>> > BTW, kernels compiled with gcc-4.8 don't work.  
>> 
>> Erm. Can you elaborate please? There was an issue where SLUB would get
>> miscompiled with 4.8 due to some per-cpu variable reordering across
>> barrier(), but I fixed that for ARM in 3.10.
>
>I compiled the 3.11.0-rc3 with gcc-4.8.1 and I still get oops in ext3
>(no problem when compiled with gcc-4.6). Here is the dmesg.
Hi, all

I also encounterd the same problem and I think it's an severe issue for the arm arch.
The issue only exists when building the kernel with gcc 4.8.x and CONFIG_FRAME_POINTER=y

There was also a mail to describe the similar issue:
https://lkml.org/lkml/2013/6/13/529
http://www.spinics.net/lists/linux-ext4/msg38685.html

It can be easyly triggered when doing some ext3/ext4 operation and I got the following
backtrace:

------------[ cut here ]------------
kernel BUG at linux/fs/buffer.c:2958!
Internal error: Oops - BUG: 0 [#3] PREEMPT SMP ARM
Modules linked in: tun ext4 crc16 jbd2 loop
CPU: 0 PID: 707 Comm: dd Tainted: G      D      3.10.19-WR6.0.0.0_standard #1
task: dcf78900 ti: d7968000 task.ti: d7968000
PC is at _submit_bh+0x3c/0x24c
LR is at submit_bh+0x1c/0x20
pc : [<c013e4c4>]    lr : [<c013e6f0>]    psr: 60000013
sp : d7969b20  ip : d7969b48  fp : d7969b44
r10: ddf7ec68  r9 : 00000000  r8 : ddd24600
r7 : 00000000  r6 : 00000060  r5 : 00000000  r4 : 00020041
r3 : 00700004  r2 : 00000000  r1 : ddd24600  r0 : 00000060
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 30c5387d  Table: 18dbae40  DAC: fffffffd
Process dd (pid: 707, stack limit = 0xd7968238)
Stack: (0xd7969b20 to 0xd796a000)
9b20: 00020041 00000000 00020042 00000000 ddd24600 dcd99400 d7969b54 d7969b48
9b40: c013e6f0 c013e494 d7969bbc d7969b58 bf0391fc c013e6e0 00000400 c0596f48
9b60: ddf7ec60 ddf7ec60 00000000 00020021 00020041 00000000 00020021 00000000
9b80: 00020023 00000000 ffff0000 d7969bfc d7969bac d7969bfc d4e8b980 ddf7ec68
9ba0: d4e8b980 bf040128 ddf7ed44 d7968028 d7969bcc d7969bc0 bf03ae98 bf039054
9bc0: d7969bec d7969bd0 bf03cb3c bf03ae80 ddf7ec68 d4e8b980 dcd98400 c08c8b60
9be0: d7969c2c d7969bf0 bf03cc64 bf03cb1c bf060f7c bf0086c8 000013d3 00000000
9c00: 00000180 00000010 ddf7ec68 d4e8b980 ddf7ec68 c08c8b60 dcd99400 ddf7ed44
9c20: d7969c44 d7969c30 bf040128 bf03cba4 ddf7ec68 00000007 d7969c6c d7969c48
9c40: c0135c08 bf0400f4 00000001 00000000 ddf7ec68 c0a83e00 00000400 ddf7ed44
9c60: d7969ca4 d7969c70 c013d610 c0135b44 00000400 00000400 c0a83e00 00000000
9c80: 00000000 ddf7ec68 00000400 c0a83e00 00000000 d4e8b980 d7969cfc d7969ca8
9ca0: bf03f2f0 c013d53c 00000400 00000400 c0a83e00 00000000 d7968020 de17fc00
9cc0: 03550000 00000000 0354fc00 00000000 d7969cfc 00000000 ddf7ed44 00000400
9ce0: 00000000 de17fc00 bf0781c8 00000400 d7969d6c d7969d00 c00c802c bf03f0d4
9d00: 00000400 00000400 c0a83e00 00000000 00000000 d7968000 00000400 00000c00
9d20: 0354fc00 00000000 c0a83e00 00000000 d7969eb8 00000001 00000000 00000400
9d40: 5292f392 0354fc00 00000000 00000400 d7969eb8 00000000 00000000 de17fc00
9d60: d7969ddc d7969d70 c00c92dc c00c7ec8 0354fc00 00000000 d7969ee0 00000400
9d80: 00000000 d7968000 d7969e14 00000000 c0594e28 c00ac43c ddf7ed44 d7969ee0
9da0: d7969ec0 00000001 0353bc00 00000400 d7969eb8 0354fc00 00000000 d7969eb8
9dc0: ddf7ece0 de17fc00 d7969ec0 00000001 d7969e14 d7969de0 c00c9390 c00c8f84
9de0: 00000400 00000000 c0092dac 0354fc00 00000000 00000001 de17fc00 de17fc00
9e00: d7969ec0 00000000 d7969eac d7969e18 bf0353bc c00c9334 0354fc00 00000000
9e20: d7968000 00000002 d7969e54 d7969e38 c0597018 c00ac708 00000000 d7968000
9e40: 60000013 d7969eb8 c0047f00 60000013 ffffffff d7969ea4 c0594e24 d7968000
9e60: d7969edc c0047e9c c0594e28 00000001 d7968018 c03074a0 c0d98448 00000000
9e80: 00000001 0354fc00 00000000 00000400 d7969f78 de17fc00 00000400 00000000
9ea0: d7969f44 d7969eb0 c0110434 bf03505c 0354fc00 00000000 0001f000 00000400
9ec0: 00000001 de17fc00 00000000 00000000 00000000 dcf78900 00000000 00000000
9ee0: 0354fc00 00000000 00000000 00000000 00000400 00000000 00000400 00000000
9f00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9f20: de17fc00 de17fc00 0001f000 d7969f78 00000400 0001f000 d7969f74 d7969f48
9f40: c0110ba4 c01103bc 00000000 00000000 0354fc00 00000000 de17fc00 00000000
9f60: 0001f000 00000400 d7969fa4 d7969f78 c01110b8 c0110acc 0354fc00 00000000
9f80: 00000000 0001d2e8 00000400 00000004 c000dd68 d7968000 00000000 d7969fa8
9fa0: c000dae0 c0111078 00000000 0001d2e8 00000001 0001f000 00000400 00000000
9fc0: 00000000 0001d2e8 00000400 00000004 00000000 0001f400 00000001 00000000
9fe0: 00000000 bed83a9c 0000ca6c 4f7fa426 40000030 00000001 00000000 00000000
[<c013e4c4>] (_submit_bh+0x3c/0x24c) from [<c013e6f0>] (submit_bh+0x1c/0x20)
[<c013e6f0>] (submit_bh+0x1c/0x20) from [<bf0391fc>] (__ext4_get_inode_loc+0x1b4/0x48c [ext4])
[<bf0391fc>] (__ext4_get_inode_loc+0x1b4/0x48c [ext4]) from [<bf03ae98>] (ext4_get_inode_loc+0x24/0x28 [ext4])
[<bf03ae98>] (ext4_get_inode_loc+0x24/0x28 [ext4]) from [<bf03cb3c>] (ext4_reserve_inode_write+0x2c/0x88 [ext4])
[<bf03cb3c>] (ext4_reserve_inode_write+0x2c/0x88 [ext4]) from [<bf03cc64>] (ext4_mark_inode_dirty+0xcc/0x224 [ext4])
[<bf03cc64>] (ext4_mark_inode_dirty+0xcc/0x224 [ext4]) from [<bf040128>] (ext4_dirty_inode+0x40/0x58 [ext4])
[<bf040128>] (ext4_dirty_inode+0x40/0x58 [ext4]) from [<c0135c08>] (__mark_inode_dirty+0xd0/0x2f0)
[<c0135c08>] (__mark_inode_dirty+0xd0/0x2f0) from [<c013d610>] (generic_write_end+0xe0/0xec)
[<c013d610>] (generic_write_end+0xe0/0xec) from [<bf03f2f0>] (ext4_da_write_end+0x228/0x26c [ext4])
[<bf03f2f0>] (ext4_da_write_end+0x228/0x26c [ext4]) from [<c00c802c>] (generic_file_buffered_write+0x170/0x240)
[<c00c802c>] (generic_file_buffered_write+0x170/0x240) from [<c00c92dc>] (__generic_file_aio_write+0x364/0x3b0)
[<c00c92dc>] (__generic_file_aio_write+0x364/0x3b0) from [<c00c9390>] (generic_file_aio_write+0x68/0xc8)
[<c00c9390>] (generic_file_aio_write+0x68/0xc8) from [<bf0353bc>] (ext4_file_write+0x36c/0x454 [ext4])
[<bf0353bc>] (ext4_file_write+0x36c/0x454 [ext4]) from [<c0110434>] (do_sync_write+0x84/0xa8)
[<c0110434>] (do_sync_write+0x84/0xa8) from [<c0110ba4>] (vfs_write+0xe4/0x194)
[<c0110ba4>] (vfs_write+0xe4/0x194) from [<c01110b8>] (SyS_write+0x4c/0x7c)
[<c01110b8>] (SyS_write+0x4c/0x7c) from [<c000dae0>] (ret_fast_syscall+0x0/0x48)
Code: e7f001f2 e5913000 e3130020 1a000000 (e7f001f2) 
---[ end trace 9b74153243e868ff ]---


The BUG() is called in fs/buffer.c:
int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
{
...
        BUG_ON(!buffer_mapped(bh));
...
}

Has anyone resolved the problem? 

Best Regard.
walimis

>
>Booting Linux on physical CPU 0x0
>Linux version 3.11.0-rc3-00004-g36f571e-dirty (jef@armhf) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 PREEMPT Wed Jul 31 09:22:30 CEST 2013
>CPU: ARMv7 Processor [560f5815] revision 5 (ARMv7), cr=10c53c7d
>CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
>Machine: Marvell Dove (Flattened Device Tree), model: SolidRun CuBox
>cma: CMA: reserved 32 MiB at 3e000000
>Memory policy: ECC disabled, Data cache writeback
>On node 0 totalpages: 262144
>free_area_init_node: node 0, pgdat 804ebd2c, node_mem_map 8075b000
>  Normal zone: 2048 pages used for memmap
>  Normal zone: 0 pages reserved
>  Normal zone: 262144 pages, LIFO batch:31
>CPU: All CPU(s) started in SVC mode.
>pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
>pcpu-alloc: [0] 0 
>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096
>Kernel command line: console=ttyS0,115200n8 console=tty1,115200 root=/dev/sda7 rootwait video=HDMI-A-1:1920x1080-32@60
>PID hash table entries: 4096 (order: 2, 16384 bytes)
>Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>Memory: 1001516K/1048576K available (3715K kernel code, 177K rwdata, 980K rodata, 135K init, 129K bss, 47060K reserved)
>Virtual kernel memory layout:
>    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
>    vmalloc : 0xc0800000 - 0xff000000   (1000 MB)
>    lowmem  : 0x80000000 - 0xc0000000   (1024 MB)
>    modules : 0x7f000000 - 0x80000000   (  16 MB)
>      .text : 0x80008000 - 0x8049df34   (4696 kB)
>      .init : 0x8049e000 - 0x804bfe68   ( 136 kB)
>      .data : 0x804c0000 - 0x804ec5c0   ( 178 kB)
>       .bss : 0x804ec5c0 - 0x8050cad0   ( 130 kB)
>Preemptible hierarchical RCU implementation.
>	Dump stacks of tasks blocking RCU-preempt GP.
>NR_IRQS:135
>sched_clock: 32 bits at 166MHz, resolution 5ns, wraps every 25769ms
>Console: colour dummy device 80x30
>console [tty1] enabled
>Calibrating delay loop... 789.70 BogoMIPS (lpj=3948544)
>pid_max: default: 32768 minimum: 301
>Mount-cache hash table entries: 512
>CPU: Testing write buffer coherency: ok
>Setting up static identity map for 0x803a6620 - 0x803a6654
>devtmpfs: initialized
>pinctrl core: initialized pinctrl subsystem
>regulator-dummy: no parameters
>NET: Registered protocol family 16
>DMA: preallocated 256 KiB pool for atomic coherent allocations
>Dove 88AP510 SoC
>Tauros2: Disabling L2 prefetch.
>Tauros2: Disabling line fill burt8.
>Tauros2: Enabling L2 cache.
>Tauros2: L2 cache support initialised in ARMv7 mode.
>bio: create slab <bio-0> at 0
>USB Power: Failed to request enable GPIO1: -517
>reg-fixed-voltage 1.regulator: Failed to register regulator: -517
>platform 1.regulator: Driver reg-fixed-voltage requests probe deferral
>SCSI subsystem initialized
>libata version 3.00 loaded.
>usbcore: registered new interface driver usbfs
>usbcore: registered new interface driver hub
>usbcore: registered new device driver usb
>Linux video capture interface: v2.00
>Advanced Linux Sound Architecture Driver Initialized.
>Switched to clocksource orion_clocksource
>NET: Registered protocol family 2
>TCP established hash table entries: 8192 (order: 4, 65536 bytes)
>TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
>TCP: Hash tables configured (established 8192 bind 8192)
>TCP: reno registered
>UDP hash table entries: 512 (order: 1, 8192 bytes)
>UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
>NET: Registered protocol family 1
>audit: initializing netlink socket (disabled)
>type=2000 audit(0.070:1): initialized
>msgmni has been set to 2020
>io scheduler noop registered
>io scheduler deadline registered
>io scheduler cfq registered (default)
>dove-pinctrl f10d0200.pinctrl: registered pinctrl driver
>mv_xor f1060800.dma-engine: Marvell shared XOR driver
>mv_xor f1060800.dma-engine: Marvell XOR: ( xor cpy )
>mv_xor f1060800.dma-engine: Marvell XOR: ( xor cpy )
>mv_xor f1060900.dma-engine: Marvell shared XOR driver
>mv_xor f1060900.dma-engine: Marvell XOR: ( xor cpy )
>mv_xor f1060900.dma-engine: Marvell XOR: ( xor cpy )
>Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
>f1012000.serial: ttyS0 at MMIO 0xf1012000 (irq = 7) is a 16550A
>console [ttyS0] enabled
>brd: module loaded
>sata_mv f10a0000.sata: version 1.28
>sata_mv f10a0000.sata: slots 32 ports 1
>scsi0 : sata_mv
>ata1: SATA max UDMA/133 irq 62
>libphy: orion_mdio_bus: probed
>mv643xx_eth: MV-643xx 10/100/1000 ethernet driver version 1.4
>libphy: PHY orion-mdio-mii:08 not found
>libphy: PHY orion-mdio-mii:09 not found
>libphy: PHY orion-mdio-mii:0a not found
>libphy: PHY orion-mdio-mii:0b not found
>libphy: PHY orion-mdio-mii:0c not found
>libphy: PHY orion-mdio-mii:0d not found
>libphy: PHY orion-mdio-mii:0e not found
>libphy: PHY orion-mdio-mii:0f not found
>libphy: PHY orion-mdio-mii:10 not found
>libphy: PHY orion-mdio-mii:11 not found
>libphy: PHY orion-mdio-mii:12 not found
>libphy: PHY orion-mdio-mii:13 not found
>libphy: PHY orion-mdio-mii:14 not found
>libphy: PHY orion-mdio-mii:15 not found
>libphy: PHY orion-mdio-mii:16 not found
>libphy: PHY orion-mdio-mii:17 not found
>libphy: PHY orion-mdio-mii:18 not found
>libphy: PHY orion-mdio-mii:19 not found
>libphy: PHY orion-mdio-mii:1a not found
>libphy: PHY orion-mdio-mii:1b not found
>libphy: PHY orion-mdio-mii:1c not found
>libphy: PHY orion-mdio-mii:1d not found
>libphy: PHY orion-mdio-mii:1e not found
>libphy: PHY orion-mdio-mii:1f not found
>libphy: PHY orion-mdio-mii:00 not found
>mv643xx_eth_port mv643xx_eth_port.0 eth0: port 0 with MAC address 00:50:43:b6:3b:10
>ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>ehci-orion: EHCI orion driver
>orion-ehci f1050000.usb-host: EHCI Host Controller
>orion-ehci f1050000.usb-host: new USB bus registered, assigned bus number 1
>orion-ehci f1050000.usb-host: irq 24, io mem 0xf1050000
>orion-ehci f1050000.usb-host: USB 2.0 started, EHCI 1.00
>hub 1-0:1.0: USB hub found
>hub 1-0:1.0: 1 port detected
>orion-ehci f1051000.usb-host: EHCI Host Controller
>orion-ehci f1051000.usb-host: new USB bus registered, assigned bus number 2
>orion-ehci f1051000.usb-host: irq 25, io mem 0xf1051000
>orion-ehci f1051000.usb-host: USB 2.0 started, EHCI 1.00
>hub 2-0:1.0: USB hub found
>hub 2-0:1.0: 1 port detected
>usbcore: registered new interface driver usb-storage
>mousedev: PS/2 mouse device common for all mice
>rtc-mv f10d8500.rtc: rtc core: registered f10d8500.rtc as rtc0
>sdhci: Secure Digital Host Controller Interface driver
>sdhci: Copyright(c) Pierre Ossman
>sdhci-pltfm: SDHCI platform and OF driver helper
>mmc0: no vqmmc regulator found
>mmc0: no vmmc regulator found
>mmc0: SDHCI controller on f1092000.sdio [f1092000.sdio] using DMA
>usbcore: registered new interface driver usbhid
>usbhid: USB HID core driver
>TCP: cubic registered
>NET: Registered protocol family 10
>NET: Registered protocol family 17
>VFP support v0.3: implementor 56 architecture 2 part 20 variant 9 rev 5
>ThumbEE CPU extension supported.
>PJ4 iWMMXt coprocessor enabled.
>USB Power: 5000 mV 
>rtc-mv f10d8500.rtc: setting system clock to 2013-07-31 08:15:22 UTC (1375258522)
>ALSA device list:
>  No soundcards found.
>ata1: SATA link down (SStatus 0 SControl F300)
>mmc0: new high speed SDHC card at address e624
>mmcblk0: mmc0:e624 SU16G 14.8 GiB 
> mmcblk0: p1 p2 p3
>Waiting for root device /dev/sda7...
>usb 1-1: new high-speed USB device number 2 using orion-ehci
>usb-storage 1-1:1.0: USB Mass Storage device detected
>scsi1 : usb-storage 1-1:1.0
>usb 2-1: new high-speed USB device number 2 using orion-ehci
>hub 2-1:1.0: USB hub found
>hub 2-1:1.0: 4 ports detected
>usb 2-1.4: new high-speed USB device number 3 using orion-ehci
>hub 2-1.4:1.0: USB hub found
>hub 2-1.4:1.0: 4 ports detected
>usb 2-1.4.2: new high-speed USB device number 4 using orion-ehci
>scsi 1:0:0:0: Direct-Access     WDC WD25 00JB-55REA0      20.0 PQ: 0 ANSI: 0
>sd 1:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
>sd 1:0:0:0: [sda] Write Protect is off
>sd 1:0:0:0: [sda] Mode Sense: 03 00 00 00
>sd 1:0:0:0: [sda] No Caching mode page present
>sd 1:0:0:0: [sda] Assuming drive cache: write through
>sd 1:0:0:0: [sda] No Caching mode page present
>sd 1:0:0:0: [sda] Assuming drive cache: write through
> sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
>sd 1:0:0:0: [sda] No Caching mode page present
>sd 1:0:0:0: [sda] Assuming drive cache: write through
>sd 1:0:0:0: [sda] Attached SCSI disk
>EXT3-fs (sda7): mounted filesystem with ordered data mode
>kjournald starting.  Commit interval 5 seconds
>usb 2-1.4.3: new low-speed USB device number 5 using orion-ehci
>VFS: Mounted root (ext3 filesystem) readonly on device 8:7.
>devtmpfs: mounted
>Freeing unused kernel memory: 132K (8049e000 - 804bf000)
>input: Generic USB K/B as /devices/soc.0/f1051000.usb-host/usb2/2-1/2-1.4/2-1.4.3/2-1.4.3:1.0/input/input0
>hid-generic 0003:13BA:0017.0001: input: USB HID v1.10 Keyboard [Generic USB K/B] on usb-f1051000.usb-host-1.4.3/input0
>input: Generic USB K/B as /devices/soc.0/f1051000.usb-host/usb2/2-1/2-1.4/2-1.4.3/2-1.4.3:1.1/input/input1
>hid-generic 0003:13BA:0017.0002: input: USB HID v1.10 Mouse [Generic USB K/B] on usb-f1051000.usb-host-1.4.3/input1
>udevd[583]: starting version 175
>[drm] Initialized drm 1.1.0 20060810
>cfg80211: Calling CRDA to update world regulatory domain
>simple-dt-audio sound.5:  dit-hifi <-> f10b4000.audio-controller mapping ok
>tda998x 0-0070: found TDA19988
>[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>[drm] No driver support for vblank timestamp query.
>usb 2-1.4.2: reset high-speed USB device number 4 using orion-ehci
>usb 2-1.4.2: Loading firmware file isl3887usb
>usbcore: registered new interface driver p54usb
>ieee80211 phy0: p54 detected a LM87 firmware
>p54: rx_mtu reduced from 3240 to 2384
>ieee80211 phy0: FW rev 2.13.25.0 - Softmac protocol 5.9
>ieee80211 phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
>Console: switching to colour frame buffer device 240x67
>dove-drm video.6: fb0:  frame buffer device
>dove-drm video.6: registered panic notifier
>[drm] Initialized dove-drm 1.0.0 20130516 on minor 0
>ieee80211 phy0: hwaddr 00:12:bf:1e:9c:e4, MAC:isl3887 RF:Frisbee
>ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
>usb 2-1.4.2: is registered as 'phy0'
>Unable to handle kernel NULL pointer dereference at virtual address 00000003
>pgd = bd374000
>[00000003] *pgd=3d3af831, *pte=00000000, *ppte=00000000
>Internal error: Oops: 811 [#1] PREEMPT ARM
>Modules linked in: arc4 p54usb p54common crc_ccitt fbcon bitblit mac80211 softcursor font cfg80211 dove_drm tda998x drm_kms_helper drm clk_si5351 snd_soc_simple_dt_card snd_soc_spdif_tx mv_cesa snd_soc_kirkwood
>CPU: 0 PID: 731 Comm: usb-db Not tainted 3.11.0-rc3-00004-g36f571e-dirty #1
>task: bda0dc00 ti: bd2fa000 task.ti: bd2fa000
>PC is at do_mpage_readpage+0x754/0x888
>LR is at bio_add_page+0x44/0x4c
>pc : [<800e89c0>]    lr : [<800e05e4>]    psr: 600e0013
>sp : bd2fbc74  ip : bd2fbcc8  fp : bd2fbc9c
>r10: 00000003  r9 : 00000000  r8 : 00000004
>r7 : 00000001  r6 : 800e8ca4  r5 : bd2fbc70  r4 : 00000003
>r3 : 00001000  r2 : 00000003  r1 : 00000000  r0 : bd2fbc9c
>Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>Control: 10c5387d  Table: 3d374019  DAC: 00000015
>Process usb-db (pid: 731, stack limit = 0xbd2fa240)
>Stack: (0xbd2fbc74 to 0xbd2fc000)
>bc60:                                              00000001 bd2fbd64 00200200
>bc80: 00100100 bd53cd54 bd9f1340 80eed380 bd2fbd34 bd2fbca0 800e8bc8 800e8278
>bca0: bd2fbcc8 bd2fbcbc 8011c554 000000c1 804ebd2c 8011c554 00000002 00000003
>bcc0: 0028de87 00000000 00000000 bd2fbcd8 80eed380 803a2f54 0028df40 00000000
>bce0: 00001000 00000000 bd402ac0 8003b810 bd2fbcf0 bd2fbcf0 bd53ccb4 bd2fbd7c
>bd00: bd53ccbc 00000002 bd2fbd24 8011a00c 00000004 00000004 00000000 0000007a
>bd20: 00000000 00000004 bd2fbd44 bd2fbd38 8011a030 800e8b00 bd2fbdac bd2fbd48
>bd40: 8007dd28 8011a018 bda54780 00000001 bd53cd54 00000004 bd53cd58 bd2fbd64
>bd60: 800c23bc bd2fbd64 bd2fbd64 91827364 bd8d5de8 bd8d5de8 bd2fbd78 bd2fbd78
>bd80: 800add50 bd53cd54 bda54780 bda547c8 00000000 00000020 00000003 bd53cd54
>bda0: bd2fbdec bd2fbdb0 8007e0e0 8007db44 00000003 bd11e470 bd95462c bdbe1540
>bdc0: bd2fbddc bd53cd54 00000000 00000000 bd53cc98 00000001 00000000 bda54780
>bde0: bd2fbe0c bd2fbdf0 8007e3b8 8007dfc4 00000000 00000001 00000000 bd53cd54
>be00: bd2fbeac bd2fbe10 8007471c 8007e378 00000001 bd954b78 bd9545f8 bd9545f8
>be20: 76f24000 76f25000 00000001 00080001 bd2fbeb8 bd2fbec0 ffffffff 00000000
>be40: 00000000 bdbe1540 00000001 bd954608 00000001 00000fff bd2fa000 bda547c8
>be60: 00000000 00000001 76f25000 00000000 00000000 00001000 76f24000 00000000
>be80: 80097780 00000000 00000000 00001000 bd2fbf78 bda54780 bda0dc00 00020000
>bea0: bd2fbf44 bd2fbeb0 800abf60 800741cc 00000000 00000000 76f24000 00001000
>bec0: 00000001 bda54780 00000000 00000000 00000000 bda0dc00 00000000 00000000
>bee0: 00000000 00000000 00000000 00000000 00001000 00000000 00001000 00000000
>bf00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>bf20: bda54780 76f24000 bd2fbf78 76f24000 00000000 00001000 bd2fbf74 bd2fbf48
>bf40: 800ac69c 800abeec 00800007 00000022 00000000 00000000 bda54780 76f24000
>bf60: 00000000 00001000 bd2fbfa4 bd2fbf78 800acd84 800ac608 00000000 00000000
>bf80: 017f7278 76ec7c58 00000000 00000003 8000e604 bd2fa000 00000000 bd2fbfa8
>bfa0: 8000e480 800acd4c 017f7278 76ec7c58 00000003 76f24000 00001000 00000000
>bfc0: 017f7278 76ec7c58 00000000 00000003 7eac3ad0 7eac3ad4 76f29000 00000000
>bfe0: 00000000 7eac3a64 76e389cf 76e6f21c 400e0010 00000003 00000000 00000000
>Backtrace: 
>[<800e826c>] (do_mpage_readpage+0x0/0x888) from [<800e8bc8>] (mpage_readpages+0xd4/0x130)
>[<800e8af4>] (mpage_readpages+0x0/0x130) from [<8011a030>] (ext3_readpages+0x24/0x28)
>[<8011a00c>] (ext3_readpages+0x0/0x28) from [<8007dd28>] (__do_page_cache_readahead+0x1f0/0x2d8)
>[<8007db38>] (__do_page_cache_readahead+0x0/0x2d8) from [<8007e0e0>] (ondemand_readahead+0x128/0x238)
>[<8007dfb8>] (ondemand_readahead+0x0/0x238) from [<8007e3b8>] (page_cache_sync_readahead+0x4c/0x6c)
>[<8007e36c>] (page_cache_sync_readahead+0x0/0x6c) from [<8007471c>] (generic_file_aio_read+0x55c/0x7c0)
> r4:bd53cd54
>[<800741c0>] (generic_file_aio_read+0x0/0x7c0) from [<800abf60>] (do_sync_read+0x80/0xa8)
>[<800abee0>] (do_sync_read+0x0/0xa8) from [<800ac69c>] (vfs_read+0xa0/0x148)
> r9:00001000 r8:00000000 r7:76f24000 r6:bd2fbf78 r5:76f24000
>r4:bda54780
>[<800ac5fc>] (vfs_read+0x0/0x148) from [<800acd84>] (SyS_read+0x44/0x80)
> r9:00001000 r8:00000000 r7:76f24000 r6:bda54780 r5:00000000
>r4:00000000
>[<800acd40>] (SyS_read+0x0/0x80) from [<8000e480>] (ret_fast_syscall+0x0/0x30)
> r9:bd2fa000 r8:8000e604 r7:00000003 r6:00000000 r5:76ec7c58
>r4:017f7278
>Code: e0854184 e51b0084 e14424d8 e51b40a0 (e1c420f0) 
>---[ end trace e23d6b4d1dcd7a83 ]---
>------------[ cut here ]------------
>WARNING: CPU: 0 PID: 731 at /home/jef/kernel/kernel/exit.c:703 do_exit+0x54/0x900()
>Modules linked in: arc4 p54usb p54common crc_ccitt fbcon bitblit mac80211 softcursor font cfg80211 dove_drm tda998x drm_kms_helper drm clk_si5351 snd_soc_simple_dt_card snd_soc_spdif_tx mv_cesa snd_soc_kirkwood
>CPU: 0 PID: 731 Comm: usb-db Tainted: G      D      3.11.0-rc3-00004-g36f571e-dirty #1
>Backtrace: 
>[<800112c4>] (dump_backtrace+0x0/0x110) from [<800114dc>] (show_stack+0x18/0x1c)
> r6:000002bf r5:00000009 r4:00000000 r3:00000000
>[<800114c4>] (show_stack+0x0/0x1c) from [<803a25b0>] (dump_stack+0x24/0x28)
>[<803a258c>] (dump_stack+0x0/0x28) from [<8001ad28>] (warn_slowpath_common+0x74/0x8c)
>[<8001acb4>] (warn_slowpath_common+0x0/0x8c) from [<8001ade4>] (warn_slowpath_null+0x24/0x2c)
> r8:00000811 r7:bd2fa000 r6:80439cc4 r5:0000000b r4:804cb598
>[<8001adc0>] (warn_slowpath_null+0x0/0x2c) from [<8001f248>] (do_exit+0x54/0x900)
>[<8001f1f4>] (do_exit+0x0/0x900) from [<80011664>] (die+0x184/0x238)
> r7:bd2fa000
>[<800114e0>] (die+0x0/0x238) from [<803a07dc>] (__do_kernel_fault.part.10+0x6c/0x7c)
>[<803a0770>] (__do_kernel_fault.part.10+0x0/0x7c) from [<8001420c>] (do_sect_fault+0x0/0x18)
> r7:bdbe1540 r3:bd2fbc28
>[<8001417c>] (do_bad_area+0x0/0x90) from [<80015d10>] (do_alignment+0xd0/0x844)
> r7:00000003 r6:800e89c0 r5:804ec85c r4:bd2fbc28
>[<80015c40>] (do_alignment+0x0/0x844) from [<80008460>] (do_DataAbort+0x40/0xa0)
>[<80008420>] (do_DataAbort+0x0/0xa0) from [<80011fb8>] (__dabt_svc+0x38/0x60)
>Exception stack(0xbd2fbc28 to 0xbd2fbc70)
>bc20:                   bd2fbc9c 00000000 00000003 00001000 00000003 bd2fbc70
>bc40: 800e8ca4 00000001 00000004 00000000 00000003 bd2fbc9c bd2fbcc8 bd2fbc74
>bc60: 800e05e4 800e89c0 600e0013 ffffffff
> r8:00000004 r7:bd2fbc5c r6:ffffffff r5:600e0013 r4:800e89c0
>[<800e826c>] (do_mpage_readpage+0x0/0x888) from [<800e8bc8>] (mpage_readpages+0xd4/0x130)
>[<800e8af4>] (mpage_readpages+0x0/0x130) from [<8011a030>] (ext3_readpages+0x24/0x28)
>[<8011a00c>] (ext3_readpages+0x0/0x28) from [<8007dd28>] (__do_page_cache_readahead+0x1f0/0x2d8)
>[<8007db38>] (__do_page_cache_readahead+0x0/0x2d8) from [<8007e0e0>] (ondemand_readahead+0x128/0x238)
>[<8007dfb8>] (ondemand_readahead+0x0/0x238) from [<8007e3b8>] (page_cache_sync_readahead+0x4c/0x6c)
>[<8007e36c>] (page_cache_sync_readahead+0x0/0x6c) from [<8007471c>] (generic_file_aio_read+0x55c/0x7c0)
> r4:bd53cd54
>[<800741c0>] (generic_file_aio_read+0x0/0x7c0) from [<800abf60>] (do_sync_read+0x80/0xa8)
>[<800abee0>] (do_sync_read+0x0/0xa8) from [<800ac69c>] (vfs_read+0xa0/0x148)
> r9:00001000 r8:00000000 r7:76f24000 r6:bd2fbf78 r5:76f24000
>r4:bda54780
>[<800ac5fc>] (vfs_read+0x0/0x148) from [<800acd84>] (SyS_read+0x44/0x80)
> r9:00001000 r8:00000000 r7:76f24000 r6:bda54780 r5:00000000
>r4:00000000
>[<800acd40>] (SyS_read+0x0/0x80) from [<8000e480>] (ret_fast_syscall+0x0/0x30)
> r9:bd2fa000 r8:8000e604 r7:00000003 r6:00000000 r5:76ec7c58
>r4:017f7278
>---[ end trace e23d6b4d1dcd7a84 ]---
>EXT3-fs (sda7): using internal journal
>IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
>wlan1: authenticate with 00:24:d4:9c:29:68
>wlan1: send auth to 00:24:d4:9c:29:68 (try 1/3)
>wlan1: authenticated
>p54usb 2-1.4.2:1.0 wlan1: disabling HT/VHT due to WEP/TKIP use
>wlan1: associate with 00:24:d4:9c:29:68 (try 1/3)
>wlan1: RX AssocResp from 00:24:d4:9c:29:68 (capab=0x411 status=0 aid=1)
>IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
>wlan1: associated
>
>-- 
>Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
>Jef		|		http://moinejf.free.fr/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
