Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3H3Kxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:53:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39063 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3H3Kxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:53:33 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 3/3] gpio: pcf857x: call the gpio user  handler  iff gpio_to_irq is done
Date: Fri, 30 Aug 2013 16:18:33 +0530
Message-ID: <1377859713-13460-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377859713-13460-1-git-send-email-george.cherian@ti.com>
References: <1377859713-13460-1-git-send-email-george.cherian@ti.com>
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
 arch/arm/boot/dts/dra7-evm.dts |  4 ++--
 drivers/gpio/gpio-pcf857x.c    | 22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 39b44bc..00fb0df 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -50,7 +50,7 @@
 	gpio20: pcf8575@20 {
 		compatible = "ti,pcf8575";
 		reg = <0x20>;
-		n_latch = <0x4000>;
+		n_latch = <0x0000>;
 		gpio-controller;
 		#gpio-cells = <2>;
 		interrupt-parent = <&gpio6>;
@@ -62,7 +62,7 @@
 	gpio21: pcf8575@21 {
 		compatible = "ti,pcf8575";
 		reg = <0x21>;
-		n_latch = <0x1408>;
+		/*n_latch = <0x1408>;*/
 		gpio-controller;
 		#gpio-cells = <2>;
 		interrupt-parent = <&gpio20>;
diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 4890e97..578d93f 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -93,6 +93,7 @@ struct pcf857x {
 	unsigned		out;		/* software latch */
 	unsigned		status;		/* current status */
 	int			irq;		/* real irq number */
+	unsigned		irq_mapped;	/* mapped gpio irqs */
 
 	int (*write)(struct i2c_client *client, unsigned data);
 	int (*read)(struct i2c_client *client);
@@ -185,8 +186,13 @@ static void pcf857x_set(struct gpio_chip *chip, unsigned offset, int value)
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
@@ -198,7 +204,12 @@ static irqreturn_t pcf857x_irq(int irq, void *data)
 
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
@@ -211,9 +222,14 @@ static irqreturn_t pcf857x_irq(int irq, void *data)
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
 
@@ -236,7 +252,7 @@ static int pcf857x_irq_domain_init(struct pcf857x *gpio,
 	gpio->irq_domain = irq_domain_add_linear(client->dev.of_node,
 						 gpio->chip.ngpio,
 						 &pcf857x_irq_domain_ops,
-						 NULL);
+						 gpio);
 	if (!gpio->irq_domain)
 		goto fail;
 
-- 
1.8.1.4

