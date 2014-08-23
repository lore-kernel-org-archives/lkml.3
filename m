Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaHWAJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:09:30 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34201 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaHWAJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:09:25 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v2 3/3] usb: Add LED trigger for USB gadget activity
Date: Sat, 23 Aug 2014 02:08:22 +0200
Message-Id: <1408752502-4162-4-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408752502-4162-1-git-send-email-sojka@merica.cz>
References: <87ha149j2z.fsf@steelpick.2x.cz>
 <1408752502-4162-1-git-send-email-sojka@merica.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, USB gadget activity can be signaled by blinking a LED.

Since there is no generic code where to put the trigger for all USB
controllers, each USB controller needs to call the trigger individually.
This patch adds the call only for the musb controller where I can test
it.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/gadget/Kconfig      | 12 ++++++++++++
 drivers/usb/gadget/udc/Makefile |  5 ++++-
 drivers/usb/gadget/udc/led.c    | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_gadget.c  |  5 +++--
 include/linux/usb/gadget.h      | 10 ++++++++++
 5 files changed, 67 insertions(+), 3 deletions(-)
 create mode 100644 drivers/usb/gadget/udc/led.c

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 5c822af..612c859 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -127,6 +127,18 @@ config USB_GADGET_STORAGE_NUM_BUFFERS
 	   a module parameter as well.
 	   If unsure, say 2.
 
+config USB_GADGET_LED
+	bool "USB Gadget LED Trigger"
+	depends on (USB_MUSB_GADGET || USB_MUSB_DUAL_ROLE)
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	help
+	  This option adds a LED trigger for USB gadgets. The trigger will
+	  only work with supported USB device controllers.
+
+	  Say Y here if you are working on a system with led-class supported
+	  LEDs and you want to use them as USB gadget activity indicators.
+
 source "drivers/usb/gadget/udc/Kconfig"
 
 #
diff --git a/drivers/usb/gadget/udc/Makefile b/drivers/usb/gadget/udc/Makefile
index 4096122..acbe3ca 100644
--- a/drivers/usb/gadget/udc/Makefile
+++ b/drivers/usb/gadget/udc/Makefile
@@ -1,7 +1,10 @@
 #
 # USB peripheral controller drivers
 #
-obj-$(CONFIG_USB_GADGET)	+= udc-core.o
+obj-$(CONFIG_USB_GADGET)	+= udc.o
+udc-y				:= udc-core.o
+udc-$(CONFIG_USB_GADGET_LED)	+= led.o
+
 obj-$(CONFIG_USB_DUMMY_HCD)	+= dummy_hcd.o
 obj-$(CONFIG_USB_NET2272)	+= net2272.o
 obj-$(CONFIG_USB_NET2280)	+= net2280.o
diff --git a/drivers/usb/gadget/udc/led.c b/drivers/usb/gadget/udc/led.c
new file mode 100644
index 0000000..29a8b3f
--- /dev/null
+++ b/drivers/usb/gadget/udc/led.c
@@ -0,0 +1,38 @@
+/*
+ * LED Trigger for USB Gadget Activity
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
+DEFINE_LED_TRIGGER(ledtrig_usbgadget);
+static unsigned long usbgadget_blink_delay = BLINK_DELAY;
+
+void usb_gadget_led_activity(void)
+{
+	led_trigger_blink_oneshot(ledtrig_usbgadget,
+				  &usbgadget_blink_delay, &usbgadget_blink_delay, 0);
+}
+EXPORT_SYMBOL(usb_gadget_led_activity);
+
+int __init ledtrig_usbgadget_init(void)
+{
+	led_trigger_register_simple("usb-gadget", &ledtrig_usbgadget);
+	return 0;
+}
+
+void __exit ledtrig_usbgadget_exit(void)
+{
+	led_trigger_unregister_simple(ledtrig_usbgadget);
+}
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index d4aa779..0bf06f9 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -167,11 +167,12 @@ __acquires(ep->musb->lock)
 	if (!dma_mapping_error(&musb->g.dev, request->dma))
 		unmap_dma_buffer(req, musb);
 
-	if (request->status == 0)
+	if (request->status == 0) {
 		dev_dbg(musb->controller, "%s done request %p,  %d/%d\n",
 				ep->end_point.name, request,
 				req->request.actual, req->request.length);
-	else
+		usb_gadget_led_activity();
+	} else
 		dev_dbg(musb->controller, "%s request %p, %d/%d fault %d\n",
 				ep->end_point.name, request,
 				req->request.actual, req->request.length,
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index c3a6185..69bd9bc 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -1025,4 +1025,14 @@ extern struct usb_ep *usb_ep_autoconfig_ss(struct usb_gadget *,
 
 extern void usb_ep_autoconfig_reset(struct usb_gadget *);
 
+/*-------------------------------------------------------------------------*/
+
+/* LED trigger */
+
+#ifdef CONFIG_USB_GADGET_LED
+extern void usb_gadget_led_activity(void);
+#else
+static inline void usb_gadget_led_activity(void) {}
+#endif
+
 #endif /* __LINUX_USB_GADGET_H */
-- 
2.1.0

