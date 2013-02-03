Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3BCPDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:03:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34576 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab3BCO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:11 -0500
Message-Id: <20130203144653.125738614@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 103/128] ALSA: hda - Fix non-snoop page handling
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9ddf1aeb2134e72275c97a2c6ff2e3eb04f2f27a upstream.

For non-snoop mode, we fiddle with the page attributes of CORB/RIRB
and the position buffer, but also the ring buffers.  The problem is
that the current code blindly assumes that the buffer is contiguous.
However, the ring buffers may be SG-buffers, thus a wrong vmapped
address is passed there, leading to Oops.

This patch fixes the handling for SG-buffers.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=800701

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: open-code snd_pcm_get_dma_buf()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_intel.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -569,29 +569,43 @@ static char *driver_short_names[] __devi
 #define get_azx_dev(substream) (substream->runtime->private_data)
 
 #ifdef CONFIG_X86
-static void __mark_pages_wc(struct azx *chip, void *addr, size_t size, bool on)
+static void __mark_pages_wc(struct azx *chip, struct snd_dma_buffer *dmab, bool on)
 {
+	int pages;
+
 	if (azx_snoop(chip))
 		return;
-	if (addr && size) {
-		int pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (!dmab || !dmab->area || !dmab->bytes)
+		return;
+
+#ifdef CONFIG_SND_DMA_SGBUF
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_SG) {
+		struct snd_sg_buf *sgbuf = dmab->private_data;
 		if (on)
-			set_memory_wc((unsigned long)addr, pages);
+			set_pages_array_wc(sgbuf->page_table, sgbuf->pages);
 		else
-			set_memory_wb((unsigned long)addr, pages);
+			set_pages_array_wb(sgbuf->page_table, sgbuf->pages);
+		return;
 	}
+#endif
+
+	pages = (dmab->bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (on)
+		set_memory_wc((unsigned long)dmab->area, pages);
+	else
+		set_memory_wb((unsigned long)dmab->area, pages);
 }
 
 static inline void mark_pages_wc(struct azx *chip, struct snd_dma_buffer *buf,
 				 bool on)
 {
-	__mark_pages_wc(chip, buf->area, buf->bytes, on);
+	__mark_pages_wc(chip, buf, on);
 }
 static inline void mark_runtime_wc(struct azx *chip, struct azx_dev *azx_dev,
-				   struct snd_pcm_runtime *runtime, bool on)
+				   struct snd_pcm_substream *substream, bool on)
 {
 	if (azx_dev->wc_marked != on) {
-		__mark_pages_wc(chip, runtime->dma_area, runtime->dma_bytes, on);
+		__mark_pages_wc(chip, substream->runtime->dma_buffer_p, on);
 		azx_dev->wc_marked = on;
 	}
 }
@@ -602,7 +616,7 @@ static inline void mark_pages_wc(struct
 {
 }
 static inline void mark_runtime_wc(struct azx *chip, struct azx_dev *azx_dev,
-				   struct snd_pcm_runtime *runtime, bool on)
+				   struct snd_pcm_substream *substream, bool on)
 {
 }
 #endif
@@ -1776,11 +1790,10 @@ static int azx_pcm_hw_params(struct snd_
 {
 	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
 	struct azx *chip = apcm->chip;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct azx_dev *azx_dev = get_azx_dev(substream);
 	int ret;
 
-	mark_runtime_wc(chip, azx_dev, runtime, false);
+	mark_runtime_wc(chip, azx_dev, substream, false);
 	azx_dev->bufsize = 0;
 	azx_dev->period_bytes = 0;
 	azx_dev->format_val = 0;
@@ -1788,7 +1801,7 @@ static int azx_pcm_hw_params(struct snd_
 					params_buffer_bytes(hw_params));
 	if (ret < 0)
 		return ret;
-	mark_runtime_wc(chip, azx_dev, runtime, true);
+	mark_runtime_wc(chip, azx_dev, substream, true);
 	return ret;
 }
 
@@ -1797,7 +1810,6 @@ static int azx_pcm_hw_free(struct snd_pc
 	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
 	struct azx_dev *azx_dev = get_azx_dev(substream);
 	struct azx *chip = apcm->chip;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct hda_pcm_stream *hinfo = apcm->hinfo[substream->stream];
 
 	/* reset BDL address */
@@ -1810,7 +1822,7 @@ static int azx_pcm_hw_free(struct snd_pc
 
 	snd_hda_codec_cleanup(apcm->codec, hinfo, substream);
 
-	mark_runtime_wc(chip, azx_dev, runtime, false);
+	mark_runtime_wc(chip, azx_dev, substream, false);
 	return snd_pcm_lib_free_pages(substream);
 }
 


