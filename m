Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaEURga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:36:30 -0400
Received: from ring0.de ([5.45.105.125]:57791 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaEURg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:36:27 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv4 1/4] Input: add common DT binding for touchscreens
Date: Wed, 21 May 2014 19:36:11 +0200
Message-Id: <1400693774-21306-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400693774-21306-1-git-send-email-sre@kernel.org>
References: <1400693774-21306-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common DT binding documentation for touchscreen devices and
implement input_parse_touchscreen_of_params, which parses the common
properties and configures the input device accordingly.

The method currently does not interpret the axis inversion properties,
since there is no matching flag in the generic linux input device.

Reviewed-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 .../bindings/input/touchscreen/touchscreen.txt     | 27 +++++++++++++
 drivers/input/touchscreen/Kconfig                  |  4 ++
 drivers/input/touchscreen/Makefile                 |  1 +
 drivers/input/touchscreen/of_touchscreen.c         | 44 ++++++++++++++++++++++
 include/linux/input/touchscreen.h                  | 22 +++++++++++
 5 files changed, 98 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
 create mode 100644 drivers/input/touchscreen/of_touchscreen.c
 create mode 100644 include/linux/input/touchscreen.h

diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
new file mode 100644
index 0000000..d8e0616
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
@@ -0,0 +1,27 @@
+General Touchscreen Properties:
+
+Optional properties for Touchscreens:
+ - touchscreen-size-x		: horizontal resolution of touchscreen
+				  (in pixels)
+ - touchscreen-size-y		: vertical resolution of touchscreen
+				  (in pixels)
+ - touchscreen-max-pressure	: maximum reported pressure (arbitrary range
+				  dependent on the controller)
+ - touchscreen-fuzz-x		: horizontal noise value of the absolute input
+				  device (in pixels)
+ - touchscreen-fuzz-y		: vertical noise value of the absolute input
+				  device (in pixels)
+ - touchscreen-fuzz-pressure	: pressure noise value of the absolute input
+				  device (arbitrary range dependent on the
+				  controller)
+ - touchscreen-inverted-x	: X axis is inverted (boolean)
+ - touchscreen-inverted-y	: Y axis is inverted (boolean)
+
+Deprecated properties for Touchscreens:
+ - x-size			: deprecated name for touchscreen-size-x
+ - y-size			: deprecated name for touchscreen-size-y
+ - moving-threshold		: deprecated name for a combination of
+				  touchscreen-fuzz-x and touchscreen-fuzz-y
+ - contact-threshold		: deprecated name for touchscreen-fuzz-pressure
+ - x-invert			: deprecated name for touchscreen-inverted-x
+ - y-invert			: deprecated name for touchscreen-inverted-y
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 68edc9d..b2a31ca 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -11,6 +11,10 @@ menuconfig INPUT_TOUCHSCREEN
 
 if INPUT_TOUCHSCREEN
 
+config OF_TOUCHSCREEN
+	def_tristate INPUT
+	depends on INPUT && OF
+
 config TOUCHSCREEN_88PM860X
 	tristate "Marvell 88PM860x touchscreen"
 	depends on MFD_88PM860X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 4bc954b..efa08ae 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -6,6 +6,7 @@
 
 wm97xx-ts-y := wm97xx-core.o
 
+obj-$(CONFIG_OF_TOUCHSCREEN)		+= of_touchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_88PM860X)	+= 88pm860x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_AD7877)	+= ad7877.o
 obj-$(CONFIG_TOUCHSCREEN_AD7879)	+= ad7879.o
diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input/touchscreen/of_touchscreen.c
new file mode 100644
index 0000000..0431b28
--- /dev/null
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -0,0 +1,44 @@
+/*
+ *  Generic DT helper functions for touchscreen devices
+ *
+ *  Copyright (c) 2014 Sebastian Reichel <sre@kernel.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/of.h>
+#include <linux/input.h>
+
+/**
+ * touchscreen_parse_of_params - parse common touchscreen DT properties
+ * @dev: device that should be parsed
+ *
+ * This function parses common DT properties for touchscreens and setups the
+ * input device accordingly. The function keeps previously setuped default
+ * values if no value is specified via DT.
+ */
+void touchscreen_parse_of_params(struct input_dev *dev)
+{
+	struct device_node *np = dev->dev.parent->of_node;
+	struct input_absinfo *absinfo;
+
+	input_alloc_absinfo(dev);
+	if (!dev->absinfo)
+		return;
+
+	absinfo = &dev->absinfo[ABS_X];
+	of_property_read_u32(np, "touchscreen-size-x", &absinfo->maximum);
+	of_property_read_u32(np, "touchscreen-fuzz-x", &absinfo->fuzz);
+
+	absinfo = &dev->absinfo[ABS_Y];
+	of_property_read_u32(np, "touchscreen-size-y", &absinfo->maximum);
+	of_property_read_u32(np, "touchscreen-fuzz-y", &absinfo->fuzz);
+
+	absinfo = &dev->absinfo[ABS_PRESSURE];
+	of_property_read_u32(np, "touchscreen-max-pressure", &absinfo->maximum);
+	of_property_read_u32(np, "touchscreen-fuzz-pressure", &absinfo->fuzz);
+}
+EXPORT_SYMBOL(touchscreen_parse_of_params);
diff --git a/include/linux/input/touchscreen.h b/include/linux/input/touchscreen.h
new file mode 100644
index 0000000..67df6f2
--- /dev/null
+++ b/include/linux/input/touchscreen.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014 Sebastian Reichel <sre@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _TOUCHSCREEN_H
+#define _TOUCHSCREEN_H
+
+#include <linux/input.h>
+
+#if defined(CONFIG_OF)
+void touchscreen_parse_of_params(struct input_dev *dev);
+#else
+static inline void touchscreen_parse_of_params(struct input_dev *dev) {
+	return;
+}
+#endif
+
+#endif
-- 
2.0.0.rc2

