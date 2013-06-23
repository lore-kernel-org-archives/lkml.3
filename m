Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3FWRny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 13:43:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41283 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751764Ab3FWRnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 13:43:50 -0400
Message-ID: <1372009427.3137.54.camel@joe-AO722>
Subject: [PATCH] iommu: Use %zx instead %lx and cast to unsigned long
From: Joe Perches <joe@perches.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Sun, 23 Jun 2013 10:43:47 -0700
In-Reply-To: <20130623114930.GA2557@8bytes.org>
References: <20130621153331.2881.35589.stgit@bling.home>
	 <20130623114930.GA2557@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printf support size_t hex type %zx so use that
instead of %lx and a cast to unsigned long.

Other miscellaneous changes around this:

Always use 0x%zx for size instead of one use of decimal.
Coalesce format and align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/iommu/iommu.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ab1fa19..7aa98c8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -807,20 +807,19 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	 * size of the smallest page supported by the hardware
 	 */
 	if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
-		pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
-			"0x%x\n", iova, (unsigned long)paddr,
-			(unsigned long)size, min_pagesz);
+		pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%zx min_pagesz 0x%x\n",
+		       iova, (unsigned long)paddr, size, min_pagesz);
 		return -EINVAL;
 	}
 
-	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
-				(unsigned long)paddr, (unsigned long)size);
+	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%zx\n",
+		 iova, (unsigned long)paddr, size);
 
 	while (size) {
 		size_t pgsize = iommu_pgsize(domain, iova | paddr, size);
 
-		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize %lu\n", iova,
-			 (unsigned long)paddr, (unsigned long)pgsize);
+		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize 0x%zx\n",
+			 iova, (unsigned long)paddr, pgsize);
 
 		ret = domain->ops->map(domain, iova, paddr, pgsize, prot);
 		if (ret)
@@ -857,13 +856,12 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
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
@@ -876,8 +874,8 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 		if (!unmapped_page)
 			break;
 
-		pr_debug("unmapped: iova 0x%lx size %lx\n", iova,
-					(unsigned long)unmapped_page);
+		pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
+			 iova, unmapped_page);
 
 		iova += unmapped_page;
 		unmapped += unmapped_page;


