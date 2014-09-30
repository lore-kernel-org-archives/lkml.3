Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaI3VcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:32:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3VcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 010/103] Input: synaptics - add support for ForcePads
Date: Tue, 30 Sep 2014 14:30:15 -0700
Message-Id: <1412112708-27356-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 5715fc764f7753d464dbe094b5ef9cffa6e479a4 upstream.

ForcePads are found on HP EliteBook 1040 laptops. They lack any kind of
physical buttons, instead they generate primary button click when user
presses somewhat hard on the surface of the touchpad. Unfortunately they
also report primary button click whenever there are 2 or more contacts
on the pad, messing up all multi-finger gestures (2-finger scrolling,
multi-finger tapping, etc). To cope with this behavior we introduce a
delay (currently 50 msecs) in reporting primary press in case more
contacts appear.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/synaptics.c | 68 +++++++++++++++++++++++++++++++----------
 drivers/input/mouse/synaptics.h | 11 +++++++
 2 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index f6fbba5..4b7996e 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -549,10 +549,61 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 			 ((buf[0] & 0x04) >> 1) |
 			 ((buf[3] & 0x04) >> 2));
 
+		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
+			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
+		    hw->w == 2) {
+			synaptics_parse_agm(buf, priv, hw);
+			return 1;
+		}
+
+		hw->x = (((buf[3] & 0x10) << 8) |
+			 ((buf[1] & 0x0f) << 8) |
+			 buf[4]);
+		hw->y = (((buf[3] & 0x20) << 7) |
+			 ((buf[1] & 0xf0) << 4) |
+			 buf[5]);
+		hw->z = buf[2];
+
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
-		if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
+		if (SYN_CAP_FORCEPAD(priv->ext_cap_0c)) {
+			/*
+			 * ForcePads, like Clickpads, use middle button
+			 * bits to report primary button clicks.
+			 * Unfortunately they report primary button not
+			 * only when user presses on the pad above certain
+			 * threshold, but also when there are more than one
+			 * finger on the touchpad, which interferes with
+			 * out multi-finger gestures.
+			 */
+			if (hw->z == 0) {
+				/* No contacts */
+				priv->press = priv->report_press = false;
+			} else if (hw->w >= 4 && ((buf[0] ^ buf[3]) & 0x01)) {
+				/*
+				 * Single-finger touch with pressure above
+				 * the threshold. If pressure stays long
+				 * enough, we'll start reporting primary
+				 * button. We rely on the device continuing
+				 * sending data even if finger does not
+				 * move.
+				 */
+				if  (!priv->press) {
+					priv->press_start = jiffies;
+					priv->press = true;
+				} else if (time_after(jiffies,
+						priv->press_start +
+							msecs_to_jiffies(50))) {
+					priv->report_press = true;
+				}
+			} else {
+				priv->press = false;
+			}
+
+			hw->left = priv->report_press;
+
+		} else if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 			/*
 			 * Clickpad's button is transmitted as middle button,
 			 * however, since it is primary button, we will report
@@ -571,21 +622,6 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
 		}
 
-		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
-			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
-		    hw->w == 2) {
-			synaptics_parse_agm(buf, priv, hw);
-			return 1;
-		}
-
-		hw->x = (((buf[3] & 0x10) << 8) |
-			 ((buf[1] & 0x0f) << 8) |
-			 buf[4]);
-		hw->y = (((buf[3] & 0x20) << 7) |
-			 ((buf[1] & 0xf0) << 4) |
-			 buf[5]);
-		hw->z = buf[2];
-
 		if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
 		    ((buf[0] ^ buf[3]) & 0x02)) {
 			switch (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) & ~0x01) {
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index e594af0..fb2e076 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -78,6 +78,11 @@
  * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
  *					reports 2.
  * 2	0x20	report min		query 0x0f gives min coord reported
+ * 2	0x80	forcepad		forcepad is a variant of clickpad that
+ *					does not have physical buttons but rather
+ *					uses pressure above certain threshold to
+ *					report primary clicks. Forcepads also have
+ *					clickpad bit set.
  */
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
 #define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
@@ -86,6 +91,7 @@
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 #define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
+#define SYN_CAP_FORCEPAD(ex0c)		((ex0c) & 0x008000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -177,6 +183,11 @@ struct synaptics_data {
 	 */
 	struct synaptics_hw_state agm;
 	bool agm_pending;			/* new AGM packet received */
+
+	/* ForcePad handling */
+	unsigned long				press_start;
+	bool					press;
+	bool					report_press;
 };
 
 void synaptics_module_init(void);
-- 
1.9.1

