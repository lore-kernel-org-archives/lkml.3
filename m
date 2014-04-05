Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaDEW2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 18:28:00 -0400
Received: from ring0.de ([5.45.105.125]:47590 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaDEW1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 18:27:14 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 1/5] Input: add common DT binding for touchscreens
Date: Sun,  6 Apr 2014 00:26:57 +0200
Message-Id: <1396736821-14395-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396736821-14395-1-git-send-email-sre@kernel.org>
References: <1396736821-14395-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common DT binding documentation for touchscreen devices and
implement input_parse_touchscreen_of_params, which parses the common
properties and configures the input device accordingly.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 .../bindings/input/touchscreen/touchscreen.txt     |  9 ++++++
 drivers/input/input.c                              | 34 ++++++++++++++++++++++
 include/linux/input.h                              |  8 +++++
 3 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt

diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
new file mode 100644
index 0000000..a2ff0a0
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
@@ -0,0 +1,9 @@
+General Touchscreen Properties:
+
+Optional properties for Touchscreens:
+ - touchscreen-size-x		: horizontal resolution of touchscreen
+ - touchscreen-size-y		: vertical resolution of touchscreen
+ - touchscreen-max-pressure	: maximum reported pressure
+ - touchscreen-fuzz-x		: horizontal noise value of the absolute input device
+ - touchscreen-fuzz-y		: vertical noise value of the absolute input device
+ - touchscreen-fuzz-pressure	: pressure noise value of the absolute input device
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1c4c0db..97966d93 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/of.h>
 #include "input-compat.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
@@ -2398,6 +2399,39 @@ void input_free_minor(unsigned int minor)
 }
 EXPORT_SYMBOL(input_free_minor);
 
+#if defined(CONFIG_OF)
+/**
+ * input_parse_touchscreen_of_params - parse common touchscreen DT properties
+ * @dev: device that should be parsed
+ *
+ * This function parses common DT properties for touchscreens and setups the
+ * input device accordingly. The function keeps previously setuped default
+ * values if no value is specified via DT.
+ */
+void input_parse_touchscreen_of_params(struct input_dev *dev)
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
+EXPORT_SYMBOL(input_parse_touchscreen_of_params);
+#endif
+
 static int __init input_init(void)
 {
 	int err;
diff --git a/include/linux/input.h b/include/linux/input.h
index 82ce323..3dc3b1e 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -531,4 +531,12 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+#if defined(CONFIG_OF)
+void input_parse_touchscreen_of_params(struct input_dev *dev);
+#else
+static inline void input_parse_touchscreen_of_params(struct input_dev *dev) {
+	return;
+}
+#endif
+
 #endif
-- 
1.9.1

