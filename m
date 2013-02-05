Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3BETuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:50:39 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:45639 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771Ab3BETt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:27 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/14] pinctrl/abx500: move IRQ handling to ab8500-core
Date: Tue, 5 Feb 2013 20:48:28 +0100
Message-ID: <1360093715-6348-8-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

In its current state the gpio-ab8500 driver looks after some GPIO
lines found on the AB8500 MFD chip. It also controls all of its
own IRQ handling for these GPIOs by inventing some virtual IRQs
and handing those out to sub-devices. There has been quite a bit
of controversy over this and it was a contributing factor to the
driver being marked as BROKEN in Mainline.

The reason for adopting this method was due to added complexity
in the hardware. Unusually, each GPIO has two separate IRQs
associated with it, one for a rising and a different one for a
falling interrupt. Using this method complicates matters further
because the GPIO IRQs are actually sandwiched between a bunch
of IRQs which are handled solely by the AB8500 core driver.

The best way for us to take this forward is to get rid of the
virtual IRQs and only hand out the rising IRQ lines. If a
sub-driver wishes to request a falling interrupt, they can do
so by requesting a rising line in the normal way. They just
have to add IRQ_TYPE_EDGE_FALLING or IRQ_TYPE_EDGE_BOTH, if
they require both in the flags. Then if a falling IRQ is
triggered, the AB8500 core driver will know how to handle the
added complexity accordingly. This should greatly simply things.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
[Augment to keep irq_base for a while (removed later)]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 299 +--------------------------------------
 1 file changed, 3 insertions(+), 296 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index a9e720f..716c835 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/mfd/abx500.h>
@@ -85,20 +86,11 @@
 #define AB8540_GPIO_VINSEL_REG	0x47
 #define AB8540_GPIO_PULL_UPDOWN_REG	0x48
 #define AB8500_GPIO_ALTFUN_REG	0x50
-#define AB8500_NUM_VIR_GPIO_IRQ	16
 #define AB8540_GPIO_PULL_UPDOWN_MASK	0x03
 #define AB8540_GPIO_VINSEL_MASK	0x03
 #define AB8540_GPIOX_VBAT_START	51
 #define AB8540_GPIOX_VBAT_END	54
 
-enum abx500_gpio_action {
-	NONE,
-	STARTUP,
-	SHUTDOWN,
-	MASK,
-	UNMASK
-};
-
 struct abx500_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctldev;
@@ -107,14 +99,8 @@ struct abx500_pinctrl {
 	struct ab8500 *parent;
 	struct mutex lock;
 	u32 irq_base;
-	enum abx500_gpio_action irq_action;
-	u16 rising;
-	u16 falling;
 	struct abx500_gpio_irq_cluster *irq_cluster;
 	int irq_cluster_size;
-	int irq_gpio_rising_offset;
-	int irq_gpio_falling_offset;
-	int irq_gpio_factor;
 };
 
 /**
@@ -469,7 +455,6 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 				     struct gpio_chip *chip,
 				     unsigned offset, unsigned gpio)
 {
-	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
 	const char *label = gpiochip_is_requested(chip, offset - 1);
 	u8 gpio_offset = offset - 1;
 	int mode = -1;
@@ -498,25 +483,6 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 		   : "?  ")
 		   : (pull ? "pull up" : "pull down"),
 		   (mode < 0) ? "unknown" : modes[mode]);
-
-	if (label && !is_out) {
-		int irq = gpio_to_irq(gpio);
-		struct irq_desc	*desc = irq_to_desc(irq);
-
-		if (irq >= 0 && desc->action) {
-			char *trigger;
-			int irq_offset = irq - pct->irq_base;
-
-			if (pct->rising & BIT(irq_offset))
-				trigger = "edge-rising";
-			else if (pct->falling & BIT(irq_offset))
-				trigger = "edge-falling";
-			else
-				trigger = "edge-undefined";
-
-			seq_printf(s, " irq-%d %s", irq, trigger);
-		}
-	}
 }
 
 static void abx500_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
@@ -570,219 +536,6 @@ static struct gpio_chip abx500gpio_chip = {
 	.dbg_show		= abx500_gpio_dbg_show,
 };
 
-static unsigned int irq_to_rising(unsigned int irq)
-{
-	struct abx500_pinctrl *pct = irq_get_chip_data(irq);
-	int offset = irq - pct->irq_base;
-	int new_irq;
-
-	new_irq = offset * pct->irq_gpio_factor
-		+ pct->irq_gpio_rising_offset
-		+ pct->parent->irq_base;
-
-	return new_irq;
-}
-
-static unsigned int irq_to_falling(unsigned int irq)
-{
-	struct abx500_pinctrl *pct = irq_get_chip_data(irq);
-	int offset = irq - pct->irq_base;
-	int new_irq;
-
-	new_irq = offset * pct->irq_gpio_factor
-		+ pct->irq_gpio_falling_offset
-		+ pct->parent->irq_base;
-	return new_irq;
-
-}
-
-static unsigned int rising_to_irq(unsigned int irq, void *dev)
-{
-	struct abx500_pinctrl *pct = dev;
-	int offset, new_irq;
-
-	offset = irq - pct->irq_gpio_rising_offset
-		- pct->parent->irq_base;
-	new_irq = (offset / pct->irq_gpio_factor)
-		+ pct->irq_base;
-
-	return new_irq;
-}
-
-static unsigned int falling_to_irq(unsigned int irq, void *dev)
-{
-	struct abx500_pinctrl *pct = dev;
-	int offset, new_irq;
-
-	offset = irq - pct->irq_gpio_falling_offset
-		- pct->parent->irq_base;
-	new_irq = (offset / pct->irq_gpio_factor)
-		+ pct->irq_base;
-
-	return new_irq;
-}
-
-/*
- * IRQ handler
- */
-
-static irqreturn_t handle_rising(int irq, void *dev)
-{
-
-	handle_nested_irq(rising_to_irq(irq , dev));
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t handle_falling(int irq, void *dev)
-{
-
-	handle_nested_irq(falling_to_irq(irq, dev));
-	return IRQ_HANDLED;
-}
-
-static void abx500_gpio_irq_lock(struct irq_data *data)
-{
-	struct abx500_pinctrl *pct = irq_data_get_irq_chip_data(data);
-	mutex_lock(&pct->lock);
-}
-
-static void abx500_gpio_irq_sync_unlock(struct irq_data *data)
-{
-	struct abx500_pinctrl *pct = irq_data_get_irq_chip_data(data);
-	unsigned int irq = data->irq;
-	int offset = irq - pct->irq_base;
-	bool rising = pct->rising & BIT(offset);
-	bool falling = pct->falling & BIT(offset);
-	int ret;
-
-	switch (pct->irq_action)	{
-	case STARTUP:
-		if (rising)
-			ret = request_threaded_irq(irq_to_rising(irq),
-					NULL, handle_rising,
-					IRQF_TRIGGER_RISING | IRQF_NO_SUSPEND,
-					"abx500-gpio-r", pct);
-		if (falling)
-			ret = request_threaded_irq(irq_to_falling(irq),
-				       NULL, handle_falling,
-				       IRQF_TRIGGER_FALLING | IRQF_NO_SUSPEND,
-				       "abx500-gpio-f", pct);
-		break;
-	case SHUTDOWN:
-		if (rising)
-			free_irq(irq_to_rising(irq), pct);
-		if (falling)
-			free_irq(irq_to_falling(irq), pct);
-		break;
-	case MASK:
-		if (rising)
-			disable_irq(irq_to_rising(irq));
-		if (falling)
-			disable_irq(irq_to_falling(irq));
-		break;
-	case UNMASK:
-		if (rising)
-			enable_irq(irq_to_rising(irq));
-		if (falling)
-			enable_irq(irq_to_falling(irq));
-		break;
-	case NONE:
-		break;
-	}
-	pct->irq_action = NONE;
-	pct->rising &= ~(BIT(offset));
-	pct->falling &= ~(BIT(offset));
-	mutex_unlock(&pct->lock);
-}
-
-
-static void abx500_gpio_irq_mask(struct irq_data *data)
-{
-	struct abx500_pinctrl *pct = irq_data_get_irq_chip_data(data);
-	pct->irq_action = MASK;
-}
-
-static void abx500_gpio_irq_unmask(struct irq_data *data)
-{
-	struct abx500_pinctrl *pct =  irq_data_get_irq_chip_data(data);
-	pct->irq_action = UNMASK;
-}
-
-static int abx500_gpio_irq_set_type(struct irq_data *data, unsigned int type)
-{
-	struct abx500_pinctrl *pct = irq_data_get_irq_chip_data(data);
-	unsigned int irq = data->irq;
-	int offset = irq - pct->irq_base;
-
-	if (type == IRQ_TYPE_EDGE_BOTH) {
-		pct->rising =  BIT(offset);
-		pct->falling = BIT(offset);
-	} else if (type == IRQ_TYPE_EDGE_RISING) {
-		pct->rising =  BIT(offset);
-	} else  {
-		pct->falling = BIT(offset);
-	}
-	return 0;
-}
-
-static unsigned int abx500_gpio_irq_startup(struct irq_data *data)
-{
-	struct abx500_pinctrl *pct = irq_data_get_irq_chip_data(data);
-	pct->irq_action = STARTUP;
-	return 0;
-}
-
-static void abx500_gpio_irq_shutdown(struct irq_data *data)
-{
-	struct abx500_pinctrl *pct = irq_data_get_irq_chip_data(data);
-	pct->irq_action = SHUTDOWN;
-}
-
-static struct irq_chip abx500_gpio_irq_chip = {
-	.name			= "abx500-gpio",
-	.irq_startup		= abx500_gpio_irq_startup,
-	.irq_shutdown		= abx500_gpio_irq_shutdown,
-	.irq_bus_lock		= abx500_gpio_irq_lock,
-	.irq_bus_sync_unlock	= abx500_gpio_irq_sync_unlock,
-	.irq_mask		= abx500_gpio_irq_mask,
-	.irq_unmask		= abx500_gpio_irq_unmask,
-	.irq_set_type		= abx500_gpio_irq_set_type,
-};
-
-static int abx500_gpio_irq_init(struct abx500_pinctrl *pct)
-{
-	u32 base = pct->irq_base;
-	int irq;
-
-	for (irq = base; irq < base + AB8500_NUM_VIR_GPIO_IRQ ; irq++) {
-		irq_set_chip_data(irq, pct);
-		irq_set_chip_and_handler(irq, &abx500_gpio_irq_chip,
-				handle_simple_irq);
-		irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID);
-#else
-		irq_set_noprobe(irq);
-#endif
-	}
-
-	return 0;
-}
-
-static void abx500_gpio_irq_remove(struct abx500_pinctrl *pct)
-{
-	int base = pct->irq_base;
-	int irq;
-
-	for (irq = base; irq < base + AB8500_NUM_VIR_GPIO_IRQ; irq++) {
-#ifdef CONFIG_ARM
-		set_irq_flags(irq, 0);
-#endif
-		irq_set_chip_and_handler(irq, NULL, NULL);
-		irq_set_chip_data(irq, NULL);
-	}
-}
-
 static int abx500_pmx_get_funcs_cnt(struct pinctrl_dev *pctldev)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
@@ -811,43 +564,6 @@ static int abx500_pmx_get_func_groups(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static void abx500_disable_lazy_irq(struct gpio_chip *chip, unsigned gpio)
-{
-	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
-	int irq;
-	int offset;
-	bool rising;
-	bool falling;
-
-	/*
-	 * check if gpio has interrupt capability and convert
-	 * gpio number to irq
-	 * On ABx5xx, there is no GPIO0, GPIO1 is the
-	 * first one, so adjust gpio number
-	 */
-	gpio--;
-	irq =  gpio_to_irq(gpio + chip->base);
-	if (irq < 0)
-		return;
-
-	offset = irq - pct->irq_base;
-	rising = pct->rising & BIT(offset);
-	falling = pct->falling & BIT(offset);
-
-	/* nothing to do ?*/
-	if (!rising && !falling)
-		return;
-
-	if (rising) {
-		disable_irq(irq_to_rising(irq));
-		free_irq(irq_to_rising(irq), pct);
-	}
-	if (falling) {
-		disable_irq(irq_to_falling(irq));
-		free_irq(irq_to_falling(irq), pct);
-	}
-}
-
 static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 			     unsigned group)
 {
@@ -867,7 +583,6 @@ static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 		dev_dbg(pct->dev, "setting pin %d to altsetting %d\n",
 			g->pins[i], g->altsetting);
 
-		abx500_disable_lazy_irq(chip, g->pins[i]);
 		ret = abx500_set_mode(pctldev, chip, g->pins[i], g->altsetting);
 	}
 
@@ -1170,18 +885,12 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	pct->chip.ngpio = abx500_get_gpio_num(pct->soc);
 	pct->irq_cluster = pct->soc->gpio_irq_cluster;
 	pct->irq_cluster_size = pct->soc->ngpio_irq_cluster;
-	pct->irq_gpio_rising_offset = pct->soc->irq_gpio_rising_offset;
-	pct->irq_gpio_falling_offset = pct->soc->irq_gpio_falling_offset;
-	pct->irq_gpio_factor = pct->soc->irq_gpio_factor;
 
-	ret = abx500_gpio_irq_init(pct);
-	if (ret)
-		goto out_free;
 	ret = gpiochip_add(&pct->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
 		mutex_destroy(&pct->lock);
-		goto out_rem_irq;
+		return ret;
 	}
 	dev_info(&pdev->dev, "added gpiochip\n");
 
@@ -1216,9 +925,7 @@ out_rem_chip:
 	err = gpiochip_remove(&pct->chip);
 	if (err)
 		dev_info(&pdev->dev, "failed to remove gpiochip\n");
-out_rem_irq:
-	abx500_gpio_irq_remove(pct);
-out_free:
+
 	mutex_destroy(&pct->lock);
 	return ret;
 }
-- 
1.7.11.3

