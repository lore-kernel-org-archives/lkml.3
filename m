Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaIHKKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:10:20 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52932 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaIHKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:10:18 -0400
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
Subject: [RFC v3 1/2] usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
Date: Mon,  8 Sep 2014 15:39:23 +0530
Message-Id: <1410170963-14182-1-git-send-email-kiran.kumar@linaro.org>
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

Disabled by default, can enable with:
   echo Y > /sys/module/otg_wakeupsource/parameters/enabled

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
 drivers/usb/phy/otg-wakeupsource.c | 136 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h            |   4 ++
 4 files changed, 149 insertions(+)
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
index 0000000..d9a1720
--- /dev/null
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -0,0 +1,136 @@
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
+bool enabled = false;
+
+static DEFINE_SPINLOCK(otgws_spinlock);
+
+static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned long event)
+{
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&otgws_spinlock, irqflags);
+
+	if (!enabled) {
+		__pm_relax(&otgws_xceiv->wsource);
+		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
+		return;
+	}
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
+		__pm_relax(&otgws_xceiv->wsource);
+		break;
+
+	default:
+		break;
+	}
+
+	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
+}
+
+static int otgws_otg_notifications(struct notifier_block *nb,
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
+static int set_enabled(const char *val, const struct kernel_param *kp)
+{
+	int rv = param_set_bool(val, kp);
+	static struct usb_phy *otgws_xceiv;
+
+	if (rv)
+		return rv;
+
+	otgws_xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+
+	if (IS_ERR(otgws_xceiv)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return PTR_ERR(otgws_xceiv);
+	}
+
+	otgws_handle_event(otgws_xceiv, otgws_xceiv->last_event);
+
+	return 0;
+}
+
+static struct kernel_param_ops enabled_param_ops = {
+	.set = set_enabled,
+	.get = param_get_bool,
+};
+
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0644);
+MODULE_PARM_DESC(enabled, "Hold wakeupsource when VBUS present");
+
+static int __init otg_wakeupsource_init(void)
+{
+	int ret;
+	char wsource_name[40];
+	static struct usb_phy *otgws_xceiv;
+
+	otgws_xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+
+	if (IS_ERR(otgws_xceiv)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return PTR_ERR(otgws_xceiv);
+	}
+
+	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
+		dev_name(otgws_xceiv->dev));
+	wakeup_source_init(&otgws_xceiv->wsource, wsource_name);
+
+	otgws_xceiv->otgws_nb.notifier_call = otgws_otg_notifications;
+	ret = usb_register_notifier(otgws_xceiv, &otgws_xceiv->otgws_nb);
+
+	if (ret) {
+		pr_err("%s: usb_register_notifier on transceiver %s failed\n",
+			 __func__, dev_name(otgws_xceiv->dev));
+		wakeup_source_trash(&otgws_xceiv->wsource);
+		otgws_xceiv = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+late_initcall(otg_wakeupsource_init);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 353053a..c71cf15 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -88,6 +88,10 @@ struct usb_phy {
 
 	/* for notification of usb_phy_events */
 	struct atomic_notifier_head	notifier;
+	struct notifier_block	otgws_nb;
+
+	/* wakeup source */
+	struct wakeup_source	wsource;
 
 	/* to pass extra port status to the root hub */
 	u16			port_status;
-- 
1.8.2.1

