Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3CISM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:12:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5517 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CISMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:12:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 09 Mar 2013 10:11:47 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/5] rtc: tegra: Use struct dev_pm_ops for power management
Date: Sat, 9 Mar 2013 23:39:46 +0530
Message-ID: <1362852588-13362-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
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
 drivers/rtc/rtc-tegra.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index d64cde6..f7718de 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -391,10 +391,9 @@ static int __exit tegra_rtc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_rtc_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
+	struct tegra_rtc_info *info = dev_get_drvdata(dev);
 
 	tegra_rtc_wait_while_busy(dev);
 
@@ -416,10 +415,9 @@ static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
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
@@ -431,6 +429,10 @@ static int tegra_rtc_resume(struct platform_device *pdev)
 }
 #endif
 
+static const struct dev_pm_ops tegra_rtc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(tegra_rtc_suspend, tegra_rtc_resume)
+};
+
 static void tegra_rtc_shutdown(struct platform_device *pdev)
 {
 	dev_vdbg(&pdev->dev, "disabling interrupts.\n");
@@ -445,11 +447,8 @@ static struct platform_driver tegra_rtc_driver = {
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

