Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaBJToU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:44:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaBJToR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:44:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 082/124] intel-iommu: fix off-by-one in pagetable freeing
Date: Mon, 10 Feb 2014 11:40:22 -0800
Message-Id: <1392061264-28124-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 08336fd218e087cc4fcc458e6b6dcafe8702b098 upstream.

dma_pte_free_level() has an off-by-one error when checking whether a pte
is completely covered by a range.  Take for example the case of
attempting to free pfn 0x0 - 0x1ff, ie.  512 entries covering the first
2M superpage.

The level_size() is 0x200 and we test:

  static void dma_pte_free_level(...
	...

	if (!(0 > 0 || 0x1ff < 0 + 0x200)) {
		...
	}

Clearly the 2nd test is true, which means we fail to take the branch to
clear and free the pagetable entry.  As a result, we're leaking
pagetables and failing to install new pages over the range.

This was found with a PCI device assigned to a QEMU guest using vfio-pci
without a VGA device present.  The first 1M of guest address space is
mapped with various combinations of 4K pages, but eventually the range
is entirely freed and replaced with a 2M contiguous mapping.
intel-iommu errors out with something like:

  ERROR: DMA PTE for vPFN 0x0 already set (to 5c2b8003 not 849c00083)

In this case 5c2b8003 is the pointer to the previous leaf page that was
neither freed nor cleared and 849c00083 is the superpage entry that
we're trying to replace it with.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/intel-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 72f2ee9..94a5c9e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -910,7 +910,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
 
 		/* If range covers entire pagetable, free it */
 		if (!(start_pfn > level_pfn ||
-		      last_pfn < level_pfn + level_size(level))) {
+		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
 			free_pgtable_page(level_pte);
-- 
1.8.3.2

