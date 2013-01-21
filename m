Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3AUKKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3AUKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:14 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/33] ARM: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:08:55 +0100
Message-Id: <1358762966-20791-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:jRXY+fAWXWQf/03pwjr832dN2E8LfBgRTcjDxn6RPIO
 M4tf2eSm/IjOomTmxA27iw+bGEbA3zNspdM9+Hrv7cI/SBP+1s
 33aIhVCB9X6qLyDZPnoYjBw29AvUORpa4LWH3X/+b5m0GnJPSr
 Hx6WBpjNpFLnwrQya0sJhifYfJBQ1DO2hp/fJWUbivKjVsX3DI
 AeMakRg/cHg/f7TdazWKS4GV0d9yETosGqU2IV0x9h/Iy/KEYv
 tyN2LBXX9C4FgISM2q+GCECjzp1iTdRbTuFZNRqACRPJZCldgA
 3YWFo+W4ifHo8HsScwZBVSO4Yf4iKSPEmVwlDwfEne5Xwl2VuT
 30WgW5DWpCF4Pme/86cNx78ZQvsof3P0sLMB9MD7tUPYXBIbut
 pvOq/MZJh0AE7SvCD6Vd63Xe7fupxCoxR3rxG8U/KVXip+n5sT
 NP5XY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-omap2/gpmc.c       | 8 +++-----
 arch/arm/mach-tegra/tegra2_emc.c | 8 +++-----
 arch/arm/plat-omap/dmtimer.c     | 8 +++-----
 arch/arm/plat-samsung/adc.c      | 8 +++-----
 4 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 8033cb7..64bac53 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1134,11 +1134,9 @@ static int gpmc_probe(struct platform_device *pdev)
 	phys_base = res->start;
 	mem_size = resource_size(res);
 
-	gpmc_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!gpmc_base) {
-		dev_err(&pdev->dev, "error: request memory / ioremap\n");
-		return -EADDRNOTAVAIL;
-	}
+	gpmc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gpmc_base))
+		return PTR_ERR(gpmc_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL)
diff --git a/arch/arm/mach-tegra/tegra2_emc.c b/arch/arm/mach-tegra/tegra2_emc.c
index e18aa2f..ce7ce42 100644
--- a/arch/arm/mach-tegra/tegra2_emc.c
+++ b/arch/arm/mach-tegra/tegra2_emc.c
@@ -312,11 +312,9 @@ static int tegra_emc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	emc_regbase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!emc_regbase) {
-		dev_err(&pdev->dev, "failed to remap registers\n");
-		return -ENOMEM;
-	}
+	emc_regbase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(emc_regbase))
+		return PTR_ERR(emc_regbase);
 
 	pdata = pdev->dev.platform_data;
 
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 7b433f3..a0daa2f 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -808,11 +808,9 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 		return  -ENOMEM;
 	}
 
-	timer->io_base = devm_request_and_ioremap(dev, mem);
-	if (!timer->io_base) {
-		dev_err(dev, "%s: region already claimed.\n", __func__);
-		return -ENOMEM;
-	}
+	timer->io_base = devm_ioremap_resource(dev, mem);
+	if (IS_ERR(timer->io_base))
+		return PTR_ERR(timer->io_base);
 
 	if (dev->of_node) {
 		if (of_find_property(dev->of_node, "ti,timer-alwon", NULL))
diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index 2d676ab..ca07cb1 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -386,11 +386,9 @@ static int s3c_adc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	adc->regs = devm_request_and_ioremap(dev, regs);
-	if (!adc->regs) {
-		dev_err(dev, "failed to map registers\n");
-		return -ENXIO;
-	}
+	adc->regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(adc->regs))
+		return PTR_ERR(adc->regs);
 
 	ret = regulator_enable(adc->vdd);
 	if (ret)
-- 
1.8.1.1

