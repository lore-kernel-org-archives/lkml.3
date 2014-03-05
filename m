Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbaCEPGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:06:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaCEO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 089/131] Input: wacom - make sure touch_max is set for touch devices
Date: Wed,  5 Mar 2014 14:23:33 +0000
Message-Id: <1394029455-23128-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit 1d0d6df02750b4a6f466768cbfbf860e24f4c8d4 upstream.

Old single touch Tablet PCs do not have touch_max set at
wacom_features. Since touch device at lease supports one
finger, assign touch_max to 1 when touch usage is defined
in its HID Descriptor and touch_max is not pre-defined.

Tested-by: Jason Gerecke <killertofu@gmail.com>
Signed-off-by: Ping Cheng <pingc@wacom.com>
Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/tablet/wacom_sys.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index aaf23ae..3d838c0 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -339,7 +339,7 @@ static int wacom_parse_hid(struct usb_interface *intf,
 	struct usb_device *dev = interface_to_usbdev(intf);
 	char limit = 0;
 	/* result has to be defined as int for some devices */
-	int result = 0;
+	int result = 0, touch_max = 0;
 	int i = 0, usage = WCM_UNDEFINED, finger = 0, pen = 0;
 	unsigned char *report;
 
@@ -386,7 +386,8 @@ static int wacom_parse_hid(struct usb_interface *intf,
 				if (usage == WCM_DESKTOP) {
 					if (finger) {
 						features->device_type = BTN_TOOL_FINGER;
-
+						/* touch device at least supports one touch point */
+						touch_max = 1;
 						switch (features->type) {
 						case TABLETPC2FG:
 							features->pktlen = WACOM_PKGLEN_TPC2FG;
@@ -539,6 +540,8 @@ static int wacom_parse_hid(struct usb_interface *intf,
 	}
 
  out:
+	if (!features->touch_max && touch_max)
+		features->touch_max = touch_max;
 	result = 0;
 	kfree(report);
 	return result;
-- 
1.9.0

