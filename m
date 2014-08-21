Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaHUQnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:43:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53641 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbaHUQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:43:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18W8pmh/zLJx4X5Pwd62TaX
Date: Thu, 21 Aug 2014 09:43:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH] usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
Message-ID: <20140821164346.GA10066@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 30a70b026b4cd ("usb: musb: fix obex in g_nokia.ko causing kernel
panic") attempted to fix runtime PM handling for PHYs that are on the
I2C bus. Commit 3063a12be2b0 (usb: musb: fix PHY power on/off) then
changed things around to enable of PHYs that rely on runtime PM.

These changes however broke idling of the PHY and causes at least
100 mW extra power consumption on omaps, which is a lot with
the idle power consumption being below 10 mW range on many devices.

As calling phy_power_on/off from runtime PM calls in the USB
causes complicated issues with I2C connected PHYs, let's just let
the PHY do it's own runtime PM as needed. This leaves out the
dependency between PHYs and USB controller drivers for runtime
PM.

Let's fix the regression for twl4030-usb by adding minimal runtime
PM support. This allows idling the PHY on disconnect.

Note that we are changing to use standard runtime PM handling
for twl4030_phy_init() as that function just checks the state
and does not initialize the PHY. The PHY won't get initialized
until in twl4030_phy_power_on().

Fixes: 30a70b026b4cd ("usb: musb: fix obex in g_nokia.ko causing kernel panic")
Fixes: 3063a12be2b0 ("usb: musb: fix PHY power on/off")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Kishon, this regression fix would be nice to get into the v3.17-rc
series if no objections. If you don't have other fixes, I can also
queue via arm-soc with proper acks.

It probably does not make sense to try to fix this without using
runtime PM without complicating the code further.

--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/usb/otg.h>
 #include <linux/phy/phy.h>
+#include <linux/pm_runtime.h>
 #include <linux/usb/musb-omap.h>
 #include <linux/usb/ulpi.h>
 #include <linux/i2c/twl.h>
@@ -422,37 +423,55 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 	}
 }
 
-static int twl4030_phy_power_off(struct phy *phy)
+static int twl4030_usb_runtime_suspend(struct device *dev)
 {
-	struct twl4030_usb *twl = phy_get_drvdata(phy);
+	struct twl4030_usb *twl = dev_get_drvdata(dev);
 
+	dev_dbg(twl->dev, "%s\n", __func__);
 	if (twl->asleep)
 		return 0;
 
 	twl4030_phy_power(twl, 0);
 	twl->asleep = 1;
-	dev_dbg(twl->dev, "%s\n", __func__);
+
 	return 0;
 }
 
-static void __twl4030_phy_power_on(struct twl4030_usb *twl)
+static int twl4030_usb_runtime_resume(struct device *dev)
 {
+	struct twl4030_usb *twl = dev_get_drvdata(dev);
+
+	dev_dbg(twl->dev, "%s\n", __func__);
+	if (!twl->asleep)
+		return 0;
+
 	twl4030_phy_power(twl, 1);
-	twl4030_i2c_access(twl, 1);
-	twl4030_usb_set_mode(twl, twl->usb_mode);
-	if (twl->usb_mode == T2_USB_MODE_ULPI)
-		twl4030_i2c_access(twl, 0);
+	twl->asleep = 0;
+
+	return 0;
+}
+
+static int twl4030_phy_power_off(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	dev_dbg(twl->dev, "%s\n", __func__);
+	pm_runtime_mark_last_busy(twl->dev);
+	pm_runtime_put_autosuspend(twl->dev);
+
+	return 0;
 }
 
 static int twl4030_phy_power_on(struct phy *phy)
 {
 	struct twl4030_usb *twl = phy_get_drvdata(phy);
 
-	if (!twl->asleep)
-		return 0;
-	__twl4030_phy_power_on(twl);
-	twl->asleep = 0;
 	dev_dbg(twl->dev, "%s\n", __func__);
+	pm_runtime_get_sync(twl->dev);
+	twl4030_i2c_access(twl, 1);
+	twl4030_usb_set_mode(twl, twl->usb_mode);
+	if (twl->usb_mode == T2_USB_MODE_ULPI)
+		twl4030_i2c_access(twl, 0);
 
 	/*
 	 * XXX When VBUS gets driven after musb goes to A mode,
@@ -558,6 +577,16 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		 * USB_LINK_VBUS state.  musb_hdrc won't care until it
 		 * starts to handle softconnect right.
 		 */
+		if ((status == OMAP_MUSB_VBUS_VALID) ||
+		    (status == OMAP_MUSB_ID_GROUND)) {
+			if (twl->asleep)
+				pm_runtime_get_sync(twl->dev);
+		} else {
+			if (!twl->asleep) {
+				pm_runtime_mark_last_busy(twl->dev);
+				pm_runtime_put_autosuspend(twl->dev);
+			}
+		}
 		omap_musb_mailbox(status);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
@@ -599,22 +628,17 @@ static int twl4030_phy_init(struct phy *phy)
 	struct twl4030_usb *twl = phy_get_drvdata(phy);
 	enum omap_musb_vbus_id_status status;
 
-	/*
-	 * Start in sleep state, we'll get called through set_suspend()
-	 * callback when musb is runtime resumed and it's time to start.
-	 */
-	__twl4030_phy_power(twl, 0);
-	twl->asleep = 1;
-
+	pm_runtime_get_sync(twl->dev);
 	status = twl4030_usb_linkstat(twl);
 	twl->linkstat = status;
 
-	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID) {
+	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID)
 		omap_musb_mailbox(twl->linkstat);
-		twl4030_phy_power_on(phy);
-	}
 
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
+	pm_runtime_mark_last_busy(twl->dev);
+	pm_runtime_put_autosuspend(twl->dev);
+
 	return 0;
 }
 
@@ -650,6 +674,11 @@ static const struct phy_ops ops = {
 	.owner		= THIS_MODULE,
 };
 
+static const struct dev_pm_ops twl4030_usb_pm_ops = {
+	SET_RUNTIME_PM_OPS(twl4030_usb_runtime_suspend,
+			   twl4030_usb_runtime_resume, NULL)
+};
+
 static int twl4030_usb_probe(struct platform_device *pdev)
 {
 	struct twl4030_usb_data *pdata = dev_get_platdata(&pdev->dev);
@@ -726,6 +755,11 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
 
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 2000);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	/* Our job is to use irqs and status from the power module
 	 * to keep the transceiver disabled when nothing's connected.
 	 *
@@ -744,6 +778,9 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 		return status;
 	}
 
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put(&pdev->dev);
+
 	dev_info(&pdev->dev, "Initialized TWL4030 USB module\n");
 	return 0;
 }
@@ -753,6 +790,7 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 	struct twl4030_usb *twl = platform_get_drvdata(pdev);
 	int val;
 
+	pm_runtime_get_sync(twl->dev);
 	cancel_delayed_work(&twl->id_workaround_work);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 
@@ -772,9 +810,8 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 
 	/* disable complete OTG block */
 	twl4030_usb_clear_bits(twl, POWER_CTRL, POWER_CTRL_OTG_ENAB);
-
-	if (!twl->asleep)
-		twl4030_phy_power(twl, 0);
+	pm_runtime_mark_last_busy(twl->dev);
+	pm_runtime_put(twl->dev);
 
 	return 0;
 }
@@ -792,6 +829,7 @@ static struct platform_driver twl4030_usb_driver = {
 	.remove		= twl4030_usb_remove,
 	.driver		= {
 		.name	= "twl4030_usb",
+		.pm	= &twl4030_usb_pm_ops,
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(twl4030_usb_id_table),
 	},
