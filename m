Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495Ab3HJPW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:22:58 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:43984
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934483Ab3HJPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:56 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: cjb@laptop.org, wei_wang@realsil.com.cn, sameo@linux.intel.com,
        arnd@arndb.de, jg1.han@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] mmc:rtsx_pci_sdmmc change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:54 -0600
Message-Id: <1376148055-2539-9-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change rtsx_pci_sdmmc platform driver to register pm ops using dev_pm_ops
instead of legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 82a35b9..fc52f28 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1166,9 +1166,9 @@ static const struct mmc_host_ops realtek_pci_sdmmc_ops = {
 };
 
 #ifdef CONFIG_PM
-static int rtsx_pci_sdmmc_suspend(struct platform_device *pdev,
-		pm_message_t state)
+static int rtsx_pci_sdmmc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 	struct mmc_host *mmc = host->mmc;
 	int err;
@@ -1182,8 +1182,9 @@ static int rtsx_pci_sdmmc_suspend(struct platform_device *pdev,
 	return 0;
 }
 
-static int rtsx_pci_sdmmc_resume(struct platform_device *pdev)
+static int rtsx_pci_sdmmc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 	struct mmc_host *mmc = host->mmc;
 
@@ -1331,15 +1332,17 @@ static struct platform_device_id rtsx_pci_sdmmc_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, rtsx_pci_sdmmc_ids);
 
+static SIMPLE_DEV_PM_OPS(rtsx_pci_sdmmc_dev_pm_ops, rtsx_pci_sdmmc_suspend,
+			 rtsx_pci_sdmmc_resume);
+
 static struct platform_driver rtsx_pci_sdmmc_driver = {
 	.probe		= rtsx_pci_sdmmc_drv_probe,
 	.remove		= rtsx_pci_sdmmc_drv_remove,
 	.id_table       = rtsx_pci_sdmmc_ids,
-	.suspend	= rtsx_pci_sdmmc_suspend,
-	.resume		= rtsx_pci_sdmmc_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= DRV_NAME_RTSX_PCI_SDMMC,
+		.pm	= &rtsx_pci_sdmmc_dev_pm_ops,
 	},
 };
 module_platform_driver(rtsx_pci_sdmmc_driver);
-- 
1.7.10.4

