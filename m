Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaFWU6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:58:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbaFWU5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:57:36 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 5/5] Input - wacom: split out the pad device for Graphire G4 and MO
Date: Mon, 23 Jun 2014 16:57:19 -0400
Message-Id: <1403557039-1487-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSC_SERIAL can be safely removed from pad devices. If it is not
here, xf86-input-wacom correctly generates ones for its internal
use.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_wac.c | 44 ++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index d3aef3a..f170277 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -262,6 +262,7 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
 	struct wacom_features *features = &wacom->features;
 	unsigned char *data = wacom->data;
 	struct input_dev *input = wacom->input;
+	struct input_dev *pad_input = wacom->pad_input;
 	int prox;
 	int rw = 0;
 	int retval = 0;
@@ -322,7 +323,6 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
 			wacom->id[0] = 0;
 		input_report_abs(input, ABS_MISC, wacom->id[0]); /* report tool id */
 		input_report_key(input, wacom->tool[0], prox);
-		input_event(input, EV_MSC, MSC_SERIAL, 1);
 		input_sync(input); /* sync last event */
 	}
 
@@ -332,14 +332,13 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
 		prox = data[7] & 0xf8;
 		if (prox || wacom->id[1]) {
 			wacom->id[1] = PAD_DEVICE_ID;
-			input_report_key(input, BTN_BACK, (data[7] & 0x40));
-			input_report_key(input, BTN_FORWARD, (data[7] & 0x80));
+			input_report_key(pad_input, BTN_BACK, (data[7] & 0x40));
+			input_report_key(pad_input, BTN_FORWARD, (data[7] & 0x80));
 			rw = ((data[7] & 0x18) >> 3) - ((data[7] & 0x20) >> 3);
-			input_report_rel(input, REL_WHEEL, rw);
+			input_report_rel(pad_input, REL_WHEEL, rw);
 			if (!prox)
 				wacom->id[1] = 0;
-			input_report_abs(input, ABS_MISC, wacom->id[1]);
-			input_event(input, EV_MSC, MSC_SERIAL, 0xf0);
+			input_report_abs(pad_input, ABS_MISC, wacom->id[1]);
 			retval = 1;
 		}
 		break;
@@ -348,15 +347,14 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
 		prox = (data[7] & 0xf8) || data[8];
 		if (prox || wacom->id[1]) {
 			wacom->id[1] = PAD_DEVICE_ID;
-			input_report_key(input, BTN_BACK, (data[7] & 0x08));
-			input_report_key(input, BTN_LEFT, (data[7] & 0x20));
-			input_report_key(input, BTN_FORWARD, (data[7] & 0x10));
-			input_report_key(input, BTN_RIGHT, (data[7] & 0x40));
-			input_report_abs(input, ABS_WHEEL, (data[8] & 0x7f));
+			input_report_key(pad_input, BTN_BACK, (data[7] & 0x08));
+			input_report_key(pad_input, BTN_LEFT, (data[7] & 0x20));
+			input_report_key(pad_input, BTN_FORWARD, (data[7] & 0x10));
+			input_report_key(pad_input, BTN_RIGHT, (data[7] & 0x40));
+			input_report_abs(pad_input, ABS_WHEEL, (data[8] & 0x7f));
 			if (!prox)
 				wacom->id[1] = 0;
-			input_report_abs(input, ABS_MISC, wacom->id[1]);
-			input_event(input, EV_MSC, MSC_SERIAL, 0xf0);
+			input_report_abs(pad_input, ABS_MISC, wacom->id[1]);
 			retval = 1;
 		}
 		break;
@@ -1624,10 +1622,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 		/* fall through */
 
 	case WACOM_G4:
-		input_set_capability(input_dev, EV_MSC, MSC_SERIAL);
-
-		__set_bit(BTN_BACK, input_dev->keybit);
-		__set_bit(BTN_FORWARD, input_dev->keybit);
 		/* fall through */
 
 	case GRAPHIRE:
@@ -1854,6 +1848,22 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 	input_set_abs_params(input_dev, ABS_Y, 0, 1, 0, 0);
 
 	switch (features->type) {
+	case WACOM_MO:
+		__set_bit(BTN_BACK, input_dev->keybit);
+		__set_bit(BTN_LEFT, input_dev->keybit);
+		__set_bit(BTN_FORWARD, input_dev->keybit);
+		__set_bit(BTN_RIGHT, input_dev->keybit);
+		input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
+		break;
+
+	case WACOM_G4:
+		__set_bit(BTN_BACK, input_dev->keybit);
+		__set_bit(BTN_LEFT, input_dev->keybit);
+		__set_bit(BTN_FORWARD, input_dev->keybit);
+		__set_bit(BTN_RIGHT, input_dev->keybit);
+		input_set_capability(input_dev, EV_REL, REL_WHEEL);
+		break;
+
 	case WACOM_24HD:
 		__set_bit(BTN_A, input_dev->keybit);
 		__set_bit(BTN_B, input_dev->keybit);
-- 
1.9.0

