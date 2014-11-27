Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaK0IrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:47:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:41543 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaK0IrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:08 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 28/91] Input: synaptics - add support for ForcePads
Date: Thu, 27 Nov 2014 16:42:11 +0800
Message-Id: <1417077794-9299-28-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/mouse/synaptics.c | 68 +++++++++++++++++++++++++++++++----------
 drivers/input/mouse/synaptics.h | 11 +++++++
 2 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 326e194..32b1363 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -517,10 +517,61 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
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
@@ -539,21 +590,6 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
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
index fd26ccc..ac1b773 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -77,6 +77,11 @@
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
@@ -85,6 +90,7 @@
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 #define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
+#define SYN_CAP_FORCEPAD(ex0c)		((ex0c) & 0x008000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -174,6 +180,11 @@ struct synaptics_data {
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

