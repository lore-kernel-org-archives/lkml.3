Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3CKTc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:32:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3905 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3CKTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:32:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 12:32:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 5/5] rtc: tegra: use managed rtc_device_register
Date: Tue, 12 Mar 2013 01:00:01 +0530
Message-ID: <1363030201-14717-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1363030201-14717-1-git-send-email-ldewangan@nvidia.com>
References: <1363030201-14717-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_rtc_device_register for registering RTC device.
This will reduce the code for unregistering RTC device in
cleanup path and remove the implementation of remove
callback of platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes from V1:
- Formatting the code.
- Add Thierry's reviewed by.

Changes from V2:
- Add Stephen's reviewed by.
- No change in code.

 drivers/rtc/rtc-tegra.c |   27 ++++-----------------------
 1 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index e9f0d53..7cb3da0 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -349,13 +349,11 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register(
-		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(dev_name(&pdev->dev),
+				&pdev->dev, &tegra_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
-		info->rtc_dev = NULL;
-		dev_err(&pdev->dev,
-			"Unable to register device (err=%d).\n",
+		dev_err(&pdev->dev, "Unable to register device (err=%d).\n",
 			ret);
 		return ret;
 	}
@@ -367,28 +365,12 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
 			ret);
-		goto err_dev_unreg;
+		return ret;
 	}
 
 	dev_notice(&pdev->dev, "Tegra internal Real Time Clock\n");
 
 	return 0;
-
-err_dev_unreg:
-	rtc_device_unregister(info->rtc_dev);
-
-	return ret;
-}
-
-static int __exit tegra_rtc_remove(struct platform_device *pdev)
-{
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(info->rtc_dev);
-
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -440,7 +422,6 @@ static void tegra_rtc_shutdown(struct platform_device *pdev)
 
 MODULE_ALIAS("platform:tegra_rtc");
 static struct platform_driver tegra_rtc_driver = {
-	.remove		= __exit_p(tegra_rtc_remove),
 	.shutdown	= tegra_rtc_shutdown,
 	.driver		= {
 		.name	= "tegra_rtc",
-- 
1.7.1.1

