Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaIZPp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:45:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35754 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196AbaIZPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:45:22 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 1/2] Documentation: dmaengine: Move the current doc to a folder of its own
Date: Fri, 26 Sep 2014 17:40:34 +0200
Message-Id: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the current client-side documentation to a subfolder to prepare the
introduction of a provider-side API documentation.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/dmaengine.txt        | 199 -------------------------------------
 Documentation/dmaengine/client.txt | 199 +++++++++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+), 199 deletions(-)
 delete mode 100644 Documentation/dmaengine.txt
 create mode 100644 Documentation/dmaengine/client.txt

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
deleted file mode 100644
index 573e28ce9751..000000000000
--- a/Documentation/dmaengine.txt
+++ /dev/null
@@ -1,199 +0,0 @@
-			DMA Engine API Guide
-			====================
-
-		 Vinod Koul <vinod dot koul at intel.com>
-
-NOTE: For DMA Engine usage in async_tx please see:
-	Documentation/crypto/async-tx-api.txt
-
-
-Below is a guide to device driver writers on how to use the Slave-DMA API of the
-DMA Engine. This is applicable only for slave DMA usage only.
-
-The slave DMA usage consists of following steps:
-1. Allocate a DMA slave channel
-2. Set slave and controller specific parameters
-3. Get a descriptor for transaction
-4. Submit the transaction
-5. Issue pending requests and wait for callback notification
-
-1. Allocate a DMA slave channel
-
-   Channel allocation is slightly different in the slave DMA context,
-   client drivers typically need a channel from a particular DMA
-   controller only and even in some cases a specific channel is desired.
-   To request a channel dma_request_channel() API is used.
-
-   Interface:
-	struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
-			dma_filter_fn filter_fn,
-			void *filter_param);
-   where dma_filter_fn is defined as:
-	typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
-
-   The 'filter_fn' parameter is optional, but highly recommended for
-   slave and cyclic channels as they typically need to obtain a specific
-   DMA channel.
-
-   When the optional 'filter_fn' parameter is NULL, dma_request_channel()
-   simply returns the first channel that satisfies the capability mask.
-
-   Otherwise, the 'filter_fn' routine will be called once for each free
-   channel which has a capability in 'mask'.  'filter_fn' is expected to
-   return 'true' when the desired DMA channel is found.
-
-   A channel allocated via this interface is exclusive to the caller,
-   until dma_release_channel() is called.
-
-2. Set slave and controller specific parameters
-
-   Next step is always to pass some specific information to the DMA
-   driver.  Most of the generic information which a slave DMA can use
-   is in struct dma_slave_config.  This allows the clients to specify
-   DMA direction, DMA addresses, bus widths, DMA burst lengths etc
-   for the peripheral.
-
-   If some DMA controllers have more parameters to be sent then they
-   should try to embed struct dma_slave_config in their controller
-   specific structure. That gives flexibility to client to pass more
-   parameters, if required.
-
-   Interface:
-	int dmaengine_slave_config(struct dma_chan *chan,
-				  struct dma_slave_config *config)
-
-   Please see the dma_slave_config structure definition in dmaengine.h
-   for a detailed explanation of the struct members.  Please note
-   that the 'direction' member will be going away as it duplicates the
-   direction given in the prepare call.
-
-3. Get a descriptor for transaction
-
-   For slave usage the various modes of slave transfers supported by the
-   DMA-engine are:
-
-   slave_sg	- DMA a list of scatter gather buffers from/to a peripheral
-   dma_cyclic	- Perform a cyclic DMA operation from/to a peripheral till the
-		  operation is explicitly stopped.
-   interleaved_dma - This is common to Slave as well as M2M clients. For slave
-		 address of devices' fifo could be already known to the driver.
-		 Various types of operations could be expressed by setting
-		 appropriate values to the 'dma_interleaved_template' members.
-
-   A non-NULL return of this transfer API represents a "descriptor" for
-   the given transaction.
-
-   Interface:
-	struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
-		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
-		unsigned long flags);
-
-	struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
-		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction);
-
-	struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
-		struct dma_chan *chan, struct dma_interleaved_template *xt,
-		unsigned long flags);
-
-   The peripheral driver is expected to have mapped the scatterlist for
-   the DMA operation prior to calling device_prep_slave_sg, and must
-   keep the scatterlist mapped until the DMA operation has completed.
-   The scatterlist must be mapped using the DMA struct device.
-   If a mapping needs to be synchronized later, dma_sync_*_for_*() must be
-   called using the DMA struct device, too.
-   So, normal setup should look like this:
-
-	nr_sg = dma_map_sg(chan->device->dev, sgl, sg_len);
-	if (nr_sg == 0)
-		/* error */
-
-	desc = dmaengine_prep_slave_sg(chan, sgl, nr_sg, direction, flags);
-
-   Once a descriptor has been obtained, the callback information can be
-   added and the descriptor must then be submitted.  Some DMA engine
-   drivers may hold a spinlock between a successful preparation and
-   submission so it is important that these two operations are closely
-   paired.
-
-   Note:
-	Although the async_tx API specifies that completion callback
-	routines cannot submit any new operations, this is not the
-	case for slave/cyclic DMA.
-
-	For slave DMA, the subsequent transaction may not be available
-	for submission prior to callback function being invoked, so
-	slave DMA callbacks are permitted to prepare and submit a new
-	transaction.
-
-	For cyclic DMA, a callback function may wish to terminate the
-	DMA via dmaengine_terminate_all().
-
-	Therefore, it is important that DMA engine drivers drop any
-	locks before calling the callback function which may cause a
-	deadlock.
-
-	Note that callbacks will always be invoked from the DMA
-	engines tasklet, never from interrupt context.
-
-4. Submit the transaction
-
-   Once the descriptor has been prepared and the callback information
-   added, it must be placed on the DMA engine drivers pending queue.
-
-   Interface:
-	dma_cookie_t dmaengine_submit(struct dma_async_tx_descriptor *desc)
-
-   This returns a cookie can be used to check the progress of DMA engine
-   activity via other DMA engine calls not covered in this document.
-
-   dmaengine_submit() will not start the DMA operation, it merely adds
-   it to the pending queue.  For this, see step 5, dma_async_issue_pending.
-
-5. Issue pending DMA requests and wait for callback notification
-
-   The transactions in the pending queue can be activated by calling the
-   issue_pending API. If channel is idle then the first transaction in
-   queue is started and subsequent ones queued up.
-
-   On completion of each DMA operation, the next in queue is started and
-   a tasklet triggered. The tasklet will then call the client driver
-   completion callback routine for notification, if set.
-
-   Interface:
-	void dma_async_issue_pending(struct dma_chan *chan);
-
-Further APIs:
-
-1. int dmaengine_terminate_all(struct dma_chan *chan)
-
-   This causes all activity for the DMA channel to be stopped, and may
-   discard data in the DMA FIFO which hasn't been fully transferred.
-   No callback functions will be called for any incomplete transfers.
-
-2. int dmaengine_pause(struct dma_chan *chan)
-
-   This pauses activity on the DMA channel without data loss.
-
-3. int dmaengine_resume(struct dma_chan *chan)
-
-   Resume a previously paused DMA channel.  It is invalid to resume a
-   channel which is not currently paused.
-
-4. enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
-        dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
-
-   This can be used to check the status of the channel.  Please see
-   the documentation in include/linux/dmaengine.h for a more complete
-   description of this API.
-
-   This can be used in conjunction with dma_async_is_complete() and
-   the cookie returned from dmaengine_submit() to check for
-   completion of a specific DMA transaction.
-
-   Note:
-	Not all DMA engine drivers can return reliable information for
-	a running DMA channel.  It is recommended that DMA engine users
-	pause or stop (via dmaengine_terminate_all) the channel before
-	using this API.
diff --git a/Documentation/dmaengine/client.txt b/Documentation/dmaengine/client.txt
new file mode 100644
index 000000000000..573e28ce9751
--- /dev/null
+++ b/Documentation/dmaengine/client.txt
@@ -0,0 +1,199 @@
+			DMA Engine API Guide
+			====================
+
+		 Vinod Koul <vinod dot koul at intel.com>
+
+NOTE: For DMA Engine usage in async_tx please see:
+	Documentation/crypto/async-tx-api.txt
+
+
+Below is a guide to device driver writers on how to use the Slave-DMA API of the
+DMA Engine. This is applicable only for slave DMA usage only.
+
+The slave DMA usage consists of following steps:
+1. Allocate a DMA slave channel
+2. Set slave and controller specific parameters
+3. Get a descriptor for transaction
+4. Submit the transaction
+5. Issue pending requests and wait for callback notification
+
+1. Allocate a DMA slave channel
+
+   Channel allocation is slightly different in the slave DMA context,
+   client drivers typically need a channel from a particular DMA
+   controller only and even in some cases a specific channel is desired.
+   To request a channel dma_request_channel() API is used.
+
+   Interface:
+	struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
+			dma_filter_fn filter_fn,
+			void *filter_param);
+   where dma_filter_fn is defined as:
+	typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
+
+   The 'filter_fn' parameter is optional, but highly recommended for
+   slave and cyclic channels as they typically need to obtain a specific
+   DMA channel.
+
+   When the optional 'filter_fn' parameter is NULL, dma_request_channel()
+   simply returns the first channel that satisfies the capability mask.
+
+   Otherwise, the 'filter_fn' routine will be called once for each free
+   channel which has a capability in 'mask'.  'filter_fn' is expected to
+   return 'true' when the desired DMA channel is found.
+
+   A channel allocated via this interface is exclusive to the caller,
+   until dma_release_channel() is called.
+
+2. Set slave and controller specific parameters
+
+   Next step is always to pass some specific information to the DMA
+   driver.  Most of the generic information which a slave DMA can use
+   is in struct dma_slave_config.  This allows the clients to specify
+   DMA direction, DMA addresses, bus widths, DMA burst lengths etc
+   for the peripheral.
+
+   If some DMA controllers have more parameters to be sent then they
+   should try to embed struct dma_slave_config in their controller
+   specific structure. That gives flexibility to client to pass more
+   parameters, if required.
+
+   Interface:
+	int dmaengine_slave_config(struct dma_chan *chan,
+				  struct dma_slave_config *config)
+
+   Please see the dma_slave_config structure definition in dmaengine.h
+   for a detailed explanation of the struct members.  Please note
+   that the 'direction' member will be going away as it duplicates the
+   direction given in the prepare call.
+
+3. Get a descriptor for transaction
+
+   For slave usage the various modes of slave transfers supported by the
+   DMA-engine are:
+
+   slave_sg	- DMA a list of scatter gather buffers from/to a peripheral
+   dma_cyclic	- Perform a cyclic DMA operation from/to a peripheral till the
+		  operation is explicitly stopped.
+   interleaved_dma - This is common to Slave as well as M2M clients. For slave
+		 address of devices' fifo could be already known to the driver.
+		 Various types of operations could be expressed by setting
+		 appropriate values to the 'dma_interleaved_template' members.
+
+   A non-NULL return of this transfer API represents a "descriptor" for
+   the given transaction.
+
+   Interface:
+	struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags);
+
+	struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction);
+
+	struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
+		struct dma_chan *chan, struct dma_interleaved_template *xt,
+		unsigned long flags);
+
+   The peripheral driver is expected to have mapped the scatterlist for
+   the DMA operation prior to calling device_prep_slave_sg, and must
+   keep the scatterlist mapped until the DMA operation has completed.
+   The scatterlist must be mapped using the DMA struct device.
+   If a mapping needs to be synchronized later, dma_sync_*_for_*() must be
+   called using the DMA struct device, too.
+   So, normal setup should look like this:
+
+	nr_sg = dma_map_sg(chan->device->dev, sgl, sg_len);
+	if (nr_sg == 0)
+		/* error */
+
+	desc = dmaengine_prep_slave_sg(chan, sgl, nr_sg, direction, flags);
+
+   Once a descriptor has been obtained, the callback information can be
+   added and the descriptor must then be submitted.  Some DMA engine
+   drivers may hold a spinlock between a successful preparation and
+   submission so it is important that these two operations are closely
+   paired.
+
+   Note:
+	Although the async_tx API specifies that completion callback
+	routines cannot submit any new operations, this is not the
+	case for slave/cyclic DMA.
+
+	For slave DMA, the subsequent transaction may not be available
+	for submission prior to callback function being invoked, so
+	slave DMA callbacks are permitted to prepare and submit a new
+	transaction.
+
+	For cyclic DMA, a callback function may wish to terminate the
+	DMA via dmaengine_terminate_all().
+
+	Therefore, it is important that DMA engine drivers drop any
+	locks before calling the callback function which may cause a
+	deadlock.
+
+	Note that callbacks will always be invoked from the DMA
+	engines tasklet, never from interrupt context.
+
+4. Submit the transaction
+
+   Once the descriptor has been prepared and the callback information
+   added, it must be placed on the DMA engine drivers pending queue.
+
+   Interface:
+	dma_cookie_t dmaengine_submit(struct dma_async_tx_descriptor *desc)
+
+   This returns a cookie can be used to check the progress of DMA engine
+   activity via other DMA engine calls not covered in this document.
+
+   dmaengine_submit() will not start the DMA operation, it merely adds
+   it to the pending queue.  For this, see step 5, dma_async_issue_pending.
+
+5. Issue pending DMA requests and wait for callback notification
+
+   The transactions in the pending queue can be activated by calling the
+   issue_pending API. If channel is idle then the first transaction in
+   queue is started and subsequent ones queued up.
+
+   On completion of each DMA operation, the next in queue is started and
+   a tasklet triggered. The tasklet will then call the client driver
+   completion callback routine for notification, if set.
+
+   Interface:
+	void dma_async_issue_pending(struct dma_chan *chan);
+
+Further APIs:
+
+1. int dmaengine_terminate_all(struct dma_chan *chan)
+
+   This causes all activity for the DMA channel to be stopped, and may
+   discard data in the DMA FIFO which hasn't been fully transferred.
+   No callback functions will be called for any incomplete transfers.
+
+2. int dmaengine_pause(struct dma_chan *chan)
+
+   This pauses activity on the DMA channel without data loss.
+
+3. int dmaengine_resume(struct dma_chan *chan)
+
+   Resume a previously paused DMA channel.  It is invalid to resume a
+   channel which is not currently paused.
+
+4. enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
+        dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
+
+   This can be used to check the status of the channel.  Please see
+   the documentation in include/linux/dmaengine.h for a more complete
+   description of this API.
+
+   This can be used in conjunction with dma_async_is_complete() and
+   the cookie returned from dmaengine_submit() to check for
+   completion of a specific DMA transaction.
+
+   Note:
+	Not all DMA engine drivers can return reliable information for
+	a running DMA channel.  It is recommended that DMA engine users
+	pause or stop (via dmaengine_terminate_all) the channel before
+	using this API.
-- 
2.1.0

