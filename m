Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3LLMcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:32:54 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:32792 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LLMcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:32:50 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: dmaengine@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com, arnd@arndb.de,
        linux@arm.linux.org.uk, mark.rutland@arm.com,
        andriy.shevchenko@linux.intel.com, lars@metafoo.de,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v14] dmaengine: Add MOXA ART DMA engine driver
Date: Thu, 12 Dec 2013 13:32:14 +0100
Message-Id: <1386851534-11288-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1386774824-1638-1-git-send-email-jonas.jensen@gmail.com>
References: <1386774824-1638-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MOXA ART SoC has a DMA controller capable of offloading expensive
memory operations, such as large copies. This patch adds support for
the controller including four channels. Two of these are used to
handle MMC copy on the UC-7112-LX hardware. The remaining two can be
used in a future audio driver or client application.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for the replies!
    
    This is now rebased on next-20131212 and uses the newly added
    dma_get_any_slave_channel().
    
    There's a problem/crash if DMA_PRIVATE isn't first added to
    capabilities (see attached boot message):
    
    Is DMA_PRIVATE mandatory or should the driver do something?
    
    From what I can tell, private_candidate() can return NULL for already
    allocated channels, or if it's a device without channels, or if
    __dma_device_satisfies_mask() returns false.
    
    The latter two can be eliminated because those errors do not print.
    
    I think dma_get_any_slave_channel() fails, but I don't know why it
    then crashes in SDHCI probe.
    
    Changes since v13:
    1.  don't use implied integer type specifiers
    2.  only count completed segments in moxart_dma_desc_size_in_flight()
    3.  start next descriptor when previous finish
    4.  remove redundant comments
    5.  reorder comment/define blocks
    6.  format text to fit 80 column width
    7.  comment style cleanup
    8.  split "unsigned int es, i" on two rows (moxart_prep_slave_sg())
    9.  print size_t using format "%zu" (moxart_dma_desc_size_in_flight())
    10. add {} to accompanying if (moxart_dma_interrupt())
    11. use NO_IRQ in irq_of_parse_and_map() return value check
    12. use dma_get_any_slave_channel() in moxart_of_xlate()
    13. remove moxart_dma_filter_fn()
    14. add DMA_PRIVATE to capabilities
    
    Applies to next-20131212
    
    Boot log:
    Uncompressing Linux... done, booting the kernel.
    [    0.000000] Booting Linux on physical CPU 0x0
    [    0.000000] Linux version 3.13.0-rc3-next-20131212+ (i@Ildjarn) (gcc version 4.6.3 (crosstool-NG 1.16.0) ) #1330 PREEMPT Thu Dec 12 12:05:54 CET 2013
    [    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
    [    0.000000] CPU: VIVT data cache, VIVT instruction cache
    [    0.000000] Machine model: MOXA UC-7112-LX
    [    0.000000] bootconsole [earlycon0] enabled
    [    0.000000] Memory policy: Data cache writeback
    [    0.000000] On node 0 totalpages: 8192
    [    0.000000] free_area_init_node: node 0, pgdat c0386234, node_mem_map c0948000
    [    0.000000]   Normal zone: 72 pages used for memmap
    [    0.000000]   Normal zone: 0 pages reserved
    [    0.000000]   Normal zone: 8192 pages, LIFO batch:0
    [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
    [    0.000000] pcpu-alloc: [0] 0
    [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8120
    [    0.000000] Kernel command line: debug loglevel=9 console=ttyS0,115200n8 earlyprintk root=/dev/mmcblk0p1 rw rootwait
    [    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
    [    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
    [    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
    [    0.000000] Memory: 22892K/32768K available (2746K kernel code, 106K rwdata, 564K rodata, 156K init, 5884K bss, 9876K reserved)
    [    0.000000] Virtual kernel memory layout:
    [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    [    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    [    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
    [    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
    [    0.000000]       .text : 0xc0008000 - 0xc0343a90   (3311 kB)
    [    0.000000]       .init : 0xc0344000 - 0xc036b358   ( 157 kB)
    [    0.000000]       .data : 0xc036c000 - 0xc0386a80   ( 107 kB)
    [    0.000000]        .bss : 0xc0386a8c - 0xc0945b98   (5885 kB)
    [    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
    [    0.000000] Preemptible hierarchical RCU implementation.
    [    0.000000] NR_IRQS:16 nr_irqs:16 16
    [    0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 21474836480000000ns
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
    [    0.000000] kmemleak: Kernel memory leak detector disabled
    [    0.000000] ODEBUG: 0 of 0 active objects replaced
    [    0.000000] kmemleak: Early log buffer exceeded (673), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
    [    0.140000] Calibrating delay loop... 143.76 BogoMIPS (lpj=718848)
    [    0.200000] pid_max: default: 4096 minimum: 301
    [    0.210000] Mount-cache hash table entries: 512
    [    0.300000] CPU: Testing write buffer coherency: ok
    [    0.320000] Setting up static identity map for 0x27ba60 - 0x27baa8
    [    0.390000] devtmpfs: initialized
    [    0.440000] kworker/u2:0 (13) used greatest stack depth: 6424 bytes left
    [    0.450000] NET: Registered protocol family 16
    [    0.480000] DMA: preallocated 256 KiB pool for atomic coherent allocations
    [    0.580000] kworker/u2:0 (21) used greatest stack depth: 6216 bytes left
    [    0.790000] kworker/u2:0 (46) used greatest stack depth: 6028 bytes left
    [    0.900000] kworker/u2:0 (60) used greatest stack depth: 5848 bytes left
    [    1.150000] bio: create slab <bio-0> at 0
    [    1.180000] moxart-dma-engine 90500080.dma: moxart_probe: chs[0]: ch->ch_num=0 ch->base=c2850080
    [    1.190000] moxart-dma-engine 90500080.dma: moxart_probe: chs[1]: ch->ch_num=1 ch->base=c2850090
    [    1.200000] moxart-dma-engine 90500080.dma: moxart_probe: chs[2]: ch->ch_num=2 ch->base=c28500a0
    [    1.210000] moxart-dma-engine 90500080.dma: moxart_probe: chs[3]: ch->ch_num=3 ch->base=c28500b0
    [    1.260000] moxart-dma-engine 90500080.dma: moxart_probe: IRQ=17
    [    1.550000] DMA-API: preallocated 4096 debug entries
    [    1.560000] DMA-API: debugging enabled by kernel config
    [    1.560000] Switched to clocksource moxart_timer
    [    1.680000] NET: Registered protocol family 2
    [    1.710000] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
    [    1.720000] TCP bind hash table entries: 1024 (order: 3, 36864 bytes)
    [    1.730000] TCP: Hash tables configured (established 1024 bind 1024)
    [    1.750000] TCP: reno registered
    [    1.750000] UDP hash table entries: 128 (order: 1, 10240 bytes)
    [    1.760000] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
    [    1.780000] NET: Registered protocol family 1
    [    2.550000] jffs2: version 2.2. (NAND) Â© 2001-2006 Red Hat, Inc.
    [    2.590000] msgmni has been set to 44
    [    2.600000] io scheduler noop registered
    [    2.610000] io scheduler cfq registered (default)
    [    2.630000] gpiochip_add: registered GPIOs 0 to 31 on device: moxart-gpio
    [    2.660000] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
    [    2.750000] 98200000.uart: ttyS0 at MMIO 0x98200000 (irq = 21, base_baud = 921600) is a 16550A
    [    2.760000] console [ttyS0] enabled
    [    2.760000] console [ttyS0] enabled
    [    2.770000] bootconsole [earlycon0] disabled
    [    2.770000] bootconsole [earlycon0] disabled
    [    2.880000] 80000000.flash: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer ID 0x000089 Chip ID 0x000018
    [    2.890000] Intel/Sharp Extended Query Table at 0x0031
    [    2.900000] Intel/Sharp Extended Query Table at 0x0031
    [    2.910000] Using buffer write method
    [    2.910000] cfi_cmdset_0001: Erase suspend on write enabled
    [    2.920000] erase region 0: offset=0x0,size=0x20000,blocks=128
    [    2.920000] 4 ofpart partitions found on MTD device 80000000.flash
    [    2.930000] Creating 4 MTD partitions on "80000000.flash":
    [    2.940000] 0x000000000000-0x000000040000 : "bootloader"
    [    3.020000] 0x000000040000-0x000000200000 : "linux kernel"
    [    3.090000] 0x000000200000-0x000000a00000 : "root filesystem"
    [    3.160000] 0x000000a00000-0x000001000000 : "user filesystem"
    [    3.910000] libphy: MOXA ART Ethernet MII: probed
    [    4.600000] libphy: MOXA ART Ethernet MII: probed
    [    4.680000] moxart-ethernet 90900000.mac eth0: moxart_mac_probe: IRQ=19 address=00:00:00:00:00:00
    [    4.690000] moxart-ethernet 90900000.mac eth0: generated random MAC address 72:53:d2:5f:0f:e8
    [    4.740000] moxart-ethernet 92000000.mac eth1: moxart_mac_probe: IRQ=20 address=00:00:00:00:00:00
    [    4.750000] moxart-ethernet 92000000.mac eth1: generated random MAC address b6:e4:b8:f4:02:8c
    [    4.770000] of_get_named_gpiod_flags exited with status 0
    [    4.790000] input: gpio_keys_polled.2 as /devices/gpio_keys_polled.2/input/input0
    [    4.820000] evbug: Connected device: input0 (gpio_keys_polled.2 at gpio-keys-polled/input0)
    [    4.840000] of_get_named_gpiod_flags exited with status 0
    [    4.850000] of_get_named_gpiod_flags exited with status 0
    [    4.860000] of_get_named_gpiod_flags exited with status 0
    [    4.890000] moxart-rtc rtc.0: rtc core: registered rtc.0 as rtc0
    [    4.930000] kworker/u2:0 (241) used greatest stack depth: 5840 bytes left
    [    4.970000] dma dma0chan0: moxart_alloc_chan_resources: allocating channel #0
    [    4.980000] Unable to handle kernel paging request at virtual address ffffffed
    [    4.990000] pgd = c0004000
    [    5.000000] [ffffffed] *pgd=01ffd831, *pte=00000000, *ppte=00000000
    [    5.000000] Internal error: Oops: 1 [#1] PREEMPT ARM
    [    5.000000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc3-next-20131212+ #1330
    [    5.000000] task: c1834000 ti: c1838000 task.ti: c1838000
    [    5.000000] PC is at moxart_probe+0x248/0x344
    [    5.000000] LR is at moxart_probe+0x228/0x344
    [    5.000000] pc : [<c01d61e8>]    lr : [<c01d61c8>]    psr: 60000053
    [    5.000000] sp : c1839d68  ip : c18d0124  fp : c1839de4
    [    5.000000] r10: 00000012  r9 : c0379fd0  r8 : c1a04b60
    [    5.000000] r7 : c099165c  r6 : 00000000  r5 : c1870a10  r4 : c1a04800
    [    5.000000] r3 : 00000000  r2 : 00050348  r1 : 98e00040  r0 : ffffffed
    [    5.000000] Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
    [    5.000000] Control: 0000397f  Table: 00004000  DAC: 00000017
    [    5.000000] Process swapper (pid: 1, stack limit = 0xc18381c0)
    [    5.000000] Stack: (0xc1839d68 to 0xc183a000)
    [    5.000000] 9d60:                   c03444b8 c036b2f4 c1839da4 c1839d80 00000002 98e00040
    [    5.000000] 9d80: 00000000 00000004 00000004 00000001 c03444b8 c1a095d8 c1839dcc 98e00000
    [    5.000000] 9da0: 98e0005b c0991698 00000200 00000000 00000000 00000000 c03808d4 c1870a10
    [    5.000000] 9dc0: c03808d4 c1870a10 00000000 c03808d4 c03444b8 c036b2f4 c1839dfc c1839de8
    [    5.000000] 9de0: c019d158 c01d5fb0 c0939698 c03808d4 c1839e24 c1839e00 c019bfb4 c019d148
    [    5.000000] 9e00: 00000000 c1870a10 c03808d4 c1870a44 00000000 c03554a4 c1839e44 c1839e28
    [    5.000000] 9e20: c019c1e0 c019bf40 00000002 c03808d4 c019c144 00000000 c1839e6c c1839e48
    [    5.000000] 9e40: c019a648 c019c154 c18036a8 c18697d0 c19e2558 c03808d4 c1a1c180 c037c738
    [    5.000000] 9e60: c1839e7c c1839e70 c019bd0c c019a5f4 c1839ea4 c1839e80 c019ae94 c019bcfc
    [    5.000000] 9e80: c02faa68 c1839e90 c03808d4 00000006 00000000 c0386aa0 c1839ebc c1839ea8
    [    5.000000] 9ea0: c019c614 c019adc4 c035cf64 00000006 c1839ecc c1839ec0 c019d97c c019c5a4
    [    5.000000] 9ec0: c1839edc c1839ed0 c03554bc c019d93c c1839f54 c1839ee0 c0344b34 c03554b4
    [    5.000000] 9ee0: c1839f0c c1839ef0 c1839f0c c1839ef8 c0344400 c03091f0 c099220b 00000036
    [    5.000000] 9f00: c1839f54 c1839f10 c002db18 c03444c8 c1839f34 00000006 00000006 c0308e90
    [    5.000000] 9f20: 00000000 c02f77f8 c1839f54 c035cf60 00000006 c035cf64 00000006 c035cf44
    [    5.000000] 9f40: c0386aa0 00000036 c1839f94 c1839f58 c0344cf0 c0344a94 00000006 00000006
    [    5.000000] 9f60: c03444b8 00000000 c00364d4 00000000 c0271f6c 00000000 00000000 00000000
    [    5.000000] 9f80: 00000000 00000000 c1839fac c1839f98 c0271f7c c0344c0c 00000000 00000000
    [    5.000000] 9fa0: 00000000 c1839fb0 c0009360 c0271f7c 00000000 00000000 00000000 00000000
    [    5.000000] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    [    5.000000] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
    [    5.000000] [<c01d61e8>] (moxart_probe) from [<c019d158>] (platform_drv_probe+0x20/0x50)
    [    5.000000] [<c019d158>] (platform_drv_probe) from [<c019bfb4>] (driver_probe_device+0x84/0x214)
    [    5.000000] [<c019bfb4>] (driver_probe_device) from [<c019c1e0>] (__driver_attach+0x9c/0xa0)
    [    5.000000] [<c019c1e0>] (__driver_attach) from [<c019a648>] (bus_for_each_dev+0x64/0x94)
    [    5.000000] [<c019a648>] (bus_for_each_dev) from [<c019bd0c>] (driver_attach+0x20/0x28)
    [    5.000000] [<c019bd0c>] (driver_attach) from [<c019ae94>] (bus_add_driver+0xe0/0x1cc)
    [    5.000000] [<c019ae94>] (bus_add_driver) from [<c019c614>] (driver_register+0x80/0xfc)
    [    5.000000] [<c019c614>] (driver_register) from [<c019d97c>] (__platform_driver_register+0x50/0x64)
    [    5.000000] [<c019d97c>] (__platform_driver_register) from [<c03554bc>] (moxart_sdhci_driver_init+0x18/0x20)
    [    5.000000] [<c03554bc>] (moxart_sdhci_driver_init) from [<c0344b34>] (do_one_initcall+0xb0/0x178)
    [    5.000000] [<c0344b34>] (do_one_initcall) from [<c0344cf0>] (kernel_init_freeable+0xf4/0x1b4)
    [    5.000000] [<c0344cf0>] (kernel_init_freeable) from [<c0271f7c>] (kernel_init+0x10/0x118)
    [    5.000000] [<c0271f7c>] (kernel_init) from [<c0009360>] (ret_from_fork+0x14/0x34)
    [    5.000000] Code: e50b306c e3a03000 e50b1068 e50b3064 (e5903000)
    [    5.010000] ---[ end trace a7a79519eb6f6ed3 ]---
    [    5.020000] swapper (1) used greatest stack depth: 4996 bytes left
    [    5.020000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
    [    5.020000]
    [ 1203.680000] random: nonblocking pool is initialized

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  45 ++
 drivers/dma/Kconfig                                |   8 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/moxart-dma.c                           | 699 +++++++++++++++++++++
 4 files changed, 753 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
 create mode 100644 drivers/dma/moxart-dma.c

diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
new file mode 100644
index 0000000..8a9f355
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
@@ -0,0 +1,45 @@
+MOXA ART DMA Controller
+
+See dma.txt first
+
+Required properties:
+
+- compatible :	Must be "moxa,moxart-dma"
+- reg :		Should contain registers location and length
+- interrupts :	Should contain an interrupt-specifier for the sole
+		interrupt generated by the device
+- #dma-cells :	Should be 1, a single cell holding a line request number
+
+Example:
+
+	dma: dma@90500000 {
+		compatible = "moxa,moxart-dma";
+		reg = <0x90500080 0x40>;
+		interrupts = <24 0>;
+		#dma-cells = <1>;
+	};
+
+
+Clients:
+
+DMA clients connected to the MOXA ART DMA controller must use the format
+described in the dma.txt file, using a two-cell specifier for each channel:
+a phandle plus one integer cells.
+The two cells in order are:
+
+1. A phandle pointing to the DMA controller.
+2. Peripheral identifier for the hardware handshaking interface.
+
+Example:
+Use specific request line passing from dma
+For example, MMC request line is 5
+
+	sdhci: sdhci@98e00000 {
+		compatible = "moxa,moxart-sdhci";
+		reg = <0x98e00000 0x5C>;
+		interrupts = <5 0>;
+		clocks = <&clk_apb>;
+		dmas =  <&dma 5>,
+			<&dma 5>;
+		dma-names = "tx", "rx";
+	};
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 132a4fd..ca4fa6b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -334,6 +334,14 @@ config K3_DMA
 	  Support the DMA engine for Hisilicon K3 platform
 	  devices.
 
+config MOXART_DMA
+	tristate "MOXART DMA support"
+	depends on ARCH_MOXART
+	select DMA_ENGINE
+	select DMA_VIRTUAL_CHANNELS
+	help
+	  Enable support for the MOXA ART SoC DMA controller.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 0ce2da9..551bfcd 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
 obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
 obj-$(CONFIG_TI_CPPI41) += cppi41.o
 obj-$(CONFIG_K3_DMA) += k3dma.o
+obj-$(CONFIG_MOXART_DMA) += moxart-dma.o
diff --git a/drivers/dma/moxart-dma.c b/drivers/dma/moxart-dma.c
new file mode 100644
index 0000000..cb3d07a
--- /dev/null
+++ b/drivers/dma/moxart-dma.c
@@ -0,0 +1,699 @@
+/*
+ * MOXA ART SoCs DMA Engine support.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_dma.h>
+#include <linux/bitops.h>
+
+#include <asm/cacheflush.h>
+
+#include "dmaengine.h"
+#include "virt-dma.h"
+
+#define APB_DMA_MAX_CHANNEL			4
+
+#define REG_OFF_ADDRESS_SOURCE			0
+#define REG_OFF_ADDRESS_DEST			4
+#define REG_OFF_CYCLES				8
+#define REG_OFF_CTRL				12
+#define REG_OFF_CHAN_SIZE			16
+
+#define APB_DMA_ENABLE				BIT(0)
+#define APB_DMA_FIN_INT_STS			BIT(1)
+#define APB_DMA_FIN_INT_EN			BIT(2)
+#define APB_DMA_BURST_MODE			BIT(3)
+#define APB_DMA_ERR_INT_STS			BIT(4)
+#define APB_DMA_ERR_INT_EN			BIT(5)
+
+/*
+ * Unset: APB
+ * Set:   AHB
+ */
+#define APB_DMA_SOURCE_SELECT			0x40
+#define APB_DMA_DEST_SELECT			0x80
+
+#define APB_DMA_SOURCE				0x100
+#define APB_DMA_DEST				0x1000
+
+#define APB_DMA_SOURCE_MASK			0x700
+#define APB_DMA_DEST_MASK			0x7000
+
+/*
+ * 000: No increment
+ * 001: +1 (Burst=0), +4  (Burst=1)
+ * 010: +2 (Burst=0), +8  (Burst=1)
+ * 011: +4 (Burst=0), +16 (Burst=1)
+ * 101: -1 (Burst=0), -4  (Burst=1)
+ * 110: -2 (Burst=0), -8  (Burst=1)
+ * 111: -4 (Burst=0), -16 (Burst=1)
+ */
+#define APB_DMA_SOURCE_INC_0			0
+#define APB_DMA_SOURCE_INC_1_4			0x100
+#define APB_DMA_SOURCE_INC_2_8			0x200
+#define APB_DMA_SOURCE_INC_4_16			0x300
+#define APB_DMA_SOURCE_DEC_1_4			0x500
+#define APB_DMA_SOURCE_DEC_2_8			0x600
+#define APB_DMA_SOURCE_DEC_4_16			0x700
+#define APB_DMA_DEST_INC_0			0
+#define APB_DMA_DEST_INC_1_4			0x1000
+#define APB_DMA_DEST_INC_2_8			0x2000
+#define APB_DMA_DEST_INC_4_16			0x3000
+#define APB_DMA_DEST_DEC_1_4			0x5000
+#define APB_DMA_DEST_DEC_2_8			0x6000
+#define APB_DMA_DEST_DEC_4_16			0x7000
+
+/*
+ * Request signal select source/destination address for DMA hardware handshake.
+ *
+ * The request line number is a property of the DMA controller itself,
+ * e.g. MMC must always request channels where dma_slave_config->slave_id is 5.
+ *
+ * 0:    No request / Grant signal
+ * 1-15: Request    / Grant signal
+ */
+#define APB_DMA_SOURCE_REQ_NO			0x1000000
+#define APB_DMA_SOURCE_REQ_NO_MASK		0xf000000
+#define APB_DMA_DEST_REQ_NO			0x10000
+#define APB_DMA_DEST_REQ_NO_MASK		0xf0000
+
+#define APB_DMA_DATA_WIDTH			0x100000
+#define APB_DMA_DATA_WIDTH_MASK			0x300000
+/*
+ * Data width of transfer:
+ *
+ * 00: Word
+ * 01: Half
+ * 10: Byte
+ */
+#define APB_DMA_DATA_WIDTH_4			0
+#define APB_DMA_DATA_WIDTH_2			0x100000
+#define APB_DMA_DATA_WIDTH_1			0x200000
+
+#define APB_DMA_CYCLES_MASK			0x00ffffff
+
+#define MOXART_DMA_DATA_TYPE_S8			0x00
+#define MOXART_DMA_DATA_TYPE_S16		0x01
+#define MOXART_DMA_DATA_TYPE_S32		0x02
+
+struct moxart_sg {
+	dma_addr_t addr;
+	uint32_t len;
+};
+
+struct moxart_desc {
+	enum dma_transfer_direction	dma_dir;
+	dma_addr_t			dev_addr;
+	unsigned int			sglen;
+	unsigned int			dma_cycles;
+	struct virt_dma_desc		vd;
+	uint8_t				es;
+	struct moxart_sg		sg[0];
+};
+
+struct moxart_chan {
+	struct virt_dma_chan		vc;
+
+	void __iomem			*base;
+	struct moxart_desc		*desc;
+
+	struct dma_slave_config		cfg;
+
+	bool				allocated;
+	bool				error;
+	int				ch_num;
+	unsigned int			line_reqno;
+	unsigned int			sgidx;
+};
+
+struct moxart_dmadev {
+	struct dma_device		dma_slave;
+	struct moxart_chan		slave_chans[APB_DMA_MAX_CHANNEL];
+};
+
+struct moxart_filter_data {
+	struct moxart_dmadev		*mdc;
+	struct of_phandle_args		*dma_spec;
+};
+
+static const unsigned int es_bytes[] = {
+	[MOXART_DMA_DATA_TYPE_S8] = 1,
+	[MOXART_DMA_DATA_TYPE_S16] = 2,
+	[MOXART_DMA_DATA_TYPE_S32] = 4,
+};
+
+static struct device *chan2dev(struct dma_chan *chan)
+{
+	return &chan->dev->device;
+}
+
+static inline struct moxart_chan *to_moxart_dma_chan(struct dma_chan *c)
+{
+	return container_of(c, struct moxart_chan, vc.chan);
+}
+
+static inline struct moxart_desc *to_moxart_dma_desc(
+	struct dma_async_tx_descriptor *t)
+{
+	return container_of(t, struct moxart_desc, vd.tx);
+}
+
+static void moxart_dma_desc_free(struct virt_dma_desc *vd)
+{
+	kfree(container_of(vd, struct moxart_desc, vd));
+}
+
+static int moxart_terminate_all(struct dma_chan *chan)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+	unsigned long flags;
+	LIST_HEAD(head);
+	u32 ctrl;
+
+	dev_dbg(chan2dev(chan), "%s: ch=%p\n", __func__, ch);
+
+	spin_lock_irqsave(&ch->vc.lock, flags);
+
+	if (ch->desc)
+		ch->desc = NULL;
+
+	ctrl = readl(ch->base + REG_OFF_CTRL);
+	ctrl &= ~(APB_DMA_ENABLE | APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(ctrl, ch->base + REG_OFF_CTRL);
+
+	vchan_get_all_descriptors(&ch->vc, &head);
+	spin_unlock_irqrestore(&ch->vc.lock, flags);
+	vchan_dma_desc_free_list(&ch->vc, &head);
+
+	return 0;
+}
+
+static int moxart_slave_config(struct dma_chan *chan,
+			       struct dma_slave_config *cfg)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+	u32 ctrl;
+
+	ch->cfg = *cfg;
+
+	ctrl = readl(ch->base + REG_OFF_CTRL);
+	ctrl |= APB_DMA_BURST_MODE;
+	ctrl &= ~(APB_DMA_DEST_MASK | APB_DMA_SOURCE_MASK);
+	ctrl &= ~(APB_DMA_DEST_REQ_NO_MASK | APB_DMA_SOURCE_REQ_NO_MASK);
+
+	switch (ch->cfg.src_addr_width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		ctrl |= APB_DMA_DATA_WIDTH_1;
+		if (ch->cfg.direction != DMA_MEM_TO_DEV)
+			ctrl |= APB_DMA_DEST_INC_1_4;
+		else
+			ctrl |= APB_DMA_SOURCE_INC_1_4;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		ctrl |= APB_DMA_DATA_WIDTH_2;
+		if (ch->cfg.direction != DMA_MEM_TO_DEV)
+			ctrl |= APB_DMA_DEST_INC_2_8;
+		else
+			ctrl |= APB_DMA_SOURCE_INC_2_8;
+		break;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		ctrl &= ~APB_DMA_DATA_WIDTH;
+		if (ch->cfg.direction != DMA_MEM_TO_DEV)
+			ctrl |= APB_DMA_DEST_INC_4_16;
+		else
+			ctrl |= APB_DMA_SOURCE_INC_4_16;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (ch->cfg.direction == DMA_MEM_TO_DEV) {
+		ctrl &= ~APB_DMA_DEST_SELECT;
+		ctrl |= APB_DMA_SOURCE_SELECT;
+		ctrl |= (ch->line_reqno << 16 &
+			 APB_DMA_DEST_REQ_NO_MASK);
+	} else {
+		ctrl |= APB_DMA_DEST_SELECT;
+		ctrl &= ~APB_DMA_SOURCE_SELECT;
+		ctrl |= (ch->line_reqno << 24 &
+			 APB_DMA_SOURCE_REQ_NO_MASK);
+	}
+
+	writel(ctrl, ch->base + REG_OFF_CTRL);
+
+	return 0;
+}
+
+static int moxart_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			  unsigned long arg)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case DMA_PAUSE:
+	case DMA_RESUME:
+		return -EINVAL;
+	case DMA_TERMINATE_ALL:
+		moxart_terminate_all(chan);
+		break;
+	case DMA_SLAVE_CONFIG:
+		ret = moxart_slave_config(chan, (struct dma_slave_config *)arg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	return ret;
+}
+
+static struct dma_async_tx_descriptor *moxart_prep_slave_sg(
+	struct dma_chan *chan, struct scatterlist *sgl,
+	unsigned int sg_len, enum dma_transfer_direction dir,
+	unsigned long tx_flags, void *context)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+	struct moxart_desc *d;
+	enum dma_slave_buswidth dev_width;
+	dma_addr_t dev_addr;
+	struct scatterlist *sgent;
+	unsigned int es;
+	unsigned int i;
+
+	if (!is_slave_direction(dir)) {
+		dev_err(chan2dev(chan), "%s: invalid DMA direction\n",
+			__func__);
+		return NULL;
+	}
+
+	if (dir == DMA_DEV_TO_MEM) {
+		dev_addr = ch->cfg.src_addr;
+		dev_width = ch->cfg.src_addr_width;
+	} else {
+		dev_addr = ch->cfg.dst_addr;
+		dev_width = ch->cfg.dst_addr_width;
+	}
+
+	switch (dev_width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		es = MOXART_DMA_DATA_TYPE_S8;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		es = MOXART_DMA_DATA_TYPE_S16;
+		break;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		es = MOXART_DMA_DATA_TYPE_S32;
+		break;
+	default:
+		dev_err(chan2dev(chan), "%s: unsupported data width (%u)\n",
+			__func__, dev_width);
+		return NULL;
+	}
+
+	d = kzalloc(sizeof(*d) + sg_len * sizeof(d->sg[0]), GFP_ATOMIC);
+	if (!d)
+		return NULL;
+
+	d->dma_dir = dir;
+	d->dev_addr = dev_addr;
+	d->es = es;
+
+	for_each_sg(sgl, sgent, sg_len, i) {
+		d->sg[i].addr = sg_dma_address(sgent);
+		d->sg[i].len = sg_dma_len(sgent);
+	}
+
+	d->sglen = sg_len;
+
+	ch->error = 0;
+
+	return vchan_tx_prep(&ch->vc, &d->vd, tx_flags);
+}
+
+static struct dma_chan *moxart_of_xlate(struct of_phandle_args *dma_spec,
+					struct of_dma *ofdma)
+{
+	struct moxart_dmadev *mdc = ofdma->of_dma_data;
+	struct dma_chan *chan;
+	struct moxart_chan *ch;
+
+	chan = dma_get_any_slave_channel(&mdc->dma_slave);
+	if (!chan)
+		return NULL;
+
+	ch = to_moxart_dma_chan(chan);
+	ch->line_reqno = dma_spec->args[0];
+
+	return chan;
+}
+
+static int moxart_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+
+	dev_dbg(chan2dev(chan), "%s: allocating channel #%u\n",
+		__func__, ch->ch_num);
+	ch->allocated = 1;
+
+	return 0;
+}
+
+static void moxart_free_chan_resources(struct dma_chan *chan)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+
+	vchan_free_chan_resources(&ch->vc);
+
+	dev_dbg(chan2dev(chan), "%s: freeing channel #%u\n",
+		__func__, ch->ch_num);
+	ch->allocated = 0;
+}
+
+static void moxart_dma_set_params(struct moxart_chan *ch, dma_addr_t src_addr,
+				  dma_addr_t dst_addr)
+{
+	writel(src_addr, ch->base + REG_OFF_ADDRESS_SOURCE);
+	writel(dst_addr, ch->base + REG_OFF_ADDRESS_DEST);
+}
+
+static void moxart_set_transfer_params(struct moxart_chan *ch, unsigned int len)
+{
+	struct moxart_desc *d = ch->desc;
+	unsigned int sglen_div = es_bytes[d->es];
+
+	d->dma_cycles = len >> sglen_div;
+
+	/*
+	 * There are 4 cycles on 64 bytes copied, i.e. one cycle copies 16
+	 * bytes ( when width is APB_DMAB_DATA_WIDTH_4 ).
+	 */
+	writel(d->dma_cycles, ch->base + REG_OFF_CYCLES);
+
+	dev_dbg(chan2dev(&ch->vc.chan), "%s: set %u DMA cycles (len=%u)\n",
+		__func__, d->dma_cycles, len);
+}
+
+static void moxart_start_dma(struct moxart_chan *ch)
+{
+	u32 ctrl;
+
+	ctrl = readl(ch->base + REG_OFF_CTRL);
+	ctrl |= (APB_DMA_ENABLE | APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(ctrl, ch->base + REG_OFF_CTRL);
+}
+
+static void moxart_dma_start_sg(struct moxart_chan *ch, unsigned int idx)
+{
+	struct moxart_desc *d = ch->desc;
+	struct moxart_sg *sg = ch->desc->sg + idx;
+
+	if (ch->desc->dma_dir == DMA_MEM_TO_DEV)
+		moxart_dma_set_params(ch, sg->addr, d->dev_addr);
+	else if (ch->desc->dma_dir == DMA_DEV_TO_MEM)
+		moxart_dma_set_params(ch, d->dev_addr, sg->addr);
+
+	moxart_set_transfer_params(ch, sg->len);
+
+	moxart_start_dma(ch);
+}
+
+static void moxart_dma_start_desc(struct dma_chan *chan)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+	struct virt_dma_desc *vd;
+
+	vd = vchan_next_desc(&ch->vc);
+
+	if (!vd) {
+		ch->desc = NULL;
+		return;
+	}
+
+	list_del(&vd->node);
+
+	ch->desc = to_moxart_dma_desc(&vd->tx);
+	ch->sgidx = 0;
+
+	moxart_dma_start_sg(ch, 0);
+}
+
+static void moxart_issue_pending(struct dma_chan *chan)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ch->vc.lock, flags);
+	if (vchan_issue_pending(&ch->vc) && !ch->desc)
+		moxart_dma_start_desc(chan);
+	spin_unlock_irqrestore(&ch->vc.lock, flags);
+}
+
+static size_t moxart_dma_desc_size(struct moxart_desc *d)
+{
+	unsigned int i;
+	size_t size;
+
+	for (size = i = 0; i < d->sglen; i++)
+		size += d->sg[i].len;
+
+	return size;
+}
+
+static size_t moxart_dma_desc_size_in_flight(struct moxart_chan *ch)
+{
+	size_t size;
+	unsigned int completed_cycles, cycles, i;
+
+	for (size = i = 0; i <= ch->sgidx; i++)
+		size += ch->desc->sg[i].len;
+	cycles = readl(ch->base + REG_OFF_CYCLES);
+	completed_cycles = (ch->desc->dma_cycles - cycles);
+	size -= completed_cycles << es_bytes[ch->desc->es];
+
+	dev_dbg(chan2dev(&ch->vc.chan), "%s: size=%zu\n", __func__, size);
+
+	return size;
+}
+
+static enum dma_status moxart_tx_status(struct dma_chan *chan,
+					dma_cookie_t cookie,
+					struct dma_tx_state *txstate)
+{
+	struct moxart_chan *ch = to_moxart_dma_chan(chan);
+	struct virt_dma_desc *vd;
+	struct moxart_desc *d;
+	enum dma_status ret;
+	unsigned long flags;
+
+	/*
+	 * dma_cookie_status() assigns initial residue value.
+	 */
+	ret = dma_cookie_status(chan, cookie, txstate);
+
+	spin_lock_irqsave(&ch->vc.lock, flags);
+	vd = vchan_find_desc(&ch->vc, cookie);
+	if (vd) {
+		d = to_moxart_dma_desc(&vd->tx);
+		txstate->residue = moxart_dma_desc_size(d);
+	} else if (ch->desc && ch->desc->vd.tx.cookie == cookie) {
+		txstate->residue = moxart_dma_desc_size_in_flight(ch);
+	}
+	spin_unlock_irqrestore(&ch->vc.lock, flags);
+
+	if (ch->error)
+		return DMA_ERROR;
+
+	return ret;
+}
+
+static void moxart_dma_init(struct dma_device *dma, struct device *dev)
+{
+	dma->device_prep_slave_sg		= moxart_prep_slave_sg;
+	dma->device_alloc_chan_resources	= moxart_alloc_chan_resources;
+	dma->device_free_chan_resources		= moxart_free_chan_resources;
+	dma->device_issue_pending		= moxart_issue_pending;
+	dma->device_tx_status			= moxart_tx_status;
+	dma->device_control			= moxart_control;
+	dma->dev				= dev;
+
+	INIT_LIST_HEAD(&dma->channels);
+}
+
+static irqreturn_t moxart_dma_interrupt(int irq, void *devid)
+{
+	struct moxart_dmadev *mc = devid;
+	struct moxart_chan *ch = &mc->slave_chans[0];
+	unsigned int i;
+	unsigned long flags;
+	u32 ctrl;
+
+	dev_dbg(chan2dev(&ch->vc.chan), "%s\n", __func__);
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, ch++) {
+		if (!ch->allocated)
+			continue;
+
+		ctrl = readl(ch->base + REG_OFF_CTRL);
+
+		dev_dbg(chan2dev(&ch->vc.chan), "%s: ch=%p ch->base=%p ctrl=%x\n",
+			__func__, ch, ch->base, ctrl);
+
+		if (ctrl & APB_DMA_FIN_INT_STS) {
+			ctrl &= ~APB_DMA_FIN_INT_STS;
+			if (ch->desc) {
+				spin_lock_irqsave(&ch->vc.lock, flags);
+				if (++ch->sgidx < ch->desc->sglen) {
+					moxart_dma_start_sg(ch, ch->sgidx);
+				} else {
+					vchan_cookie_complete(&ch->desc->vd);
+					moxart_dma_start_desc(&ch->vc.chan);
+				}
+				spin_unlock_irqrestore(&ch->vc.lock, flags);
+			}
+		}
+
+		if (ctrl & APB_DMA_ERR_INT_STS) {
+			ctrl &= ~APB_DMA_ERR_INT_STS;
+			ch->error = 1;
+		}
+
+		writel(ctrl, ch->base + REG_OFF_CTRL);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int moxart_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct resource *res;
+	static void __iomem *dma_base_addr;
+	int ret, i;
+	unsigned int irq;
+	struct moxart_chan *ch;
+	struct moxart_dmadev *mdc;
+
+	mdc = devm_kzalloc(dev, sizeof(*mdc), GFP_KERNEL);
+	if (!mdc) {
+		dev_err(dev, "can't allocate DMA container\n");
+		return -ENOMEM;
+	}
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq == NO_IRQ) {
+		dev_err(dev, "no IRQ resource\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dma_base_addr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dma_base_addr))
+		return PTR_ERR(dma_base_addr);
+
+	dma_cap_zero(mdc->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE, mdc->dma_slave.cap_mask);
+	dma_cap_set(DMA_PRIVATE, mdc->dma_slave.cap_mask);
+
+	moxart_dma_init(&mdc->dma_slave, dev);
+
+	ch = &mdc->slave_chans[0];
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, ch++) {
+		ch->ch_num = i;
+		ch->base = dma_base_addr + i * REG_OFF_CHAN_SIZE;
+		ch->allocated = 0;
+
+		ch->vc.desc_free = moxart_dma_desc_free;
+		vchan_init(&ch->vc, &mdc->dma_slave);
+
+		dev_dbg(dev, "%s: chs[%d]: ch->ch_num=%u ch->base=%p\n",
+			__func__, i, ch->ch_num, ch->base);
+	}
+
+	platform_set_drvdata(pdev, mdc);
+
+	ret = devm_request_irq(dev, irq, moxart_dma_interrupt, 0,
+			       "moxart-dma-engine", mdc);
+	if (ret) {
+		dev_err(dev, "devm_request_irq failed\n");
+		return ret;
+	}
+
+	ret = dma_async_device_register(&mdc->dma_slave);
+	if (ret) {
+		dev_err(dev, "dma_async_device_register failed\n");
+		return ret;
+	}
+
+	ret = of_dma_controller_register(node, moxart_of_xlate, mdc);
+	if (ret) {
+		dev_err(dev, "of_dma_controller_register failed\n");
+		dma_async_device_unregister(&mdc->dma_slave);
+		return ret;
+	}
+
+	dev_dbg(dev, "%s: IRQ=%u\n", __func__, irq);
+
+	return 0;
+}
+
+static int moxart_remove(struct platform_device *pdev)
+{
+	struct moxart_dmadev *m = platform_get_drvdata(pdev);
+
+	dma_async_device_unregister(&m->dma_slave);
+
+	if (pdev->dev.of_node)
+		of_dma_controller_free(pdev->dev.of_node);
+
+	return 0;
+}
+
+static const struct of_device_id moxart_dma_match[] = {
+	{ .compatible = "moxa,moxart-dma" },
+	{ }
+};
+
+static struct platform_driver moxart_driver = {
+	.probe	= moxart_probe,
+	.remove	= moxart_remove,
+	.driver = {
+		.name		= "moxart-dma-engine",
+		.owner		= THIS_MODULE,
+		.of_match_table	= moxart_dma_match,
+	},
+};
+
+static int moxart_init(void)
+{
+	return platform_driver_register(&moxart_driver);
+}
+subsys_initcall(moxart_init);
+
+static void __exit moxart_exit(void)
+{
+	platform_driver_unregister(&moxart_driver);
+}
+module_exit(moxart_exit);
+
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
+MODULE_DESCRIPTION("MOXART DMA engine driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.2.1

