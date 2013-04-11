Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937595Ab3DKAHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937293Ab3DKAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 19/30] ASoC: samsung: use irq resource for idma
Date: Thu, 11 Apr 2013 02:05:01 +0200
Message-Id: <1365638712-1028578-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:W1LMyliDYmYnhjx6YianlIGPi7nbkkfOruo6YqYfAYL
 jAlpN+DmsPavVP7uH+VLj1c12tvSZ28RkBXnTXQfhujYonjFod
 Vv5hwCEeeOxEwmXmlFXCenAwIinfGJpioOUA/G/tFU+39lH9qt
 sDdpaBwaTV8KyiSw0C/Djgm3Wgj61xNrtcDL5YHw8tCcllyZs6
 JRf44osS9oSpUcxLv5jKW9tjERMT0YAjQlCOHADkmAhoJT2WL5
 0/z7XH9drBrtMyUuZuUjyDTore558Cp/oaJVPtABzQa8CxLFA/
 ETV5b8DnJG9/X6l609phVQuyYcDxU/GTDJKm0qe2XwGiu60zc3
 FUjRD4UZiuRK4noYwYzkaEk2aMvD2x6vozpMmMLdpOXkJ668gY
 CtlU7gdwsKnhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With multiplatform kernels, we cannot use hardwired IRQ
numbers in device drivers. This changes the idma driver
to use a proper resource, like all other drivers do.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 arch/arm/plat-samsung/devs.c |  6 ++++++
 sound/soc/samsung/idma.c     | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 78be9c0..b441908 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -145,14 +145,20 @@ struct platform_device s3c_device_camif = {
 
 /* ASOC DMA */
 
+#ifdef CONFIG_PLAT_S5P 
+static struct resource samsung_asoc_idma_resource = DEFINE_RES_IRQ(IRQ_I2S0);
+
 struct platform_device samsung_asoc_idma = {
 	.name		= "samsung-idma",
 	.id		= -1,
+	.num_resources	= 1,
+	.resource	= &samsung_asoc_idma_resource,
 	.dev		= {
 		.dma_mask		= &samsung_device_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}
 };
+#endif
 
 /* FB */
 
diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index a07950b..f36a541 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -68,6 +68,8 @@ static struct idma_info {
 	dma_addr_t	lp_tx_addr;
 } idma;
 
+static int idma_irq;
+
 static void idma_getpos(dma_addr_t *src)
 {
 	*src = idma.lp_tx_addr +
@@ -305,7 +307,7 @@ static int idma_open(struct snd_pcm_substream *substream)
 	if (prtd == NULL)
 		return -ENOMEM;
 
-	ret = request_irq(IRQ_I2S0, iis_irq, 0, "i2s", prtd);
+	ret = request_irq(idma_irq, iis_irq, 0, "i2s", prtd);
 	if (ret < 0) {
 		pr_err("fail to claim i2s irq , ret = %d\n", ret);
 		kfree(prtd);
@@ -324,7 +326,7 @@ static int idma_close(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct idma_ctrl *prtd = runtime->private_data;
 
-	free_irq(IRQ_I2S0, prtd);
+	free_irq(idma_irq, prtd);
 
 	if (!prtd)
 		pr_err("idma_close called with prtd == NULL\n");
@@ -418,6 +420,10 @@ static struct snd_soc_platform_driver asoc_idma_platform = {
 
 static int asoc_idma_platform_probe(struct platform_device *pdev)
 {
+	idma_irq = platform_get_irq(pdev, 0);
+	if (idma_irq < 0)
+		return idma_irq;
+
 	return snd_soc_register_platform(&pdev->dev, &asoc_idma_platform);
 }
 
-- 
1.8.1.2

