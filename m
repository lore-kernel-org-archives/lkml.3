Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3HAWBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:01:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39786 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3HAWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:01:37 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 27/51] DMA-API: provide a helper to setup DMA masks
Message-Id: <E1V50vl-0006sG-Fo@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:01:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers contain code such as:

	dev->dma_mask = &dev->coherent_dma_mask;
	dev->coherent_dma_mask = MASK;

Let's move this pattern out of drivers and have the DMA API provide a
helper for it.  This helper uses dma_set_mask_and_coherent() to allow
platform issues to be properly dealt with via dma_set_mask()/
dma_is_supported().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/dma-mapping.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 8f7a2e8..48ef6f5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -111,6 +111,16 @@ static inline int dma_set_mask_and_coherent(struct device *dev, u64 mask)
 	return rc;
 }
 
+/*
+ * Similar to the above, except it deals with the case where the device
+ * does not have dev->dma_mask appropriately setup.
+ */
+static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
+{
+	dev->dma_mask = &dev->coherent_dma_mask;
+	return dma_set_mask_and_coherent(dev, mask);
+}
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
-- 
1.7.4.4

