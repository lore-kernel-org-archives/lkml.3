Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbbAEW3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:29:00 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:32863 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbbAEW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:28:56 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-kernel@vger.kernel.org, silverhammermba@gmail.com,
        peter.hutterer@who-t.net, hdegoede@redhat.com,
        benjamin.tissoires@gmail.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH v2 4/4] input: synaptics - make semi-mt touchpads report widths
Date: Mon,  5 Jan 2015 23:28:35 +0100
Message-Id: <1420496915-31560-5-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
References: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite claiming to report finger widths, semi-mt touchpads were not
doing it. Make them report widths using ABS_MT_TOUCH_MAJOR instead
of ABS_TOOL_WIDTH.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=77161
Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/input/mouse/synaptics.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 5008e8c..7b95a0b 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -819,6 +819,7 @@ static void synaptics_report_mt_data(struct psmouse *psmouse,
 		input_report_abs(dev, ABS_MT_POSITION_X, pos[i].x);
 		input_report_abs(dev, ABS_MT_POSITION_Y, pos[i].y);
 		input_report_abs(dev, ABS_MT_PRESSURE, hw[i]->z);
+		input_report_abs(dev, ABS_MT_TOUCH_MAJOR, hw[i]->w);
 	}
 
 	input_mt_drop_unused(dev);
@@ -954,8 +955,14 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	}
 	input_report_abs(dev, ABS_PRESSURE, hw.z);
 
-	if (SYN_CAP_PALMDETECT(priv->capabilities))
-		input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
+	if (SYN_CAP_PALMDETECT(priv->capabilities)) {
+		if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c) ||
+		    cr48_profile_sensor)
+			input_set_abs_params(dev,
+					     ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
+		else
+			input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+	}
 
 	input_report_key(dev, BTN_TOOL_FINGER, num_fingers == 1);
 	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
-- 
2.1.4

