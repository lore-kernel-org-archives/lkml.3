Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3FYSfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:35:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3FYSft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:35:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeremy Rosen <jeremy.rosen@openwide.fr>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 02/27] ALSA: usb-audio: work around Android accessory firmware bug
Date: Tue, 25 Jun 2013 11:35:21 -0700
Message-Id: <20130625183517.965044212@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 342cda29343a6272c630f94ed56810a76740251b upstream.

When the Android firmware enables the audio interfaces in accessory
mode, it always declares in the control interface's baInterfaceNr array
that interfaces 0 and 1 belong to the audio function.  However, the
accessory interface itself, if also enabled, already is at index 0 and
shifts the actual audio interface numbers to 1 and 2, which prevents the
PCM streaming interface from being seen by the host driver.

To get the PCM interface interface to work, detect when the descriptors
point to the (for this driver useless) accessory interface, and redirect
to the correct one.

Reported-by: Jeremy Rosen <jeremy.rosen@openwide.fr>
Tested-by: Jeremy Rosen <jeremy.rosen@openwide.fr>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -149,14 +149,32 @@ static int snd_usb_create_stream(struct
 		return -EINVAL;
 	}
 
+	alts = &iface->altsetting[0];
+	altsd = get_iface_desc(alts);
+
+	/*
+	 * Android with both accessory and audio interfaces enabled gets the
+	 * interface numbers wrong.
+	 */
+	if ((chip->usb_id == USB_ID(0x18d1, 0x2d04) ||
+	     chip->usb_id == USB_ID(0x18d1, 0x2d05)) &&
+	    interface == 0 &&
+	    altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC &&
+	    altsd->bInterfaceSubClass == USB_SUBCLASS_VENDOR_SPEC) {
+		interface = 2;
+		iface = usb_ifnum_to_if(dev, interface);
+		if (!iface)
+			return -EINVAL;
+		alts = &iface->altsetting[0];
+		altsd = get_iface_desc(alts);
+	}
+
 	if (usb_interface_claimed(iface)) {
 		snd_printdd(KERN_INFO "%d:%d:%d: skipping, already claimed\n",
 						dev->devnum, ctrlif, interface);
 		return -EINVAL;
 	}
 
-	alts = &iface->altsetting[0];
-	altsd = get_iface_desc(alts);
 	if ((altsd->bInterfaceClass == USB_CLASS_AUDIO ||
 	     altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC) &&
 	    altsd->bInterfaceSubClass == USB_SUBCLASS_MIDISTREAMING) {


