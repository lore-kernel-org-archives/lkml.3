Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559Ab3E3Kvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:51:31 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50028 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968083Ab3E3KvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:51:24 -0400
Message-ID: <1369911081.23034.42.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: MSP71xx: Remove gpio drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 30 May 2013 12:51:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2013 10:51:21.0718 (UTC) FILETIME=[9F3DA960:01CE5D23]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PMC MSP71XX gpio drivers were added in v2.6.28, see commit
9fa32c6b02 ("MIPS: PMC MSP71XX gpio drivers"). They are only built if
CONFIG_HAVE_GPIO_LIB is set.

But the Kconfig symbol HAVE_GPIO_LIB was already removed in v2.6.27, see
commit 7444a72eff ("gpiolib: allow user-selection"). So these drivers
were never buildable. Perhaps no-one noticed because there are no in
tree users of msp71xx_init_gpio() and msp71xx_init_gpio_extended().
Anyhow, these drivers can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h |  46 ------
 arch/mips/pmcs-msp71xx/Makefile                |   1 -
 arch/mips/pmcs-msp71xx/gpio.c                  | 216 -------------------------
 arch/mips/pmcs-msp71xx/gpio_extended.c         | 146 -----------------
 4 files changed, 409 deletions(-)
 delete mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
 delete mode 100644 arch/mips/pmcs-msp71xx/gpio.c
 delete mode 100644 arch/mips/pmcs-msp71xx/gpio_extended.c

diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h b/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
deleted file mode 100644
index ebdbab9..0000000
--- a/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * include/asm-mips/pmc-sierra/msp71xx/gpio.h
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * @author Patrick Glass <patrickglass@gmail.com>
- */
-
-#ifndef __PMC_MSP71XX_GPIO_H
-#define __PMC_MSP71XX_GPIO_H
-
-/* Max number of gpio's is 28 on chip plus 3 banks of I2C IO Expanders */
-#define ARCH_NR_GPIOS (28 + (3 * 8))
-
-/* new generic GPIO API - see Documentation/gpio.txt */
-#include <asm-generic/gpio.h>
-
-#define gpio_get_value	__gpio_get_value
-#define gpio_set_value	__gpio_set_value
-#define gpio_cansleep	__gpio_cansleep
-
-/* Setup calls for the gpio and gpio extended */
-extern void msp71xx_init_gpio(void);
-extern void msp71xx_init_gpio_extended(void);
-extern int msp71xx_set_output_drive(unsigned gpio, int value);
-
-/* Custom output drive functionss */
-static inline int gpio_set_output_drive(unsigned gpio, int value)
-{
-	return msp71xx_set_output_drive(gpio, value);
-}
-
-/* IRQ's are not supported for gpio lines */
-static inline int gpio_to_irq(unsigned gpio)
-{
-	return -EINVAL;
-}
-
-static inline int irq_to_gpio(unsigned irq)
-{
-	return -EINVAL;
-}
-
-#endif /* __PMC_MSP71XX_GPIO_H */
diff --git a/arch/mips/pmcs-msp71xx/Makefile b/arch/mips/pmcs-msp71xx/Makefile
index cefba77..9201c8b 100644
--- a/arch/mips/pmcs-msp71xx/Makefile
+++ b/arch/mips/pmcs-msp71xx/Makefile
@@ -3,7 +3,6 @@
 #
 obj-y += msp_prom.o msp_setup.o msp_irq.o \
 	 msp_time.o msp_serial.o msp_elb.o
-obj-$(CONFIG_HAVE_GPIO_LIB) += gpio.o gpio_extended.o
 obj-$(CONFIG_PMC_MSP7120_GW) += msp_hwbutton.o
 obj-$(CONFIG_IRQ_MSP_SLP) += msp_irq_slp.o
 obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
diff --git a/arch/mips/pmcs-msp71xx/gpio.c b/arch/mips/pmcs-msp71xx/gpio.c
deleted file mode 100644
index aaccbe5..0000000
--- a/arch/mips/pmcs-msp71xx/gpio.c
+++ /dev/null
@@ -1,216 +0,0 @@
-/*
- * Generic PMC MSP71xx GPIO handling. These base gpio are controlled by two
- * types of registers. The data register sets the output level when in output
- * mode and when in input mode will contain the value at the input. The config
- * register sets the various modes for each gpio.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * @author Patrick Glass <patrickglass@gmail.com>
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/gpio.h>
-#include <linux/spinlock.h>
-#include <linux/io.h>
-
-#define MSP71XX_CFG_OFFSET(gpio)	(4 * (gpio))
-#define CONF_MASK			0x0F
-#define MSP71XX_GPIO_INPUT		0x01
-#define MSP71XX_GPIO_OUTPUT		0x08
-
-#define MSP71XX_GPIO_BASE		0x0B8400000L
-
-#define to_msp71xx_gpio_chip(c) container_of(c, struct msp71xx_gpio_chip, chip)
-
-static spinlock_t gpio_lock;
-
-/*
- * struct msp71xx_gpio_chip - container for gpio chip and registers
- * @chip: chip structure for the specified gpio bank
- * @data_reg: register for reading and writing the gpio pin value
- * @config_reg: register to set the mode for the gpio pin bank
- * @out_drive_reg: register to set the output drive mode for the gpio pin bank
- */
-struct msp71xx_gpio_chip {
-	struct gpio_chip chip;
-	void __iomem *data_reg;
-	void __iomem *config_reg;
-	void __iomem *out_drive_reg;
-};
-
-/*
- * msp71xx_gpio_get() - return the chip's gpio value
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose value will be returned
- *
- * It will return 0 if gpio value is low and other if high.
- */
-static int msp71xx_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	struct msp71xx_gpio_chip *msp_chip = to_msp71xx_gpio_chip(chip);
-
-	return __raw_readl(msp_chip->data_reg) & (1 << offset);
-}
-
-/*
- * msp71xx_gpio_set() - set the output value for the gpio
- * @chip: chip structure who controls the specified gpio
- * @offset: gpio whose value will be assigned
- * @value: logic level to assign to the gpio initially
- *
- * This will set the gpio bit specified to the desired value. It will set the
- * gpio pin low if value is 0 otherwise it will be high.
- */
-static void msp71xx_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	struct msp71xx_gpio_chip *msp_chip = to_msp71xx_gpio_chip(chip);
-	unsigned long flags;
-	u32 data;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	data = __raw_readl(msp_chip->data_reg);
-	if (value)
-		data |= (1 << offset);
-	else
-		data &= ~(1 << offset);
-	__raw_writel(data, msp_chip->data_reg);
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-}
-
-/*
- * msp71xx_set_gpio_mode() - declare the mode for a gpio
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose value will be assigned
- * @mode: desired configuration for the gpio (see datasheet)
- *
- * It will set the gpio pin config to the @mode value passed in.
- */
-static int msp71xx_set_gpio_mode(struct gpio_chip *chip,
-				 unsigned offset, int mode)
-{
-	struct msp71xx_gpio_chip *msp_chip = to_msp71xx_gpio_chip(chip);
-	const unsigned bit_offset = MSP71XX_CFG_OFFSET(offset);
-	unsigned long flags;
-	u32 cfg;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	cfg = __raw_readl(msp_chip->config_reg);
-	cfg &= ~(CONF_MASK << bit_offset);
-	cfg |= (mode << bit_offset);
-	__raw_writel(cfg, msp_chip->config_reg);
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	return 0;
-}
-
-/*
- * msp71xx_direction_output() - declare the direction mode for a gpio
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose value will be assigned
- * @value: logic level to assign to the gpio initially
- *
- * This call will set the mode for the @gpio to output. It will set the
- * gpio pin low if value is 0 otherwise it will be high.
- */
-static int msp71xx_direction_output(struct gpio_chip *chip,
-				    unsigned offset, int value)
-{
-	msp71xx_gpio_set(chip, offset, value);
-
-	return msp71xx_set_gpio_mode(chip, offset, MSP71XX_GPIO_OUTPUT);
-}
-
-/*
- * msp71xx_direction_input() - declare the direction mode for a gpio
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose to which the value will be assigned
- *
- * This call will set the mode for the @gpio to input.
- */
-static int msp71xx_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	return msp71xx_set_gpio_mode(chip, offset, MSP71XX_GPIO_INPUT);
-}
-
-/*
- * msp71xx_set_output_drive() - declare the output drive for the gpio line
- * @gpio: gpio pin whose output drive you wish to modify
- * @value: zero for active drain 1 for open drain drive
- *
- * This call will set the output drive mode for the @gpio to output.
- */
-int msp71xx_set_output_drive(unsigned gpio, int value)
-{
-	unsigned long flags;
-	u32 data;
-
-	if (gpio > 15 || gpio < 0)
-		return -EINVAL;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	data = __raw_readl((void __iomem *)(MSP71XX_GPIO_BASE + 0x190));
-	if (value)
-		data |= (1 << gpio);
-	else
-		data &= ~(1 << gpio);
-	__raw_writel(data, (void __iomem *)(MSP71XX_GPIO_BASE + 0x190));
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(msp71xx_set_output_drive);
-
-#define MSP71XX_GPIO_BANK(name, dr, cr, base_gpio, num_gpio) \
-{ \
-	.chip = { \
-		.label		  = name, \
-		.direction_input  = msp71xx_direction_input, \
-		.direction_output = msp71xx_direction_output, \
-		.get		  = msp71xx_gpio_get, \
-		.set		  = msp71xx_gpio_set, \
-		.base		  = base_gpio, \
-		.ngpio		  = num_gpio \
-	}, \
-	.data_reg	= (void __iomem *)(MSP71XX_GPIO_BASE + dr), \
-	.config_reg	= (void __iomem *)(MSP71XX_GPIO_BASE + cr), \
-	.out_drive_reg	= (void __iomem *)(MSP71XX_GPIO_BASE + 0x190), \
-}
-
-/*
- * struct msp71xx_gpio_banks[] - container array of gpio banks
- * @chip: chip structure for the specified gpio bank
- * @data_reg: register for reading and writing the gpio pin value
- * @config_reg: register to set the mode for the gpio pin bank
- *
- * This array structure defines the gpio banks for the PMC MIPS Processor.
- * We specify the bank name, the data register, the config register, base
- * starting gpio number, and the number of gpios exposed by the bank.
- */
-static struct msp71xx_gpio_chip msp71xx_gpio_banks[] = {
-
-	MSP71XX_GPIO_BANK("GPIO_1_0", 0x170, 0x180, 0, 2),
-	MSP71XX_GPIO_BANK("GPIO_5_2", 0x174, 0x184, 2, 4),
-	MSP71XX_GPIO_BANK("GPIO_9_6", 0x178, 0x188, 6, 4),
-	MSP71XX_GPIO_BANK("GPIO_15_10", 0x17C, 0x18C, 10, 6),
-};
-
-void __init msp71xx_init_gpio(void)
-{
-	int i;
-
-	spin_lock_init(&gpio_lock);
-
-	for (i = 0; i < ARRAY_SIZE(msp71xx_gpio_banks); i++)
-		gpiochip_add(&msp71xx_gpio_banks[i].chip);
-}
diff --git a/arch/mips/pmcs-msp71xx/gpio_extended.c b/arch/mips/pmcs-msp71xx/gpio_extended.c
deleted file mode 100644
index 2a99f36..0000000
--- a/arch/mips/pmcs-msp71xx/gpio_extended.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/*
- * Generic PMC MSP71xx EXTENDED (EXD) GPIO handling. The extended gpio is
- * a set of hardware registers that have no need for explicit locking as
- * it is handled by unique method of writing individual set/clr bits.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * @author Patrick Glass <patrickglass@gmail.com>
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/gpio.h>
-#include <linux/io.h>
-
-#define MSP71XX_DATA_OFFSET(gpio)	(2 * (gpio))
-#define MSP71XX_READ_OFFSET(gpio)	(MSP71XX_DATA_OFFSET(gpio) + 1)
-#define MSP71XX_CFG_OUT_OFFSET(gpio)	(MSP71XX_DATA_OFFSET(gpio) + 16)
-#define MSP71XX_CFG_IN_OFFSET(gpio)	(MSP71XX_CFG_OUT_OFFSET(gpio) + 1)
-
-#define MSP71XX_EXD_GPIO_BASE	0x0BC000000L
-
-#define to_msp71xx_exd_gpio_chip(c) \
-			container_of(c, struct msp71xx_exd_gpio_chip, chip)
-
-/*
- * struct msp71xx_exd_gpio_chip - container for gpio chip and registers
- * @chip: chip structure for the specified gpio bank
- * @reg: register for control and data of gpio pin
- */
-struct msp71xx_exd_gpio_chip {
-	struct gpio_chip chip;
-	void __iomem *reg;
-};
-
-/*
- * msp71xx_exd_gpio_get() - return the chip's gpio value
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose value will be returned
- *
- * It will return 0 if gpio value is low and other if high.
- */
-static int msp71xx_exd_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	struct msp71xx_exd_gpio_chip *msp71xx_chip =
-	    to_msp71xx_exd_gpio_chip(chip);
-	const unsigned bit = MSP71XX_READ_OFFSET(offset);
-
-	return __raw_readl(msp71xx_chip->reg) & (1 << bit);
-}
-
-/*
- * msp71xx_exd_gpio_set() - set the output value for the gpio
- * @chip: chip structure who controls the specified gpio
- * @offset: gpio whose value will be assigned
- * @value: logic level to assign to the gpio initially
- *
- * This will set the gpio bit specified to the desired value. It will set the
- * gpio pin low if value is 0 otherwise it will be high.
- */
-static void msp71xx_exd_gpio_set(struct gpio_chip *chip,
-				 unsigned offset, int value)
-{
-	struct msp71xx_exd_gpio_chip *msp71xx_chip =
-	    to_msp71xx_exd_gpio_chip(chip);
-	const unsigned bit = MSP71XX_DATA_OFFSET(offset);
-
-	__raw_writel(1 << (bit + (value ? 1 : 0)), msp71xx_chip->reg);
-}
-
-/*
- * msp71xx_exd_direction_output() - declare the direction mode for a gpio
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose value will be assigned
- * @value: logic level to assign to the gpio initially
- *
- * This call will set the mode for the @gpio to output. It will set the
- * gpio pin low if value is 0 otherwise it will be high.
- */
-static int msp71xx_exd_direction_output(struct gpio_chip *chip,
-					unsigned offset, int value)
-{
-	struct msp71xx_exd_gpio_chip *msp71xx_chip =
-	    to_msp71xx_exd_gpio_chip(chip);
-
-	msp71xx_exd_gpio_set(chip, offset, value);
-	__raw_writel(1 << MSP71XX_CFG_OUT_OFFSET(offset), msp71xx_chip->reg);
-	return 0;
-}
-
-/*
- * msp71xx_exd_direction_input() - declare the direction mode for a gpio
- * @chip: chip structure which controls the specified gpio
- * @offset: gpio whose to which the value will be assigned
- *
- * This call will set the mode for the @gpio to input.
- */
-static int msp71xx_exd_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	struct msp71xx_exd_gpio_chip *msp71xx_chip =
-	    to_msp71xx_exd_gpio_chip(chip);
-
-	__raw_writel(1 << MSP71XX_CFG_IN_OFFSET(offset), msp71xx_chip->reg);
-	return 0;
-}
-
-#define MSP71XX_EXD_GPIO_BANK(name, exd_reg, base_gpio, num_gpio) \
-{ \
-	.chip = { \
-		.label		  = name, \
-		.direction_input  = msp71xx_exd_direction_input, \
-		.direction_output = msp71xx_exd_direction_output, \
-		.get		  = msp71xx_exd_gpio_get, \
-		.set		  = msp71xx_exd_gpio_set, \
-		.base		  = base_gpio, \
-		.ngpio		  = num_gpio, \
-	}, \
-	.reg	= (void __iomem *)(MSP71XX_EXD_GPIO_BASE + exd_reg), \
-}
-
-/*
- * struct msp71xx_exd_gpio_banks[] - container array of gpio banks
- * @chip: chip structure for the specified gpio bank
- * @reg: register for reading and writing the gpio pin value
- *
- * This array structure defines the extended gpio banks for the
- * PMC MIPS Processor. We specify the bank name, the data/config
- * register,the base starting gpio number, and the number of
- * gpios exposed by the bank of gpios.
- */
-static struct msp71xx_exd_gpio_chip msp71xx_exd_gpio_banks[] = {
-
-	MSP71XX_EXD_GPIO_BANK("GPIO_23_16", 0x188, 16, 8),
-	MSP71XX_EXD_GPIO_BANK("GPIO_27_24", 0x18C, 24, 4),
-};
-
-void __init msp71xx_init_gpio_extended(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(msp71xx_exd_gpio_banks); i++)
-		gpiochip_add(&msp71xx_exd_gpio_banks[i].chip);
-}
-- 
1.7.11.7



