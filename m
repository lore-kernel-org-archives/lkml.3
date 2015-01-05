Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbbAEW2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:28:55 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:54094 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbbAEW2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:28:52 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-kernel@vger.kernel.org, silverhammermba@gmail.com,
        peter.hutterer@who-t.net, hdegoede@redhat.com,
        benjamin.tissoires@gmail.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH v2 2/4] input: synaptics - fix width values calculation on image sensors
Date: Mon,  5 Jan 2015 23:28:33 +0100
Message-Id: <1420496915-31560-3-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
References: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple fingers are on the touchpad, W reports the finger
count rather than the width. Retrieve the correct value that is
encoded in X, Y and Z of AGM and SGM packets.

The minimum width reported is 8 rather than 4 in this case, while the
maximum remains 15.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/input/mouse/synaptics.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4d22ebd..918a727 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -585,10 +585,12 @@ static void synaptics_parse_agm(const unsigned char buf[],
 	switch (agm_packet_type) {
 	case 1:
 		/* Gesture packet: (x, y, z) half resolution */
-		agm->w = hw->w;
-		agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
-		agm->y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
-		agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 2;
+		agm->w = ((buf[1] & 0x01) |
+			  ((buf[2] & 0x01) << 1) |
+			  ((buf[5] & 0x01) << 2)) + 8;
+		agm->x = (((buf[4] & 0x0f) << 8) | (buf[1] & 0xfe)) << 1;
+		agm->y = (((buf[4] & 0xf0) << 4) | (buf[2] & 0xfe)) << 1;
+		agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0e)) << 2;
 		break;
 
 	case 2:
@@ -852,6 +854,17 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
 	else
 		num_fingers = 4;
 
+	/* When multiple fingers are on the TouchPad, the width is encoded in
+	 * X, Y and Z */
+	if (sgm->w == 0 || sgm->w == 1) {
+		sgm->w = (((sgm->x & BIT(1)) >> 1) |
+			  (sgm->y & BIT(1)) |
+			  ((sgm->z & BIT(0)) << 2)) + 8;
+		sgm->x &= ~BIT(1);
+		sgm->y &= ~BIT(1);
+		sgm->z &= ~BIT(0);
+	}
+
 	/* Send resulting input events to user space */
 	synaptics_report_mt_data(psmouse, sgm, num_fingers);
 }
-- 
2.1.4

