Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422664AbaKNTjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:39:16 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36308 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161863AbaKNTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:39:13 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 6/7] input: alps: Add sanity checks for non DualPoint devices
Date: Fri, 14 Nov 2014 20:38:25 +0100
Message-Id: <1415993906-13307-7-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sanity checks and reject trackstick packets from ALPS devices
which do not have trackstick present (those without ALPS_DUALPOINT flag).

Make sure that driver does not process some bogus packets as trackstick data
when there is no trackstick packet. Patch also write warning do dmesg so
possible problems with driver (e.g received invalid data) will be visible
for debugging.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 2b7b74d..770bec5 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -475,6 +475,13 @@ static void alps_process_trackstick_packet_v3(struct psmouse *psmouse)
 	struct input_dev *dev = priv->dev2;
 	int x, y, z, left, right, middle;
 
+	/* It should be a DualPoint when received trackstick packet */
+	if (!(priv->flags & ALPS_DUALPOINT)) {
+		psmouse_warn(psmouse,
+			"Rejected trackstick packet from non DualPoint device");
+		return;
+	}
+
 	/* Sanity check packet */
 	if (!(packet[0] & 0x40)) {
 		psmouse_dbg(psmouse, "Bad trackstick packet, discarding\n");
@@ -699,7 +706,8 @@ static void alps_process_touchpad_packet_v3_v5(struct psmouse *psmouse)
 
 	alps_report_semi_mt_data(psmouse, fingers);
 
-	if (!(priv->quirks & ALPS_QUIRK_TRACKSTICK_BUTTONS)) {
+	if ((priv->flags & ALPS_DUALPOINT) &&
+	    !(priv->quirks & ALPS_QUIRK_TRACKSTICK_BUTTONS)) {
 		input_report_key(dev2, BTN_LEFT, f->ts_left);
 		input_report_key(dev2, BTN_RIGHT, f->ts_right);
 		input_report_key(dev2, BTN_MIDDLE, f->ts_middle);
@@ -743,8 +751,11 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
 	 */
 	if (packet[5] == 0x7F) {
 		/* It should be a DualPoint when received Trackpoint packet */
-		if (!(priv->flags & ALPS_DUALPOINT))
+		if (!(priv->flags & ALPS_DUALPOINT)) {
+			psmouse_warn(psmouse,
+			"Rejected trackstick packet from non DualPoint device");
 			return;
+		}
 
 		/* Trackpoint packet */
 		x = packet[1] | ((packet[3] & 0x20) << 2);
@@ -962,6 +973,13 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
 	struct input_dev *dev2 = priv->dev2;
 	int x, y, z, left, right, middle;
 
+	/* It should be a DualPoint when received trackstick packet */
+	if (!(priv->flags & ALPS_DUALPOINT)) {
+		psmouse_warn(psmouse,
+			"Rejected trackstick packet from non DualPoint device");
+		return;
+	}
+
 	/*
 	 *        b7 b6 b5 b4 b3 b2 b1 b0
 	 * Byte0   0  1  0  0  1  0  0  0
-- 
1.7.9.5

