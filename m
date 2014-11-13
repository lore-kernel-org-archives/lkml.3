Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbaKMOKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:10:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40466 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932975AbaKMOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:10:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 1/4] input: touchscreen: of: Use input_set_abs_params
Date: Thu, 13 Nov 2014 15:06:55 +0100
Message-Id: <1415887618-29844-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415887618-29844-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1415887618-29844-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers are still required to call input_set_abs_params for their axes, as if
they only use the touchscreen_parse_of_params function, the axis bit in absbit
won't be set.

Switch to using input_set_abs_params to fully setup each and every available
axis so that drivers will be able to solely use this function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/input/touchscreen/of_touchscreen.c | 50 ++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input/touchscreen/of_touchscreen.c
index f8f9b84230b1..fe80d8ba7efa 100644
--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -13,6 +13,33 @@
 #include <linux/input.h>
 #include <linux/input/touchscreen.h>
 
+static u32 of_get_optional_u32(struct device_node *np,
+			       const char *property)
+{
+	u32 val = 0;
+
+	of_property_read_u32(np, property, &val);
+
+	return val;
+}
+
+static void touchscreen_set_params(struct input_dev *dev,
+				   unsigned long axis,
+				   int max, int fuzz)
+{
+	struct input_absinfo *absinfo;
+
+	if (!test_bit(axis, dev->absbit)) {
+		dev_warn(&dev->dev,
+			 "DT specifies parameters but the axis is not set up\n");
+		return;
+	}
+
+	absinfo = &dev->absinfo[axis];
+	absinfo->maximum = max;
+	absinfo->fuzz = fuzz;
+}
+
 /**
  * touchscreen_parse_of_params - parse common touchscreen DT properties
  * @dev: device that should be parsed
@@ -24,22 +51,25 @@
 void touchscreen_parse_of_params(struct input_dev *dev)
 {
 	struct device_node *np = dev->dev.parent->of_node;
-	struct input_absinfo *absinfo;
+	u32 maximum, fuzz;
 
 	input_alloc_absinfo(dev);
 	if (!dev->absinfo)
 		return;
 
-	absinfo = &dev->absinfo[ABS_X];
-	of_property_read_u32(np, "touchscreen-size-x", &absinfo->maximum);
-	of_property_read_u32(np, "touchscreen-fuzz-x", &absinfo->fuzz);
+	maximum = of_get_optional_u32(np, "touchscreen-size-x");
+	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-x");
+	if (maximum || fuzz)
+		touchscreen_set_params(dev, ABS_X, maximum, fuzz);
 
-	absinfo = &dev->absinfo[ABS_Y];
-	of_property_read_u32(np, "touchscreen-size-y", &absinfo->maximum);
-	of_property_read_u32(np, "touchscreen-fuzz-y", &absinfo->fuzz);
+	maximum = of_get_optional_u32(np, "touchscreen-size-y");
+	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-y");
+	if (maximum || fuzz)
+		touchscreen_set_params(dev, ABS_Y, maximum, fuzz);
 
-	absinfo = &dev->absinfo[ABS_PRESSURE];
-	of_property_read_u32(np, "touchscreen-max-pressure", &absinfo->maximum);
-	of_property_read_u32(np, "touchscreen-fuzz-pressure", &absinfo->fuzz);
+	maximum = of_get_optional_u32(np, "touchscreen-max-pressure");
+	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-pressure");
+	if (maximum || fuzz)
+		touchscreen_set_params(dev, ABS_PRESSURE, maximum, fuzz);
 }
 EXPORT_SYMBOL(touchscreen_parse_of_params);
-- 
2.1.1

