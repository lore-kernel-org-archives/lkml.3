Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3GWIqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:46:32 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:36776 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab3GWIqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:46:11 -0400
Date: Tue, 23 Jul 2013 10:46:15 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@vger.kernel.org
Subject: [PATCH v3] ARM: kirkwood: extend the kirkwood i2s driver for DT
 usage
Message-ID: <20130723104615.3696f1a9@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kirkwood i2s driver is used without DT in the Kirkwood machine.
This patch adds a DT compatible definition for use in other Marvell
machines as the Armada 88AP510 (Dove).

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v3
  - change compatible from kirkwood to mvebu (Andrew Lunn)
v2
  - this patch replaces the previous
	[PATCH 2/2] ARM: kirkwood: extend the kirkwood i2s driver for DT usage
  - 2 possible clocks (Sebastian Hesselbarth)
  - shorter io mapping (Andrew Lunn)
  - less #ifdef's
---
 Documentation/devicetree/bindings/sound/kirkwood-i2s.txt | 24 +++++++++++
 sound/soc/kirkwood/kirkwood-i2s.c                        | 58 ++++++++++++++++++++------
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/kirkwood-i2s.txt b/Documentation/devicetree/bindings/sound/kirkwood-i2s.txt
new file mode 100644
index 0000000..8f1e534
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/kirkwood-i2s.txt
@@ -0,0 +1,24 @@
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
+Example:
+
+i2s1: audio-controller@b4000 {
+	compatible = "marvell,mvebu-i2s";
+	reg = <0xb4000 0x2210>;
+	interrupts = <21>, <22>;
+	clocks = <&gate_clk 13>;
+};
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 4c9dad3..019e340 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
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
@@ -461,6 +462,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	struct snd_soc_dai_driver *soc_dai = &kirkwood_i2s_dai;
 	struct kirkwood_dma_data *priv;
 	struct resource *mem;
+	struct device_node *np;
 	int err;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -481,24 +483,45 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	if (!data) {
-		dev_err(&pdev->dev, "no platform data ?!\n");
-		return -EINVAL;
+	/* get the DT or static parameters */
+	np = pdev->dev.of_node;
+	if (np) {
+		struct of_phandle_args clkspec;
+
+		priv->burst = 128;			/* might be 32 or 128 */
+		priv->clk = of_clk_get(np, 0);	/* internal clock */
+		err = of_parse_phandle_with_args(np,
+					"clocks", "#clock-cells", 1,
+					&clkspec);
+		if (err) {
+			priv->extclk = ERR_PTR(-EINVAL); /* no external clock */
+		} else {
+			priv->extclk = of_clk_get(np, 1);
+			if (IS_ERR(priv->extclk)) {
+				err = -EPROBE_DEFER;
+				goto fail;
+			}
+		}
+	} else {
+		if (!data) {
+			dev_err(&pdev->dev, "no platform data ?!\n");
+			return -EINVAL;
+		}
+		priv->burst = data->burst;
+		priv->clk = clk_get(&pdev->dev, NULL);
+		priv->extclk = clk_get(&pdev->dev, "extclk");
 	}
 
-	priv->burst = data->burst;
-
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		dev_err(&pdev->dev, "no clock\n");
-		return PTR_ERR(priv->clk);
+		err = PTR_ERR(priv->clk);
+		goto fail;
 	}
 
 	err = clk_prepare_enable(priv->clk);
 	if (err < 0)
-		return err;
+		goto fail;
 
-	priv->extclk = clk_get(&pdev->dev, "extclk");
 	if (!IS_ERR(priv->extclk)) {
 		if (priv->extclk == priv->clk) {
 			clk_put(priv->extclk);
@@ -515,7 +538,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	priv->ctl_rec = KIRKWOOD_RECCTL_SIZE_24;
 
 	/* Select the burst size */
-	if (data->burst == 32) {
+	if (priv->burst == 32) {
 		priv->ctl_play |= KIRKWOOD_PLAYCTL_BURST_32;
 		priv->ctl_rec |= KIRKWOOD_RECCTL_BURST_32;
 	} else {
@@ -528,12 +551,13 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	if (!err)
 		return 0;
 	dev_err(&pdev->dev, "snd_soc_register_component failed\n");
-
+fail:
 	if (!IS_ERR(priv->extclk)) {
 		clk_disable_unprepare(priv->extclk);
 		clk_put(priv->extclk);
 	}
 	clk_disable_unprepare(priv->clk);
+	clk_put(priv->clk);
 
 	return err;
 }
@@ -549,16 +573,26 @@ static int kirkwood_i2s_dev_remove(struct platform_device *pdev)
 		clk_put(priv->extclk);
 	}
 	clk_disable_unprepare(priv->clk);
+	clk_put(priv->clk);
 
 	return 0;
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
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
