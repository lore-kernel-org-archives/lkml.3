Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3LBTiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:38:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3LBTSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Forest Bond <forest.bond@rapidrollout.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 169/212] HID: dont ignore eGalax/D-Wav/EETI HIDs
Date: Mon,  2 Dec 2013 11:16:00 -0800
Message-Id: <20131202191306.882625573@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit 95d50b6c5e18ff7351c5f2a6ff53afaed5f7e664 upstream.

Certain devices with class HID, protocol None did not work with the HID
driver at one point, and as a result were bound to usbtouchscreen
instead as of commit 139ebe8 ("Input: usbtouchscreen - fix eGalax HID
ignoring").  This change was prompted by the following report:

https://lkml.org/lkml/2009/1/25/127

Unfortunately, the device mentioned in this report is no longer
available for testing.

We've recently discovered that some devices with class HID, protocol
None do not work with usbtouchscreen, but do work with usbhid.  Here is
the report that made this evident:

http://comments.gmane.org/gmane.linux.kernel.input/31710

Driver binding for these devices has flip-flopped a few times, so both
of the above reports were regressions.

This situation would appear to leave us with no easy way to bind every
device to the right driver.  However, in my own testing with several
devices I have not found a device with class HID that does not work with
the current HID driver.  It is my belief that changes to the HID driver
since the original report have likely fixed the issue(s) that made it
unsuitable at the time, and that we should prefer it over usbtouchscreen
for these devices.  In particular, HID quirks affecting these devices
were added/removed in the following commits since then:

fe6065d HID: add multi-input quirk for eGalax Touchcontroller
77933c3 Merge branch 'egalax' into for-linus
ebd11fe HID: Add quirk for eGalax touch controler.
d34c4aa HID: add no-get quirk for eGalax touch controller

This patch makes the HID driver no longer ignore eGalax/D-Wav/EETI
devices with class HID.  If there are in fact devices with class HID
that still do not work with the HID driver, we will see another round of
regressions.  In that case I propose we investigate why the device is
not working with the HID driver rather than re-introduce regressions for
functioning HID devices by again binding them to usbtouchscreen.

The corresponding change to usbtouchscreen will be made separately.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2376,15 +2376,6 @@ bool hid_ignore(struct hid_device *hdev)
 				hdev->type == HID_TYPE_USBNONE)
 			return true;
 		break;
-	case USB_VENDOR_ID_DWAV:
-		/* These are handled by usbtouchscreen. hdev->type is probably
-		 * HID_TYPE_USBNONE, but we say !HID_TYPE_USBMOUSE to match
-		 * usbtouchscreen. */
-		if ((hdev->product == USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER ||
-		     hdev->product == USB_DEVICE_ID_DWAV_TOUCHCONTROLLER) &&
-		    hdev->type != HID_TYPE_USBMOUSE)
-			return true;
-		break;
 	case USB_VENDOR_ID_VELLEMAN:
 		/* These are not HID devices.  They are handled by comedi. */
 		if ((hdev->product >= USB_DEVICE_ID_VELLEMAN_K8055_FIRST &&


