Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaC1Ret (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:34:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaC1RbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.13 39/46] Input: wacom - make sure touch_max is set for touch devices
Date: Fri, 28 Mar 2014 10:32:23 -0700
Message-Id: <20140328173139.979034981@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/wacom_sys.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -304,7 +304,7 @@ static int wacom_parse_hid(struct usb_in
 	struct usb_device *dev = interface_to_usbdev(intf);
 	char limit = 0;
 	/* result has to be defined as int for some devices */
-	int result = 0;
+	int result = 0, touch_max = 0;
 	int i = 0, usage = WCM_UNDEFINED, finger = 0, pen = 0;
 	unsigned char *report;
 
@@ -351,7 +351,8 @@ static int wacom_parse_hid(struct usb_in
 				if (usage == WCM_DESKTOP) {
 					if (finger) {
 						features->device_type = BTN_TOOL_FINGER;
-
+						/* touch device at least supports one touch point */
+						touch_max = 1;
 						switch (features->type) {
 						case TABLETPC2FG:
 							features->pktlen = WACOM_PKGLEN_TPC2FG;
@@ -504,6 +505,8 @@ static int wacom_parse_hid(struct usb_in
 	}
 
  out:
+	if (!features->touch_max && touch_max)
+		features->touch_max = touch_max;
 	result = 0;
 	kfree(report);
 	return result;


