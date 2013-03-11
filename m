Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3CKIru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:47:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14518 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3CKIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:47:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 11 Mar 2013 01:40:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/5] rtc: tegra: Use struct dev_pm_ops for power management
Date: Mon, 11 Mar 2013 14:14:25 +0530
Message-ID: <1362991468-30226-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
References: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the Tegra RTC controller driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Use SIMPLE_DEV_PM_OPS

 drivers/rtc/rtc-tegra.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index d64cde6..6373eb7 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 
 /* set to 1 = busy every eight 32kHz clocks during copy of sec+msec to AHB */
 #define TEGRA_RTC_REG_BUSY			0x004
@@ -391,10 +392,9 @@ static int __exit tegra_rtc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_rtc_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
+	struct tegra_rtc_info *info = dev_get_drvdata(dev);
 
 	tegra_rtc_wait_while_busy(dev);
 
@@ -416,10 +416,9 @@ static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int tegra_rtc_resume(struct platform_device *pdev)
+static int tegra_rtc_resume(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
+	struct tegra_rtc_info *info = dev_get_drvdata(dev);
 
 	dev_vdbg(dev, "Resume (device_may_wakeup=%d)\n",
 		device_may_wakeup(dev));
@@ -431,6 +430,8 @@ static int tegra_rtc_resume(struct platform_device *pdev)
 }
 #endif
 
+SIMPLE_DEV_PM_OPS(tegra_rtc_pm_ops, tegra_rtc_suspend, tegra_rtc_resume);
+
 static void tegra_rtc_shutdown(struct platform_device *pdev)
 {
 	dev_vdbg(&pdev->dev, "disabling interrupts.\n");
@@ -445,11 +446,8 @@ static struct platform_driver tegra_rtc_driver = {
 		.name	= "tegra_rtc",
 		.owner	= THIS_MODULE,
 		.of_match_table = tegra_rtc_dt_match,
+		.pm	= &tegra_rtc_pm_ops,
 	},
-#ifdef CONFIG_PM_SLEEP
-	.suspend	= tegra_rtc_suspend,
-	.resume		= tegra_rtc_resume,
-#endif
 };
 
 static int __init tegra_rtc_init(void)
-- 
1.7.1.1

