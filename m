Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaFEAV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:21:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaFDXWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 144/228] Input: synaptics - add a matches_pnp_id helper function
Date: Wed,  4 Jun 2014 16:22:53 -0700
Message-Id: <20140604232352.647563044@linuxfoundation.org>
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

commit e2f611029b370bb7a04236215ad4b36aa8cb98cd upstream.

This is a preparation patch for simplifying the min/max quirk table.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -156,6 +156,18 @@ static const char * const topbuttonpad_p
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
@@ -1365,17 +1377,8 @@ static void set_input_params(struct psmo
 
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


