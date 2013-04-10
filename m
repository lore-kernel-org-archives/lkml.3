Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911Ab3DJWUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:20:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62592 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934740Ab3DJWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:54 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 3/6] DMA: shdma: add DT support
Date: Thu, 11 Apr 2013 00:19:46 +0200
Message-Id: <1365632389-2249-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:nwWDS8BAe2kWqSkOKBv2szzvLwSjBHfeBnkSGxcgSqh
 gF1xTFi8s2E8LHVSizLLoA/eaBhYvO3Tsf5A6ukCfmd0SOGyQv
 HtjBjdExRROnVeF319ee0+c4izjIGN4BPuzC1uYAJUgLSQMLzD
 NcmRqeUVeZTSYtZCy/CT9ulimVQondhSVXraMIEZdY9LmAq77L
 6clRfa4Up99IwqqWuyrG/5P0XOnykeUMraTjAlHb36H1FP2W1w
 DfSqdMosXgQfenhBXuDD1IGZ27PEUvywBJpmUTx+jknU7q+gUe
 gn46lgr1nLOzwkcGm6EKL/fnF8Ri9VmlTNbGgdhmQ1uOzKvWX2
 BFgq7b/+QTWv+RLwDLlV4vQIbYmMg03EGAja7A/DE9XR7LG4tS
 l0ZJ8xpygD3FQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Device Tree support to the shdma driver. No special DT
properties are used, only standard DMA DT bindings are implemented. Since
shdma controllers reside on SoCs, their configuration is SoC-specific and
shall be passed to the driver from the SoC platform data, using the
auxdata procedure.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Note concerning the filtering parameter. Without DT slave channels are 
configured, based on a purely virtual slave ID, passed by DMA clients 
to the shdma dmaengine driver. In the DT case we cannot use such 
virtual IDs, we use a hardware MID/RID (DMA request ID) value. This is 
confusing, ideally, all existing users should be converted to also use 
MID/RID. This patch doesn't do that, it leaves existing users 
unaffected and only uses MID/RID for DT.

 drivers/dma/sh/shdma-base.c |   51 +++++++++++++++++++++++++++++++++++++-----
 drivers/dma/sh/shdma.c      |   44 ++++++++++++++++++++++++++++++++-----
 include/linux/shdma-base.h  |    5 ++++
 3 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 4acb85a..4fd8293 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -14,6 +14,8 @@
  */
 
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_dma.h>
 #include <linux/shdma-base.h>
 #include <linux/dmaengine.h>
 #include <linux/init.h>
@@ -175,7 +177,18 @@ static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
 {
 	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
 	const struct shdma_ops *ops = sdev->ops;
-	int ret;
+	int ret, match;
+
+	if (schan->dev->of_node) {
+		match = schan->hw_req;
+		ret = ops->set_slave(schan, match, true);
+		if (ret < 0)
+			return ret;
+
+		slave_id = schan->slave_id;
+	} else {
+		match = slave_id;
+	}
 
 	if (slave_id < 0 || slave_id >= slave_num)
 		return -EINVAL;
@@ -183,7 +196,7 @@ static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
 	if (test_and_set_bit(slave_id, shdma_slave_used))
 		return -EBUSY;
 
-	ret = ops->set_slave(schan, slave_id, false);
+	ret = ops->set_slave(schan, match, false);
 	if (ret < 0) {
 		clear_bit(slave_id, shdma_slave_used);
 		return ret;
@@ -206,23 +219,26 @@ static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
  * services would have to provide their own filters, which first would check
  * the device driver, similar to how other DMAC drivers, e.g., sa11x0-dma.c, do
  * this, and only then, in case of a match, call this common filter.
+ * NOTE 2: This filter function is also used in the DT case by shdma_xlate().
+ * In that case the MID-RID value is used for slave channel filtering and is
+ * passed to this function in the "arg" parameter.
  */
 bool shdma_chan_filter(struct dma_chan *chan, void *arg)
 {
 	struct shdma_chan *schan = to_shdma_chan(chan);
 	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
 	const struct shdma_ops *ops = sdev->ops;
-	int slave_id = (int)arg;
+	int match = (int)arg;
 	int ret;
 
-	if (slave_id < 0)
+	if (match < 0)
 		/* No slave requested - arbitrary channel */
 		return true;
 
-	if (slave_id >= slave_num)
+	if (!schan->dev->of_node && match >= slave_num)
 		return false;
 
-	ret = ops->set_slave(schan, slave_id, true);
+	ret = ops->set_slave(schan, match, true);
 	if (ret < 0)
 		return false;
 
@@ -867,6 +883,29 @@ void shdma_chan_remove(struct shdma_chan *schan)
 }
 EXPORT_SYMBOL(shdma_chan_remove);
 
+struct dma_chan *shdma_xlate(struct of_phandle_args *dma_spec,
+				 struct of_dma *ofdma)
+{
+	struct shdma_dev *sdev = ofdma->of_dma_data;
+	u32 id = dma_spec->args[0];
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+
+	if (dma_spec->args_count != 1 || !sdev)
+		return NULL;
+
+	dma_cap_zero(mask);
+	/* Only slave DMA channels can be allocated via DT */
+	dma_cap_set(DMA_SLAVE, mask);
+
+	chan = dma_request_channel(mask, shdma_chan_filter, (void *)id);
+	if (chan)
+		to_shdma_chan(chan)->hw_req = id;
+
+	return chan;
+}
+EXPORT_SYMBOL(shdma_xlate);
+
 int shdma_init(struct device *dev, struct shdma_dev *sdev,
 		    int chan_num)
 {
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index a5a1887..db497d6 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -20,6 +20,8 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_dma.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
@@ -301,20 +303,32 @@ static void sh_dmae_setup_xfer(struct shdma_chan *schan,
 	}
 }
 
+/*
+ * Find a slave channel configuration from the contoller list by either a slave
+ * ID in the non-DT case, or by a MID/RID value in the DT case
+ */
 static const struct sh_dmae_slave_config *dmae_find_slave(
-	struct sh_dmae_chan *sh_chan, int slave_id)
+	struct sh_dmae_chan *sh_chan, int match)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_chan);
 	struct sh_dmae_pdata *pdata = shdev->pdata;
 	const struct sh_dmae_slave_config *cfg;
 	int i;
 
-	if (slave_id >= SH_DMA_SLAVE_NUMBER)
-		return NULL;
+	if (!sh_chan->shdma_chan.dev->of_node) {
+		if (match >= SH_DMA_SLAVE_NUMBER)
+			return NULL;
 
-	for (i = 0, cfg = pdata->slave; i < pdata->slave_num; i++, cfg++)
-		if (cfg->slave_id == slave_id)
-			return cfg;
+		for (i = 0, cfg = pdata->slave; i < pdata->slave_num; i++, cfg++)
+			if (cfg->slave_id == match)
+				return cfg;
+	} else {
+		for (i = 0, cfg = pdata->slave; i < pdata->slave_num; i++, cfg++)
+			if (cfg->mid_rid == match) {
+				sh_chan->shdma_chan.slave_id = cfg->slave_id;
+				return cfg;
+			}
+	}
 
 	return NULL;
 }
@@ -841,6 +855,14 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto edmadevreg;
 
+	if (pdev->dev.of_node) {
+		int of_err = of_dma_controller_register(pdev->dev.of_node,
+							shdma_xlate, shdev);
+		if (of_err < 0 && of_err != -ENODEV)
+			dev_err(&pdev->dev,
+				"could not register of_dma_controller\n");
+	}
+
 	return err;
 
 edmadevreg:
@@ -889,6 +911,9 @@ static int sh_dmae_remove(struct platform_device *pdev)
 
 	dma_async_device_unregister(dma_dev);
 
+	if (pdev->dev.of_node)
+		of_dma_controller_free(pdev->dev.of_node);
+
 	if (errirq > 0)
 		free_irq(errirq, shdev);
 
@@ -920,11 +945,18 @@ static int sh_dmae_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id sh_dmae_of_match[] = {
+	{ .compatible = "renesas,shdma", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
+
 static struct platform_driver sh_dmae_driver = {
 	.driver 	= {
 		.owner	= THIS_MODULE,
 		.pm	= &sh_dmae_pm,
 		.name	= SH_DMAE_DRV_NAME,
+		.of_match_table = sh_dmae_of_match,
 	},
 	.remove		= sh_dmae_remove,
 	.shutdown	= sh_dmae_shutdown,
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 9a93897..0815a0e 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -19,6 +19,7 @@
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/of_dma.h>
 #include <linux/types.h>
 
 /**
@@ -68,6 +69,8 @@ struct shdma_chan {
 	int id;				/* Raw id of this channel */
 	int irq;			/* Channel IRQ */
 	int slave_id;			/* Client ID for slave DMA */
+	int hw_req;			/* DMA request line for slave DMA - same
+					 * as MID/RID, used with DT */
 	enum shdma_pm_state pm_state;
 };
 
@@ -123,5 +126,7 @@ int shdma_init(struct device *dev, struct shdma_dev *sdev,
 		    int chan_num);
 void shdma_cleanup(struct shdma_dev *sdev);
 bool shdma_chan_filter(struct dma_chan *chan, void *arg);
+struct dma_chan *shdma_xlate(struct of_phandle_args *dma_spec,
+			     struct of_dma *ofdma);
 
 #endif
-- 
1.7.2.5

