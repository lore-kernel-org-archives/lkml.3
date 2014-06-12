Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaFLDSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:18:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55558 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbaFLDRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:17:52 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 04/10] DMA, CMA: support alignment constraint on cma region
Date: Thu, 12 Jun 2014 12:21:41 +0900
Message-Id: <1402543307-29800-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppc kvm's cma area management needs alignment constraint on
cma region. So support it to prepare generalization of cma area
management functionality.

Additionally, add some comments which tell us why alignment
constraint is needed on cma region.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 8a44c82..bc4c171 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/mm_types.h>
 #include <linux/dma-contiguous.h>
+#include <linux/log2.h>
 
 struct cma {
 	unsigned long	base_pfn;
@@ -219,6 +220,7 @@ core_initcall(cma_init_reserved_areas);
  * @size: Size of the reserved area (in bytes),
  * @base: Base address of the reserved area optional, use 0 for any
  * @limit: End address of the reserved memory (optional, 0 for any).
+ * @alignment: Alignment for the contiguous memory area, should be power of 2
  * @res_cma: Pointer to store the created cma region.
  * @fixed: hint about where to place the reserved area
  *
@@ -233,15 +235,15 @@ core_initcall(cma_init_reserved_areas);
  */
 static int __init __dma_contiguous_reserve_area(phys_addr_t size,
 				phys_addr_t base, phys_addr_t limit,
+				phys_addr_t alignment,
 				struct cma **res_cma, bool fixed)
 {
 	struct cma *cma = &cma_areas[cma_area_count];
-	phys_addr_t alignment;
 	int ret = 0;
 
-	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
-		 (unsigned long)size, (unsigned long)base,
-		 (unsigned long)limit);
+	pr_debug("%s(size %lx, base %08lx, limit %08lx align_order %08lx)\n",
+		__func__, (unsigned long)size, (unsigned long)base,
+		(unsigned long)limit, (unsigned long)alignment);
 
 	/* Sanity checks */
 	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
@@ -253,8 +255,17 @@ static int __init __dma_contiguous_reserve_area(phys_addr_t size,
 	if (!size)
 		return -EINVAL;
 
-	/* Sanitise input arguments */
-	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	if (alignment && !is_power_of_2(alignment))
+		return -EINVAL;
+
+	/*
+	 * Sanitise input arguments.
+	 * CMA area should be at least MAX_ORDER - 1 aligned. Otherwise,
+	 * CMA area could be merged into other MIGRATE_TYPE by buddy mechanism
+	 * and CMA property will be broken.
+	 */
+	alignment = max(alignment,
+		(phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
@@ -302,7 +313,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 {
 	int ret;
 
-	ret = __dma_contiguous_reserve_area(size, base, limit, res_cma, fixed);
+	ret = __dma_contiguous_reserve_area(size, base, limit, 0,
+						res_cma, fixed);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5

