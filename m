Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202Ab3IDHDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:03:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43085 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762172Ab3IDHDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:03:25 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 3/3] gpio: pcf857x: call the gpio user handler iff gpio_to_irq is done
Date: Wed, 4 Sep 2013 12:33:03 +0530
Message-ID: <1378278183-26596-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378278183-26596-1-git-send-email-george.cherian@ti.com>
References: <1378278183-26596-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pcf857x driver if the initial state is not set properly (proper
n_latch is not passed), we get bad irq prints on console.
We get this only for the first interrupt and doesnot repeat for further
interrupts unles and until there are other gpio pins which are not flipping
continously.

following prints are seen on console.

[   40.983924] irq 0, desc: ce004080, depth: 1, count: 0, unhandled: 0
[   40.990511] ->handle_irq():  c00aa538, handle_bad_irq+0x0/0x260
[   40.996768] ->irq_data.chip(): c080b6ec, no_irq_chip+0x0/0x60
[   41.002842] ->action():   (null)
[   41.006242]    IRQ_NOPROBE set
[   41.009465]  IRQ_NOREQUEST set

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/gpio/gpio-pcf857x.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index ef52ee3..4887b8c 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -92,6 +92,7 @@ struct pcf857x {
 	spinlock_t		slock;		/* protect irq demux */
 	unsigned		out;		/* software latch */
 	unsigned		status;		/* current status */
+	unsigned		irq_mapped;	/* mapped gpio irqs */
 
 	int (*write)(struct i2c_client *client, unsigned data);
 	int (*read)(struct i2c_client *client);
@@ -184,8 +185,13 @@ static void pcf857x_set(struct gpio_chip *chip, unsigned offset, int value)
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
 
 static irqreturn_t pcf857x_irq(int irq, void *data)
@@ -197,7 +203,12 @@ static irqreturn_t pcf857x_irq(int irq, void *data)
 
 	spin_lock_irqsave(&gpio->slock, flags);
 
-	change = gpio->status ^ status;
+	/*
+	 * call the interrupt handler iff gpio is used as
+	 * interrupt source, just to avoid bad irqs
+	 */
+
+	change = ((gpio->status ^ status) & gpio->irq_mapped);
 	for_each_set_bit(i, &change, gpio->chip.ngpio)
 		generic_handle_irq(irq_find_mapping(gpio->irq_domain, i));
 	gpio->status = status;
@@ -210,9 +221,14 @@ static irqreturn_t pcf857x_irq(int irq, void *data)
 static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned int virq,
 				 irq_hw_number_t hw)
 {
+	struct pcf857x *gpio = domain->host_data;
+
 	irq_set_chip_and_handler(virq,
 				 &dummy_irq_chip,
 				 handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
+	gpio->irq_mapped |= (1 << hw);
+
 	return 0;
 }
 
@@ -235,7 +251,7 @@ static int pcf857x_irq_domain_init(struct pcf857x *gpio,
 	gpio->irq_domain = irq_domain_add_linear(client->dev.of_node,
 						 gpio->chip.ngpio,
 						 &pcf857x_irq_domain_ops,
-						 NULL);
+						 gpio);
 	if (!gpio->irq_domain)
 		goto fail;
 
-- 
1.8.1.4

