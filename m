Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3ETKwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3ETKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Calvin Owens <jcalvinowens@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/115] ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
Date: Mon, 20 May 2013 11:50:11 +0100
Message-Id: <1369047116-9378-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/card.h   | 1 +
 sound/usb/pcm.c    | 2 +-
 sound/usb/quirks.c | 1 +
 sound/usb/stream.c | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index d5c2e3a..48b7e2f 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -110,6 +110,7 @@ struct snd_usb_substream {
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index ee3c15c..5fb0164 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1014,7 +1014,7 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b7fa802..9c82f8b 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -748,6 +748,7 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 1de0c8c..2025205 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -91,6 +91,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
-- 
1.8.1.2

