Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaCMJWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:22:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33145 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaCMJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:20:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 15/18] ASoC: davinci-mcasp: Use dmaengine based platform driver for AM335x/447x
Date: Thu, 13 Mar 2014 11:18:37 +0200
Message-ID: <1394702320-21743-16-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the edma-pcm with AM335x and AM447x SoCs.
Keep using the davinci-pcm for DaVinci devices, they can be switched to use
the dmaengine based driver later when they are verified to work correctly.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/davinci/davinci-mcasp.c | 46 +++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index b0ae0677f023..604aa982f5c4 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -36,6 +36,7 @@
 
 #include "davinci-pcm.h"
 #include "davinci-mcasp.h"
+#include "edma-pcm.h"
 
 struct davinci_mcasp_context {
 	u32	txfmtctl;
@@ -721,10 +722,12 @@ static int davinci_mcasp_startup(struct snd_pcm_substream *substream,
 {
 	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(dai);
 
-	if (mcasp->version == MCASP_VERSION_4)
+	if (mcasp->version >= MCASP_VERSION_3)
+		/* Using dmaengine PCM */
 		snd_soc_dai_set_dma_data(dai, substream,
 					&mcasp->dma_data[substream->stream]);
 	else
+		/* Using davinci-pcm */
 		snd_soc_dai_set_dma_data(dai, substream, mcasp->dma_params);
 
 	return 0;
@@ -1154,12 +1157,28 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (ret != 0)
 		goto err_release_clk;
 
-	if (mcasp->version != MCASP_VERSION_4) {
+	/* Based on the McASP version use different platform driver */
+	switch (mcasp->version) {
+	case MCASP_VERSION_1:
+	case MCASP_VERSION_2:
 		ret = davinci_soc_platform_register(&pdev->dev);
-		if (ret) {
-			dev_err(&pdev->dev, "register PCM failed: %d\n", ret);
-			goto err_unregister_component;
-		}
+		break;
+	case MCASP_VERSION_3:
+		ret = edma_pcm_platform_register(&pdev->dev);
+		break;
+	case MCASP_VERSION_4:
+		/* Using omap-pcm as platform driver */
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid McASP version: %d\n",
+			mcasp->version);
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret) {
+		dev_err(&pdev->dev, "register PCM failed: %d\n", ret);
+		goto err_unregister_component;
 	}
 
 	return 0;
@@ -1177,8 +1196,21 @@ static int davinci_mcasp_remove(struct platform_device *pdev)
 	struct davinci_mcasp *mcasp = dev_get_drvdata(&pdev->dev);
 
 	snd_soc_unregister_component(&pdev->dev);
-	if (mcasp->version != MCASP_VERSION_4)
+
+	switch (mcasp->version) {
+	case MCASP_VERSION_1:
+	case MCASP_VERSION_2:
 		davinci_soc_platform_unregister(&pdev->dev);
+		break;
+	case MCASP_VERSION_3:
+		edma_pcm_platform_unregister(&pdev->dev);
+		break;
+	case MCASP_VERSION_4:
+		/* Using omap-pcm as platform driver */
+		break;
+	default:
+		break;
+	}
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
1.9.0

