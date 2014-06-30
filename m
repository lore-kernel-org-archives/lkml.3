Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaF3V1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbaF3V06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:58 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 13/15] Input - wacom: use hidinput_calc_abs_res instead of duplicating its code
Date: Mon, 30 Jun 2014 17:26:24 -0400
Message-Id: <1404163586-29582-14-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may infer a small difference with the previous implementation
due to the DIV_ROUND_CLOSEST() in the hid implementation.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 48 ++++++++--------------------------------
 1 file changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index eab299c..a8294d4 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -85,49 +85,19 @@ static void wacom_close(struct input_dev *dev)
 }
 
 /*
- * Calculate the resolution of the X or Y axis, given appropriate HID data.
- * This function is little more than hidinput_calc_abs_res stripped down.
+ * Calculate the resolution of the X or Y axis using hidinput_calc_abs_res.
  */
 static int wacom_calc_hid_res(int logical_extents, int physical_extents,
 			       unsigned unit, int exponent)
 {
-	int prev;
-	int unit_exponent = exponent;
-
-	/* Check if the extents are sane */
-	if (logical_extents <= 0 || physical_extents <= 0)
-		return 0;
-
-	/* Convert physical_extents to millimeters */
-	if (unit == 0x11) {		/* If centimeters */
-		unit_exponent += 1;
-	} else if (unit == 0x13) {	/* If inches */
-		prev = physical_extents;
-		physical_extents *= 254;
-		if (physical_extents < prev)
-			return 0;
-		unit_exponent -= 1;
-	} else {
-		return 0;
-	}
-
-	/* Apply negative unit exponent */
-	for (; unit_exponent < 0; unit_exponent++) {
-		prev = logical_extents;
-		logical_extents *= 10;
-		if (logical_extents < prev)
-			return 0;
-	}
-	/* Apply positive unit exponent */
-	for (; unit_exponent > 0; unit_exponent--) {
-		prev = physical_extents;
-		physical_extents *= 10;
-		if (physical_extents < prev)
-			return 0;
-	}
-
-	/* Calculate resolution */
-	return logical_extents / physical_extents;
+	struct hid_field field = {
+		.logical_maximum = logical_extents,
+		.physical_maximum = physical_extents,
+		.unit = unit,
+		.unit_exponent = exponent
+	};
+
+	return hidinput_calc_abs_res(&field, ABS_X);
 }
 
 static void wacom_feature_mapping(struct hid_device *hdev,
-- 
2.0.0

