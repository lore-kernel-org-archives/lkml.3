Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaIRWd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:33:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38930 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbaIRWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:33:16 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] watchdog: qcom: register a restart notifier
Date: Thu, 18 Sep 2014 17:27:01 -0500
Message-Id: <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1411078425.git.joshc@codeaurora.org>
References: <cover.1411078425.git.joshc@codeaurora.org>
In-Reply-To: <cover.1411078425.git.joshc@codeaurora.org>
References: <cover.1411078425.git.joshc@codeaurora.org>
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
 drivers/watchdog/qcom-wdt.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
index e9409f5..710ab43 100644
--- a/drivers/watchdog/qcom-wdt.c
+++ b/drivers/watchdog/qcom-wdt.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/watchdog.h>
 
 #define WDT_RST		0x0
@@ -24,6 +25,7 @@
 struct qcom_wdt {
 	struct watchdog_device	wdd;
 	unsigned long		freq;
+	struct notifier_block	restart_nb;
 	void __iomem		*base;
 };
 
@@ -82,6 +84,24 @@ static const struct watchdog_info qcom_wdt_info = {
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
+	 */
+	mutex_lock(&wdt->wdd.lock);
+	writel_relaxed(0, wdt->base + WDT_EN);
+	writel_relaxed(1, wdt->base + WDT_RST);
+	writel_relaxed(0x31F3, wdt->base + WDT_BITE_TIME);
+	writel_relaxed(1, wdt->base + WDT_EN);
+	mutex_unlock(&wdt->wdd.lock);
+	return NOTIFY_DONE;
+}
+
 static int qcom_watchdog_probe(struct platform_device *pdev)
 {
 	struct qcom_wdt *wdt;
@@ -121,6 +141,17 @@ static int qcom_watchdog_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/*
+	 * WDT restart notifier has priority 0 (use as a last resort)
+	 */
+	wdt->restart_nb.notifier_call = qcom_wdt_restart;
+	ret = register_restart_handler(&wdt->restart_nb);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup restart handler\n");
+		watchdog_unregister_device(&wdt->wdd);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

