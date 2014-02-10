Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaBJQMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:12:46 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:39129
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbaBJQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:42 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, linux@arm.linux.org.uk
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shuahkhan@gmail.com
Subject: [RFT][PATCH 01/12] arm: change locomo platform and bus power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:24 -0700
Message-Id: <7483e110cf0e8938e4df73dbf7f9e8da1315e9af.1392040066.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change locomo platform and bus drivers to register pm ops using dev_pm_ops
instead of legacy pm_ops. .pm hooks call existing legacy suspend and resume
interfaces by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 arch/arm/common/locomo.c |   93 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 15 deletions(-)

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index b55c362..a48effb 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -272,7 +272,7 @@ struct locomo_save_data {
 	u16	LCM_SPIMD;
 };
 
-static int locomo_suspend(struct platform_device *dev, pm_message_t state)
+static int __locomo_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
 	struct locomo_save_data *save;
@@ -316,7 +316,22 @@ static int locomo_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int locomo_resume(struct platform_device *dev)
+static int locomo_suspend(struct device *dev)
+{
+	 return __locomo_suspend(to_platform_device(dev), PMSG_SUSPEND);
+}
+
+static int locomo_freeze(struct device *dev)
+{
+	 return __locomo_suspend(to_platform_device(dev), PMSG_FREEZE);
+}
+
+static int locomo_poweroff(struct device *dev)
+{
+	 return __locomo_suspend(to_platform_device(dev), PMSG_HIBERNATE);
+}
+
+static int __locomo_resume(struct platform_device *dev)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
 	struct locomo_save_data *save;
@@ -351,6 +366,11 @@ static int locomo_resume(struct platform_device *dev)
 
 	return 0;
 }
+
+static int locomo_resume(struct device *dev)
+{
+	 return __locomo_resume(to_platform_device(dev));
+}
 #endif
 
 
@@ -510,6 +530,18 @@ static int locomo_remove(struct platform_device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops locomo_dev_pm_ops = {
+	.suspend = locomo_suspend,
+	.resume = locomo_resume,
+	/* Hibernate hooks */
+	.freeze = locomo_freeze,
+	.thaw = locomo_resume,
+	.poweroff = locomo_poweroff,
+	.restore = locomo_resume,
+};
+#endif
+
 /*
  *	Not sure if this should be on the system bus or not yet.
  *	We really want some way to register a system device at
@@ -519,12 +551,11 @@ static int locomo_remove(struct platform_device *dev)
 static struct platform_driver locomo_device_driver = {
 	.probe		= locomo_probe,
 	.remove		= locomo_remove,
-#ifdef CONFIG_PM
-	.suspend	= locomo_suspend,
-	.resume		= locomo_resume,
-#endif
 	.driver		= {
 		.name	= "locomo",
+#ifdef CONFIG_PM
+		.pm	= &locomo_dev_pm_ops,
+#endif
 	},
 };
 
@@ -826,26 +857,45 @@ static int locomo_match(struct device *_dev, struct device_driver *_drv)
 	return dev->devid == drv->devid;
 }
 
-static int locomo_bus_suspend(struct device *dev, pm_message_t state)
+static int __locomo_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct locomo_dev *ldev = LOCOMO_DEV(dev);
 	struct locomo_driver *drv = LOCOMO_DRV(dev->driver);
-	int ret = 0;
+
+	if (drv && drv->drv.pm && drv->drv.pm->suspend)
+		return  drv->drv.pm->suspend(dev);
 
 	if (drv && drv->suspend)
-		ret = drv->suspend(ldev, state);
-	return ret;
+		return	drv->suspend(ldev, state);
+	return 0;
+}
+
+static int locomo_bus_suspend(struct device *dev)
+{
+	return	__locomo_bus_suspend(dev, PMSG_SUSPEND);
+}
+
+static int locomo_bus_freeze(struct device *dev)
+{
+	return	__locomo_bus_suspend(dev, PMSG_FREEZE);
+}
+
+static int locomo_bus_poweroff(struct device *dev)
+{
+	return	__locomo_bus_suspend(dev, PMSG_HIBERNATE);
 }
 
 static int locomo_bus_resume(struct device *dev)
 {
 	struct locomo_dev *ldev = LOCOMO_DEV(dev);
 	struct locomo_driver *drv = LOCOMO_DRV(dev->driver);
-	int ret = 0;
+
+	if (drv && drv->drv.pm && drv->drv.pm->resume)
+		return	drv->drv.pm->resume(dev);
 
 	if (drv && drv->resume)
-		ret = drv->resume(ldev);
-	return ret;
+		return	drv->resume(ldev);
+	return 0;
 }
 
 static int locomo_bus_probe(struct device *dev)
@@ -870,13 +920,26 @@ static int locomo_bus_remove(struct device *dev)
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops locomo_bus_dev_pm_ops = {
+	.suspend = locomo_bus_suspend,
+	.resume = locomo_bus_resume,
+	/* Hibernate hooks */
+	.freeze = locomo_bus_freeze,
+	.thaw = locomo_bus_resume,
+	.poweroff = locomo_bus_poweroff,
+	.restore = locomo_bus_resume,
+};
+#endif
+
 struct bus_type locomo_bus_type = {
 	.name		= "locomo-bus",
 	.match		= locomo_match,
 	.probe		= locomo_bus_probe,
 	.remove		= locomo_bus_remove,
-	.suspend	= locomo_bus_suspend,
-	.resume		= locomo_bus_resume,
+#ifdef CONFIG_PM
+	.pm		= &locomo_bus_dev_pm_ops,
+#endif
 };
 
 int locomo_driver_register(struct locomo_driver *driver)
-- 
1.7.10.4

