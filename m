Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaJXPIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:08:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbaJXPIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:08:06 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Jamie Iles <jamie.iles@oracle.com>
Subject: [PATCH 13/14] kvm: fix excessive pages un-pinning in kvm_iommu_map error path.
Date: Fri, 24 Oct 2014 17:07:24 +0200
Message-Id: <1414163245-18555-14-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

The third parameter of kvm_unpin_pages() when called from
kvm_iommu_map_pages() is wrong, it should be the number of pages to un-pin
and not the page size.

This error was facilitated with an inconsistent API: kvm_pin_pages() takes
a size, but kvn_unpin_pages() takes a number of pages, so fix the problem
by matching the two.

This was introduced by commit 350b8bd ("kvm: iommu: fix the third parameter
of kvm_iommu_put_pages (CVE-2014-3601)"), which fixes the lack of
un-pinning for pages intended to be un-pinned (i.e. memory leak) but
unfortunately potentially aggravated the number of pages we un-pin that
should have stayed pinned. As far as I understand though, the same
practical mitigations apply.

This issue was found during review of Red Hat 6.6 patches to prepare
Ksplice rebootless updates.

Thanks to Vegard for his time on a late Friday evening to help me in
understanding this code.

Fixes: 350b8bd ("kvm: iommu: fix the third parameter of... (CVE-2014-3601)")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
Reviewed-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/iommu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index e51d9f9b995f..c1e6ae989a43 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -43,13 +43,13 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
 static pfn_t kvm_pin_pages(struct kvm_memory_slot *slot, gfn_t gfn,
-			   unsigned long size)
+			   unsigned long npages)
 {
 	gfn_t end_gfn;
 	pfn_t pfn;
 
 	pfn     = gfn_to_pfn_memslot(slot, gfn);
-	end_gfn = gfn + (size >> PAGE_SHIFT);
+	end_gfn = gfn + npages;
 	gfn    += 1;
 
 	if (is_error_noslot_pfn(pfn))
@@ -119,7 +119,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.
 		 */
-		pfn = kvm_pin_pages(slot, gfn, page_size);
+		pfn = kvm_pin_pages(slot, gfn, page_size >> PAGE_SHIFT);
 		if (is_error_noslot_pfn(pfn)) {
 			gfn += 1;
 			continue;
@@ -131,7 +131,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%llx\n", pfn);
-			kvm_unpin_pages(kvm, pfn, page_size);
+			kvm_unpin_pages(kvm, pfn, page_size >> PAGE_SHIFT);
 			goto unmap_pages;
 		}
 
-- 
1.8.3.1


