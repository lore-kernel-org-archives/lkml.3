Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaAFX1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:27:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbaAFWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 007/129] ASoC: tegra: fix uninitialized variables in set_fmt
Date: Mon,  6 Jan 2014 14:37:16 -0800
Message-Id: <20140106223859.798570015@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra20_i2s.c   |    6 +++---
 sound/soc/tegra/tegra20_spdif.c |   10 +++++-----
 sound/soc/tegra/tegra30_i2s.c   |    6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/sound/soc/tegra/tegra20_i2s.c
+++ b/sound/soc/tegra/tegra20_i2s.c
@@ -74,7 +74,7 @@ static int tegra20_i2s_set_fmt(struct sn
 				unsigned int fmt)
 {
 	struct tegra20_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	unsigned int mask, val;
+	unsigned int mask = 0, val = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF:
@@ -83,10 +83,10 @@ static int tegra20_i2s_set_fmt(struct sn
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
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -67,15 +67,15 @@ static int tegra20_spdif_hw_params(struc
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
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -117,7 +117,7 @@ static int tegra30_i2s_set_fmt(struct sn
 				unsigned int fmt)
 {
 	struct tegra30_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	unsigned int mask, val;
+	unsigned int mask = 0, val = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF:
@@ -126,10 +126,10 @@ static int tegra30_i2s_set_fmt(struct sn
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


