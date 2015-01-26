Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbbAZKT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:19:58 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:60986 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbbAZKSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:18:40 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 1/4] sound: soc: jz4740: Add dynamic sampling rate support to jz4740-i2s
Date: Mon, 26 Jan 2015 10:18:28 +0000
Message-ID: <1422267511-6649-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The div clock register is not modified during jz4740_i2s_hw_params.
Hence, default sampling rates are actually used regardless of
sampling rates input from userspace.

This patch adds support to calculate the value of the divider from
the parameters passed from userspace and update the relevant div
registers

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 sound/soc/jz4740/jz4740-i2s.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index d3d45c6..98c77a63 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -77,12 +77,15 @@
 #define JZ_AIC_CTRL_INPUT_SAMPLE_SIZE_OFFSET  16
 
 #define JZ_AIC_I2S_FMT_DISABLE_BIT_CLK BIT(12)
+#define JZ_AIC_I2S_FMT_DISABLE_BIT_ICLK BIT(13)
 #define JZ_AIC_I2S_FMT_ENABLE_SYS_CLK BIT(4)
 #define JZ_AIC_I2S_FMT_MSB BIT(0)
 
 #define JZ_AIC_I2S_STATUS_BUSY BIT(2)
 
 #define JZ_AIC_CLK_DIV_MASK 0xf
+#define I2SDIV_DV_SHIFT 8
+#define I2SDIV_DV_MASK (0xf << I2SDIV_DV_SHIFT)
 
 struct jz4740_i2s {
 	struct resource *mem;
@@ -237,10 +240,14 @@ static int jz4740_i2s_hw_params(struct snd_pcm_substream *substream,
 {
 	struct jz4740_i2s *i2s = snd_soc_dai_get_drvdata(dai);
 	unsigned int sample_size;
-	uint32_t ctrl;
+	uint32_t ctrl, div_reg;
+	int div;
 
 	ctrl = jz4740_i2s_read(i2s, JZ_REG_AIC_CTRL);
 
+	div_reg = jz4740_i2s_read(i2s, JZ_REG_AIC_CLK_DIV);
+	div = clk_get_rate(i2s->clk_i2s) / (64 * params_rate(params));
+
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S8:
 		sample_size = 0;
@@ -264,7 +271,10 @@ static int jz4740_i2s_hw_params(struct snd_pcm_substream *substream,
 		ctrl |= sample_size << JZ_AIC_CTRL_INPUT_SAMPLE_SIZE_OFFSET;
 	}
 
+	div_reg &= ~I2SDIV_DV_MASK;
+	div_reg |= (div - 1) << I2SDIV_DV_SHIFT;
 	jz4740_i2s_write(i2s, JZ_REG_AIC_CTRL, ctrl);
+	jz4740_i2s_write(i2s, JZ_REG_AIC_CLK_DIV, div_reg);
 
 	return 0;
 }
-- 
1.9.1

