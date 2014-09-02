Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaIBLtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:49:51 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42469 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaIBLtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:49:50 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v2 2/2] usb: phy: Temporarily hold wakeupsource on charger connect and disconnect events
Date: Tue,  2 Sep 2014 17:19:18 +0530
Message-Id: <1409658558-12318-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: phy: Temporarily hold wakeupsource on charger connect and disconnect
events

Allow other parts of the system to react to the charger connect/disconnect
event without allowing the system to suspend before the other parts can process
the event. This wakeup_source times out after 2 seconds; if nobody else holds a
wakeup_source by that time then the device can sleep.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message
	wakeupsource handling implemented per PHY in phy core]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 drivers/usb/phy/otg-wakeupsource.c |  2 +-
 drivers/usb/phy/phy.c              | 10 ++++++++++
 include/linux/usb/phy.h            |  3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
index fca2010..70fa05e 100644
--- a/drivers/usb/phy/otg-wakeupsource.c
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -48,7 +48,7 @@ static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned long event)
 	case USB_EVENT_NONE:
 	case USB_EVENT_ID:
 	case USB_EVENT_CHARGER:
-		usb_drop_wsource(otgws_xceiv);
+		usb_temporary_hold_wsource(otgws_xceiv);
 		break;
 
 	default:
diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 659b1e8..c488716 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -483,3 +483,13 @@ void usb_drop_wsource(struct usb_phy *x)
 	__pm_relax(&x->wsource);
 }
 EXPORT_SYMBOL_GPL(usb_drop_wsource);
+
+/**
+ * usb_temporary_hold_wsource - temporarily hold wakeupsource
+ * @usb_phy: the phy returned by usb_get_phy()
+ */
+void usb_temporary_hold_wsource(struct usb_phy *x)
+{
+	__pm_wakeup_event(&x->wsource, msecs_to_jiffies(TEMPORARY_HOLD_TIME));
+}
+EXPORT_SYMBOL_GPL(usb_temporary_hold_wsource);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 6c680e6..5f9b70e 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -13,6 +13,8 @@
 #include <linux/usb.h>
 #include <linux/pm_wakeup.h>
 
+#define TEMPORARY_HOLD_TIME    2000
+
 enum usb_phy_interface {
 	USBPHY_INTERFACE_MODE_UNKNOWN,
 	USBPHY_INTERFACE_MODE_UTMI,
@@ -218,6 +220,7 @@ void usb_wsource_init(struct usb_phy *x, char *phy_dev_name);
 void usb_wsource_trash(struct usb_phy *x);
 void usb_grab_wsource(struct usb_phy *x);
 void usb_drop_wsource(struct usb_phy *x);
+void usb_temporary_hold_wsource(struct usb_phy *x);
 #else
 static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
 {
-- 
1.8.2.1

