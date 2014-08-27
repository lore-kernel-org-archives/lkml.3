Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbaH0Jy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:54:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:3195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbaH0Jya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="473110642"
From: Weike Chen <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Alvin Chen <alvin.chen@intel.com>
Subject: [PATCH 2/3] GPIO: gpio-dwapb: Support Debounce
Date: Wed, 27 Aug 2014 10:46:27 -0700
Message-Id: <1409161588-19417-3-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables 'debounce' for the designware GPIO, and
it is based on Josef Ahmad's previous work.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/gpio-dwapb.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 155a64b..e0ab988 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -36,6 +36,7 @@
 #define GPIO_INTTYPE_LEVEL	0x38
 #define GPIO_INT_POLARITY	0x3c
 #define GPIO_INTSTATUS		0x40
+#define GPIO_PORTA_DEBOUNCE	0x48
 #define GPIO_PORTA_EOI		0x4c
 #define GPIO_EXT_PORTA		0x50
 #define GPIO_EXT_PORTB		0x54
@@ -64,6 +65,23 @@ struct dwapb_gpio {
 	const struct dwapb_gpio_platform_data	*pdata;
 };
 
+static inline u32 dwapb_read(struct dwapb_gpio *gpio, unsigned int offset)
+{
+	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
+	void __iomem *reg_base	= gpio->regs;
+
+	return bgc->read_reg(reg_base + offset);
+}
+
+static inline void dwapb_write(struct dwapb_gpio *gpio, unsigned int offset,
+			       u32 val)
+{
+	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
+	void __iomem *reg_base	= gpio->regs;
+
+	bgc->write_reg(reg_base + offset, val);
+}
+
 static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
@@ -209,6 +227,29 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 	return 0;
 }
 
+static int dwapb_gpio_set_debounce(struct gpio_chip *gc,
+				   unsigned offset, unsigned debounce)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	struct dwapb_gpio_port *port =
+			container_of(bgc, struct dwapb_gpio_port, bgc);
+	struct dwapb_gpio *gpio = port->gpio;
+	unsigned long flags, val_deb;
+	unsigned long mask = bgc->pin2mask(bgc, offset);
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	val_deb = dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
+	if (debounce)
+		dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, mask | val_deb);
+	else
+		dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, ~mask & val_deb);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+
 static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -342,6 +383,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
 
 	port->bgc.gc.ngpio = pp->ngpio;
 	port->bgc.gc.base = pp->gpio_base;
+	port->bgc.gc.set_debounce = dwapb_gpio_set_debounce;
 
 	/*
 	 * Only port A can provide interrupts in all configurations of the IP.
-- 
1.7.9.5

