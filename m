Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbaCEOrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:47:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbaCEOiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 39/62] Input: elantech -  improve clickpad detection
Date: Wed,  5 Mar 2014 14:36:43 +0000
Message-Id: <1394030226-26652-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c15bdfd5b9831e4cab8cfc118243956e267dd30e upstream.

The current assumption in the elantech driver that hw version 3 touchpads
are never clickpads and hw version 4 touchpads are always clickpads is
wrong.

There are several bug reports for this, ie:
https://bugzilla.redhat.com/show_bug.cgi?id=1030802
http://superuser.com/questions/619582/right-elantech-touchpad-button-not-working-in-linux

I've spend a couple of hours wading through various bugzillas, launchpads
and forum posts to create a list of fw-versions and capabilities for
different laptop models to find a good method to differentiate between
clickpads and versions with separate hardware buttons.

Which shows that a device being a clickpad is reliable indicated by bit 12
being set in the fw_version. I've included the gathered list inside the
driver, so that we've this info at hand if we need to revisit this later.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/elantech.c | 45 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 9e47774..868a381 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -486,6 +486,7 @@ static void elantech_input_sync_v4(struct psmouse *psmouse)
 	unsigned char *packet = psmouse->packet;
 
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 	input_mt_report_pointer_emulation(dev, true);
 	input_sync(dev);
 }
@@ -954,6 +955,44 @@ static int elantech_get_resolution_v4(struct psmouse *psmouse,
 }
 
 /*
+ * Advertise INPUT_PROP_BUTTONPAD for clickpads. The testing of bit 12 in
+ * fw_version for this is based on the following fw_version & caps table:
+ *
+ * Laptop-model:           fw_version:     caps:           buttons:
+ * Acer S3                 0x461f00        10, 13, 0e      clickpad
+ * Acer S7-392             0x581f01        50, 17, 0d      clickpad
+ * Acer V5-131             0x461f02        01, 16, 0c      clickpad
+ * Acer V5-551             0x461f00        ?               clickpad
+ * Asus K53SV              0x450f01        78, 15, 0c      2 hw buttons
+ * Asus G46VW              0x460f02        00, 18, 0c      2 hw buttons
+ * Asus G750JX             0x360f00        00, 16, 0c      2 hw buttons
+ * Asus UX31               0x361f00        20, 15, 0e      clickpad
+ * Asus UX32VD             0x361f02        00, 15, 0e      clickpad
+ * Avatar AVIU-145A2       0x361f00        ?               clickpad
+ * Gigabyte U2442          0x450f01        58, 17, 0c      2 hw buttons
+ * Lenovo L430             0x350f02        b9, 15, 0c      2 hw buttons (*)
+ * Samsung NF210           0x150b00        78, 14, 0a      2 hw buttons
+ * Samsung NP770Z5E        0x575f01        10, 15, 0f      clickpad
+ * Samsung NP700Z5B        0x361f06        21, 15, 0f      clickpad
+ * Samsung NP900X3E-A02    0x575f03        ?               clickpad
+ * Samsung NP-QX410        0x851b00        19, 14, 0c      clickpad
+ * Samsung RC512           0x450f00        08, 15, 0c      2 hw buttons
+ * Samsung RF710           0x450f00        ?               2 hw buttons
+ * System76 Pangolin       0x250f01        ?               2 hw buttons
+ * (*) + 3 trackpoint buttons
+ */
+static void elantech_set_buttonpad_prop(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct elantech_data *etd = psmouse->private;
+
+	if (etd->fw_version & 0x001000) {
+		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
+		__clear_bit(BTN_RIGHT, dev->keybit);
+	}
+}
+
+/*
  * Set the appropriate event bits for the input subsystem
  */
 static int elantech_set_input_params(struct psmouse *psmouse)
@@ -996,6 +1035,8 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		/* fall through */
 	case 3:
+		if (etd->hw_version == 3)
+			elantech_set_buttonpad_prop(psmouse);
 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
 		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
 		if (etd->reports_pressure) {
@@ -1017,9 +1058,7 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 			 */
 			psmouse_warn(psmouse, "couldn't query resolution data.\n");
 		}
-		/* v4 is clickpad, with only one button. */
-		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
-		__clear_bit(BTN_RIGHT, dev->keybit);
+		elantech_set_buttonpad_prop(psmouse);
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
 		/* For X to recognize me as touchpad. */
 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
-- 
1.9.0

