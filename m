Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaGWGLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:11:38 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44392 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaGWGLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:11:36 -0400
Date: Tue, 22 Jul 2014 23:11:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Christopher Heiny <cheiny@synaptics.com>,
        Andrew Duggan <aduggan@synaptics.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: synaptics-rmi4 - fix compiler warnings in F11
Message-ID: <20140723061130.GA22639@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f11.c | 135 +++++++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 64 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index b739d31..7af4f68 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -553,7 +553,7 @@ struct f11_data {
 	unsigned long *result_bits;
 };
 
-enum finger_state_values {
+enum f11_finger_state {
 	F11_NO_FINGER	= 0x00,
 	F11_PRESENT	= 0x01,
 	F11_INACCURATE	= 0x02,
@@ -563,12 +563,14 @@ enum finger_state_values {
 /** F11_INACCURATE state is overloaded to indicate pen present. */
 #define F11_PEN F11_INACCURATE
 
-static int get_tool_type(struct f11_2d_sensor *sensor, u8 finger_state)
+static int rmi_f11_get_tool_type(struct f11_2d_sensor *sensor,
+				 enum f11_finger_state finger_state)
 {
 	if (IS_ENABLED(CONFIG_RMI4_F11_PEN) &&
 			sensor->sens_query.has_pen &&
 			finger_state == F11_PEN)
 		return MT_TOOL_PEN;
+
 	return MT_TOOL_FINGER;
 }
 
@@ -603,36 +605,32 @@ static void rmi_f11_rel_pos_report(struct f11_2d_sensor *sensor, u8 n_finger)
 
 static void rmi_f11_abs_pos_report(struct f11_data *f11,
 				   struct f11_2d_sensor *sensor,
-				   u8 finger_state, u8 n_finger)
+				   enum f11_finger_state finger_state,
+				   u8 n_finger)
 {
 	struct f11_2d_data *data = &sensor->data;
+	struct input_dev *input = sensor->input;
 	struct rmi_f11_2d_axis_alignment *axis_align = &sensor->axis_align;
+	u8 *pos_data = &data->abs_pos[n_finger * RMI_F11_ABS_BYTES];
 	u16 x, y, z;
 	int w_x, w_y, w_max, w_min, orient;
-	int temp;
-	u8 abs_base = n_finger * RMI_F11_ABS_BYTES;
+	int tool_type = rmi_f11_get_tool_type(sensor, finger_state);
+
+	if (sensor->type_a) {
+		input_report_abs(input, ABS_MT_TRACKING_ID, n_finger);
+		input_report_abs(input, ABS_MT_TOOL_TYPE, tool_type);
+	} else {
+		input_mt_slot(input, n_finger);
+		input_mt_report_slot_state(input, tool_type,
+					   finger_state != F11_NO_FINGER);
+	}
 
 	if (finger_state) {
-		x = (data->abs_pos[abs_base] << 4) |
-			(data->abs_pos[abs_base + 2] & 0x0F);
-		y = (data->abs_pos[abs_base + 1] << 4) |
-			(data->abs_pos[abs_base + 2] >> 4);
-		w_x = data->abs_pos[abs_base + 3] & 0x0F;
-		w_y = data->abs_pos[abs_base + 3] >> 4;
-		w_max = max(w_x, w_y);
-		w_min = min(w_x, w_y);
-		z = data->abs_pos[abs_base + 4];
-
-		if (axis_align->swap_axes) {
-			temp = x;
-			x = y;
-			y = temp;
-			temp = w_x;
-			w_x = w_y;
-			w_y = temp;
-		}
+		x = (pos_data[0] << 4) | (pos_data[2] & 0x0F);
+		y = (pos_data[1] << 4) | (pos_data[2] >> 4);
 
-		orient = w_x > w_y ? 1 : 0;
+		if (axis_align->swap_axes)
+			swap(x, y);
 
 		if (axis_align->flip_x)
 			x = max(sensor->max_x - x, 0);
@@ -641,13 +639,13 @@ static void rmi_f11_abs_pos_report(struct f11_data *f11,
 			y = max(sensor->max_y - y, 0);
 
 		/*
-		* here checking if X offset or y offset are specified is
-		*  redundant.  We just add the offsets or, clip the values
-		*
-		* note: offsets need to be done before clipping occurs,
-		* or we could get funny values that are outside
-		* clipping boundaries.
-		*/
+		 * Here checking if X offset or y offset are specified is
+		 * redundant. We just add the offsets or clip the values.
+		 *
+		 * Note: offsets need to be applied before clipping occurs,
+		 * or we could get funny values that are outside of
+		 * clipping boundaries.
+		 */
 		x += axis_align->offset_x;
 		y += axis_align->offset_y;
 		x =  max(axis_align->clip_x_low, x);
@@ -657,41 +655,44 @@ static void rmi_f11_abs_pos_report(struct f11_data *f11,
 		if (axis_align->clip_y_high)
 			y =  min(axis_align->clip_y_high, y);
 
-	}
+		w_x = pos_data[3] & 0x0f;
+		w_y = pos_data[3] >> 4;
 
-	/* Some UIs ignore W of zero, so we fudge it to 1 for pens.  This
-	 * only appears to be an issue when reporting pens, not plain old
-	 * fingers. */
-	if (IS_ENABLED(CONFIG_RMI4_F11_PEN) &&
-			get_tool_type(sensor, finger_state) == MT_TOOL_PEN) {
-		w_max = max(1, w_max);
-		w_min = max(1, w_min);
-	}
+		if (axis_align->swap_axes)
+			swap(w_x, w_y);
 
-	if (sensor->type_a) {
-		input_report_abs(sensor->input, ABS_MT_TRACKING_ID, n_finger);
-		input_report_abs(sensor->input, ABS_MT_TOOL_TYPE,
-					get_tool_type(sensor, finger_state));
-	} else {
-		input_mt_slot(sensor->input, n_finger);
-		input_mt_report_slot_state(sensor->input,
-			get_tool_type(sensor, finger_state), finger_state);
-	}
+		orient = w_x > w_y ? 1 : 0;
+
+		w_max = max(w_x, w_y);
+		w_min = min(w_x, w_y);
+
+		/*
+		 * Some UIs ignore W of zero, so we fudge it to 1 for pens.  This
+		 * only appears to be an issue when reporting pens, not plain old
+		 * fingers.
+		 */
+		if (tool_type == MT_TOOL_PEN) {
+			w_max = max(1, w_max);
+			w_min = max(1, w_min);
+		}
+
+		z = pos_data[4];
+
+		input_report_abs(input, ABS_MT_PRESSURE, z);
+		input_report_abs(input, ABS_MT_TOUCH_MAJOR, w_max);
+		input_report_abs(input, ABS_MT_TOUCH_MINOR, w_min);
+		input_report_abs(input, ABS_MT_ORIENTATION, orient);
+		input_report_abs(input, ABS_MT_POSITION_X, x);
+		input_report_abs(input, ABS_MT_POSITION_Y, y);
 
-	if (finger_state) {
-		input_report_abs(sensor->input, ABS_MT_PRESSURE, z);
-		input_report_abs(sensor->input, ABS_MT_TOUCH_MAJOR, w_max);
-		input_report_abs(sensor->input, ABS_MT_TOUCH_MINOR, w_min);
-		input_report_abs(sensor->input, ABS_MT_ORIENTATION, orient);
-		input_report_abs(sensor->input, ABS_MT_POSITION_X, x);
-		input_report_abs(sensor->input, ABS_MT_POSITION_Y, y);
 		dev_dbg(&sensor->fn->dev,
 			"finger[%d]:%d - x:%d y:%d z:%d w_max:%d w_min:%d\n",
 			n_finger, finger_state, x, y, z, w_max, w_min);
 	}
+
 	/* MT sync between fingers */
 	if (sensor->type_a)
-		input_mt_sync(sensor->input);
+		input_mt_sync(input);
 }
 
 static void rmi_f11_finger_handler(struct f11_data *f11,
@@ -710,25 +711,31 @@ static void rmi_f11_finger_handler(struct f11_data *f11,
 		/* Possible of having 4 fingers per f_statet register */
 		finger_state = (f_state[i / 4] >> (2 * (i % 4))) &
 					FINGER_STATE_MASK;
-		if (finger_state == F11_RESERVED) {
-			pr_err("%s: Invalid finger state[%d]:0x%02x.", __func__,
-					i, finger_state);
+		switch (finger_state) {
+		case F11_RESERVED:
+			pr_err("Invalid finger state[%d]: 0x%02x", i, finger_state);
 			continue;
-		} else if ((finger_state == F11_PRESENT) ||
-				(finger_state == F11_INACCURATE)) {
+
+		case F11_PRESENT:
+		case F11_INACCURATE:
 			finger_pressed_count++;
+			break;
+
+		case F11_NO_FINGER:
+			break;
 		}
 
 		abs_bits = bitmap_and(f11->result_bits, irq_bits, f11->abs_mask,
-				num_irq_regs);
+				      num_irq_regs);
 		if (abs_bits)
 			rmi_f11_abs_pos_report(f11, sensor, finger_state, i);
 
 		rel_bits = bitmap_and(f11->result_bits, irq_bits, f11->rel_mask,
-				num_irq_regs);
+				      num_irq_regs);
 		if (rel_bits)
 			rmi_f11_rel_pos_report(sensor, i);
 	}
+
 	input_mt_sync_frame(sensor->input);
 	input_sync(sensor->input);
 }
-- 
2.0.0.526.g5318336


-- 
Dmitry
