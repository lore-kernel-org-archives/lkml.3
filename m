Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3H0KbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:31:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38456 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3H0KbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:31:03 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] gpio: pcf857x: cleanup irq_demux_work and use threaded irq
Date: Tue, 27 Aug 2013 16:00:55 +0530
Message-ID: <1377599455-9379-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch
	- removes the irq_demux_work
	- Uses devm_request_threaded_irq
	- Call the user handler iff gpio_to_irq is done.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/gpio/gpio-pcf857x.c | 52 +++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 947cff4..aebbba6 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -30,7 +30,7 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
+#include <linux/of_irq.h>
 
 
 static const struct i2c_device_id pcf857x_id[] = {
@@ -89,12 +89,12 @@ struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
 	struct mutex		lock;		/* protect 'out' */
-	struct work_struct	work;		/* irq demux work */
 	struct irq_domain	*irq_domain;	/* for irq demux  */
 	spinlock_t		slock;		/* protect irq demux */
 	unsigned		out;		/* software latch */
 	unsigned		status;		/* current status */
 	int			irq;		/* real irq number */
+	int			irq_mapped;	/* mapped gpio irqs  */
 
 	int (*write)(struct i2c_client *client, unsigned data);
 	int (*read)(struct i2c_client *client);
@@ -187,38 +187,35 @@ static void pcf857x_set(struct gpio_chip *chip, unsigned offset, int value)
 static int pcf857x_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct pcf857x *gpio = container_of(chip, struct pcf857x, chip);
+	int ret;
 
-	return irq_create_mapping(gpio->irq_domain, offset);
+	ret = irq_create_mapping(gpio->irq_domain, offset);
+	if (ret > 0)
+		gpio->irq_mapped |= (1 << offset);
+
+	return ret;
 }
 
-static void pcf857x_irq_demux_work(struct work_struct *work)
+static irqreturn_t pcf857x_irq(int irq, void *data)
 {
-	struct pcf857x *gpio = container_of(work,
-					       struct pcf857x,
-					       work);
+	struct pcf857x	*gpio = data;
 	unsigned long change, i, status, flags;
 
 	status = gpio->read(gpio->client);
 
 	spin_lock_irqsave(&gpio->slock, flags);
+
+	/*
+	 * call the interrupt handler iff gpio is used as
+	 * interrupt source, just to avoid bad irqs
+	 */
 
-	change = gpio->status ^ status;
+	change = ((gpio->status ^ status) & gpio->irq_mapped);
 	for_each_set_bit(i, &change, gpio->chip.ngpio)
 		generic_handle_irq(irq_find_mapping(gpio->irq_domain, i));
 	gpio->status = status;
 
 	spin_unlock_irqrestore(&gpio->slock, flags);
-}
-
-static irqreturn_t pcf857x_irq_demux(int irq, void *data)
-{
-	struct pcf857x	*gpio = data;
-
-	/*
-	 * pcf857x can't read/write data here,
-	 * since i2c data access might go to sleep.
-	 */
-	schedule_work(&gpio->work);
 
 	return IRQ_HANDLED;
 }
@@ -226,9 +223,13 @@ static irqreturn_t pcf857x_irq_demux(int irq, void *data)
 static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned int virq,
 				 irq_hw_number_t hw)
 {
+	struct pcf857x  *gpio = domain->host_data;
 	irq_set_chip_and_handler(virq,
 				 &dummy_irq_chip,
 				 handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
+	gpio->irq_mapped |= (1 << hw);
+
 	return 0;
 }
 
@@ -241,30 +242,31 @@ static void pcf857x_irq_domain_cleanup(struct pcf857x *gpio)
 	if (gpio->irq_domain)
 		irq_domain_remove(gpio->irq_domain);
 
-	if (gpio->irq)
-		free_irq(gpio->irq, gpio);
 }
 
 static int pcf857x_irq_domain_init(struct pcf857x *gpio,
 				   struct i2c_client *client)
 {
 	int status;
+	struct device_node *node;
 
+	node = client->dev.of_node;
 	gpio->irq_domain = irq_domain_add_linear(client->dev.of_node,
 						 gpio->chip.ngpio,
 						 &pcf857x_irq_domain_ops,
-						 NULL);
+						 gpio);
 	if (!gpio->irq_domain)
 		goto fail;
 
 	/* enable real irq */
-	status = request_irq(client->irq, pcf857x_irq_demux, 0,
-			     dev_name(&client->dev), gpio);
+	status = devm_request_threaded_irq(&client->dev, client->irq,
+				NULL, pcf857x_irq, IRQF_ONESHOT |
+				IRQF_TRIGGER_FALLING,
+				dev_name(&client->dev), gpio);
 	if (status)
 		goto fail;
 
 	/* enable gpio_to_irq() */
-	INIT_WORK(&gpio->work, pcf857x_irq_demux_work);
 	gpio->chip.to_irq	= pcf857x_to_irq;
 	gpio->irq		= client->irq;
 
-- 
1.8.1.4

