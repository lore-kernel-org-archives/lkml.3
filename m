Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab3CYNOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:14:50 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1037 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3CYNOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:14:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32236
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: Jon Hunter <jon-hunter@ti.com>, Padmavathi Venna <padma.v@samsung.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] dma: of: Add generic xlate function for matching by channel id
Date: Mon, 25 Mar 2013 14:16:51 +0100
Message-Id: <1364217412-31905-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new generic of dma xlate callback function which will match a
channel by its id.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/of-dma.c   | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_dma.h |  4 ++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 00db454..7cad4d7 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -269,3 +269,50 @@ struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 			&dma_spec->args[0]);
 }
 EXPORT_SYMBOL_GPL(of_dma_simple_xlate);
+
+struct of_dma_filter_by_chan_id_args {
+	struct dma_device *dev;
+	unsigned int chan_id;
+};
+
+static bool of_dma_filter_by_chan_id(struct dma_chan *chan, void *params)
+{
+	struct of_dma_filter_by_chan_id_args *args = params;
+
+	return chan->device == args->dev && chan->chan_id == args->chan_id;
+}
+
+/**
+ * of_dma_xlate_by_chan_id - Translate dt property to DMA channel by channel id
+ * @dma_spec:	pointer to DMA specifier as found in the device tree
+ * @of_dma:	pointer to DMA controller data
+ *
+ * This function can be used as the of xlate callback for DMA driver which want
+ * to match the channel based on the channel id. When using this xlate function
+ * the #dma-cells propety of the DMA controller dt node needs to be set to 1.
+ * The data parameter of of_dma_controller_register must be a pointer to the
+ * dma_device struct the function should match uppon.
+ *
+ * Returns pointer to appropriate dma channel on success or NULL on error.
+ */
+struct dma_chan *of_dma_xlate_by_chan_id(struct of_phandle_args *dma_spec,
+					 struct of_dma *ofdma)
+{
+	struct of_dma_filter_by_chan_id_args args;
+	dma_cap_mask_t cap;
+
+	args.dev = ofdma->of_dma_data;
+	if (!args.dev)
+		return NULL;
+
+	if (dma_spec->args_count != 1)
+		return NULL;
+
+	dma_cap_zero(cap);
+	dma_cap_set(DMA_SLAVE, cap);
+
+	args.chan_id = dma_spec->args[0];
+
+	return dma_request_channel(cap, of_dma_filter_by_chan_id, &args);
+}
+EXPORT_SYMBOL_GPL(of_dma_xlate_by_chan_id);
diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index ce6a8ab..46732d3 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -43,6 +43,8 @@ extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 						     const char *name);
 extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 		struct of_dma *ofdma);
+extern struct dma_chan *of_dma_xlate_by_chan_id(struct of_phandle_args *dma_spec,
+		struct of_dma *ofdma);
 #else
 static inline int of_dma_controller_register(struct device_node *np,
 		struct dma_chan *(*of_dma_xlate)
@@ -69,6 +71,8 @@ static inline struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_s
 	return NULL;
 }
 
+#define of_dma_xlate_by_chan_id NULL
+
 #endif
 
 #endif /* __LINUX_OF_DMA_H */
-- 
1.8.0

