Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3FVUoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:44:10 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40116 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3FVUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:33 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH v2 08/12] ASoC: Samsung: Do not queue cyclic buffers multiple times
Date: Sat, 22 Jun 2013 22:42:40 +0200
Message-Id: <1371933764-24875-9-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy S3C-DMA API required every period of a cyclic buffer to be
queued separately. After conversion of Samsung ASoC to Samsung DMA
wrappers somebody made an assumption that the same is needed for DMA
engine API, which is not true.

In effect, Samsung ASoC DMA code was queuing the whole cyclic buffer
multiple times with a shift of one period per iteration, leading to:
  a) severe memory waste - up to 13x times more DMA transfer descriptors
     are allocated than needed,
  b) possible memory corruption, because further cyclic buffers were out
     of the original buffers, due to the offset.

This patch fixes this problem by making the legacy S3C-DMA API use the
same semantics as DMA engine (the whole cyclic buffer is enqueued at
once) and modifying users of Samsung DMA wrappers in cyclic mode to
behave appropriately.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/plat-samsung/s3c-dma-ops.c | 13 +++++++++++--
 sound/soc/samsung/dma.c             |  7 +++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/s3c-dma-ops.c b/arch/arm/plat-samsung/s3c-dma-ops.c
index 0cc40ae..98b10ba 100644
--- a/arch/arm/plat-samsung/s3c-dma-ops.c
+++ b/arch/arm/plat-samsung/s3c-dma-ops.c
@@ -82,7 +82,8 @@ static int s3c_dma_config(unsigned ch, struct samsung_dma_config *param)
 static int s3c_dma_prepare(unsigned ch, struct samsung_dma_prep *param)
 {
 	struct cb_data *data;
-	int len = (param->cap == DMA_CYCLIC) ? param->period : param->len;
+	dma_addr_t pos = param->buf;
+	dma_addr_t end = param->buf + param->len;
 
 	list_for_each_entry(data, &dma_list, node)
 		if (data->ch == ch)
@@ -94,7 +95,15 @@ static int s3c_dma_prepare(unsigned ch, struct samsung_dma_prep *param)
 		data->fp_param = param->fp_param;
 	}
 
-	s3c2410_dma_enqueue(ch, (void *)data, param->buf, len);
+	if (param->cap != DMA_CYCLIC) {
+		s3c2410_dma_enqueue(ch, (void *)data, param->buf, param->len);
+		return 0;
+	}
+
+	while (pos < end) {
+		s3c2410_dma_enqueue(ch, (void *)data, pos, param->period);
+		pos += param->period;
+	}
 
 	return 0;
 }
diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 21b7926..6e2b2b4 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -90,6 +90,13 @@ static void dma_enqueue(struct snd_pcm_substream *substream)
 	dma_info.period = prtd->dma_period;
 	dma_info.len = prtd->dma_period*limit;
 
+	if (dma_info.cap == DMA_CYCLIC) {
+		dma_info.buf = pos;
+		prtd->params->ops->prepare(prtd->params->ch, &dma_info);
+		prtd->dma_loaded += limit;
+		return;
+	}
+
 	while (prtd->dma_loaded < limit) {
 		pr_debug("dma_loaded: %d\n", prtd->dma_loaded);
 
-- 
1.8.2.1

