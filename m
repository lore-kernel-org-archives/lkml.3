Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649AbaKNTjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:39:09 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51688 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161809AbaKNTi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:38:58 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/7] input: alps: Move trackstick detection to alps_hw_init_*
Date: Fri, 14 Nov 2014 20:38:21 +0100
Message-Id: <1415993906-13307-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when alps_identify() does not need do trackstick detection it is safe to
move code init hw_init functions.

This patch also fix trackstick detection in function alps_hw_init_v3() which
remove ALPS_DUALPOINT flag when trackstick is not detected.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 9ffa98d..cbfdcfc 100644
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
@@ -2231,12 +2243,6 @@ static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
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
-- 
1.7.9.5

