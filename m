Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaIEHB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:01:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:15023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbaIEHBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="586646536"
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
        Alvin Chen <alvin.chen@intel.com>
Subject: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Date: Fri,  5 Sep 2014 07:53:18 -0700
Message-Id: <1409928798-31895-4-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables suspend and resume mode for the power management, and
it is based on Josef Ahmad's previous work.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/gpio-dwapb.c |  102 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 6db7501..a103def 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -54,6 +54,7 @@ struct dwapb_gpio_port {
 	struct bgpio_chip	bgc;
 	bool			is_registered;
 	struct dwapb_gpio	*gpio;
+	unsigned int		idx;
 };
 
 struct dwapb_gpio {
@@ -376,6 +377,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
 
 	port = &gpio->ports[offs];
 	port->gpio = gpio;
+	port->idx = pp->idx;
 
 	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
 	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
@@ -594,10 +596,110 @@ static const struct of_device_id dwapb_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, dwapb_of_match);
 
+#ifdef CONFIG_PM_SLEEP
+/* Store GPIO context across system-wide suspend/resume transitions */
+static struct dwapb_context {
+	u32 data[DWAPB_MAX_PORTS];
+	u32 dir[DWAPB_MAX_PORTS];
+	u32 ext[DWAPB_MAX_PORTS];
+	u32 int_en;
+	u32 int_mask;
+	u32 int_type;
+	u32 int_pol;
+	u32 int_deb;
+} dwapb_context;
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
+
+		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
+		dwapb_context.dir[i]	= dwapb_read(gpio, offset);
+
+		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
+		dwapb_context.data[i]	= dwapb_read(gpio, offset);
+
+		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
+		dwapb_context.ext[i]	= dwapb_read(gpio, offset);
+
+		if (idx == 0) {
+			dwapb_context.int_mask = dwapb_read(gpio, GPIO_INTMASK);
+			dwapb_context.int_en = dwapb_read(gpio, GPIO_INTEN);
+			dwapb_context.int_pol =
+					dwapb_read(gpio, GPIO_INT_POLARITY);
+			dwapb_context.int_type =
+					dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
+			dwapb_context.int_deb =
+					dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
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
+
+		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
+		dwapb_write(gpio, offset, dwapb_context.data[i]);
+
+		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
+		dwapb_write(gpio, offset, dwapb_context.dir[i]);
+
+		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
+		dwapb_write(gpio, offset, dwapb_context.ext[i]);
+
+		if (idx == 0) {
+			dwapb_write(gpio, GPIO_INTTYPE_LEVEL,
+				    dwapb_context.int_type);
+			dwapb_write(gpio, GPIO_INT_POLARITY,
+				    dwapb_context.int_pol);
+			dwapb_write(gpio, GPIO_PORTA_DEBOUNCE,
+				    dwapb_context.int_deb);
+			dwapb_write(gpio, GPIO_INTEN, dwapb_context.int_en);
+			dwapb_write(gpio, GPIO_INTMASK, dwapb_context.int_mask);
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

