Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaEPIel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:34:41 -0400
Received: from si-002-i32.relay.mailchannels.net ([184.154.112.197]:32924 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756360AbaEPId5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:33:57 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
X-MC-Relay: Neutral
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 5/5] staging: xillybus: Use devm_ API for memory allocation and DMA mapping
Date: Fri, 16 May 2014 11:26:39 +0300
Message-Id: <1400228799-8832-6-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Managed device resource API replaces code that reinvents it for memory
allocation, page allocation and DMA mapping.

Suggested-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 drivers/staging/xillybus/xillybus.h      |   31 +------
 drivers/staging/xillybus/xillybus_core.c |  160 ++++++++----------------------
 drivers/staging/xillybus/xillybus_of.c   |   54 +----------
 drivers/staging/xillybus/xillybus_pcie.c |   46 +--------
 4 files changed, 48 insertions(+), 243 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus.h b/drivers/staging/xillybus/xillybus.h
index 78a749a..88bb6e5 100644
--- a/drivers/staging/xillybus/xillybus.h
+++ b/drivers/staging/xillybus/xillybus.h
@@ -25,33 +25,12 @@
 
 struct xilly_endpoint_hardware;
 
-struct xilly_page {
-	struct list_head node;
-	unsigned long addr;
-	unsigned int order;
-};
-
-struct xilly_dma {
-	struct list_head node;
-	struct pci_dev *pdev;
-	struct device *dev;
-	dma_addr_t dma_addr;
-	size_t size;
-	int direction;
-};
-
 struct xilly_buffer {
 	void *addr;
 	dma_addr_t dma_addr;
 	int end_offset; /* Counting elements, not bytes */
 };
 
-struct xilly_cleanup {
-	struct list_head to_kfree;
-	struct list_head to_pagefree;
-	struct list_head to_unmap;
-};
-
 struct xilly_idt_handle {
 	unsigned char *chandesc;
 	unsigned char *idt;
@@ -126,9 +105,6 @@ struct xilly_endpoint {
 	struct mutex register_mutex;
 	wait_queue_head_t ep_wait;
 
-	/* List of memory allocations, to make release easy */
-	struct xilly_cleanup cleanup;
-
 	/* Channels and message handling */
 	struct cdev cdev;
 
@@ -156,19 +132,14 @@ struct xilly_endpoint_hardware {
 				       dma_addr_t,
 				       size_t,
 				       int);
-	dma_addr_t (*map_single)(struct xilly_cleanup *,
-				 struct xilly_endpoint *,
+	dma_addr_t (*map_single)(struct xilly_endpoint *,
 				 void *,
 				 size_t,
 				 int);
-	void (*unmap_single)(struct xilly_dma *entry);
 };
 
 irqreturn_t xillybus_isr(int irq, void *data);
 
-void xillybus_do_cleanup(struct xilly_cleanup *mem,
-			 struct xilly_endpoint *endpoint);
-
 struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
 					      struct device *dev,
 					      struct xilly_endpoint_hardware
diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index fe8f9d2..ff78937 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -311,85 +311,14 @@ EXPORT_SYMBOL(xillybus_isr);
  * no locks are applied!
  */
 
-void xillybus_do_cleanup(struct xilly_cleanup *mem,
-			 struct xilly_endpoint *endpoint)
-{
-	struct list_head *this, *next;
-
-	list_for_each_safe(this, next, &mem->to_unmap) {
-		struct xilly_dma *entry =
-			list_entry(this, struct xilly_dma, node);
-
-		endpoint->ephw->unmap_single(entry);
-		kfree(entry);
-	}
-
-	INIT_LIST_HEAD(&mem->to_unmap);
-
-	list_for_each_safe(this, next, &mem->to_kfree)
-		kfree(this);
-
-	INIT_LIST_HEAD(&mem->to_kfree);
-
-	list_for_each_safe(this, next, &mem->to_pagefree) {
-		struct xilly_page *entry =
-			list_entry(this, struct xilly_page, node);
-
-		free_pages(entry->addr, entry->order);
-		kfree(entry);
-	}
-	INIT_LIST_HEAD(&mem->to_pagefree);
-}
-EXPORT_SYMBOL(xillybus_do_cleanup);
-
-static void *xilly_malloc(struct xilly_cleanup *mem, size_t size)
-{
-	void *ptr;
-
-	ptr = kzalloc(sizeof(struct list_head) + size, GFP_KERNEL);
-
-	if (!ptr)
-		return ptr;
-
-	list_add_tail((struct list_head *) ptr, &mem->to_kfree);
-
-	return ptr + sizeof(struct list_head);
-}
-
-static unsigned long xilly_pagealloc(struct xilly_cleanup *mem,
-				     unsigned long order)
-{
-	unsigned long addr;
-	struct xilly_page *this;
-
-	this = kmalloc(sizeof(struct xilly_page), GFP_KERNEL);
-	if (!this)
-		return 0;
-
-	addr =  __get_free_pages(GFP_KERNEL | __GFP_DMA32 | __GFP_ZERO, order);
-
-	if (!addr) {
-		kfree(this);
-		return 0;
-	}
-
-	this->addr = addr;
-	this->order = order;
-
-	list_add_tail(&this->node, &mem->to_pagefree);
-
-	return addr;
-}
-
-
 static void xillybus_autoflush(struct work_struct *work);
 
 static int xilly_setupchannels(struct xilly_endpoint *ep,
-			       struct xilly_cleanup *mem,
 			       unsigned char *chandesc,
 			       int entries
 	)
 {
+	struct device *dev = ep->dev;
 	int i, entry, wr_nbuffer, rd_nbuffer;
 	struct xilly_channel *channel;
 	int channelnum, bufnum, bufsize, format, is_writebuf;
@@ -402,17 +331,19 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 	int left_of_rd_salami = 0;
 	dma_addr_t dma_addr;
 	int msg_buf_done = 0;
+	const gfp_t gfp_mask = GFP_KERNEL | __GFP_DMA32 | __GFP_ZERO;
 
 	struct xilly_buffer *this_buffer = NULL; /* Init to silence warning */
 
-	channel = xilly_malloc(mem, ep->num_channels *
-			       sizeof(struct xilly_channel));
+	channel = devm_kzalloc(dev, ep->num_channels *
+			       sizeof(struct xilly_channel), GFP_KERNEL);
 
 	if (!channel)
 		goto memfail;
 
-	ep->channels = xilly_malloc(mem, (ep->num_channels + 1) *
-				    sizeof(struct xilly_channel *));
+	ep->channels = devm_kzalloc(dev, (ep->num_channels + 1) *
+				    sizeof(struct xilly_channel *),
+				    GFP_KERNEL);
 
 	if (!ep->channels)
 		goto memfail;
@@ -501,16 +432,16 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 			channel->rd_exclusive_open = exclusive_open;
 			channel->seekable = seekable;
 
-			channel->rd_buffers = xilly_malloc(
-				mem,
-				bufnum * sizeof(struct xilly_buffer *));
+			channel->rd_buffers = devm_kzalloc(dev,
+				bufnum * sizeof(struct xilly_buffer *),
+				GFP_KERNEL);
 
 			if (!channel->rd_buffers)
 				goto memfail;
 
-			this_buffer = xilly_malloc(
-				mem,
-				bufnum * sizeof(struct xilly_buffer));
+			this_buffer = devm_kzalloc(dev,
+				bufnum * sizeof(struct xilly_buffer),
+				GFP_KERNEL);
 
 			if (!this_buffer)
 				goto memfail;
@@ -530,16 +461,16 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 			channel->wr_synchronous = synchronous;
 			channel->wr_exclusive_open = exclusive_open;
 
-			channel->wr_buffers = xilly_malloc(
-				mem,
-				bufnum * sizeof(struct xilly_buffer *));
+			channel->wr_buffers = devm_kzalloc(dev,
+				bufnum * sizeof(struct xilly_buffer *),
+				GFP_KERNEL);
 
 			if (!channel->wr_buffers)
 				goto memfail;
 
-			this_buffer = xilly_malloc(
-				mem,
-				bufnum * sizeof(struct xilly_buffer));
+			this_buffer = devm_kzalloc(dev,
+				bufnum * sizeof(struct xilly_buffer),
+				GFP_KERNEL);
 
 			if (!this_buffer)
 				goto memfail;
@@ -576,15 +507,16 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 					}
 
 					wr_salami = (void *)
-						xilly_pagealloc(mem,
-								allocorder);
+						devm_get_free_pages(
+							dev, gfp_mask,
+							allocorder);
+
 					if (!wr_salami)
 						goto memfail;
 					left_of_wr_salami = allocsize;
 				}
 
 				dma_addr = ep->ephw->map_single(
-					mem,
 					ep,
 					wr_salami,
 					bytebufsize,
@@ -654,8 +586,8 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 					}
 
 					rd_salami = (void *)
-						xilly_pagealloc(
-							mem,
+						devm_get_free_pages(
+							dev, gfp_mask,
 							allocorder);
 
 					if (!rd_salami)
@@ -664,7 +596,6 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 				}
 
 				dma_addr = ep->ephw->map_single(
-					mem,
 					ep,
 					rd_salami,
 					bytebufsize,
@@ -2103,9 +2034,6 @@ struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
 	endpoint->pdev = pdev;
 	endpoint->dev = dev;
 	endpoint->ephw = ephw;
-	INIT_LIST_HEAD(&endpoint->cleanup.to_kfree);
-	INIT_LIST_HEAD(&endpoint->cleanup.to_pagefree);
-	INIT_LIST_HEAD(&endpoint->cleanup.to_unmap);
 	endpoint->msg_counter = 0x0b;
 	endpoint->failed_messages = 0;
 	endpoint->fatal_error = 0;
@@ -2131,7 +2059,7 @@ static int xilly_quiesce(struct xilly_endpoint *endpoint)
 
 	if (endpoint->idtlen < 0) {
 		dev_err(endpoint->dev,
-			"Failed to quiesce the device on exit. Quitting while leaving a mess.\n");
+			"Failed to quiesce the device on exit.\n");
 		return -ENODEV;
 	}
 	return 0; /* Success */
@@ -2141,8 +2069,9 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 {
 	int rc = 0;
 
-	struct xilly_cleanup tmpmem;
+	void *bootstrap_resources;
 	int idtbuffersize = (1 << PAGE_SHIFT);
+	struct device *dev = endpoint->dev;
 
 	/*
 	 * The bogus IDT is used during bootstrap for allocating the initial
@@ -2155,10 +2084,6 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 				       3, 192, PAGE_SHIFT, 0 };
 	struct xilly_idt_handle idt_handle;
 
-	INIT_LIST_HEAD(&tmpmem.to_kfree);
-	INIT_LIST_HEAD(&tmpmem.to_pagefree);
-	INIT_LIST_HEAD(&tmpmem.to_unmap);
-
 	/*
 	 * Writing the value 0x00000001 to Endianness register signals which
 	 * endianness this processor is using, so the FPGA can swap words as
@@ -2170,12 +2095,16 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 
 	/* Bootstrap phase I: Allocate temporary message buffer */
 
+	bootstrap_resources = devres_open_group(dev, NULL, GFP_KERNEL);
+	if (!bootstrap_resources)
+		return -ENOMEM;
+
 	endpoint->num_channels = 0;
 
-	rc = xilly_setupchannels(endpoint, &tmpmem, bogus_idt, 1);
+	rc = xilly_setupchannels(endpoint, bogus_idt, 1);
 
 	if (rc)
-		goto failed_buffers;
+		return rc;
 
 	/* Clear the message subsystem (and counter in particular) */
 	iowrite32(0x04, &endpoint->registers[fpga_msg_ctrl_reg]);
@@ -2199,8 +2128,7 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 
 	if (endpoint->idtlen < 0) {
 		dev_err(endpoint->dev, "No response from FPGA. Aborting.\n");
-		rc = -ENODEV;
-		goto failed_quiesce;
+		return -ENODEV;
 	}
 
 	/* Enable DMA */
@@ -2216,7 +2144,7 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 
 	endpoint->num_channels = 1;
 
-	rc = xilly_setupchannels(endpoint, &tmpmem, bogus_idt, 2);
+	rc = xilly_setupchannels(endpoint, bogus_idt, 2);
 
 	if (rc)
 		goto failed_idt;
@@ -2234,10 +2162,12 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 		rc = -ENODEV;
 		goto failed_idt;
 	}
+
+	devres_close_group(dev, bootstrap_resources);
+
 	/* Bootstrap phase III: Allocate buffers according to IDT */
 
 	rc = xilly_setupchannels(endpoint,
-				 &endpoint->cleanup,
 				 idt_handle.chandesc,
 				 idt_handle.entries);
 
@@ -2260,7 +2190,7 @@ int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
 	if (rc)
 		goto failed_chrdevs;
 
-	xillybus_do_cleanup(&tmpmem, endpoint);
+	devres_release_group(dev, bootstrap_resources);
 
 	return 0;
 
@@ -2270,16 +2200,8 @@ failed_chrdevs:
 	mutex_unlock(&ep_list_lock);
 
 failed_idt:
-	/* Quiesce the device. Now it's serious to do it */
-	rc = xilly_quiesce(endpoint);
-
-	if (rc)
-		return rc; /* FPGA may still DMA, so no release */
-
+	xilly_quiesce(endpoint);
 	flush_workqueue(xillybus_wq);
-failed_quiesce:
-failed_buffers:
-	xillybus_do_cleanup(&tmpmem, endpoint);
 
 	return rc;
 }
diff --git a/drivers/staging/xillybus/xillybus_of.c b/drivers/staging/xillybus/xillybus_of.c
index 46ea010..0e4a67c 100644
--- a/drivers/staging/xillybus/xillybus_of.c
+++ b/drivers/staging/xillybus/xillybus_of.c
@@ -62,44 +62,13 @@ static void xilly_dma_sync_single_nop(struct xilly_endpoint *ep,
 {
 }
 
-static dma_addr_t xilly_map_single_of(struct xilly_cleanup *mem,
-				      struct xilly_endpoint *ep,
+static dma_addr_t xilly_map_single_of(struct xilly_endpoint *ep,
 				      void *ptr,
 				      size_t size,
 				      int direction
 	)
 {
-
-	dma_addr_t addr = 0;
-	struct xilly_dma *this;
-
-	this = kmalloc(sizeof(struct xilly_dma), GFP_KERNEL);
-	if (!this)
-		return 0;
-
-	addr = dma_map_single(ep->dev, ptr, size, direction);
-	this->direction = direction;
-
-	if (dma_mapping_error(ep->dev, addr)) {
-		kfree(this);
-		return 0;
-	}
-
-	this->dma_addr = addr;
-	this->dev = ep->dev;
-	this->size = size;
-
-	list_add_tail(&this->node, &mem->to_unmap);
-
-	return addr;
-}
-
-static void xilly_unmap_single_of(struct xilly_dma *entry)
-{
-	dma_unmap_single(entry->dev,
-			 entry->dma_addr,
-			 entry->size,
-			 entry->direction);
+	return dmam_map_single(ep->dev, ptr, size, direction);
 }
 
 static struct xilly_endpoint_hardware of_hw = {
@@ -107,7 +76,6 @@ static struct xilly_endpoint_hardware of_hw = {
 	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_for_cpu_of,
 	.hw_sync_sgl_for_device = xilly_dma_sync_single_for_device_of,
 	.map_single = xilly_map_single_of,
-	.unmap_single = xilly_unmap_single_of
 };
 
 static struct xilly_endpoint_hardware of_hw_coherent = {
@@ -115,7 +83,6 @@ static struct xilly_endpoint_hardware of_hw_coherent = {
 	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_nop,
 	.hw_sync_sgl_for_device = xilly_dma_sync_single_nop,
 	.map_single = xilly_map_single_of,
-	.unmap_single = xilly_unmap_single_of
 };
 
 static int xilly_drv_probe(struct platform_device *op)
@@ -138,12 +105,6 @@ static int xilly_drv_probe(struct platform_device *op)
 	dev_set_drvdata(dev, endpoint);
 
 	rc = of_address_to_resource(dev->of_node, 0, &res);
-	if (rc) {
-		dev_warn(endpoint->dev,
-			 "Failed to obtain device tree resource\n");
-		return rc;
-	}
-
 	endpoint->registers = devm_ioremap_resource(dev, &res);
 
 	if (IS_ERR(endpoint->registers))
@@ -159,14 +120,7 @@ static int xilly_drv_probe(struct platform_device *op)
 		return -ENODEV;
 	}
 
-	rc = xillybus_endpoint_discovery(endpoint);
-
-	if (!rc)
-		return 0;
-
-	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
-
-	return rc;
+	return xillybus_endpoint_discovery(endpoint);
 }
 
 static int xilly_drv_remove(struct platform_device *op)
@@ -176,8 +130,6 @@ static int xilly_drv_remove(struct platform_device *op)
 
 	xillybus_endpoint_remove(endpoint);
 
-	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
-
 	return 0;
 }
 
diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
index a4fe51c..a7d60c7 100644
--- a/drivers/staging/xillybus/xillybus_pcie.c
+++ b/drivers/staging/xillybus/xillybus_pcie.c
@@ -78,46 +78,16 @@ static void xilly_dma_sync_single_for_device_pci(struct xilly_endpoint *ep,
  * but that can change.
  */
 
-static dma_addr_t xilly_map_single_pci(struct xilly_cleanup *mem,
-				       struct xilly_endpoint *ep,
+static dma_addr_t xilly_map_single_pci(struct xilly_endpoint *ep,
 				       void *ptr,
 				       size_t size,
 				       int direction
 	)
 {
-
-	dma_addr_t addr = 0;
-	struct xilly_dma *this;
 	int pci_direction;
 
-	this = kmalloc(sizeof(struct xilly_dma), GFP_KERNEL);
-	if (!this)
-		return 0;
-
 	pci_direction = xilly_pci_direction(direction);
-	addr = pci_map_single(ep->pdev, ptr, size, pci_direction);
-	this->direction = pci_direction;
-
-	if (pci_dma_mapping_error(ep->pdev, addr)) {
-		kfree(this);
-		return 0;
-	}
-
-	this->dma_addr = addr;
-	this->pdev = ep->pdev;
-	this->size = size;
-
-	list_add_tail(&this->node, &mem->to_unmap);
-
-	return addr;
-}
-
-static void xilly_unmap_single_pci(struct xilly_dma *entry)
-{
-	pci_unmap_single(entry->pdev,
-			 entry->dma_addr,
-			 entry->size,
-			 entry->direction);
+	return pcim_map_single(ep->pdev, ptr, size, pci_direction);
 }
 
 static struct xilly_endpoint_hardware pci_hw = {
@@ -125,7 +95,6 @@ static struct xilly_endpoint_hardware pci_hw = {
 	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_for_cpu_pci,
 	.hw_sync_sgl_for_device = xilly_dma_sync_single_for_device_pci,
 	.map_single = xilly_map_single_pci,
-	.unmap_single = xilly_unmap_single_pci
 };
 
 static int xilly_probe(struct pci_dev *pdev,
@@ -199,14 +168,7 @@ static int xilly_probe(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	rc = xillybus_endpoint_discovery(endpoint);
-
-	if (!rc)
-		return 0;
-
-	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
-
-	return rc;
+	return xillybus_endpoint_discovery(endpoint);
 }
 
 static void xilly_remove(struct pci_dev *pdev)
@@ -214,8 +176,6 @@ static void xilly_remove(struct pci_dev *pdev)
 	struct xilly_endpoint *endpoint = pci_get_drvdata(pdev);
 
 	xillybus_endpoint_remove(endpoint);
-
-	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
 }
 
 MODULE_DEVICE_TABLE(pci, xillyids);
-- 
1.7.2.3

