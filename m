Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaDWIG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:06:27 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46474 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbaDWIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:05:34 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com,
        jassisinghbrar@gmail.com, kgene.kim@samsung.com
Subject: [PATCH] ASoC: SAMSUNG: Don't clear clock setting during i2s_startup
Date: Wed, 23 Apr 2014 13:34:24 +0530
Message-Id: <1398240264-21285-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In exiting kernel, if DAIFMT flags are set in dai_link and I2S is
set to run in master mode, the I2S clocks are not getting configured
resulting in no output.

Existing code clears the current I2S clock settings during i2s_startup
and requires that the clocks are reconfigured. It then assumes that
sound-card driver would call snd_soc_dai_{set_sysclk/set_fmt} to
configure the root clock.

1. Since I2S clock settings remain fixed for a board, it would be better
to set the clocks once during sound-card probe.

2. Also if the DAIFMT flags are set in dai_link, snd_soc_dai_set_fmt is
called during DAI probe.

If both these conditions are true, then I2S clock remains unconfigured
during audio playback. Fix this by removing the code to clear
rclk_srcrate in i2s_startup. Instead, reset this during DAI probe.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
The patch is based on v3.15-rc2.

 sound/soc/samsung/i2s.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 048ead9..6e61db7 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -724,9 +724,6 @@ static int i2s_startup(struct snd_pcm_substream *substream,
 	else
 		i2s->mode |= DAI_MANAGER;
 
-	/* Enforce set_sysclk in Master mode */
-	i2s->rclk_srcrate = 0;
-
 	if (!any_active(i2s) && (i2s->quirks & QUIRK_NEED_RSTCLR))
 		writel(CON_RSTCLR, i2s->addr + I2SCON);
 
@@ -984,6 +981,7 @@ probe_exit:
 	/* Reset any constraint on RFS and BFS */
 	i2s->rfs = 0;
 	i2s->bfs = 0;
+	i2s->rclk_srcrate = 0;
 	i2s_txctrl(i2s, 0);
 	i2s_rxctrl(i2s, 0);
 	i2s_fifo(i2s, FIC_TXFLUSH);
-- 
1.7.9.5

