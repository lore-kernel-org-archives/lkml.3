Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaC1RiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:38:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaC1RbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.13 35/46] Input: elantech -  improve clickpad detection
Date: Fri, 28 Mar 2014 10:32:19 -0700
Message-Id: <20140328173139.436175146@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elantech.c |   45 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -486,6 +486,7 @@ static void elantech_input_sync_v4(struc
 	unsigned char *packet = psmouse->packet;
 
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 	input_mt_report_pointer_emulation(dev, true);
 	input_sync(dev);
 }
@@ -984,6 +985,44 @@ static int elantech_get_resolution_v4(st
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
@@ -1026,6 +1065,8 @@ static int elantech_set_input_params(str
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		/* fall through */
 	case 3:
+		if (etd->hw_version == 3)
+			elantech_set_buttonpad_prop(psmouse);
 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
 		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
 		if (etd->reports_pressure) {
@@ -1047,9 +1088,7 @@ static int elantech_set_input_params(str
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


