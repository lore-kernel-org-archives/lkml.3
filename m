Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3CNLPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:15:38 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:49349 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756693Ab3CNLPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:15:34 -0400
Message-ID: <5141B154.6050504@mimc.co.uk>
Date: Thu, 14 Mar 2013 11:15:32 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
References: <5134CEF9.5070502@mimc.co.uk>   <1363087506.3348.62.camel@sauron.fi.intel.com>   <51405F3A.3090901@mimc.co.uk>  <1363252425.11441.94.camel@sauron.fi.intel.com>  <51419E3A.8030007@mimc.co.uk> <1363257009.11441.97.camel@sauron.fi.intel.com>
In-Reply-To: <1363257009.11441.97.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 10:30, Artem Bityutskiy wrote:
> On Thu, 2013-03-14 at 09:54 +0000, Mark Jackson wrote:
>> On 14/03/13 09:13, Artem Bityutskiy wrote:
>>> On Wed, 2013-03-13 at 11:12 +0000, Mark Jackson wrote:
>>>> Sorry ... this just locks up the unit.
>>>
>>> OK, I've reproduced the issue with 3.9-rc2 in nandsim, see the details
>>> below. The patch I proposed did not get the error path correctly, but it
>>> does fix the issue.
>>>
>>> I think what you treat as "lockup" is the fixup process. UBIFS basically
>>> reads the entire UBI volume and writes it back. And it uses the atomic
>>> change UBI service, which means it also calculates CRC of everything it
>>> writes. And this all just takes a lot of time. This has to be done only
>>> once on the first mount.
>>
>> Okay ... I've retried, but how long is "a lot of time" ?
>>
>> I've waited 15 minutes and still nothing.
>>
>> And I can see that there's no activity on the NAND chip select !?!
>>
>> I'll put some debug info into the fixup routines to see if I can trace what's going on.
> 
> Just to make sure - try this last patch I sent. I did test it with
> nandsim at least, and I am sure it works. I did not test at all the
> first one.
> 
> And yes, debug messages would be useful, just do not forget to add the
> 'ignore_loglevel' kernel boot option, otherwise you won't see the
> messages on your console, since they are of KERN_DEBUG level.
> 
> You may have other issues which cause lockup, e.g., in driver level. It
> makes sense to validate your flash with MTD test modules.

My first initial findings ...

I added some simple printk(KERN_INFO) lines to fixup_free_space(), and when
I remount, it gets as far as:-

printk(KERN_INFO "ffs 7\n");
	/* Fixup LEBs in the main area */
	for (lnum = c->main_first; lnum < c->leb_cnt; lnum++) {
		lprops = ubifs_lpt_lookup(c, lnum);
		if (IS_ERR(lprops)) {
			err = PTR_ERR(lprops);
			goto out;
		}

		if (lprops->free > 0) {
			err = fixup_leb(c, lnum, c->leb_size - lprops->free);
			if (err)
				goto out;
		}
	}

out:
printk(KERN_INFO "ffs x\n");
	ubifs_release_lprops(c);
	return err;
}

... before we get an oops with crc32_le().  See the full log below.

I'll keep digging ...

Regards
Mark J.
---
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.8.0-next-20130225-00002-g678576f-dirty (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot 2012.11) ) #40 Thu Mar 14 10:58:28 GMT 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x BeagleBone
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 65280
[    0.000000] free_area_init_node: node 0, pgdat c059c7b0, node_mem_map c0ac6000
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65280 pages, LIFO batch:15
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: console=ttyO0,115200n8 noinitrd ip=off mem=256M rootwait=1 ubi.mtd=6,2048 rootfstype=ubifs root=ubi0:rootfs ignore_loglevel
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 247768k/247768k available, 14376k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]       .text : 0xc0008000 - 0xc05194ac   (5190 kB)
[    0.000000]       .init : 0xc051a000 - 0xc054bfbc   ( 200 kB)
[    0.000000]       .data : 0xc054c000 - 0xc059d360   ( 325 kB)
[    0.000000]        .bss : 0xc059d360 - 0xc0ac21a0   (5268 kB)
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 26000000 Hz
[    0.000000] sched_clock: 32 bits at 26MHz, resolution 38ns, wraps every 165191ms
[    0.000000] OMAP clocksource: GPTIMER2 at 26000000 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000866] Calibrating delay loop... 476.77 BogoMIPS (lpj=2383872)
[    0.119747] pid_max: default: 32768 minimum: 301
[    0.120031] Security Framework initialized
[    0.120132] Mount-cache hash table entries: 512
[    0.130113] CPU: Testing write buffer coherency: ok
[    0.131391] Setting up static identity map for 0xc0402cf8 - 0xc0402d50
[    0.134796] devtmpfs: initialized
[    0.196435] pinctrl core: initialized pinctrl subsystem
[    0.201669] regulator-dummy: no parameters
[    0.203862] NET: Registered protocol family 16
[    0.204608] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.222839] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.223232] OMAP GPIO hardware version 0.1
[    0.225994] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.228624] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
[    0.231214] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
[    0.245983] omap-gpmc 50000000.gpmc: could not find pctldev for node /pinmux@44e10800/gpmc_pins, deferring probe
[    0.246035] platform 50000000.gpmc: Driver omap-gpmc requests probe deferral
[    0.246674] No ATAGs?
[    0.246691] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.284604] bio: create slab <bio-0> at 0
[    0.350695] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.357130] usbcore: registered new interface driver usbfs
[    0.357526] usbcore: registered new interface driver hub
[    0.358167] usbcore: registered new device driver usb
[    0.359106] omap_i2c 44e0b000.i2c: could not find pctldev for node /pinmux@44e10800/i2c1_pins, deferring probe
[    0.359152] platform 44e0b000.i2c: Driver omap_i2c requests probe deferral
[    0.366391] cfg80211: Calling CRDA to update world regulatory domain
[    0.368068] Switching to clocksource gp_timer
[    0.416727] NET: Registered protocol family 2
[    0.418471] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.418683] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.419630] TCP: Hash tables configured (established 2048 bind 2048)
[    0.419844] TCP: reno registered
[    0.419874] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.420133] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.420922] NET: Registered protocol family 1
[    0.422131] RPC: Registered named UNIX socket transport module.
[    0.422155] RPC: Registered udp transport module.
[    0.422165] RPC: Registered tcp transport module.
[    0.422175] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.423061] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.423514] CPU PMU: probing PMU on CPU 0
[    0.423544] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.435819] msgmni has been set to 483
[    0.440155] io scheduler noop registered
[    0.440181] io scheduler deadline registered
[    0.440250] io scheduler cfq registered (default)
[    0.441286] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.442944] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.450243] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    1.062979] console [ttyO0] enabled
[    1.069318] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1
[    1.078922] 48024000.serial: ttyO2 at MMIO 0x48024000 (irq = 90) is a OMAP UART2
[    1.088374] 481a6000.serial: ttyO3 at MMIO 0x481a6000 (irq = 60) is a OMAP UART3
[    1.097747] 481a8000.serial: ttyO4 at MMIO 0x481a8000 (irq = 61) is a OMAP UART4
[    1.107140] 481aa000.serial: ttyO5 at MMIO 0x481aa000 (irq = 62) is a OMAP UART5
[    1.141639] brd: module loaded
[    1.160604] loop: module loaded
[    1.167555] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.179155] usbcore: registered new interface driver rt2800usb
[    1.185699] usbcore: registered new interface driver asix
[    1.191823] usbcore: registered new interface driver cdc_ether
[    1.198389] usbcore: registered new interface driver smsc95xx
[    1.204825] usbcore: registered new interface driver net1080
[    1.211201] usbcore: registered new interface driver cdc_subset
[    1.217812] usbcore: registered new interface driver zaurus
[    1.224164] usbcore: registered new interface driver cdc_ncm
[    1.232048] usbcore: registered new interface driver cdc_wdm
[    1.238521] usbcore: registered new interface driver usbtest
[    1.244879] i2c /dev entries driver
[    1.252025] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.260616] omap_cpufreq_init: unable to get MPU regulator
[    1.269707] usbcore: registered new interface driver usbhid
[    1.275600] usbhid: USB HID core driver
[    1.280825] oprofile: using arm/armv7
[    1.285411] TCP: cubic registered
[    1.288994] Initializing XFRM netlink socket
[    1.293630] NET: Registered protocol family 17
[    1.298456] NET: Registered protocol family 15
[    1.303575] Key type dns_resolver registered
[    1.308250] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    1.316401] ThumbEE CPU extension supported.
[    1.324959] omap-gpmc 50000000.gpmc: GPMC revision 6.0
[    1.332583] enabling NAND BCH ecc with 8-bit correction
[    1.338520] ONFI param page 0 valid
[    1.342206] ONFI flash detected
[    1.345527] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xda (Micron MT29F2G08ABAEAWP), 256MiB, page size: 2048, OOB size: 64
[    1.357810] 8 ofpart partitions found on MTD device omap2-nand.0
[    1.364195] Creating 8 MTD partitions on "omap2-nand.0":
[    1.369857] 0x000000000000-0x000000020000 : "spl1"
[    1.377262] 0x000000020000-0x000000040000 : "spl2"
[    1.383363] 0x000000040000-0x000000060000 : "spl3"
[    1.389263] 0x000000060000-0x000000080000 : "spl4"
[    1.395107] 0x000000080000-0x0000001e0000 : "boot"
[    1.402034] 0x0000001e0000-0x000000200000 : "env"
[    1.407758] 0x000000200000-0x000004200000 : "rootfs"
[    1.468624] 0x000004200000-0x000010000000 : "data"
[    1.641028] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
[    1.647706] mcp230xx 0-0020: invalid or missing platform data
[    1.653901] mcp230xx: probe of 0-0020 failed with error -22
[    1.664675] DCDC1: at 1800 mV
[    1.670057] vdd_mpu: 925 <--> 1325 mV at 3300 mV
[    1.677053] vdd_core: 925 <--> 1150 mV at 1100 mV
[    1.684039] LDO1: at 1800 mV
[    1.689131] LDO2: at 3300 mV
[    1.694112] LDO3: at 1800 mV
[    1.699383] LDO4: at 2800 mV
[    1.704094] tps65217 0-0024: TPS65217 ID 0x7 version 1.1
[    1.710665] at24 0-0053: 256 byte 24c02 EEPROM, writable, 8 bytes/write
[    1.721368] rtc-ds1307 0-0068: rtc core: registered ds1307 as rtc0
[    1.727934] rtc-ds1307 0-0068: 56 bytes nvram
[    1.734589] UBI: attaching mtd6 to ubi0
[    1.944782] UBI: scanning is finished
[    1.958753] UBI warning: print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling, reserved 4, need 40
[    1.982129] UBI: volume 0 ("rootfs") re-sized from 504 to 504 LEBs
[    1.991995] UBI: attached mtd6 (name "rootfs", size 64 MiB) to ubi0
[    1.998710] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[    2.005875] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
[    2.012935] UBI: VID header offset: 2048 (aligned 2048), data offset: 4096
[    2.020220] UBI: good PEBs: 512, bad PEBs: 0, corrupted PEBs: 0
[    2.026469] UBI: user volume: 1, internal volumes: 1, max. volumes count: 128
[    2.034028] UBI: max/mean erase counter: 1/0, WL threshold: 4096, image sequence number: 104567561
[    2.043506] UBI: available PEBs: 0, total reserved PEBs: 512, PEBs reserved for bad PEB handling: 4
[    2.054154] UBI: background thread "ubi_bgt0d" started, PID 591
[    2.148196] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.154650] davinci_mdio 4a101000.mdio: detected phy mask fffffffc
[    2.179932] libphy: 4a101000.mdio: probed
[    2.184195] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
[    2.193904] davinci_mdio 4a101000.mdio: phy[1]: device 4a101000.mdio:01, driver SMSC LAN8710/LAN8720
[    2.203969] Random MACID = 36:f9:8d:06:57:7f
[    2.240893] rtc-ds1307 0-0068: setting system clock to 2013-03-14 11:07:34 UTC (1363259254)
[    2.419408] UBIFS: mounted UBI device 0, volume 0, name "rootfs", R/O mode
[    2.426699] UBIFS: LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[    2.436415] UBIFS: FS size: 62599168 bytes (59 MiB, 493 LEBs), journal size 8253440 bytes (7 MiB, 65 LEBs)
[    2.446637] UBIFS: reserved for root: 0 bytes (0 KiB)
[    2.452006] UBIFS: media format: w4/r0 (latest is w4/r0), UUID 7A53349A-BCDB-4026-B45F-CCE435589ADA, small LPT model
[    2.520859] VFS: Mounted root (ubifs filesystem) readonly on device 0:12.
[    2.530533] devtmpfs: mounted
[    2.534117] Freeing init memory: 196K
Starting logging: OK
Initializing random number generator... read-only file system detected...done
Starting network...
[    3.060289] net eth0: initializing cpsw version 1.12 (0)
[    3.068476] net eth0: phy found : id is : 0x7c0f1
[    3.074025] net eth0: phy found : id is : 0x7c0f1
udhcpc (v1.20.2) started
Sending discover...
Sending discover...
[    6.149073] libphy: 4a101000.mdio:00 - Link is Up - 100/Full
Sending discover...
Sending select for 10.0.0.127...
Lease of 10.0.0.127 obtained, lease time 259200
deleting routers
route: SIOCDELRT: No such process
adding dns 4.2.2.5
adding dns 208.67.220.220
ip: SIOCGIFFLAGS: No such device
Starting dropbear sshd: mkdir: can't create directory '/etc/dropbear': Read-only file system
generating rsa key... generating dsa key... OK
Starting lighttpd: OK

Welcome to Buildroot
nanobone login: root
Password:
# mount
rootfs on / type rootfs (rw)
ubi0:rootfs on / type ubifs (ro,relatime)
devtmpfs on /dev type devtmpfs (rw,relatime,size=123884k,nr_inodes=30971,mode=755)
proc on /proc type proc (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw,relatime,mode=777)
tmpfs on /tmp type tmpfs (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
# mount -o remount,rw /
[   28.482971] UBIFS: start fixing up free space
[   28.487601] uffs 1
[   28.489849] ffs 1
[   28.491901] ffs 2
[   28.498617] ffs 3
[   28.500932] ffs 4
[   28.504148] ffs 5
[   28.507352] ffs 6
[   28.509468] ffs 7
[   28.527936] Unable to handle kernel paging request at virtual address d08ea004
[   28.535639] pgd = cf3b8000
[   28.538525] [d08ea004] *pgd=8f045811, *pte=00000000, *ppte=00000000
[   28.545173] Internal error: Oops: 7 [#1] ARM
[   28.549685] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #40)
[   28.557595] PC is at crc32_le+0x50/0x168
[   28.561735] LR is at ubi_eba_atomic_leb_change+0x1b4/0x410
[   28.567523] pc : [<c01e7244>]    lr : [<c026dd9c>]    psr: 20000013
[   28.567523] sp : cf385de0  ip : 180a985a  fp : c054f840
[   28.579632] r10: c054f040  r9 : c054fc40  r8 : 158a1232
[   28.585141] r7 : 4d506705  r6 : 9324fd72  r5 : 4dc8a10b  r4 : 4c162691
[   28.592025] r3 : c054e040  r2 : c054f440  r1 : d08ea000  r0 : 4c8ee09f
[   28.598912] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   28.606439] Control: 10c5387d  Table: 8f3b8019  DAC: 00000015
[   28.612501] Process mount (pid: 659, stack limit = 0xcf384238)
[   28.618652] Stack: (0xcf385de0 to 0xcf386000)
[   28.623254] 5de0: cf2f8554 00000000 d08e6e8c 180a9e88 5a257c4f 58399ee9 c8d98a08 bb0ee864
[   28.631886] 5e00: eae10678 c054fc40 c054f040 c054f840 cf2f8000 00000000 d08caffc 00003c00
[   28.640517] 5e20: cf2f8000 cf357c00 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554
[   28.649148] 5e40: d08cb000 0001e000 00000000 d08cb000 00008000 00000000 00000000 0001e000
[   28.657779] 5e60: 00000000 0000000c d08cb000 00000080 0000000c 0000000c 00000000 00000020
[   28.666409] 5e80: 00008000 c026c41c 0001e000 cf330000 cf330000 d08cb000 0001e000 c0179b14
[   28.675042] 5ea0: 0000000d c0177a68 0001e000 cf330000 00000000 cf330b20 0000000d c0179698
[   28.683672] 5ec0: cf330000 00000000 cf330a9c 00000000 cf385f48 c0175170 00000001 60000013
[   28.692303] 5ee0: cf32c800 00000000 00000000 00000000 cf385f48 00000000 00000020 c00c9e24
[   28.700934] 5f00: 00100100 00200200 cf3a6c80 00008000 cf384000 00208020 00000000 cf01a200
[   28.709564] 5f20: cf32c800 c00e3d6c 00000000 0000000c cf32c840 00000000 c0013968 cf31fb80
[   28.718195] 5f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf3ac000 000a18b4 00000000
[   28.726827] 5f60: 00208020 c0013968 cf384000 00000000 00000003 c00e3e40 00000000 c0071e24
[   28.735459] 5f80: 00000000 00000000 cf31fb80 cf31fbc0 a0000010 00000000 bed87b68 b6ff148c
[   28.744091] 5fa0: 00000015 c00137c0 00000000 bed87b68 000a18b4 000a18c0 000a18c2 00208020
[   28.752720] 5fc0: 00000000 bed87b68 b6ff148c 00000015 00000000 00000000 00000000 00000003
[   28.761350] 5fe0: b6fa3f48 bed87a64 00042994 b6fa3f58 a0000010 000a18b4 00000000 00000000
[   28.769989] [<c01e7244>] (crc32_le+0x50/0x168) from [<cf2f8000>] (0xcf2f8000)
[   28.777522] Code: e58d8008 0a000026 e1a0c005 e58d2004 (e5916004)
[   28.784029] ---[ end trace f50f53afffe647f1 ]---
Segmentation fault

