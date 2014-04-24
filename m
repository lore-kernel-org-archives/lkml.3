Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaDXK0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:26:51 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:49005 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaDXK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:26:48 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/6] drivers: sh: Use generic runtime and clock helpers
Date: Thu, 24 Apr 2014 12:26:37 +0200
Message-Id: <1398335198-26555-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398335198-26555-1-git-send-email-geert+renesas@glider.be>
References: <1398335198-26555-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on "drivers: sh: pm_runtime does not need idle callback" and
"drivers: sh: pm_runtime implementation needs to suspend and resume devices"
---
 drivers/sh/pm_runtime.c |   38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/sh/pm_runtime.c b/drivers/sh/pm_runtime.c
index f0c4a384d49f..05b719637dd4 100644
--- a/drivers/sh/pm_runtime.c
+++ b/drivers/sh/pm_runtime.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
-#include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_clock.h>
 #include <linux/platform_device.h>
@@ -21,43 +20,10 @@
 #include <linux/slab.h>
 
 #ifdef CONFIG_PM_RUNTIME
-static int sh_pm_runtime_suspend(struct device *dev)
-{
-	int ret;
-
-	ret = pm_generic_runtime_suspend(dev);
-	if (ret) {
-		dev_err(dev, "failed to suspend device\n");
-		return ret;
-	}
-
-	ret = pm_clk_suspend(dev);
-	if (ret) {
-		dev_err(dev, "failed to suspend clock\n");
-		pm_generic_runtime_resume(dev);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int sh_pm_runtime_resume(struct device *dev)
-{
-	int ret;
-
-	ret = pm_clk_resume(dev);
-	if (ret) {
-		dev_err(dev, "failed to resume clock\n");
-		return ret;
-	}
-
-	return pm_generic_runtime_resume(dev);
-}
-
 static struct dev_pm_domain default_pm_domain = {
 	.ops = {
-		.runtime_suspend = sh_pm_runtime_suspend,
-		.runtime_resume = sh_pm_runtime_resume,
+		.runtime_suspend = pm_generic_runtime_clk_suspend,
+		.runtime_resume = pm_generic_clk_runtime_resume,
 		USE_PLATFORM_PM_SLEEP_OPS
 	},
 };
-- 
1.7.9.5

