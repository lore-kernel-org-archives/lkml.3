Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3CVOoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:44:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:7397 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511Ab3CVOoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:44:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,892,1355126400"; 
   d="scan'208";a="306119638"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/4] dw_dmac: make build of DT related methods optional
Date: Fri, 22 Mar 2013 16:43:20 +0200
Message-Id: <1363963401-7924-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to build custom filter function and translation function
inside the driver in case we have no DT platform.

This patch introduces new method dw_dma_of_controller_register() and moves all
DT related stuff under #ifdef CONFIG_OF. It also helps to distinguish the real
-ENODEV return code of fake one when of_dma_controller_register is not
implemented.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 274fd7d..9b2e186 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1244,6 +1244,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 
 /*----------------------------------------------------------------------*/
 
+#ifdef CONFIG_OF
 struct dw_dma_of_filter_args {
 	struct dw_dma *dw;
 	unsigned int req;
@@ -1303,6 +1304,19 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
 	return dma_request_channel(cap, dw_dma_of_filter, &fargs);
 }
 
+static void dw_dma_of_controller_register(struct dw_dma *dw)
+{
+	struct device *dev = dw->dma.dev;
+	int err;
+
+	err = of_dma_controller_register(dev->of_node, dw_dma_of_xlate, dw);
+	if (err)
+		dev_err(dev, "could not register of_dma_controller\n");
+}
+#else /* !CONFIG_OF */
+static inline void dw_dma_of_controller_register(struct dw_dma *dw) {}
+#endif /* !CONFIG_OF */
+
 /* --------------------- Cyclic DMA API extensions -------------------- */
 
 /**
@@ -1843,13 +1857,8 @@ static int dw_probe(struct platform_device *pdev)
 
 	dma_async_device_register(&dw->dma);
 
-	if (pdev->dev.of_node) {
-		err = of_dma_controller_register(pdev->dev.of_node,
-						 dw_dma_of_xlate, dw);
-		if (err && err != -ENODEV)
-			dev_err(&pdev->dev,
-				"could not register of_dma_controller\n");
-	}
+	if (pdev->dev.of_node)
+		dw_dma_of_controller_register(dw);
 
 	return 0;
 }
-- 
1.8.2.rc0.22.gb3600c3

