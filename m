Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaIIC0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:26:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:37975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884AbaIIC0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:26:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,489,1406617200"; 
   d="scan'208";a="588301981"
From: Aaron Lu <aaron.lu@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-gpio@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH 1/2] gpio / CrystalCove: support virtual GPIO
Date: Tue,  9 Sep 2014 10:26:01 +0800
Message-Id: <1410229562-11507-2-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410229562-11507-1-git-send-email-aaron.lu@intel.com>
References: <1410229562-11507-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtual GPIO introduced in ACPI table of Baytrail-T based system is
used to solve a problem under Windows. We do not have such problems
under Linux so we do not actually need them. But we have to tell GPIO
library that the Crystal Cove GPIO chip has this many GPIO pins or the
common GPIO handler will refuse any access to those high number GPIO
pins, which will resulted in a failure evaluation of every ACPI control
method that is used to turn on/off power resource and/or report sensor
temperatures.

Due to the high number of virtual GPIOs, the value of ARCH_NR_GPIOS is
bumped from 256 to 512 to avoid failures on platforms that have various
GPIO controllers.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/gpio/gpio-crystalcove.c | 19 ++++++++++++++++---
 include/asm-generic/gpio.h      |  2 +-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 934462f5bd22..a8daada67aa4 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -24,6 +24,7 @@
 #include <linux/mfd/intel_soc_pmic.h>
 
 #define CRYSTALCOVE_GPIO_NUM	16
+#define CRYSTALCOVE_VGPIO_NUM	0x5e
 
 #define UPDATE_IRQ_TYPE		BIT(0)
 #define UPDATE_IRQ_MASK		BIT(1)
@@ -130,6 +131,9 @@ static int crystalcove_gpio_dir_in(struct gpio_chip *chip, unsigned gpio)
 {
 	struct crystalcove_gpio *cg = to_cg(chip);
 
+	if (gpio > CRYSTALCOVE_VGPIO_NUM)
+		return 0;
+
 	return regmap_write(cg->regmap, to_reg(gpio, CTRL_OUT),
 			    CTLO_INPUT_SET);
 }
@@ -139,6 +143,9 @@ static int crystalcove_gpio_dir_out(struct gpio_chip *chip, unsigned gpio,
 {
 	struct crystalcove_gpio *cg = to_cg(chip);
 
+	if (gpio > CRYSTALCOVE_VGPIO_NUM)
+		return 0;
+
 	return regmap_write(cg->regmap, to_reg(gpio, CTRL_OUT),
 			    CTLO_OUTPUT_SET | value);
 }
@@ -149,6 +156,9 @@ static int crystalcove_gpio_get(struct gpio_chip *chip, unsigned gpio)
 	int ret;
 	unsigned int val;
 
+	if (gpio > CRYSTALCOVE_VGPIO_NUM)
+		return 0;
+
 	ret = regmap_read(cg->regmap, to_reg(gpio, CTRL_IN), &val);
 	if (ret)
 		return ret;
@@ -161,6 +171,9 @@ static void crystalcove_gpio_set(struct gpio_chip *chip,
 {
 	struct crystalcove_gpio *cg = to_cg(chip);
 
+	if (gpio > CRYSTALCOVE_VGPIO_NUM)
+		return;
+
 	if (value)
 		regmap_update_bits(cg->regmap, to_reg(gpio, CTRL_OUT), 1, 1);
 	else
@@ -256,7 +269,7 @@ static irqreturn_t crystalcove_gpio_irq_handler(int irq, void *data)
 
 	pending = p0 | p1 << 8;
 
-	for (gpio = 0; gpio < cg->chip.ngpio; gpio++) {
+	for (gpio = 0; gpio < CRYSTALCOVE_GPIO_NUM; gpio++) {
 		if (pending & BIT(gpio)) {
 			virq = irq_find_mapping(cg->chip.irqdomain, gpio);
 			generic_handle_irq(virq);
@@ -273,7 +286,7 @@ static void crystalcove_gpio_dbg_show(struct seq_file *s,
 	int gpio, offset;
 	unsigned int ctlo, ctli, mirqs0, mirqsx, irq;
 
-	for (gpio = 0; gpio < cg->chip.ngpio; gpio++) {
+	for (gpio = 0; gpio < CRYSTALCOVE_GPIO_NUM; gpio++) {
 		regmap_read(cg->regmap, to_reg(gpio, CTRL_OUT), &ctlo);
 		regmap_read(cg->regmap, to_reg(gpio, CTRL_IN), &ctli);
 		regmap_read(cg->regmap, gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0,
@@ -320,7 +333,7 @@ static int crystalcove_gpio_probe(struct platform_device *pdev)
 	cg->chip.get = crystalcove_gpio_get;
 	cg->chip.set = crystalcove_gpio_set;
 	cg->chip.base = -1;
-	cg->chip.ngpio = CRYSTALCOVE_GPIO_NUM;
+	cg->chip.ngpio = CRYSTALCOVE_VGPIO_NUM;
 	cg->chip.can_sleep = true;
 	cg->chip.dev = dev;
 	cg->chip.dbg_show = crystalcove_gpio_dbg_show;
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c1d4105e1c1d..383ade1a211b 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -27,7 +27,7 @@
  */
 
 #ifndef ARCH_NR_GPIOS
-#define ARCH_NR_GPIOS		256
+#define ARCH_NR_GPIOS		512
 #endif
 
 /*
-- 
1.9.3

