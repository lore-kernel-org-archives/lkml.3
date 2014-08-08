Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaHHXsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:48:23 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36318 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHHXsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:48:21 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] pinctrl: exynos: Lock GPIOs as interrupts when used as EINTs
Date: Sat,  9 Aug 2014 01:48:05 +0200
Message-Id: <1407541685-20021-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Currently after configuring a GPIO pin as an interrupt related pinmux
registers are changed, but there is no protection from calling
gpio_direction_*() in a badly written driver, which would cause the same
pinmux register to be reconfigured for regular input/output and this
disabling interrupt capability of the pin.

This patch addresses this issue by moving pinmux reconfiguration to
.irq_{request,release}_resources() callback of irq_chip and calling
gpio_lock_as_irq() helper to prevent reconfiguration of pin direction.

Setting up a GPIO interrupt on Samsung SoCs is a two-step operation -
in addition to trigger configuration in a dedicated register, the pinmux
must be also reconfigured to GPIO interrupt, which is a different function
than normal GPIO input, although I/O-wise they both behave in the same way
and gpio_get_value() can be used on a pin configured as IRQ as well.

Such design implies subtleties such as gpio_direction_input() not having
to fail if a pin is already configured as an interrupt nor change the
configuration to normal input. But the FLAG_USED_AS_IRQ set in gpiolib by
gpio_lock_as_irq() is only used to check that gpio_direction_output() is
not called, it's not used to prevent gpio_direction_input() to be called.
So this is not a complete solution for Samsung SoCs but it's definitely a
move in the right direction.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[javier: use request resources instead of startup and expand commit message]
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

This patch solves the issue explained in https://lkml.org/lkml/2014/8/8/461

 drivers/pinctrl/samsung/pinctrl-exynos.c  | 69 ++++++++++++++++++++++++++++---
 drivers/pinctrl/samsung/pinctrl-samsung.h |  1 +
 2 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 003bfd8..d7154ed 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -127,14 +127,10 @@ static int exynos_irq_set_type(struct irq_data *irqd, unsigned int type)
 	struct irq_chip *chip = irq_data_get_irq_chip(irqd);
 	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
-	struct samsung_pin_bank_type *bank_type = bank->type;
 	struct samsung_pinctrl_drv_data *d = bank->drvdata;
-	unsigned int pin = irqd->hwirq;
-	unsigned int shift = EXYNOS_EINT_CON_LEN * pin;
+	unsigned int shift = EXYNOS_EINT_CON_LEN * irqd->hwirq;
 	unsigned int con, trig_type;
 	unsigned long reg_con = our_chip->eint_con + bank->eint_offset;
-	unsigned long flags;
-	unsigned int mask;
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -167,8 +163,32 @@ static int exynos_irq_set_type(struct irq_data *irqd, unsigned int type)
 	con |= trig_type << shift;
 	writel(con, d->virt_base + reg_con);
 
+	return 0;
+}
+
+static int exynos_irq_request_resources(struct irq_data *irqd)
+{
+	struct irq_chip *chip = irq_data_get_irq_chip(irqd);
+	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
+	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
+	struct samsung_pin_bank_type *bank_type = bank->type;
+	struct samsung_pinctrl_drv_data *d = bank->drvdata;
+	unsigned int shift = EXYNOS_EINT_CON_LEN * irqd->hwirq;
+	unsigned long reg_con = our_chip->eint_con + bank->eint_offset;
+	unsigned long flags;
+	unsigned int mask;
+	unsigned int con;
+	int ret;
+
+	ret = gpio_lock_as_irq(&bank->gpio_chip, irqd->hwirq);
+	if (ret) {
+		dev_err(bank->gpio_chip.dev, "unable to lock pin %s-%lu IRQ\n",
+			bank->name, irqd->hwirq);
+		return ret;
+	}
+
 	reg_con = bank->pctl_offset + bank_type->reg_offset[PINCFG_TYPE_FUNC];
-	shift = pin * bank_type->fld_width[PINCFG_TYPE_FUNC];
+	shift = irqd->hwirq * bank_type->fld_width[PINCFG_TYPE_FUNC];
 	mask = (1 << bank_type->fld_width[PINCFG_TYPE_FUNC]) - 1;
 
 	spin_lock_irqsave(&bank->slock, flags);
@@ -180,9 +200,42 @@ static int exynos_irq_set_type(struct irq_data *irqd, unsigned int type)
 
 	spin_unlock_irqrestore(&bank->slock, flags);
 
+	exynos_irq_unmask(irqd);
+
 	return 0;
 }
 
+static void exynos_irq_release_resources(struct irq_data *irqd)
+{
+	struct irq_chip *chip = irq_data_get_irq_chip(irqd);
+	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
+	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
+	struct samsung_pin_bank_type *bank_type = bank->type;
+	struct samsung_pinctrl_drv_data *d = bank->drvdata;
+	unsigned int shift = EXYNOS_EINT_CON_LEN * irqd->hwirq;
+	unsigned long reg_con = our_chip->eint_con + bank->eint_offset;
+	unsigned long flags;
+	unsigned int mask;
+	unsigned int con;
+
+	reg_con = bank->pctl_offset + bank_type->reg_offset[PINCFG_TYPE_FUNC];
+	shift = irqd->hwirq * bank_type->fld_width[PINCFG_TYPE_FUNC];
+	mask = (1 << bank_type->fld_width[PINCFG_TYPE_FUNC]) - 1;
+
+	exynos_irq_mask(irqd);
+
+	spin_lock_irqsave(&bank->slock, flags);
+
+	con = readl(d->virt_base + reg_con);
+	con &= ~(mask << shift);
+	con |= FUNC_INPUT << shift;
+	writel(con, d->virt_base + reg_con);
+
+	spin_unlock_irqrestore(&bank->slock, flags);
+
+	gpio_unlock_as_irq(&bank->gpio_chip, irqd->hwirq);
+}
+
 /*
  * irq_chip for gpio interrupts.
  */
@@ -193,6 +246,8 @@ static struct exynos_irq_chip exynos_gpio_irq_chip = {
 		.irq_mask = exynos_irq_mask,
 		.irq_ack = exynos_irq_ack,
 		.irq_set_type = exynos_irq_set_type,
+		.irq_request_resources = exynos_irq_request_resources,
+		.irq_release_resources = exynos_irq_release_resources,
 	},
 	.eint_con = EXYNOS_GPIO_ECON_OFFSET,
 	.eint_mask = EXYNOS_GPIO_EMASK_OFFSET,
@@ -336,6 +391,8 @@ static struct exynos_irq_chip exynos_wkup_irq_chip = {
 		.irq_ack = exynos_irq_ack,
 		.irq_set_type = exynos_irq_set_type,
 		.irq_set_wake = exynos_wkup_irq_set_wake,
+		.irq_request_resources = exynos_irq_request_resources,
+		.irq_release_resources = exynos_irq_release_resources,
 	},
 	.eint_con = EXYNOS_WKUP_ECON_OFFSET,
 	.eint_mask = EXYNOS_WKUP_EMASK_OFFSET,
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index 2b88232..5cedc9d 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -26,6 +26,7 @@
 #include <linux/gpio.h>
 
 /* pinmux function number for pin as gpio output line */
+#define FUNC_INPUT	0x0
 #define FUNC_OUTPUT	0x1
 
 /**
-- 
2.0.0.rc2

