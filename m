Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3EFVCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:02:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab3EFUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Calvin Owens <jcalvinowens@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 061/115] ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
Date: Mon,  6 May 2013 13:44:57 -0700
Message-Id: <20130506203101.793119857@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <jcalvinowens@gmail.com>

commit 1539d4f82ad534431cc67935e8e442ccf107d17d upstream.

When recording at 176.2KHz or 192Khz, the device adds a 32-bit length
header to the capture packets, which obviously needs to be ignored for
recording to work properly.

Userspace expected:  L0 L1 L2 R0 R1 R2
...but actually got: R2 L0 L1 L2 R0 R1

Also, the last byte of the length header being interpreted as L0 of
the first sample caused spikes every 0.5ms, resulting in a loud 16KHz
tone (about the highest 'B' on a piano) being present throughout
captures.

Tested at all sample rates on an E-Mu 0404USB, and tested for
regressions on a generic USB headset.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h   |    1 +
 sound/usb/pcm.c    |    2 +-
 sound/usb/quirks.c |    1 +
 sound/usb/stream.c |    1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -116,6 +116,7 @@ struct snd_usb_substream {
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1170,7 +1170,7 @@ static void retire_capture_urb(struct sn
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -837,6 +837,7 @@ static void set_format_emu_quirk(struct
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -94,6 +94,7 @@ static void snd_usb_init_substream(struc
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 


