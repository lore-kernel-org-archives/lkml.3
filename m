Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3BEWTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:19:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3BEWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 67/93] ALSA: hda - Fix non-snoop page handling
Date: Tue,  5 Feb 2013 20:06:56 -0200
Message-Id: <1360102042-10732-68-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: snd_pcm_get_dma_buf doesn't exist on 3.5, pass
  substream->runtime->dma_buffer_p directly ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/hda_intel.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index ff2bf55..d086bbf 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -617,29 +617,43 @@ static char *driver_short_names[] DELAYED_INITDATA_MARK = {
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
@@ -650,7 +664,7 @@ static inline void mark_pages_wc(struct azx *chip, struct snd_dma_buffer *buf,
 {
 }
 static inline void mark_runtime_wc(struct azx *chip, struct azx_dev *azx_dev,
-				   struct snd_pcm_runtime *runtime, bool on)
+				   struct snd_pcm_substream *substream, bool on)
 {
 }
 #endif
@@ -1823,11 +1837,10 @@ static int azx_pcm_hw_params(struct snd_pcm_substream *substream,
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
@@ -1835,7 +1848,7 @@ static int azx_pcm_hw_params(struct snd_pcm_substream *substream,
 					params_buffer_bytes(hw_params));
 	if (ret < 0)
 		return ret;
-	mark_runtime_wc(chip, azx_dev, runtime, true);
+	mark_runtime_wc(chip, azx_dev, substream, true);
 	return ret;
 }
 
@@ -1844,7 +1857,6 @@ static int azx_pcm_hw_free(struct snd_pcm_substream *substream)
 	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
 	struct azx_dev *azx_dev = get_azx_dev(substream);
 	struct azx *chip = apcm->chip;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct hda_pcm_stream *hinfo = apcm->hinfo[substream->stream];
 
 	/* reset BDL address */
@@ -1857,7 +1869,7 @@ static int azx_pcm_hw_free(struct snd_pcm_substream *substream)
 
 	snd_hda_codec_cleanup(apcm->codec, hinfo, substream);
 
-	mark_runtime_wc(chip, azx_dev, runtime, false);
+	mark_runtime_wc(chip, azx_dev, substream, false);
 	return snd_pcm_lib_free_pages(substream);
 }
 
-- 
1.7.9.5

