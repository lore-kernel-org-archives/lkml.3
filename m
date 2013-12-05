Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab3LESQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:16:35 -0500
Received: from mail-qe0-f73.google.com ([209.85.128.73]:62078 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3LESQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:16:33 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>
Cc: Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] fixup: watchdog: s3c2410_wdt: use syscon regmap interface to configure pmu register
Date: Thu,  5 Dec 2013 10:15:28 -0800
Message-Id: <1386267329-9941-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386008082-28740-1-git-send-email-dianders@chromium.org>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not intended to land upon itself but is proposed fixup
to Leela Krishna's patch (v11) that can be found at
<https://patchwork.kernel.org/patch/3251841/>, potentially making a v12.

Posted so that I can build upon his patch with the fixups requested by
Guenter, Olof, and Tomasz.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Added EXYNOS5 prefix to REG_OFFSET defines (Tomasz)
- NEEDS_PMU_CONFIG => HAS_PMU_CONFIG (Olof, Guenter)
- Move QUIRK_HAS_PMU_CONFIG to (Guenter)

 drivers/watchdog/s3c2410_wdt.c | 59 +++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 47f4dcf..6a00299 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -62,9 +62,9 @@
 #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
 #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
 
-#define WDT_DISABLE_REG_OFFSET		0x0408
-#define WDT_MASK_RESET_REG_OFFSET	0x040c
-#define QUIRK_NEEDS_PMU_CONFIG		(1 << 0)
+#define EXYNOS5_WDT_DISABLE_REG_OFFSET		0x0408
+#define EXYNOS5_WDT_MASK_RESET_REG_OFFSET	0x040c
+#define QUIRK_HAS_PMU_CONFIG			(1 << 0)
 
 static bool nowayout	= WATCHDOG_NOWAYOUT;
 static int tmr_margin;
@@ -128,17 +128,17 @@ static const struct s3c2410_wdt_variant drv_data_s3c2410 = {
 
 #ifdef CONFIG_OF
 static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
-	.disable_reg = WDT_DISABLE_REG_OFFSET,
-	.mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
+	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
+	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
 	.mask_bit = 20,
-	.quirks = QUIRK_NEEDS_PMU_CONFIG
+	.quirks = QUIRK_HAS_PMU_CONFIG
 };
 
 static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
-	.disable_reg = WDT_DISABLE_REG_OFFSET,
-	.mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
+	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
+	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
 	.mask_bit = 0,
-	.quirks = QUIRK_NEEDS_PMU_CONFIG
+	.quirks = QUIRK_HAS_PMU_CONFIG
 };
 
 static const struct of_device_id s3c2410_wdt_match[] = {
@@ -183,6 +183,10 @@ static int s3c2410wdt_mask_and_disable_reset(struct s3c2410_wdt *wdt, bool mask)
 	u32 mask_val = 1 << wdt->drv_data->mask_bit;
 	u32 val = 0;
 
+	/* No need to do anything if no PMU CONFIG needed */
+	if (!(wdt->drv_data->quirks & QUIRK_HAS_PMU_CONFIG))
+		return 0;
+
 	if (mask)
 		val = mask_val;
 
@@ -460,7 +464,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	wdt->wdt_device = s3c2410_wdd;
 
 	wdt->drv_data = get_wdt_drv_data(pdev);
-	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG) {
+	if (wdt->drv_data->quirks & QUIRK_HAS_PMU_CONFIG) {
 		wdt->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
 							"samsung,syscon-phandle");
 		if (IS_ERR(wdt->pmureg)) {
@@ -537,11 +541,9 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		goto err_cpufreq;
 	}
 
-	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG) {
-		ret = s3c2410wdt_mask_and_disable_reset(wdt, false);
-		if (ret < 0)
-			goto err_unregister;
-	}
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, false);
+	if (ret < 0)
+		goto err_unregister;
 
 	if (tmr_atboot && started == 0) {
 		dev_info(dev, "starting watchdog timer\n");
@@ -586,11 +588,9 @@ static int s3c2410wdt_remove(struct platform_device *dev)
 	int ret;
 	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
-	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG) {
-		ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
-		if (ret < 0)
-			return ret;
-	}
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
+	if (ret < 0)
+		return ret;
 
 	watchdog_unregister_device(&wdt->wdt_device);
 
@@ -606,8 +606,7 @@ static void s3c2410wdt_shutdown(struct platform_device *dev)
 {
 	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
-	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG)
-		s3c2410wdt_mask_and_disable_reset(wdt, true);
+	s3c2410wdt_mask_and_disable_reset(wdt, true);
 
 	s3c2410wdt_stop(&wdt->wdt_device);
 }
@@ -623,11 +622,9 @@ static int s3c2410wdt_suspend(struct device *dev)
 	wdt->wtcon_save = readl(wdt->reg_base + S3C2410_WTCON);
 	wdt->wtdat_save = readl(wdt->reg_base + S3C2410_WTDAT);
 
-	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG) {
-		ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
-		if (ret < 0)
-			return ret;
-	}
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
+	if (ret < 0)
+		return ret;
 
 	/* Note that WTCNT doesn't need to be saved. */
 	s3c2410wdt_stop(&wdt->wdt_device);
@@ -645,11 +642,9 @@ static int s3c2410wdt_resume(struct device *dev)
 	writel(wdt->wtdat_save, wdt->reg_base + S3C2410_WTCNT);/* Reset count */
 	writel(wdt->wtcon_save, wdt->reg_base + S3C2410_WTCON);
 
-	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG) {
-		ret = s3c2410wdt_mask_and_disable_reset(wdt, false);
-		if (ret < 0)
-			return ret;
-	}
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, false);
+	if (ret < 0)
+		return ret;
 
 	dev_info(dev, "watchdog %sabled\n",
 		(wdt->wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
-- 
1.8.5.1

