Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab3ERCRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:17:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3ERCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:57 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BU9xTVjC3T8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=291B3mAb2z4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=1CVkjN0hAAAA:8 a=yOh7mzL5ixO0tChFE3EA:9 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=yHehcAF9bf0z2Eqo:21 a=PVWliHlQMPYGIGc6:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021649.338921306@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Calvin Owens <jcalvinowens@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 047/136 ] ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0047-ALSA-usb-Add-quirk-for-192KHz-recording-on-E-Mu-devi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Calvin Owens <jcalvinowens@gmail.com>

[ Upstream commit 1539d4f82ad534431cc67935e8e442ccf107d17d ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/card.h   |    1 +
 sound/usb/pcm.c    |    2 +-
 sound/usb/quirks.c |    1 +
 sound/usb/stream.c |    1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 6e262c5..48aabb6 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -112,6 +112,7 @@ struct snd_usb_substream {
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 90731af..cbaecce 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1017,7 +1017,7 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 213ecad..2c22adf 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -746,6 +746,7 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index e3c9b66..1891e49b 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -91,6 +91,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
-- 
1.7.10.4


