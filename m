Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaGZVSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 17:18:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37908 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaGZVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 17:18:08 -0400
Date: Sat, 26 Jul 2014 14:18:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chung-yih Wang <cywang@chromium.org>, linux-input@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Input: synaptics - use firmware data for Cr-48
Message-ID: <20140726211803.GC11800@core.coreip.homeip.net>
References: <1361180117-16258-1-git-send-email-cywang@chromium.org>
 <20130220215513.GA552@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220215513.GA552@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Wed, Feb 20, 2013 at 10:55:13PM +0100, Henrik Rydberg wrote:
> Hi Chung-yih,
> 
> > The profile sensor clickpad in a Cr-48 Chromebook does a reasonable job of
> > tracking individual fingers. This tracking isn't perfect, but, experiments
> > show that it works better than just passing "semi-mt" data to userspace,
> > and making userspace try to deduce where the fingers are given a bounding box.
> > 
> > This patch tries to report two-finger positions directly from firmware's sgm
> > and agm packets instead of the {(min_x, min_y), (max_x, max_y)} for profile
> > sensor clickpads on Cr-48 chromebooks. Note that this device's firmware always
> > reports the higher (smaller y) finger in the "sgm" packet, and the lower
> > (larger y) finger in the "agm" packet for the state transition from one finger
> > to two finger. Then the firmware keeps tracking of fingers with the same agm
> > or sgm packets individually. Thus, when a new finger arrives on the pad, the
> > kernel driver uses a simple Euclidean distance measure to deduce which of the
> > two new fingers should keep the tracking ID of the previous single finger.
> > Similarly, when one finger is removed, the same measure is used to determine
> > which finger remained on the pad.
> > 
> > Signed-off-by: Chung-yih Wang <cywang@chromium.org>
> > ---
> >  drivers/input/mouse/synaptics.c | 95 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 95 insertions(+)
> 
> I looks right per se, but the procedure is a bit more manual than it
> needs to be.  The input core can handle slot allocation these days, so
> I wonder if the the two patches below work for you, as an
> alternative?

You forgot to tell input_mt_init_slots() to track the contacts, but
otherwise it works. The version of the patch below seems to work well on
Cr-48 for me.

Thanks.

-- 
Dmitry


Input: synaptics - use firmware data for Cr-48

From: Henrik Rydberg <rydberg@euromail.se>

The profile sensor clickpad in a Cr-48 Chromebook does a reasonable job
of tracking individual fingers. This tracking isn't perfect, but,
experiments show that it works better than just passing "semi-mt" data
to userspace, and making userspace try to deduce where the fingers are
given a bounding box.

This patch tries to report correct two-finger positions instead of the
{(min_x, min_y), (max_x, max_y)} for profile sensor clickpads on Cr-48
chromebooks. Note that this device's firmware always reports the higher
(smaller y) finger in the "sgm" packet, and the lower (larger y) finger
in the "agm" packet. Thus, when a new finger arrives on the pad, the
kernel driver uses input core's contact tracking facilities to match
contacts with slots.

Inspired by patch by Daniel Kurtz <djkurtz@chromium.org> and Chung-yih
Wang <cywang@chromium.org>

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mouse/synaptics.c |   69 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index fe607e9..f261db9 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -67,6 +67,8 @@
 #define X_MAX_POSITIVE 8176
 #define Y_MAX_POSITIVE 8176
 
+static bool cr48_profile_sensor;
+
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
  ****************************************************************************/
@@ -1152,6 +1154,42 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
 	priv->agm_pending = false;
 }
 
+static void synaptics_profile_sensor_process(struct psmouse *psmouse,
+					     struct synaptics_hw_state *sgm,
+					     int num_fingers)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct synaptics_data *priv = psmouse->private;
+	struct synaptics_hw_state *hw[2] = { sgm, &priv->agm };
+	struct input_mt_pos pos[2];
+	int slot[2], nsemi, i;
+
+	nsemi = clamp_val(num_fingers, 0, 2);
+
+	for (i = 0; i < nsemi; i++) {
+		pos[i].x = hw[i]->x;
+		pos[i].y = synaptics_invert_y(hw[i]->y);
+	}
+
+	input_mt_assign_slots(dev, slot, pos, nsemi);
+
+	for (i = 0; i < nsemi; i++) {
+		input_mt_slot(dev, slot[i]);
+		input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
+		input_report_abs(dev, ABS_MT_POSITION_X, pos[i].x);
+		input_report_abs(dev, ABS_MT_POSITION_Y, pos[i].y);
+		input_report_abs(dev, ABS_MT_PRESSURE, hw[i]->z);
+	}
+
+	input_mt_drop_unused(dev);
+	input_mt_report_pointer_emulation(dev, false);
+	input_mt_report_finger_count(dev, num_fingers);
+
+	synaptics_report_buttons(psmouse, sgm);
+
+	input_sync(dev);
+}
+
 /*
  *  called for each full received packet from the touchpad
  */
@@ -1215,6 +1253,11 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		finger_width = 0;
 	}
 
+	if (cr48_profile_sensor) {
+		synaptics_profile_sensor_process(psmouse, &hw, num_fingers);
+		return;
+	}
+
 	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
 		synaptics_report_semi_mt_data(dev, &hw, &priv->agm,
 					      num_fingers);
@@ -1360,6 +1403,9 @@ static void set_input_params(struct psmouse *psmouse,
 	set_abs_position_params(dev, priv, ABS_X, ABS_Y);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
+	if (cr48_profile_sensor)
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+
 	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
@@ -1373,9 +1419,14 @@ static void set_input_params(struct psmouse *psmouse,
 	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
-		/* Non-image sensors with AGM use semi-mt */
+		/*
+		 * Profile sensor in CR-48 tracks contacts reasonably well,
+		 * other non-image sensors with AGM use semi-mt.
+		 */
 		input_mt_init_slots(dev, 2,
-				    INPUT_MT_POINTER | INPUT_MT_SEMI_MT);
+				    INPUT_MT_POINTER |
+				    (cr48_profile_sensor ?
+					INPUT_MT_TRACK : INPUT_MT_SEMI_MT));
 	}
 
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
@@ -1577,10 +1628,24 @@ static const struct dmi_system_id olpc_dmi_table[] __initconst = {
 	{ }
 };
 
+static const struct dmi_system_id __initconst cr48_dmi_table[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		/* Cr-48 Chromebook (Codename Mario) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IEC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
+		},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
 	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
+	cr48_profile_sensor = dmi_check_system(cr48_dmi_table);
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
