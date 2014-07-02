Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaGBK7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:59:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28577 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaGBK7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:59:36 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ed-53b3e6144e48
Message-id: <53B3E5F8.80501@samsung.com>
Date: Wed, 02 Jul 2014 12:59:04 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        =?UTF-8?B?VG9tYXN6IFN0YW5pc8WCYXdza2k=?= <t.stanislaws@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: ABBA deadlock in Common Clock Framework
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7oizzYHG5z8am1xa905VoupD5+w
	Wdz/epTRYtPja6wWl3fNYbOYcX4fk8XTCRfZLOa1v2S1WHliFrMDp8emVZ1sHneu7WHz2Lyk
	3qNvyypGj5OnnrB4fN4kF8AWxWWTkpqTWZZapG+XwJWx+Nxe5oI37xkr7t78w9rA+PoQYxcj
	B4eEgInE9d66LkZOIFNM4sK99WxdjFwcQgJLGSVWPumEcj4zSvzYfJoRpIpXQEOiuekiC0gz
	i4CqxMfFISBhNgE1ic8Nj9hAbH4BLYk1TdfBSkQFIiQeXxCC6BSU+DH5HguILSLgKLHj4Few
	8cwCc5kl3nRvYgZJCAsYSBz4dA1sDrOAusSkeYuYIWx5ic1r3jJPYOSfhWTWLCRls5CULWBk
	XsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREupfdjAuPmZ1iFGAg1GJh7dxxYZgIdbEsuLK
	3EOMEhzMSiK8/Tc2BwvxpiRWVqUW5ccXleakFh9iZOLglGpgDBbcEXWoSnLpc+GfBkaCPx2m
	eV7YKssnqhJkO7X2peJtu2aNalcjV4k9cWZ1J1M/rDIrsM45etf5l+g9ZcMbXj931jw9J94U
	cf9ls0rgd8878/8KhSafkDzg/NPveMv6yY53wngTTWf+q92kUhlS57l0QaFM9hJ+PbabK9/e
	1gqaXSjl/++uEktxRqKhFnNRcSIADu0zHFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

While testing linux-next (next-20140625) on Exynos4412-based TRATS2
board, from time to time I hit a deadlock between clk_disable_unused()
of Common Clock Framework and parallel clk_prepare() from s3c24xx-i2c
driver.

I believe the following is happening (in processes 1 and 2):
 1: clk_disable_unused()
 1: clk_prepare_lock()
 1: mutex_lock(clk prepare mutex) // lock A
 1: max77686_clk_is_prepared()
 1: regmap_read()
 2: regulator_set_voltage()
 2: regmap_read()
 2: mutex_lock(max77686 regmap mutex) // lock B
 2: i2c_transfer()
 2: s3c24xx_i2c_xfer()
 2: clk_unprepare()
 2: clk_prepare_lock()
 2: mutex_lock(clk prepare mutex) // lock A
 1: mutex_lock(max77686 regmap mutex) // lock B
 1,2: BOOM!

I suppose this is a general problem affecting any MFD device that is
also a clock provider, but I clearly don't have a good idea what to do
about it.

Full boot log below:

> Uncompressing Linux... done, booting the kernel.
> [    0.000000] Booting Linux on physical CPU 0xa00
> [    0.000000] Linux version 3.16.0-rc2-next-20140625-00007-g993e726d-dirty (t.figa@AMDC1227) (gcc version 4.8.2 (Gentoo 4.8.2 p1.1, pie-0.5.8) ) #905 SMP PREEMPT Tue Jul 1 17:48:42 CEST 2014
> [    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> [    0.000000] Machine model: Samsung Trats 2 based on Exynos4412
> [    0.000000] bootconsole [earlycon0] enabled
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Memory policy: Data cache writealloc
> [    0.000000] On node 0 totalpages: 262144
> [    0.000000] free_area_init_node: node 0, pgdat c063bc00, node_mem_map eeff0000
> [    0.000000]   Normal zone: 1520 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 194560 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 528 pages used for memmap
> [    0.000000]   HighMem zone: 67584 pages, LIFO batch:15
> [    0.000000] Running under secure firmware.
> [    0.000000] PERCPU: Embedded 7 pages/cpu @eefa3000 s7744 r8192 d12736 u32768
> [    0.000000] pcpu-alloc: s7744 r8192 d12736 u32768 alloc=8*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260624
> [    0.000000] Kernel command line: root=/dev/mmcblk0p5 rootwait console=ttySAC2,115200n8 earlyprintk ignore_loglevel no_console_suspend
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Memory: 1032564K/1048576K available (4329K kernel code, 266K rwdata, 1480K rodata, 275K init, 272K bss, 16012K reserved, 270336K highmem)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
> [    0.000000]     fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
> [    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
> [    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
> [    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
> [    0.000000]       .text : 0xc0008000 - 0xc05b47c0   (5810 kB)
> [    0.000000]       .init : 0xc05b5000 - 0xc05f9e40   ( 276 kB)
> [    0.000000]       .data : 0xc05fa000 - 0xc063c800   ( 266 kB)
> [    0.000000]        .bss : 0xc063c80c - 0xc0680a00   ( 273 kB)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] L2C: failed to init: -19
> [    0.000000] Exynos4x12 clocks: sclk_apll = 800000000, sclk_mpll = 800000000
> [    0.000000]  sclk_epll = 96000000, sclk_vpll = 108000000, arm_clk = 800000000
> [    0.000012] sched_clock: 64 bits at 24MHz, resolution 41ns, wraps every 2863311519744ns
> [    0.008211] Console: colour dummy device 80x30
> [    0.012619] Calibrating delay loop... 1590.88 BogoMIPS (lpj=3977216)
> [    0.037727] pid_max: default: 32768 minimum: 301
> [    0.042578] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.049146] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.056985] CPU: Testing write buffer coherency: ok
> [    0.062107] missing device node for CPU 0
> [    0.066114] missing device node for CPU 1
> [    0.070169] missing device node for CPU 2
> [    0.074212] missing device node for CPU 3
> [    0.078298] CPU0: thread -1, cpu 0, socket 10, mpidr 80000a00
> [    0.084903] Setting up static identity map for 0x4041c888 - 0x4041c8e0
> [    0.120728] CPU1: Booted secondary processor
> [    0.140009] CPU1: thread -1, cpu 1, socket 10, mpidr 80000a01
> [    0.150709] CPU2: Booted secondary processor
> [    0.170010] CPU2: thread -1, cpu 2, socket 10, mpidr 80000a02
> [    0.180722] CPU3: Booted secondary processor
> [    0.200010] CPU3: thread -1, cpu 3, socket 10, mpidr 80000a03
> [    0.200156] Brought up 4 CPUs
> [    0.233514] SMP: Total of 4 processors activated.
> [    0.238302] CPU: All CPU(s) started in SVC mode.
> [    0.243984] devtmpfs: initialized
> [    0.252902] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
> [    0.261509] pinctrl core: initialized pinctrl subsystem
> [    0.267742] regulator-dummy: no parameters
> [    0.287447] NET: Registered protocol family 16
> [    0.292766] DMA: preallocated 256 KiB pool for atomic coherent allocations
> [    0.307018] exynos-audss-clk 3810000.clock-controller: setup completed
> [    0.332875] gpiochip_add: registered GPIOs 0 to 7 on device: gpa0
> [    0.338935] gpiochip_add: registered GPIOs 8 to 13 on device: gpa1
> [    0.345185] gpiochip_add: registered GPIOs 14 to 21 on device: gpb
> [    0.351419] gpiochip_add: registered GPIOs 22 to 26 on device: gpc0
> [    0.357762] gpiochip_add: registered GPIOs 27 to 31 on device: gpc1
> [    0.364087] gpiochip_add: registered GPIOs 32 to 35 on device: gpd0
> [    0.370433] gpiochip_add: registered GPIOs 36 to 39 on device: gpd1
> [    0.376762] gpiochip_add: registered GPIOs 40 to 47 on device: gpf0
> [    0.383106] gpiochip_add: registered GPIOs 48 to 55 on device: gpf1
> [    0.389434] gpiochip_add: registered GPIOs 56 to 63 on device: gpf2
> [    0.395780] gpiochip_add: registered GPIOs 64 to 69 on device: gpf3
> [    0.402108] gpiochip_add: registered GPIOs 70 to 77 on device: gpj0
> [    0.408440] gpiochip_add: registered GPIOs 78 to 82 on device: gpj1
> [    0.416519] gpiochip_add: registered GPIOs 83 to 89 on device: gpk0
> [    0.422750] gpiochip_add: registered GPIOs 90 to 96 on device: gpk1
> [    0.429083] gpiochip_add: registered GPIOs 97 to 103 on device: gpk2
> [    0.435492] gpiochip_add: registered GPIOs 104 to 110 on device: gpk3
> [    0.442009] gpiochip_add: registered GPIOs 111 to 117 on device: gpl0
> [    0.448510] gpiochip_add: registered GPIOs 118 to 119 on device: gpl1
> [    0.455081] gpiochip_add: registered GPIOs 120 to 127 on device: gpl2
> [    0.461548] gpiochip_add: registered GPIOs 128 to 135 on device: gpm0
> [    0.468044] gpiochip_add: registered GPIOs 136 to 142 on device: gpm1
> [    0.474548] gpiochip_add: registered GPIOs 143 to 147 on device: gpm2
> [    0.481055] gpiochip_add: registered GPIOs 148 to 155 on device: gpm3
> [    0.487563] gpiochip_add: registered GPIOs 156 to 163 on device: gpm4
> [    0.494074] gpiochip_add: registered GPIOs 164 to 169 on device: gpy0
> [    0.500584] gpiochip_add: registered GPIOs 170 to 173 on device: gpy1
> [    0.507094] gpiochip_add: registered GPIOs 174 to 179 on device: gpy2
> [    0.513603] gpiochip_add: registered GPIOs 180 to 187 on device: gpy3
> [    0.520113] gpiochip_add: registered GPIOs 188 to 195 on device: gpy4
> [    0.526623] gpiochip_add: registered GPIOs 196 to 203 on device: gpy5
> [    0.533134] gpiochip_add: registered GPIOs 204 to 211 on device: gpy6
> [    0.539659] gpiochip_add: registered GPIOs 212 to 219 on device: gpx0
> [    0.546159] gpiochip_add: registered GPIOs 220 to 227 on device: gpx1
> [    0.552667] gpiochip_add: registered GPIOs 228 to 235 on device: gpx2
> [    0.559174] gpiochip_add: registered GPIOs 236 to 243 on device: gpx3
> [    0.567567] gpiochip_add: registered GPIOs 244 to 250 on device: gpz
> [    0.574712] gpiochip_add: registered GPIOs 251 to 258 on device: gpv0
> [    0.581130] gpiochip_add: registered GPIOs 259 to 266 on device: gpv1
> [    0.587615] gpiochip_add: registered GPIOs 267 to 274 on device: gpv2
> [    0.594130] gpiochip_add: registered GPIOs 275 to 282 on device: gpv3
> [    0.600629] gpiochip_add: registered GPIOs 283 to 284 on device: gpv4
> [    0.616275] EXYNOS4x12 PMU Initialize
> [    0.667979] of_get_named_gpiod_flags exited with status 0
> [    0.673790] VMEM_VDD_2.8V: 2800 mV 
> [    0.677531] of_get_named_gpiod_flags exited with status 0
> [    0.683339] CAM_SENSOR_A: 2800 mV 
> [    0.686996] of_get_named_gpiod_flags exited with status 0
> [    0.692796] LCD_VDD_2.2V: 2200 mV 
> [    0.696455] of_get_named_gpiod_flags exited with status 0
> [    0.702256] CAM_AF: 2800 mV 
> [    0.705409] of_get_named_gpiod_flags exited with status 0
> [    0.711172] CAM_ISP_CORE_1.2V_EN: 1200 mV 
> [    0.715489] of_get_named_gpiod_flags exited with status 0
> [    0.721255] LED_A_3.0V: 3000 mV 
> [    0.729652] SCSI subsystem initialized
> [    0.734917] usbcore: registered new interface driver usbfs
> [    0.740658] usbcore: registered new interface driver hub
> [    0.746302] usbcore: registered new device driver usb
> [    0.752844] s3c-i2c 13860000.i2c: slave address 0x10
> [    0.757776] s3c-i2c 13860000.i2c: bus frequency set to 390 KHz
> [    0.764887] s3c-i2c 13860000.i2c: i2c-0: S3C I2C adapter
> [    0.770462] s3c-i2c 13890000.i2c: slave address 0x10
> [    0.775409] s3c-i2c 13890000.i2c: bus frequency set to 390 KHz
> [    0.782528] s3c-i2c 13890000.i2c: i2c-3: S3C I2C adapter
> [    0.788120] s3c-i2c 138d0000.i2c: slave address 0x10
> [    0.793048] s3c-i2c 138d0000.i2c: bus frequency set to 97 KHz
> [    0.800838] max77686 7-0009: device found
> [    0.809622] VALIVE_1.0V_AP: 1000 mV 
> [    0.815406] VM1M2_1.2V_AP: 1200 mV 
> [    0.820988] VCC_1.8V_AP: 1800 mV 
> [    0.826434] VCC_2.8V_AP: 2800 mV 
> [    0.831844] VCC_1.8V_IO: 1800 mV 
> [    0.839038] VMPLL_1.0V_AP: 1000 mV 
> [    0.846363] VPLL_1.0V_AP: 1000 mV 
> [    0.851106] VMIPI_1.0V: 1000 mV 
> [    0.856936] CAM_ISP_MIPI_1.2V: 1200 mV 
> [    0.862121] VMIPI_1.8V: 1800 mV 
> [    0.869222] VABB1_1.95V: 1950 mV 
> [    0.873902] VUOTG_3.0V: 3000 mV 
> [    0.878469] NFC_AVDD_1.8V: 1800 mV 
> [    0.885868] VABB2_1.95V: 1950 mV 
> [    0.890618] VHSIC_1.0V: 1000 mV 
> [    0.895185] VHSIC_1.8V: 1800 mV 
> [    0.899714] CAM_SENSOR_CORE_1.2V: 1200 mV 
> [    0.905197] CAM_ISP_SEN_IO_1.8V: 1800 mV 
> [    0.910585] VT_CAM_1.8V: 1800 mV 
> [    0.915257] VDDQ_PRE_1.8V: 1800 mV 
> [    0.920072] VTF_2.8V: 2800 mV 
> [    0.925274] VMEM_VDD_2.8V: 2800 mV 
> [    0.929233] VMEM_VDD_2.8V: Failed to create debugfs directory
> [    0.935810] TSP_AVDD_3.3V: 3300 mV 
> [    0.940670] TSP_VDD_1.8V: 1800 mV 
> [    0.947112] LCD_VCC_3.3V: 2800 mV 
> [    0.951896] MOTOR_VCC_3.0V: 3000 mV 
> [    0.957637] vdd_mif: 850 <--> 1100 mV at 1000 mV 
> [    0.964138] vdd_arm: 850 <--> 1500 mV at 1100 mV 
> [    0.970659] vdd_int: 850 <--> 1150 mV at 1000 mV 
> [    0.977176] vdd_g3d: 850 <--> 1150 mV at 1000 mV 
> [    0.983693] VMEM_1.2V_AP: 1200 mV 
> [    0.988888] VCC_SUB_1.35V: 1350 mV 
> [    0.994170] VCC_SUB_2.0V: 2000 mV 
> [    0.999704] VMEM_VDDF_3.0V: 2850 mV 
> [    1.004672] CAM_ISP_CORE_1.2V: 1000 <--> 1200 mV at 1200 mV 
> [    1.011624] s3c-i2c 138d0000.i2c: i2c-7: S3C I2C adapter
> [    1.017264] media: Linux media interface: v0.10
> [    1.022084] Linux video capture interface: v2.00
> [    1.034087] Switched to clocksource mct-frc
> [    1.065452] NET: Registered protocol family 2
> [    1.070751] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
> [    1.077876] TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
> [    1.084607] TCP: Hash tables configured (established 8192 bind 8192)
> [    1.091055] TCP: reno registered
> [    1.094259] UDP hash table entries: 512 (order: 2, 24576 bytes)
> [    1.100265] UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
> [    1.106941] NET: Registered protocol family 1
> [    1.114343] futex hash table entries: 1024 (order: 4, 65536 bytes)
> [    1.136661] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
> [    1.141805] msgmni has been set to 1488
> [    1.146841] bounce: pool size: 64 pages
> [    1.150668] io scheduler noop registered
> [    1.154646] io scheduler deadline registered
> [    1.159350] io scheduler cfq registered (default)
> [    1.174939] dma-pl330 12680000.pdma: Loaded driver for PL330 DMAC-1315632
> [    1.181696] dma-pl330 12680000.pdma:         DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
> [    1.197223] dma-pl330 12690000.pdma: Loaded driver for PL330 DMAC-1315632
> [    1.204000] dma-pl330 12690000.pdma:         DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
> [    1.214521] dma-pl330 12850000.mdma: Loaded driver for PL330 DMAC-1315632
> [    1.221275] dma-pl330 12850000.mdma:         DBUFF-64x8bytes Num_Chans-8 Num_Peri-1 Num_Events-32
> [    1.397474] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    1.406862] 13800000.serial: ttySAC0 at MMIO 0x13800000 (irq = 84, base_baud = 0) is a S3C6400/10
> [    1.416444] 13810000.serial: ttySAC1 at MMIO 0x13810000 (irq = 85, base_baud = 0) is a S3C6400/10
> [    1.426041] 13820000.serial: ttySAC2 at MMIO 0x13820000 (irq = 86, base_baud = 0) is a S3C6400/10
> [    1.434949] console [tt[SAC2] enabled
>     1.434949] console [ttySAC2] enabled
> [    1.442166] bootconsole [early[on0] disabled
>     1.442166] bootconsole [earlycon0] disabled
> [    1.451388] 13830000.serial: ttySAC3 at MMIO 0x13830000 (irq = 87, base_baud = 0) is a S3C6400/10
> [    1.461017] [drm] Initialized drm 1.1.0 20060810
> [    1.467495] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    1.472686] [drm] No driver support for vblank timestamp query.
> [    1.478649] exynos-drm exynos-drm: bound 11c00000.fimd (ops fimd_component_ops)
> [    1.486503] exynos-drm exynos-drm: bound 11c80000.dsi (ops exynos_dsi_component_ops)
> [    1.493678] [drm] Initialized exynos 1.0.0 20110530 on minor 0
> [    1.499943] panel_s6e8aa0 11c80000.dsi.0: GPIO lookup for consumer reset
> [    1.506120] panel_s6e8aa0 11c80000.dsi.0: using device tree for GPIO lookup
> [    1.513071] of_get_named_gpiod_flags exited with status 0
> [    1.721532] panel_s6e8aa0 11c80000.dsi.0: ID: 0xa2, 0x60, 0x90
> [    1.894152] [drm:drm_calc_timestamping_constants] *ERROR* crtc 12: Can't calculate constants, dotclock = 0!
> [    1.927913] Console: switching to colour frame buffer device 102x91
> [    1.980431] exynos-drm exynos-drm: fb0:  frame buffer device
> [    1.986071] exynos-drm exynos-drm: registered panic notifier
> [    2.019291] brd: module loaded
> [    2.028936] loop: module loaded
> [    2.031779] s3c64xx-spi 13930000.spi: spi bus clock parent not specified, using clock at index 0 as parent
> [    2.040311] s3c64xx-spi 13930000.spi: number of chip select lines not specified, assuming 1 chip select line
> [    2.052146] usbcore: registered new interface driver asix
> [    2.056299] usbcore: registered new interface driver ax88179_178a
> [    2.062390] usbcore: registered new interface driver cdc_ether
> [    2.068182] usbcore: registered new interface driver smsc75xx
> [    2.073907] usbcore: registered new interface driver smsc95xx
> [    2.079624] usbcore: registered new interface driver net1080
> [    2.085248] usbcore: registered new interface driver cdc_subset
> [    2.091127] usbcore: registered new interface driver zaurus
> [    2.096769] usbcore: registered new interface driver cdc_ncm
> [    2.103145] s3c-hsotg 12480000.hsotg: regs f04c0000, irq 103
> [    2.109441] s3c-hsotg 12480000.hsotg: EPs:15
> [    2.112241] s3c-hsotg 12480000.hsotg: dedicated fifos
> [    2.120254] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.125422] ehci-exynos: EHCI EXYNOS driver
> [    2.130271] usbcore: registered new interface driver usb-storage
> [    2.136516] mousedev: PS/2 mouse device common for all mice
> [    2.144388] ERROR: could not get clock /i2c@13860000/s5c73m3@3c:cis_extclk(0)
> [    2.150125] i2c 0-003c: Driver S5C73M3 requests probe deferral
> [    2.156957] s5p-mipi-csis 11880000.csis: lanes: 4, hs_settle: 12, wclk: 0, freq: 176000000
> [    2.164836] s5p-mipi-csis 11890000.csis: lanes: 1, hs_settle: 18, wclk: 1, freq: 160000000
> [    2.175582] ERROR: could not get clock /camera/fimc-is@12000000/i2c-isp@12140000/s5k6a3@10:extclk(0)
> [    2.183306] i2c 1-0010: Driver S5K6A3 requests probe deferral
> [    2.191900] exynos4-fimc-is 12000000.fimc-is: Direct firmware load failed with error -2
> [    2.198501] exynos4-fimc-is 12000000.fimc-is: Falling back to user helper
> [    2.198865] isp-power-domain: Power-off latency exceeded, new value 285125 ns
> [    2.213436] s5p-fimc-md: Registered fimc.0.m2m as /dev/video0
> [    2.218521] s5p-fimc-md: Registered fimc.0.capture as /dev/video1
> [    2.224563] s5p-fimc-md: Registered fimc.1.m2m as /dev/video2
> [    2.230371] s5p-fimc-md: Registered fimc.1.capture as /dev/video3
> [    2.236463] s5p-fimc-md: Registered fimc-lite.0.capture as /dev/video4
> [    2.242875] s5p-fimc-md: Registered fimc-lite.1.capture as /dev/video5
> [    2.249499] s5p-fimc-md: Registered fimc-is-isp.capture as /dev/video6
> [    2.255932] cam-power-domain: Power-off latency exceeded, new value 271875 ns
> [    2.264529] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [    2.275629] sdhci: Secure Digital Host Controller Interface driver
> [    2.280418] sdhci: Copyright(c) Pierre Ossman
> [    2.285026] Synopsys Designware Multimedia Card Interface Driver
> [    2.291612] dwmmc_exynos 12550000.mmc: Using internal DMA controller.
> [    2.297169] dwmmc_exynos 12550000.mmc: Version ID is 240a
> [    2.302814] dwmmc_exynos 12550000.mmc: DW MMC controller at irq 109, 32 bit host data width, 128 deep fifo
> [    2.312220] of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12550000[0]'
> [    2.349217] dwmmc_exynos 12550000.mmc: 1 slots initialized
> [    2.355245] usbcore: registered new interface driver usbhid
> [    2.359407] usbhid: USB HID core driver
> [    2.363404] TCP: cubic registered
> [    2.366559] NET: Registered protocol family 17
> [    2.371013] NET: Registered protocol family 15
> [    2.375637] Registering SWP/SWPB emulation handler
> [    2.380170] gps-alive-power-domain: Power-off latency exceeded, new value 4634500 ns
> [    2.387932] gps-power-domain: Power-off latency exceeded, new value 12171083 ns
> [    2.389617] of_get_named_gpiod_flags exited with status 0
> [    2.389637] of_get_named_gpiod_flags exited with status 0
> [    2.390364] S5C73M3: S5C73M3 SPI probed successfully
> [    2.411122] tv-power-domain: Power-off latency exceeded, new value 178625 ns
> [    2.417923] g3d-power-domain: Power-off latency exceeded, new value 6944459 ns
> [    2.425415] mfc-power-domain: Power-off latency exceeded, new value 179542 ns
> [    2.436992] cam-power-domain: Power-on latency exceeded, new value 434833 ns
> [    2.455453] S5C73M3: Sensor type: CML0801-M080, FW version: ZHFJ02
> [    2.460833] cam-power-domain: Power-off latency exceeded, new value 274084 ns
> [    2.471060] s5p-fimc-md: Registered sensor subdevice: S5C73M3-OIF (0)
> [    2.476069] S5C73M3: s5c73m3_probe: completed successfully
> [    2.481721] of_get_named_gpiod_flags exited with status 0
> [    2.487347] s5p-fimc-md: Registered sensor subdevice: S5K6A3 1-0010 (1)
> [    2.493544] s5p-fimc-md: created link [S5C73M3-OIF] => [s5p-mipi-csis.0]
> [    2.500212] s5p-fimc-md: created link [S5K6A3 1-0010] => [s5p-mipi-csis.1]
> [    2.507065] s5p-fimc-md: created link [s5p-mipi-csis.0] => [FIMC.0]
> [    2.513313] s5p-fimc-md: created link [s5p-mipi-csis.0] -> [FIMC.1]
> [    2.513390] mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 52000000Hz, actual 50000000HZ div = 0)
> [    2.529361] s5p-fimc-md: created link [s5p-mipi-csis.0] -> [FIMC-LITE.0]
> [    2.536009] s5p-fimc-md: created link [s5p-mipi-csis.0] -> [FIMC-LITE.1]
> [    2.542689] s5p-fimc-md: created link [s5p-mipi-csis.1] -> [FIMC-LITE.0]
> [    2.542755] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
> [    2.542976] mmc0: new DDR MMC card at address 0001
> [    2.549471] mmcblk0: mmc0:0001 VTU00M 14.6 GiB 
> [    2.549691] mmcblk0boot0: mmc0:0001 VTU00M partition 1 2.00 MiB
> [    2.549917] mmcblk0boot1: mmc0:0001 VTU00M partition 2 2.00 MiB
> [    2.550125] mmcblk0rpmb: mmc0:0001 VTU00M partition 3 128 KiB
> [    2.555724]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
> [    2.561000]  mmcblk0boot1: unknown partition table
> [    2.562557]  mmcblk0boot0: unknown partition table
> [    2.599618] s5p-fimc-md: created link [s5p-mipi-csis.1] -> [FIMC-LITE.1]
> [    2.610369] of_get_named_gpiod_flags exited with status 0
> [    2.614413] of_get_named_gpiod_flags exited with status 0
> [    2.619804] of_get_named_gpiod_flags exited with status 0
> [    2.625115] of_get_named_gpiod_flags exited with status 0
> [    2.630533] gpio-239 (volume down): gpiod_set_debounce: missing set() or set_debounce() operations
> [    2.639541] gpio-230 (volume up): gpiod_set_debounce: missing set() or set_debounce() operations
> [    2.648314] gpio-235 (power): gpiod_set_debounce: missing set() or set_debounce() operations
> [    2.656718] gpio-213 (ok): gpiod_set_debounce: missing set() or set_debounce() operations
> [    2.665165] input: gpio-keys as /devices/gpio-keys/input/input0
> [    2.671295] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> [    2.693343] vdd_g3d: disabling
> [    2.698346] VDDQ_PRE_1.8V: disabling
> [    2.703375] VHSIC_1.8V: disabling
> [    2.708141] LED_A_3.0V: disabling
> [    2.710069] CAM_AF: disabling
> [    2.712939] CAM_SENSOR_A: disabling
> [   62.334649] exynos4-fimc-is 12000000.fimc-is: firmware request failed
> [  240.679135] INFO: task swapper/0:1 blocked for more than 120 seconds.
> [  240.684143]       Not tainted 3.16.0-rc2-next-20140625-00007-g993e726d-dirty #905
> [  240.691626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.699408] swapper/0       D c0418014     0     1      0 0x00000000
> [  240.705765] [<c0418014>] (__schedule) from [<c0418734>] (schedule_preempt_disabled+0x14/0x20)
> [  240.714267] [<c0418734>] (schedule_preempt_disabled) from [<c041ac5c>] (__mutex_lock_slowpath+0x1a0/0x3e4)
> [  240.723892] [<c041ac5c>] (__mutex_lock_slowpath) from [<c041aeac>] (mutex_lock+0xc/0x24)
> [  240.732022] [<c041aeac>] (mutex_lock) from [<c0278170>] (regmap_read+0x30/0x60)
> [  240.739280] [<c0278170>] (regmap_read) from [<c036d51c>] (max77686_clk_is_prepared+0x20/0x3c)
> [  240.747768] [<c036d51c>] (max77686_clk_is_prepared) from [<c036a59c>] (clk_unprepare_unused_subtree+0x64/0x98)
> [  240.757745] [<c036a59c>] (clk_unprepare_unused_subtree) from [<c036a654>] (clk_disable_unused+0x84/0xd8)
> [  240.767205] [<c036a654>] (clk_disable_unused) from [<c0008990>] (do_one_initcall+0x8c/0x1c4)
> [  240.775634] [<c0008990>] (do_one_initcall) from [<c05b5cf0>] (kernel_init_freeable+0x138/0x1d8)
> [  240.784318] [<c05b5cf0>] (kernel_init_freeable) from [<c04132d0>] (kernel_init+0x8/0xf0)
> [  240.792382] [<c04132d0>] (kernel_init) from [<c000e678>] (ret_from_fork+0x14/0x3c)
> [  240.799923] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
> [  240.806513]       Not tainted 3.16.0-rc2-next-20140625-00007-g993e726d-dirty #905
> [  240.813975] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.821787] kworker/0:0     D c0418014     0     4      2 0x00000000
> [  240.828118] Workqueue: events od_dbs_timer
> [  240.832198] [<c0418014>] (__schedule) from [<c0418734>] (schedule_preempt_disabled+0x14/0x20)
> [  240.840728] [<c0418734>] (schedule_preempt_disabled) from [<c041ac5c>] (__mutex_lock_slowpath+0x1a0/0x3e4)
> [  240.850357] [<c041ac5c>] (__mutex_lock_slowpath) from [<c041aeac>] (mutex_lock+0xc/0x24)
> [  240.858430] [<c041aeac>] (mutex_lock) from [<c03692c0>] (clk_prepare_lock+0x88/0xfc)
> [  240.866159] [<c03692c0>] (clk_prepare_lock) from [<c036ac80>] (clk_unprepare+0x18/0x28)
> [  240.874154] [<c036ac80>] (clk_unprepare) from [<c02f67ac>] (s3c24xx_i2c_xfer+0x18c/0x40c)
> [  240.882305] [<c02f67ac>] (s3c24xx_i2c_xfer) from [<c02f127c>] (__i2c_transfer+0x78/0x90)
> [  240.890373] [<c02f127c>] (__i2c_transfer) from [<c02f2560>] (i2c_transfer+0xa0/0xd8)
> [  240.898096] [<c02f2560>] (i2c_transfer) from [<c027c6d4>] (regmap_i2c_read+0x48/0x64)
> [  240.905916] [<c027c6d4>] (regmap_i2c_read) from [<c0278648>] (_regmap_raw_read+0x98/0xf4)
> [  240.914118] [<c0278648>] (_regmap_raw_read) from [<c02786c8>] (_regmap_bus_read+0x24/0x5c)
> [  240.922323] [<c02786c8>] (_regmap_bus_read) from [<c02780c8>] (_regmap_read+0x6c/0xe4)
> [  240.930266] [<c02780c8>] (_regmap_read) from [<c0278180>] (regmap_read+0x40/0x60)
> [  240.937693] [<c0278180>] (regmap_read) from [<c020a218>] (regulator_is_enabled_regmap+0x20/0x9c)
> [  240.946463] [<c020a218>] (regulator_is_enabled_regmap) from [<c0206b14>] (_regulator_is_enabled.part.16+0x1c/0x28)
> [  240.956785] [<c0206b14>] (_regulator_is_enabled.part.16) from [<c020705c>] (_regulator_do_set_voltage+0x2d0/0x348)
> [  240.967105] [<c020705c>] (_regulator_do_set_voltage) from [<c0207184>] (regulator_set_voltage+0xb0/0x13c)
> [  240.976650] [<c0207184>] (regulator_set_voltage) from [<c0337250>] (exynos_target+0x268/0x2d4)
> [  240.985248] [<c0337250>] (exynos_target) from [<c0331680>] (__cpufreq_driver_target+0x158/0x294)
> [  240.994020] [<c0331680>] (__cpufreq_driver_target) from [<c0336750>] (dbs_check_cpu+0x1a4/0x1e4)
> [  241.002782] [<c0336750>] (dbs_check_cpu) from [<c0335390>] (od_dbs_timer+0x78/0x130)
> [  241.010512] [<c0335390>] (od_dbs_timer) from [<c0032854>] (process_one_work+0x11c/0x35c)
> [  241.018580] [<c0032854>] (process_one_work) from [<c00330c8>] (worker_thread+0x4c/0x568)
> [  241.026649] [<c00330c8>] (worker_thread) from [<c003876c>] (kthread+0xd8/0xf0)
> [  241.033856] [<c003876c>] (kthread) from [<c000e678>] (ret_from_fork+0x14/0x3c)
> [  241.041060] INFO: task kworker/1:1:444 blocked for more than 120 seconds.
> [  241.047818]       Not tainted 3.16.0-rc2-next-20140625-00007-g993e726d-dirty #905
> [  241.055278] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.063090] kworker/1:1     D c0418014     0   444      2 0x00000000
> [  241.069435] Workqueue: events od_dbs_timer
> [  241.073501] [<c0418014>] (__schedule) from [<c0418734>] (schedule_preempt_disabled+0x14/0x20)
> [  241.082034] [<c0418734>] (schedule_preempt_disabled) from [<c041ac5c>] (__mutex_lock_slowpath+0x1a0/0x3e4)
> [  241.091663] [<c041ac5c>] (__mutex_lock_slowpath) from [<c041aeac>] (mutex_lock+0xc/0x24)
> [  241.099736] [<c041aeac>] (mutex_lock) from [<c033535c>] (od_dbs_timer+0x44/0x130)
> [  241.107203] [<c033535c>] (od_dbs_timer) from [<c0032854>] (process_one_work+0x11c/0x35c)
> [  241.115274] [<c0032854>] (process_one_work) from [<c00330c8>] (worker_thread+0x4c/0x568)
> [  241.123342] [<c00330c8>] (worker_thread) from [<c003876c>] (kthread+0xd8/0xf0)
> [  241.130602] [<c003876c>] (kthread) from [<c000e678>] (ret_from_fork+0x14/0x3c)
> [  241.137758] INFO: task kworker/3:1:1154 blocked for more than 120 seconds.
> [  241.144604]       Not tainted 3.16.0-rc2-next-20140625-00007-g993e726d-dirty #905
> [  241.152061] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.159874] kworker/3:1     D c0418014     0  1154      2 0x00000000
> [  241.166221] Workqueue: events od_dbs_timer
> [  241.170283] [<c0418014>] (__schedule) from [<c0418734>] (schedule_preempt_disabled+0x14/0x20)
> [  241.178811] [<c0418734>] (schedule_preempt_disabled) from [<c041ac5c>] (__mutex_lock_slowpath+0x1a0/0x3e4)
> [  241.188447] [<c041ac5c>] (__mutex_lock_slowpath) from [<c041aeac>] (mutex_lock+0xc/0x24)
> [  241.196519] [<c041aeac>] (mutex_lock) from [<c033535c>] (od_dbs_timer+0x44/0x130)
> [  241.203986] [<c033535c>] (od_dbs_timer) from [<c0032854>] (process_one_work+0x11c/0x35c)
> [  241.212065] [<c0032854>] (process_one_work) from [<c00330c8>] (worker_thread+0x4c/0x568)
> [  241.220131] [<c00330c8>] (worker_thread) from [<c003876c>] (kthread+0xd8/0xf0)
> [  241.227331] [<c003876c>] (kthread) from [<c000e678>] (ret_from_fork+0x14/0x3c)
> [  241.234531] INFO: task kworker/2:1:1273 blocked for more than 120 seconds.
> [  241.241381]       Not tainted 3.16.0-rc2-next-20140625-00007-g993e726d-dirty #905
> [  241.248843] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.256654] kworker/2:1     D c0418014     0  1273      2 0x00000000
> [  241.262978] Workqueue: events od_dbs_timer
> [  241.267063] [<c0418014>] (__schedule) from [<c0418734>] (schedule_preempt_disabled+0x14/0x20)
> [  241.275595] [<c0418734>] (schedule_preempt_disabled) from [<c041ac5c>] (__mutex_lock_slowpath+0x1a0/0x3e4)
> [  241.285227] [<c041ac5c>] (__mutex_lock_slowpath) from [<c041aeac>] (mutex_lock+0xc/0x24)
> [  241.293298] [<c041aeac>] (mutex_lock) from [<c033535c>] (od_dbs_timer+0x44/0x130)
> [  241.300765] [<c033535c>] (od_dbs_timer) from [<c0032854>] (process_one_work+0x11c/0x35c)
> [  241.308834] [<c0032854>] (process_one_work) from [<c00330c8>] (worker_thread+0x4c/0x568)
> [  241.316905] [<c00330c8>] (worker_thread) from [<c003876c>] (kthread+0xd8/0xf0)
> [  241.324111] [<c003876c>] (kthread) from [<c000e678>] (ret_from_fork+0x14/0x3c)

-- 
Best regards,
Tomasz
