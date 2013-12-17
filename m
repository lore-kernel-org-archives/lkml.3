Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3LQSQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:16:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32984 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab3LQSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:16:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jim Quinlan <jim2101024@gmail.com>, linux-mips@linux-mips.org,
        cernekee@gmail.com, Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 102/103] MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R10000
Date: Tue, 17 Dec 2013 18:13:31 +0000
Message-Id: <1387304012-23805-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Quinlan <jim2101024@gmail.com>

commit f86f55d3ad21b21b736bdeb29bee0f0937b77138 upstream.

The BMIPS5000 (Zephyr) processor utilizes instruction speculation. A
stale misprediction address in either the JTB or the CRS may trigger
a prefetch inside a region that is currently being used by a DMA engine,
which is not IO-coherent.  This prefetch will fetch a line into the
scache, and that line will soon become stale (ie wrong) during/after the
DMA.  Mayhem ensues.

In dma-default.c, the r10000 is handled as a special case in the same way
that we want to handle Zephyr.  So we generalize the exception cases into
a function, and include Zephyr as one of the processors that needs this
special care.

Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Cc: linux-mips@linux-mips.org
Cc: cernekee@gmail.com
Patchwork: https://patchwork.linux-mips.org/patch/5776/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/mm/dma-default.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 3fab204..0eea2d2 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -30,16 +30,20 @@ static inline struct page *dma_addr_to_page(struct device *dev,
 }
 
 /*
+ * The affected CPUs below in 'cpu_needs_post_dma_flush()' can
+ * speculatively fill random cachelines with stale data at any time,
+ * requiring an extra flush post-DMA.
+ *
  * Warning on the terminology - Linux calls an uncached area coherent;
  * MIPS terminology calls memory areas with hardware maintained coherency
  * coherent.
  */
-
-static inline int cpu_is_noncoherent_r10000(struct device *dev)
+static inline int cpu_needs_post_dma_flush(struct device *dev)
 {
 	return !plat_device_is_coherent(dev) &&
 	       (current_cpu_type() == CPU_R10000 ||
-	       current_cpu_type() == CPU_R12000);
+		current_cpu_type() == CPU_R12000 ||
+		current_cpu_type() == CPU_BMIPS5000);
 }
 
 static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp)
@@ -209,7 +213,7 @@ static inline void __dma_sync(struct page *page,
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
-	if (cpu_is_noncoherent_r10000(dev))
+	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_addr),
 			   dma_addr & ~PAGE_MASK, size, direction);
 
@@ -260,7 +264,7 @@ static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 static void mips_dma_sync_single_for_cpu(struct device *dev,
 	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
-	if (cpu_is_noncoherent_r10000(dev))
+	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_handle),
 			   dma_handle & ~PAGE_MASK, size, direction);
 }
@@ -281,7 +285,7 @@ static void mips_dma_sync_sg_for_cpu(struct device *dev,
 
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
-		if (cpu_is_noncoherent_r10000(dev))
+		if (cpu_needs_post_dma_flush(dev))
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
 	}
-- 
1.8.3.2

