Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbaIWXLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:11:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40541 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbaIWXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:10:12 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] watchdog: qcom: register a restart notifier
Date: Tue, 23 Sep 2014 18:04:38 -0500
Message-Id: <2d539bc944f3e8fc70f39728b0f61fd171b2e5bf.1411513109.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411513109.git.joshc@codeaurora.org>
References: <cover.1411513109.git.joshc@codeaurora.org>
In-Reply-To: <cover.1411513109.git.joshc@codeaurora.org>
References: <cover.1411513109.git.joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
resort mechanism for triggering chip reset.  Usually, other restart
methods (such as PS_HOLD) are preferrable for issuing a more complete
reset of the chip.  As such, keep the priority of the watchdog notifier
low.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/watchdog/qcom-wdt.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
index d5e46e2..eba92ef 100644
--- a/drivers/watchdog/qcom-wdt.c
+++ b/drivers/watchdog/qcom-wdt.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/watchdog.h>
 
 #define WDT_RST		0x0
@@ -25,6 +26,7 @@
 struct qcom_wdt {
 	struct watchdog_device	wdd;
 	struct clk		*clk;
+	struct notifier_block	restart_nb;
 	void __iomem		*base;
 };
 
@@ -86,6 +88,23 @@ static const struct watchdog_info qcom_wdt_info = {
 	.identity	= KBUILD_MODNAME,
 };
 
+static int qcom_wdt_restart(struct notifier_block *nb, unsigned long action,
+			    void *data)
+{
+	struct qcom_wdt *wdt = container_of(nb, struct qcom_wdt, restart_nb);
+
+	/*
+	 * Trigger watchdog bite:
+	 *    Setup BITE_TIME to be very low, and enable WDT.
+	 *      0x31F3 => 390ms @ 32kHz, also value at reset
+	 */
+	writel(0, wdt->base + WDT_EN);
+	writel(1, wdt->base + WDT_RST);
+	writel(0x31F3, wdt->base + WDT_BITE_TIME);
+	writel(1, wdt->base + WDT_EN);
+	return NOTIFY_DONE;
+}
+
 static int qcom_wdt_probe(struct platform_device *pdev)
 {
 	struct qcom_wdt *wdt;
@@ -141,6 +160,14 @@ static int qcom_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/*
+	 * WDT restart notifier has priority 0 (use as a last resort)
+	 */
+	wdt->restart_nb.notifier_call = qcom_wdt_restart;
+	ret = register_restart_handler(&wdt->restart_nb);
+	if (ret)
+		dev_err(&pdev->dev, "failed to setup restart handler\n");
+
 	platform_set_drvdata(pdev, wdt);
 	return 0;
 }
@@ -149,6 +176,7 @@ static int qcom_wdt_remove(struct platform_device *pdev)
 {
 	struct qcom_wdt *wdt = platform_get_drvdata(pdev);
 
+	unregister_restart_handler(&wdt->restart_nb);
 	watchdog_unregister_device(&wdt->wdd);
 	clk_disable_unprepare(wdt->clk);
 	return 0;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

