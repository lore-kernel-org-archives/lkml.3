Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3CKTQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:16:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33357 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab3CKTQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:16:48 -0400
X-Sasl-enc: +/t3ksD4J7xERw1TQOERgw7KLmQktJK5SMIIAHP+x2n6 1363029406
Message-ID: <513E2D56.8070902@ladisch.de>
Date: Mon, 11 Mar 2013 20:15:34 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dave Helstroom <helstroom@google.com>
CC: perex@perex.cz, tiwai@suse.de, eldad@fogrefinery.com, damien@zamaudio.com,
        pete.leigh@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] Add a USB audio quirk for the NuForce UDH-100
 device.
References: <1362973920-4942-1-git-send-email-helstroom@google.com>	<513D968C.1060905@ladisch.de> <CAOcFWma6fMqwqzMxFfCM7hOqk04FBk9JkKZjwekki_GFUR2jSQ@mail.gmail.com>
In-Reply-To: <CAOcFWma6fMqwqzMxFfCM7hOqk04FBk9JkKZjwekki_GFUR2jSQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> David Helstroom wrote:
>>> Interface 1 does not exist

Please try the patch below.


Regards,
Clemens


--8<---------------------------------------------------------------->8--
ALSA: usb-audio: add a workaround for the NuForce UDH-100

The NuForce UDH-100 numbers its interfaces incorrectly, which makes the
interface associations come out wrong, which results in the driver
erroring out with the message "Audio class v2 interfaces need an
interface association".

Work around this by searching for the interface association descriptor
also in some other place where it might have ended up.

Reported-by: Dave Helstroom <helstroom@google.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 sound/usb/card.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index df2f6d0..34dc3e8 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -245,6 +245,21 @@ static int snd_usb_create_streams(struct snd_usb_audio *chip, int ctrlif)
 			usb_ifnum_to_if(dev, ctrlif)->intf_assoc;

 		if (!assoc) {
+			/*
+			 * Firmware writers cannot count to three.  So to find
+			 * the IAD on the NuForce UDH-100, also check the next
+			 * interface.
+			 */
+			struct usb_interface *iface =
+				usb_ifnum_to_if(dev, ctrlif + 1);
+			if (iface &&
+			    iface->intf_assoc &&
+			    iface->intf_assoc->bFunctionClass == USB_CLASS_AUDIO &&
+			    iface->intf_assoc->bFunctionProtocol == UAC_VERSION_2)
+				assoc = iface->intf_assoc;
+		}
+
+		if (!assoc) {
 			snd_printk(KERN_ERR "Audio class v2 interfaces need an interface association\n");
 			return -EINVAL;
 		}

