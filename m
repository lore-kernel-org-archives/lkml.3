Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaFKLpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:45:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33848 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKLpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:45:41 -0400
Message-ID: <5398413F.4070606@ti.com>
Date: Wed, 11 Jun 2014 14:45:03 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [resend][PATCH 35/36] ARM: OMAP2+: gpmc: move GPMC driver into drivers/memory
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <1402477001-31132-36-git-send-email-rogerq@ti.com>
In-Reply-To: <1402477001-31132-36-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with rename detection option to git-format-patch
for easier review.

From: Roger Quadros <rogerq@ti.com>

Move the GPMC driver out of mach-omap2. We leave behind only
the mach-omap2 specific bits in mach-omap2/gpmc_legacy.c
i.e. gpmc_generic_init() for use by board files to register
the GPMC configuration and omap3_gpmc_save/restore_context() for
use by OMAP3 OFF mode support.

The GPMC driver is now enabled by its own kernel config option
TI_GPMC. The other drivers that need GPMC to work i.e. MTD_ONENAND_OMAP2
and MTD_NAND_OMAP2 are made to depend on TI_GPMC.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/Makefile                       |   2 +-
 arch/arm/mach-omap2/gpmc_legacy.c                  | 296 ++++++++++++++++
 drivers/memory/Kconfig                             |  10 +
 drivers/memory/Makefile                            |   1 +
 .../mach-omap2/gpmc.c => drivers/memory/ti-gpmc.c  | 388 +++++++--------------
 drivers/mtd/nand/Kconfig                           |   2 +-
 drivers/mtd/onenand/Kconfig                        |   6 +-
 7 files changed, 447 insertions(+), 258 deletions(-)
 create mode 100644 arch/arm/mach-omap2/gpmc_legacy.c
 rename arch/arm/mach-omap2/gpmc.c => drivers/memory/ti-gpmc.c (90%)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 8421f38..a2e7426 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -6,7 +6,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include \
 	-I$(srctree)/arch/arm/plat-omap/include
 
 # Common support
-obj-y := id.o io.o control.o mux.o devices.o fb.o serial.o gpmc.o timer.o pm.o \
+obj-y := id.o io.o control.o mux.o devices.o fb.o serial.o gpmc_legacy.o timer.o pm.o \
 	 common.o gpio.o dma.o wd_timer.o display.o i2c.o hdq1w.o omap_hwmod.o \
 	 omap_device.o sram.o drm.o
 
diff --git a/arch/arm/mach-omap2/gpmc_legacy.c b/arch/arm/mach-omap2/gpmc_legacy.c
new file mode 100644
index 0000000..3b3f86e
--- /dev/null
+++ b/arch/arm/mach-omap2/gpmc_legacy.c
@@ -0,0 +1,296 @@
+/*
+ * GPMC support functions
+ *
+ * Copyright (C) 2005-2006 Nokia Corporation
+ *
+ * Author: Juha Yrjola
+ *
+ * Copyright (C) 2009 Texas Instruments
+ * Added OMAP4 support - Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include "soc.h"
+#include "gpmc.h"
+#include "omap_device.h"
+
+#define	DEVICE_NAME		"omap-gpmc"
+
+/* CS CONFIG registers */
+#define GPMC_CS_CONFIG1		0x00
+#define GPMC_CS_CONFIG2		0x04
+#define GPMC_CS_CONFIG3		0x08
+#define GPMC_CS_CONFIG4		0x0c
+#define GPMC_CS_CONFIG5		0x10
+#define GPMC_CS_CONFIG6		0x14
+#define GPMC_CS_CONFIG7		0x18
+
+#define GPMC_CS0_OFFSET		0x60
+#define GPMC_CS_SIZE		0x30
+
+/* GPMC register offsets */
+#define GPMC_SYSCONFIG		0x10
+#define GPMC_IRQENABLE		0x1c
+#define GPMC_TIMEOUT_CONTROL	0x40
+#define GPMC_CONFIG		0x50
+#define GPMC_PREFETCH_CONFIG1	0x1e0
+#define GPMC_PREFETCH_CONFIG2	0x1e4
+#define GPMC_PREFETCH_CONTROL	0x1ec
+
+#define GPMC_CONFIG7_CSVALID		(1 << 6)
+
+static struct gpmc_omap_platform_data gpmc_pdata;
+
+/* Structure to save gpmc cs context */
+struct gpmc_cs_config {
+	u32 config1;
+	u32 config2;
+	u32 config3;
+	u32 config4;
+	u32 config5;
+	u32 config6;
+	u32 config7;
+	int is_valid;
+};
+
+/*
+ * Structure to save/restore gpmc context
+ * to support core off on OMAP3
+ */
+struct omap3_gpmc_regs {
+	u32 sysconfig;
+	u32 irqenable;
+	u32 timeout_ctrl;
+	u32 config;
+	u32 prefetch_config1;
+	u32 prefetch_config2;
+	u32 prefetch_control;
+	struct gpmc_cs_config cs_context[GPMC_CS_NUM];
+};
+
+static int __init omap_gpmc_init(void)
+{
+	struct omap_hwmod *oh;
+	struct platform_device *pdev;
+	char *oh_name = "gpmc";
+
+	/*
+	 * if the board boots up with a populated DT, do not
+	 * manually add the device from this initcall
+	 */
+	if (of_have_populated_dt())
+		return -ENODEV;
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh) {
+		pr_err("Could not look up %s\n", oh_name);
+		return -ENODEV;
+	}
+
+	pdev = omap_device_build(DEVICE_NAME, -1, oh, (void *)&gpmc_pdata,
+				 sizeof(gpmc_pdata));
+	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
+
+	return PTR_RET(pdev);
+}
+/* must run after machine_init code. i.e. arch_init */
+omap_subsys_initcall(omap_gpmc_init);
+
+/**
+ * gpmc_generic_init - Initialize platform data for a Chip Select
+ *
+ * @cs		chip select number
+ * @type	GPMC_OMAP_TYPE
+ * @settings	GPMC settings
+ * @device_timings	device timings for device on this CS
+ * @gpmc_timings	GPMC timings
+ * @pdev	platform device for the device on this CS
+ * @pdata_size	platform data size for the platform device
+ */
+int gpmc_generic_init(int cs, bool is_nand,
+		      struct gpmc_settings *settings,
+		      struct gpmc_device_timings *device_timings,
+		      struct gpmc_timings *gpmc_timings,
+		      struct platform_device *pdev, unsigned pdata_size)
+{
+	struct gpmc_settings *gpmc_s = NULL;
+	struct gpmc_device_timings *gpmc_dev_t = NULL;
+	struct gpmc_timings *gpmc_t;
+
+	if (cs >= GPMC_CS_NUM) {
+		pr_err("%s: Invalid cs specified. Max CS = %d\n",
+		       __func__, GPMC_CS_NUM);
+		return -EINVAL;
+	}
+
+	if (gpmc_pdata.cs[cs].valid) {
+		pr_err("%s: cs %d already requested, ignoring new request\n",
+		       __func__, cs);
+		return -EINVAL;
+	}
+
+	if (settings) {
+		gpmc_s = kmemdup(settings, sizeof(*settings), GFP_KERNEL);
+		if (!gpmc_s)
+			return -ENOMEM;
+
+		gpmc_pdata.cs[cs].settings = gpmc_s;
+	}
+
+	if (device_timings) {
+		gpmc_dev_t = kmemdup(device_timings, sizeof(*device_timings),
+				     GFP_KERNEL);
+		if (!gpmc_dev_t)
+			goto dev_t_fail;
+
+		gpmc_pdata.cs[cs].device_timings = gpmc_dev_t;
+	}
+
+	if (gpmc_timings) {
+		gpmc_t = kmemdup(gpmc_timings, sizeof(*gpmc_timings),
+				 GFP_KERNEL);
+		if (!gpmc_t)
+			goto gpmc_t_fail;
+
+		gpmc_pdata.cs[cs].gpmc_timings = gpmc_t;
+	}
+
+	gpmc_pdata.cs[cs].is_nand = is_nand;
+	gpmc_pdata.cs[cs].pdev = pdev;
+	gpmc_pdata.cs[cs].pdata_size = pdata_size;
+	gpmc_pdata.cs[cs].valid = true;
+
+	return 0;
+
+gpmc_t_fail:
+	if (device_timings)
+		kfree(gpmc_dev_t);
+dev_t_fail:
+	if (settings)
+		kfree(gpmc_s);
+
+	return -ENOMEM;
+}
+
+
+static struct omap3_gpmc_regs gpmc_context;
+
+/*
+ * Below code only for OMAP3 OFF mode support.
+ * This code must be left back in mach-omap2.
+ */
+void __iomem *omap2_gpmc_base;
+
+void __init omap2_set_globals_gpmc(void __iomem *gpmc)
+{
+	omap2_gpmc_base = gpmc;
+}
+
+static u32 _gpmc_read_reg(u16 reg)
+{
+	return __raw_readl(omap2_gpmc_base + reg);
+}
+
+static void _gpmc_write_reg(u32 val, u16 reg)
+{
+	__raw_readl(omap2_gpmc_base + reg);
+}
+
+static u32 _gpmc_cs_read_reg(int cs, int idx)
+{
+	u16 reg;
+
+	reg = GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+
+	return _gpmc_read_reg(reg);
+}
+
+static void _gpmc_cs_write_reg(int cs, int idx, u32 val)
+{
+	u16 reg;
+
+	reg = GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	_gpmc_write_reg(val, reg);
+}
+
+void omap3_gpmc_save_context(void)
+{
+	int i;
+	u32 val;
+
+	if (!omap2_gpmc_base)
+		return;
+
+	gpmc_context.sysconfig = _gpmc_read_reg(GPMC_SYSCONFIG);
+	gpmc_context.irqenable = _gpmc_read_reg(GPMC_IRQENABLE);
+	gpmc_context.timeout_ctrl = _gpmc_read_reg(GPMC_TIMEOUT_CONTROL);
+	gpmc_context.config = _gpmc_read_reg(GPMC_CONFIG);
+	gpmc_context.prefetch_config1 = _gpmc_read_reg(GPMC_PREFETCH_CONFIG1);
+	gpmc_context.prefetch_config2 = _gpmc_read_reg(GPMC_PREFETCH_CONFIG2);
+	gpmc_context.prefetch_control = _gpmc_read_reg(GPMC_PREFETCH_CONTROL);
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		/* check if valid */
+		val = _gpmc_cs_read_reg(i, GPMC_CS_CONFIG7);
+		gpmc_context.cs_context[i].is_valid =
+						val & GPMC_CONFIG7_CSVALID;
+
+		if (gpmc_context.cs_context[i].is_valid) {
+			gpmc_context.cs_context[i].config1 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG1);
+			gpmc_context.cs_context[i].config2 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG2);
+			gpmc_context.cs_context[i].config3 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG3);
+			gpmc_context.cs_context[i].config4 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG4);
+			gpmc_context.cs_context[i].config5 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG5);
+			gpmc_context.cs_context[i].config6 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG6);
+			gpmc_context.cs_context[i].config7 =
+				_gpmc_cs_read_reg(i, GPMC_CS_CONFIG7);
+		}
+	}
+}
+
+void omap3_gpmc_restore_context(void)
+{
+	int i;
+
+	if (!omap2_gpmc_base)
+		return;
+
+	_gpmc_write_reg(GPMC_SYSCONFIG, gpmc_context.sysconfig);
+	_gpmc_write_reg(GPMC_IRQENABLE, gpmc_context.irqenable);
+	_gpmc_write_reg(GPMC_TIMEOUT_CONTROL, gpmc_context.timeout_ctrl);
+	_gpmc_write_reg(GPMC_CONFIG, gpmc_context.config);
+	_gpmc_write_reg(GPMC_PREFETCH_CONFIG1, gpmc_context.prefetch_config1);
+	_gpmc_write_reg(GPMC_PREFETCH_CONFIG2, gpmc_context.prefetch_config2);
+	_gpmc_write_reg(GPMC_PREFETCH_CONTROL, gpmc_context.prefetch_control);
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		if (gpmc_context.cs_context[i].is_valid) {
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG1,
+					   gpmc_context.cs_context[i].config1);
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG2,
+					   gpmc_context.cs_context[i].config2);
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG3,
+					   gpmc_context.cs_context[i].config3);
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG4,
+					   gpmc_context.cs_context[i].config4);
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG5,
+					   gpmc_context.cs_context[i].config5);
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG6,
+					   gpmc_context.cs_context[i].config6);
+			_gpmc_cs_write_reg(i, GPMC_CS_CONFIG7,
+					   gpmc_context.cs_context[i].config7);
+		}
+	}
+}
diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index c59e9c9..ce611b0 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -31,6 +31,16 @@ config TI_EMIF
 	  parameters and other settings during frequency, voltage and
 	  temperature changes
 
+config TI_GPMC
+	bool "Texas Instruments GPMC driver"
+	depends on ARCH_OMAP2PLUS
+	default y
+	help
+	 This driver is for the General Purpose Memory Controller (GPMC)
+	 present on Texas Instruments SoCs (e.g. OMAP2+). GPMC allows
+	 interfacing to a variety of asynchronous as well as synchronous
+	 memory drives like NOR, NAND, OneNAND, SRAM.
+
 config MVEBU_DEVBUS
 	bool "Marvell EBU Device Bus Controller"
 	default y
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 71160a2..329b7b6 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_OF)		+= of_memory.o
 endif
 obj-$(CONFIG_TI_AEMIF)		+= ti-aemif.o
 obj-$(CONFIG_TI_EMIF)		+= emif.o
+obj-$(CONFIG_TI_GPMC)		+= ti-gpmc.o
 obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
diff --git a/arch/arm/mach-omap2/gpmc.c b/drivers/memory/ti-gpmc.c
similarity index 90%
rename from arch/arm/mach-omap2/gpmc.c
rename to drivers/memory/ti-gpmc.c
index 9173f71..3bb2fd6 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/drivers/memory/ti-gpmc.c
@@ -33,13 +33,7 @@
 #include <linux/slab.h>
 
 #include <linux/platform_data/mtd-nand-omap2.h>
-
-#include <asm/mach-types.h>
-
-#include "soc.h"
-#include "common.h"
-#include "omap_device.h"
-#include "gpmc.h"
+#include <linux/platform_data/gpmc-omap.h>
 
 #define	DEVICE_NAME		"omap-gpmc"
 
@@ -154,35 +148,6 @@
 
 #define GPMC_NR_WAITPINS		4
 
-static struct gpmc_omap_platform_data gpmc_pdata;
-
-/* Structure to save gpmc cs context */
-struct gpmc_cs_config {
-	u32 config1;
-	u32 config2;
-	u32 config3;
-	u32 config4;
-	u32 config5;
-	u32 config6;
-	u32 config7;
-	int is_valid;
-};
-
-/*
- * Structure to save/restore gpmc context
- * to support core off on OMAP3
- */
-struct omap3_gpmc_regs {
-	u32 sysconfig;
-	u32 irqenable;
-	u32 timeout_ctrl;
-	u32 config;
-	u32 prefetch_config1;
-	u32 prefetch_config2;
-	u32 prefetch_control;
-	struct gpmc_cs_config cs_context[GPMC_CS_NUM];
-};
-
 static struct resource	gpmc_mem_root;
 static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
 static DEFINE_SPINLOCK(gpmc_mem_lock);
@@ -230,7 +195,7 @@ static unsigned long gpmc_get_fclk_period(void)
 	unsigned long rate = clk_get_rate(gpmc_l3_clk);
 
 	if (rate == 0) {
-		printk(KERN_WARNING "gpmc_l3_clk not enabled\n");
+		pr_warn("%s: gpmc_l3_clk not enabled\n", __func__);
 		return 0;
 	}
 
@@ -323,8 +288,8 @@ static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 	nr_bits = end_bit - st_bit + 1;
 	if (ticks >= 1 << nr_bits) {
 #ifdef DEBUG
-		printk(KERN_INFO "GPMC CS%d: %-10s* %3d ns, %3d ticks >= %d\n",
-				cs, name, time, ticks, 1 << nr_bits);
+		pr_info("GPMC CS%d: %-10s* %3d ns, %3d ticks >= %d\n",
+			cs, name, time, ticks, 1 << nr_bits);
 #endif
 		return -1;
 	}
@@ -332,10 +297,9 @@ static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 	mask = (1 << nr_bits) - 1;
 	l = gpmc_cs_read_reg(cs, reg);
 #ifdef DEBUG
-	printk(KERN_INFO
-		"GPMC CS%d: %-10s: %3d ticks, %3lu ns (was %3i ticks) %3d ns\n",
-	       cs, name, ticks, gpmc_get_fclk_period() * ticks / 1000,
-			(l >> st_bit) & mask, time);
+	pr_info("GPMC CS%d: %-10s: %3d ticks, %3lu ns (was %3i ticks) %3d ns\n",
+		cs, name, ticks, gpmc_get_fclk_period() * ticks / 1000,
+		(l >> st_bit) & mask, time);
 #endif
 	l &= ~(mask << st_bit);
 	l |= ticks << st_bit;
@@ -346,13 +310,11 @@ static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 
 #ifdef DEBUG
 #define GPMC_SET_ONE(reg, st, end, field) \
-	if (set_gpmc_timing_reg(cs, (reg), (st), (end),		\
-			t->field, #field) < 0)			\
-		return -1
+	set_gpmc_timing_reg(cs, (reg), (st), (end),		\
+			t->field, #field)
 #else
 #define GPMC_SET_ONE(reg, st, end, field) \
-	if (set_gpmc_timing_reg(cs, (reg), (st), (end), t->field) < 0) \
-		return -1
+	set_gpmc_timing_reg(cs, (reg), (st), (end), t->field)
 #endif
 
 static int gpmc_calc_divider(unsigned int sync_clk)
@@ -415,8 +377,8 @@ static int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t)
 	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
 	if (l & (GPMC_CONFIG1_READTYPE_SYNC | GPMC_CONFIG1_WRITETYPE_SYNC)) {
 #ifdef DEBUG
-		printk(KERN_INFO "GPMC CS%d CLK period is %lu ns (div %d)\n",
-				cs, (div * gpmc_get_fclk_period()) / 1000, div);
+		pr_info("GPMC CS%d CLK period is %lu ns (div %d)\n",
+			cs, (div * gpmc_get_fclk_period()) / 1000, div);
 #endif
 		l &= ~0x03;
 		l |= (div - 1);
@@ -557,7 +519,7 @@ static int gpmc_cs_remap(int cs, u32 base)
 	 * Make sure we ignore any device offsets from the GPMC partition
 	 * allocated for the chip select and that the new base confirms
 	 * to the GPMC 16MB minimum granularity.
-	 */ 
+	 */
 	base &= ~(SZ_16M - 1);
 
 	gpmc_cs_get_memconf(cs, &old_base, &size);
@@ -622,7 +584,7 @@ static void gpmc_cs_free(int cs)
 
 	spin_lock(&gpmc_mem_lock);
 	if (cs >= gpmc_cs_num || cs < 0 || !gpmc_cs_reserved(cs)) {
-		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
+		pr_err("Trying to free non-reserved GPMC CS%d\n", cs);
 		BUG();
 		spin_unlock(&gpmc_mem_lock);
 		return;
@@ -643,7 +605,6 @@ static void gpmc_mem_exit(void)
 			continue;
 		gpmc_cs_delete_mem(cs);
 	}
-
 }
 
 static void gpmc_mem_init(void)
@@ -709,7 +670,7 @@ static int gpmc_calc_sync_read_timings(struct gpmc_timings *gpmc_t,
 	if (mux) {
 		temp = max_t(u32, temp,	gpmc_t->clk_activation + dev_t->t_ach);
 		temp = max_t(u32, temp, gpmc_t->adv_rd_off +
-				gpmc_ticks_to_ps(dev_t->cyc_aavdh_oe));
+			     gpmc_ticks_to_ps(dev_t->cyc_aavdh_oe));
 	}
 	gpmc_t->oe_on = gpmc_round_ps_to_ticks(temp);
 
@@ -722,7 +683,7 @@ static int gpmc_calc_sync_read_timings(struct gpmc_timings *gpmc_t,
 	temp += gpmc_t->clk_activation;
 	if (dev_t->cyc_oe)
 		temp = max_t(u32, temp, gpmc_t->oe_on +
-				gpmc_ticks_to_ps(dev_t->cyc_oe));
+			     gpmc_ticks_to_ps(dev_t->cyc_oe));
 	gpmc_t->access = gpmc_round_ps_to_ticks(temp);
 
 	gpmc_t->oe_off = gpmc_t->access + gpmc_ticks_to_ps(1);
@@ -731,7 +692,7 @@ static int gpmc_calc_sync_read_timings(struct gpmc_timings *gpmc_t,
 	/* rd_cycle */
 	temp = max_t(u32, dev_t->t_cez_r, dev_t->t_oez);
 	temp = gpmc_round_ps_to_sync_clk(temp, gpmc_t->sync_clk) +
-							gpmc_t->access;
+					 gpmc_t->access;
 	/* XXX: barter t_ce_rdyz with t_cez_r ? */
 	if (dev_t->t_ce_rdyz)
 		temp = max_t(u32, temp,	gpmc_t->cs_rd_off + dev_t->t_ce_rdyz);
@@ -750,22 +711,22 @@ static int gpmc_calc_sync_write_timings(struct gpmc_timings *gpmc_t,
 	temp = dev_t->t_avdp_w;
 	if (mux) {
 		temp = max_t(u32, temp,
-			gpmc_t->clk_activation + dev_t->t_avdh);
+			     gpmc_t->clk_activation + dev_t->t_avdh);
 		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
 	}
 	gpmc_t->adv_wr_off = gpmc_round_ps_to_ticks(temp);
 
 	/* wr_data_mux_bus */
 	temp = max_t(u32, dev_t->t_weasu,
-			gpmc_t->clk_activation + dev_t->t_rdyo);
+		     gpmc_t->clk_activation + dev_t->t_rdyo);
 	/* XXX: shouldn't mux be kept as a whole for wr_data_mux_bus ?,
 	 * and in that case remember to handle we_on properly
 	 */
 	if (mux) {
 		temp = max_t(u32, temp,
-			gpmc_t->adv_wr_off + dev_t->t_aavdh);
+			     gpmc_t->adv_wr_off + dev_t->t_aavdh);
 		temp = max_t(u32, temp, gpmc_t->adv_wr_off +
-				gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
+			     gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
 	}
 	gpmc_t->wr_data_mux_bus = gpmc_round_ps_to_ticks(temp);
 
@@ -782,13 +743,13 @@ static int gpmc_calc_sync_write_timings(struct gpmc_timings *gpmc_t,
 	/* we_off */
 	temp = gpmc_t->we_on + dev_t->t_wpl;
 	temp = max_t(u32, temp,
-			gpmc_t->wr_access + gpmc_ticks_to_ps(1));
+		     gpmc_t->wr_access + gpmc_ticks_to_ps(1));
 	temp = max_t(u32, temp,
-		gpmc_t->we_on + gpmc_ticks_to_ps(dev_t->cyc_wpl));
+		     gpmc_t->we_on + gpmc_ticks_to_ps(dev_t->cyc_wpl));
 	gpmc_t->we_off = gpmc_round_ps_to_ticks(temp);
 
 	gpmc_t->cs_wr_off = gpmc_round_ps_to_ticks(gpmc_t->we_off +
-							dev_t->t_wph);
+						   dev_t->t_wph);
 
 	/* wr_cycle */
 	temp = gpmc_round_ps_to_sync_clk(dev_t->t_cez_w, gpmc_t->sync_clk);
@@ -796,7 +757,7 @@ static int gpmc_calc_sync_write_timings(struct gpmc_timings *gpmc_t,
 	/* XXX: barter t_ce_rdyz with t_cez_w ? */
 	if (dev_t->t_ce_rdyz)
 		temp = max_t(u32, temp,
-				 gpmc_t->cs_wr_off + dev_t->t_ce_rdyz);
+			     gpmc_t->cs_wr_off + dev_t->t_ce_rdyz);
 	gpmc_t->wr_cycle = gpmc_round_ps_to_ticks(temp);
 
 	return 0;
@@ -818,16 +779,16 @@ static int gpmc_calc_async_read_timings(struct gpmc_timings *gpmc_t,
 	temp = dev_t->t_oeasu;
 	if (mux)
 		temp = max_t(u32, temp,
-			gpmc_t->adv_rd_off + dev_t->t_aavdh);
+			     gpmc_t->adv_rd_off + dev_t->t_aavdh);
 	gpmc_t->oe_on = gpmc_round_ps_to_ticks(temp);
 
 	/* access */
 	temp = max_t(u32, dev_t->t_iaa, /* XXX: remove t_iaa in async ? */
-				gpmc_t->oe_on + dev_t->t_oe);
+		     gpmc_t->oe_on + dev_t->t_oe);
 	temp = max_t(u32, temp,
-				gpmc_t->cs_on + dev_t->t_ce);
+		     gpmc_t->cs_on + dev_t->t_ce);
 	temp = max_t(u32, temp,
-				gpmc_t->adv_on + dev_t->t_aa);
+		     gpmc_t->adv_on + dev_t->t_aa);
 	gpmc_t->access = gpmc_round_ps_to_ticks(temp);
 
 	gpmc_t->oe_off = gpmc_t->access + gpmc_ticks_to_ps(1);
@@ -835,7 +796,7 @@ static int gpmc_calc_async_read_timings(struct gpmc_timings *gpmc_t,
 
 	/* rd_cycle */
 	temp = max_t(u32, dev_t->t_rd_cycle,
-			gpmc_t->cs_rd_off + dev_t->t_cez_r);
+		     gpmc_t->cs_rd_off + dev_t->t_cez_r);
 	temp = max_t(u32, temp, gpmc_t->oe_off + dev_t->t_oez);
 	gpmc_t->rd_cycle = gpmc_round_ps_to_ticks(temp);
 
@@ -859,7 +820,7 @@ static int gpmc_calc_async_write_timings(struct gpmc_timings *gpmc_t,
 	if (mux) {
 		temp = max_t(u32, temp,	gpmc_t->adv_wr_off + dev_t->t_aavdh);
 		temp = max_t(u32, temp, gpmc_t->adv_wr_off +
-				gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
+			     gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
 	}
 	gpmc_t->wr_data_mux_bus = gpmc_round_ps_to_ticks(temp);
 
@@ -874,27 +835,26 @@ static int gpmc_calc_async_write_timings(struct gpmc_timings *gpmc_t,
 	gpmc_t->we_off = gpmc_round_ps_to_ticks(temp);
 
 	gpmc_t->cs_wr_off = gpmc_round_ps_to_ticks(gpmc_t->we_off +
-							dev_t->t_wph);
+						   dev_t->t_wph);
 
 	/* wr_cycle */
 	temp = max_t(u32, dev_t->t_wr_cycle,
-				gpmc_t->cs_wr_off + dev_t->t_cez_w);
+		     gpmc_t->cs_wr_off + dev_t->t_cez_w);
 	gpmc_t->wr_cycle = gpmc_round_ps_to_ticks(temp);
 
 	return 0;
 }
 
 static int gpmc_calc_sync_common_timings(struct gpmc_timings *gpmc_t,
-			struct gpmc_device_timings *dev_t)
+					 struct gpmc_device_timings *dev_t)
 {
 	u32 temp;
 
 	gpmc_t->sync_clk = gpmc_calc_divider(dev_t->clk) *
-						gpmc_get_fclk_period();
+					     gpmc_get_fclk_period();
 
-	gpmc_t->page_burst_access = gpmc_round_ps_to_sync_clk(
-					dev_t->t_bacc,
-					gpmc_t->sync_clk);
+	gpmc_t->page_burst_access = gpmc_round_ps_to_sync_clk(dev_t->t_bacc,
+							      gpmc_t->sync_clk);
 
 	temp = max_t(u32, dev_t->t_ces, dev_t->t_avds);
 	gpmc_t->clk_activation = gpmc_round_ps_to_ticks(temp);
@@ -927,7 +887,7 @@ static int gpmc_calc_common_timings(struct gpmc_timings *gpmc_t,
 	temp = dev_t->t_avdasu;
 	if (dev_t->t_ce_avd)
 		temp = max_t(u32, temp,
-				gpmc_t->cs_on + dev_t->t_ce_avd);
+			     gpmc_t->cs_on + dev_t->t_ce_avd);
 	gpmc_t->adv_on = gpmc_round_ps_to_ticks(temp);
 
 	if (sync)
@@ -1084,7 +1044,7 @@ static struct of_device_id gpmc_dt_ids[] = {
 	{ .compatible = "ti,omap2420-gpmc" },
 	{ .compatible = "ti,omap2430-gpmc" },
 	{ .compatible = "ti,omap3430-gpmc" },	/* omap3430 & omap3630 */
-	{ .compatible = "ti,omap4430-gpmc" },	/* omap4430 & omap4460 & omap543x */
+	{ .compatible = "ti,omap4430-gpmc" },	/* omap4 & omap543x */
 	{ .compatible = "ti,am3352-gpmc" },	/* am335x devices */
 	{ }
 };
@@ -1205,7 +1165,7 @@ static void __maybe_unused gpmc_read_timings_dt(struct device_node *np,
  * Returns 0 on success and appropriate negative error code on failure.
  */
 static int gpmc_probe_generic_child(struct platform_device *pdev,
-				struct device_node *child)
+				    struct device_node *child)
 {
 	struct gpmc_settings gpmc_s;
 	struct gpmc_timings gpmc_t;
@@ -1341,7 +1301,7 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 		return -EINVAL;
 	} else if (gpmc_cs_num > GPMC_CS_NUM) {
 		pr_err("%s: number of supported chip-selects cannot be > %d\n",
-					 __func__, GPMC_CS_NUM);
+		       __func__, GPMC_CS_NUM);
 		return -EINVAL;
 	}
 
@@ -1353,7 +1313,6 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 	}
 
 	for_each_child_of_node(pdev->dev.of_node, child) {
-
 		if (!child->name)
 			continue;
 
@@ -1625,6 +1584,7 @@ static int gpmc_probe(struct platform_device *pdev)
 
 	/* Now the GPMC is initialised, unreserve the chip-selects */
 	gpmc_cs_map = 0;
+	gpmc_dev = dev;
 
 	if (dev->of_node) {
 		rc = gpmc_probe_dt(pdev);
@@ -1661,9 +1621,100 @@ static int gpmc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+/* Structure to save gpmc cs context */
+struct gpmc_cs_config {
+	u32 config1;
+	u32 config2;
+	u32 config3;
+	u32 config4;
+	u32 config5;
+	u32 config6;
+	u32 config7;
+	int is_valid;
+};
+
+/*
+ * Structure to save/restore gpmc context
+ */
+struct omap_gpmc_regs {
+	u32 sysconfig;
+	u32 irqenable;
+	u32 timeout_ctrl;
+	u32 config;
+	u32 prefetch_config1;
+	u32 prefetch_config2;
+	u32 prefetch_control;
+	struct gpmc_cs_config cs_context[GPMC_CS_NUM];
+};
+
+static struct omap_gpmc_regs gpmc_context;
+
+void omap_gpmc_save_context(void)
+{
+	int i;
+
+	gpmc_context.sysconfig = gpmc_read_reg(GPMC_SYSCONFIG);
+	gpmc_context.irqenable = gpmc_read_reg(GPMC_IRQENABLE);
+	gpmc_context.timeout_ctrl = gpmc_read_reg(GPMC_TIMEOUT_CONTROL);
+	gpmc_context.config = gpmc_read_reg(GPMC_CONFIG);
+	gpmc_context.prefetch_config1 = gpmc_read_reg(GPMC_PREFETCH_CONFIG1);
+	gpmc_context.prefetch_config2 = gpmc_read_reg(GPMC_PREFETCH_CONFIG2);
+	gpmc_context.prefetch_control = gpmc_read_reg(GPMC_PREFETCH_CONTROL);
+	for (i = 0; i < gpmc_cs_num; i++) {
+		gpmc_context.cs_context[i].is_valid = gpmc_cs_mem_enabled(i);
+		if (gpmc_context.cs_context[i].is_valid) {
+			gpmc_context.cs_context[i].config1 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG1);
+			gpmc_context.cs_context[i].config2 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG2);
+			gpmc_context.cs_context[i].config3 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG3);
+			gpmc_context.cs_context[i].config4 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG4);
+			gpmc_context.cs_context[i].config5 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG5);
+			gpmc_context.cs_context[i].config6 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG6);
+			gpmc_context.cs_context[i].config7 =
+				gpmc_cs_read_reg(i, GPMC_CS_CONFIG7);
+		}
+	}
+}
+
+void omap_gpmc_restore_context(void)
+{
+	int i;
+
+	gpmc_write_reg(GPMC_SYSCONFIG, gpmc_context.sysconfig);
+	gpmc_write_reg(GPMC_IRQENABLE, gpmc_context.irqenable);
+	gpmc_write_reg(GPMC_TIMEOUT_CONTROL, gpmc_context.timeout_ctrl);
+	gpmc_write_reg(GPMC_CONFIG, gpmc_context.config);
+	gpmc_write_reg(GPMC_PREFETCH_CONFIG1, gpmc_context.prefetch_config1);
+	gpmc_write_reg(GPMC_PREFETCH_CONFIG2, gpmc_context.prefetch_config2);
+	gpmc_write_reg(GPMC_PREFETCH_CONTROL, gpmc_context.prefetch_control);
+	for (i = 0; i < gpmc_cs_num; i++) {
+		if (gpmc_context.cs_context[i].is_valid) {
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG1,
+					  gpmc_context.cs_context[i].config1);
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG2,
+					  gpmc_context.cs_context[i].config2);
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG3,
+					  gpmc_context.cs_context[i].config3);
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG4,
+					  gpmc_context.cs_context[i].config4);
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG5,
+					  gpmc_context.cs_context[i].config5);
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG6,
+					  gpmc_context.cs_context[i].config6);
+			gpmc_cs_write_reg(i, GPMC_CS_CONFIG7,
+					  gpmc_context.cs_context[i].config7);
+		}
+	}
+}
+
 static int gpmc_suspend(struct device *dev)
 {
-	omap3_gpmc_save_context();
+	omap_gpmc_save_context();
 	pm_runtime_put_sync(dev);
 	return 0;
 }
@@ -1671,7 +1722,7 @@ static int gpmc_suspend(struct device *dev)
 static int gpmc_resume(struct device *dev)
 {
 	pm_runtime_get_sync(dev);
-	omap3_gpmc_restore_context();
+	omap_gpmc_restore_context();
 	return 0;
 }
 #endif
@@ -1697,116 +1748,11 @@ static __init int gpmc_init(void)
 static __exit void gpmc_exit(void)
 {
 	platform_driver_unregister(&gpmc_driver);
-
 }
 
 module_init(gpmc_init);
 module_exit(gpmc_exit);
 
-static int __init omap_gpmc_init(void)
-{
-	struct omap_hwmod *oh;
-	struct platform_device *pdev;
-	char *oh_name = "gpmc";
-
-	/*
-	 * if the board boots up with a populated DT, do not
-	 * manually add the device from this initcall
-	 */
-	if (of_have_populated_dt())
-		return -ENODEV;
-
-	oh = omap_hwmod_lookup(oh_name);
-	if (!oh) {
-		pr_err("Could not look up %s\n", oh_name);
-		return -ENODEV;
-	}
-
-	pdev = omap_device_build(DEVICE_NAME, -1, oh, (void *)&gpmc_pdata,
-				 sizeof(gpmc_pdata));
-	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
-
-	return PTR_RET(pdev);
-}
-/* must run after machine_init code. i.e. arch_init */
-omap_subsys_initcall(omap_gpmc_init);
-
-/**
- * gpmc_generic_init - Initialize platform data for a Chip Select
- *
- * @cs		chip select number
- * @is_nand	true if device is NAND flash.
- * @settings	GPMC settings
- * @device_timings	device timings for device on this CS
- * @gpmc_timings	GPMC timings
- * @pdev	platform device for the device on this CS
- * @pdata_size	platform data size for the platform device
- */
-int gpmc_generic_init(int cs, bool is_nand,
-		      struct gpmc_settings *settings,
-		      struct gpmc_device_timings *device_timings,
-		      struct gpmc_timings *gpmc_timings,
-		      struct platform_device *pdev, unsigned pdata_size)
-{
-	struct gpmc_settings *gpmc_s = NULL;
-	struct gpmc_device_timings *gpmc_dev_t = NULL;
-	struct gpmc_timings *gpmc_t;
-
-	if (cs >= GPMC_CS_NUM) {
-		pr_err("%s: Invalid cs specified. Max CS = %d\n",
-		       __func__, GPMC_CS_NUM);
-		return -EINVAL;
-	}
-
-	if (gpmc_pdata.cs[cs].valid) {
-		pr_err("%s: cs %d already requested, ignoring new request\n",
-		       __func__, cs);
-		return -EINVAL;
-	}
-
-	if (settings) {
-		gpmc_s = kmemdup(settings, sizeof(*settings), GFP_KERNEL);
-		if (!gpmc_s)
-			return -ENOMEM;
-
-		gpmc_pdata.cs[cs].settings = gpmc_s;
-	}
-
-	if (device_timings) {
-		gpmc_dev_t = kmemdup(device_timings, sizeof(*device_timings),
-				     GFP_KERNEL);
-		if (!gpmc_dev_t)
-			goto dev_t_fail;
-
-		gpmc_pdata.cs[cs].device_timings = gpmc_dev_t;
-	}
-
-	if (gpmc_timings) {
-		gpmc_t = kmemdup(gpmc_timings, sizeof(*gpmc_timings),
-				 GFP_KERNEL);
-		if (!gpmc_t)
-			goto gpmc_t_fail;
-
-		gpmc_pdata.cs[cs].gpmc_timings = gpmc_t;
-	}
-
-	gpmc_pdata.cs[cs].is_nand = is_nand;
-	gpmc_pdata.cs[cs].pdev = pdev;
-	gpmc_pdata.cs[cs].pdata_size = pdata_size;
-	gpmc_pdata.cs[cs].valid = true;
-
-	return 0;
-
-gpmc_t_fail:
-	if (device_timings)
-		kfree(gpmc_dev_t);
-dev_t_fail:
-	if (settings)
-		kfree(gpmc_s);
-
-	return -ENOMEM;
-}
-
 /**
  * omap_gpmc_retime - Reconfigre GPMC timings for the device
  *
@@ -1881,67 +1827,3 @@ unsigned long omap_gpmc_get_clk_period(int cs,
 }
 EXPORT_SYMBOL_GPL(omap_gpmc_get_clk_period);
 
-static struct omap3_gpmc_regs gpmc_context;
-
-void omap3_gpmc_save_context(void)
-{
-	int i;
-
-	gpmc_context.sysconfig = gpmc_read_reg(GPMC_SYSCONFIG);
-	gpmc_context.irqenable = gpmc_read_reg(GPMC_IRQENABLE);
-	gpmc_context.timeout_ctrl = gpmc_read_reg(GPMC_TIMEOUT_CONTROL);
-	gpmc_context.config = gpmc_read_reg(GPMC_CONFIG);
-	gpmc_context.prefetch_config1 = gpmc_read_reg(GPMC_PREFETCH_CONFIG1);
-	gpmc_context.prefetch_config2 = gpmc_read_reg(GPMC_PREFETCH_CONFIG2);
-	gpmc_context.prefetch_control = gpmc_read_reg(GPMC_PREFETCH_CONTROL);
-	for (i = 0; i < gpmc_cs_num; i++) {
-		gpmc_context.cs_context[i].is_valid = gpmc_cs_mem_enabled(i);
-		if (gpmc_context.cs_context[i].is_valid) {
-			gpmc_context.cs_context[i].config1 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG1);
-			gpmc_context.cs_context[i].config2 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG2);
-			gpmc_context.cs_context[i].config3 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG3);
-			gpmc_context.cs_context[i].config4 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG4);
-			gpmc_context.cs_context[i].config5 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG5);
-			gpmc_context.cs_context[i].config6 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG6);
-			gpmc_context.cs_context[i].config7 =
-				gpmc_cs_read_reg(i, GPMC_CS_CONFIG7);
-		}
-	}
-}
-
-void omap3_gpmc_restore_context(void)
-{
-	int i;
-
-	gpmc_write_reg(GPMC_SYSCONFIG, gpmc_context.sysconfig);
-	gpmc_write_reg(GPMC_IRQENABLE, gpmc_context.irqenable);
-	gpmc_write_reg(GPMC_TIMEOUT_CONTROL, gpmc_context.timeout_ctrl);
-	gpmc_write_reg(GPMC_CONFIG, gpmc_context.config);
-	gpmc_write_reg(GPMC_PREFETCH_CONFIG1, gpmc_context.prefetch_config1);
-	gpmc_write_reg(GPMC_PREFETCH_CONFIG2, gpmc_context.prefetch_config2);
-	gpmc_write_reg(GPMC_PREFETCH_CONTROL, gpmc_context.prefetch_control);
-	for (i = 0; i < gpmc_cs_num; i++) {
-		if (gpmc_context.cs_context[i].is_valid) {
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG1,
-				gpmc_context.cs_context[i].config1);
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG2,
-				gpmc_context.cs_context[i].config2);
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG3,
-				gpmc_context.cs_context[i].config3);
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG4,
-				gpmc_context.cs_context[i].config4);
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG5,
-				gpmc_context.cs_context[i].config5);
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG6,
-				gpmc_context.cs_context[i].config6);
-			gpmc_cs_write_reg(i, GPMC_CS_CONFIG7,
-				gpmc_context.cs_context[i].config7);
-		}
-	}
-}
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index f1cf503..e1db2c1 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -89,7 +89,7 @@ config MTD_NAND_AMS_DELTA
 
 config MTD_NAND_OMAP2
 	tristate "NAND Flash device on OMAP2, OMAP3 and OMAP4"
-	depends on ARCH_OMAP2PLUS
+	depends on TI_GPMC
 	help
           Support for NAND flash on Texas Instruments OMAP2, OMAP3 and OMAP4
 	  platforms.
diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
index ab260727..272c16c 100644
--- a/drivers/mtd/onenand/Kconfig
+++ b/drivers/mtd/onenand/Kconfig
@@ -24,10 +24,10 @@ config MTD_ONENAND_GENERIC
 	  Support for OneNAND flash via platform device driver.
 
 config MTD_ONENAND_OMAP2
-	tristate "OneNAND on OMAP2/OMAP3 support"
-	depends on ARCH_OMAP2 || ARCH_OMAP3
+	tristate "OneNAND on OMAP2+ support"
+	depends on TI_GPMC
 	help
-	  Support for a OneNAND flash device connected to an OMAP2/OMAP3 CPU
+	  Support for a OneNAND flash device connected to an OMAP2+ SoCs
 	  via the GPMC memory controller.
 
 config MTD_ONENAND_SAMSUNG
-- 
1.8.3.2


