Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3EYQyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 12:54:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab3EYQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 12:54:42 -0400
Date: Sat, 25 May 2013 12:54:38 -0400
From: Kyle McMartin <kyle@redhat.com>
To: djbw@fb.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ioatdma: check dma_mapping_error in ioat_dma_self_test
Message-ID: <20130525165437.GD30204@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not checking dma_mapping_error on these dma_map_single uses keeps
showing up in our test runs with DMA-API debugging enabled.

[   19.744756] ioatdma: Intel(R) QuickData Technology Driver 4.00 
[   19.748979] ------------[ cut here ]------------ 
[   19.748991] WARNING: at lib/dma-debug.c:933 check_unmap+0x407/0x8a0() 

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -832,7 +832,17 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 	}
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, dma_src)) {
+		err = -ENODEV;
+		goto free_resources;
+	}
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, dma_dest)) {
+		err = -ENODEV;
+		dma_unmap_single(dev, dma_src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
+		goto free_resources;
+	}
+
 	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
 		DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
