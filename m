Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3GaGRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:17:08 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:39877 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab3GaGRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:17:05 -0400
Date: Wed, 31 Jul 2013 08:17:39 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 1/4] ASoc: kirkwood: simplify probe error
Message-ID: <20130731081739.76aae84c@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function kirkwood_i2s_dev_remove() may be used when probe fails.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/kirkwood/kirkwood-i2s.c           | 40 +++++++++++-----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 0109b1e..319086f 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -449,6 +449,19 @@ static const struct snd_soc_component_driver kirkwood_i2s_component = {
 	.name		= DRV_NAME,
 };
 
+static int kirkwood_i2s_dev_remove(struct platform_device *pdev)
+{
+	struct kirkwood_dma_data *priv = dev_get_drvdata(&pdev->dev);
+
+	snd_soc_unregister_component(&pdev->dev);
+
+	if (!IS_ERR(priv->extclk))
+		clk_disable_unprepare(priv->extclk);
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
 static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 {
 	struct kirkwood_asoc_platform_data *data = pdev->dev.platform_data;
@@ -519,30 +532,17 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 
 	err = snd_soc_register_component(&pdev->dev, &kirkwood_i2s_component,
 					 soc_dai, 1);
-	if (!err)
-		return 0;
-	dev_err(&pdev->dev, "snd_soc_register_component failed\n");
-
-	if (!IS_ERR(priv->extclk))
-		clk_disable_unprepare(priv->extclk);
-	clk_disable_unprepare(priv->clk);
+	if (err) {
+		dev_err(&pdev->dev, "snd_soc_register_component failed\n");
+		goto fail;
+	}
+	return 0;
 
+fail:
+	kirkwood_i2s_dev_remove(pdev);
 	return err;
 }
 
-static int kirkwood_i2s_dev_remove(struct platform_device *pdev)
-{
-	struct kirkwood_dma_data *priv = dev_get_drvdata(&pdev->dev);
-
-	snd_soc_unregister_component(&pdev->dev);
-
-	if (!IS_ERR(priv->extclk))
-		clk_disable_unprepare(priv->extclk);
-	clk_disable_unprepare(priv->clk);
-
-	return 0;
-}
-
 static struct platform_driver kirkwood_i2s_driver = {
 	.probe  = kirkwood_i2s_dev_probe,
 	.remove = kirkwood_i2s_dev_remove,

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
