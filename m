Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3FWT3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:29:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44653 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750849Ab3FWT3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:29:05 -0400
Message-ID: <1372015744.3137.74.camel@joe-AO722>
Subject: [PATCH V2] iommu: Use %pa and %zx instead of casting
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 23 Jun 2013 12:29:04 -0700
In-Reply-To: <CAMuHMdWb4WK9ZuJ-vwdywgDSSbZTnnS1emF02VzrUgrSt5VKsg@mail.gmail.com>
References: <20130621153331.2881.35589.stgit@bling.home>
	 <20130623114930.GA2557@8bytes.org> <1372009427.3137.54.camel@joe-AO722>
	 <CAMuHMdWb4WK9ZuJ-vwdywgDSSbZTnnS1emF02VzrUgrSt5VKsg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk supports using %pa for phys_addr_t and
%zx for size_t so use those instead of %lx and
casts to unsigned long.

Other miscellaneous changes around this:

Always use 0x%zx for size instead of one use of decimal.
Coalesce format and align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
> While we're at it, paddr is phys_addr_t (which can be 32-bit or 64-bit),
> so it should be cast to unsigned long long (instead of unsigned long),
> and printed using %llx (instead of %lx).

Sounds good to me, except using %pa instead is better still.

 drivers/iommu/iommu.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ab1fa19..fbe9ca7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -807,20 +807,18 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	 * size of the smallest page supported by the hardware
 	 */
 	if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
-		pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
-			"0x%x\n", iova, (unsigned long)paddr,
-			(unsigned long)size, min_pagesz);
+		pr_err("unaligned: iova 0x%lx pa 0x%pa size 0x%zx min_pagesz 0x%x\n",
+		       iova, &paddr, size, min_pagesz);
 		return -EINVAL;
 	}
 
-	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
-				(unsigned long)paddr, (unsigned long)size);
+	pr_debug("map: iova 0x%lx pa 0x%pa size 0x%zx\n", iova, &paddr, size);
 
 	while (size) {
 		size_t pgsize = iommu_pgsize(domain, iova | paddr, size);
 
-		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize %lu\n", iova,
-			 (unsigned long)paddr, (unsigned long)pgsize);
+		pr_debug("mapping: iova 0x%lx pa 0x%pa pgsize 0x%zx\n",
+			 iova, &paddr, pgsize);
 
 		ret = domain->ops->map(domain, iova, paddr, pgsize, prot);
 		if (ret)
@@ -857,13 +855,12 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 	 * by the hardware
 	 */
 	if (!IS_ALIGNED(iova | size, min_pagesz)) {
-		pr_err("unaligned: iova 0x%lx size 0x%lx min_pagesz 0x%x\n",
-					iova, (unsigned long)size, min_pagesz);
+		pr_err("unaligned: iova 0x%lx size 0x%zx min_pagesz 0x%x\n",
+		       iova, size, min_pagesz);
 		return -EINVAL;
 	}
 
-	pr_debug("unmap this: iova 0x%lx size 0x%lx\n", iova,
-							(unsigned long)size);
+	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
 
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
@@ -876,8 +873,8 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 		if (!unmapped_page)
 			break;
 
-		pr_debug("unmapped: iova 0x%lx size %lx\n", iova,
-					(unsigned long)unmapped_page);
+		pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
+			 iova, unmapped_page);
 
 		iova += unmapped_page;
 		unmapped += unmapped_page;


