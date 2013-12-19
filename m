Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3LSL5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:57:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3LSL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 101/208] HID: hid-elo: some systems cannot stomach work around
Date: Thu, 19 Dec 2013 11:53:19 +0000
Message-Id: <1387454106-19326-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 403cfb53fb450d53751fdc7ee0cd6652419612cf upstream.

Some systems although they have firmware class 'M', which usually
needs a work around to not crash, must not be subjected to the
work around because the work around crashes them. They cannot be
told apart by their own device descriptor, but as they are part
of compound devices, can be identified by looking at their siblings.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-elo.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
index f042a6c..4e49462 100644
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -181,7 +181,40 @@ fail:
  */
 static bool elo_broken_firmware(struct usb_device *dev)
 {
-	return use_fw_quirk && le16_to_cpu(dev->descriptor.bcdDevice) == 0x10d;
+	struct usb_device *hub = dev->parent;
+	struct usb_device *child = NULL;
+	u16 fw_lvl = le16_to_cpu(dev->descriptor.bcdDevice);
+	u16 child_vid, child_pid;
+	int i;
+    
+	if (!use_fw_quirk)
+		return false;
+	if (fw_lvl != 0x10d)
+		return false;
+
+	/* iterate sibling devices of the touch controller */
+	usb_hub_for_each_child(hub, i, child) {
+		child_vid = le16_to_cpu(child->descriptor.idVendor);
+		child_pid = le16_to_cpu(child->descriptor.idProduct);
+
+		/*
+		 * If one of the devices below is present attached as a sibling of 
+		 * the touch controller then  this is a newer IBM 4820 monitor that 
+		 * does not need the IBM-requested workaround if fw level is
+		 * 0x010d - aka 'M'.
+		 * No other HW can have this combination.
+		 */
+		if (child_vid==0x04b3) {
+			switch (child_pid) {
+			case 0x4676: /* 4820 21x Video */
+			case 0x4677: /* 4820 51x Video */
+			case 0x4678: /* 4820 2Lx Video */
+			case 0x4679: /* 4820 5Lx Video */
+				return false;
+			}
+		}
+	}
+	return true;
 }
 
 static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
-- 
1.8.3.2

