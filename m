Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3EJIQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:30 -0400
Received: from sauhun.de ([89.238.76.85]:60354 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3EJIQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:26 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org
Subject: [RFC 05/42] drivers/gpio: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:50 +0200
Message-Id: <1368173847-5661-6-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpio/gpio-mvebu.c       |   12 +-----------
 drivers/gpio/gpio-spear-spics.c |    7 +------
 drivers/gpio/gpio-tegra.c       |    5 -----
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index bf69a7e..60e8c6e 100644
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
@@ -619,11 +614,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	 * per-CPU registers */
 	if (soc_variant == MVEBU_GPIO_SOC_VARIANT_ARMADAXP) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (!res) {
-			dev_err(&pdev->dev, "Cannot get memory resource\n");
-			return -ENODEV;
-		}
-
 		mvchip->percpu_membase = devm_ioremap_resource(&pdev->dev,
 							       res);
 		if (IS_ERR(mvchip->percpu_membase))
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
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index da4cb5b..9a62672 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -463,11 +463,6 @@ static int tegra_gpio_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Missing MEM resource\n");
-		return -ENODEV;
-	}
-
 	regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
-- 
1.7.10.4

