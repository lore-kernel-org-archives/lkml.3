Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3HBOwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:52:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3HBOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:50:46 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v5 1/7] DMA: shdma: switch DT mode to use configuration data from a match table
Date: Fri,  2 Aug 2013 16:50:36 +0200
Message-Id: <1375455042-24093-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:yRwdxzHnO25YJ0rLQ/uWYpR6lbeB7SrLHjuDjiUx+5C
 FLQR9CofrbnL5g9VmemJHiNKgpobi3D1d25LDszMx3GjYkxows
 lSs5O6ceimlboCU+3Mv1ugrEbCMlnioaCDektKROK8Q6atui7K
 eZrEWC1FKMMXvMsvy4wfLkdAP1LA2F1CHLkFKdiEPFADi80taN
 ddw9CL7bJDOO+kmvda3H/G5p7D6IbWfqmXFT1VHs85sZ6l64xW
 S201t/lNQA+Cjp3UUBA7OSMPCUNkFyFVm1FQhGJFnH7ZWEJ1Jw
 7eCdKE9t4wL8jj6JZ9VnfiU0L+QAUy/RDD+U3QYIiQLi0haVTY
 FiL+5OoUDiOidCN9k+dapTfpuC6awflmcnvzMux0+xgJ7EvPlb
 0c7xU+9DbKD6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This facilitates DMAC DT support by eliminating the need in AUXDATA and
avoiding creating complex DT data. This also fits well with DMAC devices,
of which SoCs often have multiple identical copies and it is perfectly
valid to use a single configuration data set for all of them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v5: support taking slave addresses from dmaengine_slave_config() calls 
    and don't use slave IDs.

 Documentation/devicetree/bindings/dma/shdma.txt |   61 +++++++++++++----------
 drivers/dma/sh/Makefile                         |    2 +
 drivers/dma/sh/shdma-base.c                     |   15 +++--
 drivers/dma/sh/shdma-of.c                       |    3 -
 drivers/dma/sh/shdma.h                          |    1 +
 drivers/dma/sh/{shdma.c => shdmac.c}            |   30 +++++++----
 drivers/dma/sh/sudmac.c                         |    3 +-
 include/linux/shdma-base.h                      |    2 +-
 8 files changed, 69 insertions(+), 48 deletions(-)
 rename drivers/dma/sh/{shdma.c => shdmac.c} (98%)

diff --git a/Documentation/devicetree/bindings/dma/shdma.txt b/Documentation/devicetree/bindings/dma/shdma.txt
index c15994a..2a3f3b8 100644
--- a/Documentation/devicetree/bindings/dma/shdma.txt
+++ b/Documentation/devicetree/bindings/dma/shdma.txt
@@ -22,42 +22,51 @@ Optional properties (currently unused):
 * DMA controller
 
 Required properties:
-- compatible:	should be "renesas,shdma"
+- compatible:	should be of the form "renesas,shdma-<soc>", where <soc> should
+		be replaced with the desired SoC model, e.g.
+		"renesas,shdma-r8a73a4" for the system DMAC on r8a73a4 SoC
 
 Example:
-	dmac: dma-mux0 {
+	dmac: dma-multiplexer@0 {
 		compatible = "renesas,shdma-mux";
 		#dma-cells = <1>;
-		dma-channels = <6>;
+		dma-channels = <20>;
 		dma-requests = <256>;
-		reg = <0 0>;	/* Needed for AUXDATA */
-		#address-cells = <1>;
-		#size-cells = <1>;
+		#address-cells = <2>;
+		#size-cells = <2>;
 		ranges;
 
-		dma0: shdma@fe008020 {
-			compatible = "renesas,shdma";
-			reg = <0xfe008020 0x270>,
-				<0xfe009000 0xc>;
+		dma0: dma-controller@e6700020 {
+			compatible = "renesas,shdma-r8a73a4";
+			reg = <0 0xe6700020 0 0x89e0>;
 			interrupt-parent = <&gic>;
-			interrupts = <0 34 4
-					0 28 4
-					0 29 4
-					0 30 4
-					0 31 4
-					0 32 4
-					0 33 4>;
+			interrupts = <0 220 4
+					0 200 4
+					0 201 4
+					0 202 4
+					0 203 4
+					0 204 4
+					0 205 4
+					0 206 4
+					0 207 4
+					0 208 4
+					0 209 4
+					0 210 4
+					0 211 4
+					0 212 4
+					0 213 4
+					0 214 4
+					0 215 4
+					0 216 4
+					0 217 4
+					0 218 4
+					0 219 4>;
 			interrupt-names = "error",
 					"ch0", "ch1", "ch2", "ch3",
-					"ch4", "ch5";
-		};
-
-		dma1: shdma@fe018020 {
-			...
-		};
-
-		dma2: shdma@fe028020 {
-			...
+					"ch4", "ch5", "ch6", "ch7",
+					"ch8", "ch9", "ch10", "ch11",
+					"ch12", "ch13", "ch14", "ch15",
+					"ch16", "ch17", "ch18", "ch19";
 		};
 	};
 
diff --git a/drivers/dma/sh/Makefile b/drivers/dma/sh/Makefile
index c962138..893ee09 100644
--- a/drivers/dma/sh/Makefile
+++ b/drivers/dma/sh/Makefile
@@ -1,3 +1,5 @@
 obj-$(CONFIG_SH_DMAE_BASE) += shdma-base.o shdma-of.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
+shdma-y := shdmac.o
+shdma-objs := $(shdma-y)
 obj-$(CONFIG_SUDMAC) += sudmac.o
diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index c5ea256..d94ab59 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -171,7 +171,8 @@ static struct shdma_desc *shdma_get_desc(struct shdma_chan *schan)
 	return NULL;
 }
 
-static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
+static int shdma_setup_slave(struct shdma_chan *schan, int slave_id,
+			     dma_addr_t slave_addr)
 {
 	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
 	const struct shdma_ops *ops = sdev->ops;
@@ -179,7 +180,7 @@ static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
 
 	if (schan->dev->of_node) {
 		match = schan->hw_req;
-		ret = ops->set_slave(schan, match, true);
+		ret = ops->set_slave(schan, match, slave_addr, true);
 		if (ret < 0)
 			return ret;
 
@@ -194,7 +195,7 @@ static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
 	if (test_and_set_bit(slave_id, shdma_slave_used))
 		return -EBUSY;
 
-	ret = ops->set_slave(schan, match, false);
+	ret = ops->set_slave(schan, match, slave_addr, false);
 	if (ret < 0) {
 		clear_bit(slave_id, shdma_slave_used);
 		return ret;
@@ -236,7 +237,7 @@ bool shdma_chan_filter(struct dma_chan *chan, void *arg)
 	if (!schan->dev->of_node && match >= slave_num)
 		return false;
 
-	ret = ops->set_slave(schan, match, true);
+	ret = ops->set_slave(schan, match, 0, true);
 	if (ret < 0)
 		return false;
 
@@ -259,7 +260,7 @@ static int shdma_alloc_chan_resources(struct dma_chan *chan)
 	 */
 	if (slave) {
 		/* Legacy mode: .private is set in filter */
-		ret = shdma_setup_slave(schan, slave->slave_id);
+		ret = shdma_setup_slave(schan, slave->slave_id, 0);
 		if (ret < 0)
 			goto esetslave;
 	} else {
@@ -680,7 +681,9 @@ static int shdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		 * channel, while using it...
 		 */
 		config = (struct dma_slave_config *)arg;
-		ret = shdma_setup_slave(schan, config->slave_id);
+		ret = shdma_setup_slave(schan, config->slave_id,
+					config->direction == DMA_DEV_TO_MEM ?
+					config->src_addr : config->dst_addr);
 		if (ret < 0)
 			return ret;
 		break;
diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index 11bcb05..2acf7b6 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -45,9 +45,6 @@ static int shdma_of_probe(struct platform_device *pdev)
 	const struct of_dev_auxdata *lookup = pdev->dev.platform_data;
 	int ret;
 
-	if (!lookup)
-		return -EINVAL;
-
 	ret = of_dma_controller_register(pdev->dev.of_node,
 					 shdma_of_xlate, pdev);
 	if (ret < 0)
diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
index 3d9dca1..ff2f93b 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -31,6 +31,7 @@ struct sh_dmae_chan {
 	void __iomem *base;
 	char dev_id[16];		/* unique name per DMAC of channel */
 	int pm_error;
+	dma_addr_t slave_addr;
 };
 
 struct sh_dmae_device {
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdmac.c
similarity index 98%
rename from drivers/dma/sh/shdma.c
rename to drivers/dma/sh/shdmac.c
index 7af64b9..7a01faa 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdmac.c
@@ -20,6 +20,8 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
@@ -333,7 +335,7 @@ static const struct sh_dmae_slave_config *dmae_find_slave(
 	} else {
 		for (i = 0, cfg = pdata->slave; i < pdata->slave_num; i++, cfg++)
 			if (cfg->mid_rid == match) {
-				sh_chan->shdma_chan.slave_id = cfg->slave_id;
+				sh_chan->shdma_chan.slave_id = i;
 				return cfg;
 			}
 	}
@@ -342,7 +344,7 @@ static const struct sh_dmae_slave_config *dmae_find_slave(
 }
 
 static int sh_dmae_set_slave(struct shdma_chan *schan,
-			     int slave_id, bool try)
+			     int slave_id, dma_addr_t slave_addr, bool try)
 {
 	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
 						    shdma_chan);
@@ -350,8 +352,10 @@ static int sh_dmae_set_slave(struct shdma_chan *schan,
 	if (!cfg)
 		return -ENXIO;
 
-	if (!try)
+	if (!try) {
 		sh_chan->config = cfg;
+		sh_chan->slave_addr = slave_addr ? : cfg->addr;
+	}
 
 	return 0;
 }
@@ -641,7 +645,7 @@ static dma_addr_t sh_dmae_slave_addr(struct shdma_chan *schan)
 	 * This is an exclusive slave DMA operation, may only be called after a
 	 * successful slave configuration.
 	 */
-	return sh_chan->config->addr;
+	return sh_chan->slave_addr;
 }
 
 static struct shdma_desc *sh_dmae_embedded_desc(void *buf, int i)
@@ -663,9 +667,14 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 	.get_partial = sh_dmae_get_partial,
 };
 
+static const struct of_device_id sh_dmae_of_match[] = {
+	{}
+};
+MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
+
 static int sh_dmae_probe(struct platform_device *pdev)
 {
-	const struct sh_dmae_pdata *pdata = pdev->dev.platform_data;
+	const struct sh_dmae_pdata *pdata;
 	unsigned long irqflags = IRQF_DISABLED,
 		chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAE_MAX_CHANNELS];
@@ -674,6 +683,11 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	struct dma_device *dma_dev;
 	struct resource *chan, *dmars, *errirq_res, *chanirq_res;
 
+	if (pdev->dev.of_node)
+		pdata = of_match_device(sh_dmae_of_match, &pdev->dev)->data;
+	else
+		pdata = pdev->dev.platform_data;
+
 	/* get platform data */
 	if (!pdata || !pdata->channel_num)
 		return -ENODEV;
@@ -897,12 +911,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id sh_dmae_of_match[] = {
-	{ .compatible = "renesas,shdma", },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
-
 static struct platform_driver sh_dmae_driver = {
 	.driver 	= {
 		.owner	= THIS_MODULE,
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index 3477901..2a8e3c2 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -150,7 +150,8 @@ static const struct sudmac_slave_config *sudmac_find_slave(
 	return NULL;
 }
 
-static int sudmac_set_slave(struct shdma_chan *schan, int slave_id, bool try)
+static int sudmac_set_slave(struct shdma_chan *schan, int slave_id,
+			    dma_addr_t slave_addr, bool try)
 {
 	struct sudmac_chan *sc = to_chan(schan);
 	const struct sudmac_slave_config *cfg = sudmac_find_slave(sc, slave_id);
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 31cf89f..f92c0a4 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -96,7 +96,7 @@ struct shdma_ops {
 	dma_addr_t (*slave_addr)(struct shdma_chan *);
 	int (*desc_setup)(struct shdma_chan *, struct shdma_desc *,
 			  dma_addr_t, dma_addr_t, size_t *);
-	int (*set_slave)(struct shdma_chan *, int, bool);
+	int (*set_slave)(struct shdma_chan *, int, dma_addr_t, bool);
 	void (*setup_xfer)(struct shdma_chan *, int);
 	void (*start_xfer)(struct shdma_chan *, struct shdma_desc *);
 	struct shdma_desc *(*embedded_desc)(void *, int);
-- 
1.7.2.5

