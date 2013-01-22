Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3AVNka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:40:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3AVNkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:40:25 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 4/4] pwm_backlight: Add support for the whole range of the PWM in DT mode
Date: Tue, 22 Jan 2013 14:39:56 +0100
Message-ID: <1358861996-27194-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting with DT make it possible to use the whole range of the PWM when
controlling the backlight in a same way it is possible when the kernel is
booted in non DT mode.
A new property "max-brightness-level" can be used to specify the maximum
value the PWM can handle (time slots).
DTS files can use either the "brightness-levels" or the "max-brightness-level"
to configure the PWM.
In case both of these properties exist the driver will prefer the
"brightness-levels" over the "max-brightness-level".

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../bindings/video/backlight/pwm-backlight.txt     | 12 +++++++++--
 drivers/video/backlight/pwm_bl.c                   | 24 ++++++++++++++--------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..517924b 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -3,13 +3,21 @@ pwm-backlight bindings
 Required properties:
   - compatible: "pwm-backlight"
   - pwms: OF device-tree PWM specification (see PWM binding[0])
+
+  Brightness range can be configured with either "brightness-levels" or with
+  "max-brightness-level".
   - brightness-levels: Array of distinct brightness levels. Typically these
       are in the range from 0 to 255, but any range starting at 0 will do.
       The actual brightness level (PWM duty cycle) will be interpolated
       from these values. 0 means a 0% duty cycle (darkest/off), while the
       last value in the array represents a 100% duty cycle (brightest).
-  - default-brightness-level: the default brightness level (index into the
-      array defined by the "brightness-levels" property)
+  - max-brightness-level: The maximum brightness level the PWM supports. When
+      the brightness is specified using this property the whole range from 0 to
+      "max-brightness-level" will be available to configure.
+  - default-brightness-level: the default brightness level. With
+      "brightness-levels" it is an index into the array defined by the
+      "brightness-levels" property. When it is used with "max-brightness-level"
+      it is the value in the range from 0 to "max-brightness-level"
 
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index df2d115..c0e4bc7 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -111,10 +111,17 @@ static int pwm_backlight_parse_dt(struct device *dev,
 
 	/* determine the number of brightness levels */
 	prop = of_find_property(node, "brightness-levels", &num_levels);
-	if (!prop)
-		return -EINVAL;
+	if (!prop) {
+		/* Levels not provided, look for the maximum property */
+		ret = of_property_read_u32(node, "max-brightness-level",
+					   &value);
+		if (ret < 0)
+			return ret;
 
-	num_levels /= sizeof(u32);
+		data->max_brightness = value;
+	} else {
+		num_levels /= sizeof(u32);
+	}
 
 	/* read brightness levels from DT property */
 	if (num_levels > 0) {
@@ -130,14 +137,13 @@ static int pwm_backlight_parse_dt(struct device *dev,
 			return ret;
 
 		data->max_brightness = num_levels;
+	}
 
-		ret = of_property_read_u32(node, "default-brightness-level",
-					   &value);
-		if (ret < 0)
-			return ret;
+	ret = of_property_read_u32(node, "default-brightness-level", &value);
+	if (ret < 0)
+		return ret;
 
-		data->dft_brightness = value;
-	}
+	data->dft_brightness = value;
 
 	/*
 	 * TODO: Most users of this driver use a number of GPIOs to control
-- 
1.8.1.1

