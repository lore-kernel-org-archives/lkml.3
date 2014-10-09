Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbaJIVa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:30:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592AbaJIVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 087/163] ASoC: samsung-i2s: Check secondary DAI exists before referencing
Date: Thu,  9 Oct 2014 14:01:52 -0700
Message-Id: <1412888588-26755-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 133c2681c4a0c1b589d138c2fdd0f131bdce20ed upstream.

In a couple of places the driver is missing a check to ensure there is a
secondary DAI before it de-references the pointer to it, causing a null
pointer de-reference. This patch adds a check to avoid this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/samsung/i2s.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 69160f7..81c04c5 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -460,7 +460,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai,
 		if (dir == SND_SOC_CLOCK_IN)
 			rfs = 0;
 
-		if ((rfs && other->rfs && (other->rfs != rfs)) ||
+		if ((rfs && other && other->rfs && (other->rfs != rfs)) ||
 				(any_active(i2s) &&
 				(((dir == SND_SOC_CLOCK_IN)
 					&& !(mod & MOD_CDCLKCON)) ||
@@ -757,7 +757,8 @@ static void i2s_shutdown(struct snd_pcm_substream *substream,
 	} else {
 		u32 mod = readl(i2s->addr + I2SMOD);
 		i2s->cdclk_out = !(mod & MOD_CDCLKCON);
-		other->cdclk_out = i2s->cdclk_out;
+		if (other)
+			other->cdclk_out = i2s->cdclk_out;
 	}
 	/* Reset any constraint on RFS and BFS */
 	i2s->rfs = 0;
-- 
1.9.1

