Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3BZNUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:20:45 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61289 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab3BZNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:20:42 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, Magnus Damm <magnus.damm@gmail.com>,
        horms@verge.net.au, linus.walleij@linaro.org, linux-sh@vger.kernel.org
Date: Tue, 26 Feb 2013 22:26:23 +0900
Message-Id: <20130226132623.18365.36583.sendpatchset@w520>
Subject: [PATCH] gpio: em: Add Device Tree support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the Emma Mobile GPIO driver to add DT support.

The patch simply adds a two-cell xlate function and
updates the probe code to allow configuration via DT
using the "ngpios" property plus OF id in the same
style as gpio-mvebu.c. The code is also adjusted to
use postcore_initcall() to force early setup.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written on top of:
 [PATCH] gpio: em: Use irq_domain_add_simple() to fix runtime error

 drivers/gpio/gpio-em.c |   45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

--- 0010/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-02-26 22:11:58.000000000 +0900
@@ -231,10 +231,12 @@ static int em_gio_irq_domain_map(struct
 
 static struct irq_domain_ops em_gio_irq_domain_ops = {
 	.map	= em_gio_irq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
 };
 
 static int em_gio_probe(struct platform_device *pdev)
 {
+	struct gpio_em_config pdata_dt;
 	struct gpio_em_config *pdata = pdev->dev.platform_data;
 	struct em_gio_priv *p;
 	struct resource *io[2], *irq[2];
@@ -259,8 +261,8 @@ static int em_gio_probe(struct platform_
 	irq[0] = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	irq[1] = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
 
-	if (!io[0] || !io[1] || !irq[0] || !irq[1] || !pdata) {
-		dev_err(&pdev->dev, "missing IRQ, IOMEM or configuration\n");
+	if (!io[0] || !io[1] || !irq[0] || !irq[1]) {
+		dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
 		ret = -EINVAL;
 		goto err1;
 	}
@@ -279,6 +281,25 @@ static int em_gio_probe(struct platform_
 		goto err2;
 	}
 
+	if (!pdata) {
+		memset(&pdata_dt, 0, sizeof(pdata_dt));
+		pdata = &pdata_dt;
+
+		if (of_property_read_u32(pdev->dev.of_node, "ngpios",
+					 &pdata->number_of_pins)) {
+			dev_err(&pdev->dev, "Missing ngpios OF property\n");
+			ret = -EINVAL;
+			goto err3;
+		}
+
+		ret = of_alias_get_id(pdev->dev.of_node, "gpio");
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Couldn't get OF id\n");
+			goto err3;
+		}
+		pdata->gpio_base = ret * 32; /* 32 GPIOs per instance */
+	}
+
 	gpio_chip = &p->gpio_chip;
 	gpio_chip->direction_input = em_gio_direction_input;
 	gpio_chip->get = em_gio_get;
@@ -366,15 +387,33 @@ static int em_gio_remove(struct platform
 	return 0;
 }
 
+static const struct of_device_id em_gio_dt_ids[] = {
+	{ .compatible = "renesas,em-gio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, em_gio_dt_ids);
+
 static struct platform_driver em_gio_device_driver = {
 	.probe		= em_gio_probe,
 	.remove		= em_gio_remove,
 	.driver		= {
 		.name	= "em_gio",
+		.of_match_table = em_gio_dt_ids,
+		.owner		= THIS_MODULE,
 	}
 };
 
-module_platform_driver(em_gio_device_driver);
+static int __init em_gio_init(void)
+{
+	return platform_driver_register(&em_gio_device_driver);
+}
+postcore_initcall(em_gio_init);
+
+static void __exit em_gio_exit(void)
+{
+	platform_driver_unregister(&em_gio_device_driver);
+}
+module_exit(em_gio_exit);
 
 MODULE_AUTHOR("Magnus Damm");
 MODULE_DESCRIPTION("Renesas Emma Mobile GIO Driver");
