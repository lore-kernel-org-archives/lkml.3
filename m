Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaLFPU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:28 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47654 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752111AbaLFPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 04/66] Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property
Date: Sat,  6 Dec 2014 16:06:56 +0100
Message-Id: <8f878acdf87a288172225f91418bae8e74f3ec58.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 43e19888b1fe2a3e8a5543030c5b286cde38b3f5 upstream.

Check PNP ID of the PS/2 AUX port and report INPUT_PROP_TOPBUTTONPAD
property for for touchpads with top button areas.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 55 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4b7996ebd150..f4a5adc17d73 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -117,6 +117,44 @@ void synaptics_reset(struct psmouse *psmouse)
 }
 
 #ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+/* This list has been kindly provided by Synaptics. */
+static const char * const topbuttonpad_pnp_ids[] = {
+	"LEN0017",
+	"LEN0018",
+	"LEN0019",
+	"LEN0023",
+	"LEN002A",
+	"LEN002B",
+	"LEN002C",
+	"LEN002D",
+	"LEN002E",
+	"LEN0033", /* Helix */
+	"LEN0034", /* T431s, T540, X1 Carbon 2nd */
+	"LEN0035", /* X240 */
+	"LEN0036", /* T440 */
+	"LEN0037",
+	"LEN0038",
+	"LEN0041",
+	"LEN0042", /* Yoga */
+	"LEN0045",
+	"LEN0046",
+	"LEN0047",
+	"LEN0048",
+	"LEN0049",
+	"LEN2000",
+	"LEN2001",
+	"LEN2002",
+	"LEN2003",
+	"LEN2004", /* L440 */
+	"LEN2005",
+	"LEN2006",
+	"LEN2007",
+	"LEN2008",
+	"LEN2009",
+	"LEN200A",
+	"LEN200B",
+	NULL
+};
 
 /*****************************************************************************
  *	Synaptics communications functions
@@ -1291,8 +1329,10 @@ static void set_abs_position_params(struct input_dev *dev,
 	input_abs_set_res(dev, y_code, priv->y_res);
 }
 
-static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
+static void set_input_params(struct psmouse *psmouse,
+			     struct synaptics_data *priv)
 {
+	struct input_dev *dev = psmouse->dev;
 	int i;
 
 	/* Things that apply to both modes */
@@ -1361,6 +1401,17 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 
 	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
+		/* See if this buttonpad has a top button area */
+		if (!strncmp(psmouse->ps2dev.serio->firmware_id, "PNP:", 4)) {
+			for (i = 0; topbuttonpad_pnp_ids[i]; i++) {
+				if (strstr(psmouse->ps2dev.serio->firmware_id,
+					   topbuttonpad_pnp_ids[i])) {
+					__set_bit(INPUT_PROP_TOPBUTTONPAD,
+						  dev->propbit);
+					break;
+				}
+			}
+		}
 		/* Clickpads report only left button */
 		__clear_bit(BTN_RIGHT, dev->keybit);
 		__clear_bit(BTN_MIDDLE, dev->keybit);
@@ -1687,7 +1738,7 @@ static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
 		     priv->capabilities, priv->ext_cap, priv->ext_cap_0c,
 		     priv->board_id, priv->firmware_id);
 
-	set_input_params(psmouse->dev, priv);
+	set_input_params(psmouse, priv);
 
 	/*
 	 * Encode touchpad model so that it can be used to set
-- 
2.1.3

