Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547Ab3JPKTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:19:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13801 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab3JPKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:19:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 03:19:37 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ARM: dma-mapping: Drop GFP_COMP for DMA memory allocations
Date: Wed, 16 Oct 2013 13:19:13 +0300
Message-ID: <1381918756-10389-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm_iommu_alloc_attrs wants to split pages after allocation in order
to reduce the memory footprint. This does not work well with GFP_COMP
pages, so drop this flag before allocation.

ref: ea2e7057c0234cfb8b09467d8f137760d371fc72:

    ARM: 7172/1: dma: Drop GFP_COMP for DMA memory allocations

    dma_alloc_coherent wants to split pages after allocation in order to
    reduce the memory footprint. This does not work well with GFP_COMP
    pages, so drop this flag before allocation.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index f5e1a84..955dd3e 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1321,6 +1321,13 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	struct page **pages;
 	void *addr = NULL;
 
+	/* Following is a work-around (a.k.a. hack) to prevent pages
+	 * with __GFP_COMP being passed to split_page() which cannot
+	 * handle them.  The real problem is that this flag probably
+	 * should be 0 on ARM as it is not supported on this
+	 * platform--see CONFIG_HUGETLB_PAGE. */
+	gfp &= ~(__GFP_COMP);
+
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-- 
1.8.1.5

