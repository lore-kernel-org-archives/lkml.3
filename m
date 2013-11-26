Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab3KZREd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:04:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56493 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3KZREa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:04:30 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: andriy.shevchenko@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4] dma: add channel request API that supports deferred probe
Date: Tue, 26 Nov 2013 10:04:22 -0700
Message-Id: <1385485462-30376-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

dma_request_slave_channel() simply returns NULL whenever DMA channel
lookup fails. Lookup could fail for two distinct reasons:

a) No DMA specification exists for the channel name.
   This includes situations where no DMA specifications exist at all, or
   other general lookup problems.

b) A DMA specification does exist, yet the driver for that channel is not
   yet registered.

Case (b) should trigger deferred probe in client drivers. However, since
they have no way to differentiate the two situations, it cannot.

Implement new function dma_request_slave_channel_reason(), which performs
identically to dma_request_slave_channel(), except that it returns an
error-pointer rather than NULL, which allows callers to detect when
deferred probe should occur.

Eventually, all drivers should be converted to this new API, the old API
removed, and the new API renamed to the more desirable name. This patch
doesn't convert the existing API and all drivers in one go, since some
drivers call dma_request_slave_channel() then dma_request_channel() if
that fails. That would require either modifying dma_request_channel() in
the same way, or adding extra error-handling code to all affected
drivers, and there are close to 100 drivers using the other API, rather
than just the 15-20 or so that use dma_request_slave_channel(), which
might be tenable in a single patch.

acpi_dma_request_slave_chan_by_name() doesn't currently implement
deferred probe. It should, but this will be addressed later.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v4:
* Add {} around both branches in of_dma_request_slave_channel().
v3:
* s/_or_err/_reason/ in the new API name.
* Simplify changes to of_dma_request_slave_channel() so that the new
  "bool defer" parameter is not needed.
* Revert changes to acpi-dma.c and handle the return value conversion
  in dma_request_slave_channel_reason() instead.
* Mention that acpi_dma_request_slave_chan_by_name() should implement
  deferred probe, but that will happen later.
v2:
* include <linux/err.h> in <linux/dmaengine.h>
* Return -ENODATA if slave_id or chan_id out-of-range.
* Return an error-pointer not NULL if we can't find a matching DMA
  controller or translate the channel.

This patch is a dependency for:
* A series that reworks many of the Tegra drivers.
* A series that enhances ASoC's dmaengine code to support deferred probe.

As such, it needs to go into a topic branch on its own, based directly
on 3.13-rc1. If the DMA maintainers ack the patches I'm happy to create
this topic branch myself and send a pull request to the DMA tree. Or the
patches can be applied to a topic branch by the DMA maintainers and I
will merge their topic branch into the Tegra rework branch that I
mentioned.
---
 drivers/dma/dmaengine.c   | 35 +++++++++++++++++++++++++++++++----
 drivers/dma/of-dma.c      | 15 +++++++++------
 include/linux/dmaengine.h |  8 ++++++++
 3 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index ea806bdc12ef..e17e9b22d85e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -540,6 +540,8 @@ EXPORT_SYMBOL_GPL(dma_get_slave_channel);
  * @mask: capabilities that the channel must satisfy
  * @fn: optional callback to disposition available channels
  * @fn_param: opaque parameter to pass to dma_filter_fn
+ *
+ * Returns pointer to appropriate DMA channel on success or NULL.
  */
 struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 				       dma_filter_fn fn, void *fn_param)
@@ -591,18 +593,43 @@ EXPORT_SYMBOL_GPL(__dma_request_channel);
  * dma_request_slave_channel - try to allocate an exclusive slave channel
  * @dev:	pointer to client device structure
  * @name:	slave channel name
+ *
+ * Returns pointer to appropriate DMA channel on success or an error pointer.
  */
-struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name)
+struct dma_chan *dma_request_slave_channel_reason(struct device *dev,
+						  const char *name)
 {
+	struct dma_chan *chan;
+
 	/* If device-tree is present get slave info from here */
 	if (dev->of_node)
 		return of_dma_request_slave_channel(dev->of_node, name);
 
 	/* If device was enumerated by ACPI get slave info from here */
-	if (ACPI_HANDLE(dev))
-		return acpi_dma_request_slave_chan_by_name(dev, name);
+	if (ACPI_HANDLE(dev)) {
+		chan = acpi_dma_request_slave_chan_by_name(dev, name);
+		if (chan)
+			return chan;
+	}
 
-	return NULL;
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(dma_request_slave_channel_reason);
+
+/**
+ * dma_request_slave_channel - try to allocate an exclusive slave channel
+ * @dev:	pointer to client device structure
+ * @name:	slave channel name
+ *
+ * Returns pointer to appropriate DMA channel on success or NULL.
+ */
+struct dma_chan *dma_request_slave_channel(struct device *dev,
+					   const char *name)
+{
+	struct dma_chan *ch = dma_request_slave_channel_reason(dev, name);
+	if (IS_ERR(ch))
+		return NULL;
+	return ch;
 }
 EXPORT_SYMBOL_GPL(dma_request_slave_channel);
 
diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 0b88dd3d05f4..e8fe9dc455f4 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -143,7 +143,7 @@ static int of_dma_match_channel(struct device_node *np, const char *name,
  * @np:		device node to get DMA request from
  * @name:	name of desired channel
  *
- * Returns pointer to appropriate dma channel on success or NULL on error.
+ * Returns pointer to appropriate DMA channel on success or an error pointer.
  */
 struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 					      const char *name)
@@ -152,17 +152,18 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 	struct of_dma		*ofdma;
 	struct dma_chan		*chan;
 	int			count, i;
+	int			ret_no_channel = -ENODEV;
 
 	if (!np || !name) {
 		pr_err("%s: not enough information provided\n", __func__);
-		return NULL;
+		return ERR_PTR(-ENODEV);
 	}
 
 	count = of_property_count_strings(np, "dma-names");
 	if (count < 0) {
 		pr_err("%s: dma-names property of node '%s' missing or empty\n",
 			__func__, np->full_name);
-		return NULL;
+		return ERR_PTR(-ENODEV);
 	}
 
 	for (i = 0; i < count; i++) {
@@ -172,10 +173,12 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 		mutex_lock(&of_dma_lock);
 		ofdma = of_dma_find_controller(&dma_spec);
 
-		if (ofdma)
+		if (ofdma) {
 			chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
-		else
+		} else {
+			ret_no_channel = -EPROBE_DEFER;
 			chan = NULL;
+		}
 
 		mutex_unlock(&of_dma_lock);
 
@@ -185,7 +188,7 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 			return chan;
 	}
 
-	return NULL;
+	return ERR_PTR(ret_no_channel);
 }
 
 /**
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 41cf0c399288..ed92b30a02fd 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -22,6 +22,7 @@
 #define LINUX_DMAENGINE_H
 
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/uio.h>
 #include <linux/bug.h>
 #include <linux/scatterlist.h>
@@ -1040,6 +1041,8 @@ enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
 struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 					dma_filter_fn fn, void *fn_param);
+struct dma_chan *dma_request_slave_channel_reason(struct device *dev,
+						  const char *name);
 struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
 void dma_release_channel(struct dma_chan *chan);
 #else
@@ -1063,6 +1066,11 @@ static inline struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 {
 	return NULL;
 }
+static inline struct dma_chan *dma_request_slave_channel_reason(
+					struct device *dev, const char *name)
+{
+	return ERR_PTR(-ENODEV);
+}
 static inline struct dma_chan *dma_request_slave_channel(struct device *dev,
 							 const char *name)
 {
-- 
1.8.1.5

