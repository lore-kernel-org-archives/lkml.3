Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab3DIIhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:37:08 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:42348 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935662Ab3DIIhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:37:05 -0400
From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Subject: [PATCH 3/3] gpio: support stmpe1801 18 bits enhanced port expander
Date: Tue, 9 Apr 2013 10:35:21 +0200
Message-ID: <1365496521-16880-3-git-send-email-jean-nicolas.graux@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
References: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
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
 drivers/gpio/gpio-stmpe.c |   52 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 770476a..343dfe1 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -45,14 +45,25 @@ static inline struct stmpe_gpio *to_stmpe_gpio(struct gpio_chip *chip)
 	return container_of(chip, struct stmpe_gpio, chip);
 }
 
+static inline u8 stmpe_gpio_reg(struct stmpe *stmpe, u8 index, int offset)
+{
+	u8 reg;
+	if (stmpe->partnum == STMPE1801)
+		reg = stmpe->regs[index] + offset;
+	else
+		reg = stmpe->regs[index] - offset;
+	return reg;
+}
+
 static int stmpe_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 reg = stmpe->regs[STMPE_IDX_GPMR_LSB] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
 	int ret;
+	u8 reg, mask;
 
+	reg = stmpe_gpio_reg(stmpe, STMPE_IDX_GPMR_LSB, offset / 8);
+	mask = 1 << (offset % 8);
 	ret = stmpe_reg_read(stmpe, reg);
 	if (ret < 0)
 		return ret;
@@ -65,8 +76,10 @@ static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	int which = val ? STMPE_IDX_GPSR_LSB : STMPE_IDX_GPCR_LSB;
-	u8 reg = stmpe->regs[which] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
+	u8 reg, mask;
+
+	reg = stmpe_gpio_reg(stmpe, which, offset / 8);
+	mask = 1 << (offset % 8);
 
 	/*
 	 * Some variants have single register for gpio set/clear functionality.
@@ -83,8 +96,10 @@ static int stmpe_gpio_direction_output(struct gpio_chip *chip,
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
+	u8 reg, mask;
+
+	reg = stmpe_gpio_reg(stmpe, STMPE_IDX_GPDR_LSB, offset / 8);
+	mask = 1 << (offset % 8);
 
 	stmpe_gpio_set(chip, offset, val);
 
@@ -96,8 +111,10 @@ static int stmpe_gpio_direction_input(struct gpio_chip *chip,
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
+	u8 reg, mask;
+
+	reg = stmpe_gpio_reg(stmpe, STMPE_IDX_GPDR_LSB, offset / 8);
+	mask = 1 << (offset % 8);
 
 	return stmpe_set_bits(stmpe, reg, mask, 0);
 }
@@ -177,6 +194,7 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 		[REG_IE]	= STMPE_IDX_IEGPIOR_LSB,
 	};
 	int i, j;
+	u8 reg;
 
 	for (i = 0; i < CACHE_NR_REGS; i++) {
 		/* STMPE801 doesn't have RE and FE registers */
@@ -192,7 +210,8 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 				continue;
 
 			stmpe_gpio->oldregs[i][j] = new;
-			stmpe_reg_write(stmpe, stmpe->regs[regmap[i]] - j, new);
+			reg = stmpe_gpio_reg(stmpe, regmap[i], j);
+			stmpe_reg_write(stmpe, reg, new);
 		}
 	}
 
@@ -232,18 +251,20 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 {
 	struct stmpe_gpio *stmpe_gpio = dev;
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 statmsbreg = stmpe->regs[STMPE_IDX_ISGPIOR_MSB];
 	int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
 	u8 status[num_banks];
 	int ret;
 	int i;
+	bool lsb = stmpe->partnum == STMPE1801;
+	u8 statmsbreg = lsb ? stmpe->regs[STMPE_IDX_ISGPIOR_LSB] :
+			stmpe->regs[STMPE_IDX_ISGPIOR_MSB];
 
 	ret = stmpe_block_read(stmpe, statmsbreg, num_banks, status);
 	if (ret < 0)
 		return IRQ_NONE;
 
 	for (i = 0; i < num_banks; i++) {
-		int bank = num_banks - i - 1;
+		int bank = lsb ? i : num_banks - i - 1;
 		unsigned int enabled = stmpe_gpio->regs[REG_IE][bank];
 		unsigned int stat = status[i];
 
@@ -262,10 +283,11 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 
 		stmpe_reg_write(stmpe, statmsbreg + i, status[i]);
 
-		/* Edge detect register is not present on 801 */
-		if (stmpe->partnum != STMPE801)
-			stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB]
-					+ i, status[i]);
+		/* Edge detect register is not present on 801 and 1801 */
+		if (stmpe->partnum != STMPE801 && stmpe->partnum != STMPE1801)
+			stmpe_reg_write(stmpe,
+				stmpe->regs[STMPE_IDX_GPEDR_MSB] + i,
+				status[i]);
 	}
 
 	return IRQ_HANDLED;
-- 
1.7.10

