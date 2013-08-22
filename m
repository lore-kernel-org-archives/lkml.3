Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3HVGnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:43:20 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1825 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HVGnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:43:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 21 Aug 2013 23:41:01 -0700
From: Richard Zhao <rizhao@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <swarren@wwwdotorg.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree@vger.kernel.org>, Richard Zhao <rizhao@nvidia.com>
Subject: [PATCH v2] DMA: add help function to check whether dma controller registered
Date: Thu, 22 Aug 2013 14:43:00 +0800
Message-ID: <1377153781-18006-1-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375423458-6868-1-git-send-email-rizhao@nvidia.com>
References: <1375423458-6868-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA client device driver usually needs to know at probe time whether
dma controller has been registered to deffer probe. So add a help
function of_dma_check_controller.

DMA request channel functions can also used to check it, but they
are usually called at open() time.

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 drivers/dma/of-dma.c   | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_dma.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 8cd5f3f..0063ddf 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -189,6 +189,45 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 }
 
 /**
+ * of_dma_check_controller - Check whether dma controller registered
+ * @dev:	pointer to client device structure
+ * @name:	slave channel name
+ */
+int of_dma_check_controller(struct device *dev, const char *name)
+{
+	struct device_node *np = dev->of_node;
+	struct of_phandle_args dma_spec;
+	struct of_dma *ofdma = NULL;
+	int count, i, ret = 0;
+
+	if (!np || !name)
+		return -EINVAL;
+
+	count = of_property_count_strings(np, "dma-names");
+	if (count < 0) {
+		dev_err(dev, "dma-names property missing or empty\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < count; i++) {
+		ret = of_dma_match_channel(np, name, i, &dma_spec);
+		if (ret)
+			continue;
+
+		mutex_lock(&of_dma_lock);
+		ofdma = of_dma_find_controller(&dma_spec);
+		mutex_unlock(&of_dma_lock);
+		of_node_put(dma_spec.np);
+		if (!ofdma)
+			ret = -EPROBE_DEFER;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(of_dma_check_controller);
+
+/**
  * of_dma_simple_xlate - Simple DMA engine translation function
  * @dma_spec:	pointer to DMA specifier as found in the device tree
  * @of_dma:	pointer to DMA controller data
diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index ae36298..bc7195f 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -39,6 +39,7 @@ extern int of_dma_controller_register(struct device_node *np,
 extern void of_dma_controller_free(struct device_node *np);
 extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 						     const char *name);
+extern int of_dma_check_controller(struct device *dev, const char *name);
 extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 		struct of_dma *ofdma);
 #else
@@ -60,6 +61,11 @@ static inline struct dma_chan *of_dma_request_slave_channel(struct device_node *
 	return NULL;
 }
 
+static inline int of_dma_check_controller(struct device *dev, const char *name)
+{
+	return 0;
+}
+
 static inline struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 		struct of_dma *ofdma)
 {
-- 
1.8.1.5

