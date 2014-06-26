Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaFZOWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:22:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36783 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbaFZOWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:22:38 -0400
Message-ID: <53AC2CA7.30800@ti.com>
Date: Thu, 26 Jun 2014 17:22:31 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        "Kristo, Tero" <t-kristo@ti.com>
CC: <rnayak@ti.com>, <balbi@ti.com>, <nsekhar@ti.com>, <kishon@ti.com>,
        <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: DRA7-evm: Enable SATA PHY and USB PHY power supplies
References: <1403700996-27105-1-git-send-email-rogerq@ti.com> <53AB4CE0.6020705@ti.com> <20140626073115.GD28884@atomide.com> <53ABE9AD.1000100@ti.com>
In-Reply-To: <53ABE9AD.1000100@ti.com>
Content-Type: multipart/mixed;
	boundary="------------080108030109050304020400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080108030109050304020400
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

+Tero

On 06/26/2014 12:36 PM, Roger Quadros wrote:
> On 06/26/2014 10:31 AM, Tony Lindgren wrote:
>> * Nishanth Menon <nm@ti.com> [140625 15:29]:
>>> On 06/25/2014 07:56 AM, Roger Quadros wrote:
>>>> The SATA and USB PHYs need the 1.8V and 3.3V supplies.
>>>> The PHY drivers/framework don't yet support regulator
>>>> supply so we have to keep these regulators always-on till
>>>> then.
>>>>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>> ---
>>>>  arch/arm/boot/dts/dra7-evm.dts | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>>>> index 4adc280..99a1f79 100644
>>>> --- a/arch/arm/boot/dts/dra7-evm.dts
>>>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>>>> @@ -241,6 +241,7 @@
>>>>  					regulator-min-microvolt = <1800000>;
>>>>  					regulator-max-microvolt = <1800000>;
>>>>  					regulator-boot-on;
>>>> +					regulator-always-on;
>>>>  				};
>>>>  
>>>>  				ldo9_reg: ldo9 {
>>>> @@ -266,6 +267,7 @@
>>>>  					regulator-min-microvolt = <3300000>;
>>>>  					regulator-max-microvolt = <3300000>;
>>>>  					regulator-boot-on;
>>>> +					regulator-always-on;
>>>>  				};
>>>>  			};
>>>>  		};
>>>>
>>>
>>> Why not fix phy driver/framework as needed? the trouble is people
>>> always forget to remove always-on... who actually audits old logs and
>>> fixes stuff back up?
>>
>> Yes I agree let's not play with the regulator-always-on unless
>> absolutely necessary.
>>
> Agreed. PHY framework must deal with this. Till then USB, SATA and most likely PCIe as well will not work on DRA7-evm.
> 

I tried the below patch to enable the relevant regulators in the PHY drivers but still couldn't manage to get USB to work. The same 1.8V regulator is used to supply 3 pins
-vdda_usb1: DPLL_USB and HS_USB1 analog supply
-vdda_usb2: HS_USB2 analog supply
-vdda_usb3: DPLL_USB_OTG_SS and USB3.0 Rx/Tx analog supply

It seems that the regulator auto disable kicks in before the phy driver enables the regulator thus causing some kind of malfunction. I'm not sure whether this is due to DPLL_USB supply glitch or HS_USB1 analog supply glitch.

In any case, the DPLL_USB (clock driver?) needs to enable the 1.8V regulator in addition to the HS_USB PHY driver to prevent this supply glitch.

Tero, any suggestions about this? If we are not concerned about disabling DPLL_USB anytime then the regulator might just as well be always-on. Alternatively can we place a regulator_get(), regulator_enable() in drivers/clk/ti/dpll.c?

cheers,
-roger
---

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 4adc280..23379ab 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -495,3 +495,11 @@
 		};
 	};
 };
+
+&usb2_phy1 {
+	vdda3v3-supply = <&ldousb_reg>;
+};
+
+&usb3_phy1 {
+	vdda1v8-supply = <&ldo3_reg>;
+};
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7007c11..bb1a768 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -30,6 +30,7 @@
 #include <linux/phy/omap_control_phy.h>
 #include <linux/phy/phy.h>
 #include <linux/of_platform.h>
+#include <linux/regulator/consumer.h>
 
 #define USB2PHY_DISCON_BYP_LATCH (1 << 31)
 #define USB2PHY_ANA_CONFIG1 0x4c
@@ -107,6 +108,18 @@ static int omap_usb_power_off(struct phy *x)
 
 	omap_control_phy_power(phy->control_dev, 0);
 
+	if (phy->pwr) {
+		int ret;
+
+		ret = regulator_disable(phy->pwr);
+		if (ret) {
+			dev_err(phy->dev, "failed to disable regulator\n");
+			return ret;
+		} else {
+			dev_info(phy->dev, "disabled regulator\n");
+		}
+	}
+
 	return 0;
 }
 
@@ -114,6 +127,18 @@ static int omap_usb_power_on(struct phy *x)
 {
 	struct omap_usb *phy = phy_get_drvdata(x);
 
+	if (phy->pwr) {
+		int ret;
+
+		ret = regulator_enable(phy->pwr);
+		if (ret) {
+			dev_err(phy->dev, "failed to enable regulator\n");
+			return ret;
+		} else {
+			dev_info(phy->dev, "enabled regulator\n");
+		}
+	}
+
 	omap_control_phy_power(phy->control_dev, 1);
 
 	return 0;
@@ -253,6 +278,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->control_dev = &control_pdev->dev;
 	omap_control_phy_power(phy->control_dev, 0);
 
+	/* phy-supply */
+	phy->pwr = devm_regulator_get_optional(phy->dev, "vdda3v3");
+	if (IS_ERR(phy->pwr)) {
+		if (PTR_ERR(phy->pwr) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		phy->pwr = NULL;
+	}
+
 	otg->set_host		= omap_usb_set_host;
 	otg->set_peripheral	= omap_usb_set_peripheral;
 	if (phy_data->flags & OMAP_USB2_HAS_SET_VBUS)
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 5913676..1b46b0b 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/phy/omap_control_phy.h>
 #include <linux/of_platform.h>
+#include <linux/regulator/consumer.h>
 
 #define	PLL_STATUS		0x00000004
 #define	PLL_GO			0x00000008
@@ -81,6 +82,7 @@ struct ti_pipe3 {
 	struct clk		*sys_clk;
 	struct clk		*refclk;
 	struct pipe3_dpll_map	*dpll_map;
+	struct regulator	*pwr_dpll;
 };
 
 static struct pipe3_dpll_map dpll_map_usb[] = {
@@ -215,6 +217,17 @@ static int ti_pipe3_init(struct phy *x)
 	u32 val;
 	int ret = 0;
 
+	/* Enable DPLL regulator */
+	if (phy->pwr_dpll) {
+		ret = regulator_enable(phy->pwr_dpll);
+		if (ret) {
+			dev_err(phy->dev, "failed to enable regulator\n");
+			return ret;
+		} else {
+			dev_info(phy->dev, "enabled regulator\n");
+		}
+	}
+
 	/* Bring it out of IDLE if it is IDLE */
 	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
 	if (val & PLL_IDLE) {
@@ -262,6 +275,18 @@ static int ti_pipe3_exit(struct phy *x)
 		return -EBUSY;
 	}
 
+	/* Disable DPLL regulator */
+	if (phy->pwr_dpll) {
+		int ret;
+
+		ret = regulator_disable(phy->pwr_dpll);
+		if (ret) {
+			dev_err(phy->dev, "failed to disable regulator\n");
+			return ret;
+		} else {
+			dev_info(phy->dev, "disabled regulator\n");
+		}
+	}
 	return 0;
 }
 static struct phy_ops ops = {
@@ -308,7 +333,15 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	if (IS_ERR(phy->pll_ctrl_base))
 		return PTR_ERR(phy->pll_ctrl_base);
 
-	phy->dev		= &pdev->dev;
+	phy->dev = &pdev->dev;
+
+	/* dpll-supply */
+	phy->pwr_dpll = devm_regulator_get_optional(phy->dev, "vdda1v8");
+	if (IS_ERR(phy->pwr_dpll)) {
+		if (PTR_ERR(phy->pwr_dpll) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		phy->pwr_dpll = NULL;
+	}
 
 	if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
 
diff --git a/include/linux/phy/omap_usb.h b/include/linux/phy/omap_usb.h
index dc2c541..e2c46df 100644
--- a/include/linux/phy/omap_usb.h
+++ b/include/linux/phy/omap_usb.h
@@ -40,6 +40,7 @@ struct omap_usb {
 	struct clk		*wkupclk;
 	struct clk		*optclk;
 	u8			flags;
+	struct regulator	*pwr;
 };
 
 struct usb_phy_data {


--------------080108030109050304020400
Content-Type: text/x-log; name="boot.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="boot.log"

U-Boot 2014.07-rc3-00068-gd8a97f9 (Jun 18 2014 - 11:40:50)

CPU  : DRA752 ES1.0
Board: DRA7xx
I2C:   ready
DRAM:  1.5 GiB
MMC:   OMAP SD/MMC: 0, OMAP SD/MMC: 1
Card did not respond to voltage select!
MMC init failed
Using default environment

SATA link 0 timeout.
AHCI 0001.0300 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
flags: 64bit ncq stag pm led clo only pmp pio slum part ccc apst 
scanning bus for devices...
Found 0 device(s).
Net:   <ethaddr> not set. Validating first E-fuse MAC
cpsw
Hit any key to stop autoboot:  0 
switch to partitions #0, OK
mmc0 is current device
SD/MMC found on device 0
reading uEnv.txt
805 bytes read in 6 ms (130.9 KiB/s)
Loaded environment from
Importing environment from mmc0 ...
Running uenvcmd ...
4486456 bytes read in 262 ms (16.3 MiB/s)
59512 bytes read in 16 ms (3.5 MiB/s)
Kernel image @ 0x82000000 [ 0x000000 - 0x447538 ]
## Flattened Device Tree blob at 88000000
   Booting using the fdt blob at 0x88000000
   Loading Device Tree to 8ffee000, end 8ffff877 ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.16.0-rc2-00004-ge5e2361-dirty (roger@rockdesk) (gcc version 4.7.3 20130226 (prerelease) (crosstool-NG linaro-1.13.1-4.7-2013.03-20130313 - Linaro GCC 2013.03) ) #314 SMP Thu Jun 26 4
[    0.000000] CPU: ARMv7 Processor [412fc0f2] revision 2 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: TI DRA742
[    0.000000] cma: CMA: reserved 16 MiB at ae800000
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] DRA752 ES1.0
[    0.000000] PERCPU: Embedded 9 pages/cpu @edb8f000 s13632 r8192 d15040 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 391440
[    0.000000] Kernel command line: console=ttyO0,115200n8 root=/dev/mmcblk0p2 rw rootwait no_console_suspend
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1524484K/1571840K available (5788K kernel code, 682K rwdata, 2268K rodata, 413K init, 8213K bss, 47356K reserved, 793600K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc07e631c   (8057 kB)
[    0.000000]       .init : 0xc07e7000 - 0xc084e540   ( 414 kB)
[    0.000000]       .data : 0xc0850000 - 0xc08fa990   ( 683 kB)
[    0.000000]        .bss : 0xc08fa990 - 0xc1100060   (8214 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] OMAP clockevent source: timer1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 65536000000000ns
[    0.000000] OMAP clocksource: 32k_counter at 32768 Hz
[    0.000366] Architected cp15 timer(s) running at 6.14MHz (virt).
[    0.000371] sched_clock: 56 bits at 6MHz, resolution 162ns, wraps every 2796202663936ns
[    0.000382] Switching to timer-based delay loop
[    0.001396] Console: colour dummy device 80x30
[    0.001423] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.001434] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.001445] ... MAX_LOCK_DEPTH:          48
[    0.001456] ... MAX_LOCKDEP_KEYS:        8191
[    0.001466] ... CLASSHASH_SIZE:          4096
[    0.001476] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.001486] ... MAX_LOCKDEP_CHAINS:      65536
[    0.001496] ... CHAINHASH_SIZE:          32768
[    0.001506]  memory used by lock dependency info: 5167 kB
[    0.001516]  per task-struct memory footprint: 1152 bytes
[    0.001549] Calibrating delay loop (skipped), value calculated using timer frequency.. 12.28 BogoMIPS (lpj=61440)
[    0.001569] pid_max: default: 32768 minimum: 301
[    0.001892] Security Framework initialized
[    0.002006] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.002021] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.003647] CPU: Testing write buffer coherency: ok
[    0.004403] /cpus/cpu@0 missing clock-frequency property
[    0.004440] /cpus/cpu@1 missing clock-frequency property
[    0.004455] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.004511] Setting up static identity map for 0x8057c270 - 0x8057c2e0
[    0.008435] CPU1: Booted secondary processor
[    0.008472] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.008891] Brought up 2 CPUs
[    0.008910] SMP: Total of 2 processors activated.
[    0.008922] CPU: All CPU(s) started in SVC mode.
[    0.010899] devtmpfs: initialized
[    0.020269] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[    0.020363] omap_hwmod: l3_main_2 using broken dt data from ocp
[    0.110310] omap_hwmod: dss_core: _wait_target_disable failed
[    0.110329] omap_hwmod: dss_core: cannot be enabled for reset (3)
[    0.112891] omap_hwmod: dss_dispc: cannot be enabled for reset (3)
[    0.115442] omap_hwmod: dss_hdmi: cannot be enabled for reset (3)
[    0.183892] pinctrl core: initialized pinctrl subsystem
[    0.185718] regulator-dummy: no parameters
[    0.229451] NET: Registered protocol family 16
[    0.233437] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.237354] omap_l3_noc 44000000.ocp: L3 debug error: target 2 mod:1 (unclearable)
[    0.237409] omap_l3_noc 44000000.ocp: L3 application error: target 2 mod:1 (unclearable)
[    0.241772] OMAP GPIO hardware version 0.1
[    0.256662] platform 4e000000.dmm: Cannot lookup hwmod 'dmm'
[    0.261143] ------------[ cut here ]------------
[    0.261167] WARNING: CPU: 1 PID: 1 at kernel/irq/irqdomain.c:277 irq_domain_associate+0x150/0x1b8()
[    0.261179] error: hwirq 0x177 is too large for GIC
[    0.261190] Modules linked in:
[    0.261210] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc2-00004-ge5e2361-dirty #314
[    0.261242] [<c0014d7c>] (unwind_backtrace) from [<c0011a00>] (show_stack+0x10/0x14)
[    0.261265] [<c0011a00>] (show_stack) from [<c0573eec>] (dump_stack+0x80/0x9c)
[    0.261284] [<c0573eec>] (dump_stack) from [<c00401b8>] (warn_slowpath_common+0x6c/0x90)
[    0.261299] [<c00401b8>] (warn_slowpath_common) from [<c0040270>] (warn_slowpath_fmt+0x30/0x40)
[    0.261316] [<c0040270>] (warn_slowpath_fmt) from [<c0093a38>] (irq_domain_associate+0x150/0x1b8)
[    0.261332] [<c0093a38>] (irq_domain_associate) from [<c0093b0c>] (irq_create_mapping+0x6c/0xfc)
[    0.261348] [<c0093b0c>] (irq_create_mapping) from [<c0093c14>] (irq_create_of_mapping+0x78/0x10c)
[    0.261365] [<c0093c14>] (irq_create_of_mapping) from [<c048d470>] (irq_of_parse_and_map+0x24/0x2c)
[    0.261381] [<c048d470>] (irq_of_parse_and_map) from [<c048d490>] (of_irq_to_resource+0x18/0xac)
[    0.261395] [<c048d490>] (of_irq_to_resource) from [<c048d55c>] (of_irq_to_resource_table+0x38/0x4c)
[    0.261414] [<c048d55c>] (of_irq_to_resource_table) from [<c048b828>] (of_device_alloc+0xd4/0x140)
[    0.261432] [<c048b828>] (of_device_alloc) from [<c048b8e0>] (of_platform_device_create_pdata+0x4c/0x10c)
[    0.261451] [<c048b8e0>] (of_platform_device_create_pdata) from [<c048ba80>] (of_platform_bus_create+0xe0/0x164)
[    0.261468] [<c048ba80>] (of_platform_bus_create) from [<c048badc>] (of_platform_bus_create+0x13c/0x164)
[    0.261486] [<c048badc>] (of_platform_bus_create) from [<c048bb60>] (of_platform_populate+0x5c/0x9c)
[    0.261505] [<c048bb60>] (of_platform_populate) from [<c07f91bc>] (pdata_quirks_init+0x34/0x44)
[    0.261522] [<c07f91bc>] (pdata_quirks_init) from [<c07f8e64>] (omap_generic_init+0x10/0x1c)
[    0.261538] [<c07f8e64>] (omap_generic_init) from [<c07ea500>] (customize_machine+0x1c/0x40)
[    0.261554] [<c07ea500>] (customize_machine) from [<c0008984>] (do_one_initcall+0x80/0x1c0)
[    0.261570] [<c0008984>] (do_one_initcall) from [<c07e7cb0>] (kernel_init_freeable+0xfc/0x1cc)
[    0.261585] [<c07e7cb0>] (kernel_init_freeable) from [<c056e9ac>] (kernel_init+0x8/0xec)
[    0.261601] [<c056e9ac>] (kernel_init) from [<c000e788>] (ret_from_fork+0x14/0x2c)
[    0.261659] ---[ end trace 1536df6d8ccf88e1 ]---
[    0.265579] omap-gpmc 50000000.gpmc: could not find pctldev for node /ocp/pinmux@4a003400/nand_flash_x16, deferring probe
[    0.265606] platform 50000000.gpmc: Driver omap-gpmc requests probe deferral
[    0.266437] No ATAGs?
[    0.266496] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    0.266521] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.268614] OMAP DMA hardware revision 0.0
[    0.313363] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM dummy slot
[    0.313408] edma-dma-engine: probe of edma-dma-engine.0 failed with error -5
[    0.340055] omap-dma-engine 4a056000.dma-controller: OMAP DMA engine driver
[    0.341013] mmc2_3v3: 3300 mV 
[    0.343871] SCSI subsystem initialized
[    0.347063] usbcore: registered new interface driver usbfs
[    0.347198] usbcore: registered new interface driver hub
[    0.347460] usbcore: registered new device driver usb
[    0.348182] omap_i2c 48070000.i2c: could not find pctldev for node /ocp/pinmux@4a003400/pinmux_i2c1_pins, deferring probe
[    0.348209] platform 48070000.i2c: Driver omap_i2c requests probe deferral
[    0.348262] omap_i2c 48072000.i2c: could not find pctldev for node /ocp/pinmux@4a003400/pinmux_i2c2_pins, deferring probe
[    0.348285] platform 48072000.i2c: Driver omap_i2c requests probe deferral
[    0.348336] omap_i2c 48060000.i2c: could not find pctldev for node /ocp/pinmux@4a003400/pinmux_i2c3_pins, deferring probe
[    0.348359] platform 48060000.i2c: Driver omap_i2c requests probe deferral
[    0.348543] pps_core: LinuxPPS API ver. 1 registered
[    0.348555] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.348608] PTP clock support registered
[    0.351407] Switched to clocksource arch_sys_counter
[    0.452979] NET: Registered protocol family 2
[    0.454225] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.454421] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.456738] TCP: Hash tables configured (established 8192 bind 8192)
[    0.456840] TCP: reno registered
[    0.456879] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.457192] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.458143] NET: Registered protocol family 1
[    0.458904] RPC: Registered named UNIX socket transport module.
[    0.458933] RPC: Registered udp transport module.
[    0.458946] RPC: Registered tcp transport module.
[    0.458959] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.463640] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.466547] VFS: Disk quotas dquot_6.5.2
[    0.466645] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.468127] NFS: Registering the id_resolver key type
[    0.468334] Key type id_resolver registered
[    0.468361] Key type id_legacy registered
[    0.468451] jffs2: version 2.2. (NAND) (SUMMARY)  �© 2001-2006 Red Hat, Inc.
[    0.468878] msgmni has been set to 1459
[    0.470645] bounce: pool size: 64 pages
[    0.470695] io scheduler noop registered
[    0.470714] io scheduler deadline registered
[    0.470788] io scheduler cfq registered (default)
[    0.473600] platform 4a084000.phy: Driver omap-usb2 requests probe deferral
[    0.475444] platform 4a084400.phy: Driver ti-pipe3 requests probe deferral
[    0.476200] pinctrl-single 4a003400.pinmux: 281 pins at pa fc003400 size 1124
[    0.478832] pbias_mmc_omap5: 1800 <--> 3000 mV at 3000 mV 
[    0.481843] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.486403] omap_uart 4806a000.serial: no wakeirq for uart0
[    0.486704] 4806a000.serial: ttyO0 at MMIO 0x4806a000 (irq = 104, base_baud = 3000000) is a OMAP UART0
[    1.529459] console [ttyO0] enabled
[    1.534260] omap_uart 4806c000.serial: no wakeirq for uart0
[    1.540316] 4806c000.serial: ttyO1 at MMIO 0x4806c000 (irq = 105, base_baud = 3000000) is a OMAP UART1
[    1.551188] omap_uart 48020000.serial: no wakeirq for uart0
[    1.557230] 48020000.serial: ttyO2 at MMIO 0x48020000 (irq = 106, base_baud = 3000000) is a OMAP UART2
[    1.583669] brd: module loaded
[    1.596226] loop: module loaded
[    1.601789] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.613120] usbcore: registered new interface driver asix
[    1.618878] usbcore: registered new interface driver ax88179_178a
[    1.625395] usbcore: registered new interface driver cdc_ether
[    1.631659] usbcore: registered new interface driver smsc95xx
[    1.637771] usbcore: registered new interface driver net1080
[    1.643814] usbcore: registered new interface driver cdc_subset
[    1.650104] usbcore: registered new interface driver zaurus
[    1.656100] usbcore: registered new interface driver cdc_ncm
[    1.662587] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.669428] ehci-omap: OMAP-EHCI Host Controller driver
[    1.675257] usbcore: registered new interface driver cdc_wdm
[    1.681341] usbcore: registered new interface driver usb-storage
[    1.688961] mousedev: PS/2 mouse device common for all mice
[    1.697124] i2c /dev entries driver
[    1.700834] Driver for 1-wire Dallas network protocol.
[    1.708330] omap_hsmmc 4809c000.mmc: unable to get vmmc regulator -517
[    1.715371] platform 4809c000.mmc: Driver omap_hsmmc requests probe deferral
[    1.723422] omap_hsmmc 480b4000.mmc: pins are not configured from the driver
[    1.761861] ledtrig-cpu: registered to indicate activity on CPUs
[    1.768782] usbcore: registered new interface driver usbhid
[    1.774722] usbhid: USB HID core driver
[    1.779898] oprofile: no performance counters
[    1.785133] oprofile: using timer interrupt.
[    1.790029] TCP: cubic registered
[    1.793589] Initializing XFRM netlink socket
[    1.798155] NET: Registered protocol family 17
[    1.802911] NET: Registered protocol family 15
[    1.807739] Key type dns_resolver registered
[    1.812363] omap_voltage_late_init: Voltage driver support not added
[    1.819597] ThumbEE CPU extension supported.
[    1.824110] Registering SWP/SWPB emulation handler
[    1.831610] omap-gpmc 50000000.gpmc: GPMC revision 6.0
[    1.837074] gpmc_mem_init: disabling cs 0 mapped at 0x0-0x10000000
[    1.844734] nand: No NAND device found
[    1.848675] nand device scan failed, may be bus-width mismatch
[    1.858887] palmas 0-0058: IRQ missing: skipping irq request
[    1.865780] palmas 0-0058: Muxing GPIO 2e, PWM 0, LED 0
[    1.874692] smps123: 850 <--> 1250 mV at 1060 mV 
[    1.881926] smps45: 850 <--> 1150 mV at 1060 mV 
[    1.888930] smps6: 850 <--> 1650 mV at 1060 mV 
[    1.895664] smps7: 850 <--> 1030 mV at 1030 mV 
[    1.902748] smps8: 850 <--> 1250 mV at 1060 mV 
[    1.909475] smps9: 1800 mV 
[    1.914302] ldo1: 1800 <--> 3300 mV at 3000 mV 
[    1.921215] ldo2: 3300 mV 
[    1.926220] ldo3: 1800 mV 
[    1.930338] LDO4: at 1800 mV 
[    1.934495] LDO5: no parameters
[    1.938753] LDO6: no parameters
[    1.943050] LDO7: no parameters
[    1.947282] LDO8: no parameters
[    1.952530] ldo9: 1050 mV 
[    1.957511] ldoln: 1800 mV 
[    1.962569] ldousb: 3300 mV 
[    1.966598] REGEN1: no parameters
[    1.970470] REGEN2: no parameters
[    1.974461] REGEN3: no parameters
[    1.978330] SYSEN1: no parameters
[    1.982263] SYSEN2: no parameters
[    1.985980] omap_i2c 48070000.i2c: bus 0 rev0.12 at 400 kHz
[    1.993257] omap_i2c 48072000.i2c: bus 1 rev0.12 at 400 kHz
[    2.000159] omap_i2c 48060000.i2c: bus 2 rev0.12 at 3400 kHz
[    2.011089] omap_hsmmc 4809c000.mmc: pins are not configured from the driver
[    2.052610] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    2.097991] ldousb: disabling
[    2.101782] ldo9: disabling
[    2.105499] ldo3: disabling
[    2.109110] ldo2: disabling
[    2.116071] mmc2_3v3: disabling
[    2.121479] Waiting for root device /dev/mmcblk0p2...
[    2.193400] mmc1: host does not support reading read-only switch. assuming write-enable.
[    2.205541] mmc1: new high speed SD card at address e624
[    2.212654] mmcblk0: mmc1:e624 SU02G 1.84 GiB 
[    2.221583]  mmcblk0: p1 p2
[    2.232849] EXT3-fs (mmcblk0p2): error: couldn't mount because of unsupported optional features (240)
[    2.243777] EXT2-fs (mmcblk0p2): error: couldn't mount because of unsupported optional features (240)
[    2.274866] EXT4-fs (mmcblk0p2): warning: mounting fs with errors, running e2fsck is recommended
[    2.292951] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    2.301521] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    2.317827] devtmpfs: mounted
[    2.321292] Freeing unused kernel memory: 412K (c07e7000 - c084e000)
INIT: version 2.88 booting
[info] Using makefile-style concurrent boot in runlevel S.
[....] Starting the hotplug events dispatcher: udevd[    3.492137] udevd[916]: starting version 175
. ok 
[....] Synthesizing the initial hotplug events...done.
[....] Waiting for /dev to be fully populated...[    4.537456] ti-pipe3 4a084400.phy: enabled regulator
[    4.744070] omap-usb2 4a084000.phy: enabled regulator
[    5.049426] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    5.057375] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 1
[    5.066526] xhci-hcd xhci-hcd.0.auto: irq 110, io mem 0x488d0000
[    5.074147] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.081305] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.088897] usb usb1: Product: xHCI Host Controller
[    5.094030] usb usb1: Manufacturer: Linux 3.16.0-rc2-00004-ge5e2361-dirty xhci-hcd
[    5.101966] usb usb1: SerialNumber: xhci-hcd.0.auto
[    5.111032] hub 1-0:1.0: USB hub found
[    5.115489] hub 1-0:1.0: 1 port detected
[    5.122317] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    5.128991] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 2
[    5.137507] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    5.144660] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.152252] usb usb2: Product: xHCI Host Controller
[    5.157351] usb usb2: Manufacturer: Linux 3.16.0-rc2-00004-ge5e2361-dirty xhci-hcd
[    5.165289] usb usb2: SerialNumber: xhci-hcd.0.auto
[    5.172385] hub 2-0:1.0: USB hub found
[    5.176374] hub 2-0:1.0: 1 port detected
done.
[....] Setting parameters of disc: (none). ok 
[....] Activating swap...done.
[    6.146184] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[....] Cleaning up temporary files... /tmp. ok 
[    6.450302] random: nonblocking pool is initialized
[....] Activating lvm and md swap...done.
[....] Checking file systems...fsck from util-linux 2.20.1
done.
[....] Mounting local filesystems...done.
[....] Activating swapfile swap...done.
[....] Cleaning up temporary files.... ok 
[....] Cleaning up temporary files.... ok 
[....] Setting up ALSA...done (none loaded).
[....] Setting kernel variables ...done.
INIT: Entering runlevel: 2
[info] Using makefile-style concurrent boot in runlevel 2.

Debian GNU/Linux 7.0 rockdesk ttyO0

rockdesk login: 


--------------080108030109050304020400--
