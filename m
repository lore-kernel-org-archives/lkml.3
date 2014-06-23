Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbaFWU5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:57:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbaFWU5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:57:33 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 2/5] Input - wacom: split out the pad device for Intuos/Cintiq
Date: Mon, 23 Jun 2014 16:57:16 -0400
Message-Id: <1403557039-1487-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSC_SERIAL can be safely dropped for pad input devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_wac.c | 208 +++++++++++++++++++++++----------------
 1 file changed, 122 insertions(+), 86 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 4b16a34..8807ab5 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -584,6 +584,7 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 
 	/* pad packets. Works as a second tool and is always in prox */
 	if (data[0] == WACOM_REPORT_INTUOSPAD || data[0] == WACOM_REPORT_INTUOS5PAD) {
+		input = wacom->pad_input;
 		if (features->type >= INTUOS4S && features->type <= INTUOS4L) {
 			input_report_key(input, BTN_0, (data[2] & 0x01));
 			input_report_key(input, BTN_1, (data[3] & 0x01));
@@ -773,7 +774,6 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 				input_report_abs(input, ABS_MISC, 0);
 			}
 		}
-		input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
                 return 1;
 	}
 
@@ -1656,61 +1656,20 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 		break;
 
 	case WACOM_24HD:
-		__set_bit(BTN_A, input_dev->keybit);
-		__set_bit(BTN_B, input_dev->keybit);
-		__set_bit(BTN_C, input_dev->keybit);
-		__set_bit(BTN_X, input_dev->keybit);
-		__set_bit(BTN_Y, input_dev->keybit);
-		__set_bit(BTN_Z, input_dev->keybit);
-
-		for (i = 6; i < 10; i++)
-			__set_bit(BTN_0 + i, input_dev->keybit);
-
-		__set_bit(KEY_PROG1, input_dev->keybit);
-		__set_bit(KEY_PROG2, input_dev->keybit);
-		__set_bit(KEY_PROG3, input_dev->keybit);
-
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 		input_set_abs_params(input_dev, ABS_THROTTLE, 0, 71, 0, 0);
 		/* fall through */
 
 	case DTK:
-		for (i = 0; i < 6; i++)
-			__set_bit(BTN_0 + i, input_dev->keybit);
-
 		__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
 
 		wacom_setup_cintiq(wacom_wac);
 		break;
 
 	case WACOM_22HD:
-		__set_bit(KEY_PROG1, input_dev->keybit);
-		__set_bit(KEY_PROG2, input_dev->keybit);
-		__set_bit(KEY_PROG3, input_dev->keybit);
-		/* fall through */
-
 	case WACOM_21UX2:
-		__set_bit(BTN_A, input_dev->keybit);
-		__set_bit(BTN_B, input_dev->keybit);
-		__set_bit(BTN_C, input_dev->keybit);
-		__set_bit(BTN_X, input_dev->keybit);
-		__set_bit(BTN_Y, input_dev->keybit);
-		__set_bit(BTN_Z, input_dev->keybit);
-		__set_bit(BTN_BASE, input_dev->keybit);
-		__set_bit(BTN_BASE2, input_dev->keybit);
-		/* fall through */
-
 	case WACOM_BEE:
-		__set_bit(BTN_8, input_dev->keybit);
-		__set_bit(BTN_9, input_dev->keybit);
-		/* fall through */
-
 	case CINTIQ:
-		for (i = 0; i < 8; i++)
-			__set_bit(BTN_0 + i, input_dev->keybit);
-
-		input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
-		input_set_abs_params(input_dev, ABS_RY, 0, 4096, 0, 0);
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 
 		__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
@@ -1719,9 +1678,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 		break;
 
 	case WACOM_13HD:
-		for (i = 0; i < 9; i++)
-			__set_bit(BTN_0 + i, input_dev->keybit);
-
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 		__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
 		wacom_setup_cintiq(wacom_wac);
@@ -1729,21 +1685,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 	case INTUOS3:
 	case INTUOS3L:
-		__set_bit(BTN_4, input_dev->keybit);
-		__set_bit(BTN_5, input_dev->keybit);
-		__set_bit(BTN_6, input_dev->keybit);
-		__set_bit(BTN_7, input_dev->keybit);
-
-		input_set_abs_params(input_dev, ABS_RY, 0, 4096, 0, 0);
-		/* fall through */
-
 	case INTUOS3S:
-		__set_bit(BTN_0, input_dev->keybit);
-		__set_bit(BTN_1, input_dev->keybit);
-		__set_bit(BTN_2, input_dev->keybit);
-		__set_bit(BTN_3, input_dev->keybit);
-
-		input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 		/* fall through */
 
@@ -1757,20 +1699,11 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 	case INTUOS5L:
 	case INTUOSPM:
 	case INTUOSPL:
-		if (features->device_type == BTN_TOOL_PEN) {
-			__set_bit(BTN_7, input_dev->keybit);
-			__set_bit(BTN_8, input_dev->keybit);
-		}
-		/* fall through */
-
 	case INTUOS5S:
 	case INTUOSPS:
 		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
 
 		if (features->device_type == BTN_TOOL_PEN) {
-			for (i = 0; i < 7; i++)
-				__set_bit(BTN_0 + i, input_dev->keybit);
-
 			input_set_abs_params(input_dev, ABS_DISTANCE, 0,
 					      features->distance_max,
 					      0, 0);
@@ -1791,14 +1724,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 	case INTUOS4:
 	case INTUOS4L:
-		__set_bit(BTN_7, input_dev->keybit);
-		__set_bit(BTN_8, input_dev->keybit);
-		/* fall through */
-
 	case INTUOS4S:
-		for (i = 0; i < 7; i++)
-			__set_bit(BTN_0 + i, input_dev->keybit);
-
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 		wacom_setup_intuos(wacom_wac);
 
@@ -1922,17 +1848,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 		break;
 
 	case CINTIQ_HYBRID:
-		__set_bit(BTN_1, input_dev->keybit);
-		__set_bit(BTN_2, input_dev->keybit);
-		__set_bit(BTN_3, input_dev->keybit);
-		__set_bit(BTN_4, input_dev->keybit);
-
-		__set_bit(BTN_5, input_dev->keybit);
-		__set_bit(BTN_6, input_dev->keybit);
-		__set_bit(BTN_7, input_dev->keybit);
-		__set_bit(BTN_8, input_dev->keybit);
-		__set_bit(BTN_0, input_dev->keybit);
-
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 		__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
 
@@ -1946,6 +1861,7 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 				   struct wacom_wac *wacom_wac)
 {
 	struct wacom_features *features = &wacom_wac->features;
+	int i;
 
 	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
@@ -1957,6 +1873,126 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 	input_set_abs_params(input_dev, ABS_Y, 0, 1, 0, 0);
 
 	switch (features->type) {
+	case WACOM_24HD:
+		__set_bit(BTN_A, input_dev->keybit);
+		__set_bit(BTN_B, input_dev->keybit);
+		__set_bit(BTN_C, input_dev->keybit);
+		__set_bit(BTN_X, input_dev->keybit);
+		__set_bit(BTN_Y, input_dev->keybit);
+		__set_bit(BTN_Z, input_dev->keybit);
+
+		for (i = 0; i < 10; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		__set_bit(KEY_PROG1, input_dev->keybit);
+		__set_bit(KEY_PROG2, input_dev->keybit);
+		__set_bit(KEY_PROG3, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
+		input_set_abs_params(input_dev, ABS_THROTTLE, 0, 71, 0, 0);
+		break;
+
+	case DTK:
+		for (i = 0; i < 6; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		break;
+
+	case WACOM_22HD:
+		__set_bit(KEY_PROG1, input_dev->keybit);
+		__set_bit(KEY_PROG2, input_dev->keybit);
+		__set_bit(KEY_PROG3, input_dev->keybit);
+		/* fall through */
+
+	case WACOM_21UX2:
+		__set_bit(BTN_A, input_dev->keybit);
+		__set_bit(BTN_B, input_dev->keybit);
+		__set_bit(BTN_C, input_dev->keybit);
+		__set_bit(BTN_X, input_dev->keybit);
+		__set_bit(BTN_Y, input_dev->keybit);
+		__set_bit(BTN_Z, input_dev->keybit);
+		__set_bit(BTN_BASE, input_dev->keybit);
+		__set_bit(BTN_BASE2, input_dev->keybit);
+		/* fall through */
+
+	case WACOM_BEE:
+		__set_bit(BTN_8, input_dev->keybit);
+		__set_bit(BTN_9, input_dev->keybit);
+		/* fall through */
+
+	case CINTIQ:
+		for (i = 0; i < 8; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
+		input_set_abs_params(input_dev, ABS_RY, 0, 4096, 0, 0);
+		break;
+
+	case WACOM_13HD:
+		for (i = 0; i < 9; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
+		break;
+
+	case INTUOS3:
+	case INTUOS3L:
+		__set_bit(BTN_4, input_dev->keybit);
+		__set_bit(BTN_5, input_dev->keybit);
+		__set_bit(BTN_6, input_dev->keybit);
+		__set_bit(BTN_7, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_RY, 0, 4096, 0, 0);
+		/* fall through */
+
+	case INTUOS3S:
+		__set_bit(BTN_0, input_dev->keybit);
+		__set_bit(BTN_1, input_dev->keybit);
+		__set_bit(BTN_2, input_dev->keybit);
+		__set_bit(BTN_3, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
+		break;
+
+	case INTUOS5:
+	case INTUOS5L:
+	case INTUOSPM:
+	case INTUOSPL:
+		__set_bit(BTN_7, input_dev->keybit);
+		__set_bit(BTN_8, input_dev->keybit);
+		/* fall through */
+
+	case INTUOS5S:
+	case INTUOSPS:
+		/* touch interface does not have the pad device */
+		if (features->device_type != BTN_TOOL_PEN)
+			return 1;
+
+		for (i = 0; i < 7; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
+		break;
+
+	case INTUOS4:
+	case INTUOS4L:
+		__set_bit(BTN_7, input_dev->keybit);
+		__set_bit(BTN_8, input_dev->keybit);
+		/* fall through */
+
+	case INTUOS4S:
+		for (i = 0; i < 7; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
+		break;
+
+	case CINTIQ_HYBRID:
+		for (i = 0; i < 9; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+
+		break;
+
 	default:
 		/* no pad supported */
 		return 1;
-- 
1.9.0

