Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaLJNg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:36:26 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:59514 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaLJNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:36:22 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@redhat.com>, linux-gpio@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] gpio: pcf857x: Propagate wake-up setting to parent irq controller
Date: Wed, 10 Dec 2014 14:36:14 +0100
Message-Id: <1418218575-17694-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcf857x GPIO and interrupt controller uses dummy_irq_chip, which
does not implement irq_chip.irq_set_wake() and does not set
IRQCHIP_SKIP_SET_WAKE.

This causes two s2ram issues if wake-up is enabled for the pcf857x GPIO
pins:
  1. During resume from s2ram, the following warning is printed:

     WARNING: CPU: 0 PID: 1046 at kernel/irq/manage.c:537 irq_set_irq_wake+0x9c/0xf8()
     Unbalanced IRQ 113 wake disable

  2. Wake-up through the pcf857x GPIO pins may fail, as the parent
     interrupt controller may be suspended.

Migrate the pcf857x GPIO and interrupt controller from dummy_irq_chip to
its own irq_chip. This irq chip implements irq_chip.irq_set_wake() to
propagate its wake-up setting to the parent interrupt controller.

This fixes wake-up through gpio-keys on sh73a0/kzm9g, where the pcf857x
interrupt is cascaded to irq-renesas-intc-irqpin, and the latter must
not be suspended when wake-up is enabled.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/gpio/gpio-pcf857x.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 236708ad0a5ba0ab..22dbecb004cf6c5b 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -218,14 +218,45 @@ static irqreturn_t pcf857x_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/*
+ * NOP functions
+ */
+static void noop(struct irq_data *data) { }
+
+static unsigned int noop_ret(struct irq_data *data)
+{
+	return 0;
+}
+
+static int pcf857x_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	struct pcf857x *gpio = irq_data_get_irq_chip_data(data);
+
+	irq_set_irq_wake(gpio->client->irq, on);
+	return 0;
+}
+
+static struct irq_chip pcf857x_irq_chip = {
+	.name		= "pcf857x",
+	.irq_startup	= noop_ret,
+	.irq_shutdown	= noop,
+	.irq_enable	= noop,
+	.irq_disable	= noop,
+	.irq_ack	= noop,
+	.irq_mask	= noop,
+	.irq_unmask	= noop,
+	.irq_set_wake	= pcf857x_irq_set_wake,
+};
+
 static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned int irq,
 				 irq_hw_number_t hw)
 {
 	struct pcf857x *gpio = domain->host_data;
 
 	irq_set_chip_and_handler(irq,
-				 &dummy_irq_chip,
+				 &pcf857x_irq_chip,
 				 handle_level_irq);
+	irq_set_chip_data(irq, gpio);
 #ifdef CONFIG_ARM
 	set_irq_flags(irq, IRQF_VALID);
 #else
-- 
1.9.1

