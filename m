Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaIIKRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:17:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:51732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbaIIKQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:16:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="570461329"
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
Subject: [PATCH 3/4 v3] GPIO: gpio-dwapb: Support Debounce
Date: Tue,  9 Sep 2014 11:08:00 -0700
Message-Id: <1410286081-16653-4-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables 'debounce' for the designware GPIO, and
it is based on Josef Ahmad's previous work.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/gpio-dwapb.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index c78a878..a90afb9 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -37,6 +37,7 @@
 #define GPIO_INTTYPE_LEVEL	0x38
 #define GPIO_INT_POLARITY	0x3c
 #define GPIO_INTSTATUS		0x40
+#define GPIO_PORTA_DEBOUNCE	0x48
 #define GPIO_PORTA_EOI		0x4c
 #define GPIO_EXT_PORTA		0x50
 #define GPIO_EXT_PORTB		0x54
@@ -235,6 +236,29 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
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
 	u32 worked;
@@ -373,6 +397,10 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
 	port->bgc.gc.ngpio = pp->ngpio;
 	port->bgc.gc.base = pp->gpio_base;
 
+	/* Only port A support debounce */
+	if (pp->idx == 0)
+		port->bgc.gc.set_debounce = dwapb_gpio_set_debounce;
+
 	if (pp->irq)
 		dwapb_configure_irqs(gpio, port, pp);
 
-- 
1.7.9.5

