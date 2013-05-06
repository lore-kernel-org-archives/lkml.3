Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3EFRf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:35:57 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62350 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3EFRfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:35:55 -0400
Message-ID: <1367861750.11289.3.camel@u-foka-laptop.ethome2>
Subject: [PATCH] Input: Add support for Fujitsu S762 laptops scroll wheel
From: Eisenberger =?ISO-8859-1?Q?Tam=E1s?= <ufooka@gmail.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Mon, 06 May 2013 19:35:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detects and makes the Touch Scroll Wheel found on some Fujitsu laptops
working.

The detection is based on the (hopefully) unique E7 report of the wheel
device.
Up and down scrolling is detected by the only byte that has different
values in the devices packets, but it should be fine since it only able
to report that two events.

Signed-off-by: Tama's Eisenberger <tamas@eisenberger.hu>
Index: linux/drivers/input/mouse/alps.c
===================================================================
--- linux.orig/drivers/input/mouse/alps.c
+++ linux/drivers/input/mouse/alps.c
@@ -410,6 +410,17 @@ static void alps_process_trackstick_pack
 	if (packet[1] == 0x7f && packet[2] == 0x7f && packet[4] == 0x7f)
 		return;
 
+	if (priv->quirks & ALPS_QUIRK_SCROLL_WHEEL) {
+		if (packet[3] == 0x4c)
+			input_report_rel(dev, REL_WHEEL, 1);
+
+		if (packet[3] == 0x58)
+			input_report_rel(dev, REL_WHEEL, -1);
+
+		input_sync(dev);
+		return;
+	}
+
 	x = (s8)(((packet[0] & 0x20) << 2) | (packet[1] & 0x7f));
 	y = (s8)(((packet[0] & 0x10) << 3) | (packet[2] & 0x7f));
 	z = (packet[4] & 0x7c) >> 2;
@@ -1255,6 +1266,7 @@ error:
 static int alps_setup_trackstick_v3(struct psmouse *psmouse, int
reg_base)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	struct alps_data *priv = psmouse->private;
 	int ret = 0;
 	unsigned char param[4];
 
@@ -1277,6 +1289,12 @@ static int alps_setup_trackstick_v3(stru
 		psmouse_dbg(psmouse, "trackstick E7 report: %3ph\n", param);
 
 		/*
+		 * Detect fujitsu scroll wheel device
+		 */
+		if (param[0] == 0x34 && param[1] == 0x01 && param[2] == 0x14)
+			priv->quirks |= ALPS_QUIRK_SCROLL_WHEEL;
+
+		/*
 		 * Not sure what this does, but it is absolutely
 		 * essential. Without it, the touchpad does not
 		 * work at all and the trackstick just emits normal
@@ -1798,12 +1816,16 @@ int alps_init(struct psmouse *psmouse)
 	dev2->id.product = PSMOUSE_ALPS;
 	dev2->id.version = 0x0000;
 	dev2->dev.parent = &psmouse->ps2dev.serio->dev;
-
 	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
 	dev2->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 	dev2->keybit[BIT_WORD(BTN_LEFT)] =
 		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 
+	if (priv->quirks & ALPS_QUIRK_SCROLL_WHEEL) {
+		dev2->name = "DualPoint Scroll Wheel";
+		dev2->relbit[BIT_WORD(REL_X)] |= BIT_MASK(REL_WHEEL);
+	}
+
 	if (input_register_device(priv->dev2))
 		goto init_fail;
 
Index: linux/drivers/input/mouse/alps.h
===================================================================
--- linux.orig/drivers/input/mouse/alps.h
+++ linux/drivers/input/mouse/alps.h
@@ -158,6 +158,7 @@ struct alps_data {
 };
 
 #define ALPS_QUIRK_TRACKSTICK_BUTTONS	1 /* trakcstick buttons in
trackstick packet */
+#define ALPS_QUIRK_SCROLL_WHEEL		2 /* secondary device is scroll wheel
*/
 
 #ifdef CONFIG_MOUSE_PS2_ALPS
 int alps_detect(struct psmouse *psmouse, bool set_properties);

