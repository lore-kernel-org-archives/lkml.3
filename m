Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3APQGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab3APQGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 136/222] intel-iommu: Free old page tables before creating superpage
Date: Wed, 16 Jan 2013 13:55:36 -0200
Message-Id: <1358351822-7675-137-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Woodhouse, David" <david.woodhouse@intel.com>

commit 6491d4d02893d9787ba67279595990217177b351 upstream.

The dma_pte_free_pagetable() function will only free a page table page
if it is asked to free the *entire* 2MiB range that it covers. So if a
page table page was used for one or more small mappings, it's likely to
end up still present in the page tables... but with no valid PTEs.

This was fine when we'd only be repopulating it with 4KiB PTEs anyway
but the same virtual address range can end up being reused for a
*large-page* mapping. And in that case were were trying to insert the
large page into the second-level page table, and getting a complaint
from the sanity check in __domain_mapping() because there was already a
corresponding entry. This was *relatively* harmless; it led to a memory
leak of the old page table page, but no other ill-effects.

Fix it by calling dma_pte_clear_range (hopefully redundant) and
dma_pte_free_pagetable() before setting up the new large page.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: Ravi Murty <Ravi.Murty@intel.com>
Tested-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/iommu/intel-iommu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 3e1bdc1..f3e77a5 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1827,10 +1827,17 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			if (!pte)
 				return -ENOMEM;
 			/* It is large page*/
-			if (largepage_lvl > 1)
+			if (largepage_lvl > 1) {
 				pteval |= DMA_PTE_LARGE_PAGE;
-			else
+				/* Ensure that old small page tables are removed to make room
+				   for superpage, if they exist. */
+				dma_pte_clear_range(domain, iov_pfn,
+						    iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+				dma_pte_free_pagetable(domain, iov_pfn,
+						       iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+			} else {
 				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
+			}
 
 		}
 		/* We don't need lock here, nobody else
-- 
1.7.9.5

