Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3K0Muv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:50:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38715 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab3K0MuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:50:11 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 2/5] watchdog: davinci: use davinci_wdt_device structure to hold device data
Date: Wed, 27 Nov 2013 14:48:25 +0200
Message-ID: <1385556508-3935-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385556508-3935-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1385556508-3935-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SoCs, like Keystone 2, can support more than one WDT and each
watchdog device has to use it's own base address, clock source,
watchdog device, so add new davinci_wdt_device structure to hold
device data.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Guenter roeck <linux@roeck-us.net>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/watchdog/davinci_wdt.c |   74 ++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 9595e70..2d46c43 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -56,51 +56,63 @@
 #define WDKEY_SEQ1		(0xda7e << 16)
 
 static int heartbeat;
-static void __iomem	*wdt_base;
-struct clk		*wdt_clk;
-static struct watchdog_device	wdt_wdd;
+
+/*
+ * struct to hold data for each WDT device
+ * @base - base io address of WD device
+ * @clk - source clock of WDT
+ * @wdd - hold watchdog device as is in WDT core
+ */
+struct davinci_wdt_device {
+	void __iomem		*base;
+	struct clk		*clk;
+	struct watchdog_device	wdd;
+};
 
 static int davinci_wdt_start(struct watchdog_device *wdd)
 {
 	u32 tgcr;
 	u32 timer_margin;
 	unsigned long wdt_freq;
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
 
-	wdt_freq = clk_get_rate(wdt_clk);
+	wdt_freq = clk_get_rate(davinci_wdt->clk);
 
 	/* disable, internal clock source */
-	iowrite32(0, wdt_base + TCR);
+	iowrite32(0, davinci_wdt->base + TCR);
 	/* reset timer, set mode to 64-bit watchdog, and unreset */
-	iowrite32(0, wdt_base + TGCR);
+	iowrite32(0, davinci_wdt->base + TGCR);
 	tgcr = TIMMODE_64BIT_WDOG | TIM12RS_UNRESET | TIM34RS_UNRESET;
-	iowrite32(tgcr, wdt_base + TGCR);
+	iowrite32(tgcr, davinci_wdt->base + TGCR);
 	/* clear counter regs */
-	iowrite32(0, wdt_base + TIM12);
-	iowrite32(0, wdt_base + TIM34);
+	iowrite32(0, davinci_wdt->base + TIM12);
+	iowrite32(0, davinci_wdt->base + TIM34);
 	/* set timeout period */
 	timer_margin = (((u64)wdd->timeout * wdt_freq) & 0xffffffff);
-	iowrite32(timer_margin, wdt_base + PRD12);
+	iowrite32(timer_margin, davinci_wdt->base + PRD12);
 	timer_margin = (((u64)wdd->timeout * wdt_freq) >> 32);
-	iowrite32(timer_margin, wdt_base + PRD34);
+	iowrite32(timer_margin, davinci_wdt->base + PRD34);
 	/* enable run continuously */
-	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
+	iowrite32(ENAMODE12_PERIODIC, davinci_wdt->base + TCR);
 	/* Once the WDT is in pre-active state write to
 	 * TIM12, TIM34, PRD12, PRD34, TCR, TGCR, WDTCR are
 	 * write protected (except for the WDKEY field)
 	 */
 	/* put watchdog in pre-active state */
-	iowrite32(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0 | WDEN, davinci_wdt->base + WDTCR);
 	/* put watchdog in active state */
-	iowrite32(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ1 | WDEN, davinci_wdt->base + WDTCR);
 	return 0;
 }
 
 static int davinci_wdt_ping(struct watchdog_device *wdd)
 {
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
+
 	/* put watchdog in service state */
-	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0, davinci_wdt->base + WDTCR);
 	/* put watchdog in active state */
-	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ1, davinci_wdt->base + WDTCR);
 	return 0;
 }
 
@@ -122,14 +134,21 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource  *wdt_mem;
 	struct watchdog_device *wdd;
+	struct davinci_wdt_device *davinci_wdt;
+
+	davinci_wdt = devm_kzalloc(dev, sizeof(*davinci_wdt), GFP_KERNEL);
+	if (!davinci_wdt)
+		return -ENOMEM;
 
-	wdt_clk = devm_clk_get(dev, NULL);
-	if (WARN_ON(IS_ERR(wdt_clk)))
-		return PTR_ERR(wdt_clk);
+	davinci_wdt->clk = devm_clk_get(dev, NULL);
+	if (WARN_ON(IS_ERR(davinci_wdt->clk)))
+		return PTR_ERR(davinci_wdt->clk);
 
-	clk_prepare_enable(wdt_clk);
+	clk_prepare_enable(davinci_wdt->clk);
 
-	wdd			= &wdt_wdd;
+	platform_set_drvdata(pdev, davinci_wdt);
+
+	wdd			= &davinci_wdt->wdd;
 	wdd->info		= &davinci_wdt_info;
 	wdd->ops		= &davinci_wdt_ops;
 	wdd->min_timeout	= 1;
@@ -140,12 +159,13 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 
 	dev_info(dev, "heartbeat %d sec\n", wdd->timeout);
 
+	watchdog_set_drvdata(wdd, davinci_wdt);
 	watchdog_set_nowayout(wdd, WATCHDOG_NOWAYOUT);
 
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	wdt_base = devm_ioremap_resource(dev, wdt_mem);
-	if (IS_ERR(wdt_base))
-		return PTR_ERR(wdt_base);
+	davinci_wdt->base = devm_ioremap_resource(dev, wdt_mem);
+	if (IS_ERR(davinci_wdt->base))
+		return PTR_ERR(davinci_wdt->base);
 
 	ret = watchdog_register_device(wdd);
 	if (ret < 0)
@@ -156,8 +176,10 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 
 static int davinci_wdt_remove(struct platform_device *pdev)
 {
-	watchdog_unregister_device(&wdt_wdd);
-	clk_disable_unprepare(wdt_clk);
+	struct davinci_wdt_device *davinci_wdt = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&davinci_wdt->wdd);
+	clk_disable_unprepare(davinci_wdt->clk);
 
 	return 0;
 }
-- 
1.7.9.5

