Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3JUJ1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:27:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39409 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab3JUIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Williamson" <alex.williamson@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Joerg Roedel" <joro@8bytes.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.130866562@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 025/149] intel-iommu: Fix leaks in pagetable freeing
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 3269ee0bd6686baf86630300d528500ac5b516d7 upstream.

At best the current code only seems to free the leaf pagetables and
the root.  If you're unlucky enough to have a large gap (like any
QEMU guest with more than 3G of memory), only the first chunk of leaf
pagetables are freed (plus the root).  This is a massive memory leak.
This patch re-writes the pagetable freeing function to use a
recursive algorithm and manages to not only free all the pagetables,
but does it without any apparent performance loss versus the current
broken version.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c | 72 ++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -861,56 +861,54 @@ static int dma_pte_clear_range(struct dm
 	return order;
 }
 
+static void dma_pte_free_level(struct dmar_domain *domain, int level,
+			       struct dma_pte *pte, unsigned long pfn,
+			       unsigned long start_pfn, unsigned long last_pfn)
+{
+	pfn = max(start_pfn, pfn);
+	pte = &pte[pfn_level_offset(pfn, level)];
+
+	do {
+		unsigned long level_pfn;
+		struct dma_pte *level_pte;
+
+		if (!dma_pte_present(pte) || dma_pte_superpage(pte))
+			goto next;
+
+		level_pfn = pfn & level_mask(level - 1);
+		level_pte = phys_to_virt(dma_pte_addr(pte));
+
+		if (level > 2)
+			dma_pte_free_level(domain, level - 1, level_pte,
+					   level_pfn, start_pfn, last_pfn);
+
+		/* If range covers entire pagetable, free it */
+		if (!(start_pfn > level_pfn ||
+		      last_pfn < level_pfn + level_size(level))) {
+			dma_clear_pte(pte);
+			domain_flush_cache(domain, pte, sizeof(*pte));
+			free_pgtable_page(level_pte);
+		}
+next:
+		pfn += level_size(level);
+	} while (!first_pte_in_page(++pte) && pfn <= last_pfn);
+}
+
 /* free page table pages. last level pte should already be cleared */
 static void dma_pte_free_pagetable(struct dmar_domain *domain,
 				   unsigned long start_pfn,
 				   unsigned long last_pfn)
 {
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
-	struct dma_pte *first_pte, *pte;
-	int total = agaw_to_level(domain->agaw);
-	int level;
-	unsigned long tmp;
-	int large_page = 2;
 
 	BUG_ON(addr_width < BITS_PER_LONG && start_pfn >> addr_width);
 	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
 	BUG_ON(start_pfn > last_pfn);
 
 	/* We don't need lock here; nobody else touches the iova range */
-	level = 2;
-	while (level <= total) {
-		tmp = align_to_level(start_pfn, level);
-
-		/* If we can't even clear one PTE at this level, we're done */
-		if (tmp + level_size(level) - 1 > last_pfn)
-			return;
-
-		do {
-			large_page = level;
-			first_pte = pte = dma_pfn_level_pte(domain, tmp, level, &large_page);
-			if (large_page > level)
-				level = large_page + 1;
-			if (!pte) {
-				tmp = align_to_level(tmp + 1, level + 1);
-				continue;
-			}
-			do {
-				if (dma_pte_present(pte)) {
-					free_pgtable_page(phys_to_virt(dma_pte_addr(pte)));
-					dma_clear_pte(pte);
-				}
-				pte++;
-				tmp += level_size(level);
-			} while (!first_pte_in_page(pte) &&
-				 tmp + level_size(level) - 1 <= last_pfn);
-
-			domain_flush_cache(domain, first_pte,
-					   (void *)pte - (void *)first_pte);
-			
-		} while (tmp && tmp + level_size(level) - 1 <= last_pfn);
-		level++;
-	}
+	dma_pte_free_level(domain, agaw_to_level(domain->agaw),
+			   domain->pgd, 0, start_pfn, last_pfn);
+
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
 		free_pgtable_page(domain->pgd);

