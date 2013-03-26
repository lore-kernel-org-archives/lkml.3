Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab3DDKk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:40:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35317 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696Ab3DDKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:40:35 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Thomas Abraham <thomas.ab@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 2/3] pinctrl: exynos5440: add gpio interrupt support
Date: Wed, 27 Mar 2013 00:12:33 +0900
Message-Id: <1364310754-3692-3-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1364310754-3692-1-git-send-email-kgene.kim@samsung.com>
References: <1364310754-3692-1-git-send-email-kgene.kim@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.ab@samsung.com>

Exynos5440 supports gpio interrupts on gpios 16 to 23. The eight interrupt lines
originating from the pin-controller are connected to the gic. Add irq-chip support
for these interrupts.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/pinctrl/pinctrl-exynos5440.c |  142 ++++++++++++++++++++++++++++++++++
 1 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 96cb1e9..b5c5014 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -20,6 +20,9 @@
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
 #include "core.h"
 
 /* EXYNOS5440 GPIO and Pinctrl register offsets */
@@ -37,6 +40,7 @@
 #define GPIO_DS1		0x2C
 
 #define EXYNOS5440_MAX_PINS		23
+#define EXYNOS5440_MAX_GPIO_INT	8
 #define PIN_NAME_LENGTH		10
 
 #define GROUP_SUFFIX		"-grp"
@@ -109,6 +113,7 @@ struct exynos5440_pmx_func {
 struct exynos5440_pinctrl_priv_data {
 	void __iomem			*reg_base;
 	struct gpio_chip		*gc;
+	struct irq_domain		*irq_domain;
 
 	const struct exynos5440_pin_group	*pin_groups;
 	unsigned int			nr_groups;
@@ -116,6 +121,16 @@ struct exynos5440_pinctrl_priv_data {
 	unsigned int			nr_functions;
 };
 
+/**
+ * struct exynos5440_gpio_intr_data: private data for gpio interrupts.
+ * @priv: driver's private runtime data.
+ * @gpio_int: gpio interrupt number.
+ */
+struct exynos5440_gpio_intr_data {
+	struct exynos5440_pinctrl_priv_data	*priv;
+	unsigned int				gpio_int;
+};
+
 /* list of all possible config options supported */
 static struct pin_config {
 	char		*prop_cfg;
@@ -598,6 +613,22 @@ static int exynos5440_gpio_direction_output(struct gpio_chip *gc, unsigned offse
 	return 0;
 }
 
+/* gpiolib gpio_to_irq callback function */
+static int exynos5440_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct exynos5440_pinctrl_priv_data *priv = dev_get_drvdata(gc->dev);
+	unsigned int virq;
+
+	if (offset < 16 || offset > 23)
+		return -ENXIO;
+
+	if (!priv->irq_domain)
+		return -ENXIO;
+
+	virq = irq_create_mapping(priv->irq_domain, offset - 16);
+	return virq ? : -ENXIO;
+}
+
 /* parse the pin numbers listed in the 'samsung,exynos5440-pins' property */
 static int exynos5440_pinctrl_parse_dt_pins(struct platform_device *pdev,
 			struct device_node *cfg_np, unsigned int **pin_list,
@@ -821,6 +852,7 @@ static int exynos5440_gpiolib_register(struct platform_device *pdev,
 	gc->get = exynos5440_gpio_get;
 	gc->direction_input = exynos5440_gpio_direction_input;
 	gc->direction_output = exynos5440_gpio_direction_output;
+	gc->to_irq = exynos5440_gpio_to_irq;
 	gc->label = "gpiolib-exynos5440";
 	gc->owner = THIS_MODULE;
 	ret = gpiochip_add(gc);
@@ -845,6 +877,110 @@ static int exynos5440_gpiolib_unregister(struct platform_device *pdev,
 	return 0;
 }
 
+static void exynos5440_gpio_irq_unmask(struct irq_data *irqd)
+{
+	struct exynos5440_pinctrl_priv_data *d;
+	unsigned long gpio_int;
+
+	d = irq_data_get_irq_chip_data(irqd);
+	gpio_int = readl(d->reg_base + GPIO_INT);
+	gpio_int |= 1 << irqd->hwirq;
+	writel(gpio_int, d->reg_base + GPIO_INT);
+}
+
+static void exynos5440_gpio_irq_mask(struct irq_data *irqd)
+{
+	struct exynos5440_pinctrl_priv_data *d;
+	unsigned long gpio_int;
+
+	d = irq_data_get_irq_chip_data(irqd);
+	gpio_int = readl(d->reg_base + GPIO_INT);
+	gpio_int &= ~(1 << irqd->hwirq);
+	writel(gpio_int, d->reg_base + GPIO_INT);
+}
+
+/* irq_chip for gpio interrupts */
+static struct irq_chip exynos5440_gpio_irq_chip = {
+	.name		= "exynos5440_gpio_irq_chip",
+	.irq_unmask	= exynos5440_gpio_irq_unmask,
+	.irq_mask	= exynos5440_gpio_irq_mask,
+};
+
+/* interrupt handler for GPIO interrupts 0..7 */
+static irqreturn_t exynos5440_gpio_irq(int irq, void *data)
+{
+	struct exynos5440_gpio_intr_data *intd = data;
+	struct exynos5440_pinctrl_priv_data *d = intd->priv;
+	int virq;
+
+	virq = irq_linear_revmap(d->irq_domain, intd->gpio_int);
+	if (!virq)
+		return IRQ_NONE;
+	generic_handle_irq(virq);
+	return IRQ_HANDLED;
+}
+
+static int exynos5440_gpio_irq_map(struct irq_domain *h, unsigned int virq,
+					irq_hw_number_t hw)
+{
+	struct exynos5440_pinctrl_priv_data *d = h->host_data;
+
+	irq_set_chip_data(virq, d);
+	irq_set_chip_and_handler(virq, &exynos5440_gpio_irq_chip,
+					handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
+	return 0;
+}
+
+/* irq domain callbacks for gpio interrupt controller */
+static const struct irq_domain_ops exynos5440_gpio_irqd_ops = {
+	.map	= exynos5440_gpio_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+/* setup handling of gpio interrupts */
+static int exynos5440_gpio_irq_init(struct platform_device *pdev,
+				struct exynos5440_pinctrl_priv_data *priv)
+{
+	struct device *dev = &pdev->dev;
+	struct exynos5440_gpio_intr_data *intd;
+	int i, irq, ret;
+
+	intd = devm_kzalloc(dev, sizeof(*intd) * EXYNOS5440_MAX_GPIO_INT,
+					GFP_KERNEL);
+	if (!intd) {
+		dev_err(dev, "failed to allocate memory for gpio intr data\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < EXYNOS5440_MAX_GPIO_INT; i++) {
+		irq = irq_of_parse_and_map(dev->of_node, i);
+		if (irq <= 0) {
+			dev_err(dev, "irq parsing failed\n");
+			return -EINVAL;
+		}
+
+		intd->gpio_int = i;
+		intd->priv = priv;
+		ret = devm_request_irq(dev, irq, exynos5440_gpio_irq,
+					0, dev_name(dev), intd++);
+		if (ret) {
+			dev_err(dev, "irq request failed\n");
+			return -ENXIO;
+		}
+	}
+
+	priv->irq_domain = irq_domain_add_linear(dev->of_node,
+				EXYNOS5440_MAX_GPIO_INT,
+				&exynos5440_gpio_irqd_ops, priv);
+	if (!priv->irq_domain) {
+		dev_err(dev, "failed to create irq domain\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 static int exynos5440_pinctrl_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -883,6 +1019,12 @@ static int exynos5440_pinctrl_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = exynos5440_gpio_irq_init(pdev, priv);
+	if (ret) {
+		dev_err(dev, "failed to setup gpio interrupts\n");
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, priv);
 	dev_info(dev, "EXYNOS5440 pinctrl driver registered\n");
 	return 0;
-- 
1.7.4.4

