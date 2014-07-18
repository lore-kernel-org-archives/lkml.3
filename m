Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965932AbaGRNsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:48:43 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17527 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030614AbaGRNLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/170] Input: elantech - deal with clickpads reporting right button events
Date: Fri, 18 Jul 2014 14:10:17 +0200
Message-Id: <56f9d41164c04546995e1174a6d5b4ef22f50cd2.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cd9e83e2754465856097f31c7ab933ce74c473f8 upstream.

At least the Dell Vostro 5470 elantech *clickpad* reports right button
clicks when clicked in the right bottom area:

https://bugzilla.redhat.com/show_bug.cgi?id=1103528

This is different from how (elantech) clickpads normally operate, normally
no matter where the user clicks on the pad the pad always reports a left
button event, since there is only 1 hardware button beneath the path.

It looks like Dell has put 2 buttons under the pad, one under each bottom
corner, causing this.

Since this however still clearly is a real clickpad hardware-wise, we still
want to report it as such to userspace, so that things like finger movement
in the bottom area can be properly ignored as it should be on clickpads.

So deal with this weirdness by simply mapping a right click to a left click
on elantech clickpads. As an added advantage this is something which we can
simply do on all elantech clickpads, so no need to add special quirks for
this weird model.

Reported-and-tested-by: Elder Marco <eldermarco@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/elantech.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 230cdcf8e6fe..360e46b200de 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -473,8 +473,15 @@ static void elantech_report_absolute_v3(struct psmouse *psmouse,
 	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
 	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
 	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
-	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
-	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+
+	/* For clickpads map both buttons to BTN_LEFT */
+	if (etd->fw_version & 0x001000) {
+		input_report_key(dev, BTN_LEFT, packet[0] & 0x03);
+	} else {
+		input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+	}
+
 	input_report_abs(dev, ABS_PRESSURE, pres);
 	input_report_abs(dev, ABS_TOOL_WIDTH, width);
 
@@ -484,10 +491,17 @@ static void elantech_report_absolute_v3(struct psmouse *psmouse,
 static void elantech_input_sync_v4(struct psmouse *psmouse)
 {
 	struct input_dev *dev = psmouse->dev;
+	struct elantech_data *etd = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 
-	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
-	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+	/* For clickpads map both buttons to BTN_LEFT */
+	if (etd->fw_version & 0x001000) {
+		input_report_key(dev, BTN_LEFT, packet[0] & 0x03);
+	} else {
+		input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+	}
+
 	input_mt_report_pointer_emulation(dev, true);
 	input_sync(dev);
 }
-- 
2.0.0

