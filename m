Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3EXROv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab3EXROt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:14:49 -0400
Subject: [PATCH] iommu: Split iommu_unmaps
To: iommu@lists.linux-foundation.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: joro@8bytes.org, linux-kernel@vger.kernel.org
Date: Fri, 24 May 2013 11:14:45 -0600
Message-ID: <20130524171401.14099.78694.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_map splits requests into pages that the iommu driver reports
that it can handle.  The iommu_unmap path does not do the same.  This
can cause problems not only from callers that might expect the same
behavior as the map path, but even from the failure path of iommu_map,
should it fail at a point where it has mapped and needs to unwind a
set of pages that the iommu driver cannot handle directly.  amd_iommu,
for example, will BUG_ON if asked to unmap a non power of 2 size.

Fix this by extracting and generalizing the sizing code from the
iommu_map path and use it for both map and unmap.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommu.c |   63 +++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d8f98b1..4b0b56b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -754,6 +754,38 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
 
+static size_t iommu_pgsize(struct iommu_domain *domain,
+			   unsigned long addr_merge, size_t size)
+{
+	unsigned int pgsize_idx;
+	size_t pgsize;
+
+	/* Max page size that still fits into 'size' */
+	pgsize_idx = __fls(size);
+
+	/* need to consider alignment requirements ? */
+	if (likely(addr_merge)) {
+		/* Max page size allowed by address */
+		unsigned int align_pgsize_idx = __ffs(addr_merge);
+		pgsize_idx = min(pgsize_idx, align_pgsize_idx);
+	}
+
+	/* build a mask of acceptable page sizes */
+	pgsize = (1UL << (pgsize_idx + 1)) - 1;
+
+	/* throw away page sizes not supported by the hardware */
+	pgsize &= domain->ops->pgsize_bitmap;
+
+	/* make sure we're still sane */
+	BUG_ON(!pgsize);
+
+	/* pick the biggest page */
+	pgsize_idx = __fls(pgsize);
+	pgsize = 1UL << pgsize_idx;
+
+	return pgsize;
+}
+
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot)
 {
@@ -785,32 +817,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 				(unsigned long)paddr, (unsigned long)size);
 
 	while (size) {
-		unsigned long pgsize, addr_merge = iova | paddr;
-		unsigned int pgsize_idx;
-
-		/* Max page size that still fits into 'size' */
-		pgsize_idx = __fls(size);
-
-		/* need to consider alignment requirements ? */
-		if (likely(addr_merge)) {
-			/* Max page size allowed by both iova and paddr */
-			unsigned int align_pgsize_idx = __ffs(addr_merge);
-
-			pgsize_idx = min(pgsize_idx, align_pgsize_idx);
-		}
-
-		/* build a mask of acceptable page sizes */
-		pgsize = (1UL << (pgsize_idx + 1)) - 1;
-
-		/* throw away page sizes not supported by the hardware */
-		pgsize &= domain->ops->pgsize_bitmap;
-
-		/* make sure we're still sane */
-		BUG_ON(!pgsize);
-
-		/* pick the biggest page */
-		pgsize_idx = __fls(pgsize);
-		pgsize = 1UL << pgsize_idx;
+		size_t pgsize = iommu_pgsize(domain, iova | paddr, size);
 
 		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize %lu\n", iova,
 					(unsigned long)paddr, pgsize);
@@ -863,9 +870,9 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 	 * or we hit an area that isn't mapped.
 	 */
 	while (unmapped < size) {
-		size_t left = size - unmapped;
+		size_t pgsize = iommu_pgsize(domain, iova, size - unmapped);
 
-		unmapped_page = domain->ops->unmap(domain, iova, left);
+		unmapped_page = domain->ops->unmap(domain, iova, pgsize);
 		if (!unmapped_page)
 			break;
 

