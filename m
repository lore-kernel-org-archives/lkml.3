Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaBJQMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:12:52 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:48168
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbaBJQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:42 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, linux@arm.linux.org.uk
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shuahkhan@gmail.com
Subject: [RFT][PATCH 02/12] arm: change sa1111 platform and bus power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:25 -0700
Message-Id: <9946f14a5837560d5aa83bf3501685365a1aa759.1392040067.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sa1111 platform and bus drivers to register pm ops using dev_pm_ops
instead of legacy pm_ops. .pm hooks call existing legacy suspend and resume
interfaces by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 arch/arm/common/sa1111.c |   88 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 16 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index e57d7e5..db017b2 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -872,7 +872,7 @@ struct sa1111_save_data {
 
 #ifdef CONFIG_PM
 
-static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
+static int __sa1111_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct sa1111 *sachip = platform_get_drvdata(dev);
 	struct sa1111_save_data *save;
@@ -928,6 +928,21 @@ static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
+static int sa1111_suspend(struct device *dev)
+{
+	return __sa1111_suspend(to_platform_device(dev), PMSG_SUSPEND);
+}
+
+static int sa1111_freeze(struct device *dev)
+{
+	return __sa1111_suspend(to_platform_device(dev), PMSG_FREEZE);
+}
+
+static int sa1111_poweroff(struct device *dev)
+{
+	return __sa1111_suspend(to_platform_device(dev), PMSG_HIBERNATE);
+}
+
 /*
  *	sa1111_resume - Restore the SA1111 device state.
  *	@dev: device to restore
@@ -937,7 +952,7 @@ static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
  *	restored by their respective drivers, and must be called
  *	via LDM after this function.
  */
-static int sa1111_resume(struct platform_device *dev)
+static int __sa1111_resume(struct platform_device *dev)
 {
 	struct sa1111 *sachip = platform_get_drvdata(dev);
 	struct sa1111_save_data *save;
@@ -1005,9 +1020,10 @@ static int sa1111_resume(struct platform_device *dev)
 	return 0;
 }
 
-#else
-#define sa1111_suspend NULL
-#define sa1111_resume  NULL
+static int sa1111_resume(struct device *dev)
+{
+	return __sa1111_resume(to_platform_device(dev));
+}
 #endif
 
 static int sa1111_probe(struct platform_device *pdev)
@@ -1041,6 +1057,18 @@ static int sa1111_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops sa1111_dev_pm_ops = {
+	.suspend = sa1111_suspend,
+	.resume = sa1111_resume,
+	/* Hibernate hooks */
+	.freeze = sa1111_freeze,
+	.thaw = sa1111_resume,
+	.poweroff = sa1111_poweroff,
+	.restore = sa1111_resume,
+};
+#endif
+
 /*
  *	Not sure if this should be on the system bus or not yet.
  *	We really want some way to register a system device at
@@ -1053,11 +1081,12 @@ static int sa1111_remove(struct platform_device *pdev)
 static struct platform_driver sa1111_device_driver = {
 	.probe		= sa1111_probe,
 	.remove		= sa1111_remove,
-	.suspend	= sa1111_suspend,
-	.resume		= sa1111_resume,
 	.driver		= {
 		.name	= "sa1111",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &sa1111_dev_pm_ops,
+#endif
 	},
 };
 
@@ -1297,26 +1326,44 @@ static int sa1111_match(struct device *_dev, struct device_driver *_drv)
 	return dev->devid & drv->devid;
 }
 
-static int sa1111_bus_suspend(struct device *dev, pm_message_t state)
+static int __sa1111_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct sa1111_dev *sadev = SA1111_DEV(dev);
 	struct sa1111_driver *drv = SA1111_DRV(dev->driver);
-	int ret = 0;
+
+	if (drv && drv->drv.pm && drv->drv.pm->suspend)
+		return  drv->drv.pm->suspend(dev);
 
 	if (drv && drv->suspend)
-		ret = drv->suspend(sadev, state);
-	return ret;
+		return drv->suspend(sadev, state);
+	return 0;
+}
+
+static int sa1111_bus_suspend(struct device *dev)
+{
+	return __sa1111_bus_suspend(dev, PMSG_SUSPEND);
+}
+
+static int sa1111_bus_freeze(struct device *dev)
+{
+	return __sa1111_bus_suspend(dev, PMSG_FREEZE);
+}
+
+static int sa1111_bus_poweroff(struct device *dev)
+{
+	return __sa1111_bus_suspend(dev, PMSG_HIBERNATE);
 }
 
 static int sa1111_bus_resume(struct device *dev)
 {
 	struct sa1111_dev *sadev = SA1111_DEV(dev);
 	struct sa1111_driver *drv = SA1111_DRV(dev->driver);
-	int ret = 0;
 
+	if (drv && drv->drv.pm && drv->drv.pm->resume)
+		return  drv->drv.pm->resume(dev);
 	if (drv && drv->resume)
-		ret = drv->resume(sadev);
-	return ret;
+		return drv->resume(sadev);
+	return 0;
 }
 
 static void sa1111_bus_shutdown(struct device *dev)
@@ -1349,14 +1396,23 @@ static int sa1111_bus_remove(struct device *dev)
 	return ret;
 }
 
+static const struct dev_pm_ops sa1111_bus_dev_pm_ops = {
+	.suspend = sa1111_bus_suspend,
+	.resume = sa1111_bus_resume,
+	/* Hibernate hooks */
+	.freeze = sa1111_bus_freeze,
+	.thaw = sa1111_bus_resume,
+	.poweroff = sa1111_bus_poweroff,
+	.restore = sa1111_bus_resume,
+};
+
 struct bus_type sa1111_bus_type = {
 	.name		= "sa1111-rab",
 	.match		= sa1111_match,
 	.probe		= sa1111_bus_probe,
 	.remove		= sa1111_bus_remove,
-	.suspend	= sa1111_bus_suspend,
-	.resume		= sa1111_bus_resume,
 	.shutdown	= sa1111_bus_shutdown,
+	.pm		= &sa1111_bus_dev_pm_ops,
 };
 EXPORT_SYMBOL(sa1111_bus_type);
 
-- 
1.7.10.4

