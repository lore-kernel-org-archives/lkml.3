Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3GEW5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:57:41 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:57693
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab3GEW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:57:40 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: linux@arm.linux.org.uk, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] arm: Convert sa1111 platform and bus legacy pm_ops to dev_pm_ops
Date: Fri,  5 Jul 2013 16:57:35 -0600
Message-Id: <1373065055-13887-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert arch/arm/common/sa1111 platform and bus legacy pm_ops to dev_pm_ops.
This change also updates the use of COMFIG_PM to CONFIG_PM_SLEEP as this
platform and bus code implements PM_SLEEP ops and not the PM_RUNTIME ops.
Compile tested.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 arch/arm/common/sa1111.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index e57d7e5..95594f0 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -107,7 +107,7 @@ struct sa1111 {
 	spinlock_t	lock;
 	void __iomem	*base;
 	struct sa1111_platform_data *pdata;
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	void		*saved_state;
 #endif
 };
@@ -870,11 +870,11 @@ struct sa1111_save_data {
 	unsigned int	wakeen1;
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
+static int sa1111_suspend(struct device *dev)
 {
-	struct sa1111 *sachip = platform_get_drvdata(dev);
+	struct sa1111 *sachip = platform_get_drvdata(to_platform_device(dev));
 	struct sa1111_save_data *save;
 	unsigned long flags;
 	unsigned int val;
@@ -937,9 +937,10 @@ static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
  *	restored by their respective drivers, and must be called
  *	via LDM after this function.
  */
-static int sa1111_resume(struct platform_device *dev)
+static int sa1111_resume(struct device *dev)
 {
-	struct sa1111 *sachip = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct sa1111 *sachip = platform_get_drvdata(pdev);
 	struct sa1111_save_data *save;
 	unsigned long flags, id;
 	void __iomem *base;
@@ -955,7 +956,7 @@ static int sa1111_resume(struct platform_device *dev)
 	id = sa1111_readl(sachip->base + SA1111_SKID);
 	if ((id & SKID_ID_MASK) != SKID_SA1111_ID) {
 		__sa1111_remove(sachip);
-		platform_set_drvdata(dev, NULL);
+		platform_set_drvdata(pdev, NULL);
 		kfree(save);
 		return 0;
 	}
@@ -1005,9 +1006,7 @@ static int sa1111_resume(struct platform_device *dev)
 	return 0;
 }
 
-#else
-#define sa1111_suspend NULL
-#define sa1111_resume  NULL
+static SIMPLE_DEV_PM_OPS(sa1111_dev_pm_ops, sa1111_suspend, sa1111_resume);
 #endif
 
 static int sa1111_probe(struct platform_device *pdev)
@@ -1030,7 +1029,7 @@ static int sa1111_remove(struct platform_device *pdev)
 	struct sa1111 *sachip = platform_get_drvdata(pdev);
 
 	if (sachip) {
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 		kfree(sachip->saved_state);
 		sachip->saved_state = NULL;
 #endif
@@ -1053,11 +1052,12 @@ static int sa1111_remove(struct platform_device *pdev)
 static struct platform_driver sa1111_device_driver = {
 	.probe		= sa1111_probe,
 	.remove		= sa1111_remove,
-	.suspend	= sa1111_suspend,
-	.resume		= sa1111_resume,
 	.driver		= {
 		.name	= "sa1111",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM_SLEEP
+		.pm = &sa1111_dev_pm_ops,
+#endif
 	},
 };
 
@@ -1297,14 +1297,15 @@ static int sa1111_match(struct device *_dev, struct device_driver *_drv)
 	return dev->devid & drv->devid;
 }
 
-static int sa1111_bus_suspend(struct device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int sa1111_bus_suspend(struct device *dev)
 {
 	struct sa1111_dev *sadev = SA1111_DEV(dev);
 	struct sa1111_driver *drv = SA1111_DRV(dev->driver);
 	int ret = 0;
 
 	if (drv && drv->suspend)
-		ret = drv->suspend(sadev, state);
+		ret = drv->suspend(sadev, PMSG_SUSPEND);
 	return ret;
 }
 
@@ -1318,6 +1319,9 @@ static int sa1111_bus_resume(struct device *dev)
 		ret = drv->resume(sadev);
 	return ret;
 }
+static SIMPLE_DEV_PM_OPS(sa1111_bus_dev_pm_ops, sa1111_bus_suspend,
+			 sa1111_bus_resume);
+#endif
 
 static void sa1111_bus_shutdown(struct device *dev)
 {
@@ -1354,8 +1358,9 @@ struct bus_type sa1111_bus_type = {
 	.match		= sa1111_match,
 	.probe		= sa1111_bus_probe,
 	.remove		= sa1111_bus_remove,
-	.suspend	= sa1111_bus_suspend,
-	.resume		= sa1111_bus_resume,
+#ifdef CONFIG_PM_SLEEP
+	.pm		= &sa1111_bus_dev_pm_ops,
+#endif
 	.shutdown	= sa1111_bus_shutdown,
 };
 EXPORT_SYMBOL(sa1111_bus_type);
-- 
1.7.10.4

