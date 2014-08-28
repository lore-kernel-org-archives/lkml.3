Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936538AbaH1Jzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:55:38 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41721 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934539AbaH1Jzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:55:36 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v1 1/2] USB: OTG: Hold wakeupsource when VBUS present
Date: Thu, 28 Aug 2014 15:25:10 +0530
Message-Id: <1409219710-26874-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

USB: OTG: Hold wakeupsource when VBUS present

Purpose of this is to prevent the system to enter into
suspend state from USB peripheral traffic by hodling a
wakeupsource when USB(otg) is connected and enumerated
in peripheral mode(say adb).

Disabled by default, can enable with:
   echo Y > /sys/module/otg_wakeupsource/parameters/enabled

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Benoit Goby <benoit@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message.
	Included build fix from Benoit Goby and Arve Hjønnevåg.
	Removed lock->held field in driver as this mechanism is
	provided in wakeupsource driver.
	wakelock(wl) terminology replaced with wakeup_source(ws).
	changed to disabled by default from "enable by default".
	sys entry(module param) field modified to otg_wakeupsource.
	included Todd's refactoring logic.
	Introduced get_phy_hook to handle otgws_xceiv per-PHY.
	otgws_nb moved to otg_wakeupsource_init function.
	__pm_stay_awake and __pm_relax called directly from the main.
	code instead of calling them via otgws_grab,otgws_drop.
	modified Kconfig help text]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 drivers/usb/phy/Kconfig            |   8 +++
 drivers/usb/phy/Makefile           |   1 +
 drivers/usb/phy/otg-wakeupsource.c | 144 +++++++++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+)
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
index 0000000..7c838d1
--- /dev/null
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -0,0 +1,144 @@
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
+static struct usb_phy *get_phy_hook(void);
+
+/* Only one lock, but since these 2 fields are associated with each other... */
+
+struct otgws_lock {
+	char name[40];
+	struct wakeup_source wsource;
+};
+
+/* VBUS present lock */
+
+static struct otgws_lock vbus_lock;
+
+static void otgws_handle_event(unsigned long event)
+{
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&otgws_spinlock, irqflags);
+
+	if (!enabled) {
+		__pm_relax(&vbus_lock.wsource);
+		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
+		return;
+	}
+
+	switch (event) {
+	case USB_EVENT_VBUS:
+	case USB_EVENT_ENUMERATED:
+		__pm_stay_awake(&vbus_lock.wsource);
+		break;
+
+	case USB_EVENT_NONE:
+	case USB_EVENT_ID:
+	case USB_EVENT_CHARGER:
+		__pm_relax(&vbus_lock.wsource);
+		break;
+
+	default:
+		break;
+	}
+
+	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
+}
+static struct usb_phy *get_phy_hook(void)
+{
+	struct usb_phy *phy;
+
+	phy = usb_get_phy(USB_PHY_TYPE_USB2);
+
+	if (IS_ERR(phy)) {
+		pr_err("%s: No OTG transceiver found\n", __func__);
+		return NULL;
+	}
+
+	return phy;
+}
+static int otgws_otg_notifications(struct notifier_block *nb,
+				unsigned long event, void *unused)
+{
+	otgws_handle_event(event);
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
+	otgws_xceiv = get_phy_hook();
+
+	if (otgws_xceiv)
+		otgws_handle_event(otgws_xceiv->last_event);
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
+	static struct notifier_block otgws_nb;
+	static struct usb_phy *otgws_xceiv;
+
+	otgws_xceiv = get_phy_hook();
+
+	if (NULL == otgws_xceiv)
+		return PTR_ERR(otgws_xceiv);
+
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
+	}
+
+	return 0;
+}
+
+late_initcall(otg_wakeupsource_init);
-- 
1.8.2.1

