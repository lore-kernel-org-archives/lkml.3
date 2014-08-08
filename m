Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaHHNfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:35:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42567 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbaHHNfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:35:14 -0400
Date: Fri, 8 Aug 2014 14:35:10 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@linaro.org, lee.jones@linaro.org, sameo@linux.intel.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3 v4 RESEND] ASoC: arizona: Add DVFS handling for sample
	rate control
Message-ID: <20140808133510.GC2665@opensource.wolfsonmicro.com>
References: <20140808133233.GA2665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808133233.GA2665@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

Some codecs need to boost DVFS for higher sample rates.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/arizona.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index d441d80..c5b6be2 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -1185,7 +1185,7 @@ static int arizona_hw_params_rate(struct snd_pcm_substream *substream,
 	struct arizona_priv *priv = snd_soc_codec_get_drvdata(codec);
 	struct arizona_dai_priv *dai_priv = &priv->dai[dai->id - 1];
 	int base = dai->driver->base;
-	int i, sr_val;
+	int i, sr_val, ret;
 
 	/*
 	 * We will need to be more flexible than this in future,
@@ -1201,6 +1201,26 @@ static int arizona_hw_params_rate(struct snd_pcm_substream *substream,
 	}
 	sr_val = i;
 
+	switch (priv->arizona->type) {
+	case WM5102:
+	case WM8997:
+		if (arizona_sr_vals[sr_val] >= 88200)
+			ret = arizona_dvfs_up(priv->arizona,
+					      ARIZONA_DVFS_SR1_RQ);
+		else
+			ret = arizona_dvfs_down(priv->arizona,
+						ARIZONA_DVFS_SR1_RQ);
+
+		if (ret != 0) {
+			arizona_aif_err(dai, "Failed to change DVFS %d\n", ret);
+			return ret;
+		}
+		break;
+
+	default:
+		break;
+	}
+
 	switch (dai_priv->clk) {
 	case ARIZONA_CLK_SYSCLK:
 		switch (priv->arizona->type) {
-- 
1.7.2.5

