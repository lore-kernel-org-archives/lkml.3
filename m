Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaGVW1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:27:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693AbaGVW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:27:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 068/116] Input: elantech - deal with clickpads reporting right button events
Date: Tue, 22 Jul 2014 15:21:19 -0700
Message-Id: <1406067727-19683-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/elantech.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index c7bd58e..dc66ca8 100644
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
 
@@ -484,9 +491,17 @@ static void elantech_report_absolute_v3(struct psmouse *psmouse,
 static void elantech_input_sync_v4(struct psmouse *psmouse)
 {
 	struct input_dev *dev = psmouse->dev;
+	struct elantech_data *etd = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 
-	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
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
1.9.1

