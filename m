Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaLFPUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:25 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47646 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752120AbaLFPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 05/66] Input: synaptics - add a matches_pnp_id helper function
Date: Sat,  6 Dec 2014 16:06:57 +0100
Message-Id: <ea70c325e0ec1e393ee7caf5c1b2496ee743cb71.1417878427.git.jslaby@suse.cz>
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

commit e2f611029b370bb7a04236215ad4b36aa8cb98cd upstream.

This is a preparation patch for simplifying the min/max quirk table.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index f4a5adc17d73..069c4fd1d0bb 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -156,6 +156,18 @@ static const char * const topbuttonpad_pnp_ids[] = {
 	NULL
 };
 
+static bool matches_pnp_id(struct psmouse *psmouse, const char * const ids[])
+{
+	int i;
+
+	if (!strncmp(psmouse->ps2dev.serio->firmware_id, "PNP:", 4))
+		for (i = 0; ids[i]; i++)
+			if (strstr(psmouse->ps2dev.serio->firmware_id, ids[i]))
+				return true;
+
+	return false;
+}
+
 /*****************************************************************************
  *	Synaptics communications functions
  ****************************************************************************/
@@ -1401,17 +1413,8 @@ static void set_input_params(struct psmouse *psmouse,
 
 	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
-		/* See if this buttonpad has a top button area */
-		if (!strncmp(psmouse->ps2dev.serio->firmware_id, "PNP:", 4)) {
-			for (i = 0; topbuttonpad_pnp_ids[i]; i++) {
-				if (strstr(psmouse->ps2dev.serio->firmware_id,
-					   topbuttonpad_pnp_ids[i])) {
-					__set_bit(INPUT_PROP_TOPBUTTONPAD,
-						  dev->propbit);
-					break;
-				}
-			}
-		}
+		if (matches_pnp_id(psmouse, topbuttonpad_pnp_ids))
+			__set_bit(INPUT_PROP_TOPBUTTONPAD, dev->propbit);
 		/* Clickpads report only left button */
 		__clear_bit(BTN_RIGHT, dev->keybit);
 		__clear_bit(BTN_MIDDLE, dev->keybit);
-- 
2.1.3

