Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3LRNWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:22:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48046 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab3LRNWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:22:14 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: phy: am335x: Enable USB remote wakeup using PHY wakeup
Date: Wed, 18 Dec 2013 18:52:09 +0530
Message-ID: <1387372929-18629-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB remote wakeup using PHY wakeup is supported only in standby mode.
Enabling the PHY_WKUP will break DS0 mode of system suspend.
If the same is enabled while entering DS0, AM33xx never stays in DS0,
it returns immediately from DS0. By default make the PHY wakeup
disabled, using sysfs entry enable the same manually to get
the remote wakeup working from standby.

echo enabled > /sys/bus/platform/device/<usb phy id>/power/wakeup
This will enable the PHY wakeup while going to standby.

PHY wakeup feature is required to wakeup  the system from standby
state. Since AM33xx has a bug in which PHY wakeup should not
be enabled while entering DS0, disable the same by default.
A user wishing to use USB wakeup from standby mode need to enable
the same using the sysfs entries.

Also remove am335x_phy_runtime_(suspend/resume) this driver doesnot really
enable/disable the clocks to the PHY.
Add am335x_phy_(suspend/resume) and use the same for enabling the PHY_WKUP.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/phy/phy-am335x.c | 46 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 6370e50..3f78eaf 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -64,6 +64,19 @@ static int am335x_phy_probe(struct platform_device *pdev)
 	am_phy->usb_phy_gen.phy.shutdown = am335x_shutdown;
 
 	platform_set_drvdata(pdev, am_phy);
+	device_init_wakeup(dev, true);
+
+	/*
+	 * If we leave PHY wakeup enabled then AM33XX wakes up
+	 * immediately from DS0. To avoid this we mark dev->power.can_wakeup
+	 * to false. The same is checked in suspend routine to decide
+	 * on whether to enable PHY wakeup or not.
+	 * PHY wakeup works fine in standby mode, there by allowing us to
+	 * handle remote wakeup, wakeup on disconnect and connect.
+	 */
+
+	device_set_wakeup_enable(dev, false);
+	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
 
 	return 0;
 
@@ -78,40 +91,51 @@ static int am335x_phy_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
-
-static int am335x_phy_runtime_suspend(struct device *dev)
+#ifdef CONFIG_PM_SLEEP
+static int am335x_phy_suspend(struct device *dev)
 {
 	struct platform_device	*pdev = to_platform_device(dev);
 	struct am335x_phy *am_phy = platform_get_drvdata(pdev);
 
+	/*
+	 * Enable phy wakeup only if dev->power.can_wakeup is true.
+	 * Make sure to enable wakeup to support remote wakeup	in
+	 * standby mode ( same is not supported in OFF(DS0) mode).
+	 * Enable it by doing
+	 * echo enabled > /sys/bus/platform/devices/<usb-phy-id>/power/wakeup
+	 */
+
 	if (device_may_wakeup(dev))
 		phy_ctrl_wkup(am_phy->phy_ctrl, am_phy->id, true);
+
 	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
+
 	return 0;
 }
 
-static int am335x_phy_runtime_resume(struct device *dev)
+static int am335x_phy_resume(struct device *dev)
 {
 	struct platform_device	*pdev = to_platform_device(dev);
 	struct am335x_phy	*am_phy = platform_get_drvdata(pdev);
 
 	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, true);
+
 	if (device_may_wakeup(dev))
 		phy_ctrl_wkup(am_phy->phy_ctrl, am_phy->id, false);
+
 	return 0;
 }
+#define DEV_PM_OPS     (&am335x_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
 
 static const struct dev_pm_ops am335x_pm_ops = {
-	SET_RUNTIME_PM_OPS(am335x_phy_runtime_suspend,
-			am335x_phy_runtime_resume, NULL)
+	.suspend = am335x_phy_suspend,
+	.resume = am335x_phy_resume,
 };
 
-#define DEV_PM_OPS	(&am335x_pm_ops)
-#else
-#define DEV_PM_OPS	NULL
-#endif
-
 static const struct of_device_id am335x_phy_ids[] = {
 	{ .compatible = "ti,am335x-usb-phy" },
 	{ }
-- 
1.8.1

