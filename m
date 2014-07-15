Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaGOSxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:53:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbaGOSp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:45:56 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 06/23] Input - wacom: split out the pad device for DTUS
Date: Tue, 15 Jul 2014 14:45:29 -0400
Message-Id: <1405449946-11515-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSC_SERIAL can be safely removed from the pad device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Ping Cheng <pingc@wacom.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
---

no changes in v2

 drivers/input/tablet/wacom_wac.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 4a40381..e7ce16e 100644
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
 
@@ -1759,11 +1753,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
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
@@ -1971,6 +1960,11 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 
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
2.0.0

