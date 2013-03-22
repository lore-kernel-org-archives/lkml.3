Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3CVOnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:43:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:49313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569Ab3CVOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,892,1355126400"; 
   d="scan'208";a="310518397"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/4] dw_dmac: rename DT related methods to reflect their belonging
Date: Fri, 22 Mar 2013 16:43:19 +0200
Message-Id: <1363963401-7924-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we will have not only DT cases in future let's rename DT related methods
to reflect their belonging.

The rename was done as follows:
	struct dw_dma_filter_args	-> struct dw_dma_of_filter_args
	dw_dma_generic_filter()		-> dw_dma_of_filter()
	dw_dma_xlate()			-> dw_dma_of_xlate()
	dw_dma_id_table			-> dw_dma_of_id_table

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d6dbb14..274fd7d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1242,18 +1242,20 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
 }
 
-struct dw_dma_filter_args {
+/*----------------------------------------------------------------------*/
+
+struct dw_dma_of_filter_args {
 	struct dw_dma *dw;
 	unsigned int req;
 	unsigned int src;
 	unsigned int dst;
 };
 
-static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
+static bool dw_dma_of_filter(struct dma_chan *chan, void *param)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 	struct dw_dma *dw = to_dw_dma(chan->device);
-	struct dw_dma_filter_args *fargs = param;
+	struct dw_dma_of_filter_args *fargs = param;
 	struct dw_dma_slave *dws = &dwc->slave;
 
 	/* Ensure the device matches our channel */
@@ -1273,11 +1275,11 @@ static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
 	return true;
 }
 
-static struct dma_chan *dw_dma_xlate(struct of_phandle_args *dma_spec,
-					 struct of_dma *ofdma)
+static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
+					struct of_dma *ofdma)
 {
 	struct dw_dma *dw = ofdma->of_dma_data;
-	struct dw_dma_filter_args fargs = {
+	struct dw_dma_of_filter_args fargs = {
 		.dw = dw,
 	};
 	dma_cap_mask_t cap;
@@ -1298,7 +1300,7 @@ static struct dma_chan *dw_dma_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_set(DMA_SLAVE, cap);
 
 	/* TODO: there should be a simpler way to do this */
-	return dma_request_channel(cap, dw_dma_generic_filter, &fargs);
+	return dma_request_channel(cap, dw_dma_of_filter, &fargs);
 }
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
@@ -1843,7 +1845,7 @@ static int dw_probe(struct platform_device *pdev)
 
 	if (pdev->dev.of_node) {
 		err = of_dma_controller_register(pdev->dev.of_node,
-						 dw_dma_xlate, dw);
+						 dw_dma_of_xlate, dw);
 		if (err && err != -ENODEV)
 			dev_err(&pdev->dev,
 				"could not register of_dma_controller\n");
@@ -1913,11 +1915,11 @@ static const struct dev_pm_ops dw_dev_pm_ops = {
 };
 
 #ifdef CONFIG_OF
-static const struct of_device_id dw_dma_id_table[] = {
+static const struct of_device_id dw_dma_of_id_table[] = {
 	{ .compatible = "snps,dma-spear1340" },
 	{}
 };
-MODULE_DEVICE_TABLE(of, dw_dma_id_table);
+MODULE_DEVICE_TABLE(of, dw_dma_of_id_table);
 #endif
 
 static const struct platform_device_id dw_dma_ids[] = {
@@ -1933,7 +1935,7 @@ static struct platform_driver dw_driver = {
 	.driver = {
 		.name	= "dw_dmac",
 		.pm	= &dw_dev_pm_ops,
-		.of_match_table = of_match_ptr(dw_dma_id_table),
+		.of_match_table = of_match_ptr(dw_dma_of_id_table),
 	},
 	.id_table	= dw_dma_ids,
 };
-- 
1.8.2.rc0.22.gb3600c3

