Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3DMDeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 23:34:09 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36956 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3DMDeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 23:34:08 -0400
Date: Fri, 12 Apr 2013 22:33:59 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Daniel Mack <zonque@gmail.com>, Damien Zammit <damien@zamaudio.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Calvin Owens <jcalvinowens@gmail.com>
Subject: [PATCH] alsa/usb: Add quirk for 192KHz recording on E-Mu devices
Message-ID: <20130413033359.GA1591@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 sound/usb/card.h   | 1 +
 sound/usb/pcm.c    | 2 +-
 sound/usb/quirks.c | 1 +
 sound/usb/stream.c | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 8a751b4..d32ea41 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -116,6 +116,7 @@ struct snd_usb_substream {
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index f94397b..a481fea 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1170,7 +1170,7 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 5325a38..7e292b9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -837,6 +837,7 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index ad181d5..0927cc6 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -94,6 +94,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
-- 
1.8.1.5
