Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbbASUyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbbASUyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:54:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 6/6] Input: mt: introduce dmax in in-kernel tracking
Date: Mon, 19 Jan 2015 15:53:55 -0500
Message-Id: <1421700835-22157-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tapping a clickpad with two fingers, there is a chance that the sensor
sees first only one finger, and at the next scan only the second one.
In this case, the sensors says that there has been only one finger
on the clickpad, which moved really fast between two scans.

We can try to counter this by adding a limit to what an actual finger
can move between 2 scans.
We can try to provide a reasonable distance of 1cm between two scans for
one finger. This is what is used in the synaptcs.c portion of the patch.

However, this is not really accurate because the resolution in X and in Y
differs. But heh, that's how the in-kernel tracking works right now, and
its job is quite good even with this approximation.

Once a driver has set the maximum distance for a jump of a finger between
two scans, we can tell the in-kernel tracking to dissociate the slots
and the touch with input_mt_check_slots().

In order not to penalize better sensors, this parameter is not
automatically enabled, but each driver has to manually set it to a
reasonable value.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=76722

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/input-mt.c        | 67 +++++++++++++++++++++++++++++++++++++++--
 drivers/input/mouse/synaptics.c |  3 +-
 include/linux/input/mt.h        |  4 +++
 3 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c7b3752..d326262 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -403,9 +403,51 @@ static int input_mt_set_matrix(struct input_mt *mt,
 }
 
 /**
+ * input_mt_check_slots() - validate the slot assignments
+ * @mt: the input_mt handle of the current device
+ * @pos: the position array to match
+ * @slots: the slot assignment to be filled
+ * @num_pos: number of positions
+ *
+ * For each assigned touch in pos, check if the distance between this touch
+ * and the previously reported position is not too big.
+ * If it is too big, break the assignment by resetting the slot value to -1.
+ * While syncing the frame, the previously matched slot will be freed, and
+ * a new one will be assigned in input_mt_set_slots().
+ *
+ * The "too big" parameter is stored in mt->dmax2.
+ */
+static void input_mt_check_slots(struct input_mt *mt,
+				 const struct input_mt_pos *pos, int *slots,
+				 int num_pos)
+{
+	struct input_mt_slot *s;
+	int *p;
+	int i, x, y, d2, dx, dy;
+	struct input_mt_pos *mt_pos;
+
+	if (!mt->dmax2)
+		return;
+
+	for (i = 0; i < num_pos; i++) {
+		mt_pos = pos + i;
+		p = slots + i;
+		s = mt->slots + *p;
+		x = input_mt_get_value(s, ABS_MT_POSITION_X);
+		y = input_mt_get_value(s, ABS_MT_POSITION_Y);
+		dx = x - mt_pos->x;
+		dy = y - mt_pos->y;
+		d2 = dx * dx + dy * dy;
+		if (d2 >= mt->dmax2)
+			*p = -1;
+	}
+}
+
+/**
  * input_mt_set_slots() - assign slots to the list of pos thanks to the reduced
  * cost matrix
  * @mt: the input_mt handle of the current device
+ * @pos: the position array to match
  * @slots: the slot assignment to be filled
  * @num_pos: number of positions
  *
@@ -414,7 +456,8 @@ static int input_mt_set_matrix(struct input_mt *mt,
  * sent slots.
  */
 static void input_mt_set_slots(struct input_mt *mt,
-			       int *slots, int num_pos)
+			       const struct input_mt_pos *pos, int *slots,
+			       int num_pos)
 {
 	struct input_mt_slot *s;
 	int *red_cost_matrix = mt->red;
@@ -436,6 +479,8 @@ static void input_mt_set_slots(struct input_mt *mt,
 				*p = s - mt->slots;
 	}
 
+	input_mt_check_slots(mt, pos, slots, num_pos);
+
 	/* for each unassigned touch in pos, assign a new slot for it */
 	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
 		if (input_mt_is_active(s))
@@ -478,13 +523,31 @@ int input_mt_assign_slots(struct input_dev *dev, int *slots,
 	n_rows = n_elems / num_pos;
 	n_columns = num_pos;
 	find_reduced_matrix(mt->red, n_columns, n_rows, n_elems);
-	input_mt_set_slots(mt, slots, num_pos);
+	input_mt_set_slots(mt, pos, slots, num_pos);
 
 	return 0;
 }
 EXPORT_SYMBOL(input_mt_assign_slots);
 
 /**
+ * input_mt_set_dmax_tracking() - enhance tracking
+ * @dev: input device with allocated MT slots
+ * @dmax: the max distance between two touches to be considered as the same
+ *
+ * Enhance the in-kernel tracking by providing a maximum distance between
+ * 2 touches to be considered as the same slot.
+ * The stored value is the square of the provided distance to ease the tests
+ * later on. The input distance has to be given in the device coordinate system.
+ */
+void input_mt_set_dmax_tracking(struct input_dev *dev, int dmax)
+{
+	struct input_mt *mt = dev->mt;
+
+	mt->dmax2 = dmax * dmax;
+}
+EXPORT_SYMBOL(input_mt_set_dmax_tracking);
+
+/**
  * input_mt_get_slot_by_key() - return slot matching key
  * @dev: input device with allocated MT slots
  * @key: the key of the sought slot
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index f89de89..95c15451 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1077,7 +1077,8 @@ static void set_input_params(struct psmouse *psmouse,
 					ABS_MT_POSITION_Y);
 		/* Image sensors can report per-contact pressure */
 		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
-		input_mt_init_slots(dev, 2, INPUT_MT_POINTER | INPUT_MT_TRACK);
+		input_mt_init_slots(dev, 4, INPUT_MT_POINTER | INPUT_MT_TRACK);
+		input_mt_set_dmax_tracking(dev, 10 * priv->x_res);
 
 		/* Image sensors can signal 4 and 5 finger clicks */
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index f583ff6..c4b35c4 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -41,6 +41,7 @@ struct input_mt_slot {
  * @flags: input_mt operation flags
  * @frame: increases every time input_mt_sync_frame() is called
  * @red: reduced cost matrix for in-kernel tracking
+ * @dmax2: max (squared) distance between 2 points when using in-kernel tracking
  * @slots: array of slots holding current values of tracked contacts
  */
 struct input_mt {
@@ -50,6 +51,7 @@ struct input_mt {
 	unsigned int flags;
 	unsigned int frame;
 	int *red;
+	int dmax2;
 	struct input_mt_slot slots[];
 };
 
@@ -100,6 +102,8 @@ static inline bool input_is_mt_axis(int axis)
 	return axis == ABS_MT_SLOT || input_is_mt_value(axis);
 }
 
+void input_mt_set_dmax_tracking(struct input_dev *dev, int dmax);
+
 void input_mt_report_slot_state(struct input_dev *dev,
 				unsigned int tool_type, bool active);
 
-- 
2.1.0

