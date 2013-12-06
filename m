Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3LFVPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:15:50 -0500
Received: from mail-oa0-f74.google.com ([209.85.219.74]:52252 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3LFVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:15:48 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>
Cc: Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] watchdog: s3c2410_wdt: Report when the watchdog reset the system
Date: Fri,  6 Dec 2013 13:08:07 -0800
Message-Id: <1386364088-6220-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386267329-9941-2-git-send-email-dianders@chromium.org>
References: <1386267329-9941-2-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A good watchdog driver is supposed to report when it was responsible
for resetting the system.  Implement this for the s3c2410, at least on
exynos5250 and exynos5420 where we already have a pointer to the PMU
registers to read the information.

Note that exynos4 SoCs also provide the reset status, but providing
that is left as an exercise for future changes and is not plumbed up
in this patch series.  Also note the exynos4 SoCs don't appear to need
any PMU config, which is why this patch separates the concepts of
having PMU Registers vs. needing PMU Config.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3:
- Atop the real v12 of Leela Krishna's patches.
- Combine QURIKs to one line.

Changes in v2:
- Explained QUIRK organization in patch descritpion.
- Reduced indentation as per Olof and Tomasz suggestion.
- Now atop proposed v12 of Leela Krishna's patches.
- NEEDS => HAS, EXYNOS5 prefix

 drivers/watchdog/s3c2410_wdt.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index e1b1a75..ff1b5cc 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -62,9 +62,15 @@
 #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
 #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
 
+#define EXYNOS5_RST_STAT_REG_OFFSET		0x0404
 #define EXYNOS5_WDT_DISABLE_REG_OFFSET		0x0408
 #define EXYNOS5_WDT_MASK_RESET_REG_OFFSET	0x040c
 #define QUIRK_HAS_PMU_CONFIG			(1 << 0)
+#define QUIRK_HAS_RST_STAT			(1 << 1)
+
+/* These quirks require that we have a PMU register map */
+#define QUIRKS_HAVE_PMUREG			(QUIRK_HAS_PMU_CONFIG | \
+						 QUIRK_HAS_RST_STAT)
 
 static bool nowayout	= WATCHDOG_NOWAYOUT;
 static int tmr_margin;
@@ -98,6 +104,9 @@ MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
  * timer reset functionality.
  * @mask_bit: Bit number for the watchdog timer in the disable register and the
  * mask reset register.
+ * @rst_stat_reg: Offset in pmureg for the register that has the reset status.
+ * @rst_stat_bit: Bit number in the rst_stat register indicating a watchdog
+ * reset.
  * @quirks: A bitfield of quirks.
  */
 
@@ -105,6 +114,8 @@ struct s3c2410_wdt_variant {
 	int disable_reg;
 	int mask_reset_reg;
 	int mask_bit;
+	int rst_stat_reg;
+	int rst_stat_bit;
 	u32 quirks;
 };
 
@@ -131,14 +142,18 @@ static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
 	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
 	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
 	.mask_bit = 20,
-	.quirks = QUIRK_HAS_PMU_CONFIG
+	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
+	.rst_stat_bit = 20,
+	.quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,
 };
 
 static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
 	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
 	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
 	.mask_bit = 0,
-	.quirks = QUIRK_HAS_PMU_CONFIG
+	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
+	.rst_stat_bit = 9,
+	.quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,
 };
 
 static const struct of_device_id s3c2410_wdt_match[] = {
@@ -427,6 +442,23 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
 }
 #endif
 
+static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
+{
+	unsigned int rst_stat;
+	int ret;
+
+	if (!(wdt->drv_data->quirks & QUIRK_HAS_RST_STAT))
+		return 0;
+
+	ret = regmap_read(wdt->pmureg, wdt->drv_data->rst_stat_reg, &rst_stat);
+	if (ret)
+		dev_warn(wdt->dev, "Couldn't get RST_STAT register\n");
+	else if (rst_stat & BIT(wdt->drv_data->rst_stat_bit))
+		return WDIOF_CARDRESET;
+
+	return 0;
+}
+
 /* s3c2410_get_wdt_driver_data */
 static inline struct s3c2410_wdt_variant *
 get_wdt_drv_data(struct platform_device *pdev)
@@ -464,7 +496,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	wdt->wdt_device = s3c2410_wdd;
 
 	wdt->drv_data = get_wdt_drv_data(pdev);
-	if (wdt->drv_data->quirks & QUIRK_HAS_PMU_CONFIG) {
+	if (wdt->drv_data->quirks & QUIRKS_HAVE_PMUREG) {
 		wdt->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
 						"samsung,syscon-phandle");
 		if (IS_ERR(wdt->pmureg)) {
@@ -535,6 +567,8 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_nowayout(&wdt->wdt_device, nowayout);
 
+	wdt->wdt_device.bootstatus = s3c2410wdt_get_bootstatus(wdt);
+
 	ret = watchdog_register_device(&wdt->wdt_device);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
-- 
1.8.5.1

