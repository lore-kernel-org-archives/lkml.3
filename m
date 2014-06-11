Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaFKJAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:00:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57703 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbaFKI7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 35/36] ARM: OMAP2+: gpmc: move GPMC driver into drivers/memory
Date: Wed, 11 Jun 2014 11:56:40 +0300
Message-ID: <1402477001-31132-36-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/arm/mach-omap2/Makefile      |    2 +-
 arch/arm/mach-omap2/gpmc.c        | 1947 -------------------------------------
 arch/arm/mach-omap2/gpmc_legacy.c |  296 ++++++
 drivers/memory/Kconfig            |   10 +
 drivers/memory/Makefile           |    1 +
 drivers/memory/ti-gpmc.c          | 1829 ++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/Kconfig          |    2 +-
 drivers/mtd/onenand/Kconfig       |    6 +-
 8 files changed, 2141 insertions(+), 1952 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/gpmc.c
 create mode 100644 arch/arm/mach-omap2/gpmc_legacy.c
 create mode 100644 drivers/memory/ti-gpmc.c

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
 
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
deleted file mode 100644
index 9173f71..0000000
--- a/arch/arm/mach-omap2/gpmc.c
+++ /dev/null
@@ -1,1947 +0,0 @@
-/*
- * GPMC support functions
- *
- * Copyright (C) 2005-2006 Nokia Corporation
- *
- * Author: Juha Yrjola
- *
- * Copyright (C) 2009 Texas Instruments
- * Added OMAP4 support - Santosh Shilimkar <santosh.shilimkar@ti.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#undef DEBUG
-
-#include <linux/irq.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/ioport.h>
-#include <linux/spinlock.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_mtd.h>
-#include <linux/of_device.h>
-#include <linux/pm_runtime.h>
-#include <linux/slab.h>
-
-#include <linux/platform_data/mtd-nand-omap2.h>
-
-#include <asm/mach-types.h>
-
-#include "soc.h"
-#include "common.h"
-#include "omap_device.h"
-#include "gpmc.h"
-
-#define	DEVICE_NAME		"omap-gpmc"
-
-/* GPMC register offsets */
-#define GPMC_REVISION		0x00
-#define GPMC_SYSCONFIG		0x10
-#define GPMC_SYSSTATUS		0x14
-#define GPMC_IRQSTATUS		0x18
-#define GPMC_IRQENABLE		0x1c
-#define GPMC_TIMEOUT_CONTROL	0x40
-#define GPMC_ERR_ADDRESS	0x44
-#define GPMC_ERR_TYPE		0x48
-#define GPMC_CONFIG		0x50
-#define GPMC_STATUS		0x54
-#define GPMC_PREFETCH_CONFIG1	0x1e0
-#define GPMC_PREFETCH_CONFIG2	0x1e4
-#define GPMC_PREFETCH_CONTROL	0x1ec
-#define GPMC_PREFETCH_STATUS	0x1f0
-#define GPMC_ECC_CONFIG		0x1f4
-#define GPMC_ECC_CONTROL	0x1f8
-#define GPMC_ECC_SIZE_CONFIG	0x1fc
-#define GPMC_ECC1_RESULT        0x200
-#define GPMC_ECC_BCH_RESULT_0   0x240   /* not available on OMAP2 */
-#define	GPMC_ECC_BCH_RESULT_1	0x244	/* not available on OMAP2 */
-#define	GPMC_ECC_BCH_RESULT_2	0x248	/* not available on OMAP2 */
-#define	GPMC_ECC_BCH_RESULT_3	0x24c	/* not available on OMAP2 */
-
-/* GPMC ECC control settings */
-#define GPMC_ECC_CTRL_ECCCLEAR		0x100
-#define GPMC_ECC_CTRL_ECCDISABLE	0x000
-#define GPMC_ECC_CTRL_ECCREG1		0x001
-#define GPMC_ECC_CTRL_ECCREG2		0x002
-#define GPMC_ECC_CTRL_ECCREG3		0x003
-#define GPMC_ECC_CTRL_ECCREG4		0x004
-#define GPMC_ECC_CTRL_ECCREG5		0x005
-#define GPMC_ECC_CTRL_ECCREG6		0x006
-#define GPMC_ECC_CTRL_ECCREG7		0x007
-#define GPMC_ECC_CTRL_ECCREG8		0x008
-#define GPMC_ECC_CTRL_ECCREG9		0x009
-
-/* ECC commands */
-#define GPMC_ECC_READ		0 /* Reset Hardware ECC for read */
-#define GPMC_ECC_WRITE		1 /* Reset Hardware ECC for write */
-#define GPMC_ECC_READSYN	2 /* Reset before syndrom is read back */
-
-/* CS CONFIG registers */
-#define GPMC_CS_CONFIG1		0x00
-#define GPMC_CS_CONFIG2		0x04
-#define GPMC_CS_CONFIG3		0x08
-#define GPMC_CS_CONFIG4		0x0c
-#define GPMC_CS_CONFIG5		0x10
-#define GPMC_CS_CONFIG6		0x14
-#define GPMC_CS_CONFIG7		0x18
-
-#define GPMC_CONFIG1_WRAPBURST_SUPP     (1 << 31)
-#define GPMC_CONFIG1_READMULTIPLE_SUPP  (1 << 30)
-#define GPMC_CONFIG1_READTYPE_ASYNC     (0 << 29)
-#define GPMC_CONFIG1_READTYPE_SYNC      (1 << 29)
-#define GPMC_CONFIG1_WRITEMULTIPLE_SUPP (1 << 28)
-#define GPMC_CONFIG1_WRITETYPE_ASYNC    (0 << 27)
-#define GPMC_CONFIG1_WRITETYPE_SYNC     (1 << 27)
-#define GPMC_CONFIG1_CLKACTIVATIONTIME(val) ((val & 3) << 25)
-#define GPMC_CONFIG1_PAGE_LEN(val)      ((val & 3) << 23)
-#define GPMC_CONFIG1_WAIT_READ_MON      (1 << 22)
-#define GPMC_CONFIG1_WAIT_WRITE_MON     (1 << 21)
-#define GPMC_CONFIG1_WAIT_MON_IIME(val) ((val & 3) << 18)
-#define GPMC_CONFIG1_WAIT_PIN_SEL(val)  ((val & 3) << 16)
-#define GPMC_CONFIG1_DEVICESIZE(val)    ((val & 3) << 12)
-#define GPMC_CONFIG1_DEVICESIZE_16      GPMC_CONFIG1_DEVICESIZE(1)
-#define GPMC_CONFIG1_DEVICETYPE(val)    ((val & 3) << 10)
-#define GPMC_CONFIG1_DEVICETYPE_NOR     GPMC_CONFIG1_DEVICETYPE(0)
-#define GPMC_CONFIG1_MUXTYPE(val)       ((val & 3) << 8)
-#define GPMC_CONFIG1_TIME_PARA_GRAN     (1 << 4)
-#define GPMC_CONFIG1_FCLK_DIV(val)      (val & 3)
-#define GPMC_CONFIG1_FCLK_DIV2          (GPMC_CONFIG1_FCLK_DIV(1))
-#define GPMC_CONFIG1_FCLK_DIV3          (GPMC_CONFIG1_FCLK_DIV(2))
-#define GPMC_CONFIG1_FCLK_DIV4          (GPMC_CONFIG1_FCLK_DIV(3))
-#define GPMC_CONFIG7_CSVALID		(1 << 6)
-
-#define	GPMC_CONFIG2_CSEXTRADELAY		BIT(7)
-#define	GPMC_CONFIG3_ADVEXTRADELAY		BIT(7)
-#define	GPMC_CONFIG4_OEEXTRADELAY		BIT(7)
-#define	GPMC_CONFIG4_WEEXTRADELAY		BIT(23)
-#define	GPMC_CONFIG6_CYCLE2CYCLEDIFFCSEN	BIT(6)
-#define	GPMC_CONFIG6_CYCLE2CYCLESAMECSEN	BIT(7)
-
-#define GPMC_DEVICETYPE_NOR		0
-#define GPMC_DEVICETYPE_NAND		2
-#define WR_RD_PIN_MONITORING		0x00600000
-#define GPMC_IRQ_FIFOEVENTENABLE	0x01
-#define GPMC_IRQ_COUNT_EVENT		0x02
-
-#define GPMC_CS0_OFFSET		0x60
-#define GPMC_CS_SIZE		0x30
-#define	GPMC_BCH_SIZE		0x10
-
-#define GPMC_MEM_END		0x3FFFFFFF
-
-#define GPMC_CHUNK_SHIFT	24		/* 16 MB */
-#define GPMC_SECTION_SHIFT	28		/* 128 MB */
-
-#define CS_NUM_SHIFT		24
-#define ENABLE_PREFETCH		(0x1 << 7)
-#define DMA_MPU_MODE		2
-
-#define	GPMC_REVISION_MAJOR(l)		((l >> 4) & 0xf)
-#define	GPMC_REVISION_MINOR(l)		(l & 0xf)
-
-#define	GPMC_HAS_WR_ACCESS		0x1
-#define	GPMC_HAS_WR_DATA_MUX_BUS	0x2
-#define	GPMC_HAS_MUX_AAD		0x4
-
-#define GPMC_NR_WAITPINS		4
-
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
-static struct resource	gpmc_mem_root;
-static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
-static DEFINE_SPINLOCK(gpmc_mem_lock);
-/* Define chip-selects as reserved by default until probe completes */
-static unsigned int gpmc_cs_map = ((1 << GPMC_CS_NUM) - 1);
-static unsigned int gpmc_cs_num = GPMC_CS_NUM;
-static unsigned int gpmc_nr_waitpins;
-static struct device *gpmc_dev;
-static int gpmc_irq = -EINVAL;
-static resource_size_t phys_base, mem_size;
-static unsigned gpmc_capability;
-static void __iomem *gpmc_base;
-
-static struct clk *gpmc_l3_clk;
-
-static void gpmc_write_reg(int idx, u32 val)
-{
-	__raw_writel(val, gpmc_base + idx);
-}
-
-static u32 gpmc_read_reg(int idx)
-{
-	return __raw_readl(gpmc_base + idx);
-}
-
-static void gpmc_cs_write_reg(int cs, int idx, u32 val)
-{
-	void __iomem *reg_addr;
-
-	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	__raw_writel(val, reg_addr);
-}
-
-static u32 gpmc_cs_read_reg(int cs, int idx)
-{
-	void __iomem *reg_addr;
-
-	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	return __raw_readl(reg_addr);
-}
-
-/* TODO: Add support for gpmc_fck to clock framework and use it */
-static unsigned long gpmc_get_fclk_period(void)
-{
-	unsigned long rate = clk_get_rate(gpmc_l3_clk);
-
-	if (rate == 0) {
-		printk(KERN_WARNING "gpmc_l3_clk not enabled\n");
-		return 0;
-	}
-
-	rate /= 1000;
-	rate = 1000000000 / rate;	/* In picoseconds */
-
-	return rate;
-}
-
-static unsigned int gpmc_ns_to_ticks(unsigned int time_ns)
-{
-	unsigned long tick_ps;
-
-	/* Calculate in picosecs to yield more exact results */
-	tick_ps = gpmc_get_fclk_period();
-
-	return (time_ns * 1000 + tick_ps - 1) / tick_ps;
-}
-
-static unsigned int gpmc_ps_to_ticks(unsigned int time_ps)
-{
-	unsigned long tick_ps;
-
-	/* Calculate in picosecs to yield more exact results */
-	tick_ps = gpmc_get_fclk_period();
-
-	return (time_ps + tick_ps - 1) / tick_ps;
-}
-
-static unsigned int gpmc_ticks_to_ps(unsigned int ticks)
-{
-	return ticks * gpmc_get_fclk_period();
-}
-
-static unsigned int gpmc_round_ps_to_ticks(unsigned int time_ps)
-{
-	unsigned long ticks = gpmc_ps_to_ticks(time_ps);
-
-	return ticks * gpmc_get_fclk_period();
-}
-
-static inline void gpmc_cs_modify_reg(int cs, int reg, u32 mask, bool value)
-{
-	u32 l;
-
-	l = gpmc_cs_read_reg(cs, reg);
-	if (value)
-		l |= mask;
-	else
-		l &= ~mask;
-	gpmc_cs_write_reg(cs, reg, l);
-}
-
-static void gpmc_cs_bool_timings(int cs, const struct gpmc_bool_timings *p)
-{
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG1,
-			   GPMC_CONFIG1_TIME_PARA_GRAN,
-			   p->time_para_granularity);
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG2,
-			   GPMC_CONFIG2_CSEXTRADELAY, p->cs_extra_delay);
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG3,
-			   GPMC_CONFIG3_ADVEXTRADELAY, p->adv_extra_delay);
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG4,
-			   GPMC_CONFIG4_OEEXTRADELAY, p->oe_extra_delay);
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG4,
-			   GPMC_CONFIG4_OEEXTRADELAY, p->we_extra_delay);
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG6,
-			   GPMC_CONFIG6_CYCLE2CYCLESAMECSEN,
-			   p->cycle2cyclesamecsen);
-	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG6,
-			   GPMC_CONFIG6_CYCLE2CYCLEDIFFCSEN,
-			   p->cycle2cyclediffcsen);
-}
-
-#ifdef DEBUG
-static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
-			       int time, const char *name)
-#else
-static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
-			       int time)
-#endif
-{
-	u32 l;
-	int ticks, mask, nr_bits;
-
-	if (time == 0)
-		ticks = 0;
-	else
-		ticks = gpmc_ns_to_ticks(time);
-	nr_bits = end_bit - st_bit + 1;
-	if (ticks >= 1 << nr_bits) {
-#ifdef DEBUG
-		printk(KERN_INFO "GPMC CS%d: %-10s* %3d ns, %3d ticks >= %d\n",
-				cs, name, time, ticks, 1 << nr_bits);
-#endif
-		return -1;
-	}
-
-	mask = (1 << nr_bits) - 1;
-	l = gpmc_cs_read_reg(cs, reg);
-#ifdef DEBUG
-	printk(KERN_INFO
-		"GPMC CS%d: %-10s: %3d ticks, %3lu ns (was %3i ticks) %3d ns\n",
-	       cs, name, ticks, gpmc_get_fclk_period() * ticks / 1000,
-			(l >> st_bit) & mask, time);
-#endif
-	l &= ~(mask << st_bit);
-	l |= ticks << st_bit;
-	gpmc_cs_write_reg(cs, reg, l);
-
-	return 0;
-}
-
-#ifdef DEBUG
-#define GPMC_SET_ONE(reg, st, end, field) \
-	if (set_gpmc_timing_reg(cs, (reg), (st), (end),		\
-			t->field, #field) < 0)			\
-		return -1
-#else
-#define GPMC_SET_ONE(reg, st, end, field) \
-	if (set_gpmc_timing_reg(cs, (reg), (st), (end), t->field) < 0) \
-		return -1
-#endif
-
-static int gpmc_calc_divider(unsigned int sync_clk)
-{
-	int div;
-	u32 l;
-
-	l = sync_clk + (gpmc_get_fclk_period() - 1);
-	div = l / gpmc_get_fclk_period();
-	if (div > 4)
-		return -1;
-	if (div <= 0)
-		div = 1;
-
-	return div;
-}
-
-static int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t)
-{
-	int div;
-	u32 l;
-
-	div = gpmc_calc_divider(t->sync_clk);
-	if (div < 0)
-		return div;
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG2,  0,  3, cs_on);
-	GPMC_SET_ONE(GPMC_CS_CONFIG2,  8, 12, cs_rd_off);
-	GPMC_SET_ONE(GPMC_CS_CONFIG2, 16, 20, cs_wr_off);
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG3,  0,  3, adv_on);
-	GPMC_SET_ONE(GPMC_CS_CONFIG3,  8, 12, adv_rd_off);
-	GPMC_SET_ONE(GPMC_CS_CONFIG3, 16, 20, adv_wr_off);
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG4,  0,  3, oe_on);
-	GPMC_SET_ONE(GPMC_CS_CONFIG4,  8, 12, oe_off);
-	GPMC_SET_ONE(GPMC_CS_CONFIG4, 16, 19, we_on);
-	GPMC_SET_ONE(GPMC_CS_CONFIG4, 24, 28, we_off);
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG5,  0,  4, rd_cycle);
-	GPMC_SET_ONE(GPMC_CS_CONFIG5,  8, 12, wr_cycle);
-	GPMC_SET_ONE(GPMC_CS_CONFIG5, 16, 20, access);
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG5, 24, 27, page_burst_access);
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG6, 0, 3, bus_turnaround);
-	GPMC_SET_ONE(GPMC_CS_CONFIG6, 8, 11, cycle2cycle_delay);
-
-	GPMC_SET_ONE(GPMC_CS_CONFIG1, 18, 19, wait_monitoring);
-	GPMC_SET_ONE(GPMC_CS_CONFIG1, 25, 26, clk_activation);
-
-	if (gpmc_capability & GPMC_HAS_WR_DATA_MUX_BUS)
-		GPMC_SET_ONE(GPMC_CS_CONFIG6, 16, 19, wr_data_mux_bus);
-	if (gpmc_capability & GPMC_HAS_WR_ACCESS)
-		GPMC_SET_ONE(GPMC_CS_CONFIG6, 24, 28, wr_access);
-
-	/* caller is expected to have initialized CONFIG1 to cover
-	 * at least sync vs async
-	 */
-	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
-	if (l & (GPMC_CONFIG1_READTYPE_SYNC | GPMC_CONFIG1_WRITETYPE_SYNC)) {
-#ifdef DEBUG
-		printk(KERN_INFO "GPMC CS%d CLK period is %lu ns (div %d)\n",
-				cs, (div * gpmc_get_fclk_period()) / 1000, div);
-#endif
-		l &= ~0x03;
-		l |= (div - 1);
-		gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, l);
-	}
-
-	gpmc_cs_bool_timings(cs, &t->bool_timings);
-
-	return 0;
-}
-
-static int gpmc_cs_enable_mem(int cs, u32 base, u32 size)
-{
-	u32 l;
-	u32 mask;
-
-	/*
-	 * Ensure that base address is aligned on a
-	 * boundary equal to or greater than size.
-	 */
-	if (base & (size - 1))
-		return -EINVAL;
-
-	mask = (1 << GPMC_SECTION_SHIFT) - size;
-	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
-	l &= ~0x3f;
-	l = (base >> GPMC_CHUNK_SHIFT) & 0x3f;
-	l &= ~(0x0f << 8);
-	l |= ((mask >> GPMC_CHUNK_SHIFT) & 0x0f) << 8;
-	l |= GPMC_CONFIG7_CSVALID;
-	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG7, l);
-
-	return 0;
-}
-
-static void gpmc_cs_disable_mem(int cs)
-{
-	u32 l;
-
-	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
-	l &= ~GPMC_CONFIG7_CSVALID;
-	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG7, l);
-}
-
-static void gpmc_cs_get_memconf(int cs, u32 *base, u32 *size)
-{
-	u32 l;
-	u32 mask;
-
-	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
-	*base = (l & 0x3f) << GPMC_CHUNK_SHIFT;
-	mask = (l >> 8) & 0x0f;
-	*size = (1 << GPMC_SECTION_SHIFT) - (mask << GPMC_CHUNK_SHIFT);
-}
-
-static int gpmc_cs_mem_enabled(int cs)
-{
-	u32 l;
-
-	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
-	return l & GPMC_CONFIG7_CSVALID;
-}
-
-static void gpmc_cs_set_reserved(int cs, int reserved)
-{
-	gpmc_cs_map &= ~(1 << cs);
-	gpmc_cs_map |= (reserved ? 1 : 0) << cs;
-}
-
-static bool gpmc_cs_reserved(int cs)
-{
-	return gpmc_cs_map & (1 << cs);
-}
-
-static unsigned long gpmc_mem_align(unsigned long size)
-{
-	int order;
-
-	size = (size - 1) >> (GPMC_CHUNK_SHIFT - 1);
-	order = GPMC_CHUNK_SHIFT - 1;
-	do {
-		size >>= 1;
-		order++;
-	} while (size);
-	size = 1 << order;
-	return size;
-}
-
-static int gpmc_cs_insert_mem(int cs, unsigned long base, unsigned long size)
-{
-	struct resource	*res = &gpmc_cs_mem[cs];
-	int r;
-
-	size = gpmc_mem_align(size);
-	spin_lock(&gpmc_mem_lock);
-	res->start = base;
-	res->end = base + size - 1;
-	r = request_resource(&gpmc_mem_root, res);
-	spin_unlock(&gpmc_mem_lock);
-
-	return r;
-}
-
-static int gpmc_cs_delete_mem(int cs)
-{
-	struct resource	*res = &gpmc_cs_mem[cs];
-	int r;
-
-	spin_lock(&gpmc_mem_lock);
-	r = release_resource(res);
-	res->start = 0;
-	res->end = 0;
-	spin_unlock(&gpmc_mem_lock);
-
-	return r;
-}
-
-/**
- * gpmc_cs_remap - remaps a chip-select physical base address
- * @cs:		chip-select to remap
- * @base:	physical base address to re-map chip-select to
- *
- * Re-maps a chip-select to a new physical base address specified by
- * "base". Returns 0 on success and appropriate negative error code
- * on failure.
- */
-static int gpmc_cs_remap(int cs, u32 base)
-{
-	int ret;
-	u32 old_base, size;
-
-	if (cs > gpmc_cs_num) {
-		pr_err("%s: requested chip-select is disabled\n", __func__);
-		return -ENODEV;
-	}
-
-	/*
-	 * Make sure we ignore any device offsets from the GPMC partition
-	 * allocated for the chip select and that the new base confirms
-	 * to the GPMC 16MB minimum granularity.
-	 */ 
-	base &= ~(SZ_16M - 1);
-
-	gpmc_cs_get_memconf(cs, &old_base, &size);
-	if (base == old_base)
-		return 0;
-	gpmc_cs_disable_mem(cs);
-	ret = gpmc_cs_delete_mem(cs);
-	if (ret < 0)
-		return ret;
-	ret = gpmc_cs_insert_mem(cs, base, size);
-	if (ret < 0)
-		return ret;
-	ret = gpmc_cs_enable_mem(cs, base, size);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
-{
-	struct resource *res = &gpmc_cs_mem[cs];
-	int r = -1;
-
-	if (cs > gpmc_cs_num) {
-		pr_err("%s: requested chip-select is disabled\n", __func__);
-		return -ENODEV;
-	}
-	size = gpmc_mem_align(size);
-	if (size > (1 << GPMC_SECTION_SHIFT))
-		return -ENOMEM;
-
-	spin_lock(&gpmc_mem_lock);
-	if (gpmc_cs_reserved(cs)) {
-		r = -EBUSY;
-		goto out;
-	}
-	if (gpmc_cs_mem_enabled(cs))
-		r = adjust_resource(res, res->start & ~(size - 1), size);
-	if (r < 0)
-		r = allocate_resource(&gpmc_mem_root, res, size, 0, ~0,
-				      size, NULL, NULL);
-	if (r < 0)
-		goto out;
-
-	r = gpmc_cs_enable_mem(cs, res->start, resource_size(res));
-	if (r < 0) {
-		release_resource(res);
-		goto out;
-	}
-
-	*base = res->start;
-	gpmc_cs_set_reserved(cs, 1);
-out:
-	spin_unlock(&gpmc_mem_lock);
-	return r;
-}
-
-static void gpmc_cs_free(int cs)
-{
-	struct resource	*res = &gpmc_cs_mem[cs];
-
-	spin_lock(&gpmc_mem_lock);
-	if (cs >= gpmc_cs_num || cs < 0 || !gpmc_cs_reserved(cs)) {
-		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
-		BUG();
-		spin_unlock(&gpmc_mem_lock);
-		return;
-	}
-	gpmc_cs_disable_mem(cs);
-	if (res->flags)
-		release_resource(res);
-	gpmc_cs_set_reserved(cs, 0);
-	spin_unlock(&gpmc_mem_lock);
-}
-
-static void gpmc_mem_exit(void)
-{
-	int cs;
-
-	for (cs = 0; cs < gpmc_cs_num; cs++) {
-		if (!gpmc_cs_mem_enabled(cs))
-			continue;
-		gpmc_cs_delete_mem(cs);
-	}
-
-}
-
-static void gpmc_mem_init(void)
-{
-	int cs;
-
-	/*
-	 * The first 1MB of GPMC address space is typically mapped to
-	 * the internal ROM. Never allocate the first page, to
-	 * facilitate bug detection; even if we didn't boot from ROM.
-	 */
-	gpmc_mem_root.start = SZ_1M;
-	gpmc_mem_root.end = GPMC_MEM_END;
-
-	/* Reserve all regions that has been set up by bootloader */
-	for (cs = 0; cs < gpmc_cs_num; cs++) {
-		u32 base, size;
-
-		if (!gpmc_cs_mem_enabled(cs))
-			continue;
-		gpmc_cs_get_memconf(cs, &base, &size);
-		if (gpmc_cs_insert_mem(cs, base, size)) {
-			pr_warn("%s: disabling cs %d mapped at 0x%x-0x%x\n",
-				__func__, cs, base, base + size);
-			gpmc_cs_disable_mem(cs);
-		}
-	}
-}
-
-static u32 gpmc_round_ps_to_sync_clk(u32 time_ps, u32 sync_clk)
-{
-	u32 temp;
-	int div;
-
-	div = gpmc_calc_divider(sync_clk);
-	temp = gpmc_ps_to_ticks(time_ps);
-	temp = (temp + div - 1) / div;
-	return gpmc_ticks_to_ps(temp * div);
-}
-
-/* XXX: can the cycles be avoided ? */
-static int gpmc_calc_sync_read_timings(struct gpmc_timings *gpmc_t,
-				       struct gpmc_device_timings *dev_t,
-				       bool mux)
-{
-	u32 temp;
-
-	/* adv_rd_off */
-	temp = dev_t->t_avdp_r;
-	/* XXX: mux check required ? */
-	if (mux) {
-		/* XXX: t_avdp not to be required for sync, only added for tusb
-		 * this indirectly necessitates requirement of t_avdp_r and
-		 * t_avdp_w instead of having a single t_avdp
-		 */
-		temp = max_t(u32, temp,	gpmc_t->clk_activation + dev_t->t_avdh);
-		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
-	}
-	gpmc_t->adv_rd_off = gpmc_round_ps_to_ticks(temp);
-
-	/* oe_on */
-	temp = dev_t->t_oeasu; /* XXX: remove this ? */
-	if (mux) {
-		temp = max_t(u32, temp,	gpmc_t->clk_activation + dev_t->t_ach);
-		temp = max_t(u32, temp, gpmc_t->adv_rd_off +
-				gpmc_ticks_to_ps(dev_t->cyc_aavdh_oe));
-	}
-	gpmc_t->oe_on = gpmc_round_ps_to_ticks(temp);
-
-	/* access */
-	/* XXX: any scope for improvement ?, by combining oe_on
-	 * and clk_activation, need to check whether
-	 * access = clk_activation + round to sync clk ?
-	 */
-	temp = max_t(u32, dev_t->t_iaa,	dev_t->cyc_iaa * gpmc_t->sync_clk);
-	temp += gpmc_t->clk_activation;
-	if (dev_t->cyc_oe)
-		temp = max_t(u32, temp, gpmc_t->oe_on +
-				gpmc_ticks_to_ps(dev_t->cyc_oe));
-	gpmc_t->access = gpmc_round_ps_to_ticks(temp);
-
-	gpmc_t->oe_off = gpmc_t->access + gpmc_ticks_to_ps(1);
-	gpmc_t->cs_rd_off = gpmc_t->oe_off;
-
-	/* rd_cycle */
-	temp = max_t(u32, dev_t->t_cez_r, dev_t->t_oez);
-	temp = gpmc_round_ps_to_sync_clk(temp, gpmc_t->sync_clk) +
-							gpmc_t->access;
-	/* XXX: barter t_ce_rdyz with t_cez_r ? */
-	if (dev_t->t_ce_rdyz)
-		temp = max_t(u32, temp,	gpmc_t->cs_rd_off + dev_t->t_ce_rdyz);
-	gpmc_t->rd_cycle = gpmc_round_ps_to_ticks(temp);
-
-	return 0;
-}
-
-static int gpmc_calc_sync_write_timings(struct gpmc_timings *gpmc_t,
-					struct gpmc_device_timings *dev_t,
-					bool mux)
-{
-	u32 temp;
-
-	/* adv_wr_off */
-	temp = dev_t->t_avdp_w;
-	if (mux) {
-		temp = max_t(u32, temp,
-			gpmc_t->clk_activation + dev_t->t_avdh);
-		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
-	}
-	gpmc_t->adv_wr_off = gpmc_round_ps_to_ticks(temp);
-
-	/* wr_data_mux_bus */
-	temp = max_t(u32, dev_t->t_weasu,
-			gpmc_t->clk_activation + dev_t->t_rdyo);
-	/* XXX: shouldn't mux be kept as a whole for wr_data_mux_bus ?,
-	 * and in that case remember to handle we_on properly
-	 */
-	if (mux) {
-		temp = max_t(u32, temp,
-			gpmc_t->adv_wr_off + dev_t->t_aavdh);
-		temp = max_t(u32, temp, gpmc_t->adv_wr_off +
-				gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
-	}
-	gpmc_t->wr_data_mux_bus = gpmc_round_ps_to_ticks(temp);
-
-	/* we_on */
-	if (gpmc_capability & GPMC_HAS_WR_DATA_MUX_BUS)
-		gpmc_t->we_on = gpmc_round_ps_to_ticks(dev_t->t_weasu);
-	else
-		gpmc_t->we_on = gpmc_t->wr_data_mux_bus;
-
-	/* wr_access */
-	/* XXX: gpmc_capability check reqd ? , even if not, will not harm */
-	gpmc_t->wr_access = gpmc_t->access;
-
-	/* we_off */
-	temp = gpmc_t->we_on + dev_t->t_wpl;
-	temp = max_t(u32, temp,
-			gpmc_t->wr_access + gpmc_ticks_to_ps(1));
-	temp = max_t(u32, temp,
-		gpmc_t->we_on + gpmc_ticks_to_ps(dev_t->cyc_wpl));
-	gpmc_t->we_off = gpmc_round_ps_to_ticks(temp);
-
-	gpmc_t->cs_wr_off = gpmc_round_ps_to_ticks(gpmc_t->we_off +
-							dev_t->t_wph);
-
-	/* wr_cycle */
-	temp = gpmc_round_ps_to_sync_clk(dev_t->t_cez_w, gpmc_t->sync_clk);
-	temp += gpmc_t->wr_access;
-	/* XXX: barter t_ce_rdyz with t_cez_w ? */
-	if (dev_t->t_ce_rdyz)
-		temp = max_t(u32, temp,
-				 gpmc_t->cs_wr_off + dev_t->t_ce_rdyz);
-	gpmc_t->wr_cycle = gpmc_round_ps_to_ticks(temp);
-
-	return 0;
-}
-
-static int gpmc_calc_async_read_timings(struct gpmc_timings *gpmc_t,
-					struct gpmc_device_timings *dev_t,
-					bool mux)
-{
-	u32 temp;
-
-	/* adv_rd_off */
-	temp = dev_t->t_avdp_r;
-	if (mux)
-		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
-	gpmc_t->adv_rd_off = gpmc_round_ps_to_ticks(temp);
-
-	/* oe_on */
-	temp = dev_t->t_oeasu;
-	if (mux)
-		temp = max_t(u32, temp,
-			gpmc_t->adv_rd_off + dev_t->t_aavdh);
-	gpmc_t->oe_on = gpmc_round_ps_to_ticks(temp);
-
-	/* access */
-	temp = max_t(u32, dev_t->t_iaa, /* XXX: remove t_iaa in async ? */
-				gpmc_t->oe_on + dev_t->t_oe);
-	temp = max_t(u32, temp,
-				gpmc_t->cs_on + dev_t->t_ce);
-	temp = max_t(u32, temp,
-				gpmc_t->adv_on + dev_t->t_aa);
-	gpmc_t->access = gpmc_round_ps_to_ticks(temp);
-
-	gpmc_t->oe_off = gpmc_t->access + gpmc_ticks_to_ps(1);
-	gpmc_t->cs_rd_off = gpmc_t->oe_off;
-
-	/* rd_cycle */
-	temp = max_t(u32, dev_t->t_rd_cycle,
-			gpmc_t->cs_rd_off + dev_t->t_cez_r);
-	temp = max_t(u32, temp, gpmc_t->oe_off + dev_t->t_oez);
-	gpmc_t->rd_cycle = gpmc_round_ps_to_ticks(temp);
-
-	return 0;
-}
-
-static int gpmc_calc_async_write_timings(struct gpmc_timings *gpmc_t,
-					 struct gpmc_device_timings *dev_t,
-					 bool mux)
-{
-	u32 temp;
-
-	/* adv_wr_off */
-	temp = dev_t->t_avdp_w;
-	if (mux)
-		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
-	gpmc_t->adv_wr_off = gpmc_round_ps_to_ticks(temp);
-
-	/* wr_data_mux_bus */
-	temp = dev_t->t_weasu;
-	if (mux) {
-		temp = max_t(u32, temp,	gpmc_t->adv_wr_off + dev_t->t_aavdh);
-		temp = max_t(u32, temp, gpmc_t->adv_wr_off +
-				gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
-	}
-	gpmc_t->wr_data_mux_bus = gpmc_round_ps_to_ticks(temp);
-
-	/* we_on */
-	if (gpmc_capability & GPMC_HAS_WR_DATA_MUX_BUS)
-		gpmc_t->we_on = gpmc_round_ps_to_ticks(dev_t->t_weasu);
-	else
-		gpmc_t->we_on = gpmc_t->wr_data_mux_bus;
-
-	/* we_off */
-	temp = gpmc_t->we_on + dev_t->t_wpl;
-	gpmc_t->we_off = gpmc_round_ps_to_ticks(temp);
-
-	gpmc_t->cs_wr_off = gpmc_round_ps_to_ticks(gpmc_t->we_off +
-							dev_t->t_wph);
-
-	/* wr_cycle */
-	temp = max_t(u32, dev_t->t_wr_cycle,
-				gpmc_t->cs_wr_off + dev_t->t_cez_w);
-	gpmc_t->wr_cycle = gpmc_round_ps_to_ticks(temp);
-
-	return 0;
-}
-
-static int gpmc_calc_sync_common_timings(struct gpmc_timings *gpmc_t,
-			struct gpmc_device_timings *dev_t)
-{
-	u32 temp;
-
-	gpmc_t->sync_clk = gpmc_calc_divider(dev_t->clk) *
-						gpmc_get_fclk_period();
-
-	gpmc_t->page_burst_access = gpmc_round_ps_to_sync_clk(
-					dev_t->t_bacc,
-					gpmc_t->sync_clk);
-
-	temp = max_t(u32, dev_t->t_ces, dev_t->t_avds);
-	gpmc_t->clk_activation = gpmc_round_ps_to_ticks(temp);
-
-	if (gpmc_calc_divider(gpmc_t->sync_clk) != 1)
-		return 0;
-
-	if (dev_t->ce_xdelay)
-		gpmc_t->bool_timings.cs_extra_delay = true;
-	if (dev_t->avd_xdelay)
-		gpmc_t->bool_timings.adv_extra_delay = true;
-	if (dev_t->oe_xdelay)
-		gpmc_t->bool_timings.oe_extra_delay = true;
-	if (dev_t->we_xdelay)
-		gpmc_t->bool_timings.we_extra_delay = true;
-
-	return 0;
-}
-
-static int gpmc_calc_common_timings(struct gpmc_timings *gpmc_t,
-				    struct gpmc_device_timings *dev_t,
-				    bool sync)
-{
-	u32 temp;
-
-	/* cs_on */
-	gpmc_t->cs_on = gpmc_round_ps_to_ticks(dev_t->t_ceasu);
-
-	/* adv_on */
-	temp = dev_t->t_avdasu;
-	if (dev_t->t_ce_avd)
-		temp = max_t(u32, temp,
-				gpmc_t->cs_on + dev_t->t_ce_avd);
-	gpmc_t->adv_on = gpmc_round_ps_to_ticks(temp);
-
-	if (sync)
-		gpmc_calc_sync_common_timings(gpmc_t, dev_t);
-
-	return 0;
-}
-
-/* TODO: remove this function once all peripherals are confirmed to
- * work with generic timing. Simultaneously gpmc_cs_set_timings()
- * has to be modified to handle timings in ps instead of ns
-*/
-static void gpmc_convert_ps_to_ns(struct gpmc_timings *t)
-{
-	t->cs_on /= 1000;
-	t->cs_rd_off /= 1000;
-	t->cs_wr_off /= 1000;
-	t->adv_on /= 1000;
-	t->adv_rd_off /= 1000;
-	t->adv_wr_off /= 1000;
-	t->we_on /= 1000;
-	t->we_off /= 1000;
-	t->oe_on /= 1000;
-	t->oe_off /= 1000;
-	t->page_burst_access /= 1000;
-	t->access /= 1000;
-	t->rd_cycle /= 1000;
-	t->wr_cycle /= 1000;
-	t->bus_turnaround /= 1000;
-	t->cycle2cycle_delay /= 1000;
-	t->wait_monitoring /= 1000;
-	t->clk_activation /= 1000;
-	t->wr_access /= 1000;
-	t->wr_data_mux_bus /= 1000;
-}
-
-static int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
-			     struct gpmc_settings *gpmc_s,
-			     struct gpmc_device_timings *dev_t)
-{
-	bool mux = false, sync = false;
-
-	if (gpmc_s) {
-		mux = gpmc_s->mux_add_data ? true : false;
-		sync = (gpmc_s->sync_read || gpmc_s->sync_write);
-	}
-
-	memset(gpmc_t, 0, sizeof(*gpmc_t));
-
-	gpmc_calc_common_timings(gpmc_t, dev_t, sync);
-
-	if (gpmc_s && gpmc_s->sync_read)
-		gpmc_calc_sync_read_timings(gpmc_t, dev_t, mux);
-	else
-		gpmc_calc_async_read_timings(gpmc_t, dev_t, mux);
-
-	if (gpmc_s && gpmc_s->sync_write)
-		gpmc_calc_sync_write_timings(gpmc_t, dev_t, mux);
-	else
-		gpmc_calc_async_write_timings(gpmc_t, dev_t, mux);
-
-	/* TODO: remove, see function definition */
-	gpmc_convert_ps_to_ns(gpmc_t);
-
-	return 0;
-}
-
-/**
- * gpmc_cs_program_settings - programs non-timing related settings
- * @cs:		GPMC chip-select to program
- * @p:		pointer to GPMC settings structure
- *
- * Programs non-timing related settings for a GPMC chip-select, such as
- * bus-width, burst configuration, etc. Function should be called once
- * for each chip-select that is being used and must be called before
- * calling gpmc_cs_set_timings() as timing parameters in the CONFIG1
- * register will be initialised to zero by this function. Returns 0 on
- * success and appropriate negative error code on failure.
- */
-static int gpmc_cs_program_settings(int cs, struct gpmc_settings *p)
-{
-	u32 config1;
-
-	if ((!p->device_width) || (p->device_width > GPMC_DEVWIDTH_16BIT)) {
-		pr_err("%s: invalid width %d!", __func__, p->device_width);
-		return -EINVAL;
-	}
-
-	/* Address-data multiplexing not supported for NAND devices */
-	if (p->device_nand && p->mux_add_data) {
-		pr_err("%s: invalid configuration!\n", __func__);
-		return -EINVAL;
-	}
-
-	if ((p->mux_add_data > GPMC_MUX_AD) ||
-	    ((p->mux_add_data == GPMC_MUX_AAD) &&
-	     !(gpmc_capability & GPMC_HAS_MUX_AAD))) {
-		pr_err("%s: invalid multiplex configuration!\n", __func__);
-		return -EINVAL;
-	}
-
-	/* Page/burst mode supports lengths of 4, 8 and 16 bytes */
-	if (p->burst_read || p->burst_write) {
-		switch (p->burst_len) {
-		case GPMC_BURST_4:
-		case GPMC_BURST_8:
-		case GPMC_BURST_16:
-			break;
-		default:
-			pr_err("%s: invalid page/burst-length (%d)\n",
-			       __func__, p->burst_len);
-			return -EINVAL;
-		}
-	}
-
-	if ((p->wait_on_read || p->wait_on_write) &&
-	    (p->wait_pin > gpmc_nr_waitpins)) {
-		pr_err("%s: invalid wait-pin (%d)\n", __func__, p->wait_pin);
-		return -EINVAL;
-	}
-
-	config1 = GPMC_CONFIG1_DEVICESIZE((p->device_width - 1));
-
-	if (p->sync_read)
-		config1 |= GPMC_CONFIG1_READTYPE_SYNC;
-	if (p->sync_write)
-		config1 |= GPMC_CONFIG1_WRITETYPE_SYNC;
-	if (p->wait_on_read)
-		config1 |= GPMC_CONFIG1_WAIT_READ_MON;
-	if (p->wait_on_write)
-		config1 |= GPMC_CONFIG1_WAIT_WRITE_MON;
-	if (p->wait_on_read || p->wait_on_write)
-		config1 |= GPMC_CONFIG1_WAIT_PIN_SEL(p->wait_pin);
-	if (p->device_nand)
-		config1	|= GPMC_CONFIG1_DEVICETYPE(GPMC_DEVICETYPE_NAND);
-	if (p->mux_add_data)
-		config1	|= GPMC_CONFIG1_MUXTYPE(p->mux_add_data);
-	if (p->burst_read)
-		config1 |= GPMC_CONFIG1_READMULTIPLE_SUPP;
-	if (p->burst_write)
-		config1 |= GPMC_CONFIG1_WRITEMULTIPLE_SUPP;
-	if (p->burst_read || p->burst_write) {
-		config1 |= GPMC_CONFIG1_PAGE_LEN(p->burst_len >> 3);
-		config1 |= p->burst_wrap ? GPMC_CONFIG1_WRAPBURST_SUPP : 0;
-	}
-
-	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, config1);
-
-	return 0;
-}
-
-#ifdef CONFIG_OF
-static struct of_device_id gpmc_dt_ids[] = {
-	{ .compatible = "ti,omap2420-gpmc" },
-	{ .compatible = "ti,omap2430-gpmc" },
-	{ .compatible = "ti,omap3430-gpmc" },	/* omap3430 & omap3630 */
-	{ .compatible = "ti,omap4430-gpmc" },	/* omap4430 & omap4460 & omap543x */
-	{ .compatible = "ti,am3352-gpmc" },	/* am335x devices */
-	{ }
-};
-MODULE_DEVICE_TABLE(of, gpmc_dt_ids);
-
-/**
- * gpmc_read_settings_dt - read gpmc settings from device-tree
- * @np:		pointer to device-tree node for a gpmc child device
- * @p:		pointer to gpmc settings structure
- *
- * Reads the GPMC settings for a GPMC child device from device-tree and
- * stores them in the GPMC settings structure passed. The GPMC settings
- * structure is initialised to zero by this function and so any
- * previously stored settings will be cleared.
- */
-static void gpmc_read_settings_dt(struct device_node *np,
-				  struct gpmc_settings *p)
-{
-	memset(p, 0, sizeof(struct gpmc_settings));
-
-	p->sync_read = of_property_read_bool(np, "gpmc,sync-read");
-	p->sync_write = of_property_read_bool(np, "gpmc,sync-write");
-	of_property_read_u32(np, "gpmc,device-width", &p->device_width);
-	of_property_read_u32(np, "gpmc,mux-add-data", &p->mux_add_data);
-
-	if (!of_property_read_u32(np, "gpmc,burst-length", &p->burst_len)) {
-		p->burst_wrap = of_property_read_bool(np, "gpmc,burst-wrap");
-		p->burst_read = of_property_read_bool(np, "gpmc,burst-read");
-		p->burst_write = of_property_read_bool(np, "gpmc,burst-write");
-		if (!p->burst_read && !p->burst_write)
-			pr_warn("%s: page/burst-length set but not used!\n",
-				__func__);
-	}
-
-	if (!of_property_read_u32(np, "gpmc,wait-pin", &p->wait_pin)) {
-		p->wait_on_read = of_property_read_bool(np,
-							"gpmc,wait-on-read");
-		p->wait_on_write = of_property_read_bool(np,
-							 "gpmc,wait-on-write");
-		if (!p->wait_on_read && !p->wait_on_write)
-			pr_warn("%s: read/write wait monitoring not enabled!\n",
-				__func__);
-	}
-}
-
-static void __maybe_unused gpmc_read_timings_dt(struct device_node *np,
-						struct gpmc_timings *gpmc_t)
-{
-	struct gpmc_bool_timings *p;
-
-	if (!np || !gpmc_t)
-		return;
-
-	memset(gpmc_t, 0, sizeof(*gpmc_t));
-
-	/* minimum clock period for syncronous mode */
-	of_property_read_u32(np, "gpmc,sync-clk-ps", &gpmc_t->sync_clk);
-
-	/* chip select timtings */
-	of_property_read_u32(np, "gpmc,cs-on-ns", &gpmc_t->cs_on);
-	of_property_read_u32(np, "gpmc,cs-rd-off-ns", &gpmc_t->cs_rd_off);
-	of_property_read_u32(np, "gpmc,cs-wr-off-ns", &gpmc_t->cs_wr_off);
-
-	/* ADV signal timings */
-	of_property_read_u32(np, "gpmc,adv-on-ns", &gpmc_t->adv_on);
-	of_property_read_u32(np, "gpmc,adv-rd-off-ns", &gpmc_t->adv_rd_off);
-	of_property_read_u32(np, "gpmc,adv-wr-off-ns", &gpmc_t->adv_wr_off);
-
-	/* WE signal timings */
-	of_property_read_u32(np, "gpmc,we-on-ns", &gpmc_t->we_on);
-	of_property_read_u32(np, "gpmc,we-off-ns", &gpmc_t->we_off);
-
-	/* OE signal timings */
-	of_property_read_u32(np, "gpmc,oe-on-ns", &gpmc_t->oe_on);
-	of_property_read_u32(np, "gpmc,oe-off-ns", &gpmc_t->oe_off);
-
-	/* access and cycle timings */
-	of_property_read_u32(np, "gpmc,page-burst-access-ns",
-			     &gpmc_t->page_burst_access);
-	of_property_read_u32(np, "gpmc,access-ns", &gpmc_t->access);
-	of_property_read_u32(np, "gpmc,rd-cycle-ns", &gpmc_t->rd_cycle);
-	of_property_read_u32(np, "gpmc,wr-cycle-ns", &gpmc_t->wr_cycle);
-	of_property_read_u32(np, "gpmc,bus-turnaround-ns",
-			     &gpmc_t->bus_turnaround);
-	of_property_read_u32(np, "gpmc,cycle2cycle-delay-ns",
-			     &gpmc_t->cycle2cycle_delay);
-	of_property_read_u32(np, "gpmc,wait-monitoring-ns",
-			     &gpmc_t->wait_monitoring);
-	of_property_read_u32(np, "gpmc,clk-activation-ns",
-			     &gpmc_t->clk_activation);
-
-	/* only applicable to OMAP3+ */
-	of_property_read_u32(np, "gpmc,wr-access-ns", &gpmc_t->wr_access);
-	of_property_read_u32(np, "gpmc,wr-data-mux-bus-ns",
-			     &gpmc_t->wr_data_mux_bus);
-
-	/* bool timing parameters */
-	p = &gpmc_t->bool_timings;
-
-	p->cycle2cyclediffcsen =
-		of_property_read_bool(np, "gpmc,cycle2cycle-diffcsen");
-	p->cycle2cyclesamecsen =
-		of_property_read_bool(np, "gpmc,cycle2cycle-samecsen");
-	p->we_extra_delay = of_property_read_bool(np, "gpmc,we-extra-delay");
-	p->oe_extra_delay = of_property_read_bool(np, "gpmc,oe-extra-delay");
-	p->adv_extra_delay = of_property_read_bool(np, "gpmc,adv-extra-delay");
-	p->cs_extra_delay = of_property_read_bool(np, "gpmc,cs-extra-delay");
-	p->time_para_granularity =
-		of_property_read_bool(np, "gpmc,time-para-granularity");
-}
-
-/**
- * gpmc_probe_generic_child - configures the gpmc for a child device
- * @pdev:	pointer to gpmc platform device
- * @child:	pointer to device-tree node for child device
- *
- * Allocates and configures a GPMC chip-select for a child device.
- * Returns 0 on success and appropriate negative error code on failure.
- */
-static int gpmc_probe_generic_child(struct platform_device *pdev,
-				struct device_node *child)
-{
-	struct gpmc_settings gpmc_s;
-	struct gpmc_timings gpmc_t;
-	struct resource res;
-	unsigned long base;
-	int ret, cs;
-	struct device *dev = &pdev->dev;
-
-	if (of_property_read_u32(child, "reg", &cs) < 0) {
-		dev_err(&pdev->dev, "%s has no 'reg' property\n",
-			child->full_name);
-		return -ENODEV;
-	}
-
-	if (of_address_to_resource(child, 0, &res) < 0) {
-		dev_err(&pdev->dev, "%s has malformed 'reg' property\n",
-			child->full_name);
-		return -ENODEV;
-	}
-
-	ret = gpmc_cs_request(cs, resource_size(&res), &base);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot request GPMC CS %d\n", cs);
-		return ret;
-	}
-
-	/*
-	 * For some GPMC devices we still need to rely on the bootloader
-	 * timings because the devices can be connected via FPGA. So far
-	 * the list is smc91x on the omap2 SDP boards, and 8250 on zooms.
-	 * REVISIT: Add timing support from slls644g.pdf and from the
-	 * lan91c96 manual.
-	 */
-	if (of_device_is_compatible(child, "ns16550a") ||
-	    of_device_is_compatible(child, "smsc,lan91c94") ||
-	    of_device_is_compatible(child, "smsc,lan91c111")) {
-		dev_warn(&pdev->dev,
-			 "%s using bootloader timings on CS%d\n",
-			 child->name, cs);
-		goto no_timings;
-	}
-
-	/*
-	 * FIXME: gpmc_cs_request() will map the CS to an arbitary
-	 * location in the gpmc address space. When booting with
-	 * device-tree we want the NOR flash to be mapped to the
-	 * location specified in the device-tree blob. So remap the
-	 * CS to this location. Once DT migration is complete should
-	 * just make gpmc_cs_request() map a specific address.
-	 */
-	ret = gpmc_cs_remap(cs, res.start);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot remap GPMC CS %d to %pa\n",
-			cs, &res.start);
-		goto err;
-	}
-
-	gpmc_read_settings_dt(child, &gpmc_s);
-
-	if (of_node_cmp(child->name, "nand") == 0) {
-		/* NAND specific setup */
-		u32 val;
-
-		val = of_get_nand_bus_width(child);
-		switch (val) {
-		case 8:
-			gpmc_s.device_width = GPMC_DEVWIDTH_8BIT;
-			break;
-		case 16:
-			gpmc_s.device_width = GPMC_DEVWIDTH_16BIT;
-			break;
-		default:
-			dev_err(dev, "%s: invalid 'nand-bus-width'\n",
-				child->name);
-			ret = -EINVAL;
-			goto err;
-		}
-
-		gpmc_s.device_nand = true;
-
-	} else if (of_node_cmp(child->name, "onenand") == 0) {
-		/* DT incorrectly sets sync modes, onenand default is async */
-		gpmc_s.sync_read = false;
-		gpmc_s.sync_write = false;
-
-	} else {
-		if (of_property_read_u32(child, "bank-width",
-					 &gpmc_s.device_width)) {
-			dev_err(dev, "%s: no 'bank-width' property\n",
-				child->name);
-			goto err;
-		}
-
-		if (gpmc_s.device_width < 1 || gpmc_s.device_width > 2) {
-			dev_err(dev, "%s: invalid 'bank-width'\n",
-				child->name);
-			goto err;
-		}
-	}
-
-	ret = gpmc_cs_program_settings(cs, &gpmc_s);
-	if (ret < 0)
-		goto err;
-
-	gpmc_read_timings_dt(child, &gpmc_t);
-	gpmc_cs_set_timings(cs, &gpmc_t);
-
-no_timings:
-	if (of_platform_device_create(child, NULL, &pdev->dev))
-		return 0;
-
-	dev_err(&pdev->dev, "failed to create gpmc child %s\n", child->name);
-	ret = -ENODEV;
-
-err:
-	gpmc_cs_free(cs);
-
-	return ret;
-}
-
-static int gpmc_probe_dt(struct platform_device *pdev)
-{
-	int ret;
-	struct device_node *child;
-
-	ret = of_property_read_u32(pdev->dev.of_node, "gpmc,num-cs",
-				   &gpmc_cs_num);
-	if (ret < 0) {
-		pr_err("%s: number of chip-selects not defined\n", __func__);
-		return ret;
-	} else if (gpmc_cs_num < 1) {
-		pr_err("%s: all chip-selects are disabled\n", __func__);
-		return -EINVAL;
-	} else if (gpmc_cs_num > GPMC_CS_NUM) {
-		pr_err("%s: number of supported chip-selects cannot be > %d\n",
-					 __func__, GPMC_CS_NUM);
-		return -EINVAL;
-	}
-
-	ret = of_property_read_u32(pdev->dev.of_node, "gpmc,num-waitpins",
-				   &gpmc_nr_waitpins);
-	if (ret < 0) {
-		pr_err("%s: number of wait pins not found!\n", __func__);
-		return ret;
-	}
-
-	for_each_child_of_node(pdev->dev.of_node, child) {
-
-		if (!child->name)
-			continue;
-
-		if (of_node_cmp(child->name, "ethernet") == 0 ||
-		    of_node_cmp(child->name, "nor") == 0 ||
-		    of_node_cmp(child->name, "uart") == 0 ||
-		    of_node_cmp(child->name, "nand") == 0 ||
-		    of_node_cmp(child->name, "onenand") == 0)
-			ret = gpmc_probe_generic_child(pdev, child);
-
-		if (WARN(ret < 0, "%s: probing gpmc child %s failed\n",
-			 __func__, child->full_name))
-			of_node_put(child);
-	}
-
-	return 0;
-}
-#else
-static int gpmc_probe_dt(struct platform_device *pdev)
-{
-	return 0;
-}
-#endif
-
-static int gpmc_nand_setup(struct platform_device *parent_pdev,
-			   struct gpmc_omap_cs_data *cs)
-{
-	struct resource *res;
-	struct resource *res_gpmc;
-
-	if (!cs->pdev)
-		return -EINVAL;
-
-	res = cs->pdev->resource;
-
-	if (cs->pdev->num_resources < 3)
-		return -EINVAL;
-
-	if (resource_type(&res[1]) != IORESOURCE_MEM ||
-	    resource_type(&res[2]) != IORESOURCE_IRQ)
-		return -EINVAL;
-
-	if (!cs->settings)
-		return -EINVAL;
-
-	/* GPMC register space */
-	res_gpmc = platform_get_resource(parent_pdev, IORESOURCE_MEM, 0);
-	if (!res_gpmc)
-		return -EINVAL;
-
-	res[1] = *res_gpmc;
-
-	/* setup IRQ resources */
-	res[2].start = gpmc_irq;
-
-	cs->settings->device_nand = true;
-
-	return 0;
-}
-
-static void gpmc_probe_legacy(struct platform_device *pdev)
-{
-	int i, rc, j;
-	struct device *dev = &pdev->dev;
-	struct gpmc_omap_platform_data *gpmc_pdata;
-	struct resource *mem_res;
-	unsigned long cs_base;
-	resource_size_t size;
-	struct gpmc_timings gpmc_timings;
-	struct gpmc_omap_cs_data *cs;
-
-	gpmc_pdata = dev->platform_data;
-	gpmc_cs_num = GPMC_CS_NUM;
-	gpmc_nr_waitpins = GPMC_NR_WAITPINS;
-
-	for (i = 0; i < GPMC_CS_NUM; i++) {
-		cs = &gpmc_pdata->cs[i];
-		if (!cs->valid)
-			continue;
-
-		if (cs->settings) {
-			if (gpmc_cs_program_settings(i, cs->settings)) {
-				dev_err(dev,
-					"Couldn't program settings for CS %d\n",
-					i);
-				continue;
-			}
-		}
-
-		/* give device_timings priority over gpmc_timings */
-		if (cs->device_timings) {
-			gpmc_calc_timings(&gpmc_timings, cs->settings,
-					  cs->device_timings);
-
-			if (gpmc_cs_set_timings(i, &gpmc_timings)) {
-				dev_err(dev,
-					"Couldn't program timings for CS %d\n",
-					i);
-				continue;
-			}
-		} else if (cs->gpmc_timings) {
-			if (gpmc_cs_set_timings(i, cs->gpmc_timings)) {
-				dev_err(dev,
-					"Couldn't program timings for CS %d\n",
-					i);
-				continue;
-			}
-		}
-	}
-
-	/*
-	 * All Chip Selects must be configured before platform devices are
-	 * created as some devices (e.g. tusb6010) can use multiple
-	 * Chip selects.
-	 */
-
-	/* Fixup Memory resources */
-	for (i = 0; i < GPMC_CS_NUM; i++) {
-		int required_resources;
-
-		cs = &gpmc_pdata->cs[i];
-		if (!cs->valid)
-			continue;
-
-		if (!cs->pdev)
-			continue;
-
-		/* Customized NAND setup */
-		if (cs->is_nand) {
-			if (gpmc_nand_setup(pdev, cs)) {
-				dev_err(dev, "Error setting up NAND on CS %d\n",
-					i);
-				continue;
-			}
-		}
-
-		mem_res = cs->pdev->resource;
-
-		/*
-		 * If device is present multiple times, fix the subsequent
-		 * resources
-		 */
-		required_resources = 1;
-		for (j = 0; j < i; j++) {
-			if (gpmc_pdata->cs[j].pdev == cs->pdev) {
-				mem_res++;
-				required_resources++;
-			}
-		}
-
-		if (cs->pdev->num_resources < required_resources ||
-		    resource_type(mem_res) != IORESOURCE_MEM) {
-			dev_err(dev, "Invalid IOMEM resource for CS %d\n", i);
-			continue;
-		}
-
-		/*
-		 * Request a CS space. Use size from
-		 * platform device's MEM resource
-		 */
-		size = mem_res->end - mem_res->start + 1;
-		if (gpmc_cs_request(i, size, &cs_base)) {
-			dev_err(dev, "Couldn't request resource for CS %d\n",
-				i);
-			continue;
-		}
-
-		mem_res->start = cs_base;
-		mem_res->end = cs_base + size - 1;
-	}
-
-	/* create the platform devices */
-	for (i = 0; i < GPMC_CS_NUM; i++) {
-		bool registered;
-
-		cs = &gpmc_pdata->cs[i];
-		if (!cs->valid)
-			continue;
-
-		if (!cs->pdev)
-			continue;
-
-		/*
-		 * same device can be present on multiple CS, don't
-		 * register device more than once.
-		 */
-		registered = false;
-		for (j = 0; j < i; j++) {
-			if (gpmc_pdata->cs[j].pdev == cs->pdev) {
-				registered = true;
-				break;
-			}
-		}
-
-		if (registered)
-			continue;
-
-		cs->pdev->dev.parent = dev;
-		rc = platform_device_register(cs->pdev);
-		if (rc < 0) {
-			dev_err(dev,
-				"Failed to register device %s on CS %d\n",
-				cs->pdev->name, i);
-			continue;
-		}
-	}
-}
-
-static int gpmc_probe(struct platform_device *pdev)
-{
-	int rc;
-	u32 l;
-	struct resource *res;
-	struct device *dev = &pdev->dev;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL)
-		return -ENOENT;
-
-	phys_base = res->start;
-	mem_size = resource_size(res);
-
-	gpmc_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(gpmc_base))
-		return PTR_ERR(gpmc_base);
-
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Failed to get resource: irq\n");
-		return -EINVAL;
-	}
-
-	gpmc_irq = res->start;
-
-	gpmc_l3_clk = clk_get(&pdev->dev, "fck");
-	if (IS_ERR(gpmc_l3_clk)) {
-		dev_err(&pdev->dev, "error: clk_get\n");
-		gpmc_irq = 0;
-		return PTR_ERR(gpmc_l3_clk);
-	}
-
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
-
-	gpmc_dev = dev;
-
-	l = gpmc_read_reg(GPMC_REVISION);
-
-	/*
-	 * FIXME: Once device-tree migration is complete the below flags
-	 * should be populated based upon the device-tree compatible
-	 * string. For now just use the IP revision. OMAP3+ devices have
-	 * the wr_access and wr_data_mux_bus register fields. OMAP4+
-	 * devices support the addr-addr-data multiplex protocol.
-	 *
-	 * GPMC IP revisions:
-	 * - OMAP24xx			= 2.0
-	 * - OMAP3xxx			= 5.0
-	 * - OMAP44xx/54xx/AM335x	= 6.0
-	 */
-	if (GPMC_REVISION_MAJOR(l) > 0x4)
-		gpmc_capability = GPMC_HAS_WR_ACCESS | GPMC_HAS_WR_DATA_MUX_BUS;
-	if (GPMC_REVISION_MAJOR(l) > 0x5)
-		gpmc_capability |= GPMC_HAS_MUX_AAD;
-	dev_info(dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
-		 GPMC_REVISION_MINOR(l));
-
-	gpmc_mem_init();
-
-	/* Now the GPMC is initialised, unreserve the chip-selects */
-	gpmc_cs_map = 0;
-
-	if (dev->of_node) {
-		rc = gpmc_probe_dt(pdev);
-		if (rc) {
-			dev_err(dev, "gpmc_probe_dt() failed\n");
-			goto error;
-		}
-	} else {
-		/* Legacy probing based on platform data */
-		if (!dev->platform_data) {
-			dev_err(dev, "No platform data\n");
-			rc = -EINVAL;
-			goto error;
-		}
-
-		gpmc_probe_legacy(pdev);
-	}
-
-	return 0;
-
-error:
-	pm_runtime_put_sync(dev);
-	clk_put(gpmc_l3_clk);
-	return rc;
-}
-
-static int gpmc_remove(struct platform_device *pdev)
-{
-	gpmc_mem_exit();
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-	gpmc_dev = NULL;
-	return 0;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static int gpmc_suspend(struct device *dev)
-{
-	omap3_gpmc_save_context();
-	pm_runtime_put_sync(dev);
-	return 0;
-}
-
-static int gpmc_resume(struct device *dev)
-{
-	pm_runtime_get_sync(dev);
-	omap3_gpmc_restore_context();
-	return 0;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(gpmc_pm_ops, gpmc_suspend, gpmc_resume);
-
-static struct platform_driver gpmc_driver = {
-	.probe		= gpmc_probe,
-	.remove		= gpmc_remove,
-	.driver		= {
-		.name	= DEVICE_NAME,
-		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(gpmc_dt_ids),
-		.pm	= &gpmc_pm_ops,
-	},
-};
-
-static __init int gpmc_init(void)
-{
-	return platform_driver_register(&gpmc_driver);
-}
-
-static __exit void gpmc_exit(void)
-{
-	platform_driver_unregister(&gpmc_driver);
-
-}
-
-module_init(gpmc_init);
-module_exit(gpmc_exit);
-
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
-/**
- * omap_gpmc_retime - Reconfigre GPMC timings for the device
- *
- * @cs		Chip select number
- * @gpmc_s	GPMC settings
- * @dev_t	New device timings to set
- */
-int omap_gpmc_retime(int cs, struct gpmc_settings *gpmc_s,
-		     struct gpmc_device_timings *dev_t)
-{
-	struct gpmc_timings gpmc_t;
-	struct device *dev = gpmc_dev;
-
-	if (!gpmc_dev)
-		return -ENODEV;
-
-	if (cs < 0 || cs >= gpmc_cs_num) {
-		dev_err(dev, "%s: Invalid find Chip Select\n", __func__);
-		return cs;
-	}
-
-	if (gpmc_cs_program_settings(cs, gpmc_s)) {
-		dev_err(dev, "%s: Failed to set GPMC settings\n", __func__);
-		return -EINVAL;
-	}
-
-	gpmc_calc_timings(&gpmc_t, gpmc_s, dev_t);
-	if (gpmc_cs_set_timings(cs, &gpmc_t)) {
-		dev_err(dev, "%s: Failed to set GPMC timings\n", __func__);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(omap_gpmc_retime);
-
-/**
- * omap_gpmc_get_clk_period - Get the nearest possible (equal to or higer) GPMC
- *				synchronous clock (GPMC_CLK) period.
- *
- * @cs		Chip select number
- * @min_ps	Minimum synchronous clock period supporded by the device
- *
- * Returns the nearest possible GPMC clock period in picoseconds, equal to or
- * higher than the requested period. 0 in case of error.
- */
-unsigned long omap_gpmc_get_clk_period(int cs,
-				       unsigned long min_ps)
-{
-	int div;
-	unsigned long clk_ps;
-	struct device *dev = gpmc_dev;
-
-	if (!gpmc_dev)
-		return 0;
-
-	if (cs < 0 || cs >= gpmc_cs_num) {
-		dev_err(dev, "%s: Invalid Chip Select\n", __func__);
-		return cs;
-	}
-
-	div = gpmc_calc_divider(min_ps);
-	if (div < 0) {
-		dev_err(dev, "%s: Can't support requested clock period %lu ps\n",
-			__func__, min_ps);
-		return 0;
-	}
-
-	clk_ps = gpmc_get_fclk_period() * div;
-
-	return clk_ps;
-}
-EXPORT_SYMBOL_GPL(omap_gpmc_get_clk_period);
-
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
diff --git a/drivers/memory/ti-gpmc.c b/drivers/memory/ti-gpmc.c
new file mode 100644
index 0000000..3bb2fd6
--- /dev/null
+++ b/drivers/memory/ti-gpmc.c
@@ -0,0 +1,1829 @@
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
+#undef DEBUG
+
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/ioport.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_mtd.h>
+#include <linux/of_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#include <linux/platform_data/mtd-nand-omap2.h>
+#include <linux/platform_data/gpmc-omap.h>
+
+#define	DEVICE_NAME		"omap-gpmc"
+
+/* GPMC register offsets */
+#define GPMC_REVISION		0x00
+#define GPMC_SYSCONFIG		0x10
+#define GPMC_SYSSTATUS		0x14
+#define GPMC_IRQSTATUS		0x18
+#define GPMC_IRQENABLE		0x1c
+#define GPMC_TIMEOUT_CONTROL	0x40
+#define GPMC_ERR_ADDRESS	0x44
+#define GPMC_ERR_TYPE		0x48
+#define GPMC_CONFIG		0x50
+#define GPMC_STATUS		0x54
+#define GPMC_PREFETCH_CONFIG1	0x1e0
+#define GPMC_PREFETCH_CONFIG2	0x1e4
+#define GPMC_PREFETCH_CONTROL	0x1ec
+#define GPMC_PREFETCH_STATUS	0x1f0
+#define GPMC_ECC_CONFIG		0x1f4
+#define GPMC_ECC_CONTROL	0x1f8
+#define GPMC_ECC_SIZE_CONFIG	0x1fc
+#define GPMC_ECC1_RESULT        0x200
+#define GPMC_ECC_BCH_RESULT_0   0x240   /* not available on OMAP2 */
+#define	GPMC_ECC_BCH_RESULT_1	0x244	/* not available on OMAP2 */
+#define	GPMC_ECC_BCH_RESULT_2	0x248	/* not available on OMAP2 */
+#define	GPMC_ECC_BCH_RESULT_3	0x24c	/* not available on OMAP2 */
+
+/* GPMC ECC control settings */
+#define GPMC_ECC_CTRL_ECCCLEAR		0x100
+#define GPMC_ECC_CTRL_ECCDISABLE	0x000
+#define GPMC_ECC_CTRL_ECCREG1		0x001
+#define GPMC_ECC_CTRL_ECCREG2		0x002
+#define GPMC_ECC_CTRL_ECCREG3		0x003
+#define GPMC_ECC_CTRL_ECCREG4		0x004
+#define GPMC_ECC_CTRL_ECCREG5		0x005
+#define GPMC_ECC_CTRL_ECCREG6		0x006
+#define GPMC_ECC_CTRL_ECCREG7		0x007
+#define GPMC_ECC_CTRL_ECCREG8		0x008
+#define GPMC_ECC_CTRL_ECCREG9		0x009
+
+/* ECC commands */
+#define GPMC_ECC_READ		0 /* Reset Hardware ECC for read */
+#define GPMC_ECC_WRITE		1 /* Reset Hardware ECC for write */
+#define GPMC_ECC_READSYN	2 /* Reset before syndrom is read back */
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
+#define GPMC_CONFIG1_WRAPBURST_SUPP     (1 << 31)
+#define GPMC_CONFIG1_READMULTIPLE_SUPP  (1 << 30)
+#define GPMC_CONFIG1_READTYPE_ASYNC     (0 << 29)
+#define GPMC_CONFIG1_READTYPE_SYNC      (1 << 29)
+#define GPMC_CONFIG1_WRITEMULTIPLE_SUPP (1 << 28)
+#define GPMC_CONFIG1_WRITETYPE_ASYNC    (0 << 27)
+#define GPMC_CONFIG1_WRITETYPE_SYNC     (1 << 27)
+#define GPMC_CONFIG1_CLKACTIVATIONTIME(val) ((val & 3) << 25)
+#define GPMC_CONFIG1_PAGE_LEN(val)      ((val & 3) << 23)
+#define GPMC_CONFIG1_WAIT_READ_MON      (1 << 22)
+#define GPMC_CONFIG1_WAIT_WRITE_MON     (1 << 21)
+#define GPMC_CONFIG1_WAIT_MON_IIME(val) ((val & 3) << 18)
+#define GPMC_CONFIG1_WAIT_PIN_SEL(val)  ((val & 3) << 16)
+#define GPMC_CONFIG1_DEVICESIZE(val)    ((val & 3) << 12)
+#define GPMC_CONFIG1_DEVICESIZE_16      GPMC_CONFIG1_DEVICESIZE(1)
+#define GPMC_CONFIG1_DEVICETYPE(val)    ((val & 3) << 10)
+#define GPMC_CONFIG1_DEVICETYPE_NOR     GPMC_CONFIG1_DEVICETYPE(0)
+#define GPMC_CONFIG1_MUXTYPE(val)       ((val & 3) << 8)
+#define GPMC_CONFIG1_TIME_PARA_GRAN     (1 << 4)
+#define GPMC_CONFIG1_FCLK_DIV(val)      (val & 3)
+#define GPMC_CONFIG1_FCLK_DIV2          (GPMC_CONFIG1_FCLK_DIV(1))
+#define GPMC_CONFIG1_FCLK_DIV3          (GPMC_CONFIG1_FCLK_DIV(2))
+#define GPMC_CONFIG1_FCLK_DIV4          (GPMC_CONFIG1_FCLK_DIV(3))
+#define GPMC_CONFIG7_CSVALID		(1 << 6)
+
+#define	GPMC_CONFIG2_CSEXTRADELAY		BIT(7)
+#define	GPMC_CONFIG3_ADVEXTRADELAY		BIT(7)
+#define	GPMC_CONFIG4_OEEXTRADELAY		BIT(7)
+#define	GPMC_CONFIG4_WEEXTRADELAY		BIT(23)
+#define	GPMC_CONFIG6_CYCLE2CYCLEDIFFCSEN	BIT(6)
+#define	GPMC_CONFIG6_CYCLE2CYCLESAMECSEN	BIT(7)
+
+#define GPMC_DEVICETYPE_NOR		0
+#define GPMC_DEVICETYPE_NAND		2
+#define WR_RD_PIN_MONITORING		0x00600000
+#define GPMC_IRQ_FIFOEVENTENABLE	0x01
+#define GPMC_IRQ_COUNT_EVENT		0x02
+
+#define GPMC_CS0_OFFSET		0x60
+#define GPMC_CS_SIZE		0x30
+#define	GPMC_BCH_SIZE		0x10
+
+#define GPMC_MEM_END		0x3FFFFFFF
+
+#define GPMC_CHUNK_SHIFT	24		/* 16 MB */
+#define GPMC_SECTION_SHIFT	28		/* 128 MB */
+
+#define CS_NUM_SHIFT		24
+#define ENABLE_PREFETCH		(0x1 << 7)
+#define DMA_MPU_MODE		2
+
+#define	GPMC_REVISION_MAJOR(l)		((l >> 4) & 0xf)
+#define	GPMC_REVISION_MINOR(l)		(l & 0xf)
+
+#define	GPMC_HAS_WR_ACCESS		0x1
+#define	GPMC_HAS_WR_DATA_MUX_BUS	0x2
+#define	GPMC_HAS_MUX_AAD		0x4
+
+#define GPMC_NR_WAITPINS		4
+
+static struct resource	gpmc_mem_root;
+static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
+static DEFINE_SPINLOCK(gpmc_mem_lock);
+/* Define chip-selects as reserved by default until probe completes */
+static unsigned int gpmc_cs_map = ((1 << GPMC_CS_NUM) - 1);
+static unsigned int gpmc_cs_num = GPMC_CS_NUM;
+static unsigned int gpmc_nr_waitpins;
+static struct device *gpmc_dev;
+static int gpmc_irq = -EINVAL;
+static resource_size_t phys_base, mem_size;
+static unsigned gpmc_capability;
+static void __iomem *gpmc_base;
+
+static struct clk *gpmc_l3_clk;
+
+static void gpmc_write_reg(int idx, u32 val)
+{
+	__raw_writel(val, gpmc_base + idx);
+}
+
+static u32 gpmc_read_reg(int idx)
+{
+	return __raw_readl(gpmc_base + idx);
+}
+
+static void gpmc_cs_write_reg(int cs, int idx, u32 val)
+{
+	void __iomem *reg_addr;
+
+	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	__raw_writel(val, reg_addr);
+}
+
+static u32 gpmc_cs_read_reg(int cs, int idx)
+{
+	void __iomem *reg_addr;
+
+	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	return __raw_readl(reg_addr);
+}
+
+/* TODO: Add support for gpmc_fck to clock framework and use it */
+static unsigned long gpmc_get_fclk_period(void)
+{
+	unsigned long rate = clk_get_rate(gpmc_l3_clk);
+
+	if (rate == 0) {
+		pr_warn("%s: gpmc_l3_clk not enabled\n", __func__);
+		return 0;
+	}
+
+	rate /= 1000;
+	rate = 1000000000 / rate;	/* In picoseconds */
+
+	return rate;
+}
+
+static unsigned int gpmc_ns_to_ticks(unsigned int time_ns)
+{
+	unsigned long tick_ps;
+
+	/* Calculate in picosecs to yield more exact results */
+	tick_ps = gpmc_get_fclk_period();
+
+	return (time_ns * 1000 + tick_ps - 1) / tick_ps;
+}
+
+static unsigned int gpmc_ps_to_ticks(unsigned int time_ps)
+{
+	unsigned long tick_ps;
+
+	/* Calculate in picosecs to yield more exact results */
+	tick_ps = gpmc_get_fclk_period();
+
+	return (time_ps + tick_ps - 1) / tick_ps;
+}
+
+static unsigned int gpmc_ticks_to_ps(unsigned int ticks)
+{
+	return ticks * gpmc_get_fclk_period();
+}
+
+static unsigned int gpmc_round_ps_to_ticks(unsigned int time_ps)
+{
+	unsigned long ticks = gpmc_ps_to_ticks(time_ps);
+
+	return ticks * gpmc_get_fclk_period();
+}
+
+static inline void gpmc_cs_modify_reg(int cs, int reg, u32 mask, bool value)
+{
+	u32 l;
+
+	l = gpmc_cs_read_reg(cs, reg);
+	if (value)
+		l |= mask;
+	else
+		l &= ~mask;
+	gpmc_cs_write_reg(cs, reg, l);
+}
+
+static void gpmc_cs_bool_timings(int cs, const struct gpmc_bool_timings *p)
+{
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG1,
+			   GPMC_CONFIG1_TIME_PARA_GRAN,
+			   p->time_para_granularity);
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG2,
+			   GPMC_CONFIG2_CSEXTRADELAY, p->cs_extra_delay);
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG3,
+			   GPMC_CONFIG3_ADVEXTRADELAY, p->adv_extra_delay);
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG4,
+			   GPMC_CONFIG4_OEEXTRADELAY, p->oe_extra_delay);
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG4,
+			   GPMC_CONFIG4_OEEXTRADELAY, p->we_extra_delay);
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG6,
+			   GPMC_CONFIG6_CYCLE2CYCLESAMECSEN,
+			   p->cycle2cyclesamecsen);
+	gpmc_cs_modify_reg(cs, GPMC_CS_CONFIG6,
+			   GPMC_CONFIG6_CYCLE2CYCLEDIFFCSEN,
+			   p->cycle2cyclediffcsen);
+}
+
+#ifdef DEBUG
+static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
+			       int time, const char *name)
+#else
+static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
+			       int time)
+#endif
+{
+	u32 l;
+	int ticks, mask, nr_bits;
+
+	if (time == 0)
+		ticks = 0;
+	else
+		ticks = gpmc_ns_to_ticks(time);
+	nr_bits = end_bit - st_bit + 1;
+	if (ticks >= 1 << nr_bits) {
+#ifdef DEBUG
+		pr_info("GPMC CS%d: %-10s* %3d ns, %3d ticks >= %d\n",
+			cs, name, time, ticks, 1 << nr_bits);
+#endif
+		return -1;
+	}
+
+	mask = (1 << nr_bits) - 1;
+	l = gpmc_cs_read_reg(cs, reg);
+#ifdef DEBUG
+	pr_info("GPMC CS%d: %-10s: %3d ticks, %3lu ns (was %3i ticks) %3d ns\n",
+		cs, name, ticks, gpmc_get_fclk_period() * ticks / 1000,
+		(l >> st_bit) & mask, time);
+#endif
+	l &= ~(mask << st_bit);
+	l |= ticks << st_bit;
+	gpmc_cs_write_reg(cs, reg, l);
+
+	return 0;
+}
+
+#ifdef DEBUG
+#define GPMC_SET_ONE(reg, st, end, field) \
+	set_gpmc_timing_reg(cs, (reg), (st), (end),		\
+			t->field, #field)
+#else
+#define GPMC_SET_ONE(reg, st, end, field) \
+	set_gpmc_timing_reg(cs, (reg), (st), (end), t->field)
+#endif
+
+static int gpmc_calc_divider(unsigned int sync_clk)
+{
+	int div;
+	u32 l;
+
+	l = sync_clk + (gpmc_get_fclk_period() - 1);
+	div = l / gpmc_get_fclk_period();
+	if (div > 4)
+		return -1;
+	if (div <= 0)
+		div = 1;
+
+	return div;
+}
+
+static int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t)
+{
+	int div;
+	u32 l;
+
+	div = gpmc_calc_divider(t->sync_clk);
+	if (div < 0)
+		return div;
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG2,  0,  3, cs_on);
+	GPMC_SET_ONE(GPMC_CS_CONFIG2,  8, 12, cs_rd_off);
+	GPMC_SET_ONE(GPMC_CS_CONFIG2, 16, 20, cs_wr_off);
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG3,  0,  3, adv_on);
+	GPMC_SET_ONE(GPMC_CS_CONFIG3,  8, 12, adv_rd_off);
+	GPMC_SET_ONE(GPMC_CS_CONFIG3, 16, 20, adv_wr_off);
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG4,  0,  3, oe_on);
+	GPMC_SET_ONE(GPMC_CS_CONFIG4,  8, 12, oe_off);
+	GPMC_SET_ONE(GPMC_CS_CONFIG4, 16, 19, we_on);
+	GPMC_SET_ONE(GPMC_CS_CONFIG4, 24, 28, we_off);
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG5,  0,  4, rd_cycle);
+	GPMC_SET_ONE(GPMC_CS_CONFIG5,  8, 12, wr_cycle);
+	GPMC_SET_ONE(GPMC_CS_CONFIG5, 16, 20, access);
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG5, 24, 27, page_burst_access);
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG6, 0, 3, bus_turnaround);
+	GPMC_SET_ONE(GPMC_CS_CONFIG6, 8, 11, cycle2cycle_delay);
+
+	GPMC_SET_ONE(GPMC_CS_CONFIG1, 18, 19, wait_monitoring);
+	GPMC_SET_ONE(GPMC_CS_CONFIG1, 25, 26, clk_activation);
+
+	if (gpmc_capability & GPMC_HAS_WR_DATA_MUX_BUS)
+		GPMC_SET_ONE(GPMC_CS_CONFIG6, 16, 19, wr_data_mux_bus);
+	if (gpmc_capability & GPMC_HAS_WR_ACCESS)
+		GPMC_SET_ONE(GPMC_CS_CONFIG6, 24, 28, wr_access);
+
+	/* caller is expected to have initialized CONFIG1 to cover
+	 * at least sync vs async
+	 */
+	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
+	if (l & (GPMC_CONFIG1_READTYPE_SYNC | GPMC_CONFIG1_WRITETYPE_SYNC)) {
+#ifdef DEBUG
+		pr_info("GPMC CS%d CLK period is %lu ns (div %d)\n",
+			cs, (div * gpmc_get_fclk_period()) / 1000, div);
+#endif
+		l &= ~0x03;
+		l |= (div - 1);
+		gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, l);
+	}
+
+	gpmc_cs_bool_timings(cs, &t->bool_timings);
+
+	return 0;
+}
+
+static int gpmc_cs_enable_mem(int cs, u32 base, u32 size)
+{
+	u32 l;
+	u32 mask;
+
+	/*
+	 * Ensure that base address is aligned on a
+	 * boundary equal to or greater than size.
+	 */
+	if (base & (size - 1))
+		return -EINVAL;
+
+	mask = (1 << GPMC_SECTION_SHIFT) - size;
+	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
+	l &= ~0x3f;
+	l = (base >> GPMC_CHUNK_SHIFT) & 0x3f;
+	l &= ~(0x0f << 8);
+	l |= ((mask >> GPMC_CHUNK_SHIFT) & 0x0f) << 8;
+	l |= GPMC_CONFIG7_CSVALID;
+	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG7, l);
+
+	return 0;
+}
+
+static void gpmc_cs_disable_mem(int cs)
+{
+	u32 l;
+
+	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
+	l &= ~GPMC_CONFIG7_CSVALID;
+	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG7, l);
+}
+
+static void gpmc_cs_get_memconf(int cs, u32 *base, u32 *size)
+{
+	u32 l;
+	u32 mask;
+
+	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
+	*base = (l & 0x3f) << GPMC_CHUNK_SHIFT;
+	mask = (l >> 8) & 0x0f;
+	*size = (1 << GPMC_SECTION_SHIFT) - (mask << GPMC_CHUNK_SHIFT);
+}
+
+static int gpmc_cs_mem_enabled(int cs)
+{
+	u32 l;
+
+	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
+	return l & GPMC_CONFIG7_CSVALID;
+}
+
+static void gpmc_cs_set_reserved(int cs, int reserved)
+{
+	gpmc_cs_map &= ~(1 << cs);
+	gpmc_cs_map |= (reserved ? 1 : 0) << cs;
+}
+
+static bool gpmc_cs_reserved(int cs)
+{
+	return gpmc_cs_map & (1 << cs);
+}
+
+static unsigned long gpmc_mem_align(unsigned long size)
+{
+	int order;
+
+	size = (size - 1) >> (GPMC_CHUNK_SHIFT - 1);
+	order = GPMC_CHUNK_SHIFT - 1;
+	do {
+		size >>= 1;
+		order++;
+	} while (size);
+	size = 1 << order;
+	return size;
+}
+
+static int gpmc_cs_insert_mem(int cs, unsigned long base, unsigned long size)
+{
+	struct resource	*res = &gpmc_cs_mem[cs];
+	int r;
+
+	size = gpmc_mem_align(size);
+	spin_lock(&gpmc_mem_lock);
+	res->start = base;
+	res->end = base + size - 1;
+	r = request_resource(&gpmc_mem_root, res);
+	spin_unlock(&gpmc_mem_lock);
+
+	return r;
+}
+
+static int gpmc_cs_delete_mem(int cs)
+{
+	struct resource	*res = &gpmc_cs_mem[cs];
+	int r;
+
+	spin_lock(&gpmc_mem_lock);
+	r = release_resource(res);
+	res->start = 0;
+	res->end = 0;
+	spin_unlock(&gpmc_mem_lock);
+
+	return r;
+}
+
+/**
+ * gpmc_cs_remap - remaps a chip-select physical base address
+ * @cs:		chip-select to remap
+ * @base:	physical base address to re-map chip-select to
+ *
+ * Re-maps a chip-select to a new physical base address specified by
+ * "base". Returns 0 on success and appropriate negative error code
+ * on failure.
+ */
+static int gpmc_cs_remap(int cs, u32 base)
+{
+	int ret;
+	u32 old_base, size;
+
+	if (cs > gpmc_cs_num) {
+		pr_err("%s: requested chip-select is disabled\n", __func__);
+		return -ENODEV;
+	}
+
+	/*
+	 * Make sure we ignore any device offsets from the GPMC partition
+	 * allocated for the chip select and that the new base confirms
+	 * to the GPMC 16MB minimum granularity.
+	 */
+	base &= ~(SZ_16M - 1);
+
+	gpmc_cs_get_memconf(cs, &old_base, &size);
+	if (base == old_base)
+		return 0;
+	gpmc_cs_disable_mem(cs);
+	ret = gpmc_cs_delete_mem(cs);
+	if (ret < 0)
+		return ret;
+	ret = gpmc_cs_insert_mem(cs, base, size);
+	if (ret < 0)
+		return ret;
+	ret = gpmc_cs_enable_mem(cs, base, size);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
+{
+	struct resource *res = &gpmc_cs_mem[cs];
+	int r = -1;
+
+	if (cs > gpmc_cs_num) {
+		pr_err("%s: requested chip-select is disabled\n", __func__);
+		return -ENODEV;
+	}
+	size = gpmc_mem_align(size);
+	if (size > (1 << GPMC_SECTION_SHIFT))
+		return -ENOMEM;
+
+	spin_lock(&gpmc_mem_lock);
+	if (gpmc_cs_reserved(cs)) {
+		r = -EBUSY;
+		goto out;
+	}
+	if (gpmc_cs_mem_enabled(cs))
+		r = adjust_resource(res, res->start & ~(size - 1), size);
+	if (r < 0)
+		r = allocate_resource(&gpmc_mem_root, res, size, 0, ~0,
+				      size, NULL, NULL);
+	if (r < 0)
+		goto out;
+
+	r = gpmc_cs_enable_mem(cs, res->start, resource_size(res));
+	if (r < 0) {
+		release_resource(res);
+		goto out;
+	}
+
+	*base = res->start;
+	gpmc_cs_set_reserved(cs, 1);
+out:
+	spin_unlock(&gpmc_mem_lock);
+	return r;
+}
+
+static void gpmc_cs_free(int cs)
+{
+	struct resource	*res = &gpmc_cs_mem[cs];
+
+	spin_lock(&gpmc_mem_lock);
+	if (cs >= gpmc_cs_num || cs < 0 || !gpmc_cs_reserved(cs)) {
+		pr_err("Trying to free non-reserved GPMC CS%d\n", cs);
+		BUG();
+		spin_unlock(&gpmc_mem_lock);
+		return;
+	}
+	gpmc_cs_disable_mem(cs);
+	if (res->flags)
+		release_resource(res);
+	gpmc_cs_set_reserved(cs, 0);
+	spin_unlock(&gpmc_mem_lock);
+}
+
+static void gpmc_mem_exit(void)
+{
+	int cs;
+
+	for (cs = 0; cs < gpmc_cs_num; cs++) {
+		if (!gpmc_cs_mem_enabled(cs))
+			continue;
+		gpmc_cs_delete_mem(cs);
+	}
+}
+
+static void gpmc_mem_init(void)
+{
+	int cs;
+
+	/*
+	 * The first 1MB of GPMC address space is typically mapped to
+	 * the internal ROM. Never allocate the first page, to
+	 * facilitate bug detection; even if we didn't boot from ROM.
+	 */
+	gpmc_mem_root.start = SZ_1M;
+	gpmc_mem_root.end = GPMC_MEM_END;
+
+	/* Reserve all regions that has been set up by bootloader */
+	for (cs = 0; cs < gpmc_cs_num; cs++) {
+		u32 base, size;
+
+		if (!gpmc_cs_mem_enabled(cs))
+			continue;
+		gpmc_cs_get_memconf(cs, &base, &size);
+		if (gpmc_cs_insert_mem(cs, base, size)) {
+			pr_warn("%s: disabling cs %d mapped at 0x%x-0x%x\n",
+				__func__, cs, base, base + size);
+			gpmc_cs_disable_mem(cs);
+		}
+	}
+}
+
+static u32 gpmc_round_ps_to_sync_clk(u32 time_ps, u32 sync_clk)
+{
+	u32 temp;
+	int div;
+
+	div = gpmc_calc_divider(sync_clk);
+	temp = gpmc_ps_to_ticks(time_ps);
+	temp = (temp + div - 1) / div;
+	return gpmc_ticks_to_ps(temp * div);
+}
+
+/* XXX: can the cycles be avoided ? */
+static int gpmc_calc_sync_read_timings(struct gpmc_timings *gpmc_t,
+				       struct gpmc_device_timings *dev_t,
+				       bool mux)
+{
+	u32 temp;
+
+	/* adv_rd_off */
+	temp = dev_t->t_avdp_r;
+	/* XXX: mux check required ? */
+	if (mux) {
+		/* XXX: t_avdp not to be required for sync, only added for tusb
+		 * this indirectly necessitates requirement of t_avdp_r and
+		 * t_avdp_w instead of having a single t_avdp
+		 */
+		temp = max_t(u32, temp,	gpmc_t->clk_activation + dev_t->t_avdh);
+		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
+	}
+	gpmc_t->adv_rd_off = gpmc_round_ps_to_ticks(temp);
+
+	/* oe_on */
+	temp = dev_t->t_oeasu; /* XXX: remove this ? */
+	if (mux) {
+		temp = max_t(u32, temp,	gpmc_t->clk_activation + dev_t->t_ach);
+		temp = max_t(u32, temp, gpmc_t->adv_rd_off +
+			     gpmc_ticks_to_ps(dev_t->cyc_aavdh_oe));
+	}
+	gpmc_t->oe_on = gpmc_round_ps_to_ticks(temp);
+
+	/* access */
+	/* XXX: any scope for improvement ?, by combining oe_on
+	 * and clk_activation, need to check whether
+	 * access = clk_activation + round to sync clk ?
+	 */
+	temp = max_t(u32, dev_t->t_iaa,	dev_t->cyc_iaa * gpmc_t->sync_clk);
+	temp += gpmc_t->clk_activation;
+	if (dev_t->cyc_oe)
+		temp = max_t(u32, temp, gpmc_t->oe_on +
+			     gpmc_ticks_to_ps(dev_t->cyc_oe));
+	gpmc_t->access = gpmc_round_ps_to_ticks(temp);
+
+	gpmc_t->oe_off = gpmc_t->access + gpmc_ticks_to_ps(1);
+	gpmc_t->cs_rd_off = gpmc_t->oe_off;
+
+	/* rd_cycle */
+	temp = max_t(u32, dev_t->t_cez_r, dev_t->t_oez);
+	temp = gpmc_round_ps_to_sync_clk(temp, gpmc_t->sync_clk) +
+					 gpmc_t->access;
+	/* XXX: barter t_ce_rdyz with t_cez_r ? */
+	if (dev_t->t_ce_rdyz)
+		temp = max_t(u32, temp,	gpmc_t->cs_rd_off + dev_t->t_ce_rdyz);
+	gpmc_t->rd_cycle = gpmc_round_ps_to_ticks(temp);
+
+	return 0;
+}
+
+static int gpmc_calc_sync_write_timings(struct gpmc_timings *gpmc_t,
+					struct gpmc_device_timings *dev_t,
+					bool mux)
+{
+	u32 temp;
+
+	/* adv_wr_off */
+	temp = dev_t->t_avdp_w;
+	if (mux) {
+		temp = max_t(u32, temp,
+			     gpmc_t->clk_activation + dev_t->t_avdh);
+		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
+	}
+	gpmc_t->adv_wr_off = gpmc_round_ps_to_ticks(temp);
+
+	/* wr_data_mux_bus */
+	temp = max_t(u32, dev_t->t_weasu,
+		     gpmc_t->clk_activation + dev_t->t_rdyo);
+	/* XXX: shouldn't mux be kept as a whole for wr_data_mux_bus ?,
+	 * and in that case remember to handle we_on properly
+	 */
+	if (mux) {
+		temp = max_t(u32, temp,
+			     gpmc_t->adv_wr_off + dev_t->t_aavdh);
+		temp = max_t(u32, temp, gpmc_t->adv_wr_off +
+			     gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
+	}
+	gpmc_t->wr_data_mux_bus = gpmc_round_ps_to_ticks(temp);
+
+	/* we_on */
+	if (gpmc_capability & GPMC_HAS_WR_DATA_MUX_BUS)
+		gpmc_t->we_on = gpmc_round_ps_to_ticks(dev_t->t_weasu);
+	else
+		gpmc_t->we_on = gpmc_t->wr_data_mux_bus;
+
+	/* wr_access */
+	/* XXX: gpmc_capability check reqd ? , even if not, will not harm */
+	gpmc_t->wr_access = gpmc_t->access;
+
+	/* we_off */
+	temp = gpmc_t->we_on + dev_t->t_wpl;
+	temp = max_t(u32, temp,
+		     gpmc_t->wr_access + gpmc_ticks_to_ps(1));
+	temp = max_t(u32, temp,
+		     gpmc_t->we_on + gpmc_ticks_to_ps(dev_t->cyc_wpl));
+	gpmc_t->we_off = gpmc_round_ps_to_ticks(temp);
+
+	gpmc_t->cs_wr_off = gpmc_round_ps_to_ticks(gpmc_t->we_off +
+						   dev_t->t_wph);
+
+	/* wr_cycle */
+	temp = gpmc_round_ps_to_sync_clk(dev_t->t_cez_w, gpmc_t->sync_clk);
+	temp += gpmc_t->wr_access;
+	/* XXX: barter t_ce_rdyz with t_cez_w ? */
+	if (dev_t->t_ce_rdyz)
+		temp = max_t(u32, temp,
+			     gpmc_t->cs_wr_off + dev_t->t_ce_rdyz);
+	gpmc_t->wr_cycle = gpmc_round_ps_to_ticks(temp);
+
+	return 0;
+}
+
+static int gpmc_calc_async_read_timings(struct gpmc_timings *gpmc_t,
+					struct gpmc_device_timings *dev_t,
+					bool mux)
+{
+	u32 temp;
+
+	/* adv_rd_off */
+	temp = dev_t->t_avdp_r;
+	if (mux)
+		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
+	gpmc_t->adv_rd_off = gpmc_round_ps_to_ticks(temp);
+
+	/* oe_on */
+	temp = dev_t->t_oeasu;
+	if (mux)
+		temp = max_t(u32, temp,
+			     gpmc_t->adv_rd_off + dev_t->t_aavdh);
+	gpmc_t->oe_on = gpmc_round_ps_to_ticks(temp);
+
+	/* access */
+	temp = max_t(u32, dev_t->t_iaa, /* XXX: remove t_iaa in async ? */
+		     gpmc_t->oe_on + dev_t->t_oe);
+	temp = max_t(u32, temp,
+		     gpmc_t->cs_on + dev_t->t_ce);
+	temp = max_t(u32, temp,
+		     gpmc_t->adv_on + dev_t->t_aa);
+	gpmc_t->access = gpmc_round_ps_to_ticks(temp);
+
+	gpmc_t->oe_off = gpmc_t->access + gpmc_ticks_to_ps(1);
+	gpmc_t->cs_rd_off = gpmc_t->oe_off;
+
+	/* rd_cycle */
+	temp = max_t(u32, dev_t->t_rd_cycle,
+		     gpmc_t->cs_rd_off + dev_t->t_cez_r);
+	temp = max_t(u32, temp, gpmc_t->oe_off + dev_t->t_oez);
+	gpmc_t->rd_cycle = gpmc_round_ps_to_ticks(temp);
+
+	return 0;
+}
+
+static int gpmc_calc_async_write_timings(struct gpmc_timings *gpmc_t,
+					 struct gpmc_device_timings *dev_t,
+					 bool mux)
+{
+	u32 temp;
+
+	/* adv_wr_off */
+	temp = dev_t->t_avdp_w;
+	if (mux)
+		temp = max_t(u32, gpmc_t->adv_on + gpmc_ticks_to_ps(1), temp);
+	gpmc_t->adv_wr_off = gpmc_round_ps_to_ticks(temp);
+
+	/* wr_data_mux_bus */
+	temp = dev_t->t_weasu;
+	if (mux) {
+		temp = max_t(u32, temp,	gpmc_t->adv_wr_off + dev_t->t_aavdh);
+		temp = max_t(u32, temp, gpmc_t->adv_wr_off +
+			     gpmc_ticks_to_ps(dev_t->cyc_aavdh_we));
+	}
+	gpmc_t->wr_data_mux_bus = gpmc_round_ps_to_ticks(temp);
+
+	/* we_on */
+	if (gpmc_capability & GPMC_HAS_WR_DATA_MUX_BUS)
+		gpmc_t->we_on = gpmc_round_ps_to_ticks(dev_t->t_weasu);
+	else
+		gpmc_t->we_on = gpmc_t->wr_data_mux_bus;
+
+	/* we_off */
+	temp = gpmc_t->we_on + dev_t->t_wpl;
+	gpmc_t->we_off = gpmc_round_ps_to_ticks(temp);
+
+	gpmc_t->cs_wr_off = gpmc_round_ps_to_ticks(gpmc_t->we_off +
+						   dev_t->t_wph);
+
+	/* wr_cycle */
+	temp = max_t(u32, dev_t->t_wr_cycle,
+		     gpmc_t->cs_wr_off + dev_t->t_cez_w);
+	gpmc_t->wr_cycle = gpmc_round_ps_to_ticks(temp);
+
+	return 0;
+}
+
+static int gpmc_calc_sync_common_timings(struct gpmc_timings *gpmc_t,
+					 struct gpmc_device_timings *dev_t)
+{
+	u32 temp;
+
+	gpmc_t->sync_clk = gpmc_calc_divider(dev_t->clk) *
+					     gpmc_get_fclk_period();
+
+	gpmc_t->page_burst_access = gpmc_round_ps_to_sync_clk(dev_t->t_bacc,
+							      gpmc_t->sync_clk);
+
+	temp = max_t(u32, dev_t->t_ces, dev_t->t_avds);
+	gpmc_t->clk_activation = gpmc_round_ps_to_ticks(temp);
+
+	if (gpmc_calc_divider(gpmc_t->sync_clk) != 1)
+		return 0;
+
+	if (dev_t->ce_xdelay)
+		gpmc_t->bool_timings.cs_extra_delay = true;
+	if (dev_t->avd_xdelay)
+		gpmc_t->bool_timings.adv_extra_delay = true;
+	if (dev_t->oe_xdelay)
+		gpmc_t->bool_timings.oe_extra_delay = true;
+	if (dev_t->we_xdelay)
+		gpmc_t->bool_timings.we_extra_delay = true;
+
+	return 0;
+}
+
+static int gpmc_calc_common_timings(struct gpmc_timings *gpmc_t,
+				    struct gpmc_device_timings *dev_t,
+				    bool sync)
+{
+	u32 temp;
+
+	/* cs_on */
+	gpmc_t->cs_on = gpmc_round_ps_to_ticks(dev_t->t_ceasu);
+
+	/* adv_on */
+	temp = dev_t->t_avdasu;
+	if (dev_t->t_ce_avd)
+		temp = max_t(u32, temp,
+			     gpmc_t->cs_on + dev_t->t_ce_avd);
+	gpmc_t->adv_on = gpmc_round_ps_to_ticks(temp);
+
+	if (sync)
+		gpmc_calc_sync_common_timings(gpmc_t, dev_t);
+
+	return 0;
+}
+
+/* TODO: remove this function once all peripherals are confirmed to
+ * work with generic timing. Simultaneously gpmc_cs_set_timings()
+ * has to be modified to handle timings in ps instead of ns
+*/
+static void gpmc_convert_ps_to_ns(struct gpmc_timings *t)
+{
+	t->cs_on /= 1000;
+	t->cs_rd_off /= 1000;
+	t->cs_wr_off /= 1000;
+	t->adv_on /= 1000;
+	t->adv_rd_off /= 1000;
+	t->adv_wr_off /= 1000;
+	t->we_on /= 1000;
+	t->we_off /= 1000;
+	t->oe_on /= 1000;
+	t->oe_off /= 1000;
+	t->page_burst_access /= 1000;
+	t->access /= 1000;
+	t->rd_cycle /= 1000;
+	t->wr_cycle /= 1000;
+	t->bus_turnaround /= 1000;
+	t->cycle2cycle_delay /= 1000;
+	t->wait_monitoring /= 1000;
+	t->clk_activation /= 1000;
+	t->wr_access /= 1000;
+	t->wr_data_mux_bus /= 1000;
+}
+
+static int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
+			     struct gpmc_settings *gpmc_s,
+			     struct gpmc_device_timings *dev_t)
+{
+	bool mux = false, sync = false;
+
+	if (gpmc_s) {
+		mux = gpmc_s->mux_add_data ? true : false;
+		sync = (gpmc_s->sync_read || gpmc_s->sync_write);
+	}
+
+	memset(gpmc_t, 0, sizeof(*gpmc_t));
+
+	gpmc_calc_common_timings(gpmc_t, dev_t, sync);
+
+	if (gpmc_s && gpmc_s->sync_read)
+		gpmc_calc_sync_read_timings(gpmc_t, dev_t, mux);
+	else
+		gpmc_calc_async_read_timings(gpmc_t, dev_t, mux);
+
+	if (gpmc_s && gpmc_s->sync_write)
+		gpmc_calc_sync_write_timings(gpmc_t, dev_t, mux);
+	else
+		gpmc_calc_async_write_timings(gpmc_t, dev_t, mux);
+
+	/* TODO: remove, see function definition */
+	gpmc_convert_ps_to_ns(gpmc_t);
+
+	return 0;
+}
+
+/**
+ * gpmc_cs_program_settings - programs non-timing related settings
+ * @cs:		GPMC chip-select to program
+ * @p:		pointer to GPMC settings structure
+ *
+ * Programs non-timing related settings for a GPMC chip-select, such as
+ * bus-width, burst configuration, etc. Function should be called once
+ * for each chip-select that is being used and must be called before
+ * calling gpmc_cs_set_timings() as timing parameters in the CONFIG1
+ * register will be initialised to zero by this function. Returns 0 on
+ * success and appropriate negative error code on failure.
+ */
+static int gpmc_cs_program_settings(int cs, struct gpmc_settings *p)
+{
+	u32 config1;
+
+	if ((!p->device_width) || (p->device_width > GPMC_DEVWIDTH_16BIT)) {
+		pr_err("%s: invalid width %d!", __func__, p->device_width);
+		return -EINVAL;
+	}
+
+	/* Address-data multiplexing not supported for NAND devices */
+	if (p->device_nand && p->mux_add_data) {
+		pr_err("%s: invalid configuration!\n", __func__);
+		return -EINVAL;
+	}
+
+	if ((p->mux_add_data > GPMC_MUX_AD) ||
+	    ((p->mux_add_data == GPMC_MUX_AAD) &&
+	     !(gpmc_capability & GPMC_HAS_MUX_AAD))) {
+		pr_err("%s: invalid multiplex configuration!\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Page/burst mode supports lengths of 4, 8 and 16 bytes */
+	if (p->burst_read || p->burst_write) {
+		switch (p->burst_len) {
+		case GPMC_BURST_4:
+		case GPMC_BURST_8:
+		case GPMC_BURST_16:
+			break;
+		default:
+			pr_err("%s: invalid page/burst-length (%d)\n",
+			       __func__, p->burst_len);
+			return -EINVAL;
+		}
+	}
+
+	if ((p->wait_on_read || p->wait_on_write) &&
+	    (p->wait_pin > gpmc_nr_waitpins)) {
+		pr_err("%s: invalid wait-pin (%d)\n", __func__, p->wait_pin);
+		return -EINVAL;
+	}
+
+	config1 = GPMC_CONFIG1_DEVICESIZE((p->device_width - 1));
+
+	if (p->sync_read)
+		config1 |= GPMC_CONFIG1_READTYPE_SYNC;
+	if (p->sync_write)
+		config1 |= GPMC_CONFIG1_WRITETYPE_SYNC;
+	if (p->wait_on_read)
+		config1 |= GPMC_CONFIG1_WAIT_READ_MON;
+	if (p->wait_on_write)
+		config1 |= GPMC_CONFIG1_WAIT_WRITE_MON;
+	if (p->wait_on_read || p->wait_on_write)
+		config1 |= GPMC_CONFIG1_WAIT_PIN_SEL(p->wait_pin);
+	if (p->device_nand)
+		config1	|= GPMC_CONFIG1_DEVICETYPE(GPMC_DEVICETYPE_NAND);
+	if (p->mux_add_data)
+		config1	|= GPMC_CONFIG1_MUXTYPE(p->mux_add_data);
+	if (p->burst_read)
+		config1 |= GPMC_CONFIG1_READMULTIPLE_SUPP;
+	if (p->burst_write)
+		config1 |= GPMC_CONFIG1_WRITEMULTIPLE_SUPP;
+	if (p->burst_read || p->burst_write) {
+		config1 |= GPMC_CONFIG1_PAGE_LEN(p->burst_len >> 3);
+		config1 |= p->burst_wrap ? GPMC_CONFIG1_WRAPBURST_SUPP : 0;
+	}
+
+	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, config1);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static struct of_device_id gpmc_dt_ids[] = {
+	{ .compatible = "ti,omap2420-gpmc" },
+	{ .compatible = "ti,omap2430-gpmc" },
+	{ .compatible = "ti,omap3430-gpmc" },	/* omap3430 & omap3630 */
+	{ .compatible = "ti,omap4430-gpmc" },	/* omap4 & omap543x */
+	{ .compatible = "ti,am3352-gpmc" },	/* am335x devices */
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gpmc_dt_ids);
+
+/**
+ * gpmc_read_settings_dt - read gpmc settings from device-tree
+ * @np:		pointer to device-tree node for a gpmc child device
+ * @p:		pointer to gpmc settings structure
+ *
+ * Reads the GPMC settings for a GPMC child device from device-tree and
+ * stores them in the GPMC settings structure passed. The GPMC settings
+ * structure is initialised to zero by this function and so any
+ * previously stored settings will be cleared.
+ */
+static void gpmc_read_settings_dt(struct device_node *np,
+				  struct gpmc_settings *p)
+{
+	memset(p, 0, sizeof(struct gpmc_settings));
+
+	p->sync_read = of_property_read_bool(np, "gpmc,sync-read");
+	p->sync_write = of_property_read_bool(np, "gpmc,sync-write");
+	of_property_read_u32(np, "gpmc,device-width", &p->device_width);
+	of_property_read_u32(np, "gpmc,mux-add-data", &p->mux_add_data);
+
+	if (!of_property_read_u32(np, "gpmc,burst-length", &p->burst_len)) {
+		p->burst_wrap = of_property_read_bool(np, "gpmc,burst-wrap");
+		p->burst_read = of_property_read_bool(np, "gpmc,burst-read");
+		p->burst_write = of_property_read_bool(np, "gpmc,burst-write");
+		if (!p->burst_read && !p->burst_write)
+			pr_warn("%s: page/burst-length set but not used!\n",
+				__func__);
+	}
+
+	if (!of_property_read_u32(np, "gpmc,wait-pin", &p->wait_pin)) {
+		p->wait_on_read = of_property_read_bool(np,
+							"gpmc,wait-on-read");
+		p->wait_on_write = of_property_read_bool(np,
+							 "gpmc,wait-on-write");
+		if (!p->wait_on_read && !p->wait_on_write)
+			pr_warn("%s: read/write wait monitoring not enabled!\n",
+				__func__);
+	}
+}
+
+static void __maybe_unused gpmc_read_timings_dt(struct device_node *np,
+						struct gpmc_timings *gpmc_t)
+{
+	struct gpmc_bool_timings *p;
+
+	if (!np || !gpmc_t)
+		return;
+
+	memset(gpmc_t, 0, sizeof(*gpmc_t));
+
+	/* minimum clock period for syncronous mode */
+	of_property_read_u32(np, "gpmc,sync-clk-ps", &gpmc_t->sync_clk);
+
+	/* chip select timtings */
+	of_property_read_u32(np, "gpmc,cs-on-ns", &gpmc_t->cs_on);
+	of_property_read_u32(np, "gpmc,cs-rd-off-ns", &gpmc_t->cs_rd_off);
+	of_property_read_u32(np, "gpmc,cs-wr-off-ns", &gpmc_t->cs_wr_off);
+
+	/* ADV signal timings */
+	of_property_read_u32(np, "gpmc,adv-on-ns", &gpmc_t->adv_on);
+	of_property_read_u32(np, "gpmc,adv-rd-off-ns", &gpmc_t->adv_rd_off);
+	of_property_read_u32(np, "gpmc,adv-wr-off-ns", &gpmc_t->adv_wr_off);
+
+	/* WE signal timings */
+	of_property_read_u32(np, "gpmc,we-on-ns", &gpmc_t->we_on);
+	of_property_read_u32(np, "gpmc,we-off-ns", &gpmc_t->we_off);
+
+	/* OE signal timings */
+	of_property_read_u32(np, "gpmc,oe-on-ns", &gpmc_t->oe_on);
+	of_property_read_u32(np, "gpmc,oe-off-ns", &gpmc_t->oe_off);
+
+	/* access and cycle timings */
+	of_property_read_u32(np, "gpmc,page-burst-access-ns",
+			     &gpmc_t->page_burst_access);
+	of_property_read_u32(np, "gpmc,access-ns", &gpmc_t->access);
+	of_property_read_u32(np, "gpmc,rd-cycle-ns", &gpmc_t->rd_cycle);
+	of_property_read_u32(np, "gpmc,wr-cycle-ns", &gpmc_t->wr_cycle);
+	of_property_read_u32(np, "gpmc,bus-turnaround-ns",
+			     &gpmc_t->bus_turnaround);
+	of_property_read_u32(np, "gpmc,cycle2cycle-delay-ns",
+			     &gpmc_t->cycle2cycle_delay);
+	of_property_read_u32(np, "gpmc,wait-monitoring-ns",
+			     &gpmc_t->wait_monitoring);
+	of_property_read_u32(np, "gpmc,clk-activation-ns",
+			     &gpmc_t->clk_activation);
+
+	/* only applicable to OMAP3+ */
+	of_property_read_u32(np, "gpmc,wr-access-ns", &gpmc_t->wr_access);
+	of_property_read_u32(np, "gpmc,wr-data-mux-bus-ns",
+			     &gpmc_t->wr_data_mux_bus);
+
+	/* bool timing parameters */
+	p = &gpmc_t->bool_timings;
+
+	p->cycle2cyclediffcsen =
+		of_property_read_bool(np, "gpmc,cycle2cycle-diffcsen");
+	p->cycle2cyclesamecsen =
+		of_property_read_bool(np, "gpmc,cycle2cycle-samecsen");
+	p->we_extra_delay = of_property_read_bool(np, "gpmc,we-extra-delay");
+	p->oe_extra_delay = of_property_read_bool(np, "gpmc,oe-extra-delay");
+	p->adv_extra_delay = of_property_read_bool(np, "gpmc,adv-extra-delay");
+	p->cs_extra_delay = of_property_read_bool(np, "gpmc,cs-extra-delay");
+	p->time_para_granularity =
+		of_property_read_bool(np, "gpmc,time-para-granularity");
+}
+
+/**
+ * gpmc_probe_generic_child - configures the gpmc for a child device
+ * @pdev:	pointer to gpmc platform device
+ * @child:	pointer to device-tree node for child device
+ *
+ * Allocates and configures a GPMC chip-select for a child device.
+ * Returns 0 on success and appropriate negative error code on failure.
+ */
+static int gpmc_probe_generic_child(struct platform_device *pdev,
+				    struct device_node *child)
+{
+	struct gpmc_settings gpmc_s;
+	struct gpmc_timings gpmc_t;
+	struct resource res;
+	unsigned long base;
+	int ret, cs;
+	struct device *dev = &pdev->dev;
+
+	if (of_property_read_u32(child, "reg", &cs) < 0) {
+		dev_err(&pdev->dev, "%s has no 'reg' property\n",
+			child->full_name);
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(child, 0, &res) < 0) {
+		dev_err(&pdev->dev, "%s has malformed 'reg' property\n",
+			child->full_name);
+		return -ENODEV;
+	}
+
+	ret = gpmc_cs_request(cs, resource_size(&res), &base);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot request GPMC CS %d\n", cs);
+		return ret;
+	}
+
+	/*
+	 * For some GPMC devices we still need to rely on the bootloader
+	 * timings because the devices can be connected via FPGA. So far
+	 * the list is smc91x on the omap2 SDP boards, and 8250 on zooms.
+	 * REVISIT: Add timing support from slls644g.pdf and from the
+	 * lan91c96 manual.
+	 */
+	if (of_device_is_compatible(child, "ns16550a") ||
+	    of_device_is_compatible(child, "smsc,lan91c94") ||
+	    of_device_is_compatible(child, "smsc,lan91c111")) {
+		dev_warn(&pdev->dev,
+			 "%s using bootloader timings on CS%d\n",
+			 child->name, cs);
+		goto no_timings;
+	}
+
+	/*
+	 * FIXME: gpmc_cs_request() will map the CS to an arbitary
+	 * location in the gpmc address space. When booting with
+	 * device-tree we want the NOR flash to be mapped to the
+	 * location specified in the device-tree blob. So remap the
+	 * CS to this location. Once DT migration is complete should
+	 * just make gpmc_cs_request() map a specific address.
+	 */
+	ret = gpmc_cs_remap(cs, res.start);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot remap GPMC CS %d to %pa\n",
+			cs, &res.start);
+		goto err;
+	}
+
+	gpmc_read_settings_dt(child, &gpmc_s);
+
+	if (of_node_cmp(child->name, "nand") == 0) {
+		/* NAND specific setup */
+		u32 val;
+
+		val = of_get_nand_bus_width(child);
+		switch (val) {
+		case 8:
+			gpmc_s.device_width = GPMC_DEVWIDTH_8BIT;
+			break;
+		case 16:
+			gpmc_s.device_width = GPMC_DEVWIDTH_16BIT;
+			break;
+		default:
+			dev_err(dev, "%s: invalid 'nand-bus-width'\n",
+				child->name);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		gpmc_s.device_nand = true;
+
+	} else if (of_node_cmp(child->name, "onenand") == 0) {
+		/* DT incorrectly sets sync modes, onenand default is async */
+		gpmc_s.sync_read = false;
+		gpmc_s.sync_write = false;
+
+	} else {
+		if (of_property_read_u32(child, "bank-width",
+					 &gpmc_s.device_width)) {
+			dev_err(dev, "%s: no 'bank-width' property\n",
+				child->name);
+			goto err;
+		}
+
+		if (gpmc_s.device_width < 1 || gpmc_s.device_width > 2) {
+			dev_err(dev, "%s: invalid 'bank-width'\n",
+				child->name);
+			goto err;
+		}
+	}
+
+	ret = gpmc_cs_program_settings(cs, &gpmc_s);
+	if (ret < 0)
+		goto err;
+
+	gpmc_read_timings_dt(child, &gpmc_t);
+	gpmc_cs_set_timings(cs, &gpmc_t);
+
+no_timings:
+	if (of_platform_device_create(child, NULL, &pdev->dev))
+		return 0;
+
+	dev_err(&pdev->dev, "failed to create gpmc child %s\n", child->name);
+	ret = -ENODEV;
+
+err:
+	gpmc_cs_free(cs);
+
+	return ret;
+}
+
+static int gpmc_probe_dt(struct platform_device *pdev)
+{
+	int ret;
+	struct device_node *child;
+
+	ret = of_property_read_u32(pdev->dev.of_node, "gpmc,num-cs",
+				   &gpmc_cs_num);
+	if (ret < 0) {
+		pr_err("%s: number of chip-selects not defined\n", __func__);
+		return ret;
+	} else if (gpmc_cs_num < 1) {
+		pr_err("%s: all chip-selects are disabled\n", __func__);
+		return -EINVAL;
+	} else if (gpmc_cs_num > GPMC_CS_NUM) {
+		pr_err("%s: number of supported chip-selects cannot be > %d\n",
+		       __func__, GPMC_CS_NUM);
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(pdev->dev.of_node, "gpmc,num-waitpins",
+				   &gpmc_nr_waitpins);
+	if (ret < 0) {
+		pr_err("%s: number of wait pins not found!\n", __func__);
+		return ret;
+	}
+
+	for_each_child_of_node(pdev->dev.of_node, child) {
+		if (!child->name)
+			continue;
+
+		if (of_node_cmp(child->name, "ethernet") == 0 ||
+		    of_node_cmp(child->name, "nor") == 0 ||
+		    of_node_cmp(child->name, "uart") == 0 ||
+		    of_node_cmp(child->name, "nand") == 0 ||
+		    of_node_cmp(child->name, "onenand") == 0)
+			ret = gpmc_probe_generic_child(pdev, child);
+
+		if (WARN(ret < 0, "%s: probing gpmc child %s failed\n",
+			 __func__, child->full_name))
+			of_node_put(child);
+	}
+
+	return 0;
+}
+#else
+static int gpmc_probe_dt(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
+static int gpmc_nand_setup(struct platform_device *parent_pdev,
+			   struct gpmc_omap_cs_data *cs)
+{
+	struct resource *res;
+	struct resource *res_gpmc;
+
+	if (!cs->pdev)
+		return -EINVAL;
+
+	res = cs->pdev->resource;
+
+	if (cs->pdev->num_resources < 3)
+		return -EINVAL;
+
+	if (resource_type(&res[1]) != IORESOURCE_MEM ||
+	    resource_type(&res[2]) != IORESOURCE_IRQ)
+		return -EINVAL;
+
+	if (!cs->settings)
+		return -EINVAL;
+
+	/* GPMC register space */
+	res_gpmc = platform_get_resource(parent_pdev, IORESOURCE_MEM, 0);
+	if (!res_gpmc)
+		return -EINVAL;
+
+	res[1] = *res_gpmc;
+
+	/* setup IRQ resources */
+	res[2].start = gpmc_irq;
+
+	cs->settings->device_nand = true;
+
+	return 0;
+}
+
+static void gpmc_probe_legacy(struct platform_device *pdev)
+{
+	int i, rc, j;
+	struct device *dev = &pdev->dev;
+	struct gpmc_omap_platform_data *gpmc_pdata;
+	struct resource *mem_res;
+	unsigned long cs_base;
+	resource_size_t size;
+	struct gpmc_timings gpmc_timings;
+	struct gpmc_omap_cs_data *cs;
+
+	gpmc_pdata = dev->platform_data;
+	gpmc_cs_num = GPMC_CS_NUM;
+	gpmc_nr_waitpins = GPMC_NR_WAITPINS;
+
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		cs = &gpmc_pdata->cs[i];
+		if (!cs->valid)
+			continue;
+
+		if (cs->settings) {
+			if (gpmc_cs_program_settings(i, cs->settings)) {
+				dev_err(dev,
+					"Couldn't program settings for CS %d\n",
+					i);
+				continue;
+			}
+		}
+
+		/* give device_timings priority over gpmc_timings */
+		if (cs->device_timings) {
+			gpmc_calc_timings(&gpmc_timings, cs->settings,
+					  cs->device_timings);
+
+			if (gpmc_cs_set_timings(i, &gpmc_timings)) {
+				dev_err(dev,
+					"Couldn't program timings for CS %d\n",
+					i);
+				continue;
+			}
+		} else if (cs->gpmc_timings) {
+			if (gpmc_cs_set_timings(i, cs->gpmc_timings)) {
+				dev_err(dev,
+					"Couldn't program timings for CS %d\n",
+					i);
+				continue;
+			}
+		}
+	}
+
+	/*
+	 * All Chip Selects must be configured before platform devices are
+	 * created as some devices (e.g. tusb6010) can use multiple
+	 * Chip selects.
+	 */
+
+	/* Fixup Memory resources */
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		int required_resources;
+
+		cs = &gpmc_pdata->cs[i];
+		if (!cs->valid)
+			continue;
+
+		if (!cs->pdev)
+			continue;
+
+		/* Customized NAND setup */
+		if (cs->is_nand) {
+			if (gpmc_nand_setup(pdev, cs)) {
+				dev_err(dev, "Error setting up NAND on CS %d\n",
+					i);
+				continue;
+			}
+		}
+
+		mem_res = cs->pdev->resource;
+
+		/*
+		 * If device is present multiple times, fix the subsequent
+		 * resources
+		 */
+		required_resources = 1;
+		for (j = 0; j < i; j++) {
+			if (gpmc_pdata->cs[j].pdev == cs->pdev) {
+				mem_res++;
+				required_resources++;
+			}
+		}
+
+		if (cs->pdev->num_resources < required_resources ||
+		    resource_type(mem_res) != IORESOURCE_MEM) {
+			dev_err(dev, "Invalid IOMEM resource for CS %d\n", i);
+			continue;
+		}
+
+		/*
+		 * Request a CS space. Use size from
+		 * platform device's MEM resource
+		 */
+		size = mem_res->end - mem_res->start + 1;
+		if (gpmc_cs_request(i, size, &cs_base)) {
+			dev_err(dev, "Couldn't request resource for CS %d\n",
+				i);
+			continue;
+		}
+
+		mem_res->start = cs_base;
+		mem_res->end = cs_base + size - 1;
+	}
+
+	/* create the platform devices */
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		bool registered;
+
+		cs = &gpmc_pdata->cs[i];
+		if (!cs->valid)
+			continue;
+
+		if (!cs->pdev)
+			continue;
+
+		/*
+		 * same device can be present on multiple CS, don't
+		 * register device more than once.
+		 */
+		registered = false;
+		for (j = 0; j < i; j++) {
+			if (gpmc_pdata->cs[j].pdev == cs->pdev) {
+				registered = true;
+				break;
+			}
+		}
+
+		if (registered)
+			continue;
+
+		cs->pdev->dev.parent = dev;
+		rc = platform_device_register(cs->pdev);
+		if (rc < 0) {
+			dev_err(dev,
+				"Failed to register device %s on CS %d\n",
+				cs->pdev->name, i);
+			continue;
+		}
+	}
+}
+
+static int gpmc_probe(struct platform_device *pdev)
+{
+	int rc;
+	u32 l;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL)
+		return -ENOENT;
+
+	phys_base = res->start;
+	mem_size = resource_size(res);
+
+	gpmc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gpmc_base))
+		return PTR_ERR(gpmc_base);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get resource: irq\n");
+		return -EINVAL;
+	}
+
+	gpmc_irq = res->start;
+
+	gpmc_l3_clk = clk_get(&pdev->dev, "fck");
+	if (IS_ERR(gpmc_l3_clk)) {
+		dev_err(&pdev->dev, "error: clk_get\n");
+		gpmc_irq = 0;
+		return PTR_ERR(gpmc_l3_clk);
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
+	gpmc_dev = dev;
+
+	l = gpmc_read_reg(GPMC_REVISION);
+
+	/*
+	 * FIXME: Once device-tree migration is complete the below flags
+	 * should be populated based upon the device-tree compatible
+	 * string. For now just use the IP revision. OMAP3+ devices have
+	 * the wr_access and wr_data_mux_bus register fields. OMAP4+
+	 * devices support the addr-addr-data multiplex protocol.
+	 *
+	 * GPMC IP revisions:
+	 * - OMAP24xx			= 2.0
+	 * - OMAP3xxx			= 5.0
+	 * - OMAP44xx/54xx/AM335x	= 6.0
+	 */
+	if (GPMC_REVISION_MAJOR(l) > 0x4)
+		gpmc_capability = GPMC_HAS_WR_ACCESS | GPMC_HAS_WR_DATA_MUX_BUS;
+	if (GPMC_REVISION_MAJOR(l) > 0x5)
+		gpmc_capability |= GPMC_HAS_MUX_AAD;
+	dev_info(dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
+		 GPMC_REVISION_MINOR(l));
+
+	gpmc_mem_init();
+
+	/* Now the GPMC is initialised, unreserve the chip-selects */
+	gpmc_cs_map = 0;
+	gpmc_dev = dev;
+
+	if (dev->of_node) {
+		rc = gpmc_probe_dt(pdev);
+		if (rc) {
+			dev_err(dev, "gpmc_probe_dt() failed\n");
+			goto error;
+		}
+	} else {
+		/* Legacy probing based on platform data */
+		if (!dev->platform_data) {
+			dev_err(dev, "No platform data\n");
+			rc = -EINVAL;
+			goto error;
+		}
+
+		gpmc_probe_legacy(pdev);
+	}
+
+	return 0;
+
+error:
+	pm_runtime_put_sync(dev);
+	clk_put(gpmc_l3_clk);
+	return rc;
+}
+
+static int gpmc_remove(struct platform_device *pdev)
+{
+	gpmc_mem_exit();
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	gpmc_dev = NULL;
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
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
+static int gpmc_suspend(struct device *dev)
+{
+	omap_gpmc_save_context();
+	pm_runtime_put_sync(dev);
+	return 0;
+}
+
+static int gpmc_resume(struct device *dev)
+{
+	pm_runtime_get_sync(dev);
+	omap_gpmc_restore_context();
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(gpmc_pm_ops, gpmc_suspend, gpmc_resume);
+
+static struct platform_driver gpmc_driver = {
+	.probe		= gpmc_probe,
+	.remove		= gpmc_remove,
+	.driver		= {
+		.name	= DEVICE_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(gpmc_dt_ids),
+		.pm	= &gpmc_pm_ops,
+	},
+};
+
+static __init int gpmc_init(void)
+{
+	return platform_driver_register(&gpmc_driver);
+}
+
+static __exit void gpmc_exit(void)
+{
+	platform_driver_unregister(&gpmc_driver);
+}
+
+module_init(gpmc_init);
+module_exit(gpmc_exit);
+
+/**
+ * omap_gpmc_retime - Reconfigre GPMC timings for the device
+ *
+ * @cs		Chip select number
+ * @gpmc_s	GPMC settings
+ * @dev_t	New device timings to set
+ */
+int omap_gpmc_retime(int cs, struct gpmc_settings *gpmc_s,
+		     struct gpmc_device_timings *dev_t)
+{
+	struct gpmc_timings gpmc_t;
+	struct device *dev = gpmc_dev;
+
+	if (!gpmc_dev)
+		return -ENODEV;
+
+	if (cs < 0 || cs >= gpmc_cs_num) {
+		dev_err(dev, "%s: Invalid find Chip Select\n", __func__);
+		return cs;
+	}
+
+	if (gpmc_cs_program_settings(cs, gpmc_s)) {
+		dev_err(dev, "%s: Failed to set GPMC settings\n", __func__);
+		return -EINVAL;
+	}
+
+	gpmc_calc_timings(&gpmc_t, gpmc_s, dev_t);
+	if (gpmc_cs_set_timings(cs, &gpmc_t)) {
+		dev_err(dev, "%s: Failed to set GPMC timings\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_gpmc_retime);
+
+/**
+ * omap_gpmc_get_clk_period - Get the nearest possible (equal to or higer) GPMC
+ *				synchronous clock (GPMC_CLK) period.
+ *
+ * @cs		Chip select number
+ * @min_ps	Minimum synchronous clock period supporded by the device
+ *
+ * Returns the nearest possible GPMC clock period in picoseconds, equal to or
+ * higher than the requested period. 0 in case of error.
+ */
+unsigned long omap_gpmc_get_clk_period(int cs,
+				       unsigned long min_ps)
+{
+	int div;
+	unsigned long clk_ps;
+	struct device *dev = gpmc_dev;
+
+	if (!gpmc_dev)
+		return 0;
+
+	if (cs < 0 || cs >= gpmc_cs_num) {
+		dev_err(dev, "%s: Invalid Chip Select\n", __func__);
+		return cs;
+	}
+
+	div = gpmc_calc_divider(min_ps);
+	if (div < 0) {
+		dev_err(dev, "%s: Can't support requested clock period %lu ps\n",
+			__func__, min_ps);
+		return 0;
+	}
+
+	clk_ps = gpmc_get_fclk_period() * div;
+
+	return clk_ps;
+}
+EXPORT_SYMBOL_GPL(omap_gpmc_get_clk_period);
+
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

