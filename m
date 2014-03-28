Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaC1Rdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:33:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaC1RbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Jason Gerecke <killertofu@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.13 41/46] Input: wacom - add reporting of SW_MUTE_DEVICE events
Date: Fri, 28 Mar 2014 10:32:25 -0700
Message-Id: <20140328173140.256834425@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit 961794a00eab03f4344b7d5e825e8e789e55da87 upstream.

New Intuos series models added a hardware switch to turn touch
data on/off. The state of the switch is reported periodically
from the tablet. To report the state the driver will emit SW_MUTE_DEVICE
events.

Reviewed_by: Chris Bagwell <chris@cnpbagwell.com>
Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Tested-by: Jason Gerecke <killertofu@gmail.com>
Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/wacom_sys.c |   12 ++++++++++++
 drivers/input/tablet/wacom_wac.c |   30 +++++++++++++++++++++++++++---
 drivers/input/tablet/wacom_wac.h |    5 +++++
 3 files changed, 44 insertions(+), 3 deletions(-)

--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1197,6 +1197,8 @@ static void wacom_wireless_work(struct w
 		wacom_wac1->features.device_type = BTN_TOOL_PEN;
 		snprintf(wacom_wac1->name, WACOM_NAME_MAX, "%s (WL) Pen",
 			 wacom_wac1->features.name);
+		wacom_wac1->shared->touch_max = wacom_wac1->features.touch_max;
+		wacom_wac1->shared->type = wacom_wac1->features.type;
 		error = wacom_register_input(wacom1);
 		if (error)
 			goto fail;
@@ -1218,6 +1220,10 @@ static void wacom_wireless_work(struct w
 			error = wacom_register_input(wacom2);
 			if (error)
 				goto fail;
+
+			if (wacom_wac1->features.type == INTUOSHT &&
+			    wacom_wac1->features.touch_max)
+				wacom_wac->shared->touch_input = wacom_wac2->input;
 		}
 
 		error = wacom_initialize_battery(wacom);
@@ -1396,6 +1402,12 @@ static int wacom_probe(struct usb_interf
 			goto fail5;
 		}
 	}
+
+	if (wacom_wac->features.type == INTUOSHT && wacom_wac->features.touch_max) {
+		if (wacom_wac->features.device_type == BTN_TOOL_FINGER)
+			wacom_wac->shared->touch_input = wacom_wac->input;
+	}
+
 	return 0;
 
  fail5: wacom_destroy_leds(wacom);
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1219,13 +1219,23 @@ static int wacom_bpt3_touch(struct wacom
 
 static int wacom_bpt_pen(struct wacom_wac *wacom)
 {
+	struct wacom_features *features = &wacom->features;
 	struct input_dev *input = wacom->input;
 	unsigned char *data = wacom->data;
 	int prox = 0, x = 0, y = 0, p = 0, d = 0, pen = 0, btn1 = 0, btn2 = 0;
 
-	if (data[0] != WACOM_REPORT_PENABLED)
+	if (data[0] != WACOM_REPORT_PENABLED && data[0] != WACOM_REPORT_USB)
 	    return 0;
 
+	if (data[0] == WACOM_REPORT_USB) {
+		if (features->type == INTUOSHT && features->touch_max) {
+			input_report_switch(wacom->shared->touch_input,
+					    SW_MUTE_DEVICE, data[8] & 0x40);
+			input_sync(wacom->shared->touch_input);
+		}
+		return 0;
+	}
+
 	prox = (data[1] & 0x20) == 0x20;
 
 	/*
@@ -1258,8 +1268,8 @@ static int wacom_bpt_pen(struct wacom_wa
 		 * touching and applying pressure; do not report negative
 		 * distance.
 		 */
-		if (data[8] <= wacom->features.distance_max)
-			d = wacom->features.distance_max - data[8];
+		if (data[8] <= features->distance_max)
+			d = features->distance_max - data[8];
 
 		pen = data[1] & 0x01;
 		btn1 = data[1] & 0x02;
@@ -1310,6 +1320,13 @@ static int wacom_wireless_irq(struct wac
 	if (connected) {
 		int pid, battery;
 
+		if ((wacom->shared->type == INTUOSHT) &&
+				wacom->shared->touch_max) {
+			input_report_switch(wacom->shared->touch_input,
+					SW_MUTE_DEVICE, data[5] & 0x40);
+			input_sync(wacom->shared->touch_input);
+		}
+
 		pid = get_unaligned_be16(&data[6]);
 		battery = data[5] & 0x3f;
 		if (wacom->pid != pid) {
@@ -1779,6 +1796,13 @@ int wacom_setup_input_capabilities(struc
 		break;
 
 	case INTUOSHT:
+		if (features->touch_max &&
+		    features->device_type == BTN_TOOL_FINGER) {
+			input_dev->evbit[0] |= BIT_MASK(EV_SW);
+			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
+		}
+		/* fall through */
+
 	case BAMBOO_PT:
 		__clear_bit(ABS_MISC, input_dev->absbit);
 
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -55,6 +55,7 @@
 #define WACOM_REPORT_TPC1FGE		18
 #define WACOM_REPORT_24HDT		1
 #define WACOM_REPORT_WL			128
+#define WACOM_REPORT_USB		192
 
 /* device quirks */
 #define WACOM_QUIRK_MULTI_INPUT		0x0001
@@ -131,6 +132,10 @@ struct wacom_features {
 struct wacom_shared {
 	bool stylus_in_proximity;
 	bool touch_down;
+	/* for wireless device to access USB interfaces */
+	unsigned touch_max;
+	int type;
+	struct input_dev *touch_input;
 };
 
 struct wacom_wac {


