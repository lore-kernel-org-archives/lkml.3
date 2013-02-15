Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161910Ab3BONCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:02:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56376 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3BOM57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/35] mfd: ab8500-debug: Add support for ab8505 and ab9540
Date: Fri, 15 Feb 2013 12:56:50 +0000
Message-Id: <1360933026-30325-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to dump all registers in ab8505 and ab9540.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c      |  383 +++++++++++++++++++++++++++++++++++--
 include/linux/mfd/abx500/ab8500.h |    1 +
 2 files changed, 373 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 3eeab01..ef1bd89 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -155,7 +155,9 @@ static struct hwreg_cfg hwreg_cfg = {
 
 #define AB8500_REV_REG 0x80
 
-static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
+static struct ab8500_prcmu_ranges *debug_ranges;
+
+struct ab8500_prcmu_ranges ab8500_debug_ranges[AB8500_NUM_BANKS] = {
 	[0x0] = {
 		.num_ranges = 0,
 		.range = NULL,
@@ -359,7 +361,7 @@ static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 			},
 			{
 				.first = 0xf5,
-				.last =	0xf6,
+				.last = 0xf6,
 			},
 		},
 	},
@@ -484,6 +486,365 @@ static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 };
 
+struct ab8500_prcmu_ranges ab8505_debug_ranges[AB8500_NUM_BANKS] = {
+	[0x0] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_SYS_CTRL1_BLOCK] = {
+		.num_ranges = 5,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x04,
+			},
+			{
+				.first = 0x42,
+				.last = 0x42,
+			},
+			{
+				.first = 0x52,
+				.last = 0x52,
+			},
+			{
+				.first = 0x54,
+				.last = 0x57,
+			},
+			{
+				.first = 0x80,
+				.last = 0x83,
+			},
+		},
+	},
+	[AB8500_SYS_CTRL2_BLOCK] = {
+		.num_ranges = 5,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x0D,
+			},
+			{
+				.first = 0x0F,
+				.last = 0x17,
+			},
+			{
+				.first = 0x20,
+				.last = 0x20,
+			},
+			{
+				.first = 0x30,
+				.last = 0x30,
+			},
+			{
+				.first = 0x32,
+				.last = 0x3A,
+			},
+		},
+	},
+	[AB8500_REGU_CTRL1] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x00,
+			},
+			{
+				.first = 0x03,
+				.last = 0x11,
+			},
+			{
+				.first = 0x80,
+				.last = 0x86,
+			},
+		},
+	},
+	[AB8500_REGU_CTRL2] = {
+		.num_ranges = 6,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x06,
+			},
+			{
+				.first = 0x08,
+				.last = 0x15,
+			},
+			{
+				.first = 0x17,
+				.last = 0x19,
+			},
+			{
+				.first = 0x1B,
+				.last = 0x1D,
+			},
+			{
+				.first = 0x1F,
+				.last = 0x30,
+			},
+			{
+				.first = 0x40,
+				.last = 0x48,
+			},
+			/* 0x80-0x8B is SIM registers and should
+			 * not be accessed from here */
+		},
+	},
+	[AB8500_USB] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x80,
+				.last = 0x83,
+			},
+			{
+				.first = 0x87,
+				.last = 0x8A,
+			},
+			{
+				.first = 0x91,
+				.last = 0x94,
+			},
+		},
+	},
+	[AB8500_TVOUT] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_DBI] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_ECI_AV_ACC] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x80,
+				.last = 0x82,
+			},
+		},
+	},
+	[AB8500_RESERVED] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_GPADC] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x08,
+			},
+		},
+	},
+	[AB8500_CHARGER] = {
+		.num_ranges = 9,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x02,
+				.last = 0x03,
+			},
+			{
+				.first = 0x05,
+				.last = 0x05,
+			},
+			{
+				.first = 0x40,
+				.last = 0x44,
+			},
+			{
+				.first = 0x50,
+				.last = 0x57,
+			},
+			{
+				.first = 0x60,
+				.last = 0x60,
+			},
+			{
+				.first = 0xA0,
+				.last = 0xA7,
+			},
+			{
+				.first = 0xAF,
+				.last = 0xB2,
+			},
+			{
+				.first = 0xC0,
+				.last = 0xC2,
+			},
+			{
+				.first = 0xF5,
+				.last = 0xF5,
+			},
+		},
+	},
+	[AB8500_GAS_GAUGE] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x00,
+			},
+			{
+				.first = 0x07,
+				.last = 0x0A,
+			},
+			{
+				.first = 0x10,
+				.last = 0x14,
+			},
+		},
+	},
+	[AB8500_AUDIO] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x83,
+			},
+		},
+	},
+	[AB8500_INTERRUPT] = {
+		.num_ranges = 11,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x04,
+			},
+			{
+				.first = 0x06,
+				.last = 0x07,
+			},
+			{
+				.first = 0x09,
+				.last = 0x09,
+			},
+			{
+				.first = 0x0B,
+				.last = 0x0C,
+			},
+			{
+				.first = 0x12,
+				.last = 0x15,
+			},
+			{
+				.first = 0x18,
+				.last = 0x18,
+			},
+			/* Latch registers should not be read here */
+			{
+				.first = 0x40,
+				.last = 0x44,
+			},
+			{
+				.first = 0x46,
+				.last = 0x49,
+			},
+			{
+				.first = 0x4B,
+				.last = 0x4D,
+			},
+			{
+				.first = 0x52,
+				.last = 0x55,
+			},
+			{
+				.first = 0x58,
+				.last = 0x58,
+			},
+			/* LatchHier registers should not be read here */
+		},
+	},
+	[AB8500_RTC] = {
+		.num_ranges = 2,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x14,
+			},
+			{
+				.first = 0x16,
+				.last = 0x17,
+			},
+		},
+	},
+	[AB8500_MISC] = {
+		.num_ranges = 8,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x06,
+			},
+			{
+				.first = 0x10,
+				.last = 0x16,
+			},
+			{
+				.first = 0x20,
+				.last = 0x26,
+			},
+			{
+				.first = 0x30,
+				.last = 0x36,
+			},
+			{
+				.first = 0x40,
+				.last = 0x46,
+			},
+			{
+				.first = 0x50,
+				.last = 0x50,
+			},
+			{
+				.first = 0x60,
+				.last = 0x6B,
+			},
+			{
+				.first = 0x80,
+				.last = 0x82,
+			},
+		},
+	},
+	[AB8500_DEVELOPMENT] = {
+		.num_ranges = 2,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x00,
+			},
+			{
+				.first = 0x05,
+				.last = 0x05,
+			},
+		},
+	},
+	[AB8500_DEBUG] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x05,
+				.last = 0x07,
+			},
+		},
+	},
+	[AB8500_PROD_TEST] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_STE_TEST] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_OTP_EMUL] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x01,
+				.last = 0x15,
+			},
+		},
+	},
+};
+
 static irqreturn_t ab8500_debug_handler(int irq, void *data)
 {
 	char buf[16];
@@ -528,9 +889,6 @@ static int ab8500_registers_print(struct device *dev, u32 bank,
 				err = seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
 					bank, reg, value);
 				if (err < 0) {
-					dev_err(dev,
-					"seq_printf overflow bank=0x%02X reg=0x%02X\n",
-						bank, reg);
 					/* Error is not returned here since
 					 * the output is wanted in any case */
 					return 0;
@@ -580,8 +938,6 @@ static int ab8500_print_all_banks(struct seq_file *s, void *p)
 
 	for (i = 1; i < AB8500_NUM_BANKS; i++) {
 		err = seq_printf(s, " bank 0x%02X:\n", i);
-		if (err < 0)
-			dev_err(dev, "seq_printf overflow, bank=0x%02X\n", i);
 
 		ab8500_registers_print(dev, i, s);
 	}
@@ -1936,14 +2292,19 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
-	if (is_ab8500(ab8500))
+	if (is_ab8500(ab8500)) {
+		debug_ranges = ab8500_debug_ranges;
 		num_interrupt_lines = AB8500_NR_IRQS;
-	else if (is_ab8505(ab8500))
+	} else if (is_ab8505(ab8500)) {
+		debug_ranges = ab8505_debug_ranges;
 		num_interrupt_lines = AB8505_NR_IRQS;
-	else if (is_ab9540(ab8500))
+	} else if (is_ab9540(ab8500)) {
+		debug_ranges = ab8505_debug_ranges;
 		num_interrupt_lines = AB9540_NR_IRQS;
-	else if (is_ab8540(ab8500))
+	} else if (is_ab8540(ab8500)) {
+		debug_ranges = ab8505_debug_ranges;
 		num_interrupt_lines = AB8540_NR_IRQS;
+	}
 
 	file = debugfs_create_file("interrupts", (S_IRUGO),
 	    ab8500_dir, &plf->dev, &ab8500_interrupts_fops);
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 6748129..3e9131f 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -59,6 +59,7 @@ enum ab8500_version {
 #define AB8500_DEVELOPMENT	0x11
 #define AB8500_DEBUG		0x12
 #define AB8500_PROD_TEST	0x13
+#define AB8500_STE_TEST		0x14
 #define AB8500_OTP_EMUL		0x15
 
 /*
-- 
1.7.10.4

