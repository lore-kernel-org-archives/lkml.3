Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaAMQB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52972 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaAMQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/208] ASoC: tegra: fix uninitialized variables in set_fmt
Date: Mon, 13 Jan 2014 15:57:56 +0000
Message-Id: <1389628849-1614-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 241bf43321a10815225f477bba96a42285a2da73 upstream.

In tegra*_i2s_set_fmt(), in the (fmt == SND_SOC_DAIFMT_CBM_CFM) case,
"val" is never assigned to, but left uninitialized. The other case does
initialized it. Fix this by initializing val at the start of the
function, and only ever ORing into it.

Update the handling of "mask" so it works the same way for consistency.

Update tegra20_spdif.c to use the same code-style for consistency, even
though it doesn't happen to suffer from the same problem at present.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Fixes: 0f163546a772 ("ASoC: tegra: use regmap more directly")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/tegra/tegra20_i2s.c   |  6 +++---
 sound/soc/tegra/tegra20_spdif.c | 10 +++++-----
 sound/soc/tegra/tegra30_i2s.c   |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/soc/tegra/tegra20_i2s.c b/sound/soc/tegra/tegra20_i2s.c
index 52af7f6..540832e 100644
--- a/sound/soc/tegra/tegra20_i2s.c
+++ b/sound/soc/tegra/tegra20_i2s.c
@@ -74,7 +74,7 @@ static int tegra20_i2s_set_fmt(struct snd_soc_dai *dai,
 				unsigned int fmt)
 {
 	struct tegra20_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	unsigned int mask, val;
+	unsigned int mask = 0, val = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF:
@@ -83,10 +83,10 @@ static int tegra20_i2s_set_fmt(struct snd_soc_dai *dai,
 		return -EINVAL;
 	}
 
-	mask = TEGRA20_I2S_CTRL_MASTER_ENABLE;
+	mask |= TEGRA20_I2S_CTRL_MASTER_ENABLE;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-		val = TEGRA20_I2S_CTRL_MASTER_ENABLE;
+		val |= TEGRA20_I2S_CTRL_MASTER_ENABLE;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		break;
diff --git a/sound/soc/tegra/tegra20_spdif.c b/sound/soc/tegra/tegra20_spdif.c
index 551b3c9..2e7d4ac 100644
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -67,15 +67,15 @@ static int tegra20_spdif_hw_params(struct snd_pcm_substream *substream,
 {
 	struct device *dev = dai->dev;
 	struct tegra20_spdif *spdif = snd_soc_dai_get_drvdata(dai);
-	unsigned int mask, val;
+	unsigned int mask = 0, val = 0;
 	int ret, spdifclock;
 
-	mask = TEGRA20_SPDIF_CTRL_PACK |
-	       TEGRA20_SPDIF_CTRL_BIT_MODE_MASK;
+	mask |= TEGRA20_SPDIF_CTRL_PACK |
+		TEGRA20_SPDIF_CTRL_BIT_MODE_MASK;
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
-		val = TEGRA20_SPDIF_CTRL_PACK |
-		      TEGRA20_SPDIF_CTRL_BIT_MODE_16BIT;
+		val |= TEGRA20_SPDIF_CTRL_PACK |
+		       TEGRA20_SPDIF_CTRL_BIT_MODE_16BIT;
 		break;
 	default:
 		return -EINVAL;
diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 47565fd04..732e9cb 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -117,7 +117,7 @@ static int tegra30_i2s_set_fmt(struct snd_soc_dai *dai,
 				unsigned int fmt)
 {
 	struct tegra30_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	unsigned int mask, val;
+	unsigned int mask = 0, val = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF:
@@ -126,10 +126,10 @@ static int tegra30_i2s_set_fmt(struct snd_soc_dai *dai,
 		return -EINVAL;
 	}
 
-	mask = TEGRA30_I2S_CTRL_MASTER_ENABLE;
+	mask |= TEGRA30_I2S_CTRL_MASTER_ENABLE;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-		val = TEGRA30_I2S_CTRL_MASTER_ENABLE;
+		val |= TEGRA30_I2S_CTRL_MASTER_ENABLE;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		break;
-- 
1.8.3.2

