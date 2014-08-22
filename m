Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaHVJtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:49:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40491 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaHVJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:49:49 -0400
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
Subject: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
Date: Fri, 22 Aug 2014 15:19:32 +0530
Message-Id: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

USB: OTG: Hold wakeupsource when VBUS present

Enabled by default, can disable with:
   echo N > /sys/module/otg_wakeupsource/parameters/enabled

This is one of the number of patches from the Android AOSP common.git tree,
which is used on almost all Android devices. so I wanted to submit it for
review to see if it should go upstream.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Benoit Goby <benoit@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
[kiran: Added context to commit message
	Included build fix from Benoit Goby and Arve Arve Hjønnevåg
	Removed lock->held field in driver as this mechanism is provided in wakeup.c
	wakelock(wl) terminology replaced with wakeup_source(ws)
	sys entry(module param) field modified to otg_wakeupsource
	__pm_stay_awake and __pm_relax called directly from the main
	code instead of calling them via otgws_grab,otgws_drop]
---
 drivers/usb/phy/Kconfig            |   8 ++
 drivers/usb/phy/Makefile           |   1 +
 drivers/usb/phy/otg-wakeupsource.c | 171 +++++++++++++++++++++++++++++++++++++
 3 files changed, 180 insertions(+)
 create mode 100644 drivers/usb/phy/otg-wakeupsource.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index e253fa0..9c747b2 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
 config USB_PHY
 	def_bool n
 
+config USB_OTG_WAKEUPSOURCE
+	bool "Hold a wakeupsource when USB connected"
+	depends on PM_SLEEP
+	select USB_PHY
+	help
+	  Select this to automatically hold a wakeupsource when USB is
+	  connected, preventing suspend.
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
index 0000000..fa44e11
--- /dev/null
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -0,0 +1,171 @@
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
+static bool enabled = true;
+static struct usb_phy *otgws_xceiv;
+static struct notifier_block otgws_nb;
+
+
+static DEFINE_SPINLOCK(otgws_spinlock);
+
+/*
+ * Only one lock, but since these 2 fields are associated with each other...
+ */
+
+struct otgws_lock {
+	char name[40];
+	struct wakeup_source wsource;
+};
+
+/*
+ * VBUS present lock.
+ */
+
+static struct otgws_lock vbus_lock;
+
+static int otgws_otg_notifications(struct notifier_block *nb,
+				   unsigned long event, void *unused)
+{
+	unsigned long irqflags;
+
+	if (!enabled)
+		return NOTIFY_OK;
+
+	spin_lock_irqsave(&otgws_spinlock, irqflags);
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
+	return NOTIFY_OK;
+}
+
+static void sync_with_xceiv_state(void)
+{
+	if ((otgws_xceiv->last_event == USB_EVENT_VBUS) ||
+	    (otgws_xceiv->last_event == USB_EVENT_ENUMERATED))
+		__pm_stay_awake(&vbus_lock.wsource);
+	else
+		__pm_relax(&vbus_lock.wsource);
+}
+
+static int init_for_xceiv(void)
+{
+	int rv;
+	struct usb_phy *phy;
+
+	if (!otgws_xceiv) {
+		phy = usb_get_phy(USB_PHY_TYPE_USB2);
+
+		if (IS_ERR(phy)) {
+			pr_err("%s: No USB transceiver found\n", __func__);
+			return PTR_ERR(phy);
+		}
+		otgws_xceiv = phy;
+
+		snprintf(vbus_lock.name, sizeof(vbus_lock.name), "vbus-%s",
+			 dev_name(otgws_xceiv->dev));
+		wakeup_source_init(&vbus_lock.wsource, vbus_lock.name);
+
+		rv = usb_register_notifier(otgws_xceiv, &otgws_nb);
+
+		if (rv) {
+			pr_err("%s: usb_register_notifier on transceiver %s
+				failed\n", __func__,
+			       dev_name(otgws_xceiv->dev));
+			otgws_xceiv = NULL;
+			wakeup_source_trash(&vbus_lock.wsource);
+			return rv;
+		}
+	}
+
+	return 0;
+}
+
+static int set_enabled(const char *val, const struct kernel_param *kp)
+{
+	unsigned long irqflags;
+	int rv = param_set_bool(val, kp);
+
+	if (rv)
+		return rv;
+
+	rv = init_for_xceiv();
+
+	if (rv)
+		return rv;
+
+	spin_lock_irqsave(&otgws_spinlock, irqflags);
+
+	if (enabled)
+		sync_with_xceiv_state();
+	else
+		__pm_relax(&vbus_lock.wsource);
+
+	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
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
+	unsigned long irqflags;
+
+	otgws_nb.notifier_call = otgws_otg_notifications;
+
+	if (!init_for_xceiv()) {
+		spin_lock_irqsave(&otgws_spinlock, irqflags);
+
+		if (enabled)
+			sync_with_xceiv_state();
+
+		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
+	} else {
+		enabled = false;
+	}
+
+	return 0;
+}
+
+late_initcall(otg_wakeupsource_init);
-- 
1.8.2.1

