Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbaJ3SdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbaJ3SdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:33:18 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Input: synaptics: remove duplicated code
Date: Thu, 30 Oct 2014 14:33:07 -0400
Message-Id: <1414693987-6059-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1414693987-6059-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1414693987-6059-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synaptics_profile_sensor_process() and synaptics_report_mt_data() now
share the exact same code. Remove one implementation and rely on the
other where it was used.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/mouse/synaptics.c | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index fd89249..8ae1841 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -851,42 +851,6 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
 	synaptics_report_mt_data(psmouse, sgm, num_fingers);
 }
 
-static void synaptics_profile_sensor_process(struct psmouse *psmouse,
-					     struct synaptics_hw_state *sgm,
-					     int num_fingers)
-{
-	struct input_dev *dev = psmouse->dev;
-	struct synaptics_data *priv = psmouse->private;
-	struct synaptics_hw_state *hw[2] = { sgm, &priv->agm };
-	struct input_mt_pos pos[2];
-	int slot[2], nsemi, i;
-
-	nsemi = clamp_val(num_fingers, 0, 2);
-
-	for (i = 0; i < nsemi; i++) {
-		pos[i].x = hw[i]->x;
-		pos[i].y = synaptics_invert_y(hw[i]->y);
-	}
-
-	input_mt_assign_slots(dev, slot, pos, nsemi);
-
-	for (i = 0; i < nsemi; i++) {
-		input_mt_slot(dev, slot[i]);
-		input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
-		input_report_abs(dev, ABS_MT_POSITION_X, pos[i].x);
-		input_report_abs(dev, ABS_MT_POSITION_Y, pos[i].y);
-		input_report_abs(dev, ABS_MT_PRESSURE, hw[i]->z);
-	}
-
-	input_mt_drop_unused(dev);
-	input_mt_report_pointer_emulation(dev, false);
-	input_mt_report_finger_count(dev, num_fingers);
-
-	synaptics_report_buttons(psmouse, sgm);
-
-	input_sync(dev);
-}
-
 /*
  *  called for each full received packet from the touchpad
  */
@@ -951,7 +915,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	}
 
 	if (cr48_profile_sensor) {
-		synaptics_profile_sensor_process(psmouse, &hw, num_fingers);
+		synaptics_report_mt_data(psmouse, &hw, num_fingers);
 		return;
 	}
 
-- 
2.1.0

