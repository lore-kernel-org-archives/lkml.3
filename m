Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361AbaH0NHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:07:30 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:50413 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0NH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:07:27 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v3 2/2] usb: Add LED triggers for USB activity
Date: Wed, 27 Aug 2014 15:03:45 +0200
Message-Id: <1409144625-25274-3-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409144625-25274-1-git-send-email-sojka@merica.cz>
References: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com>
 <1409144625-25274-1-git-send-email-sojka@merica.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: s7RD6RJj068108
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-0.498, required 6, autolearn=not spam, BAYES_00 -0.50,
	HEADER_FROM_DIFFERENT_DOMAINS 0.00, RP_MATCHES_RCVD 0.00)
X-FELK-MailScanner-From: sojkam1@fel.cvut.cz
X-FELK-MailScanner-Watermark: 1409749589.8113@HujVH8OA6CDTE2gUOa530A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, USB activity can be signaled by blinking a LED. There
are two triggers, one for activity on USB host and one for USB gadget.

Both trigger should work with all host/device controllers. Tested only
with musb.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/Kconfig                           | 11 ++++++
 drivers/usb/common/Makefile                   |  5 ++-
 drivers/usb/common/{usb-common.c => common.c} |  0
 drivers/usb/common/led.c                      | 56 +++++++++++++++++++++++++++
 drivers/usb/core/hcd.c                        |  2 +
 drivers/usb/gadget/udc/udc-core.c             |  4 ++
 include/linux/usb.h                           | 12 ++++++
 7 files changed, 89 insertions(+), 1 deletion(-)
 rename drivers/usb/common/{usb-common.c => common.c} (100%)
 create mode 100644 drivers/usb/common/led.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index e0cad441..fc90cda 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -147,4 +147,15 @@ source "drivers/usb/phy/Kconfig"
 
 source "drivers/usb/gadget/Kconfig"
 
+config USB_LED_TRIG
+	bool "USB LED Triggers"
+	depends on LEDS_CLASS && USB_COMMON
+	select LEDS_TRIGGERS
+	help
+	  This option adds LED triggers for USB host and/or gadget activity.
+
+	  Say Y here if you are working on a system with led-class supported
+	  LEDs and you want to use them as activity indicators for USB host or
+	  gadget.
+
 endif # USB_SUPPORT
diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
index 7526461..ca2f8bd 100644
--- a/drivers/usb/common/Makefile
+++ b/drivers/usb/common/Makefile
@@ -2,5 +2,8 @@
 # Makefile for the usb common parts.
 #
 
-obj-$(CONFIG_USB_COMMON) += usb-common.o
+obj-$(CONFIG_USB_COMMON)	  += usb-common.o
+usb-common-y			  += common.o
+usb-common-$(CONFIG_USB_LED_TRIG) += led.o
+
 obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
diff --git a/drivers/usb/common/usb-common.c b/drivers/usb/common/common.c
similarity index 100%
rename from drivers/usb/common/usb-common.c
rename to drivers/usb/common/common.c
diff --git a/drivers/usb/common/led.c b/drivers/usb/common/led.c
new file mode 100644
index 0000000..af3ce2c
--- /dev/null
+++ b/drivers/usb/common/led.c
@@ -0,0 +1,56 @@
+/*
+ * LED Triggers for USB Activity
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
+#include <linux/usb.h>
+
+#define BLINK_DELAY 30
+
+static unsigned long usb_blink_delay = BLINK_DELAY;
+
+DEFINE_LED_TRIGGER(ledtrig_usb_gadget);
+DEFINE_LED_TRIGGER(ledtrig_usb_host);
+
+void usb_led_activity(enum usb_led_event ev)
+{
+	struct led_trigger *trig = NULL;
+
+	switch (ev) {
+	case USB_LED_EVENT_GADGET: trig = ledtrig_usb_gadget; break;
+	case USB_LED_EVENT_HOST:   trig = ledtrig_usb_host;    break;
+	}
+	led_trigger_blink_oneshot(trig, &usb_blink_delay, &usb_blink_delay, 0);
+}
+EXPORT_SYMBOL(usb_led_activity);
+
+
+static int __init ledtrig_usb_init(void)
+{
+#ifdef CONFIG_USB_GADGET
+	led_trigger_register_simple("usb-gadget", &ledtrig_usb_gadget);
+#endif
+#ifdef CONFIG_USB
+	led_trigger_register_simple("usb-host", &ledtrig_usb_host);
+#endif
+	return 0;
+}
+
+static void __exit ledtrig_usb_exit(void)
+{
+	led_trigger_unregister_simple(ledtrig_usb_gadget);
+	led_trigger_unregister_simple(ledtrig_usb_host);
+}
+
+module_init(ledtrig_usb_init);
+module_exit(ledtrig_usb_exit);
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 487abcf..409cb95 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1664,6 +1664,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 	usbmon_urb_complete(&hcd->self, urb, status);
 	usb_anchor_suspend_wakeups(anchor);
 	usb_unanchor_urb(urb);
+	if (likely(status == 0))
+		usb_led_activity(USB_LED_EVENT_HOST);
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
index 2eb0ae4..2ce42f9 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -27,6 +27,7 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/usb.h>
 
 /**
  * struct usb_udc - describes one usb device controller
@@ -105,6 +106,9 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
 void usb_gadget_giveback_request(struct usb_ep *ep,
 		struct usb_request *req)
 {
+	if (likely(req->status == 0))
+		usb_led_activity(USB_LED_EVENT_GADGET);
+
 	/* complete() is from gadget layer,
 	 * eg fsg->bulk_in_complete() */
 	if (req->complete)
diff --git a/include/linux/usb.h b/include/linux/usb.h
index d2465bc..447a7e2 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1862,6 +1862,18 @@ extern void usb_unregister_notify(struct notifier_block *nb);
 /* debugfs stuff */
 extern struct dentry *usb_debug_root;
 
+/* LED triggers */
+enum usb_led_event {
+	USB_LED_EVENT_HOST = 0,
+	USB_LED_EVENT_GADGET = 1,
+};
+
+#ifdef CONFIG_USB_LED_TRIG
+extern void usb_led_activity(enum usb_led_event ev);
+#else
+static inline void usb_led_activity(enum usb_led_event ev) {}
+#endif
+
 #endif  /* __KERNEL__ */
 
 #endif
-- 
2.1.0

