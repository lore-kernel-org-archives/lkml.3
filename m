Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3KZBZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:25:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46884 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3KZBZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:25:16 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] dma: add common of_dma_slave_xlate()
Date: Mon, 25 Nov 2013 18:25:04 -0700
Message-Id: <1385429104-7001-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

mmp_pdma.c implements a custom of_xlate() function that is 95% identical
to what Tegra will need. Create a function to implement the common part,
so everyone doesn't just cut/paste the implementation.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Squashed the conversion of mmp_pdma.c into the patch that added the
common implementation, so it's easier to see the whole conversion in one
go.

This patch is a dependency for a series that reworks many of the Tegra
drivers.

As such, it needs to go into a topic branch on its own, based directly
on 3.13-rc1. If the DMA maintainers ack the patches I'm happy to create
this topic branch myself and send a pull request to the DMA tree. Or the
patches can be applied to a topic branch by the DMA maintainers and I
will merge their topic branch into the Tegra rework branch that I
mentioned.

Note that this patch is independant from the "dma: add channel request
API that supports deferred probe" which I just sent, so it could
(should?) be a different topic branch.
---
 drivers/dma/mmp_pdma.c | 39 ++++++++++-----------------------------
 drivers/dma/of-dma.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_dma.h | 14 ++++++++++++++
 3 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index dcb1e05149a7..9705cedf623d 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -128,6 +128,7 @@ struct mmp_pdma_device {
 	void __iomem			*base;
 	struct device			*dev;
 	struct dma_device		device;
+	struct of_dma_slave_xlate_info	xlate_info;
 	struct mmp_pdma_phy		*phy;
 	spinlock_t phy_lock; /* protect alloc/free phy channels */
 };
@@ -889,37 +890,14 @@ static struct of_device_id mmp_pdma_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mmp_pdma_dt_ids);
 
-static struct dma_chan *mmp_pdma_dma_xlate(struct of_phandle_args *dma_spec,
-					   struct of_dma *ofdma)
+static int mmp_pdma_of_xlate_post_alloc(struct dma_chan *chan,
+					struct of_phandle_args *dma_spec)
 {
-	struct mmp_pdma_device *d = ofdma->of_dma_data;
-	struct dma_chan *chan, *candidate;
-
-retry:
-	candidate = NULL;
-
-	/* walk the list of channels registered with the current instance and
-	 * find one that is currently unused */
-	list_for_each_entry(chan, &d->device.channels, device_node)
-		if (chan->client_count == 0) {
-			candidate = chan;
-			break;
-		}
-
-	if (!candidate)
-		return NULL;
+	struct mmp_pdma_chan *c = to_mmp_pdma_chan(chan);
 
-	/* dma_get_slave_channel will return NULL if we lost a race between
-	 * the lookup and the reservation */
-	chan = dma_get_slave_channel(candidate);
+	c->drcmr = dma_spec->args[0];
 
-	if (chan) {
-		struct mmp_pdma_chan *c = to_mmp_pdma_chan(chan);
-		c->drcmr = dma_spec->args[0];
-		return chan;
-	}
-
-	goto retry;
+	return 0;
 }
 
 static int mmp_pdma_probe(struct platform_device *op)
@@ -1009,8 +987,11 @@ static int mmp_pdma_probe(struct platform_device *op)
 
 	if (op->dev.of_node) {
 		/* Device-tree DMA controller registration */
+		pdev->xlate_info.device = &pdev->device;
+		pdev->xlate_info.post_alloc = mmp_pdma_of_xlate_post_alloc;
 		ret = of_dma_controller_register(op->dev.of_node,
-						 mmp_pdma_dma_xlate, pdev);
+						 of_dma_slave_xlate,
+						 &pdev->xlate_info);
 		if (ret < 0) {
 			dev_err(&op->dev, "of_dma_controller_register failed\n");
 			return ret;
diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index f68e25c9af3a..d9786a9c8797 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -218,3 +218,46 @@ struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 			&dma_spec->args[0]);
 }
 EXPORT_SYMBOL_GPL(of_dma_simple_xlate);
+
+struct dma_chan *of_dma_slave_xlate(struct of_phandle_args *dma_spec,
+				    struct of_dma *ofdma)
+{
+	struct of_dma_slave_xlate_info *info = ofdma->of_dma_data;
+	struct dma_chan *candidate, *chan;
+	int ret;
+
+retry:
+	candidate = NULL;
+
+	/*
+	 * walk the list of channels registered with the current instance and
+	 * find one that is currently unused
+	 */
+	list_for_each_entry(chan, &info->device->channels, device_node)
+		if (chan->client_count == 0) {
+			candidate = chan;
+			break;
+		}
+
+	if (!candidate)
+		return NULL;
+
+	/*
+	 * dma_get_slave_channel will return NULL if we lost a race between
+	 * the lookup and the reservation
+	 */
+	chan = dma_get_slave_channel(candidate);
+	if (!chan)
+		goto retry;
+
+	if (info->post_alloc) {
+		ret = info->post_alloc(chan, dma_spec);
+		if (ret) {
+			dma_release_channel(chan);
+			return NULL;
+		}
+	}
+
+	return chan;
+}
+EXPORT_SYMBOL_GPL(of_dma_slave_xlate);
diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index ae36298ba076..fb4187adc68b 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -31,6 +31,12 @@ struct of_dma_filter_info {
 	dma_filter_fn	filter_fn;
 };
 
+struct of_dma_slave_xlate_info {
+	struct dma_device *device;
+	int (*post_alloc)(struct dma_chan *chan,
+			  struct of_phandle_args *dma_spec);
+};
+
 #ifdef CONFIG_OF
 extern int of_dma_controller_register(struct device_node *np,
 		struct dma_chan *(*of_dma_xlate)
@@ -41,6 +47,8 @@ extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 						     const char *name);
 extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 		struct of_dma *ofdma);
+extern struct dma_chan *of_dma_slave_xlate(struct of_phandle_args *dma_spec,
+		struct of_dma *ofdma);
 #else
 static inline int of_dma_controller_register(struct device_node *np,
 		struct dma_chan *(*of_dma_xlate)
@@ -66,6 +74,12 @@ static inline struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_s
 	return NULL;
 }
 
+static inline struct dma_chan *of_dma_slave_xlate(struct of_phandle_args *dma_spec,
+		struct of_dma *ofdma)
+{
+	return NULL;
+}
+
 #endif
 
 #endif /* __LINUX_OF_DMA_H */
-- 
1.8.1.5

