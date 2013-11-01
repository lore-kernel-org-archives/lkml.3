Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3KAQOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:14:17 -0400
Received: from legacy.ddn.com ([64.47.133.206]:24036 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3KAQOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:14:16 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 12:14:16 EDT
Date: Fri, 1 Nov 2013 10:08:55 -0600
From: Greg Edwards <gedwards@ddn.com>
To: kvm@vger.kernel.org
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: IOMMU: hva align mapping page size
Message-ID: <20131101160855.GB5052@psuche>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When determining the page size we could use to map with the IOMMU, the
page size should be aligned with the hva, not the gfn.  The gfn may not
reflect the real alignment within the hugetlbfs file.

Most of the time, this works fine.  However, if the hugetlbfs file is
backed by non-contiguous huge pages, a multi-huge page memslot starts at
an unaligned offset within the hugetlbfs file, and the gfn is aligned
with respect to the huge page size, kvm_host_page_size() will return the
huge page size and we will use that to map with the IOMMU.

When we later unpin that same memslot, the IOMMU returns the unmap size
as the huge page size, and we happily unpin that many pfns in
monotonically increasing order, not realizing we are spanning
non-contiguous huge pages and partially unpin the wrong huge page.

Instead, ensure the IOMMU mapping page size is aligned with the hva
corresponding to the gfn, which does reflect the alignment within the
hugetlbfs file.

Signed-off-by: Greg Edwards <gedwards@ddn.com>
Cc: stable@vger.kernel.org
---
This resolves the bug previously reported (and misdiagnosed) here:

 http://www.spinics.net/lists/kvm/msg97599.html

 virt/kvm/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 72a130b..0e2ff32 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -99,8 +99,8 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		while ((gfn + (page_size >> PAGE_SHIFT)) > end_gfn)
 			page_size >>= 1;
 
-		/* Make sure gfn is aligned to the page size we want to map */
-		while ((gfn << PAGE_SHIFT) & (page_size - 1))
+		/* Make sure hva is aligned to the page size we want to map */
+		while (__gfn_to_hva_memslot(slot, gfn) & (page_size - 1))
 			page_size >>= 1;
 
 		/*
-- 
1.8.3.2

