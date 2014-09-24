Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaIXUo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:44:56 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34628 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbaIXUoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:44:16 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        Michal Sojka <sojka@merica.cz>
Subject: [PATCH v6 4/4] usb: Add LED triggers for USB activity
Date: Wed, 24 Sep 2014 22:43:21 +0200
Message-Id: <1411591401-5874-5-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411591401-5874-1-git-send-email-sojka@merica.cz>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, USB activity can be signaled by blinking a LED. There
are two triggers, one for activity on USB host and one for USB gadget.

Both triggers should work with all host/device controllers. Tested only
with musb.

Performace: I measured performance overheads on ARM Cortex-A8 (TI
AM335x) running on 600 MHz.

Duration of usb_led_activity():
- with no LED attached to the trigger:        2 ± 1 µs
- with one GPIO LED attached to the trigger:  2 ± 1 µs or 8 ± 2 µs (two peaks in histogram)

Duration of functions calling usb_led_activity() (with this patch
applied and no LED attached to the trigger):
- __usb_hcd_giveback_urb():    10 - 25 µs
- usb_gadget_giveback_request(): 2 - 6 µs

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/Kconfig               | 10 +++++++
 drivers/usb/common/Makefile       |  1 +
 drivers/usb/common/led.c          | 57 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/hcd.c            |  2 ++
 drivers/usb/gadget/udc/udc-core.c |  4 +++
 include/linux/usb.h               | 12 +++++++++
 6 files changed, 86 insertions(+)
 create mode 100644 drivers/usb/common/led.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index cf1b19b..ae481c3 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -149,4 +149,14 @@ source "drivers/usb/phy/Kconfig"
 
 source "drivers/usb/gadget/Kconfig"
 
+config USB_LED_TRIG
+	bool "USB LED Triggers"
+	depends on LEDS_CLASS && USB_COMMON && LEDS_TRIGGERS
+	help
+	  This option adds LED triggers for USB host and/or gadget activity.
+
+	  Say Y here if you are working on a system with led-class supported
+	  LEDs and you want to use them as activity indicators for USB host or
+	  gadget.
+
 endif # USB_SUPPORT
diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
index 052c120..ca2f8bd 100644
--- a/drivers/usb/common/Makefile
+++ b/drivers/usb/common/Makefile
@@ -4,5 +4,6 @@
 
 obj-$(CONFIG_USB_COMMON)	  += usb-common.o
 usb-common-y			  += common.o
+usb-common-$(CONFIG_USB_LED_TRIG) += led.o
 
 obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
diff --git a/drivers/usb/common/led.c b/drivers/usb/common/led.c
new file mode 100644
index 0000000..df23da0
--- /dev/null
+++ b/drivers/usb/common/led.c
@@ -0,0 +1,57 @@
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
+	case USB_LED_EVENT_GADGET:
+		trig = ledtrig_usb_gadget;
+		break;
+	case USB_LED_EVENT_HOST:
+		trig = ledtrig_usb_host;
+		break;
+	}
+	/* led_trigger_blink_oneshot() handles trig == NULL gracefully */
+	led_trigger_blink_oneshot(trig, &usb_blink_delay, &usb_blink_delay, 0);
+}
+EXPORT_SYMBOL_GPL(usb_led_activity);
+
+
+static int __init ledtrig_usb_init(void)
+{
+	led_trigger_register_simple("usb-gadget", &ledtrig_usb_gadget);
+	led_trigger_register_simple("usb-host", &ledtrig_usb_host);
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
index f7b3151..931b9f1 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -27,6 +27,7 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/usb.h>
 
 /**
  * struct usb_udc - describes one usb device controller
@@ -116,6 +117,9 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
 void usb_gadget_giveback_request(struct usb_ep *ep,
 		struct usb_request *req)
 {
+	if (likely(req->status == 0))
+		usb_led_activity(USB_LED_EVENT_GADGET);
+
 	req->complete(ep, req);
 }
 EXPORT_SYMBOL_GPL(usb_gadget_giveback_request);
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

