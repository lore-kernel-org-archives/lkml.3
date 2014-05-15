Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaEOV5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:57:15 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64720 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaEOV5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:57:13 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=5D=20Fix=20for=20possible=20null=20pointer=20dereference=20in=20dma=2Ec?=
Date: Thu, 15 May 2014 23:57:56 +0200
Message-Id: <1400191076-28279-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/soc/samsung/dma.c |   10 ++++++----
 1 fil ändrad, 6 tillägg(+), 4 borttagningar(-)

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index dc09b71..b1f6757 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -115,17 +115,19 @@ static void dma_enqueue(struct snd_pcm_substream *substream)
 static void audio_buffdone(void *data)
 {
 	struct snd_pcm_substream *substream = data;
-	struct runtime_data *prtd = substream->runtime->private_data;
+	struct runtime_data *prtd = NULL;
 
 	pr_debug("Entered %s\n", __func__);
 
-	if (prtd->state & ST_RUNNING) {
+	if(substream)
+		prtd = substream->runtime->private_data;
+
+	if (prtd && prtd->state & ST_RUNNING) {
 		prtd->dma_pos += prtd->dma_period;
 		if (prtd->dma_pos >= prtd->dma_end)
 			prtd->dma_pos = prtd->dma_start;
 
-		if (substream)
-			snd_pcm_period_elapsed(substream);
+		snd_pcm_period_elapsed(substream);
 
 		spin_lock(&prtd->lock);
 		if (!samsung_dma_has_circular()) {
-- 
1.7.10.4

