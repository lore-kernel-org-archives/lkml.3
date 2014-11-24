Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaKXR1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:27:37 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38190 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaKXR1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:27:34 -0500
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Kiran Raparthy <kiran.kumar@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
Date: Mon, 24 Nov 2014 22:55:00 +0530
Message-Id: <1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
References: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: phy: hold wakeupsource when USB is enumerated in peripheral mode

Some systems require a mechanism to prevent system to enter into suspend
state when USB is connected and enumerated in peripheral mode.

This patch provides an interface to hold a wakeupsource to prevent suspend.
PHY drivers can use this interface when USB is connected and enumerated in
peripheral mode.

A timed wakeupsource is temporarily held on USB disconnect events, to allow
the rest of the system to react to the USB disconnection (dropping host
sessions, updating charger status, etc.) prior to re-allowing suspend.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Benoit Goby <benoit@android.com>
[Original patch in Android from Todd]
Cc: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 drivers/usb/phy/phy.c   | 29 +++++++++++++++++++++++++++--
 include/linux/usb/phy.h |  5 +++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index b4066a0..8c87bc3 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -331,6 +331,7 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
 	int		ret = 0;
 	unsigned long	flags;
 	struct usb_phy	*phy;
+	char wsource_name[40];
 
 	if (x->type != USB_PHY_TYPE_UNDEFINED) {
 		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
@@ -353,6 +354,10 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
 	x->type = type;
 	list_add_tail(&x->head, &phy_list);
 
+	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
+		dev_name(x->dev));
+	wakeup_source_init(&x->wsource, wsource_name);
+
 out:
 	spin_unlock_irqrestore(&phy_lock, flags);
 	return ret;
@@ -404,6 +409,7 @@ void usb_remove_phy(struct usb_phy *x)
 
 	spin_lock_irqsave(&phy_lock, flags);
 	if (x) {
+		wakeup_source_trash(&x->wsource);
 		list_for_each_entry(phy_bind, &phy_bind_list, list)
 			if (phy_bind->phy == x)
 				phy_bind->phy = NULL;
@@ -448,13 +454,32 @@ int usb_bind_phy(const char *dev_name, u8 index,
 EXPORT_SYMBOL_GPL(usb_bind_phy);
 
 /**
- * usb_phy_set_event - set event to phy event
+ * usb_phy_set_event - set event to phy event and
+ * hold/temporarily hold wakeupsource
  * @x: the phy returned by usb_get_phy();
  *
- * This sets event to phy event
+ * This holds per-PHY wakeupsource/timed wakeupsource
  */
 void usb_phy_set_event(struct usb_phy *x, unsigned long event)
 {
+
 	x->last_event = event;
+
+	switch (event) {
+	case USB_EVENT_ENUMERATED:
+		__pm_stay_awake(&x->wsource);
+		break;
+
+	case USB_EVENT_NONE:
+	case USB_EVENT_ID:
+	case USB_EVENT_VBUS:
+	case USB_EVENT_CHARGER:
+		__pm_wakeup_event(&x->wsource,
+				  USB_PHY_DEFAULT_WAKEUP_SRC_TIMEOUT);
+		break;
+
+	default:
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(usb_phy_set_event);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index f499c23..63a56bf 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -12,6 +12,8 @@
 #include <linux/notifier.h>
 #include <linux/usb.h>
 
+#define USB_PHY_DEFAULT_WAKEUP_SRC_TIMEOUT	msecs_to_jiffies(2000)
+
 enum usb_phy_interface {
 	USBPHY_INTERFACE_MODE_UNKNOWN,
 	USBPHY_INTERFACE_MODE_UTMI,
@@ -88,6 +90,9 @@ struct usb_phy {
 	/* for notification of usb_phy_events */
 	struct atomic_notifier_head	notifier;
 
+	/* wakeup source */
+	struct wakeup_source    wsource;
+
 	/* to pass extra port status to the root hub */
 	u16			port_status;
 	u16			port_change;
-- 
1.9.1

