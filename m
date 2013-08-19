Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab3HSIxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:53:19 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:59236 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab3HSIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:52:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="29716857"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: kernel-janitors@vger.kernel.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] ASoC: omap: simplify platform_get_resource_byname/devm_ioremap_resource
Date: Mon, 19 Aug 2013 10:51:51 +0200
Message-Id: <1376902316-18520-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource_byname when the value is passed to devm_ioremap_resource.

In the case of omap-dmic.c, the error-handling code of
devm_ioremap_resource is also corrected to include releasing the clock.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,e,e1;
expression ret != 0;
identifier l;
@@

  res = platform_get_resource_byname(...);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/soc/omap/omap-dmic.c  |    9 +++------
 sound/soc/omap/omap-mcpdm.c |    3 ---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 4db1f8e..12e566b 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -480,15 +480,12 @@ static int asoc_dmic_probe(struct platform_device *pdev)
 	dmic->dma_data.filter_data = "up_link";
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpu");
-	if (!res) {
-		dev_err(dmic->dev, "invalid memory resource\n");
-		ret = -ENODEV;
+	dmic->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dmic->io_base)) {
+		ret = PTR_ERR(dmic->io_base);
 		goto err_put_clk;
 	}
 
-	dmic->io_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dmic->io_base))
-		return PTR_ERR(dmic->io_base);
 
 	ret = snd_soc_register_component(&pdev->dev, &omap_dmic_component,
 					 &omap_dmic_dai, 1);
diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index a49dc52..90d2a7c 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -480,9 +480,6 @@ static int asoc_mcpdm_probe(struct platform_device *pdev)
 	mcpdm->dma_data[1].filter_data = "up_link";
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpu");
-	if (res == NULL)
-		return -ENOMEM;
-
 	mcpdm->io_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(mcpdm->io_base))
 		return PTR_ERR(mcpdm->io_base);

