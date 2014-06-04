Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaFEAU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:20:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaFDXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 134/228] Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property
Date: Wed,  4 Jun 2014 16:22:43 -0700
Message-Id: <20140604232352.319219021@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 43e19888b1fe2a3e8a5543030c5b286cde38b3f5 upstream.

Check PNP ID of the PS/2 AUX port and report INPUT_PROP_TOPBUTTONPAD
property for for touchpads with top button areas.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |   55 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -117,6 +117,44 @@ void synaptics_reset(struct psmouse *psm
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
@@ -1255,8 +1293,10 @@ static void set_abs_position_params(stru
 	input_abs_set_res(dev, y_code, priv->y_res);
 }
 
-static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
+static void set_input_params(struct psmouse *psmouse,
+			     struct synaptics_data *priv)
 {
+	struct input_dev *dev = psmouse->dev;
 	int i;
 
 	/* Things that apply to both modes */
@@ -1325,6 +1365,17 @@ static void set_input_params(struct inpu
 
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
@@ -1643,7 +1694,7 @@ static int __synaptics_init(struct psmou
 		     priv->capabilities, priv->ext_cap, priv->ext_cap_0c,
 		     priv->board_id, priv->firmware_id);
 
-	set_input_params(psmouse->dev, priv);
+	set_input_params(psmouse, priv);
 
 	/*
 	 * Encode touchpad model so that it can be used to set


