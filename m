Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaIPBaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:30:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:50501 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbaIPB33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:29:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,532,1406617200"; 
   d="scan'208";a="477747353"
From: Weike Chen <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Alvin Chen <alvin.chen@intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/4 v4] GPIO: gpio-dwapb: Change readl&writel to dwapb_read&dwapb_write
Date: Tue, 16 Sep 2014 02:22:13 -0700
Message-Id: <1410859335-11080-3-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces 'readl&writel' with 'dwapb_read&dwapb_write'.

Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/gpio-dwapb.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index a62467a..534945c 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -64,6 +64,23 @@ struct dwapb_gpio {
 	struct irq_domain	*domain;
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
@@ -76,14 +93,14 @@ static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 
 static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
 {
-	u32 v = readl(gpio->regs + GPIO_INT_POLARITY);
+	u32 v = dwapb_read(gpio, GPIO_INT_POLARITY);
 
 	if (gpio_get_value(gpio->ports[0].bgc.gc.base + offs))
 		v &= ~BIT(offs);
 	else
 		v |= BIT(offs);
 
-	writel(v, gpio->regs + GPIO_INT_POLARITY);
+	dwapb_write(gpio, GPIO_INT_POLARITY, v);
 }
 
 static u32 dwapb_do_irq(struct dwapb_gpio *gpio)
@@ -126,9 +143,9 @@ static void dwapb_irq_enable(struct irq_data *d)
 	u32 val;
 
 	spin_lock_irqsave(&bgc->lock, flags);
-	val = readl(gpio->regs + GPIO_INTEN);
+	val = dwapb_read(gpio, GPIO_INTEN);
 	val |= BIT(d->hwirq);
-	writel(val, gpio->regs + GPIO_INTEN);
+	dwapb_write(gpio, GPIO_INTEN, val);
 	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
@@ -141,9 +158,9 @@ static void dwapb_irq_disable(struct irq_data *d)
 	u32 val;
 
 	spin_lock_irqsave(&bgc->lock, flags);
-	val = readl(gpio->regs + GPIO_INTEN);
+	val = dwapb_read(gpio, GPIO_INTEN);
 	val &= ~BIT(d->hwirq);
-	writel(val, gpio->regs + GPIO_INTEN);
+	dwapb_write(gpio, GPIO_INTEN, val);
 	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
@@ -183,8 +200,8 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 		return -EINVAL;
 
 	spin_lock_irqsave(&bgc->lock, flags);
-	level = readl(gpio->regs + GPIO_INTTYPE_LEVEL);
-	polarity = readl(gpio->regs + GPIO_INT_POLARITY);
+	level = dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
+	polarity = dwapb_read(gpio, GPIO_INT_POLARITY);
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:
@@ -211,8 +228,8 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 
 	irq_setup_alt_chip(d, type);
 
-	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
-	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
+	dwapb_write(gpio, GPIO_INTTYPE_LEVEL, level);
+	dwapb_write(gpio, GPIO_INT_POLARITY, polarity);
 	spin_unlock_irqrestore(&bgc->lock, flags);
 
 	return 0;
-- 
1.7.9.5

