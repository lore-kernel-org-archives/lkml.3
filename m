Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaHVMaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:30:20 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:27305 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbaHVMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:30:17 -0400
X-Greylist: delayed 2086 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2014 08:30:05 EDT
From: Michal Sojka <sojka@merica.cz>
To: linux-leds@vger.kernel.org
Cc: michal.vokac@comap.cz, Michal Sojka <sojka@merica.cz>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 2/2] leds: usb: Add LED trigger for USB host activity
Date: Fri, 22 Aug 2014 13:53:13 +0200
Message-Id: <1408708399-20423-2-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408708399-20423-1-git-send-email-sojka@merica.cz>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: s7MBsvpI055365
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.167, required 6, autolearn=not spam, BAYES_00 -0.50,
	HEADER_FROM_DIFFERENT_DOMAINS 0.00, RP_MATCHES_RCVD -0.67)
X-FELK-MailScanner-From: sojkam1@fel.cvut.cz
X-FELK-MailScanner-Watermark: 1409313301.08151@hLDyehHSHTtR23HbL8hD3w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, USB host activity can be signaled by blinking a LED.

This should work with all host controllers. Tested only with musb.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/leds/trigger/Kconfig           |  8 ++++++
 drivers/leds/trigger/Makefile          |  1 +
 drivers/leds/trigger/ledtrig-usbhost.c | 45 ++++++++++++++++++++++++++++++++++
 drivers/usb/core/hcd.c                 |  3 +++
 include/linux/leds.h                   |  6 +++++
 5 files changed, 63 insertions(+)
 create mode 100644 drivers/leds/trigger/ledtrig-usbhost.c

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 9562963..528d736 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -49,6 +49,14 @@ config LEDS_TRIGGER_USBGADGET
 	  This allows LEDs to be controlled by USB gadget activity.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_USBHOST
+	bool "LED USB Host Trigger"
+	depends on USB
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by USB host activity.
+	  If unsure, say Y.
+
 config LEDS_TRIGGER_HEARTBEAT
 	tristate "LED Heartbeat Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 45917c0..9e9ca19 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
 obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
 obj-$(CONFIG_LEDS_TRIGGER_CAMERA)	+= ledtrig-camera.o
 obj-$(CONFIG_LEDS_TRIGGER_USBGADGET)	+= ledtrig-usbgadget.o
+obj-$(CONFIG_LEDS_TRIGGER_USBHOST)	+= ledtrig-usbhost.o
diff --git a/drivers/leds/trigger/ledtrig-usbhost.c b/drivers/leds/trigger/ledtrig-usbhost.c
new file mode 100644
index 0000000..0a12f67
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-usbhost.c
@@ -0,0 +1,45 @@
+/*
+ * LED Trigger for USB Host Activity
+ *
+ * Copyright 2014 Michal Sojka <sojka@merica.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+
+#define BLINK_DELAY 30
+
+DEFINE_LED_TRIGGER(ledtrig_usbhost);
+static unsigned long usbhost_blink_delay = BLINK_DELAY;
+
+void ledtrig_usbhost_activity(void)
+{
+	led_trigger_blink_oneshot(ledtrig_usbhost,
+				  &usbhost_blink_delay, &usbhost_blink_delay, 0);
+}
+EXPORT_SYMBOL(ledtrig_usbhost_activity);
+
+static int __init ledtrig_usbhost_init(void)
+{
+	led_trigger_register_simple("usb-host", &ledtrig_usbhost);
+	return 0;
+}
+
+static void __exit ledtrig_usbhost_exit(void)
+{
+	led_trigger_unregister_simple(ledtrig_usbhost);
+}
+
+module_init(ledtrig_usbhost_init);
+module_exit(ledtrig_usbhost_exit);
+
+MODULE_AUTHOR("Michal Sojka <sojka@merica.cz>");
+MODULE_DESCRIPTION("LED Trigger for USB Host Activity");
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 9c4e292..bcfea14 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -41,6 +41,7 @@
 #include <linux/workqueue.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
+#include <linux/leds.h>
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -1664,6 +1665,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 	usbmon_urb_complete(&hcd->self, urb, status);
 	usb_anchor_suspend_wakeups(anchor);
 	usb_unanchor_urb(urb);
+	if (status == 0)
+		ledtrig_usbhost_activity();
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5d9668e..5653495 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -224,6 +224,12 @@ extern void ledtrig_usbgadget_activity(void);
 static inline void ledtrig_usbgadget_activity(void) {}
 #endif
 
+#ifdef CONFIG_LEDS_TRIGGER_USBHOST
+extern void ledtrig_usbhost_activity(void);
+#else
+static inline void ledtrig_usbhost_activity(void) {}
+#endif
+
 #if defined(CONFIG_LEDS_TRIGGER_CAMERA) || defined(CONFIG_LEDS_TRIGGER_CAMERA_MODULE)
 extern void ledtrig_flash_ctrl(bool on);
 extern void ledtrig_torch_ctrl(bool on);
-- 
2.1.0

