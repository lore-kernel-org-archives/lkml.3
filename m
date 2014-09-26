Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaIZKIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:08:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:7420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbaIZKH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391941563"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 3/3] gpio: sch: Enable IRQ support for Quark X1000
Date: Fri, 26 Sep 2014 18:07:27 +0800
Message-Id: <1411726047-3224-4-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Quark X1000 GPIO controller supports interrupt handling for
both core power well and resume power well. This patch is to enable
the IRQ support and provide IRQ handling for Intel Quark X1000
GPIO-SCH device driver.

This piece of work is derived from Dan O'Donovan's initial work for
Quark X1000 enabling.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
---
 drivers/gpio/gpio-sch.c |  267 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 253 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 952990f..332ffaf 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -28,17 +28,30 @@
 #include <linux/pci_ids.h>
 
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #define GEN	0x00
 #define GIO	0x04
 #define GLV	0x08
+#define GTPE	0x0C
+#define GTNE	0x10
+#define GGPE	0x14
+#define GSMI	0x18
+#define GTS	0x1C
+#define CGNMIEN	0x40
+#define RGNMIEN	0x44
 
 struct sch_gpio {
 	struct gpio_chip chip;
+	struct irq_data data;
 	spinlock_t lock;
 	unsigned short iobase;
 	unsigned short core_base;
 	unsigned short resume_base;
+	int irq_base;
+	int irq_num;
+	int irq_support;
 };
 
 #define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
@@ -66,10 +79,11 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
 static void sch_gpio_register_set(struct sch_gpio *sch, unsigned gpio,
 				  unsigned reg)
 {
+	unsigned long flags;
 	unsigned short offset, bit;
 	u8 enable;
 
-	spin_lock(&sch->lock);
+	spin_lock_irqsave(&sch->lock, flags);
 
 	offset = sch_gpio_offset(sch, gpio, reg);
 	bit = sch_gpio_bit(sch, gpio);
@@ -78,16 +92,17 @@ static void sch_gpio_register_set(struct sch_gpio *sch, unsigned gpio,
 	if (!(enable & BIT(bit)))
 		outb(enable | BIT(bit), sch->iobase + offset);
 
-	spin_unlock(&sch->lock);
+	spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_gpio_register_clear(struct sch_gpio *sch, unsigned gpio,
 				    unsigned reg)
 {
+	unsigned long flags;
 	unsigned short offset, bit;
 	u8 disable;
 
-	spin_lock(&sch->lock);
+	spin_lock_irqsave(&sch->lock, flags);
 
 	offset = sch_gpio_offset(sch, gpio, reg);
 	bit = sch_gpio_bit(sch, gpio);
@@ -96,7 +111,7 @@ static void sch_gpio_register_clear(struct sch_gpio *sch, unsigned gpio,
 	if (disable & BIT(bit))
 		outb(disable & ~BIT(bit), sch->iobase + offset);
 
-	spin_unlock(&sch->lock);
+	spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
@@ -134,10 +149,11 @@ static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
 static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
+	unsigned long flags;
 
-	spin_lock(&sch->lock);
+	spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_register_set(sch, gpio_num, GIO);
-	spin_unlock(&sch->lock);
+	spin_unlock_irqrestore(&sch->lock, flags);
 	return 0;
 }
 
@@ -149,20 +165,22 @@ static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
 static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
+	unsigned long flags;
 
-	spin_lock(&sch->lock);
+	spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(gc, gpio_num, GLV, val);
-	spin_unlock(&sch->lock);
+	spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
 				  int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
+	unsigned long flags;
 
-	spin_lock(&sch->lock);
+	spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_register_clear(sch, gpio_num, GIO);
-	spin_unlock(&sch->lock);
+	spin_unlock_irqrestore(&sch->lock, flags);
 
 	/*
 	 * according to the datasheet, writing to the level register has no
@@ -177,6 +195,13 @@ static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
 	return 0;
 }
 
+static int sch_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct sch_gpio *sch = to_sch_gpio(gc);
+
+	return sch->irq_base + offset;
+}
+
 static struct gpio_chip sch_gpio_chip = {
 	.label			= "sch_gpio",
 	.owner			= THIS_MODULE,
@@ -184,12 +209,160 @@ static struct gpio_chip sch_gpio_chip = {
 	.get			= sch_gpio_get,
 	.direction_output	= sch_gpio_direction_out,
 	.set			= sch_gpio_set,
+	.to_irq			= sch_gpio_to_irq,
+};
+
+static void sch_gpio_irq_enable(struct irq_data *d)
+{
+	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
+	u32 gpio_num;
+
+	gpio_num = d->irq - sch->irq_base;
+	sch_gpio_register_set(sch, gpio_num, GGPE);
+}
+
+static void sch_gpio_irq_disable(struct irq_data *d)
+{
+	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
+	u32 gpio_num;
+
+	gpio_num = d->irq - sch->irq_base;
+	sch_gpio_register_clear(sch, gpio_num, GGPE);
+}
+
+static void sch_gpio_irq_ack(struct irq_data *d)
+{
+	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
+	u32 gpio_num;
+
+	gpio_num = d->irq - sch->irq_base;
+	sch_gpio_reg_set(&(sch->chip), gpio_num, GTS, 1);
+}
+
+static int sch_gpio_irq_type(struct irq_data *d, unsigned type)
+{
+	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
+	unsigned long flags;
+	u32 gpio_num;
+
+	if (d == NULL)
+		return -EINVAL;
+
+	gpio_num = d->irq - sch->irq_base;
+
+	spin_lock_irqsave(&sch->lock, flags);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		sch_gpio_register_set(sch, gpio_num, GTPE);
+		sch_gpio_register_clear(sch, gpio_num, GTNE);
+		break;
+
+	case IRQ_TYPE_EDGE_FALLING:
+		sch_gpio_register_set(sch, gpio_num, GTNE);
+		sch_gpio_register_clear(sch, gpio_num, GTPE);
+		break;
+
+	case IRQ_TYPE_EDGE_BOTH:
+		sch_gpio_register_set(sch, gpio_num, GTPE);
+		sch_gpio_register_set(sch, gpio_num, GTNE);
+		break;
+
+	case IRQ_TYPE_NONE:
+		sch_gpio_register_clear(sch, gpio_num, GTPE);
+		sch_gpio_register_clear(sch, gpio_num, GTNE);
+		break;
+
+	default:
+		spin_unlock_irqrestore(&sch->lock, flags);
+		return -EINVAL;
+	}
+
+	spin_unlock_irqrestore(&sch->lock, flags);
+
+	return 0;
+}
+
+static struct irq_chip sch_irq_chip = {
+	.irq_enable	= sch_gpio_irq_enable,
+	.irq_disable	= sch_gpio_irq_disable,
+	.irq_ack	= sch_gpio_irq_ack,
+	.irq_set_type	= sch_gpio_irq_type,
 };
 
+static void sch_gpio_irqs_init(struct sch_gpio *sch, unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++) {
+		irq_set_chip_data(i + sch->irq_base, sch);
+		irq_set_chip_and_handler_name(i + sch->irq_base,
+					      &sch_irq_chip,
+					      handle_simple_irq,
+					      "sch_gpio_irq_chip");
+	}
+}
+
+static void sch_gpio_irqs_deinit(struct sch_gpio *sch, unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++) {
+		irq_set_chip_data(i + sch->irq_base, 0);
+		irq_set_chip_and_handler_name(i + sch->irq_base, 0, 0, 0);
+	}
+}
+
+static void sch_gpio_irq_disable_all(struct sch_gpio *sch, unsigned int num)
+{
+	unsigned long flags;
+	unsigned int gpio_num;
+
+	spin_lock_irqsave(&sch->lock, flags);
+
+	for (gpio_num = 0; gpio_num < num; gpio_num++) {
+		sch_gpio_register_clear(sch, gpio_num, GTPE);
+		sch_gpio_register_clear(sch, gpio_num, GTNE);
+		sch_gpio_register_clear(sch, gpio_num, GGPE);
+		sch_gpio_register_clear(sch, gpio_num, GSMI);
+
+		if (gpio_num >= 2)
+			sch_gpio_register_clear(sch, gpio_num, RGNMIEN);
+		else
+			sch_gpio_register_clear(sch, gpio_num, CGNMIEN);
+
+		/* clear any pending interrupts */
+		sch_gpio_reg_set(&sch->chip, gpio_num, GTS, 1);
+	}
+
+	spin_unlock_irqrestore(&sch->lock, flags);
+}
+
+static irqreturn_t sch_gpio_irq_handler(int irq, void *dev_id)
+{
+	struct sch_gpio *sch = dev_id;
+	int res;
+	unsigned int i;
+	int ret = IRQ_NONE;
+
+	for (i = 0; i < sch->chip.ngpio; i++) {
+		res = sch_gpio_reg_get(&sch->chip, i, GTS);
+		if (res) {
+			/* clear by setting GTS to 1 */
+			sch_gpio_reg_set(&sch->chip, i, GTS, 1);
+			generic_handle_irq(sch->irq_base + i);
+			ret = IRQ_HANDLED;
+		}
+	}
+
+	return ret;
+}
+
 static int sch_gpio_probe(struct platform_device *pdev)
 {
 	struct sch_gpio *sch;
-	struct resource *res;
+	struct resource *res, *irq;
+	int err;
 
 	sch = devm_kzalloc(&pdev->dev, sizeof(*sch), GFP_KERNEL);
 	if (!sch)
@@ -203,6 +376,17 @@ static int sch_gpio_probe(struct platform_device *pdev)
 				 pdev->name))
 		return -EBUSY;
 
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	sch->irq_support = !!irq;
+	if (sch->irq_support) {
+		sch->irq_num = irq->start;
+		if (sch->irq_num < 0) {
+			dev_warn(&pdev->dev,
+				 "failed to obtain irq number for device\n");
+			sch->irq_support = 0;
+		}
+	}
+
 	spin_lock_init(&sch->lock);
 	sch->iobase = res->start;
 	sch->chip = sch_gpio_chip;
@@ -251,17 +435,72 @@ static int sch_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	err = gpiochip_add(&sch->chip);
+	if (err < 0)
+		goto err_sch_gpio;
+
+	if (sch->irq_support) {
+		sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
+						NUMA_NO_NODE);
+		if (sch->irq_base < 0) {
+			dev_err(&pdev->dev,
+				"failed to add GPIO IRQ descs\n");
+			sch->irq_base = -1;
+			goto err_sch_intr_chip;
+		}
+
+		/* disable interrupts */
+		sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
+
+		err = request_irq(sch->irq_num, sch_gpio_irq_handler,
+				  IRQF_SHARED, KBUILD_MODNAME, sch);
+		if (err) {
+			dev_err(&pdev->dev,
+				"%s failed to request IRQ\n", __func__);
+			goto err_sch_request_irq;
+		}
+
+		sch_gpio_irqs_init(sch, sch->chip.ngpio);
+	}
+
 	platform_set_drvdata(pdev, sch);
 
-	return gpiochip_add(&sch->chip);
+	return 0;
+
+err_sch_request_irq:
+	irq_free_descs(sch->irq_base, sch->chip.ngpio);
+
+err_sch_intr_chip:
+	if (gpiochip_remove(&sch->chip))
+		dev_err(&pdev->dev,
+			"%s gpiochip_remove() failed\n", __func__);
+
+err_sch_gpio:
+	release_region(res->start, resource_size(res));
+
+	return err;
 }
 
 static int sch_gpio_remove(struct platform_device *pdev)
 {
 	struct sch_gpio *sch = platform_get_drvdata(pdev);
+	int err;
 
-	gpiochip_remove(&sch->chip);
-	return 0;
+	if (sch->irq_support) {
+		sch_gpio_irqs_deinit(sch, sch->chip.ngpio);
+
+		if (sch->irq_num >= 0)
+			free_irq(sch->irq_num, sch);
+
+		irq_free_descs(sch->irq_base, sch->chip.ngpio);
+	}
+
+	err = gpiochip_remove(&sch->chip);
+	if (err)
+		dev_err(&pdev->dev,
+			"%s gpiochip_remove() failed\n", __func__);
+
+	return err;
 }
 
 static struct platform_driver sch_gpio_driver = {
-- 
1.7.9.5

