Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaKAX0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:26:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:51635 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKAX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:26:10 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v3 4/4] input: alps: Fix trackstick detection
Date: Sun,  2 Nov 2014 00:25:10 +0100
Message-Id: <1414884310-19842-5-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some laptops after starting them from off state (not after reboot), function
alps_probe_trackstick_v3() (called from function alps_identify()) does not
detect trackstick. To fix this problem we need to reset device. But function
alps_identify() is called also from alps_detect() and we do not want to reset
device in detect function because it will slow down initialization of all other
non alps devices.

Current alps device init sequence is:
alps_detect() --> alps_identify() (trackstick not detected)
alps_init() --> psmouse_reset() --> alps_identify() (trackstick detected)

This patch moves initialization code between driver functions so we can remove
alps_identify() call from alps_detect(). Which means that trackstick function
alps_probe_trackstick_v3() will be called only from alps_init() and only after
device reset so it will always return correct information about trackstick
presence. Code for identifying protocol version is moved to alps_init() and
because psmouse-base.c calling alps_detect() and alps_init() consecutively then
detection of both alps and also other non alps devices will not be broken.

First this patch moves code between functions:

 * Move calling function alps_probe_trackstick_v3() (for rushmore devices) from
   alps_identify() to alps_hw_init_rushmore_v3()

 * Move code for checking "E6 report" from alps_identify() to alps_detect()

 * Move code for setting correct device name string and model/protocol version
   from alps_detect() to alps_init(). To not break psmouse-base.c in function
   alps_detect() set only generic name "DualPoint TouchPad".

Next it removes alps_identify() from alps_detect() because it is not needed
anymore (code which use it was moved to alps_init()).

And last this patch fix another code for trackstick detection of protocol V3
devices. In function alps_hw_init_v3() is removed ALPS_DUALPOINT flag from
device if alps_setup_trackstick_v3() or alps_setup_trackstick_v3() returns
-ENODEV (which means trackstick is not present).

Now trackstick detection should work and in function alps_init() is set
correct name and other properties for both input devices.

Side effect of this patch is also faster alps devices initialization because
function alps_identify() is called only once (from alps_init()).

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/input/mouse/alps.c |   96 +++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index e802d28..04161b6 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1732,6 +1732,7 @@ error:
 
 static int alps_hw_init_v3(struct psmouse *psmouse)
 {
+	struct alps_data *priv = psmouse->private;
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	int reg_val;
 	unsigned char param[4];
@@ -1740,9 +1741,15 @@ static int alps_hw_init_v3(struct psmouse *psmouse)
 	if (reg_val == -EIO)
 		goto error;
 
-	if (reg_val == 0 &&
-	    alps_setup_trackstick_v3(psmouse, ALPS_REG_BASE_PINNACLE) == -EIO)
-		goto error;
+	if (reg_val == 0) {
+		reg_val = alps_setup_trackstick_v3(psmouse,
+						   ALPS_REG_BASE_PINNACLE);
+		if (reg_val == -EIO)
+			goto error;
+	}
+
+	if (reg_val == -ENODEV)
+		priv->flags &= ~ALPS_DUALPOINT;
 
 	if (alps_enter_command_mode(psmouse) ||
 	    alps_absolute_mode_v3(psmouse)) {
@@ -1849,15 +1856,20 @@ static int alps_hw_init_rushmore_v3(struct psmouse *psmouse)
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	int reg_val, ret = -1;
 
-	if (priv->flags & ALPS_DUALPOINT) {
+	reg_val = alps_probe_trackstick_v3(psmouse, ALPS_REG_BASE_RUSHMORE);
+	if (reg_val == -EIO)
+		goto error;
+
+	if (reg_val == 0) {
 		reg_val = alps_setup_trackstick_v3(psmouse,
 						   ALPS_REG_BASE_RUSHMORE);
 		if (reg_val == -EIO)
 			goto error;
-		if (reg_val == -ENODEV)
-			priv->flags &= ~ALPS_DUALPOINT;
 	}
 
+	if (reg_val == -ENODEV)
+		priv->flags &= ~ALPS_DUALPOINT;
+
 	if (alps_enter_command_mode(psmouse) ||
 	    alps_command_mode_read_reg(psmouse, 0xc2d9) == -1 ||
 	    alps_command_mode_write_reg(psmouse, 0xc2cb, 0x00))
@@ -2176,20 +2188,15 @@ static int alps_match_table(struct psmouse *psmouse, struct alps_data *priv,
 
 static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 {
-	unsigned char e6[4], e7[4], ec[4];
+	unsigned char e7[4], ec[4];
+	int ret;
 
 	/*
 	 * First try "E6 report".
-	 * ALPS should return 0,0,10 or 0,0,100 if no buttons are pressed.
-	 * The bits 0-2 of the first byte will be 1s if some buttons are
-	 * pressed.
 	 */
-	if (alps_rpt_cmd(psmouse, PSMOUSE_CMD_SETRES,
-			 PSMOUSE_CMD_SETSCALE11, e6))
-		return -EIO;
-
-	if ((e6[0] & 0xf8) != 0 || e6[1] != 0 || (e6[2] != 10 && e6[2] != 100))
-		return -EINVAL;
+	ret = alps_detect(psmouse, false);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * Now get the "E7" and "EC" reports.  These will uniquely identify
@@ -2231,12 +2238,6 @@ static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 		priv->y_bits = 12;
 		priv->flags |= ALPS_IS_RUSHMORE;
 
-		/* hack to make addr_command, nibble_command available */
-		psmouse->private = priv;
-
-		if (alps_probe_trackstick_v3(psmouse, ALPS_REG_BASE_RUSHMORE))
-			priv->flags &= ~ALPS_DUALPOINT;
-
 		return 0;
 	} else if (ec[0] == 0x88 && ec[1] == 0x07 &&
 		   ec[2] >= 0x90 && ec[2] <= 0x9d) {
@@ -2370,14 +2371,24 @@ int alps_init(struct psmouse *psmouse)
 		dev1->keybit[BIT_WORD(BTN_MIDDLE)] |= BIT_MASK(BTN_MIDDLE);
 	}
 
+	if (priv->flags & ALPS_DUALPOINT) {
+		/*
+		 * format of device name is: "protocol vendor name"
+		 * see function psmouse_switch_protocol() in psmouse-base.c
+		 */
+		dev2->name = "AlpsPS/2 ALPS DualPoint Stick";
+		dev2->id.product = PSMOUSE_ALPS;
+		dev2->id.version = priv->proto_version;
+	} else {
+		dev2->name = "PS/2 ALPS Mouse";
+		dev2->id.product = PSMOUSE_PS2;
+		dev2->id.version = 0x0000;
+	}
+
 	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
 	dev2->phys = priv->phys;
-	dev2->name = (priv->flags & ALPS_DUALPOINT) ?
-		     "DualPoint Stick" : "ALPS PS/2 Device";
 	dev2->id.bustype = BUS_I8042;
 	dev2->id.vendor  = 0x0002;
-	dev2->id.product = PSMOUSE_ALPS;
-	dev2->id.version = 0x0000;
 	dev2->dev.parent = &psmouse->ps2dev.serio->dev;
 
 	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
@@ -2392,6 +2403,10 @@ int alps_init(struct psmouse *psmouse)
 	if (input_register_device(priv->dev2))
 		goto init_fail;
 
+	if (!(priv->flags & ALPS_DUALPOINT))
+		psmouse->name = "GlidePoint TouchPad";
+	psmouse->model = priv->proto_version;
+
 	psmouse->protocol_handler = alps_process_byte;
 	psmouse->poll = alps_poll;
 	psmouse->disconnect = alps_disconnect;
@@ -2416,17 +2431,34 @@ init_fail:
 
 int alps_detect(struct psmouse *psmouse, bool set_properties)
 {
-	struct alps_data dummy;
+	unsigned char e6[4];
 
-	if (alps_identify(psmouse, &dummy) < 0)
-		return -1;
+	/*
+	 * Try "E6 report".
+	 * ALPS should return 0,0,10 or 0,0,100 if no buttons are pressed.
+	 * The bits 0-2 of the first byte will be 1s if some buttons are
+	 * pressed.
+	 */
+	if (alps_rpt_cmd(psmouse, PSMOUSE_CMD_SETRES,
+			 PSMOUSE_CMD_SETSCALE11, e6))
+		return -EIO;
+
+	if ((e6[0] & 0xf8) != 0 || e6[1] != 0 || (e6[2] != 10 && e6[2] != 100))
+		return -EINVAL;
 
 	if (set_properties) {
+		/*
+		 * NOTE: To detect model and trackstick presence we need to do
+		 *       full device reset. To speed up detection and prevent
+		 *       calling duplicate initialization sequence (both in
+		 *       alps_detect() and alps_init()) we set model/protocol
+		 *       version and correct name in alps_init() (which will
+		 *       do full device reset). For now set name to DualPoint.
+		 */
 		psmouse->vendor = "ALPS";
-		psmouse->name = dummy.flags & ALPS_DUALPOINT ?
-				"DualPoint TouchPad" : "GlidePoint";
-		psmouse->model = dummy.proto_version << 8;
+		psmouse->name = "DualPoint TouchPad";
 	}
+
 	return 0;
 }
 
-- 
1.7.9.5

