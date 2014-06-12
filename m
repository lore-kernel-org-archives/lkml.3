Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaFLDSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:18:07 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55555 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaFLDRw (ORCPT
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
Subject: [PATCH v2 01/10] DMA, CMA: clean-up log message
Date: Thu, 12 Jun 2014 12:21:38 +0900
Message-Id: <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need explicit 'CMA:' prefix, since we already define prefix
'cma:' in pr_fmt. So remove it.

And, some logs print function name and others doesn't. This looks
bad to me, so I unify log format to print function name consistently.

Lastly, I add one more debug log on cma_activate_area().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 83969f8..bd0bb81 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -144,7 +144,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 	}
 
 	if (selected_size && !dma_contiguous_default_area) {
-		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
+		pr_debug("%s(): reserving %ld MiB for global area\n", __func__,
 			 (unsigned long)selected_size / SZ_1M);
 
 		dma_contiguous_reserve_area(selected_size, selected_base,
@@ -163,8 +163,9 @@ static int __init cma_activate_area(struct cma *cma)
 	unsigned i = cma->count >> pageblock_order;
 	struct zone *zone;
 
-	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	pr_debug("%s()\n", __func__);
 
+	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!cma->bitmap)
 		return -ENOMEM;
 
@@ -234,7 +235,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 
 	/* Sanity checks */
 	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
-		pr_err("Not enough slots for CMA reserved regions!\n");
+		pr_err("%s(): Not enough slots for CMA reserved regions!\n",
+			__func__);
 		return -ENOSPC;
 	}
 
@@ -274,14 +276,15 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 	*res_cma = cma;
 	cma_area_count++;
 
-	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
-		(unsigned long)base);
+	pr_info("%s(): reserved %ld MiB at %08lx\n",
+		__func__, (unsigned long)size / SZ_1M, (unsigned long)base);
 
 	/* Architecture specific contiguous memory fixup. */
 	dma_contiguous_early_fixup(base, size);
 	return 0;
 err:
-	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
+	pr_err("%s(): failed to reserve %ld MiB\n",
+		__func__, (unsigned long)size / SZ_1M);
 	return ret;
 }
 
-- 
1.7.9.5

