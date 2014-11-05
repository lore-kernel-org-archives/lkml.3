Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaKEPKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:10:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42425 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134AbaKEPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:10:03 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/3] input: touchscreen: of: Use input_set_abs_params
Date: Wed,  5 Nov 2014 16:07:48 +0100
Message-Id: <1415200070-19346-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/input/touchscreen/of_touchscreen.c | 33 +++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input/touchscreen/of_touchscreen.c
index f8f9b84230b1..74d6b0eb50ac 100644
--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -13,6 +13,16 @@
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
 /**
  * touchscreen_parse_of_params - parse common touchscreen DT properties
  * @dev: device that should be parsed
@@ -24,22 +34,25 @@
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
+		input_set_abs_params(dev, ABS_X, 0, maximum, fuzz, 0);
 
-	absinfo = &dev->absinfo[ABS_Y];
-	of_property_read_u32(np, "touchscreen-size-y", &absinfo->maximum);
-	of_property_read_u32(np, "touchscreen-fuzz-y", &absinfo->fuzz);
+	maximum = of_get_optional_u32(np, "touchscreen-size-y");
+	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-y");
+	if (maximum || fuzz)
+		input_set_abs_params(dev, ABS_Y, 0, maximum, fuzz, 0);
 
-	absinfo = &dev->absinfo[ABS_PRESSURE];
-	of_property_read_u32(np, "touchscreen-max-pressure", &absinfo->maximum);
-	of_property_read_u32(np, "touchscreen-fuzz-pressure", &absinfo->fuzz);
+	maximum = of_get_optional_u32(np, "touchscreen-max-pressure");
+	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-pressure");
+	if (maximum || fuzz)
+		input_set_abs_params(dev, ABS_PRESSURE, 0, maximum, fuzz, 0);
 }
 EXPORT_SYMBOL(touchscreen_parse_of_params);
-- 
2.1.1

