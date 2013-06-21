Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946025Ab3FUUd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945951Ab3FUUdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:33:24 -0400
Subject: [PATCH] iommu/amd: Only unmap large pages from the first pte
To: joro@8bytes.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Jun 2013 14:33:19 -0600
Message-ID: <20130621203242.7475.19737.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use a large mapping, the expectation is that only unmaps from
the first pte in the superpage are supported.  Unmaps from offsets
into the superpage should fail (ie. return zero sized unmap).  In the
current code, unmapping from an offset clears the size of the full
mapping starting from an offset.  For instance, if we map a 16k
physically contiguous range at IOVA 0x0 with a large page, then
attempt to unmap 4k at offset 12k, 4 ptes are cleared (12k - 28k) and
the unmap returns 16k unmapped.  This potentially incorrectly clears
valid mappings and confuses drivers like VFIO that use the unmap size
to release pinned pages.

Fix by refusing to unmap from offsets into the page.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/iommu/amd_iommu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 21d02b0..a3c3389 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1484,6 +1484,10 @@ static unsigned long iommu_unmap_page(struct protection_domain *dom,
 
 			/* Large PTE found which maps this address */
 			unmap_size = PTE_PAGE_SIZE(*pte);
+
+			/* Only unmap from the first pte in the page */
+			if ((unmap_size - 1) & bus_addr)
+				break;
 			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
 				pte[i] = 0ULL;
@@ -1493,7 +1497,7 @@ static unsigned long iommu_unmap_page(struct protection_domain *dom,
 		unmapped += unmap_size;
 	}
 
-	BUG_ON(!is_power_of_2(unmapped));
+	BUG_ON(unmapped && !is_power_of_2(unmapped));
 
 	return unmapped;
 }

