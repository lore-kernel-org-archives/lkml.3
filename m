Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaHVJu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:50:29 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59295 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaHVJu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:50:26 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC 2/2] usb: otg: Temporarily hold wakeupsource on charger and  disconnect events
Date: Fri, 22 Aug 2014 15:20:00 +0530
Message-Id: <1408701000-8555-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: otg: Temporarily hold wakeupsource on charger and disconnect events

Allow other parts of the system to react to the charger connect/disconnect
event without allowing the system to suspend before the other parts can process
the event. This wakeup_source times out after 2 seconds; if nobody else holds a
wakeup_source by that time then the device can sleep.

This patch also refactoras the logic of wakeupsource_init,otg_notifications and
handle event funtions

This is one of the number of patches from the Android AOSP tegra.git tree,
which is used on Android devices. so I wanted to submit it for
review to see if it should go upstream.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
[kiran: Added context to commit message]
---
 drivers/usb/phy/otg-wakeupsource.c | 108 ++++++++++++++-----------------------
 include/linux/usb/otg.h            |   2 +
 2 files changed, 41 insertions(+), 69 deletions(-)

diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
index fa44e11..d2c16b8 100644
--- a/drivers/usb/phy/otg-wakeupsource.c
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -39,21 +39,25 @@ struct otgws_lock {
 };
 
 /*
- * VBUS present lock.
++ * VBUS present lock.  Also used as a timed lock on charger
++ * connect/disconnect and USB host disconnect, to allow the system
++ * to react to the change in power.
  */
 
 static struct otgws_lock vbus_lock;
 
-static int otgws_otg_notifications(struct notifier_block *nb,
-				   unsigned long event, void *unused)
+static void otgws_handle_event(unsigned long event)
 {
 	unsigned long irqflags;
 
-	if (!enabled)
-		return NOTIFY_OK;
-
 	spin_lock_irqsave(&otgws_spinlock, irqflags);
 
+	if (!enabled) {
+		__pm_relax(&vbus_lock.wsource);
+		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
+		return;
+	}
+
 	switch (event) {
 	case USB_EVENT_VBUS:
 	case USB_EVENT_ENUMERATED:
@@ -63,7 +67,8 @@ static int otgws_otg_notifications(struct notifier_block *nb,
 	case USB_EVENT_NONE:
 	case USB_EVENT_ID:
 	case USB_EVENT_CHARGER:
-		__pm_relax(&vbus_lock.wsource);
+	__pm_wakeup_event(&vbus_lock.wsource,
+		msecs_to_jiffies(TEMPORARY_HOLD_TIME));
 		break;
 
 	default:
@@ -71,72 +76,25 @@ static int otgws_otg_notifications(struct notifier_block *nb,
 	}
 
 	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
-	return NOTIFY_OK;
-}
-
-static void sync_with_xceiv_state(void)
-{
-	if ((otgws_xceiv->last_event == USB_EVENT_VBUS) ||
-	    (otgws_xceiv->last_event == USB_EVENT_ENUMERATED))
-		__pm_stay_awake(&vbus_lock.wsource);
-	else
-		__pm_relax(&vbus_lock.wsource);
 }
 
-static int init_for_xceiv(void)
+static int otgws_otg_notifications(struct notifier_block *nb,
+				unsigned long event, void *unused)
 {
-	int rv;
-	struct usb_phy *phy;
-
-	if (!otgws_xceiv) {
-		phy = usb_get_phy(USB_PHY_TYPE_USB2);
-
-		if (IS_ERR(phy)) {
-			pr_err("%s: No USB transceiver found\n", __func__);
-			return PTR_ERR(phy);
-		}
-		otgws_xceiv = phy;
-
-		snprintf(vbus_lock.name, sizeof(vbus_lock.name), "vbus-%s",
-			 dev_name(otgws_xceiv->dev));
-		wakeup_source_init(&vbus_lock.wsource, vbus_lock.name);
-
-		rv = usb_register_notifier(otgws_xceiv, &otgws_nb);
-
-		if (rv) {
-			pr_err("%s: usb_register_notifier on transceiver %s
-				failed\n", __func__,
-			       dev_name(otgws_xceiv->dev));
-			otgws_xceiv = NULL;
-			wakeup_source_trash(&vbus_lock.wsource);
-			return rv;
-		}
-	}
-
-	return 0;
+	otgws_handle_event(event);
+	return NOTIFY_OK;
 }
 
 static int set_enabled(const char *val, const struct kernel_param *kp)
 {
-	unsigned long irqflags;
 	int rv = param_set_bool(val, kp);
 
 	if (rv)
 		return rv;
 
-	rv = init_for_xceiv();
-
-	if (rv)
-		return rv;
-
-	spin_lock_irqsave(&otgws_spinlock, irqflags);
-
-	if (enabled)
-		sync_with_xceiv_state();
-	else
-		__pm_relax(&vbus_lock.wsource);
+	if (otgws_xceiv)
+		otgws_handle_event(otgws_xceiv->last_event);
 
-	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
 	return 0;
 }
 
@@ -150,19 +108,31 @@ MODULE_PARM_DESC(enabled, "enable wakelock when VBUS present");
 
 static int __init otg_wakeupsource_init(void)
 {
-	unsigned long irqflags;
+	int ret;
+	struct usb_phy *phy;
 
-	otgws_nb.notifier_call = otgws_otg_notifications;
+	phy = usb_get_phy(USB_PHY_TYPE_USB2);
 
-	if (!init_for_xceiv()) {
-		spin_lock_irqsave(&otgws_spinlock, irqflags);
+	if (IS_ERR(phy)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return PTR_ERR(phy);
+	}
 
-		if (enabled)
-			sync_with_xceiv_state();
+	otgws_xceiv = phy;
 
-		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
-	} else {
-		enabled = false;
+	snprintf(vbus_lock.name, sizeof(vbus_lock.name), "vbus-%s",
+		dev_name(otgws_xceiv->dev));
+	wakeup_source_init(&vbus_lock.wsource, vbus_lock.name);
+
+	otgws_nb.notifier_call = otgws_otg_notifications;
+	ret = usb_register_notifier(otgws_xceiv, &otgws_nb);
+
+	if (ret) {
+		pr_err("%s: usb_register_notifier on transceiver %s failed\n",
+			 __func__, dev_name(otgws_xceiv->dev));
+		otgws_xceiv = NULL;
+		wakeup_source_trash(&vbus_lock.wsource);
+		return ret;
 	}
 
 	return 0;
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 154332b..4243747 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -11,6 +11,8 @@
 
 #include <linux/usb/phy.h>
 
+#define TEMPORARY_HOLD_TIME    2000
+
 struct usb_otg {
 	u8			default_a;
 
-- 
1.8.2.1

