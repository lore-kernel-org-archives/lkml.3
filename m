Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3GYSkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:40:39 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:52750 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907Ab3GYSka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:40:30 -0400
Date: Thu, 25 Jul 2013 20:40:37 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 4/4 v2] ASoc: kirkwood: add DT support
Message-ID: <20130725204037.6ffc62d5@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kirkwood audio driver is used without DT in the Kirkwood machine.
This patch adds a DT compatible definition for use in other Marvell
machines as the Armada 88AP510 (Dove).

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v2
	fix compilation error
---
 Documentation/devicetree/bindings/sound/kirkwood-i2s.txt | 29 ++++++++++++++++++
 sound/soc/kirkwood/kirkwood-i2s.c                        | 35 +++++++++++++++-------
 2 files changed, 53 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/kirkwood-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/kirkwood-i2s.txt b/Documentation/devicetree/bindings/sound/kirkwood-i2s.txt
new file mode 100644
index 0000000..015a769
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/kirkwood-i2s.txt
@@ -0,0 +1,29 @@
+* mvebu (Kirkwood, Dove, Armada 370) I2S controller
+
+Required properties:
+
+- compatible: "marvell,mvebu-i2s"
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- interrupts: list of two irq numbers.
+  The first irq is used for data flow and the second one is used for errors.
+
+- clocks: one or two phandles.
+  The first one is mandatory and defines the internal clock.
+  The second one is optional and defines an external clock.
+
+- clock-names: names associated to the clocks:
+	"internal" for the internal clock
+	"external" for the external clock
+
+Example:
+
+i2s1: audio-controller@b4000 {
+	compatible = "marvell,mvebu-i2s";
+	reg = <0xb4000 0x2210>;
+	interrupts = <21>, <22>;
+	clocks = <&gate_clk 13>;
+	clock-names = "internal";
+};
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/home/jef/kernel/sound/soc/kirkwood/kirkwood-i2s.c.new
index a1037e2..26c2f74 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/home/jef/kernel/sound/soc/kirkwood/kirkwood-i2s.c.new
@@ -12,7 +12,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/mbus.h>
@@ -22,6 +21,8 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <linux/platform_data/asoc-kirkwood.h>
+#include <linux/of.h>
+
 #include "kirkwood.h"
 
 #define DRV_NAME	"kirkwood-i2s"
@@ -477,6 +478,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	struct snd_soc_dai_driver *soc_dai = &kirkwood_i2s_dai;
 	struct kirkwood_dma_data *priv;
 	struct resource *mem;
+	struct device_node *np = pdev->dev.of_node;
 	int err;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -497,16 +499,18 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	if (!data) {
-		dev_err(&pdev->dev, "no platform data ?!\n");
-		return -EINVAL;
-	}
-
-	priv->burst = data->burst;
+	if (np) {
+		priv->burst = 128;		/* might be 32 or 128 */
+	} else if (data) {
+		priv->burst = data->burst;
+	} else {
+		dev_err(&pdev->dev, "no DT nor platform data ?!\n");
+ 		return -EINVAL;
+ 	}
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	priv->clk = devm_clk_get(&pdev->dev, "internal");
 	if (IS_ERR(priv->clk)) {
-		dev_err(&pdev->dev, "no clock\n");
+		dev_err(&pdev->dev, "no internal clock\n");
 		return PTR_ERR(priv->clk);
 	}
 
@@ -514,7 +518,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	priv->extclk = clk_get(&pdev->dev, "extclk");
+	priv->extclk = clk_get(&pdev->dev, "external");
 	if (!IS_ERR(priv->extclk)) {
 		if (priv->extclk == priv->clk) {
 			clk_put(priv->extclk);
@@ -531,7 +535,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	priv->ctl_rec = KIRKWOOD_RECCTL_SIZE_24;
 
 	/* Select the burst size */
-	if (data->burst == 32) {
+	if (priv->burst == 32) {
 		priv->ctl_play |= KIRKWOOD_PLAYCTL_BURST_32;
 		priv->ctl_rec |= KIRKWOOD_RECCTL_BURST_32;
 	} else {
@@ -557,12 +561,21 @@ fail:
 	return err;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id kirkwood_i2s_of_match[] = {
+	{ .compatible = "marvell,mvebu-i2s" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, kirkwood_i2s_of_match);
+#endif
+
 static struct platform_driver kirkwood_i2s_driver = {
 	.probe  = kirkwood_i2s_dev_probe,
 	.remove = kirkwood_i2s_dev_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(kirkwood_i2s_of_match),
 	},
 };
 
-- 
1.8.3.2



-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
