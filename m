Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbaJIVTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:19:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbaJIVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Zhen <zhen1.chen@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 086/163] ASoC: samsung-i2s: Maintain CDCLK settings across i2s_{shutdown/startup}
Date: Thu,  9 Oct 2014 14:01:51 -0700
Message-Id: <1412888588-26755-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit b97c60abf9a561f86ae71bd741add02673cc1a08 upstream.

Currently configuration of the CDCLK pad is being overwritten in
the i2s_shutdown() callback in order to gate the SoC output clock.
However if an ASoC machine driver doesn't restore that clock
settings each time after opening the sound device this results
in the CDCLK pin being permanently configured into input mode.
I.e. the output clock will always stay disabled.
Fix that by saving the CDCLKCON bit state in i2s_shutdown() and
and restoring it in the i2s_startup() callback.

Signed-off-by: Chen Zhen <zhen1.chen@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[ kamal: 3.13-stable prereq for
  133c268 "ASoC: samsung-i2s: Check secondary DAI exists before referencing". ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/samsung/i2s.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 27ca0aa..69160f7 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -70,6 +70,8 @@ struct i2s_dai {
 #define DAI_OPENED	(1 << 0) /* Dai is opened */
 #define DAI_MANAGER	(1 << 1) /* Dai is the manager */
 	unsigned mode;
+	/* CDCLK pin direction: 0  - input, 1 - output */
+	unsigned int cdclk_out:1;
 	/* Driver for this DAI */
 	struct snd_soc_dai_driver i2s_dai_drv;
 	/* DMA parameters */
@@ -732,6 +734,9 @@ static int i2s_startup(struct snd_pcm_substream *substream,
 
 	spin_unlock_irqrestore(&lock, flags);
 
+	if (!is_opened(other) && i2s->cdclk_out)
+		i2s_set_sysclk(dai, SAMSUNG_I2S_CDCLK,
+				0, SND_SOC_CLOCK_OUT);
 	return 0;
 }
 
@@ -747,9 +752,13 @@ static void i2s_shutdown(struct snd_pcm_substream *substream,
 	i2s->mode &= ~DAI_OPENED;
 	i2s->mode &= ~DAI_MANAGER;
 
-	if (is_opened(other))
+	if (is_opened(other)) {
 		other->mode |= DAI_MANAGER;
-
+	} else {
+		u32 mod = readl(i2s->addr + I2SMOD);
+		i2s->cdclk_out = !(mod & MOD_CDCLKCON);
+		other->cdclk_out = i2s->cdclk_out;
+	}
 	/* Reset any constraint on RFS and BFS */
 	i2s->rfs = 0;
 	i2s->bfs = 0;
-- 
1.9.1

