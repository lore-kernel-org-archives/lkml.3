Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909AbaGCJy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:54:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038AbaGCJXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 106/198] Input: elantech - deal with clickpads reporting right button events
Date: Thu,  3 Jul 2014 10:19:09 +0100
Message-Id: <1404379241-8590-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/elantech.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 01fbea59398a..1f011270846a 100644
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
1.9.1

