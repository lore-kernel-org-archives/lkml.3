Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaL0LcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 06:32:04 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62693 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaL0Lb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 06:31:57 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        silverhammermba@gmail.com, Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 1/2] input: synaptics - make image sensors report ABS_MT_TOUCH_MAJOR
Date: Sat, 27 Dec 2014 12:31:28 +0100
Message-Id: <1419679889-6582-2-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com>
References: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite claiming to be able to report ABS_TOOL_WIDTH, image sensors
were not doing it. Make them report widths and use ABS_MT_TOUCH_MAJOR
instead ABS_TOOL_WIDTH.

Since the 'w' slot is used to report the finger count when two or more
fingers are on the touchpad, make sure that only meaningful values are
emitted, i.e. values greater than or equal to 4, and assign the correct
range to ABS_MT_TOUCH_MAJOR.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=77161
Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/input/mouse/synaptics.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index f947292..ea0563e 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -814,6 +814,8 @@ static void synaptics_report_slot(struct input_dev *dev, int slot,
 	input_report_abs(dev, ABS_MT_POSITION_X, hw->x);
 	input_report_abs(dev, ABS_MT_POSITION_Y, synaptics_invert_y(hw->y));
 	input_report_abs(dev, ABS_MT_PRESSURE, hw->z);
+	if (hw->w >= 4)
+		input_report_abs(dev, ABS_MT_TOUCH_MAJOR, hw->w);
 }
 
 static void synaptics_report_mt_data(struct psmouse *psmouse,
@@ -1462,8 +1464,13 @@ static void set_input_params(struct psmouse *psmouse,
 					INPUT_MT_TRACK : INPUT_MT_SEMI_MT));
 	}
 
-	if (SYN_CAP_PALMDETECT(priv->capabilities))
-		input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+	if (SYN_CAP_PALMDETECT(priv->capabilities)) {
+		if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c))
+			input_set_abs_params(dev,
+					     ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
+		else
+			input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+	}
 
 	__set_bit(BTN_TOUCH, dev->keybit);
 	__set_bit(BTN_TOOL_FINGER, dev->keybit);
-- 
2.1.4

