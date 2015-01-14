Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbbANCyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:54:40 -0500
Received: from 60-248-182-7.HINET-IP.hinet.net ([60.248.182.7]:38670 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543AbbANCya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:54:30 -0500
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 21:54:22 EST
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0E2eWRS024528, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <oakad@yahoo.com>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 3/3] memstick: rtsx: move suspend/resume to pm ops
Date: Wed, 14 Jan 2015 10:40:17 +0800
Message-ID: <50460f994b1fe34c329ab0d59bcdb81bbf6b941b.1421202479.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421202479.git.micky_ching@realsil.com.cn>
References: <cover.1421202479.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Move suspend/resume function to pm ops, make it consistence
with rtsx_usb_ms.c driver.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index c9981af..475afa8 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/delay.h>
+#include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/memstick.h>
 #include <linux/mfd/rtsx_pci.h>
@@ -514,11 +515,11 @@ static int rtsx_pci_ms_set_param(struct memstick_host *msh,
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-static int rtsx_pci_ms_suspend(struct platform_device *pdev, pm_message_t state)
+static int rtsx_pci_ms_suspend(struct device *dev)
 {
-	struct realtek_pci_ms *host = platform_get_drvdata(pdev);
+	struct realtek_pci_ms *host = dev_get_drvdata(dev);
 	struct memstick_host *msh = host->msh;
 
 	dev_dbg(ms_dev(host), "--> %s\n", __func__);
@@ -527,9 +528,9 @@ static int rtsx_pci_ms_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int rtsx_pci_ms_resume(struct platform_device *pdev)
+static int rtsx_pci_ms_resume(struct device *dev)
 {
-	struct realtek_pci_ms *host = platform_get_drvdata(pdev);
+	struct realtek_pci_ms *host = dev_get_drvdata(dev);
 	struct memstick_host *msh = host->msh;
 
 	dev_dbg(ms_dev(host), "--> %s\n", __func__);
@@ -537,13 +538,7 @@ static int rtsx_pci_ms_resume(struct platform_device *pdev)
 	memstick_resume_host(msh);
 	return 0;
 }
-
-#else /* CONFIG_PM */
-
-#define rtsx_pci_ms_suspend NULL
-#define rtsx_pci_ms_resume NULL
-
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static void rtsx_pci_ms_card_event(struct platform_device *pdev)
 {
@@ -641,6 +636,9 @@ static int rtsx_pci_ms_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rtsx_pci_ms_pm_ops,
+	rtsx_pci_ms_suspend, rtsx_pci_ms_resume);
+
 static struct platform_device_id rtsx_pci_ms_ids[] = {
 	{
 		.name = DRV_NAME_RTSX_PCI_MS,
@@ -654,10 +652,9 @@ static struct platform_driver rtsx_pci_ms_driver = {
 	.probe		= rtsx_pci_ms_drv_probe,
 	.remove		= rtsx_pci_ms_drv_remove,
 	.id_table       = rtsx_pci_ms_ids,
-	.suspend	= rtsx_pci_ms_suspend,
-	.resume		= rtsx_pci_ms_resume,
 	.driver		= {
 		.name	= DRV_NAME_RTSX_PCI_MS,
+		.pm	= &rtsx_pci_ms_pm_ops,
 	},
 };
 module_platform_driver(rtsx_pci_ms_driver);
-- 
1.9.1

