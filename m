Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbaH0Jyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:54:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:3195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbaH0Jyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:54:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="473110658"
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
Subject: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Date: Wed, 27 Aug 2014 10:46:28 -0700
Message-Id: <1409161588-19417-4-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables suspend and resume mode for the power management, and
it is based on Josef Ahmad's previous work.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/gpio-dwapb.c |   67 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index e0ab988..1055cb3 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -560,10 +560,77 @@ static const struct of_device_id dwapb_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, dwapb_of_match);
 
+#if defined CONFIG_PM_SLEEP
+/* Store GPIO context across system-wide suspend/resume transitions */
+static struct gpio_saved_regs {
+	unsigned long data;
+	unsigned long dir;
+	unsigned long int_en;
+	unsigned long int_mask;
+	unsigned long int_type;
+	unsigned long int_pol;
+	unsigned long int_deb;
+} saved_regs;
+
+static int dwapb_gpio_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
+	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	saved_regs.int_mask	= dwapb_read(gpio, GPIO_INTMASK);
+	saved_regs.int_en	= dwapb_read(gpio, GPIO_INTEN);
+	saved_regs.int_deb	= dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
+	saved_regs.int_pol	= dwapb_read(gpio, GPIO_INT_POLARITY);
+	saved_regs.int_type	= dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
+	saved_regs.dir		= dwapb_read(gpio, GPIO_SWPORTA_DDR);
+	saved_regs.data		= dwapb_read(gpio, GPIO_SWPORTA_DR);
+
+	/* Mask out interrupts */
+	dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
+
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
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	dwapb_write(gpio, GPIO_SWPORTA_DR, saved_regs.data);
+	dwapb_write(gpio, GPIO_SWPORTA_DDR, saved_regs.dir);
+	dwapb_write(gpio, GPIO_INTTYPE_LEVEL, saved_regs.int_type);
+	dwapb_write(gpio, GPIO_INT_POLARITY, saved_regs.int_pol);
+	dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, saved_regs.int_deb);
+	dwapb_write(gpio, GPIO_INTEN, saved_regs.int_en);
+	dwapb_write(gpio, GPIO_INTMASK, saved_regs.int_mask);
+
+	/* Clear out spurious interrupts */
+	dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
+
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

