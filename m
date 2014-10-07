Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaJGJQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:16:22 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38352 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaJGJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:16:17 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v4] usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
Date: Tue,  7 Oct 2014 14:45:44 +0530
Message-Id: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode

Purpose of this is to prevent the system to enter into suspend state from USB
peripheral traffic by hodling a wakeupsource when USB is connected and
enumerated in peripheral mode(say adb).

Temporarily hold a timed wakeup source on USB disconnect events, to allow
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
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message, squished build fixes
from Benoit Goby and Arve Hjønnevåg, changed wakelocks usage
to wakeupsource, merged Todd's refactoring logic and simplified
the structures and code and addressed community feedback]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
v4:
* Temporarily hold wakeupsource patch integrated into main patch.
* As per feedback,dropped "enabled" module parameter.
* Introduced otgws_otg_usb3_notifications function to handle event
  notifications from usb3 phy.
* Handled wakeupsource initialization,spinlock,registration of notifier block
  per-PHY.
* Updated usb_phy structure.

v3:
* As per the feedback,no global phy pointer used.
* called the one-liner wakeupsource handling calls
  directly instead of indirect functions implemented in v2.
* Removed indirect function get_phy_hook and used usb_get_phy
  to get the phy handle..

v2:
* wakeupsource handling implemeted per-PHY
* Implemented wakeupsource handling calls in phy
* included Todd's refactoring logic.

v1:
* changed to "disabled by default" from "enable by default".
* Kconfig help text modified
* Included better commit text
* otgws_nb moved to otg_wakeupsource_init function
* Introduced get_phy_hook to handle otgws_xceiv per-PHY

RFC:
* Included build fix from Benoit Goby and Arve Hjønnevåg
* Removed lock->held field in driver as this mechanism is
  provided in wakeupsource driver.
* wakelock(wl) terminology replaced with wakeup_source(ws).

 drivers/usb/phy/Kconfig            |   8 +++
 drivers/usb/phy/Makefile           |   1 +
 drivers/usb/phy/otg-wakeupsource.c | 134 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h            |   8 +++
 4 files changed, 151 insertions(+)
 create mode 100644 drivers/usb/phy/otg-wakeupsource.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index e253fa0..d9ddd85 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
 config USB_PHY
 	def_bool n
 
+config USB_OTG_WAKEUPSOURCE
+	bool "Hold wakeupsource when USB is enumerated in peripheral mode"
+	depends on PM_SLEEP
+	select USB_PHY
+	help
+	  Prevent the system going into automatic suspend while
+	  it is attached as a USB peripheral by holding a wakeupsource.
+
 #
 # USB Transceiver Drivers
 #
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 24a9133..ca2fbaf 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -3,6 +3,7 @@
 #
 obj-$(CONFIG_USB_PHY)			+= phy.o
 obj-$(CONFIG_OF)			+= of.o
+obj-$(CONFIG_USB_OTG_WAKEUPSOURCE)		+= otg-wakeupsource.o
 
 # transceiver drivers, keep the list sorted
 
diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
new file mode 100644
index 0000000..00d3359
--- /dev/null
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -0,0 +1,134 @@
+/*
+ * otg-wakeupsource.c
+ *
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/pm_wakeup.h>
+#include <linux/spinlock.h>
+#include <linux/usb/otg.h>
+
+static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned long event)
+{
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&otgws_xceiv->otgws_slock, irqflags);
+
+	switch (event) {
+	case USB_EVENT_VBUS:
+	case USB_EVENT_ENUMERATED:
+		__pm_stay_awake(&otgws_xceiv->wsource);
+		break;
+
+	case USB_EVENT_NONE:
+	case USB_EVENT_ID:
+	case USB_EVENT_CHARGER:
+		__pm_wakeup_event(&otgws_xceiv->wsource,
+				msecs_to_jiffies(TEMPORARY_HOLD_TIME));
+		break;
+
+	default:
+		break;
+	}
+
+	spin_unlock_irqrestore(&otgws_xceiv->otgws_slock, irqflags);
+}
+
+static int otgws_otg_usb2_notifications(struct notifier_block *nb,
+				unsigned long event, void *unused)
+{
+	static struct usb_phy *otgws_xceiv;
+
+	otgws_xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+
+	if (IS_ERR(otgws_xceiv)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return PTR_ERR(otgws_xceiv);
+	}
+
+	otgws_handle_event(otgws_xceiv, event);
+
+	return NOTIFY_OK;
+}
+
+static int otgws_otg_usb3_notifications(struct notifier_block *nb,
+				unsigned long event, void *unused)
+{
+	static struct usb_phy *otgws_xceiv;
+
+	otgws_xceiv = usb_get_phy(USB_PHY_TYPE_USB3);
+
+	if (IS_ERR(otgws_xceiv)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return PTR_ERR(otgws_xceiv);
+	}
+
+	otgws_handle_event(otgws_xceiv, event);
+
+	return NOTIFY_OK;
+}
+
+static int otg_wakeupsource_init(void)
+{
+	int ret_usb2;
+	int ret_usb3;
+	char wsource_name_usb2[40];
+	char wsource_name_usb3[40];
+	static struct usb_phy *otgws_xceiv_usb2;
+	static struct usb_phy *otgws_xceiv_usb3;
+
+	otgws_xceiv_usb2 = usb_get_phy(USB_PHY_TYPE_USB2);
+	otgws_xceiv_usb3 = usb_get_phy(USB_PHY_TYPE_USB3);
+
+	if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return PTR_ERR(otgws_xceiv_usb2);
+	}
+
+	spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
+	spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
+
+	snprintf(wsource_name_usb2, sizeof(wsource_name_usb2), "vbus-%s",
+		dev_name(otgws_xceiv_usb2->dev));
+	wakeup_source_init(&otgws_xceiv_usb2->wsource, wsource_name_usb2);
+
+	snprintf(wsource_name_usb3, sizeof(wsource_name_usb3), "vbus-%s",
+		dev_name(otgws_xceiv_usb3->dev));
+	wakeup_source_init(&otgws_xceiv_usb3->wsource, wsource_name_usb3);
+
+	otgws_xceiv_usb2->otgws_nb.notifier_call = otgws_otg_usb2_notifications;
+	ret_usb2 = usb_register_notifier(otgws_xceiv_usb2,
+					&otgws_xceiv_usb2->otgws_nb);
+
+	otgws_xceiv_usb3->otgws_nb.notifier_call = otgws_otg_usb3_notifications;
+	ret_usb3 = usb_register_notifier(otgws_xceiv_usb3,
+					&otgws_xceiv_usb3->otgws_nb);
+
+	if (ret_usb2 && ret_usb3) {
+		pr_err("%s: usb_register_notifier on transceiver failed\n",
+			 __func__);
+		wakeup_source_trash(&otgws_xceiv_usb2->wsource);
+		wakeup_source_trash(&otgws_xceiv_usb3->wsource);
+		otgws_xceiv_usb2 = NULL;
+		otgws_xceiv_usb3 = NULL;
+		return ret_usb2 | ret_usb3;
+	}
+
+	return 0;
+}
+
+late_initcall(otg_wakeupsource_init);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 353053a..dd64e2e 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -12,6 +12,8 @@
 #include <linux/notifier.h>
 #include <linux/usb.h>
 
+#define TEMPORARY_HOLD_TIME    2000
+
 enum usb_phy_interface {
 	USBPHY_INTERFACE_MODE_UNKNOWN,
 	USBPHY_INTERFACE_MODE_UTMI,
@@ -88,6 +90,12 @@ struct usb_phy {
 
 	/* for notification of usb_phy_events */
 	struct atomic_notifier_head	notifier;
+	struct notifier_block	otgws_nb;
+
+	/* wakeup source */
+	struct wakeup_source	wsource;
+
+	spinlock_t		otgws_slock;
 
 	/* to pass extra port status to the root hub */
 	u16			port_status;
-- 
1.8.2.1

