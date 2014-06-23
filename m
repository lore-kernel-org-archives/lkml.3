Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaFWU5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbaFWU5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:57:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 4/5] Input - wacom: split out the pad device for DTUS
Date: Mon, 23 Jun 2014 16:57:18 -0400
Message-Id: <1403557039-1487-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSC_SERIAL can be safely removed from the pad device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_wac.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 5aaa3d2..d3aef3a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -217,17 +217,13 @@ static int wacom_dtus_irq(struct wacom_wac *wacom)
 			"%s: received unknown report #%d", __func__, data[0]);
 		return 0;
 	} else if (data[0] == WACOM_REPORT_DTUSPAD) {
+		input = wacom->pad_input;
 		input_report_key(input, BTN_0, (data[1] & 0x01));
 		input_report_key(input, BTN_1, (data[1] & 0x02));
 		input_report_key(input, BTN_2, (data[1] & 0x04));
 		input_report_key(input, BTN_3, (data[1] & 0x08));
 		input_report_abs(input, ABS_MISC,
 				 data[1] & 0x0f ? PAD_DEVICE_ID : 0);
-		/*
-		 * Serial number is required when expresskeys are
-		 * reported through pen interface.
-		 */
-		input_event(input, EV_MSC, MSC_SERIAL, 0xf0);
 		return 1;
 	} else {
 		prox = data[1] & 0x80;
@@ -257,7 +253,6 @@ static int wacom_dtus_irq(struct wacom_wac *wacom)
 			wacom->id[0] = 0;
 		input_report_key(input, wacom->tool[0], prox);
 		input_report_abs(input, ABS_MISC, wacom->id[0]);
-		input_event(input, EV_MSC, MSC_SERIAL, 1);
 		return 1;
 	}
 }
@@ -1615,7 +1610,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 				   struct wacom_wac *wacom_wac)
 {
 	struct wacom_features *features = &wacom_wac->features;
-	int i;
 
 	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
@@ -1765,11 +1759,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 	case DTUS:
 	case PL:
 	case DTU:
-		if (features->type == DTUS) {
-			input_set_capability(input_dev, EV_MSC, MSC_SERIAL);
-			for (i = 0; i < 4; i++)
-				__set_bit(BTN_0 + i, input_dev->keybit);
-		}
 		__set_bit(BTN_TOOL_PEN, input_dev->keybit);
 		__set_bit(BTN_TOOL_RUBBER, input_dev->keybit);
 		__set_bit(BTN_STYLUS, input_dev->keybit);
@@ -1985,6 +1974,11 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 
 		break;
 
+	case DTUS:
+		for (i = 0; i < 4; i++)
+			__set_bit(BTN_0 + i, input_dev->keybit);
+		break;
+
 	case INTUOSHT:
 	case BAMBOO_PT:
 		/* pad device is on the touch interface */
-- 
1.9.0

