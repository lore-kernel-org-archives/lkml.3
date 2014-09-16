Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbaIPB3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:29:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:50501 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbaIPB3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:29:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,532,1406617200"; 
   d="scan'208";a="477747371"
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
Subject: [PATCH 4/4 v4] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Date: Tue, 16 Sep 2014 02:22:15 -0700
Message-Id: <1410859335-11080-5-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables suspend and resume mode for the power management, and
it is based on Josef Ahmad's previous work.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/gpio-dwapb.c |  109 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 9a76e3c..14d83af 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -50,11 +50,14 @@
 #define GPIO_SWPORT_DDR_SIZE	(GPIO_SWPORTB_DDR - GPIO_SWPORTA_DDR)
 
 struct dwapb_gpio;
+struct dwapb_context;
 
 struct dwapb_gpio_port {
 	struct bgpio_chip	bgc;
 	bool			is_registered;
 	struct dwapb_gpio	*gpio;
+	struct dwapb_context	*ctx;
+	unsigned int		idx;
 };
 
 struct dwapb_gpio {
@@ -377,6 +380,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
 
 	port = &gpio->ports[offs];
 	port->gpio = gpio;
+	port->idx = pp->idx;
 
 	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
 	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
@@ -584,10 +588,115 @@ static const struct of_device_id dwapb_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, dwapb_of_match);
 
+#ifdef CONFIG_PM_SLEEP
+/* Store GPIO context across system-wide suspend/resume transitions */
+struct dwapb_context {
+	u32 data;
+	u32 dir;
+	u32 ext;
+	u32 int_en;
+	u32 int_mask;
+	u32 int_type;
+	u32 int_pol;
+	u32 int_deb;
+};
+
+static int dwapb_gpio_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
+	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	for (i = 0; i < gpio->nr_ports; i++) {
+		unsigned int offset;
+		unsigned int idx = gpio->ports[i].idx;
+		struct dwapb_context *ctx = gpio->ports[i].ctx;
+
+		if (!ctx) {
+			ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+			gpio->ports[i].ctx = ctx;
+		}
+
+		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
+		ctx->dir = dwapb_read(gpio, offset);
+
+		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
+		ctx->data = dwapb_read(gpio, offset);
+
+		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
+		ctx->ext = dwapb_read(gpio, offset);
+
+		/* Only port A can provide interrupts */
+		if (idx == 0) {
+			ctx->int_mask	= dwapb_read(gpio, GPIO_INTMASK);
+			ctx->int_en	= dwapb_read(gpio, GPIO_INTEN);
+			ctx->int_pol	= dwapb_read(gpio, GPIO_INT_POLARITY);
+			ctx->int_type	= dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
+			ctx->int_deb	= dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
+
+			/* Mask out interrupts */
+			dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
+		}
+	}
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+
+static int dwapb_gpio_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
+	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	for (i = 0; i < gpio->nr_ports; i++) {
+		unsigned int offset;
+		unsigned int idx = gpio->ports[i].idx;
+		struct dwapb_context *ctx = gpio->ports[i].ctx;
+
+		BUG_ON(ctx == 0);
+
+		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
+		dwapb_write(gpio, offset, ctx->data);
+
+		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
+		dwapb_write(gpio, offset, ctx->dir);
+
+		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
+		dwapb_write(gpio, offset, ctx->ext);
+
+		/* Only port A can provide interrupts */
+		if (idx == 0) {
+			dwapb_write(gpio, GPIO_INTTYPE_LEVEL, ctx->int_type);
+			dwapb_write(gpio, GPIO_INT_POLARITY, ctx->int_pol);
+			dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, ctx->int_deb);
+			dwapb_write(gpio, GPIO_INTEN, ctx->int_en);
+			dwapb_write(gpio, GPIO_INTMASK, ctx->int_mask);
+
+			/* Clear out spurious interrupts */
+			dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
+		}
+	}
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(dwapb_gpio_pm_ops, dwapb_gpio_suspend,
+			 dwapb_gpio_resume);
+
 static struct platform_driver dwapb_gpio_driver = {
 	.driver		= {
 		.name	= "gpio-dwapb",
 		.owner	= THIS_MODULE,
+		.pm	= &dwapb_gpio_pm_ops,
 		.of_match_table = of_match_ptr(dwapb_of_match),
 	},
 	.probe		= dwapb_gpio_probe,
-- 
1.7.9.5

