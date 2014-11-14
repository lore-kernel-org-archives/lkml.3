Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422679AbaKNTjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:39:23 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47180 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161863AbaKNTjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:39:19 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 7/7] input: alps: Do not report both trackstick and external PS/2 mouse data to one input device
Date: Fri, 14 Nov 2014 20:38:26 +0100
Message-Id: <1415993906-13307-8-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch dev2 device was used for both external PS/2 mouse and internal
trackstick device (if available).

This patch introduce dev3 device which is used for external PS/2 mouse data and
dev2 is not used only for trackstick.

In case that trackstick is not present dev2 is not created, so userspace does
not see non existent device in system.

Because laptops with ALPS devices often do not use i8042 active multiplexing
all data (from touchpad, trackstick and external PS/2 mouse) come to one port.
So it is not possible to know if external PS/2 mouse is connected or not. In
most cases external PS/2 mouse is not connected so driver will create dev3
input device after first bare PS/2 packet will be received. So there will not
be "ghost" input device.

This patch also helps identify possible problems in future if driver decide
to report 6-bytes trackstick packets as 3-bytes bare PS/2 (data will be
reported to dev3 instead dev2).

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |  163 +++++++++++++++++++++++++++++++-------------
 drivers/input/mouse/alps.h |   14 +++-
 2 files changed, 128 insertions(+), 49 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 770bec5..6b69f4b 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -150,8 +150,7 @@ static bool alps_is_valid_first_byte(struct alps_data *priv,
 	return (data & priv->mask0) == priv->byte0;
 }
 
-static void alps_report_buttons(struct psmouse *psmouse,
-				struct input_dev *dev1, struct input_dev *dev2,
+static void alps_report_buttons(struct input_dev *dev1, struct input_dev *dev2,
 				int left, int right, int middle)
 {
 	struct input_dev *dev;
@@ -161,20 +160,21 @@ static void alps_report_buttons(struct psmouse *psmouse,
 	 * other device (dev2) then this event should be also
 	 * sent through that device.
 	 */
-	dev = test_bit(BTN_LEFT, dev2->key) ? dev2 : dev1;
+	dev = (dev2 && test_bit(BTN_LEFT, dev2->key)) ? dev2 : dev1;
 	input_report_key(dev, BTN_LEFT, left);
 
-	dev = test_bit(BTN_RIGHT, dev2->key) ? dev2 : dev1;
+	dev = (dev2 && test_bit(BTN_RIGHT, dev2->key)) ? dev2 : dev1;
 	input_report_key(dev, BTN_RIGHT, right);
 
-	dev = test_bit(BTN_MIDDLE, dev2->key) ? dev2 : dev1;
+	dev = (dev2 && test_bit(BTN_MIDDLE, dev2->key)) ? dev2 : dev1;
 	input_report_key(dev, BTN_MIDDLE, middle);
 
 	/*
 	 * Sync the _other_ device now, we'll do the first
 	 * device later once we report the rest of the events.
 	 */
-	input_sync(dev2);
+	if (dev2)
+		input_sync(dev2);
 }
 
 static void alps_process_packet_v1_v2(struct psmouse *psmouse)
@@ -221,13 +221,13 @@ static void alps_process_packet_v1_v2(struct psmouse *psmouse)
 		input_report_rel(dev2, REL_X,  (x > 383 ? (x - 768) : x));
 		input_report_rel(dev2, REL_Y, -(y > 255 ? (y - 512) : y));
 
-		alps_report_buttons(psmouse, dev2, dev, left, right, middle);
+		alps_report_buttons(dev2, dev, left, right, middle);
 
 		input_sync(dev2);
 		return;
 	}
 
-	alps_report_buttons(psmouse, dev, dev2, left, right, middle);
+	alps_report_buttons(dev, dev2, left, right, middle);
 
 	/* Convert hardware tap to a reasonable Z value */
 	if (ges && !fin)
@@ -1043,23 +1043,73 @@ static void alps_process_packet_v7(struct psmouse *psmouse)
 		alps_process_touchpad_packet_v7(psmouse);
 }
 
-static void alps_report_bare_ps2_packet(struct psmouse *psmouse,
+static DEFINE_MUTEX(alps_mutex);
+
+static void alps_register_bare_ps2_mouse(struct work_struct *work)
+{
+	struct alps_data *priv =
+		container_of(work, struct alps_data, dev3_register_work.work);
+	struct psmouse *psmouse = priv->psmouse;
+	struct input_dev *dev3;
+
+	mutex_lock(&alps_mutex);
+
+	if (priv->dev3)
+		goto out;
+
+	dev3 = input_allocate_device();
+	if (!dev3)
+		goto out;
+
+	snprintf(priv->phys3, sizeof(priv->phys3), "%s/%s",
+		 psmouse->ps2dev.serio->phys,
+		 (priv->dev2 ? "input2" : "input1"));
+	dev3->phys = priv->phys3;
+
+	/*
+	 * format of input device name is: "protocol vendor name"
+	 * see function psmouse_switch_protocol() in psmouse-base.c
+	 */
+	dev3->name = "PS/2 ALPS Mouse";
+
+	dev3->id.bustype = BUS_I8042;
+	dev3->id.vendor  = 0x0002;
+	dev3->id.product = PSMOUSE_PS2;
+	dev3->id.version = 0x0000;
+	dev3->dev.parent = &psmouse->ps2dev.serio->dev;
+
+	dev3->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	dev3->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	dev3->keybit[BIT_WORD(BTN_LEFT)] =
+		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+
+	__set_bit(INPUT_PROP_POINTER, dev3->propbit);
+
+	if (input_register_device(dev3)) {
+		input_free_device(dev3);
+		goto out;
+	}
+
+	priv->dev3 = dev3;
+
+out:
+	mutex_unlock(&alps_mutex);
+}
+
+static void alps_report_bare_ps2_packet(struct input_dev *dev,
 					unsigned char packet[],
 					bool report_buttons)
 {
-	struct alps_data *priv = psmouse->private;
-	struct input_dev *dev2 = priv->dev2;
-
 	if (report_buttons)
-		alps_report_buttons(psmouse, dev2, psmouse->dev,
+		alps_report_buttons(dev, NULL,
 				packet[0] & 1, packet[0] & 2, packet[0] & 4);
 
-	input_report_rel(dev2, REL_X,
+	input_report_rel(dev, REL_X,
 		packet[1] ? packet[1] - ((packet[0] << 4) & 0x100) : 0);
-	input_report_rel(dev2, REL_Y,
+	input_report_rel(dev, REL_Y,
 		packet[2] ? ((packet[0] << 3) & 0x100) - packet[2] : 0);
 
-	input_sync(dev2);
+	input_sync(dev);
 }
 
 static psmouse_ret_t alps_handle_interleaved_ps2(struct psmouse *psmouse)
@@ -1124,8 +1174,8 @@ static psmouse_ret_t alps_handle_interleaved_ps2(struct psmouse *psmouse)
 		 * de-synchronization.
 		 */
 
-		alps_report_bare_ps2_packet(psmouse, &psmouse->packet[3],
-					    false);
+		alps_report_bare_ps2_packet(priv->dev2,
+					    &psmouse->packet[3], false);
 
 		/*
 		 * Continue with the standard ALPS protocol handling,
@@ -1174,12 +1224,24 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
 
-	/* FIXME: Could we receive bare PS/2 packets from DualPoint devices?? */
+	/* NOTE: Some ALPS devices do not have active multiplexing controller
+	 *       so everything comes mixed into single data stream. Which means
+	 *       also external devices plugged into PS/2 ports. If ALPS device
+	 *       is not out of sync check for bare PS/2 packet which could come
+	 *       from external PS/2 mouse.
+	 */
 	if (!psmouse->out_of_sync_cnt &&
 	    (psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
+		/* Register dev3 mouse if we received PS/2 packet first time */
+		if (!priv->dev3)
+			psmouse_queue_work(psmouse,
+					   &priv->dev3_register_work, 0);
 		if (psmouse->pktcnt == 3) {
-			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
-						    true);
+			/* Once dev3 mouse device is registered report data */
+			if (priv->dev3)
+				alps_report_bare_ps2_packet(priv->dev3,
+							    psmouse->packet,
+							    true);
 			return PSMOUSE_FULL_PACKET;
 		}
 		return PSMOUSE_GOOD_DATA;
@@ -2325,7 +2387,10 @@ static void alps_disconnect(struct psmouse *psmouse)
 
 	psmouse_reset(psmouse);
 	del_timer_sync(&priv->timer);
-	input_unregister_device(priv->dev2);
+	if (priv->dev2)
+		input_unregister_device(priv->dev2);
+	if (priv->dev3)
+		input_unregister_device(priv->dev3);
 	kfree(priv);
 }
 
@@ -2359,17 +2424,17 @@ static void alps_set_abs_params_mt(struct alps_data *priv,
 int alps_init(struct psmouse *psmouse)
 {
 	struct alps_data *priv;
-	struct input_dev *dev1 = psmouse->dev, *dev2;
+	struct input_dev *dev1 = psmouse->dev;
+	struct input_dev *dev2 = NULL;
 
 	priv = kzalloc(sizeof(struct alps_data), GFP_KERNEL);
-	dev2 = input_allocate_device();
-	if (!priv || !dev2)
+	if (!priv)
 		goto init_fail;
 
-	priv->dev2 = dev2;
 	setup_timer(&priv->timer, alps_flush_packet, (unsigned long)psmouse);
 
 	psmouse->private = priv;
+	priv->psmouse = psmouse;
 
 	psmouse_reset(psmouse);
 
@@ -2426,36 +2491,41 @@ int alps_init(struct psmouse *psmouse)
 	}
 
 	if (priv->flags & ALPS_DUALPOINT) {
+		dev2 = input_allocate_device();
+		if (!priv || !dev2)
+			goto init_fail;
+
+		priv->dev2 = dev2;
+
+		snprintf(priv->phys2, sizeof(priv->phys2), "%s/input1",
+			 psmouse->ps2dev.serio->phys);
+		dev2->phys = priv->phys2;
+
 		/*
 		 * format of input device name is: "protocol vendor name"
 		 * see function psmouse_switch_protocol() in psmouse-base.c
 		 */
 		dev2->name = "AlpsPS/2 ALPS DualPoint Stick";
+
+		dev2->id.bustype = BUS_I8042;
+		dev2->id.vendor  = 0x0002;
 		dev2->id.product = PSMOUSE_ALPS;
 		dev2->id.version = priv->proto_version;
-	} else {
-		dev2->name = "PS/2 ALPS Mouse";
-		dev2->id.product = PSMOUSE_PS2;
-		dev2->id.version = 0x0000;
-	}
+		dev2->dev.parent = &psmouse->ps2dev.serio->dev;
 
-	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
-	dev2->phys = priv->phys;
-	dev2->id.bustype = BUS_I8042;
-	dev2->id.vendor  = 0x0002;
-	dev2->dev.parent = &psmouse->ps2dev.serio->dev;
+		dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+		dev2->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+		dev2->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 
-	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
-	dev2->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
-	dev2->keybit[BIT_WORD(BTN_LEFT)] =
-		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
-
-	__set_bit(INPUT_PROP_POINTER, dev2->propbit);
-	if (priv->flags & ALPS_DUALPOINT)
+		__set_bit(INPUT_PROP_POINTER, dev2->propbit);
 		__set_bit(INPUT_PROP_POINTING_STICK, dev2->propbit);
 
-	if (input_register_device(priv->dev2))
-		goto init_fail;
+		if (input_register_device(priv->dev2))
+			goto init_fail;
+	}
+
+	INIT_DELAYED_WORK(&priv->dev3_register_work, alps_register_bare_ps2_mouse);
 
 	if (!(priv->flags & ALPS_DUALPOINT))
 		psmouse->name = "GlidePoint TouchPad";
@@ -2477,7 +2547,8 @@ int alps_init(struct psmouse *psmouse)
 
 init_fail:
 	psmouse_reset(psmouse);
-	input_free_device(dev2);
+	if (dev2)
+		input_free_device(dev2);
 	kfree(priv);
 	psmouse->private = NULL;
 	return -1;
diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
index 66240b4..8d4de04 100644
--- a/drivers/input/mouse/alps.h
+++ b/drivers/input/mouse/alps.h
@@ -132,8 +132,12 @@ struct alps_fields {
 
 /**
  * struct alps_data - private data structure for the ALPS driver
- * @dev2: "Relative" device used to report trackstick or mouse activity.
- * @phys: Physical path for the relative device.
+ * @psmouse: Pointer to parent psmouse device
+ * @dev2: Trackstick device (can be NULL).
+ * @dev3: Generic PS/2 mouse (can be NULL, delayed registering).
+ * @phys2: Physical path for the trackstick device.
+ * @phys3: Physical path for the generic PS/2 mouse.
+ * @dev3_register_work: Delayed work for registering PS/2 mouse.
  * @nibble_commands: Command mapping used for touchpad register accesses.
  * @addr_command: Command used to tell the touchpad that a register address
  *   follows.
@@ -160,8 +164,12 @@ struct alps_fields {
  * @timer: Timer for flushing out the final report packet in the stream.
  */
 struct alps_data {
+	struct psmouse *psmouse;
 	struct input_dev *dev2;
-	char phys[32];
+	struct input_dev *dev3;
+	char phys2[32];
+	char phys3[32];
+	struct delayed_work dev3_register_work;
 
 	/* these are autodetected when the device is identified */
 	const struct alps_nibble_commands *nibble_commands;
-- 
1.7.9.5

