Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3LRVIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:08:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3LRVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:08:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Quinlan <jim2101024@gmail.com>, linux-mips@linux-mips.org,
        cernekee@gmail.com, Ralf Baechle <ralf@linux-mips.org>,
        John Ulvr <julvr@broadcom.com>
Subject: [PATCH 3.4 01/31] MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R10000
Date: Wed, 18 Dec 2013 13:08:09 -0800
Message-Id: <20131218210522.833580254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: John Ulvr <julvr@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/dma-default.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -30,16 +30,20 @@ static inline struct page *dma_addr_to_p
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
@@ -209,7 +213,7 @@ static inline void __dma_sync(struct pag
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
-	if (cpu_is_noncoherent_r10000(dev))
+	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_addr),
 			   dma_addr & ~PAGE_MASK, size, direction);
 
@@ -260,7 +264,7 @@ static void mips_dma_unmap_sg(struct dev
 static void mips_dma_sync_single_for_cpu(struct device *dev,
 	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
-	if (cpu_is_noncoherent_r10000(dev))
+	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_handle),
 			   dma_handle & ~PAGE_MASK, size, direction);
 }
@@ -281,7 +285,7 @@ static void mips_dma_sync_sg_for_cpu(str
 
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
-		if (cpu_is_noncoherent_r10000(dev))
+		if (cpu_needs_post_dma_flush(dev))
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
 	}


