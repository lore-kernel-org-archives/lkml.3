Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3BRIsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:48:32 -0500
Received: from mail-ve0-f201.google.com ([209.85.128.201]:61858 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3BRIsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:48:31 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2013 03:48:30 EST
From: Chung-yih Wang <cywang@chromium.org>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Chung-yih Wang <cywang@chromium.org>
Subject: [PATCH] Input: synaptics - add retry mechanism for reconnect
Date: Mon, 18 Feb 2013 16:40:21 +0800
Message-Id: <1361176821-31372-1-git-send-email-cywang@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Samsung Series 5 Chromebook, the Synaptics ClickPad will sometimes not
send an "0xFA" PS/2 ACK in response to a command byte during the reconnect
sequence following a resume from suspend. From our experiments, the failure can
happen during any byte of any of the commands in the reconnect batch.

This failure results in a timeout in the psmouse driver. In addition, the
ClickPad will often also respond to the next PS/2 command byte with an "0xFE"
PS/2 RESEND response.

This patch makes the synaptics reconnect-at-resume more tolerant to such
failures.

Signed-off-by: Chung-yih Wang <cywang@chromium.org>
---
 drivers/input/mouse/synaptics.c |   79 ++++++++++++++++++++++++++-------------
 1 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 2f78538..2ee19a5 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -72,33 +72,65 @@
  ****************************************************************************/
 
 /*
+ * Send a "synaptics" command to the device and retry on PS/2 communication
+ * error
+ */
+static int synaptics_send_cmd_retry(struct psmouse *psmouse, unsigned char cmd,
+				    unsigned char *param, int param_c)
+{
+	int tries = 2;
+	do {
+		if (!psmouse_sliced_command(psmouse, cmd) &&
+		    !ps2_command(&psmouse->ps2dev, param, param_c)) {
+			return 0;
+		}
+		/*
+		 * If the touchpad did not ACK a previous command byte,
+		 * it may also respond to the next command byte with 'FE'.
+		 * Send a dummy command to clear this possible 'FE'.
+		 */
+		ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
+	} while (--tries > 0);
+	psmouse_err(psmouse, "synaptics_retry failed cmd:0x%02x param_c 0x%x",
+		    cmd, param_c);
+	return -1;
+}
+
+/*
  * Set the synaptics touchpad mode byte by special commands
  */
 static int synaptics_mode_cmd(struct psmouse *psmouse, unsigned char mode)
 {
 	unsigned char param[1];
 
-	if (psmouse_sliced_command(psmouse, mode))
-		return -1;
 	param[0] = SYN_PS_SET_MODE2;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_SETRATE))
-		return -1;
-	return 0;
+	return synaptics_send_cmd_retry(psmouse, mode,
+					param, PSMOUSE_CMD_SETRATE);
 }
 
 int synaptics_detect(struct psmouse *psmouse, bool set_properties)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[4];
+	int tries = 2;
 
-	param[0] = 0;
+	do {
+		param[0] = 0;
+		if (!ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) &&
+		    !ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) &&
+		    !ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) &&
+		    !ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) &&
+		    !ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+			goto ps2_command_success;
+		}
+		/* dummy command to reset the communication channel */
+		ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
+	} while (--tries > 0);
 
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
+	psmouse_err(psmouse, "synaptics_retry failed in detect()");
+	return -1;
 
+ps2_command_success:
 	if (param[1] != 0x47)
 		return -ENODEV;
 
@@ -137,11 +169,7 @@ static int synaptics_invert_y(int y)
  */
 static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
 {
-	if (psmouse_sliced_command(psmouse, c))
-		return -1;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
-		return -1;
-	return 0;
+	return synaptics_send_cmd_retry(psmouse, c, param, PSMOUSE_CMD_GETINFO);
 }
 
 /*
@@ -332,11 +360,10 @@ static int synaptics_set_advanced_gesture_mode(struct psmouse *psmouse)
 	      SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
 		return 0;
 
-	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
-		return -1;
-
-	if (ps2_command(&psmouse->ps2dev, &param, PSMOUSE_CMD_SETRATE))
+	if (synaptics_send_cmd_retry(psmouse, SYN_QUE_MODEL,
+				     &param, PSMOUSE_CMD_SETRATE)) {
 		return -1;
+	}
 
 	/* Advanced gesture mode also sends multi finger data */
 	priv->capabilities |= BIT(1);
@@ -393,11 +420,8 @@ static int synaptics_pt_write(struct serio *serio, unsigned char c)
 	struct psmouse *parent = serio_get_drvdata(serio->parent);
 	char rate_param = SYN_PS_CLIENT_CMD; /* indicates that we want pass-through port */
 
-	if (psmouse_sliced_command(parent, c))
-		return -1;
-	if (ps2_command(&parent->ps2dev, &rate_param, PSMOUSE_CMD_SETRATE))
-		return -1;
-	return 0;
+	return synaptics_send_cmd_retry(parent, c,
+					&rate_param, PSMOUSE_CMD_SETRATE);
 }
 
 static int synaptics_pt_start(struct serio *serio)
@@ -1383,7 +1407,10 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 	int error;
 
 	do {
-		psmouse_reset(psmouse);
+		if (psmouse_reset(psmouse))
+			psmouse_err(psmouse, "psmouse_reset() failed.\n");
+
+
 		if (retry) {
 			/*
 			 * On some boxes, right after resuming, the touchpad
-- 
1.7.8.6

