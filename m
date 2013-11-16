Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3KPABx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:01:53 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37780 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3KPABg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:36 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 02/23] watchdog: omap_wdt: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:05 +0200
Message-Id: <1384560086-11994-3-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/watchdog/omap_wdt.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index af88ffd..2ff7bff 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -68,14 +68,14 @@ static void omap_wdt_reload(struct omap_wdt_dev *wdev)
 	void __iomem    *base = wdev->base;
 
 	/* wait for posted write to complete */
-	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
+	while ((readl_relaxed(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 
 	wdev->wdt_trgr_pattern = ~wdev->wdt_trgr_pattern;
-	__raw_writel(wdev->wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
+	writel_relaxed(wdev->wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
 
 	/* wait for posted write to complete */
-	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
+	while ((readl_relaxed(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 	/* reloaded WCRR from WLDR */
 }
@@ -85,12 +85,12 @@ static void omap_wdt_enable(struct omap_wdt_dev *wdev)
 	void __iomem *base = wdev->base;
 
 	/* Sequence to enable the watchdog */
-	__raw_writel(0xBBBB, base + OMAP_WATCHDOG_SPR);
-	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
+	writel_relaxed(0xBBBB, base + OMAP_WATCHDOG_SPR);
+	while ((readl_relaxed(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
 
-	__raw_writel(0x4444, base + OMAP_WATCHDOG_SPR);
-	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
+	writel_relaxed(0x4444, base + OMAP_WATCHDOG_SPR);
+	while ((readl_relaxed(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
 }
 
@@ -99,12 +99,12 @@ static void omap_wdt_disable(struct omap_wdt_dev *wdev)
 	void __iomem *base = wdev->base;
 
 	/* sequence required to disable watchdog */
-	__raw_writel(0xAAAA, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
-	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
+	writel_relaxed(0xAAAA, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
+	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
 
-	__raw_writel(0x5555, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
-	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
+	writel_relaxed(0x5555, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
+	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
 }
 
@@ -115,11 +115,11 @@ static void omap_wdt_set_timer(struct omap_wdt_dev *wdev,
 	void __iomem *base = wdev->base;
 
 	/* just count up at 32 KHz */
-	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
+	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
 
-	__raw_writel(pre_margin, base + OMAP_WATCHDOG_LDR);
-	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
+	writel_relaxed(pre_margin, base + OMAP_WATCHDOG_LDR);
+	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
 }
 
@@ -135,11 +135,11 @@ static int omap_wdt_start(struct watchdog_device *wdog)
 	pm_runtime_get_sync(wdev->dev);
 
 	/* initialize prescaler */
-	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
+	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
 
-	__raw_writel((1 << 5) | (PTV << 2), base + OMAP_WATCHDOG_CNTRL);
-	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
+	writel_relaxed((1 << 5) | (PTV << 2), base + OMAP_WATCHDOG_CNTRL);
+	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
 
 	omap_wdt_set_timer(wdev, wdog->timeout);
@@ -275,7 +275,7 @@ static int omap_wdt_probe(struct platform_device *pdev)
 	}
 
 	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
-		__raw_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
+		readl_relaxed(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
 		omap_wdt->timeout);
 
 	pm_runtime_put_sync(wdev->dev);
-- 
1.7.9.5

