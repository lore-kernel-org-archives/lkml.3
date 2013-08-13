Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3HMQMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:12:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab3HMP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:25 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_e-bQnksv4sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BPcurU3HXu8A:10 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=dk5SIzXgUxAa1Ew6g9MA:9 a=7t4jVOfIR2gA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.008200738@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:56:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeremy Rosen <jeremy.rosen@openwide.fr>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [02/88] ALSA: usb-audio: work around Android accessory firmware bug
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0002-ALSA-usb-audio-work-around-Android-accessory-firmwar.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

[ Upstream commit 342cda29343a6272c630f94ed56810a76740251b ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/card.c |   22 ++++++++++++++++++++--
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
1.7.10.4


