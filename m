Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3KFKRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:17:47 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48468 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3KFKRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 12/13] ASoC: ux500_pcm: Differentiate between pdata and DT initialisation
Date: Wed,  6 Nov 2013 10:16:24 +0000
Message-Id: <1383732985-18928-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If booting with full DT support (i.e. DMA too, the last piece of the
puzzle), then we don't need to use the compatible request channel call
back and, due to the work we laid down earlier in this patch-set, we
can use core function calls to populate the DMA slave_config. We also
require slightly different flags to inform the core that we 'are'
booting with DT.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index ce554de..acfec98 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -139,15 +139,33 @@ static const struct snd_dmaengine_pcm_config ux500_dmaengine_pcm_config = {
 	.prepare_slave_config = ux500_pcm_prepare_slave_config,
 };
 
+static const struct snd_dmaengine_pcm_config ux500_dmaengine_of_pcm_config = {
+	.pcm_hardware = &ux500_pcm_hw,
+	.prealloc_buffer_size = 128 * 1024,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+};
+
 int ux500_pcm_register_platform(struct platform_device *pdev)
 {
+	const struct snd_dmaengine_pcm_config *pcm_config;
+	struct device_node *np = pdev->dev.of_node;
+	unsigned int pcm_flags;
 	int ret;
 
-	ret = snd_dmaengine_pcm_register(&pdev->dev,
-			&ux500_dmaengine_pcm_config,
-			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
-			SND_DMAENGINE_PCM_FLAG_COMPAT |
-			SND_DMAENGINE_PCM_FLAG_NO_DT);
+	if (np) {
+		pcm_config = &ux500_dmaengine_of_pcm_config;
+
+		pcm_flags = SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
+			SND_DMAENGINE_PCM_FLAG_COMPAT;
+	} else {
+		pcm_config = &ux500_dmaengine_pcm_config;
+
+		pcm_flags = SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
+			SND_DMAENGINE_PCM_FLAG_NO_DT |
+			SND_DMAENGINE_PCM_FLAG_COMPAT;
+	}
+
+	ret = snd_dmaengine_pcm_register(&pdev->dev, pcm_config, pcm_flags);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"%s: ERROR: Failed to register platform '%s' (%d)!\n",
-- 
1.8.1.2

