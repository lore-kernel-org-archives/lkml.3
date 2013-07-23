Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156Ab3GWWd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:33:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934870Ab3GWW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 088/103] iommu/amd: Only unmap large pages from the first pte
Date: Tue, 23 Jul 2013 15:26:39 -0700
Message-Id: <20130723220430.812288894@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1484,6 +1484,10 @@ static unsigned long iommu_unmap_page(st
 
 			/* Large PTE found which maps this address */
 			unmap_size = PTE_PAGE_SIZE(*pte);
+
+			/* Only unmap from the first pte in the page */
+			if ((unmap_size - 1) & bus_addr)
+				break;
 			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
 				pte[i] = 0ULL;
@@ -1493,7 +1497,7 @@ static unsigned long iommu_unmap_page(st
 		unmapped += unmap_size;
 	}
 
-	BUG_ON(!is_power_of_2(unmapped));
+	BUG_ON(unmapped && !is_power_of_2(unmapped));
 
 	return unmapped;
 }


