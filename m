Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab3DIIhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:37:13 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:41668 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965174Ab3DIIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:37:09 -0400
From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Subject: [PATCH 1/3] mfd: support stmpe1801 18 bits enhanced port expander
Date: Tue, 9 Apr 2013 10:35:19 +0200
Message-ID: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides support for 1801 variant of stmpe gpio port expanders.
This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
special key or dedicated key function.

Note that special/dedicated key function is not supported yet.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
---
 drivers/mfd/Kconfig       |    1 +
 drivers/mfd/stmpe-i2c.c   |    1 +
 drivers/mfd/stmpe.c       |   97 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/mfd/stmpe.h       |   49 +++++++++++++++++++++++
 include/linux/mfd/stmpe.h |    3 ++
 5 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d5b9b05..8583167 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -393,6 +393,7 @@ config MFD_STMPE
 
 		STMPE811: GPIO, Touchscreen
 		STMPE1601: GPIO, Keypad
+		STMPE1801: GPIO, Keypad
 		STMPE2401: GPIO, Keypad
 		STMPE2403: GPIO, Keypad
 
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index fd5fcb6..0da02e1 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -75,6 +75,7 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 	{ "stmpe801", STMPE801 },
 	{ "stmpe811", STMPE811 },
 	{ "stmpe1601", STMPE1601 },
+	{ "stmpe1801", STMPE1801 },
 	{ "stmpe2401", STMPE2401 },
 	{ "stmpe2403", STMPE2403 },
 	{ }
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index bc85877..bbccd51 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -19,6 +19,7 @@
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
+#include <linux/delay.h>
 #include "stmpe.h"
 
 static int __stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
@@ -643,6 +644,88 @@ static struct stmpe_variant_info stmpe1601 = {
 };
 
 /*
+ * STMPE1801
+ */
+static const u8 stmpe1801_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE1801_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE1801_REG_INT_CTRL_LOW,
+	[STMPE_IDX_IER_LSB]	= STMPE1801_REG_INT_EN_MASK_LOW,
+	[STMPE_IDX_ISR_LSB]	= STMPE1801_REG_INT_STA_LOW,
+	[STMPE_IDX_GPMR_LSB]	= STMPE1801_REG_GPIO_MP_LOW,
+	[STMPE_IDX_GPSR_LSB]	= STMPE1801_REG_GPIO_SET_LOW,
+	[STMPE_IDX_GPCR_LSB]	= STMPE1801_REG_GPIO_CLR_LOW,
+	[STMPE_IDX_GPDR_LSB]	= STMPE1801_REG_GPIO_SET_DIR_LOW,
+	[STMPE_IDX_GPRER_LSB]	= STMPE1801_REG_GPIO_RE_LOW,
+	[STMPE_IDX_GPFER_LSB]	= STMPE1801_REG_GPIO_FE_LOW,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1801_REG_INT_EN_GPIO_MASK_LOW,
+	[STMPE_IDX_ISGPIOR_LSB]	= STMPE1801_REG_INT_STA_GPIO_LOW,
+};
+
+static struct stmpe_variant_block stmpe1801_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE1801_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_keypad_cell,
+		.irq	= STMPE1801_IRQ_KEYPAD,
+		.block	= STMPE_BLOCK_KEYPAD,
+	},
+};
+
+static int stmpe1801_enable(struct stmpe *stmpe, unsigned int blocks,
+			    bool enable)
+{
+	unsigned int mask = 0;
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE1801_MSK_INT_EN_GPIO;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE1801_MSK_INT_EN_KPC;
+
+	return __stmpe_set_bits(stmpe, STMPE1801_REG_INT_EN_MASK_LOW, mask,
+				enable ? mask : 0);
+}
+
+static int stmpe1801_reset(struct stmpe *stmpe)
+{
+	unsigned long timeout;
+	int ret = 0;
+
+	ret = __stmpe_set_bits(stmpe, STMPE1801_REG_SYS_CTRL,
+		STMPE1801_MSK_SYS_CTRL_RESET, STMPE1801_MSK_SYS_CTRL_RESET);
+	if (ret < 0)
+		return ret;
+
+	timeout = jiffies + msecs_to_jiffies(100);
+	while (time_before(jiffies, timeout)) {
+		ret = __stmpe_reg_read(stmpe, STMPE1801_REG_SYS_CTRL);
+		if (ret < 0)
+			return ret;
+		if (!(ret & STMPE1801_MSK_SYS_CTRL_RESET))
+			return 0;
+		usleep_range(100, 200);
+	};
+	return -EIO;
+}
+
+static struct stmpe_variant_info stmpe1801 = {
+	.name		= "stmpe1801",
+	.id_val		= STMPE1801_ID,
+	.id_mask	= 0xfff0,
+	.num_gpios	= 18,
+	.af_bits	= 0,
+	.regs		= stmpe1801_regs,
+	.blocks		= stmpe1801_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe1801_blocks),
+	.num_irqs	= STMPE1801_NR_INTERNAL_IRQS,
+	.enable		= stmpe1801_enable,
+	/* stmpe1801 do not have any gpio alternate function */
+	.get_altfunc	= NULL,
+};
+
+/*
  * STMPE24XX
  */
 
@@ -740,6 +823,7 @@ static struct stmpe_variant_info *stmpe_variant_info[STMPE_NBR_PARTS] = {
 	[STMPE801]	= &stmpe801,
 	[STMPE811]	= &stmpe811,
 	[STMPE1601]	= &stmpe1601,
+	[STMPE1801]	= &stmpe1801,
 	[STMPE2401]	= &stmpe2401,
 	[STMPE2403]	= &stmpe2403,
 };
@@ -759,7 +843,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 	struct stmpe *stmpe = data;
 	struct stmpe_variant_info *variant = stmpe->variant;
 	int num = DIV_ROUND_UP(variant->num_irqs, 8);
-	u8 israddr = stmpe->regs[STMPE_IDX_ISR_MSB];
+	u8 israddr;
 	u8 isr[num];
 	int ret;
 	int i;
@@ -771,6 +855,11 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
+	if (variant->id_val == STMPE1801_ID)
+		israddr = stmpe->regs[STMPE_IDX_ISR_LSB];
+	else
+		israddr = stmpe->regs[STMPE_IDX_ISR_MSB];
+
 	ret = stmpe_block_read(stmpe, israddr, num, isr);
 	if (ret < 0)
 		return IRQ_NONE;
@@ -938,6 +1027,12 @@ static int stmpe_chip_init(struct stmpe *stmpe)
 	if (ret)
 		return ret;
 
+	if (id == STMPE1801_ID)	{
+		ret =  stmpe1801_reset(stmpe);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (stmpe->irq >= 0) {
 		if (id == STMPE801_ID)
 			icr = STMPE801_REG_SYS_CTRL_INT_EN;
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 7b8e13f..ff2b09b 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -199,6 +199,55 @@ int stmpe_remove(struct stmpe *stmpe);
 #define STPME1601_AUTOSLEEP_ENABLE		(1 << 3)
 
 /*
+ * STMPE1801
+ */
+#define STMPE1801_ID			0xc110
+#define STMPE1801_NR_INTERNAL_IRQS	5
+#define STMPE1801_IRQ_KEYPAD_COMBI	4
+#define STMPE1801_IRQ_GPIOC		3
+#define STMPE1801_IRQ_KEYPAD_OVER	2
+#define STMPE1801_IRQ_KEYPAD		1
+#define STMPE1801_IRQ_WAKEUP		0
+
+#define STMPE1801_REG_CHIP_ID			0x00
+#define STMPE1801_REG_SYS_CTRL			0x02
+#define STMPE1801_REG_INT_CTRL_LOW		0x04
+#define STMPE1801_REG_INT_EN_MASK_LOW		0x06
+#define STMPE1801_REG_INT_STA_LOW		0x08
+#define STMPE1801_REG_INT_EN_GPIO_MASK_LOW	0x0A
+#define STMPE1801_REG_INT_EN_GPIO_MASK_MID	0x0B
+#define STMPE1801_REG_INT_EN_GPIO_MASK_HIGH	0x0C
+#define STMPE1801_REG_INT_STA_GPIO_LOW		0x0D
+#define STMPE1801_REG_INT_STA_GPIO_MID		0x0E
+#define STMPE1801_REG_INT_STA_GPIO_HIGH		0x0F
+#define STMPE1801_REG_GPIO_SET_LOW		0x10
+#define STMPE1801_REG_GPIO_SET_MID		0x11
+#define STMPE1801_REG_GPIO_SET_HIGH		0x12
+#define STMPE1801_REG_GPIO_CLR_LOW		0x13
+#define STMPE1801_REG_GPIO_CLR_MID		0x14
+#define STMPE1801_REG_GPIO_CLR_HIGH		0x15
+#define STMPE1801_REG_GPIO_MP_LOW		0x16
+#define STMPE1801_REG_GPIO_MP_MID		0x17
+#define STMPE1801_REG_GPIO_MP_HIGH		0x18
+#define STMPE1801_REG_GPIO_SET_DIR_LOW		0x19
+#define STMPE1801_REG_GPIO_SET_DIR_MID		0x1A
+#define STMPE1801_REG_GPIO_SET_DIR_HIGH		0x1B
+#define STMPE1801_REG_GPIO_RE_LOW		0x1C
+#define STMPE1801_REG_GPIO_RE_MID		0x1D
+#define STMPE1801_REG_GPIO_RE_HIGH		0x1E
+#define STMPE1801_REG_GPIO_FE_LOW		0x1F
+#define STMPE1801_REG_GPIO_FE_MID		0x20
+#define STMPE1801_REG_GPIO_FE_HIGH		0x21
+#define STMPE1801_REG_GPIO_PULL_UP_LOW		0x22
+#define STMPE1801_REG_GPIO_PULL_UP_MID		0x23
+#define STMPE1801_REG_GPIO_PULL_UP_HIGH		0x24
+
+#define STMPE1801_MSK_SYS_CTRL_RESET		(1 << 7)
+
+#define STMPE1801_MSK_INT_EN_KPC		(1 << 1)
+#define STMPE1801_MSK_INT_EN_GPIO		(1 << 3)
+
+/*
  * STMPE24xx
  */
 
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 383ac15..48395a6 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -26,6 +26,7 @@ enum stmpe_partnum {
 	STMPE801,
 	STMPE811,
 	STMPE1601,
+	STMPE1801,
 	STMPE2401,
 	STMPE2403,
 	STMPE_NBR_PARTS
@@ -39,6 +40,7 @@ enum {
 	STMPE_IDX_CHIP_ID,
 	STMPE_IDX_ICR_LSB,
 	STMPE_IDX_IER_LSB,
+	STMPE_IDX_ISR_LSB,
 	STMPE_IDX_ISR_MSB,
 	STMPE_IDX_GPMR_LSB,
 	STMPE_IDX_GPSR_LSB,
@@ -49,6 +51,7 @@ enum {
 	STMPE_IDX_GPFER_LSB,
 	STMPE_IDX_GPAFR_U_MSB,
 	STMPE_IDX_IEGPIOR_LSB,
+	STMPE_IDX_ISGPIOR_LSB,
 	STMPE_IDX_ISGPIOR_MSB,
 	STMPE_IDX_MAX,
 };
-- 
1.7.10

