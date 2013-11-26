Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3KZTsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:48:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49500 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3KZTsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:48:15 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH V4] dma: add dma_get_any_slave_channel(), for use in of_xlate()
Date: Tue, 26 Nov 2013 12:40:51 -0700
Message-Id: <1385494851-22640-1-git-send-email-swarren@wwwdotorg.org>
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
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3:
* Re-implemented the common code as dma_get_any_slave_channel(), in
  dmaengine.c. This allows it to mutex_lock(&dma_list_mutex), and hence
  avoid the retry loop.
* Rather than having the common code call out to a driver-provided
  callback at the tail (which avoided drivers having to implement an
  of_xlate function themselves), have drivers implement a custom
  of_xlate() again, which mostly just calls the new
  dma_get_any_slave_channel(), then does any extra custom work.

v2:
* Squashed the conversion of mmp_pdma.c into the patch that added the
  common implementation, so it's easier to see the whole conversion in
  one go.

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
 drivers/dma/dmaengine.c   | 28 ++++++++++++++++++++++++++++
 drivers/dma/mmp_pdma.c    | 30 +++++++-----------------------
 include/linux/dmaengine.h |  1 +
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index e17e9b22d85e..24095ff8a93b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -535,6 +535,34 @@ struct dma_chan *dma_get_slave_channel(struct dma_chan *chan)
 }
 EXPORT_SYMBOL_GPL(dma_get_slave_channel);
 
+struct dma_chan *dma_get_any_slave_channel(struct dma_device *device)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	int err;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	/* lock against __dma_request_channel */
+	mutex_lock(&dma_list_mutex);
+
+	chan = private_candidate(&mask, device, NULL, NULL);
+	if (chan) {
+		err = dma_chan_get(chan);
+		if (err) {
+			pr_debug("%s: failed to get %s: (%d)\n",
+				__func__, dma_chan_name(chan), err);
+			chan = NULL;
+		}
+	}
+
+	mutex_unlock(&dma_list_mutex);
+
+	return chan;
+}
+EXPORT_SYMBOL_GPL(dma_get_any_slave_channel);
+
 /**
  * __dma_request_channel - try to allocate an exclusive channel
  * @mask: capabilities that the channel must satisfy
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index dcb1e05149a7..2998f1bffac1 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -893,33 +893,17 @@ static struct dma_chan *mmp_pdma_dma_xlate(struct of_phandle_args *dma_spec,
 					   struct of_dma *ofdma)
 {
 	struct mmp_pdma_device *d = ofdma->of_dma_data;
-	struct dma_chan *chan, *candidate;
+	struct dma_chan *chan;
+	struct mmp_pdma_chan *c;
 
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
+	chan = dma_get_any_slave_channel(&d->device);
+	if (!chan)
 		return NULL;
 
-	/* dma_get_slave_channel will return NULL if we lost a race between
-	 * the lookup and the reservation */
-	chan = dma_get_slave_channel(candidate);
-
-	if (chan) {
-		struct mmp_pdma_chan *c = to_mmp_pdma_chan(chan);
-		c->drcmr = dma_spec->args[0];
-		return chan;
-	}
+	c = to_mmp_pdma_chan(chan);
+	c->drcmr = dma_spec->args[0];
 
-	goto retry;
+	return chan;
 }
 
 static int mmp_pdma_probe(struct platform_device *op)
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index ed92b30a02fd..bae1568416f8 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1087,6 +1087,7 @@ int dma_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_get_slave_channel(struct dma_chan *chan);
+struct dma_chan *dma_get_any_slave_channel(struct dma_device *device);
 struct dma_chan *net_dma_find_channel(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
 #define dma_request_slave_channel_compat(mask, x, y, dev, name) \
-- 
1.8.1.5

