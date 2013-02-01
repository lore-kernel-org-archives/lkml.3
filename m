Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422647Ab3BANMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:12:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:45142 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422631Ab3BANMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:12:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 47/89] ALSA: hda - Fix non-snoop page handling
Date: Fri,  1 Feb 2013 14:08:02 +0100
Message-Id: <20130201130210.876503660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -650,29 +650,43 @@ static char *driver_short_names[] DELAYE
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
+		__mark_pages_wc(chip, snd_pcm_get_dma_buf(substream), on);
 		azx_dev->wc_marked = on;
 	}
 }
@@ -683,7 +697,7 @@ static inline void mark_pages_wc(struct
 {
 }
 static inline void mark_runtime_wc(struct azx *chip, struct azx_dev *azx_dev,
-				   struct snd_pcm_runtime *runtime, bool on)
+				   struct snd_pcm_substream *substream, bool on)
 {
 }
 #endif
@@ -1860,11 +1874,10 @@ static int azx_pcm_hw_params(struct snd_
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
@@ -1872,7 +1885,7 @@ static int azx_pcm_hw_params(struct snd_
 					params_buffer_bytes(hw_params));
 	if (ret < 0)
 		return ret;
-	mark_runtime_wc(chip, azx_dev, runtime, true);
+	mark_runtime_wc(chip, azx_dev, substream, true);
 	return ret;
 }
 
@@ -1881,7 +1894,6 @@ static int azx_pcm_hw_free(struct snd_pc
 	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
 	struct azx_dev *azx_dev = get_azx_dev(substream);
 	struct azx *chip = apcm->chip;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct hda_pcm_stream *hinfo = apcm->hinfo[substream->stream];
 
 	/* reset BDL address */
@@ -1894,7 +1906,7 @@ static int azx_pcm_hw_free(struct snd_pc
 
 	snd_hda_codec_cleanup(apcm->codec, hinfo, substream);
 
-	mark_runtime_wc(chip, azx_dev, runtime, false);
+	mark_runtime_wc(chip, azx_dev, substream, false);
 	return snd_pcm_lib_free_pages(substream);
 }
 


