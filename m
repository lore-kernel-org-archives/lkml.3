Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435Ab3LIDA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:00:58 -0500
Received: from msr14.hinet.net ([168.95.4.114]:36438 "EHLO msr14.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760359Ab3LIDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:00:55 -0500
From: Duson Lin <dusonlin@emc.com.tw>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com
Cc: Duson Lin <dusonlin@emc.com.tw>
Subject: [PATCH] Add: (1) Detection for newer Elantech touchpads, so that kernel doesn't fall-back to default PS/2 driver. (2) Enable hardware version 4 touchpad right click function.
Date: Mon,  9 Dec 2013 10:59:50 +0800
Message-Id: <1386557990-27445-1-git-send-email-dusonlin@emc.com.tw>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify:
(1) crc_enabled only support for v3 and v4 touchpad, so initialize crc_enabled as false first and
check this hardware flag when hw_version as 3 or 4.

Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
---
 drivers/input/mouse/elantech.c |   30 ++++++++++++++----------------
 drivers/input/mouse/elantech.h |    2 +-
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 8551dca..b3627cf 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1,5 +1,5 @@
 /*
- * Elantech Touchpad driver (v6)
+ * Elantech Touchpad driver (v7)
  *
  * Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
  *
@@ -486,6 +486,7 @@ static void elantech_input_sync_v4(struct psmouse *psmouse)
 	unsigned char *packet = psmouse->packet;
 
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 	input_mt_report_pointer_emulation(dev, true);
 	input_sync(dev);
 }
@@ -1047,9 +1048,7 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 			 */
 			psmouse_warn(psmouse, "couldn't query resolution data.\n");
 		}
-		/* v4 is clickpad, with only one button. */
 		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
-		__clear_bit(BTN_RIGHT, dev->keybit);
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
 		/* For X to recognize me as touchpad. */
 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
@@ -1186,19 +1185,12 @@ static struct attribute_group elantech_attr_group = {
 
 static bool elantech_is_signature_valid(const unsigned char *param)
 {
-	static const unsigned char rates[] = { 200, 100, 80, 60, 40, 20, 10 };
-	int i;
-
 	if (param[0] == 0)
 		return false;
 
 	if (param[1] == 0)
 		return true;
 
-	for (i = 0; i < ARRAY_SIZE(rates); i++)
-		if (param[2] == rates[i])
-			return false;
-
 	return true;
 }
 
@@ -1298,6 +1290,14 @@ static int elantech_set_properties(struct elantech_data *etd)
 {
 	/* This represents the version of IC body. */
 	int ver = (etd->fw_version & 0x0f0000) >> 16;
+	/*
+	 * The signatures of v3 and v4 packets change depending on the
+	 * value of this hardware flag. But the v1 and v2 have not crc
+	 * check mechanism and the same hardware flag are also defined
+	 * as other function. So crc_enabled must be initialized as false 
+	 * first and checking by different hw_version.
+	 */
+	etd->crc_enabled = false;
 
 	/* Early version of Elan touchpads doesn't obey the rule. */
 	if (etd->fw_version < 0x020030 || etd->fw_version == 0x020600)
@@ -1309,10 +1309,14 @@ static int elantech_set_properties(struct elantech_data *etd)
 			etd->hw_version = 2;
 			break;
 		case 5:
+			etd->crc_enabled = ((etd->fw_version & 0x4000) == 0x4000);
 			etd->hw_version = 3;
 			break;
 		case 6:
 		case 7:
+		case 8:
+		case 10:
+			etd->crc_enabled = ((etd->fw_version & 0x4000) == 0x4000);
 			etd->hw_version = 4;
 			break;
 		default:
@@ -1343,12 +1347,6 @@ static int elantech_set_properties(struct elantech_data *etd)
 			etd->reports_pressure = true;
 	}
 
-	/*
-	 * The signatures of v3 and v4 packets change depending on the
-	 * value of this hardware flag.
-	 */
-	etd->crc_enabled = ((etd->fw_version & 0x4000) == 0x4000);
-
 	return 0;
 }
 
diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
index 036a04a..c963ac8 100644
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -1,5 +1,5 @@
 /*
- * Elantech Touchpad driver (v6)
+ * Elantech Touchpad driver (v7)
  *
  * Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
  *
-- 
1.7.10.4

