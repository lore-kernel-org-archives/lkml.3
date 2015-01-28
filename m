Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbbA1Uzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbbA1Uzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:46 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Input - synaptics: remove TOPBUTTONPAD property for Lenovos 2015
Date: Wed, 28 Jan 2015 15:10:06 -0500
Message-Id: <1422475807-15033-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2015 series of the Lenovo thinkpads added back the hardware buttons
on top of the touchpad for the trackstick.

Unfortunately, they are wired to the touchpad, and not the trackstick.
Thus, they are seen as extra buttons from the kernel point of view.

This leads to a problem in user space because extra buttons on synaptics
devices used to be used as scroll up/down buttons. So in the end, the
experience for the user is scroll events for buttons left and right
when using the trackstick. Yay!
Still, this user space problem will be fixed in the user space, and
the kernel will only handle the TOPBUTTONPAD property - which was not
a good idea to introduce in the kernel in the first place, I concede.

Furthermore, Lenovo kept using the PNPIDs that are supposed to be
"5 buttons" touchpads, so the new laptops also have the
INPUT_PROP_TOPBUTTONPAD. Yay again!

Insteead of manually removing each of the new ones, or hoping that we
know all the current ones, we can consider that the PNPIDs list that
were given contains touchpads that have the trackstick buttons, either
physically wired to them, or emulated with the top software button
property.

Thanks to the extra buttons capability, we can reliably detect the
physical buttons from the software ones, and so we can remove the
TOPBUTTONPAD property even if it was declared as such.

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/mouse/synaptics.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d58863b..4f05c9f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1129,7 +1129,8 @@ static void set_input_params(struct psmouse *psmouse,
 
 	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
-		if (psmouse_matches_pnp_id(psmouse, topbuttonpad_pnp_ids))
+		if (psmouse_matches_pnp_id(psmouse, topbuttonpad_pnp_ids) &&
+		    !test_bit(BTN_0, dev->keybit))
 			__set_bit(INPUT_PROP_TOPBUTTONPAD, dev->propbit);
 		/* Clickpads report only left button */
 		__clear_bit(BTN_RIGHT, dev->keybit);
-- 
2.1.0

