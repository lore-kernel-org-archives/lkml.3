Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaCGPth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:49:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaCGPtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:49:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Christopher Heiny <cheiny@synaptics.com>,
        Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
        Stephen Chandler Paul <thatslyude@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] Input: synaptics add manual min/max quirk
Date: Fri,  7 Mar 2014 10:49:24 -0500
Message-Id: <1394207364-4235-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Lenovo Haswell series (-40's) contains a new Synaptics touchpad.
However, these new Synaptics devices report bad axis ranges.
Under Windows, it is not a problem because the Windows driver uses RMI4
over SMBus to talk to the device. Under Linux, we are using the PS/2
fallback interface and it occurs the reported ranges are wrong.

Of course, it would be too easy to have only one range for the whole
series, each touchpad seems to be calibrated in a different way.

We can not use SMBus to get the actual range because I suspect the firmware
will switch into the SMBus mode and stop talking through PS/2 (this is the
case for hybrid HID over I2C / PS/2 Synaptics touchpads).

So as a temporary solution (until RMI4 land into upstream), start a new
list of quirks with the min/max manually set.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC: stable@vger.kernel.org
---

Hi Dmitry,

Well, this work is part of a (big) attempt to support the new touchpads
Lenovo put in its latest series.
Those new laptops have lost the buttons associated to the trackstick and are
what we call "clickpad".
Things would be easy if:
1. the PS/2 firmware did not lied about the actual range of the axis
2. on some install (mine) the DMI matching in udev would not have been broken
3. we did not have to fix a lot of stuff in Xorg / libinput / wayland

This patch fixes 1.

Matthew Garrett fixed 2. -> https://patchwork.kernel.org/patch/3704401/

3. is heavily working as shown by this tracker bug: https://bugs.freedesktop.org/show_bug.cgi?id=73158

I put the 'stable' marker, feel free to remove it if you don't think it should
be there, but I really think this should also be backported to have something
working in current distros.

Cheers,
Benjamin

 drivers/input/mouse/synaptics.c | 43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 26386f9..ff6a4cf 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -67,6 +67,8 @@
 #define X_MAX_POSITIVE 8176
 #define Y_MAX_POSITIVE 8176
 
+static int *quirk_min_max = NULL;
+
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
  ****************************************************************************/
@@ -302,6 +304,13 @@ static int synaptics_resolution(struct psmouse *psmouse)
 		}
 	}
 
+	if (quirk_min_max) {
+		priv->x_min = quirk_min_max[0];
+		priv->x_max = quirk_min_max[1];
+		priv->y_min = quirk_min_max[2];
+		priv->y_max = quirk_min_max[3];
+	}
+
 	return 0;
 }
 
@@ -1485,10 +1494,44 @@ static const struct dmi_system_id olpc_dmi_table[] __initconst = {
 	{ }
 };
 
+static const struct dmi_system_id min_max_dmi_table[] __initconst = {
+#if defined(CONFIG_DMI)
+	{
+		/* Lenovo ThinkPad Helix */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Helix"),
+		},
+		.driver_data = (int []){1024, 5052, 2258, 4832},
+	},
+	{
+		/* Lenovo ThinkPad T440s */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T440"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
+		/* Lenovo ThinkPad T540p */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
+		},
+		.driver_data = (int []){1024, 5056, 2058, 4832},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
+	const struct dmi_system_id *min_max_dmi;
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
 	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
+	min_max_dmi = dmi_first_match(min_max_dmi_table);
+	if (min_max_dmi)
+		quirk_min_max = (int *)min_max_dmi->driver_data;
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
-- 
1.8.5.3

