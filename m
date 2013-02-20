Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3BTVxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:53:51 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:32933 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3BTVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:53:49 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqFGAJZFJVFV5qjOOWdsb2JhbABFhWCFILVjgQEXAwEBAQEhFzSCHwEBBAEnExwTAQ8FCwgDEQMBAgolDwUlCgwOE4gMCsBJFY5uCweCX2EDliuGAo1i
X-IronPort-AV: E=Sophos;i="4.84,705,1355094000"; 
   d="scan'208";a="500994326"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 22:55:13 +0100
To: Chung-yih Wang <cywang@chromium.org>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Input: synaptics - use firmware data for Cr-48
Message-ID: <20130220215513.GA552@polaris.bitmath.org>
References: <1361180117-16258-1-git-send-email-cywang@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361180117-16258-1-git-send-email-cywang@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chung-yih,

> The profile sensor clickpad in a Cr-48 Chromebook does a reasonable job of
> tracking individual fingers. This tracking isn't perfect, but, experiments
> show that it works better than just passing "semi-mt" data to userspace,
> and making userspace try to deduce where the fingers are given a bounding box.
> 
> This patch tries to report two-finger positions directly from firmware's sgm
> and agm packets instead of the {(min_x, min_y), (max_x, max_y)} for profile
> sensor clickpads on Cr-48 chromebooks. Note that this device's firmware always
> reports the higher (smaller y) finger in the "sgm" packet, and the lower
> (larger y) finger in the "agm" packet for the state transition from one finger
> to two finger. Then the firmware keeps tracking of fingers with the same agm
> or sgm packets individually. Thus, when a new finger arrives on the pad, the
> kernel driver uses a simple Euclidean distance measure to deduce which of the
> two new fingers should keep the tracking ID of the previous single finger.
> Similarly, when one finger is removed, the same measure is used to determine
> which finger remained on the pad.
> 
> Signed-off-by: Chung-yih Wang <cywang@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c | 95 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)

I looks right per se, but the procedure is a bit more manual than it
needs to be.  The input core can handle slot allocation these days, so
I wonder if the the two patches below work for you, as an
alternative?

Thanks,
Henrik

---

>From 47629b43c260cb9c1ccbd5c474d89da81a029d27 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 22:36:52 +0100
Subject: [PATCH 1/2] Input: MT - Make slot cleanup callable outside
 mt_sync_frame()

Some semi-mt drivers use the slots in a manual way, but may still
want to call parts of the frame synchronization logic. This patch
makes input_mt_drop_unused callable from those drivers.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c | 38 +++++++++++++++++++++++++++-----------
 include/linux/input/mt.h |  1 +
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 1b7f4d4..a22094d 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -235,6 +235,31 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 EXPORT_SYMBOL(input_mt_report_pointer_emulation);
 
 /**
+ * input_mt_drop_unused() - Inactivate slots not seen in this frame
+ * @dev: input device with allocated MT slots
+ *
+ * Lift all slots not seen since the last call to this function.
+ */
+void input_mt_drop_unused(struct input_dev *dev)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *s;
+
+	if (!mt)
+		return;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (s->frame == mt->frame)
+			continue;
+		input_mt_slot(dev, s - mt->slots);
+		input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
+	}
+
+	mt->frame++;
+}
+EXPORT_SYMBOL(input_mt_drop_unused);
+
+/**
  * input_mt_sync_frame() - synchronize mt frame
  * @dev: input device with allocated MT slots
  *
@@ -245,23 +270,14 @@ EXPORT_SYMBOL(input_mt_report_pointer_emulation);
 void input_mt_sync_frame(struct input_dev *dev)
 {
 	struct input_mt *mt = dev->mt;
-	struct input_mt_slot *s;
 
 	if (!mt)
 		return;
 
-	if (mt->flags & INPUT_MT_DROP_UNUSED) {
-		for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
-			if (s->frame == mt->frame)
-				continue;
-			input_mt_slot(dev, s - mt->slots);
-			input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
-		}
-	}
+	if (mt->flags & INPUT_MT_DROP_UNUSED)
+		input_mt_drop_unused(dev);
 
 	input_mt_report_pointer_emulation(dev, (mt->flags & INPUT_MT_POINTER));
-
-	mt->frame++;
 }
 EXPORT_SYMBOL(input_mt_sync_frame);
 
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index cc5cca7..5766be1 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -98,6 +98,7 @@ void input_mt_report_slot_state(struct input_dev *dev,
 
 void input_mt_report_finger_count(struct input_dev *dev, int count);
 void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
+void input_mt_drop_unused(struct input_dev *dev);
 
 void input_mt_sync_frame(struct input_dev *dev);
 
-- 
1.8.1.3

>From 62a7bca6a782e83736c782c0b91e8640f2e5a140 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 22:47:18 +0100
Subject: [PATCH 2/2] Input: synaptics - Alternative use of firmware data for
 Cr-48

---
 drivers/input/mouse/synaptics.c | 60 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index a8590ad..52b30ad 100644
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
@@ -1040,6 +1042,42 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
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
@@ -1103,6 +1141,11 @@ static void synaptics_process_packet(struct psmouse *psmouse)
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
@@ -1246,6 +1289,9 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	set_abs_position_params(dev, priv, ABS_X, ABS_Y);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
+	if (cr48_profile_sensor)
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+
 	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
@@ -1459,10 +1505,24 @@ static const struct dmi_system_id __initconst olpc_dmi_table[] = {
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
-- 
1.8.1.3

