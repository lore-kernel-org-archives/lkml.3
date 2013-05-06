Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3EFPNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:13:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59981 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab3EFPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:13:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Emulate level triggered interrupts if required
Date: Mon,  6 May 2013 16:12:56 +0100
Message-Id: <1367853176-31886-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt controller on the wm8994 series of devices requires a level
triggered parent. If one is not available but a GPIO is available for the
interrupt then emulate.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-irq.c         |  100 ++++++++++++++++++++++++++++++++++++--
 include/linux/mfd/wm8994/core.h  |    2 +
 include/linux/mfd/wm8994/pdata.h |    5 ++
 3 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index a050e56..d3a184a 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -14,10 +14,12 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/mfd/core.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/regmap.h>
 
 #include <linux/mfd/wm8994/core.h>
@@ -138,6 +140,55 @@ static struct regmap_irq_chip wm8994_irq_chip = {
 	.runtime_pm = true,
 };
 
+static void wm8994_edge_irq_enable(struct irq_data *data)
+{
+}
+
+static void wm8994_edge_irq_disable(struct irq_data *data)
+{
+}
+
+static struct irq_chip wm8994_edge_irq_chip = {
+	.name			= "wm8994_edge",
+	.irq_disable		= wm8994_edge_irq_disable,
+	.irq_enable		= wm8994_edge_irq_enable,
+};
+
+static irqreturn_t wm8994_edge_irq(int irq, void *data)
+{
+	struct wm8994 *wm8994 = data;
+
+	while (gpio_get_value_cansleep(wm8994->pdata.irq_gpio))
+		handle_nested_irq(irq_create_mapping(wm8994->edge_irq, 0));
+
+	return IRQ_HANDLED;
+}
+
+static int wm8994_edge_irq_map(struct irq_domain *h, unsigned int virq,
+			       irq_hw_number_t hw)
+{
+	struct wm8994 *wm8994 = h->host_data;
+
+	irq_set_chip_data(virq, wm8994);
+	irq_set_chip_and_handler(virq, &wm8994_edge_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops wm8994_edge_irq_ops = {
+	.map	= wm8994_edge_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
 int wm8994_irq_init(struct wm8994 *wm8994)
 {
 	int ret;
@@ -156,10 +207,51 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 	if (pdata->irq_flags)
 		irqflags = pdata->irq_flags;
 
-	ret = regmap_add_irq_chip(wm8994->regmap, wm8994->irq,
-				  irqflags,
-				  wm8994->irq_base, &wm8994_irq_chip,
-				  &wm8994->irq_data);
+	/* use a GPIO for edge triggered controllers */
+	if (irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
+		if (gpio_to_irq(pdata->irq_gpio) != wm8994->irq) {
+			dev_warn(wm8994->dev, "IRQ %d is not GPIO %d (%d)\n",
+				 wm8994->irq, pdata->irq_gpio,
+				 gpio_to_irq(pdata->irq_gpio));
+			wm8994->irq = gpio_to_irq(pdata->irq_gpio);
+		}
+
+		ret = devm_gpio_request_one(wm8994->dev, pdata->irq_gpio,
+					    GPIOF_IN, "WM8994 IRQ");
+
+		if (ret != 0) {
+			dev_err(wm8994->dev, "Failed to get IRQ GPIO: %d\n",
+				ret);
+			return ret;
+		}
+
+		wm8994->edge_irq = irq_domain_add_linear(NULL, 1,
+							 &wm8994_edge_irq_ops,
+							 wm8994);
+
+		ret = regmap_add_irq_chip(wm8994->regmap,
+					  irq_create_mapping(wm8994->edge_irq,
+							     0),
+					  IRQF_ONESHOT,
+					  wm8994->irq_base, &wm8994_irq_chip,
+					  &wm8994->irq_data);
+		if (ret != 0) {
+			dev_err(wm8994->dev, "Failed to get IRQ: %d\n",
+				ret);
+			return ret;
+		}
+
+		ret = request_threaded_irq(wm8994->irq,
+					   NULL, wm8994_edge_irq,
+					   irqflags,
+					   "WM8994 edge", wm8994);
+	} else {
+		ret = regmap_add_irq_chip(wm8994->regmap, wm8994->irq,
+					  irqflags,
+					  wm8994->irq_base, &wm8994_irq_chip,
+					  &wm8994->irq_data);
+	}
+
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to register IRQ chip: %d\n", ret);
 		return ret;
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index ae5c249..40854ac 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -29,6 +29,7 @@ enum wm8994_type {
 
 struct regulator_dev;
 struct regulator_bulk_data;
+struct irq_domain;
 
 #define WM8994_NUM_GPIO_REGS 11
 #define WM8994_NUM_LDO_REGS   2
@@ -73,6 +74,7 @@ struct wm8994 {
 
 	int irq;
 	struct regmap_irq_chip_data *irq_data;
+	struct irq_domain *edge_irq;
 
 	/* Used over suspend/resume */
 	bool suspended;
diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index 68e7765..90e9bf8 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -223,6 +223,11 @@ struct wm8994_pdata {
 	 * lines is mastered.
 	 */
 	int max_channels_clocked[WM8994_NUM_AIF];
+
+	/**
+	 * GPIO for the IRQ pin if host only supports edge triggering
+	 */
+	int irq_gpio;
 };
 
 #endif
-- 
1.7.10.4

