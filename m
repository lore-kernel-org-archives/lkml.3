Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbbARXeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 18:34:31 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57901 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbARXea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 18:34:30 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mach-davinci: Remove driver CDCE949
Date: Mon, 19 Jan 2015 00:37:39 +0100
Message-Id: <1421624259-24127-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove driver CDCE949 because it is not used anywhere.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-davinci/Makefile               |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c     |    4 -
 arch/arm/mach-davinci/cdce949.c              |  295 --------------------------
 arch/arm/mach-davinci/include/mach/cdce949.h |   19 --
 4 files changed, 1 insertion(+), 319 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/cdce949.c
 delete mode 100644 arch/arm/mach-davinci/include/mach/cdce949.h

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 2204239..2e3464b 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_MACH_SFFSDR)		+= board-sffsdr.o
 obj-$(CONFIG_MACH_NEUROS_OSD2)		+= board-neuros-osd2.o
 obj-$(CONFIG_MACH_DAVINCI_DM355_EVM)	+= board-dm355-evm.o
 obj-$(CONFIG_MACH_DM355_LEOPARD)	+= board-dm355-leopard.o
-obj-$(CONFIG_MACH_DAVINCI_DM6467_EVM)	+= board-dm646x-evm.o cdce949.o
+obj-$(CONFIG_MACH_DAVINCI_DM6467_EVM)	+= board-dm646x-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DM365_EVM)	+= board-dm365-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DA830_EVM)	+= board-da830-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DA850_EVM)	+= board-da850-evm.o
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index ae129bc..8be5aef 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -45,7 +45,6 @@
 #include <mach/irqs.h>
 #include <mach/serial.h>
 #include <mach/clock.h>
-#include <mach/cdce949.h>
 
 #include "davinci.h"
 #include "clock.h"
@@ -399,9 +398,6 @@ static struct i2c_board_info __initdata i2c_info[] =  {
 	{
 		I2C_BOARD_INFO("cpld_video", 0x3b),
 	},
-	{
-		I2C_BOARD_INFO("cdce949", 0x6c),
-	},
 };
 
 static struct davinci_i2c_platform_data i2c_pdata = {
diff --git a/arch/arm/mach-davinci/cdce949.c b/arch/arm/mach-davinci/cdce949.c
deleted file mode 100644
index abafb92..0000000
--- a/arch/arm/mach-davinci/cdce949.c
+++ /dev/null
@@ -1,295 +0,0 @@
-/*
- * TI CDCE949 clock synthesizer driver
- *
- * Note: This implementation assumes an input of 27MHz to the CDCE.
- * This is by no means constrained by CDCE hardware although the datasheet
- * does use this as an example for all illustrations and more importantly:
- * that is the crystal input on boards it is currently used on.
- *
- * Copyright (C) 2009 Texas Instruments Incorporated. http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-#include <linux/kernel.h>
-#include <linux/clk.h>
-#include <linux/platform_device.h>
-#include <linux/i2c.h>
-#include <linux/module.h>
-
-#include <mach/clock.h>
-#include <mach/cdce949.h>
-
-#include "clock.h"
-
-static struct i2c_client *cdce_i2c_client;
-static DEFINE_MUTEX(cdce_mutex);
-
-/* CDCE register descriptor */
-struct cdce_reg {
-	u8	addr;
-	u8	val;
-};
-
-/* Per-Output (Y1, Y2 etc.) frequency descriptor */
-struct cdce_freq {
-	/* Frequency in KHz */
-	unsigned long frequency;
-	/*
-	 * List of registers to program to obtain a particular frequency.
-	 * 0x0 in register address and value is the end of list marker.
-	 */
-	struct cdce_reg *reglist;
-};
-
-#define CDCE_FREQ_TABLE_ENTRY(line, out)		\
-{							\
-	.reglist	= cdce_y ##line## _ ##out,		\
-	.frequency	= out,				\
-}
-
-/* List of CDCE outputs  */
-struct cdce_output {
-	/* List of frequencies on this output */
-	struct cdce_freq *freq_table;
-	/* Number of possible frequencies */
-	int size;
-};
-
-/*
- * Finding out the values to program into CDCE949 registers for a particular
- * frequency output is not a simple calculation. Have a look at the datasheet
- * for the details. There is desktop software available to help users with
- * the calculations. Here, we just depend on the output of that software
- * (or hand calculations) instead trying to runtime calculate the register
- * values and inflicting misery on ourselves.
- */
-static struct cdce_reg cdce_y1_148500[] = {
-	{ 0x13, 0x00 },
-	/* program PLL1_0 multiplier */
-	{ 0x18, 0xaf },
-	{ 0x19, 0x50 },
-	{ 0x1a, 0x02 },
-	{ 0x1b, 0xc9 },
-	/* program PLL1_11 multiplier */
-	{ 0x1c, 0x00 },
-	{ 0x1d, 0x40 },
-	{ 0x1e, 0x02 },
-	{ 0x1f, 0xc9 },
-	/* output state selection */
-	{ 0x15, 0x00 },
-	{ 0x14, 0xef },
-	/* switch MUX to PLL1 output */
-	{ 0x14, 0x6f },
-	{ 0x16, 0x06 },
-	/* set P2DIV divider, P3DIV and input crystal */
-	{ 0x17, 0x06 },
-	{ 0x01, 0x00 },
-	{ 0x05, 0x48 },
-	{ 0x02, 0x80 },
-	/* enable and disable PLL */
-	{ 0x02, 0xbc },
-	{ 0x03, 0x01 },
-	{ },
-};
-
-static struct cdce_reg cdce_y1_74250[] = {
-	{ 0x13, 0x00 },
-	{ 0x18, 0xaf },
-	{ 0x19, 0x50 },
-	{ 0x1a, 0x02 },
-	{ 0x1b, 0xc9 },
-	{ 0x1c, 0x00 },
-	{ 0x1d, 0x40 },
-	{ 0x1e, 0x02 },
-	{ 0x1f, 0xc9 },
-	/* output state selection */
-	{ 0x15, 0x00 },
-	{ 0x14, 0xef },
-	/* switch MUX to PLL1 output */
-	{ 0x14, 0x6f },
-	{ 0x16, 0x06 },
-	/* set P2DIV divider, P3DIV and input crystal */
-	{ 0x17, 0x06 },
-	{ 0x01, 0x00 },
-	{ 0x05, 0x48 },
-	{ 0x02, 0x80 },
-	/* enable and disable PLL */
-	{ 0x02, 0xbc },
-	{ 0x03, 0x02 },
-	{ },
-};
-
-static struct cdce_reg cdce_y1_27000[] = {
-	{ 0x13, 0x00 },
-	{ 0x18, 0x00 },
-	{ 0x19, 0x40 },
-	{ 0x1a, 0x02 },
-	{ 0x1b, 0x08 },
-	{ 0x1c, 0x00 },
-	{ 0x1d, 0x40 },
-	{ 0x1e, 0x02 },
-	{ 0x1f, 0x08 },
-	{ 0x15, 0x02 },
-	{ 0x14, 0xed },
-	{ 0x16, 0x01 },
-	{ 0x17, 0x01 },
-	{ 0x01, 0x00 },
-	{ 0x05, 0x50 },
-	{ 0x02, 0xb4 },
-	{ 0x03, 0x01 },
-	{ },
-};
-
-static struct cdce_freq cdce_y1_freqs[] = {
-	CDCE_FREQ_TABLE_ENTRY(1, 148500),
-	CDCE_FREQ_TABLE_ENTRY(1, 74250),
-	CDCE_FREQ_TABLE_ENTRY(1, 27000),
-};
-
-static struct cdce_reg cdce_y5_13500[] = {
-	{ 0x27, 0x08 },
-	{ 0x28, 0x00 },
-	{ 0x29, 0x40 },
-	{ 0x2a, 0x02 },
-	{ 0x2b, 0x08 },
-	{ 0x24, 0x6f },
-	{ },
-};
-
-static struct cdce_reg cdce_y5_16875[] = {
-	{ 0x27, 0x08 },
-	{ 0x28, 0x9f },
-	{ 0x29, 0xb0 },
-	{ 0x2a, 0x02 },
-	{ 0x2b, 0x89 },
-	{ 0x24, 0x6f },
-	{ },
-};
-
-static struct cdce_reg cdce_y5_27000[] = {
-	{ 0x27, 0x04 },
-	{ 0x28, 0x00 },
-	{ 0x29, 0x40 },
-	{ 0x2a, 0x02 },
-	{ 0x2b, 0x08 },
-	{ 0x24, 0x6f },
-	{ },
-};
-static struct cdce_reg cdce_y5_54000[] = {
-	{ 0x27, 0x04 },
-	{ 0x28, 0xff },
-	{ 0x29, 0x80 },
-	{ 0x2a, 0x02 },
-	{ 0x2b, 0x07 },
-	{ 0x24, 0x6f },
-	{ },
-};
-
-static struct cdce_reg cdce_y5_81000[] = {
-	{ 0x27, 0x02 },
-	{ 0x28, 0xbf },
-	{ 0x29, 0xa0 },
-	{ 0x2a, 0x03 },
-	{ 0x2b, 0x0a },
-	{ 0x24, 0x6f },
-	{ },
-};
-
-static struct cdce_freq cdce_y5_freqs[] = {
-	CDCE_FREQ_TABLE_ENTRY(5, 13500),
-	CDCE_FREQ_TABLE_ENTRY(5, 16875),
-	CDCE_FREQ_TABLE_ENTRY(5, 27000),
-	CDCE_FREQ_TABLE_ENTRY(5, 54000),
-	CDCE_FREQ_TABLE_ENTRY(5, 81000),
-};
-
-
-static struct cdce_output output_list[] = {
-	[1]	= { cdce_y1_freqs, ARRAY_SIZE(cdce_y1_freqs) },
-	[5]	= { cdce_y5_freqs, ARRAY_SIZE(cdce_y5_freqs) },
-};
-
-int cdce_set_rate(struct clk *clk, unsigned long rate)
-{
-	int i, ret = 0;
-	struct cdce_freq *freq_table = output_list[clk->lpsc].freq_table;
-	struct cdce_reg  *regs = NULL;
-
-	if (!cdce_i2c_client)
-		return -ENODEV;
-
-	if (!freq_table)
-		return -EINVAL;
-
-	for (i = 0; i < output_list[clk->lpsc].size; i++) {
-		if (freq_table[i].frequency == rate / 1000) {
-			regs = freq_table[i].reglist;
-			break;
-		}
-	}
-
-	if (!regs)
-		return -EINVAL;
-
-	mutex_lock(&cdce_mutex);
-	for (i = 0; regs[i].addr; i++) {
-		ret = i2c_smbus_write_byte_data(cdce_i2c_client,
-					regs[i].addr | 0x80, regs[i].val);
-		if (ret)
-			break;
-	}
-	mutex_unlock(&cdce_mutex);
-
-	if (!ret)
-		clk->rate = rate;
-
-	return ret;
-}
-
-static int cdce_probe(struct i2c_client *client,
-					const struct i2c_device_id *id)
-{
-	cdce_i2c_client = client;
-	return 0;
-}
-
-static int cdce_remove(struct i2c_client *client)
-{
-	cdce_i2c_client = NULL;
-	return 0;
-}
-
-static const struct i2c_device_id cdce_id[] = {
-	{"cdce949", 0},
-	{},
-};
-MODULE_DEVICE_TABLE(i2c, cdce_id);
-
-static struct i2c_driver cdce_driver = {
-	.driver = {
-		.owner	= THIS_MODULE,
-		.name	= "cdce949",
-	},
-	.probe		= cdce_probe,
-	.remove		= cdce_remove,
-	.id_table	= cdce_id,
-};
-
-static int __init cdce_init(void)
-{
-	return i2c_add_driver(&cdce_driver);
-}
-subsys_initcall(cdce_init);
-
-static void __exit cdce_exit(void)
-{
-	i2c_del_driver(&cdce_driver);
-}
-module_exit(cdce_exit);
-
-MODULE_AUTHOR("Texas Instruments");
-MODULE_DESCRIPTION("CDCE949 clock synthesizer driver");
-MODULE_LICENSE("GPL v2");
diff --git a/arch/arm/mach-davinci/include/mach/cdce949.h b/arch/arm/mach-davinci/include/mach/cdce949.h
deleted file mode 100644
index c73331f..0000000
--- a/arch/arm/mach-davinci/include/mach/cdce949.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * TI CDCE949 off-chip clock synthesizer support
- *
- * 2009 (C) Texas Instruments, Inc. http://www.ti.com/
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- */
-#ifndef _MACH_DAVINCI_CDCE949_H
-#define _MACH_DAVINCI_CDCE949_H
-
-#include <linux/clk.h>
-
-#include <mach/clock.h>
-
-int cdce_set_rate(struct clk *clk, unsigned long rate);
-
-#endif
-- 
1.7.10.4

