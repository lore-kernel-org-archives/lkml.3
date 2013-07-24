Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3GXOHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:07:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196Ab3GXOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Williamson" <alex.williamson@redhat.com>,
        "Joerg Roedel" <joro@8bytes.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.148018747@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [33/85] iommu/amd: Only unmap large pages from the first pte
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1076,6 +1076,10 @@ static unsigned long iommu_unmap_page(st
 
 			/* Large PTE found which maps this address */
 			unmap_size = PTE_PAGE_SIZE(*pte);
+
+			/* Only unmap from the first pte in the page */
+			if ((unmap_size - 1) & bus_addr)
+				break;
 			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
 				pte[i] = 0ULL;
@@ -1085,7 +1089,7 @@ static unsigned long iommu_unmap_page(st
 		unmapped += unmap_size;
 	}
 
-	BUG_ON(!is_power_of_2(unmapped));
+	BUG_ON(unmapped && !is_power_of_2(unmapped));
 
 	return unmapped;
 }

