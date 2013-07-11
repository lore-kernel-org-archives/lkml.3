Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3GKO1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:27:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab3GKO1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 98/98] iommu/amd: Only unmap large pages from the first pte
Date: Thu, 11 Jul 2013 15:25:08 +0100
Message-Id: <1373552708-15235-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 60d0ca3cfd199b6612bbbbf4999a3470dad38bb1 upstream.

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
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/amd_iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d3be586..141c69f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1309,6 +1309,10 @@ static unsigned long iommu_unmap_page(struct protection_domain *dom,
 
 			/* Large PTE found which maps this address */
 			unmap_size = PTE_PAGE_SIZE(*pte);
+
+			/* Only unmap from the first pte in the page */
+			if ((unmap_size - 1) & bus_addr)
+				break;
 			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
 				pte[i] = 0ULL;
@@ -1318,7 +1322,7 @@ static unsigned long iommu_unmap_page(struct protection_domain *dom,
 		unmapped += unmap_size;
 	}
 
-	BUG_ON(!is_power_of_2(unmapped));
+	BUG_ON(unmapped && !is_power_of_2(unmapped));
 
 	return unmapped;
 }
-- 
1.8.1.2

