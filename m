Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3EJO0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:26:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57297 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939Ab3EJOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Calvin Owens" <jcalvinowens@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.572632486@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [028/118] ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -73,6 +73,7 @@ struct snd_usb_substream {
 	unsigned int fill_max: 1;	/* fill max packet size always */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -458,7 +458,7 @@ static int retire_capture_urb(struct snd
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd("frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
@@ -898,6 +898,7 @@ void snd_usb_init_substream(struct snd_u
 	subs->speed = snd_usb_get_speed(subs->dev);
 	if (subs->speed >= USB_SPEED_HIGH)
 		subs->ops.prepare_sync = prepare_capture_sync_urb_hs;
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -744,6 +744,7 @@ static void set_format_emu_quirk(struct
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,

