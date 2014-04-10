Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbaDJDXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934673AbaDJDWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Calvin Owens <jcalvinowens@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 050/134] ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
Date: Wed,  9 Apr 2014 20:22:46 -0700
Message-Id: <20140410032306.528476708@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h     |    1 +
 sound/usb/endpoint.c |    3 ++-
 sound/usb/quirks.c   |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -74,6 +74,7 @@ struct snd_usb_substream {
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
@@ -748,6 +748,7 @@ static void set_format_emu_quirk(struct
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,


