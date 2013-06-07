Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3FGSrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:47:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50317 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3FGSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:47:39 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 0/5] v3.10-rc4: fix OMAP4 boot failure if CONFIG_SENSORS_LM75=y
Date: Fri, 7 Jun 2013 21:43:27 +0300
Message-ID: <1370630612-4014-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I observe, that OMAP4 SDP board boot is failed if CONFIG_SENSORS_LM75=y. See log below.
This issue reproduced with kernel v3.9-rc6, but without hang - just I2C is stuck
in Bus Busy condition. My investigation results are below.

[    2.048858] TCP: cubic registered
[    2.052398] Initializing XFRM netlink socket
[    2.057037] NET: Registered protocol family 17
[    2.061859] NET: Registered protocol family 15
[    2.066955] Key type dns_resolver registered
[    2.071716] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
[    2.081085] Power Management for TI OMAP4.
[    2.085418] OMAP4 PM: u-boot >= v2012.07 is required for full PM support
[    2.092773] ThumbEE CPU extension supported.
[    2.107788] omap_i2c 48070000.i2c: bus 0 rev0.11 at 400 kHz
[    2.117858] Skipping twl internal clock init and using bootloader value (unknown osc rate)
[    2.128570] twl 0-0048: PIH (irq 39) chaining IRQs 416..436
[    2.137237] twl_rtc rtc.11: Enabling TWL-RTC
[    2.146301] twl_rtc rtc.11: rtc core: registered rtc.11 as rtc0
[    2.155181] VAUX1_6030: 1000 <--> 3000 mV at 2800 mV 
[    2.162750] VAUX2_6030: 1200 <--> 2800 mV at 1800 mV 
[    2.170318] VAUX3_6030: 1000 <--> 3000 mV at 1200 mV 
[    2.177856] VMMC: 1200 <--> 3000 mV at 1800 mV 
[    2.184692] VPP: 1800 <--> 2500 mV at 1900 mV 
[    2.191589] VUSIM: 1200 <--> 2900 mV at 1800 mV 
[    2.198394] VDAC: 1800 mV 
[    2.202850] VANA: 2100 mV 
[    2.207763] VCXIO: 1800 mV 
[    2.212310] VUSB: 3300 mV 
[    2.217346] V1V8: 1800 mV 
[    2.222290] V2V1: 2100 mV 
[    2.239837] omap_i2c 48072000.i2c: bus 1 rev0.11 at 400 kHz
[    2.246307] ------------[ cut here ]------------
[    2.251220] WARNING: at drivers/bus/omap_l3_noc.c:113 l3_interrupt_handler+0x140/0x184()
[    2.257781] L3 custom error: MASTER:MPU TARGET:L4 PER2
[    2.264373] Modules linked in:
[    2.268463] CPU: 0 PID: 2 Comm: kthreadd Not tainted 3.10.0-rc4-00034-g042dd60-dirty #64
[    2.270385] [<c001a80c>] (unwind_backtrace+0x0/0xf0) from [<c0017238>] (show_stack+0x10/0x14)
[    2.286102] [<c0017238>] (show_stack+0x10/0x14) from [<c0040fd0>] (warn_slowpath_common+0x4c/0x68)
[    2.295593] [<c0040fd0>] (warn_slowpath_common+0x4c/0x68) from [<c0041080>] (warn_slowpath_fmt+0x30/0x40)
[    2.299987] [<c0041080>] (warn_slowpath_fmt+0x30/0x40) from [<c02c5ed0>] (l3_interrupt_handler+0x140/0x184)
[    2.315582] [<c02c5ed0>] (l3_interrupt_handler+0x140/0x184) from [<c009ffb8>] (handle_irq_event_percpu+0x58/0x258)
[    2.323364] [<c009ffb8>] (handle_irq_event_percpu+0x58/0x258) from [<c00a01f4>] (handle_irq_event+0x3c/0x5c)
[    2.327819] [<c00a01f4>] (handle_irq_event+0x3c/0x5c) from [<c00a2f7c>] (handle_fasteoi_irq+0xbc/0x164)
[    2.337829] [<c00a2f7c>] (handle_fasteoi_irq+0xbc/0x164) from [<c009f978>] (generic_handle_irq+0x20/0x30)
[    2.357513] [<c009f978>] (generic_handle_irq+0x20/0x30) from [<c0014168>] (handle_IRQ+0x4c/0xac)
[    2.366821] [<c0014168>] (handle_IRQ+0x4c/0xac) from [<c00085b4>] (gic_handle_irq+0x28/0x5c)
[    2.375762] [<c00085b4>] (gic_handle_irq+0x28/0x5c) from [<c04f08a4>] (__irq_svc+0x44/0x5c)
[    2.379821] Exception stack(0xdb085ec0 to 0xdb085f08)
[    2.389953] 5ec0: 00000001 00000001 00000000 db07ea00 40000113 db2317a8 db084000 000002f1
[    2.389953] 5ee0: db07ea00 00000000 00000000 00000000 c04fd990 db085f08 c009170c c04f03e8
[    2.405609] 5f00: 20000113 ffffffff
[    2.408355] [<c04f08a4>] (__irq_svc+0x44/0x5c) from [<c04f03e8>] (_raw_spin_unlock_irqrestore+0x34/0x44)
[    2.418304] [<c04f03e8>] (_raw_spin_unlock_irqrestore+0x34/0x44) from [<c00403c0>] (do_fork+0xa4/0x2d4)
[    2.427795] [<c00403c0>] (do_fork+0xa4/0x2d4) from [<c0040620>] (kernel_thread+0x30/0x38)
[    2.437805] [<c0040620>] (kernel_thread+0x30/0x38) from [<c0063888>] (kthreadd+0xd4/0x13c)
[    2.448364] [<c0063888>] (kthreadd+0xd4/0x13c) from [<c0013308>] (ret_from_fork+0x14/0x2c)
[    2.448364] ---[ end trace da8cf92c433d1616 ]---
[    4.028594] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    5.047637] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    6.662322] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    7.687499] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    8.717315] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    9.737365] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   10.747863] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   11.767608] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   12.768035] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   13.777893] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   14.787872] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   15.807128] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   17.318084] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   18.338226] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   19.367645] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   20.388031] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   21.407928] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   22.457336] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   23.487915] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   23.487915] omap_i2c 48060000.i2c: bus 2 rev0.11 at 400 kHz
[   24.537414] omap_i2c 48060000.i2c: timeout waiting for bus ready
[   24.537445] lm75: probe of 2-0048 failed with error -110
[   24.578216] omap_i2c 48350000.i2c: bus 3 rev0.11 at 400 kHz
[   24.585601] omap-dma-engine 4a056000.dma-controller: allocating channel for 62
[   24.593383] omap-dma-engine 4a056000.dma-controller: allocating channel for 61
[   24.602386] omap_hsmmc 4809c000.mmc: pins are not configured from the driver
[   24.641540] omap-dma-engine 4a056000.dma-controller: allocating channel for 48
[   24.649261] omap-dma-engine 4a056000.dma-controller: allocating channel for 47
[   24.657104] omap_hsmmc 480b4000.mmc: pins are not configured from the driver
[   24.713287] twl_rtc rtc.11: setting system clock to 2000-01-01 03:51:29 UTC (946698689)
[   24.725891] RAMDISK: gzip image found at block 0
[   24.805297] mmc1: new high speed MMC card at address 0001
[   24.813659] mmcblk0: mmc1:0001 SEM32G 29.7 GiB 
[   24.819488] mmcblk0boot0: mmc1:0001 SEM32G partition 1 1.00 MiB
[   24.827301] mmcblk0boot1: mmc1:0001 SEM32G partition 2 1.00 MiB
[   24.848236] Alternate GPT is invalid, using primary GPT.
[   24.854034]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
[   24.869995]  mmcblk0boot1: unknown partition table
[   24.878601]  mmcblk0boot0: unknown partition table
[   25.244140] kjournald starting.  Commit interval 5 seconds
[   25.244140] EXT3-fs (ram0): using internal journal
[   25.244140] EXT3-fs (ram0): mounted filesystem with ordered data mode
[   25.244140] VFS: Mounted root (ext3 filesystem) on device 1:0.
[   25.270233] Unhandled fault: imprecise external abort (0x1406) at 0x00207eb0
[   25.281677] VFS: Cannot open root device "(null)" or unknown-block(0,0): error -6
[   25.290008] Please append a correct "root=" boot option; here are the available partitions:
[   25.298950] b300        31162368 mmcblk0  driver: mmcblk
[   25.298950]   b301             128 mmcblk0p1 f9f21f00-a8d4-5f0e-9746-594869aec34e
[   25.312561]   b302             256 mmcblk0p2 f9f21f01-a8d4-5f0e-9746-594869aec34e
[   25.317779]   b303             128 mmcblk0p3 f9f21f02-a8d4-5f0e-9746-594869aec34e
[   25.328216]   b304           16384 mmcblk0p4 f9f21f03-a8d4-5f0e-9746-594869aec34e
[   25.336364]   b305              16 mmcblk0p5 f9f21f04-a8d4-5f0e-9746-594869aec34e
[   25.344116]   b306            8192 mmcblk0p6 f9f21f05-a8d4-5f0e-9746-594869aec34e
[   25.351501]   b307            8192 mmcblk0p7 f9f21f06-a8d4-5f0e-9746-594869aec34e
[   25.360229] b310            1024 mmcblk0boot1  (driver?)
[   25.364074] b308            1024 mmcblk0boot0  (driver?)
[   25.370391] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[   25.371643] CPU1: stopping
[   25.383361] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.10.0-rc4-00034-g042dd60-dirty #64
[   25.383361] [<c001a80c>] (unwind_backtrace+0x0/0xf0) from [<c0017238>] (show_stack+0x10/0x14)
[   25.402069] [<c0017238>] (show_stack+0x10/0x14) from [<c0018840>] (handle_IPI+0x130/0x158)
[   25.402069] [<c0018840>] (handle_IPI+0x130/0x158) from [<c00085e0>] (gic_handle_irq+0x54/0x5c)
[   25.410827] [<c00085e0>] (gic_handle_irq+0x54/0x5c) from [<c04f08a4>] (__irq_svc+0x44/0x5c)
[   25.428771] Exception stack(0xdb0a7f90 to 0xdb0a7fd8)
[   25.428771] 7f80:                                     00000001 00000001 00000000 db0a5480
[   25.428771] 7fa0: db0a6000 00000000 10c03c7d c07f6834 c04fc6a0 c07f4eec c07689ac 00000000
[   25.451416] 7fc0: 01000000 db0a7fd8 c009170c c00144b4 20000113 ffffffff
[   25.451416] [<c04f08a4>] (__irq_svc+0x44/0x5c) from [<c00144b4>] (arch_cpu_idle+0x20/0x44)
[   25.451416] [<c00144b4>] (arch_cpu_idle+0x20/0x44) from [<c0080bd0>] (cpu_startup_entry+0xa8/0x228)
[   25.451416] [<c0080bd0>] (cpu_startup_entry+0xa8/0x228) from [<804e45c4>] (0x804e45c4)


Investigation results - There are three issues:
1) The crash happens because of the race between omap_i2c_runtime_suspend()
 and omap_i2c_isr_thread()

CPU1:                                   CPU2:
|-omap_i2c_xfer                         |
  |- pm_runtime_put_autosuspend()       |
     |-timeout                          |-omap_i2c_isr()
                                          |-return IRQ_WAKE_THREAD
     |-omap_i2c_runtime_suspend()       |
                                        |-omap_i2c_isr_thread()
                                          |- oops is here - I2C module is in idle state

The patch https://lkml.org/lkml/2013/6/3/59 
"[PATCH v5] i2c: omap: correct usage of the interrupt enable register" improves 
situation and allows to boot sometimes.
The patch https://lkml.org/lkml/2013/4/23/215 
"[PATCH 1/2] i2c: omap: convert to module_platform_driver()" hides the issue.

The patch http://www.spinics.net/lists/linux-i2c/msg10169.html
"i2c: omap: fix spurious IRQs: disable/enable IRQ at INTC when idle"
- fixes the boot crash, but I2C bus 2 still stuck in "Bus Busy" state.

[   23.487915] omap_i2c 48060000.i2c: timeout waiting for bus ready

In addition, I've created two patches to fix wrong IRQ handling and to prevent 
such kind of crashes in the future:
  i2c: omap: add runtime check in isr to be sure that i2c is enabled
  i2c: omap: handle all irqs befor unblocking omap_i2c_xfer_msg()


2) Q: Why I2C is suspended so fast during the boot?
The issue 1 should be reproducible very rare, in general. I traced it to:
omap_i2c_xfer
|- pm_runtime_put_autosuspend()
   |- __pm_runtime_suspend
      |- rpm_suspend()
         |- mod_timer(&dev->power.suspend_timer, expires);

The mod_timer() should schedule next timer event after ~100-200 jiffes,
which is equal to  1 sec (as requested).
 But, at boot time, the timer expires after ~50 ms instead!!

[   23.190002] omap_i2c 48350000.i2c: ==== i2c_add_numbered_adapter
[   23.204681] omap_i2c 48350000.i2c: bus 3 rev0.11 at 400 kHz
[   23.211669] omap_i2c 48350000.i2c: ====== rpm_suspend elapsed 0 last_busy 4294939616
[   23.219879] omap_i2c 48350000.i2c: ====== rpm_suspend expires 4294939716 last_busy 4294939616 autosuspend_delay 1000
[   23.219879] omap_i2c 48350000.i2c: ====== rpm_suspend expires 4294939700
[   23.237274] omap_i2c 48350000.i2c: ====== rpm_suspend mod_timer expires 4294939700
--- the timer scheduled to 84 jiffes
[   23.246185] omap_i2c 48350000.i2c: ==== pm_runtime_put_autosuspend
[   23.253448] omap-dma-engine 4a056000.dma-controller: allocating channel for 62
[   23.261138] omap-dma-engine 4a056000.dma-controller: allocating channel for 61
[   23.269500] omap_i2c 48070000.i2c: ==== omap_i2c_runtime_resume
[   23.275817] omap_i2c 48350000.i2c: ==== omap_i2c_runtime_suspend
--- and expired after ~40 ms

Unfortunatelly, Im not able to find the root cause of such timers behavior - have
not to much knowledge about system clocks code.


3) when lm75_detect() requests to read from  bus 2 addr 0x48 (tmp105 sensor)
registers 0x04 and above (registers don't exist) the bus stuck in Bus busy condition
 until next I2C re-initialization (PM runtime suspend/resume). 

[    3.300933] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    4.369262] omap_i2c 48060000.i2c: timeout waiting for bus ready
[    5.381530] omap_i2c 48060000.i2c: timeout waiting for bus ready

I've found that the NACK condition not handled properly:
- when NACK condition is detected the master should generate STT or STP condition
- now, the I2C driver generates STP only if NACK has been received during the
  last message transmitting/recieving. As result, the "Bus Busy" state may occur
  if NACK has been received during any other messages transmission
  /reception, because STP isn't generated.

Patch "i2c: omap: query STP always when NACK is received:" fixes this issue.


This patch series based on top of:
http://patchwork.ozlabs.org/patch/248188/

Grygorii Strashko (4):
  i2c: omap: add runtime check in isr to be sure that i2c is enabled
  i2c: omap: handle all irqs befor unblocking omap_i2c_xfer_msg()
  i2c: omap: query STP always when NACK is received
  i2c: omap: remove omap_i2c_isr() hw irq handler

Kevin Hilman (1):
  i2c: omap: fix spurious IRQs: disable/enable IRQ at INTC when idle

 drivers/i2c/busses/i2c-omap.c |   52 +++++++++++++----------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)


CC: Kevin Hilman <khilman@linaro.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Felipe Balbi <balbi@ti.com>
-- 
1.7.9.5

