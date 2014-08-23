Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaHWAJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:09:29 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34202 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbaHWAJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:09:25 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v2 2/3] usb: Add LED trigger for USB host activity
Date: Sat, 23 Aug 2014 02:08:21 +0200
Message-Id: <1408752502-4162-3-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408752502-4162-1-git-send-email-sojka@merica.cz>
References: <87ha149j2z.fsf@steelpick.2x.cz>
 <1408752502-4162-1-git-send-email-sojka@merica.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, USB host activity can be signaled by blinking a LED.

This should work with all host controllers. Tested only with musb.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/core/Kconfig  |  9 +++++++++
 drivers/usb/core/Makefile |  1 +
 drivers/usb/core/hcd.c    |  2 ++
 drivers/usb/core/led.c    | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/usb/hcd.h   |  6 ++++++
 5 files changed, 56 insertions(+)
 create mode 100644 drivers/usb/core/led.c

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 1060657..8295f65 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -90,3 +90,12 @@ config USB_OTG_FSM
 	  Implements OTG Finite State Machine as specified in On-The-Go
 	  and Embedded Host Supplement to the USB Revision 2.0 Specification.
 
+config USB_HOST_LED
+	bool "USB Host LED Trigger"
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	help
+	  This option adds a LED trigger for USB host controllers.
+
+	  Say Y here if you are working on a system with led-class supported
+	  LEDs and you want to use them as USB host activity indicators.
diff --git a/drivers/usb/core/Makefile b/drivers/usb/core/Makefile
index 2f6f932..324c8c9 100644
--- a/drivers/usb/core/Makefile
+++ b/drivers/usb/core/Makefile
@@ -9,5 +9,6 @@ usbcore-y += port.o
 
 usbcore-$(CONFIG_PCI)		+= hcd-pci.o
 usbcore-$(CONFIG_ACPI)		+= usb-acpi.o
+usbcore-$(CONFIG_USB_HOST_LED)	+= led.o
 
 obj-$(CONFIG_USB)		+= usbcore.o
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 487abcf..46d9f3a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1664,6 +1664,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 	usbmon_urb_complete(&hcd->self, urb, status);
 	usb_anchor_suspend_wakeups(anchor);
 	usb_unanchor_urb(urb);
+	if (status == 0)
+		usb_hcd_led_activity();
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
diff --git a/drivers/usb/core/led.c b/drivers/usb/core/led.c
new file mode 100644
index 0000000..49ff76c
--- /dev/null
+++ b/drivers/usb/core/led.c
@@ -0,0 +1,38 @@
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
+#include <linux/usb/hcd.h>
+
+#define BLINK_DELAY 30
+
+DEFINE_LED_TRIGGER(ledtrig_usb_hcd);
+static unsigned long usb_hcd_blink_delay = BLINK_DELAY;
+
+void usb_hcd_led_activity(void)
+{
+	led_trigger_blink_oneshot(ledtrig_usb_hcd,
+				  &usb_hcd_blink_delay, &usb_hcd_blink_delay, 0);
+}
+
+int __init ledtrig_usb_hcd_init(void)
+{
+	led_trigger_register_simple("usb-host", &ledtrig_usb_hcd);
+	return 0;
+}
+
+void __exit ledtrig_usb_hcd_exit(void)
+{
+	led_trigger_unregister_simple(ledtrig_usb_hcd);
+}
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index b43f0fe..eb5fa0f 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -700,6 +700,12 @@ extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 #define USB_EHCI_LOADED		2
 extern unsigned long usb_hcds_loaded;
 
+#ifdef CONFIG_USB_HOST_LED
+extern void usb_hcd_led_activity(void);
+#else
+static inline void usb_hcd_led_activity(void) {}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* __USB_CORE_HCD_H */
-- 
2.1.0

