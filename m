Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaHFNrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:47:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39910 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaHFNrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:47:37 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <airlied@linux.ie>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <bcousson@baylibre.com>
CC: <tony@atomide.com>, <broonie@kernel.org>,
        <liam.r.girdwood@linux.intel.com>, <peter.ujfalusi@ti.com>,
        <detheridge@ti.com>, <zonque@gmail.com>, <t-kristo@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 1/9] ASoC: mcasp: Fix implicit BLCK divider setting
Date: Wed, 6 Aug 2014 16:47:16 +0300
Message-ID: <5e5987c830439e39d26a44580ebe01de631c10cc.1407332062.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407332062.git.jsarha@ti.com>
References: <cover.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implicit BLCK divider setting was broken by "ASoC: mcasp: don't
override bclk divider if it was provided by the machine"-patch. After
the BCLK divider is implicitly set for the first time the
mcasp->bclk_div gets a non zero value and the implicit setting is
"turned off".

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 sound/soc/davinci/davinci-mcasp.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index c28508d..6a6b2ff 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -403,7 +403,8 @@ out:
 	return ret;
 }
 
-static int davinci_mcasp_set_clkdiv(struct snd_soc_dai *dai, int div_id, int div)
+static int __davinci_mcasp_set_clkdiv(struct snd_soc_dai *dai, int div_id,
+				      int div, bool explicit)
 {
 	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(dai);
 
@@ -420,7 +421,8 @@ static int davinci_mcasp_set_clkdiv(struct snd_soc_dai *dai, int div_id, int div
 			       ACLKXDIV(div - 1), ACLKXDIV_MASK);
 		mcasp_mod_bits(mcasp, DAVINCI_MCASP_ACLKRCTL_REG,
 			       ACLKRDIV(div - 1), ACLKRDIV_MASK);
-		mcasp->bclk_div = div;
+		if (explicit)
+			mcasp->bclk_div = div;
 		break;
 
 	case 2:		/* BCLK/LRCLK ratio */
@@ -434,6 +436,12 @@ static int davinci_mcasp_set_clkdiv(struct snd_soc_dai *dai, int div_id, int div
 	return 0;
 }
 
+static int davinci_mcasp_set_clkdiv(struct snd_soc_dai *dai, int div_id,
+				    int div)
+{
+	return __davinci_mcasp_set_clkdiv(dai, div_id, div, 1);
+}
+
 static int davinci_mcasp_set_sysclk(struct snd_soc_dai *dai, int clk_id,
 				    unsigned int freq, int dir)
 {
@@ -738,7 +746,7 @@ static int davinci_mcasp_hw_params(struct snd_pcm_substream *substream,
 				 "Inaccurate BCLK: %u Hz / %u != %u Hz\n",
 				 mcasp->sysclk_freq, div, bclk_freq);
 		}
-		davinci_mcasp_set_clkdiv(cpu_dai, 1, div);
+		__davinci_mcasp_set_clkdiv(cpu_dai, 1, div, 0);
 	}
 
 	ret = mcasp_common_hw_param(mcasp, substream->stream,
-- 
1.7.9.5

