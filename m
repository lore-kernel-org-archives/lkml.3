Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbaDBUSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:18:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42859 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758922AbaDBUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ping Cheng <pinglinux@gmail.com>,
        Ping Cheng <pingc@wacom.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 24/40] Input: wacom - add support for three new Intuos Pro devices
Date: Wed,  2 Apr 2014 22:13:10 +0200
Message-Id: <80c4a86393bd91aea6d6ef4966fdf49455f432b3.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ping Cheng <pinglinux@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b5fd2a3e92ca5c8c1f3c20d31ac5daed3ec4d604 upstream.

Two tablets in this series support both pen and touch. One (Intuos S)
only supports pen. This patch also updates the driver to process wireless
devices that do not support touch interface.

Tested-by: Jason Gerecke <killertofu@gmail.com>
Acked-by: Chris Bagwell <chris@cnpbagwell.com>
Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/tablet/wacom_sys.c | 10 +++++--
 drivers/input/tablet/wacom_wac.c | 61 +++++++++++++++++++++++++++++++---------
 drivers/input/tablet/wacom_wac.h |  3 ++
 3 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index a6debe13d5b9..44a1fb6fa4a0 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -722,7 +722,7 @@ static int wacom_led_control(struct wacom *wacom)
 		return -ENOMEM;
 
 	if (wacom->wacom_wac.features.type >= INTUOS5S &&
-	    wacom->wacom_wac.features.type <= INTUOS5L)	{
+	    wacom->wacom_wac.features.type <= INTUOSPL)	{
 		/*
 		 * Touch Ring and crop mark LED luminance may take on
 		 * one of four values:
@@ -984,6 +984,9 @@ static int wacom_initialize_leds(struct wacom *wacom)
 	case INTUOS5S:
 	case INTUOS5:
 	case INTUOS5L:
+	case INTUOSPS:
+	case INTUOSPM:
+	case INTUOSPL:
 		wacom->led.select[0] = 0;
 		wacom->led.select[1] = 0;
 		wacom->led.llv = 32;
@@ -1027,6 +1030,9 @@ static void wacom_destroy_leds(struct wacom *wacom)
 	case INTUOS5S:
 	case INTUOS5:
 	case INTUOS5L:
+	case INTUOSPS:
+	case INTUOSPM:
+	case INTUOSPL:
 		sysfs_remove_group(&wacom->intf->dev.kobj,
 				   &intuos5_led_attr_group);
 		break;
@@ -1305,7 +1311,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	 * HID descriptor. If this is the touch interface (wMaxPacketSize
 	 * of WACOM_PKGLEN_BBTOUCH3), override the table values.
 	 */
-	if (features->type >= INTUOS5S && features->type <= INTUOS5L) {
+	if (features->type >= INTUOS5S && features->type <= INTUOSPL) {
 		if (endpoint->wMaxPacketSize == WACOM_PKGLEN_BBTOUCH3) {
 			features->device_type = BTN_TOOL_FINGER;
 			features->pktlen = WACOM_PKGLEN_BBTOUCH3;
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index c59b797eeafa..0091bdedb240 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -621,14 +621,14 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 			} else {
 				input_report_abs(input, ABS_MISC, 0);
 			}
-		} else if (features->type >= INTUOS5S && features->type <= INTUOS5L) {
+		} else if (features->type >= INTUOS5S && features->type <= INTUOSPL) {
 			int i;
 
 			/* Touch ring mode switch has no capacitive sensor */
 			input_report_key(input, BTN_0, (data[3] & 0x01));
 
 			/*
-			 * ExpressKeys on Intuos5 have a capacitive sensor in
+			 * ExpressKeys on Intuos5/Intuos Pro have a capacitive sensor in
 			 * addition to the mechanical switch. Switch data is
 			 * stored in data[4], capacitive data in data[5].
 			 */
@@ -716,7 +716,9 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 	     features->type == INTUOS4 ||
 	     features->type == INTUOS4S ||
 	     features->type == INTUOS5 ||
-	     features->type == INTUOS5S)) {
+	     features->type == INTUOS5S ||
+	     features->type == INTUOSPM ||
+	     features->type == INTUOSPS)) {
 
 		return 0;
 	}
@@ -769,8 +771,7 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 
 		} else if (wacom->tool[idx] == BTN_TOOL_MOUSE) {
 			/* I4 mouse */
-			if ((features->type >= INTUOS4S && features->type <= INTUOS4L) ||
-			    (features->type >= INTUOS5S && features->type <= INTUOS5L)) {
+			if (features->type >= INTUOS4S && features->type <= INTUOSPL) {
 				input_report_key(input, BTN_LEFT,   data[6] & 0x01);
 				input_report_key(input, BTN_MIDDLE, data[6] & 0x02);
 				input_report_key(input, BTN_RIGHT,  data[6] & 0x04);
@@ -797,7 +798,8 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 				}
 			}
 		} else if ((features->type < INTUOS3S || features->type == INTUOS3L ||
-				features->type == INTUOS4L || features->type == INTUOS5L) &&
+				features->type == INTUOS4L || features->type == INTUOS5L ||
+				features->type == INTUOSPL) &&
 			   wacom->tool[idx] == BTN_TOOL_LENS) {
 			/* Lens cursor packets */
 			input_report_key(input, BTN_LEFT,   data[8] & 0x01);
@@ -1107,6 +1109,7 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 
 static void wacom_bpt3_touch_msg(struct wacom_wac *wacom, unsigned char *data)
 {
+	struct wacom_features *features = &wacom->features;
 	struct input_dev *input = wacom->input;
 	bool touch = data[1] & 0x80;
 	int slot = input_mt_get_slot_by_key(input, data[0]);
@@ -1122,14 +1125,23 @@ static void wacom_bpt3_touch_msg(struct wacom_wac *wacom, unsigned char *data)
 	if (touch) {
 		int x = (data[2] << 4) | (data[4] >> 4);
 		int y = (data[3] << 4) | (data[4] & 0x0f);
-		int a = data[5];
+		int width, height;
 
-		// "a" is a scaled-down area which we assume is roughly
-		// circular and which can be described as: a=(pi*r^2)/C.
-		int x_res  = input_abs_get_res(input, ABS_X);
-		int y_res  = input_abs_get_res(input, ABS_Y);
-		int width  = 2 * int_sqrt(a * WACOM_CONTACT_AREA_SCALE);
-		int height = width * y_res / x_res;
+		if (features->type >= INTUOSPS && features->type <= INTUOSPL) {
+			width  = data[5];
+			height = data[6];
+		} else {
+			/*
+			 * "a" is a scaled-down area which we assume is
+			 * roughly circular and which can be described as:
+			 * a=(pi*r^2)/C.
+			 */
+			int a = data[5];
+			int x_res  = input_abs_get_res(input, ABS_X);
+			int y_res  = input_abs_get_res(input, ABS_Y);
+			width  = 2 * int_sqrt(a * WACOM_CONTACT_AREA_SCALE);
+			height = width * y_res / x_res;
+		}
 
 		input_report_abs(input, ABS_MT_POSITION_X, x);
 		input_report_abs(input, ABS_MT_POSITION_Y, y);
@@ -1337,6 +1349,9 @@ void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
 	case INTUOS5S:
 	case INTUOS5:
 	case INTUOS5L:
+	case INTUOSPS:
+	case INTUOSPM:
+	case INTUOSPL:
 		if (len == WACOM_PKGLEN_BBTOUCH3)
 			sync = wacom_bpt3_touch(wacom_wac);
 		else
@@ -1420,7 +1435,7 @@ void wacom_setup_device_quirks(struct wacom_features *features)
 
 	/* these device have multiple inputs */
 	if (features->type >= WIRELESS ||
-	    (features->type >= INTUOS5S && features->type <= INTUOS5L) ||
+	    (features->type >= INTUOS5S && features->type <= INTUOSPL) ||
 	    (features->oVid && features->oPid))
 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
 
@@ -1627,6 +1642,8 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 	case INTUOS5:
 	case INTUOS5L:
+	case INTUOSPM:
+	case INTUOSPL:
 		if (features->device_type == BTN_TOOL_PEN) {
 			__set_bit(BTN_7, input_dev->keybit);
 			__set_bit(BTN_8, input_dev->keybit);
@@ -1634,6 +1651,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 		/* fall through */
 
 	case INTUOS5S:
+	case INTUOSPS:
 		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
 
 		if (features->device_type == BTN_TOOL_PEN) {
@@ -1952,6 +1970,18 @@ static const struct wacom_features wacom_features_0x29 =
 static const struct wacom_features wacom_features_0x2A =
 	{ "Wacom Intuos5 M", WACOM_PKGLEN_INTUOS,  44704, 27940, 2047,
 	  63, INTUOS5, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
+static const struct wacom_features wacom_features_0x314 =
+	{ "Wacom Intuos Pro S", WACOM_PKGLEN_INTUOS,  31496, 19685, 2047,
+	  63, INTUOSPS, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES,
+	  .touch_max = 16 };
+static const struct wacom_features wacom_features_0x315 =
+	{ "Wacom Intuos Pro M", WACOM_PKGLEN_INTUOS,  44704, 27940, 2047,
+	  63, INTUOSPM, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES,
+	  .touch_max = 16 };
+static const struct wacom_features wacom_features_0x317 =
+	{ "Wacom Intuos Pro L", WACOM_PKGLEN_INTUOS,  65024, 40640, 2047,
+	  63, INTUOSPL, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES,
+	  .touch_max = 16 };
 static const struct wacom_features wacom_features_0xF4 =
 	{ "Wacom Cintiq 24HD",       WACOM_PKGLEN_INTUOS,   104480, 65600, 2047,
 	  63, WACOM_24HD, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
@@ -2259,6 +2289,9 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x300) },
 	{ USB_DEVICE_WACOM(0x301) },
 	{ USB_DEVICE_WACOM(0x304) },
+	{ USB_DEVICE_DETAILED(0x314, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_DETAILED(0x315, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_DETAILED(0x317, USB_CLASS_HID, 0, 0) },
 	{ USB_DEVICE_WACOM(0x4001) },
 	{ USB_DEVICE_WACOM(0x47) },
 	{ USB_DEVICE_WACOM(0xF4) },
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index dfc9e08e7f70..d6dec5800791 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -76,6 +76,9 @@ enum {
 	INTUOS5S,
 	INTUOS5,
 	INTUOS5L,
+	INTUOSPS,
+	INTUOSPM,
+	INTUOSPL,
 	WACOM_21UX2,
 	WACOM_22HD,
 	DTK,
-- 
1.9.1

