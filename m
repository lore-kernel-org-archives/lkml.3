Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaJXXsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:48:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38796 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaJXXsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:48:24 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org, b02247@freescale.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com
Subject: [PATCH] ASoC: fsl-asoc-card: Don't bypass settings if cpu-dai is Master
Date: Fri, 24 Oct 2014 16:48:11 -0700
Message-Id: <1414194502-14052-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1414193668.git.nicoleotsuka@gmail.com>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpu-dai is the DAI Master (CBM_CFx), it may need some configurations,
set_sysclk() call for eample, for cpu-dai side in the hw_params(), even if
the set_bias_level() has already taken care of the codec-dai side.

So this patch just simply adds an additional condition.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl-asoc-card.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 007c772..14572e6 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -125,7 +125,12 @@ static int fsl_asoc_card_hw_params(struct snd_pcm_substream *substream,
 	priv->sample_rate = params_rate(params);
 	priv->sample_format = params_format(params);
 
-	if (priv->card.set_bias_level)
+	/*
+	 * If codec-dai is DAI Master and all configurations are already in the
+	 * set_bias_level(), bypass the remaining settings in hw_params().
+	 * Note: (dai_fmt & CBM_CFM) includes CBM_CFM and CBM_CFS.
+	 */
+	if (priv->card.set_bias_level && priv->dai_fmt & SND_SOC_DAIFMT_CBM_CFM)
 		return 0;
 
 	/* Specific configurations of DAIs starts from here */
-- 
1.9.1

