Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab3HNJVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:21:39 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44583
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759620Ab3HNJLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:39 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908312"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: kernel-janitors@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/29] drivers/gpio: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:07 +0200
Message-Id: <1376471493-22215-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

Move the call to platform_get_resource adjacent to the call to
devm_ioremap_resource to make the connection between them more clear.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpio/gpio-mvebu.c       |    7 +------
 drivers/gpio/gpio-spear-spics.c |    7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 80ad35e..3c3321f 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -566,12 +566,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	else
 		soc_variant = MVEBU_GPIO_SOC_VARIANT_ORION;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Cannot get memory resource\n");
-		return -ENODEV;
-	}
-
 	mvchip = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_gpio_chip), GFP_KERNEL);
 	if (!mvchip) {
 		dev_err(&pdev->dev, "Cannot allocate memory\n");
@@ -611,6 +605,7 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	mvchip->chip.dbg_show = mvebu_gpio_dbg_show;
 
 	spin_lock_init(&mvchip->lock);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mvchip->membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(mvchip->membase))
 		return PTR_ERR(mvchip->membase);
diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
index 7a4bf7c..e9a0415 100644
--- a/drivers/gpio/gpio-spear-spics.c
+++ b/drivers/gpio/gpio-spear-spics.c
@@ -128,18 +128,13 @@ static int spics_gpio_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "invalid IORESOURCE_MEM\n");
-		return -EBUSY;
-	}
-
 	spics = devm_kzalloc(&pdev->dev, sizeof(*spics), GFP_KERNEL);
 	if (!spics) {
 		dev_err(&pdev->dev, "memory allocation fail\n");
 		return -ENOMEM;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	spics->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(spics->base))
 		return PTR_ERR(spics->base);

