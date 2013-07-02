Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3GBLH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:07:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3GBLHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:07:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 02/50] ALSA: usb-audio: work around Android accessory firmware bug
Date: Tue,  2 Jul 2013 12:06:50 +0100
Message-Id: <1372763258-20664-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/card.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index aa25e04..51241f4 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -150,14 +150,32 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
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
-- 
1.8.1.2

