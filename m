Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaGHTW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:22:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54237 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hans de Goede" <hdegoede@redhat.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.582590494@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 067/125] Input: elantech - deal with clickpads
 reporting right button events
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/elantech.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -455,8 +455,15 @@ static void elantech_report_absolute_v3(
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
 
@@ -466,10 +473,17 @@ static void elantech_report_absolute_v3(
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

