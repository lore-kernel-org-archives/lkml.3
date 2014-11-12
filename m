Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaKLBWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:22:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaKLBWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 060/319] ALSA: hda - Add workaround for CMI8888 snoop behavior
Date: Wed, 12 Nov 2014 10:13:18 +0900
Message-Id: <20141112011002.446832514@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3b70bdba2fcb374a2235a56ab73334348d819579 upstream.

CMI8888 shows the stuttering playback when the snooping is disabled
on the audio buffer.  Meanwhile, we've got reports that CORB/RIRB
doesn't work in the snooped mode.  So, as a compromise, disable the
snoop only for CORB/RIRB and enable the snoop for the stream buffers.

The resultant patch became a bit ugly, unfortunately, but we still can
live with it.

Reported-and-tested-by: Geoffrey McRae <geoff@spacevs.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -373,6 +373,8 @@ static void __mark_pages_wc(struct azx *
 #ifdef CONFIG_SND_DMA_SGBUF
 	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_SG) {
 		struct snd_sg_buf *sgbuf = dmab->private_data;
+		if (chip->driver_type == AZX_DRIVER_CMEDIA)
+			return; /* deal with only CORB/RIRB buffers */
 		if (on)
 			set_pages_array_wc(sgbuf->page_table, sgbuf->pages);
 		else
@@ -1768,7 +1770,7 @@ static void pcm_mmap_prepare(struct snd_
 #ifdef CONFIG_X86
 	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
 	struct azx *chip = apcm->chip;
-	if (!azx_snoop(chip))
+	if (!azx_snoop(chip) && chip->driver_type != AZX_DRIVER_CMEDIA)
 		area->vm_page_prot = pgprot_writecombine(area->vm_page_prot);
 #endif
 }


