Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaIXUok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:44:40 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34627 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaIXUoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:44:16 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        Michal Sojka <sojka@merica.cz>
Subject: [PATCH v6 3/4] usb: Rename usb-common.c
Date: Wed, 24 Sep 2014 22:43:20 +0200
Message-Id: <1411591401-5874-4-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411591401-5874-1-git-send-email-sojka@merica.cz>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the next commit, we will want the usb-common module to be composed of
two object files. Since Kbuild cannot "append" another object to an
existing one, we need to rename usb-common.c to something
else (common.c) and create usb-common.o by linking the wanted objects
together. Currently, usb-common.o comprises only common.o.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/common/Makefile     |   4 +-
 drivers/usb/common/common.c     | 144 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/common/usb-common.c | 144 ----------------------------------------
 3 files changed, 147 insertions(+), 145 deletions(-)
 create mode 100644 drivers/usb/common/common.c
 delete mode 100644 drivers/usb/common/usb-common.c

diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
index 7526461..052c120 100644
--- a/drivers/usb/common/Makefile
+++ b/drivers/usb/common/Makefile
@@ -2,5 +2,7 @@
 # Makefile for the usb common parts.
 #
 
-obj-$(CONFIG_USB_COMMON) += usb-common.o
+obj-$(CONFIG_USB_COMMON)	  += usb-common.o
+usb-common-y			  += common.o
+
 obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
new file mode 100644
index 0000000..6dfd30a
--- /dev/null
+++ b/drivers/usb/common/common.c
@@ -0,0 +1,144 @@
+/*
+ * Provides code common for host and device side USB.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ * If either host side (ie. CONFIG_USB=y) or device side USB stack
+ * (ie. CONFIG_USB_GADGET=y) is compiled in the kernel, this module is
+ * compiled-in as well.  Otherwise, if either of the two stacks is
+ * compiled as module, this file is compiled as module as well.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/of.h>
+#include <linux/usb/otg.h>
+
+const char *usb_otg_state_string(enum usb_otg_state state)
+{
+	static const char *const names[] = {
+		[OTG_STATE_A_IDLE] = "a_idle",
+		[OTG_STATE_A_WAIT_VRISE] = "a_wait_vrise",
+		[OTG_STATE_A_WAIT_BCON] = "a_wait_bcon",
+		[OTG_STATE_A_HOST] = "a_host",
+		[OTG_STATE_A_SUSPEND] = "a_suspend",
+		[OTG_STATE_A_PERIPHERAL] = "a_peripheral",
+		[OTG_STATE_A_WAIT_VFALL] = "a_wait_vfall",
+		[OTG_STATE_A_VBUS_ERR] = "a_vbus_err",
+		[OTG_STATE_B_IDLE] = "b_idle",
+		[OTG_STATE_B_SRP_INIT] = "b_srp_init",
+		[OTG_STATE_B_PERIPHERAL] = "b_peripheral",
+		[OTG_STATE_B_WAIT_ACON] = "b_wait_acon",
+		[OTG_STATE_B_HOST] = "b_host",
+	};
+
+	if (state < 0 || state >= ARRAY_SIZE(names))
+		return "UNDEFINED";
+
+	return names[state];
+}
+EXPORT_SYMBOL_GPL(usb_otg_state_string);
+
+static const char *const speed_names[] = {
+	[USB_SPEED_UNKNOWN] = "UNKNOWN",
+	[USB_SPEED_LOW] = "low-speed",
+	[USB_SPEED_FULL] = "full-speed",
+	[USB_SPEED_HIGH] = "high-speed",
+	[USB_SPEED_WIRELESS] = "wireless",
+	[USB_SPEED_SUPER] = "super-speed",
+};
+
+const char *usb_speed_string(enum usb_device_speed speed)
+{
+	if (speed < 0 || speed >= ARRAY_SIZE(speed_names))
+		speed = USB_SPEED_UNKNOWN;
+	return speed_names[speed];
+}
+EXPORT_SYMBOL_GPL(usb_speed_string);
+
+const char *usb_state_string(enum usb_device_state state)
+{
+	static const char *const names[] = {
+		[USB_STATE_NOTATTACHED] = "not attached",
+		[USB_STATE_ATTACHED] = "attached",
+		[USB_STATE_POWERED] = "powered",
+		[USB_STATE_RECONNECTING] = "reconnecting",
+		[USB_STATE_UNAUTHENTICATED] = "unauthenticated",
+		[USB_STATE_DEFAULT] = "default",
+		[USB_STATE_ADDRESS] = "addressed",
+		[USB_STATE_CONFIGURED] = "configured",
+		[USB_STATE_SUSPENDED] = "suspended",
+	};
+
+	if (state < 0 || state >= ARRAY_SIZE(names))
+		return "UNKNOWN";
+
+	return names[state];
+}
+EXPORT_SYMBOL_GPL(usb_state_string);
+
+#ifdef CONFIG_OF
+static const char *const usb_dr_modes[] = {
+	[USB_DR_MODE_UNKNOWN]		= "",
+	[USB_DR_MODE_HOST]		= "host",
+	[USB_DR_MODE_PERIPHERAL]	= "peripheral",
+	[USB_DR_MODE_OTG]		= "otg",
+};
+
+/**
+ * of_usb_get_dr_mode - Get dual role mode for given device_node
+ * @np:	Pointer to the given device_node
+ *
+ * The function gets phy interface string from property 'dr_mode',
+ * and returns the correspondig enum usb_dr_mode
+ */
+enum usb_dr_mode of_usb_get_dr_mode(struct device_node *np)
+{
+	const char *dr_mode;
+	int err, i;
+
+	err = of_property_read_string(np, "dr_mode", &dr_mode);
+	if (err < 0)
+		return USB_DR_MODE_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(usb_dr_modes); i++)
+		if (!strcmp(dr_mode, usb_dr_modes[i]))
+			return i;
+
+	return USB_DR_MODE_UNKNOWN;
+}
+EXPORT_SYMBOL_GPL(of_usb_get_dr_mode);
+
+/**
+ * of_usb_get_maximum_speed - Get maximum requested speed for a given USB
+ * controller.
+ * @np: Pointer to the given device_node
+ *
+ * The function gets the maximum speed string from property "maximum-speed",
+ * and returns the corresponding enum usb_device_speed.
+ */
+enum usb_device_speed of_usb_get_maximum_speed(struct device_node *np)
+{
+	const char *maximum_speed;
+	int err;
+	int i;
+
+	err = of_property_read_string(np, "maximum-speed", &maximum_speed);
+	if (err < 0)
+		return USB_SPEED_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(speed_names); i++)
+		if (strcmp(maximum_speed, speed_names[i]) == 0)
+			return i;
+
+	return USB_SPEED_UNKNOWN;
+}
+EXPORT_SYMBOL_GPL(of_usb_get_maximum_speed);
+
+#endif
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/common/usb-common.c b/drivers/usb/common/usb-common.c
deleted file mode 100644
index 6dfd30a..0000000
--- a/drivers/usb/common/usb-common.c
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- * Provides code common for host and device side USB.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation, version 2.
- *
- * If either host side (ie. CONFIG_USB=y) or device side USB stack
- * (ie. CONFIG_USB_GADGET=y) is compiled in the kernel, this module is
- * compiled-in as well.  Otherwise, if either of the two stacks is
- * compiled as module, this file is compiled as module as well.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/usb/ch9.h>
-#include <linux/usb/of.h>
-#include <linux/usb/otg.h>
-
-const char *usb_otg_state_string(enum usb_otg_state state)
-{
-	static const char *const names[] = {
-		[OTG_STATE_A_IDLE] = "a_idle",
-		[OTG_STATE_A_WAIT_VRISE] = "a_wait_vrise",
-		[OTG_STATE_A_WAIT_BCON] = "a_wait_bcon",
-		[OTG_STATE_A_HOST] = "a_host",
-		[OTG_STATE_A_SUSPEND] = "a_suspend",
-		[OTG_STATE_A_PERIPHERAL] = "a_peripheral",
-		[OTG_STATE_A_WAIT_VFALL] = "a_wait_vfall",
-		[OTG_STATE_A_VBUS_ERR] = "a_vbus_err",
-		[OTG_STATE_B_IDLE] = "b_idle",
-		[OTG_STATE_B_SRP_INIT] = "b_srp_init",
-		[OTG_STATE_B_PERIPHERAL] = "b_peripheral",
-		[OTG_STATE_B_WAIT_ACON] = "b_wait_acon",
-		[OTG_STATE_B_HOST] = "b_host",
-	};
-
-	if (state < 0 || state >= ARRAY_SIZE(names))
-		return "UNDEFINED";
-
-	return names[state];
-}
-EXPORT_SYMBOL_GPL(usb_otg_state_string);
-
-static const char *const speed_names[] = {
-	[USB_SPEED_UNKNOWN] = "UNKNOWN",
-	[USB_SPEED_LOW] = "low-speed",
-	[USB_SPEED_FULL] = "full-speed",
-	[USB_SPEED_HIGH] = "high-speed",
-	[USB_SPEED_WIRELESS] = "wireless",
-	[USB_SPEED_SUPER] = "super-speed",
-};
-
-const char *usb_speed_string(enum usb_device_speed speed)
-{
-	if (speed < 0 || speed >= ARRAY_SIZE(speed_names))
-		speed = USB_SPEED_UNKNOWN;
-	return speed_names[speed];
-}
-EXPORT_SYMBOL_GPL(usb_speed_string);
-
-const char *usb_state_string(enum usb_device_state state)
-{
-	static const char *const names[] = {
-		[USB_STATE_NOTATTACHED] = "not attached",
-		[USB_STATE_ATTACHED] = "attached",
-		[USB_STATE_POWERED] = "powered",
-		[USB_STATE_RECONNECTING] = "reconnecting",
-		[USB_STATE_UNAUTHENTICATED] = "unauthenticated",
-		[USB_STATE_DEFAULT] = "default",
-		[USB_STATE_ADDRESS] = "addressed",
-		[USB_STATE_CONFIGURED] = "configured",
-		[USB_STATE_SUSPENDED] = "suspended",
-	};
-
-	if (state < 0 || state >= ARRAY_SIZE(names))
-		return "UNKNOWN";
-
-	return names[state];
-}
-EXPORT_SYMBOL_GPL(usb_state_string);
-
-#ifdef CONFIG_OF
-static const char *const usb_dr_modes[] = {
-	[USB_DR_MODE_UNKNOWN]		= "",
-	[USB_DR_MODE_HOST]		= "host",
-	[USB_DR_MODE_PERIPHERAL]	= "peripheral",
-	[USB_DR_MODE_OTG]		= "otg",
-};
-
-/**
- * of_usb_get_dr_mode - Get dual role mode for given device_node
- * @np:	Pointer to the given device_node
- *
- * The function gets phy interface string from property 'dr_mode',
- * and returns the correspondig enum usb_dr_mode
- */
-enum usb_dr_mode of_usb_get_dr_mode(struct device_node *np)
-{
-	const char *dr_mode;
-	int err, i;
-
-	err = of_property_read_string(np, "dr_mode", &dr_mode);
-	if (err < 0)
-		return USB_DR_MODE_UNKNOWN;
-
-	for (i = 0; i < ARRAY_SIZE(usb_dr_modes); i++)
-		if (!strcmp(dr_mode, usb_dr_modes[i]))
-			return i;
-
-	return USB_DR_MODE_UNKNOWN;
-}
-EXPORT_SYMBOL_GPL(of_usb_get_dr_mode);
-
-/**
- * of_usb_get_maximum_speed - Get maximum requested speed for a given USB
- * controller.
- * @np: Pointer to the given device_node
- *
- * The function gets the maximum speed string from property "maximum-speed",
- * and returns the corresponding enum usb_device_speed.
- */
-enum usb_device_speed of_usb_get_maximum_speed(struct device_node *np)
-{
-	const char *maximum_speed;
-	int err;
-	int i;
-
-	err = of_property_read_string(np, "maximum-speed", &maximum_speed);
-	if (err < 0)
-		return USB_SPEED_UNKNOWN;
-
-	for (i = 0; i < ARRAY_SIZE(speed_names); i++)
-		if (strcmp(maximum_speed, speed_names[i]) == 0)
-			return i;
-
-	return USB_SPEED_UNKNOWN;
-}
-EXPORT_SYMBOL_GPL(of_usb_get_maximum_speed);
-
-#endif
-
-MODULE_LICENSE("GPL");
-- 
2.1.0

