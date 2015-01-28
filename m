Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbbA1EWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:22:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:39763 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964887AbbA1EWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:00 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Jamie Iles <jamie.iles@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 087/177] kvm: fix excessive pages un-pinning in kvm_iommu_map error path.
Date: Wed, 28 Jan 2015 12:09:00 +0800
Message-Id: <1422418236-12852-173-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 3d32e4dbe71374a6780eaf51d719d76f9a9bf22f upstream.

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
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
Reviewed-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 virt/kvm/iommu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index defc9ba..3225903 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -43,13 +43,13 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
 static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
-			   gfn_t gfn, unsigned long size)
+			   gfn_t gfn, unsigned long npages)
 {
 	gfn_t end_gfn;
 	pfn_t pfn;
 
 	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
-	end_gfn = gfn + (size >> PAGE_SHIFT);
+	end_gfn = gfn + npages;
 	gfn    += 1;
 
 	if (is_error_pfn(pfn))
@@ -117,7 +117,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.
 		 */
-		pfn = kvm_pin_pages(kvm, slot, gfn, page_size);
+		pfn = kvm_pin_pages(kvm, slot, gfn, page_size >> PAGE_SHIFT);
 		if (is_error_pfn(pfn)) {
 			gfn += 1;
 			continue;
@@ -129,7 +129,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%llx\n", pfn);
-			kvm_unpin_pages(kvm, pfn, page_size);
+			kvm_unpin_pages(kvm, pfn, page_size >> PAGE_SHIFT);
 			goto unmap_pages;
 		}
 
-- 
1.9.1

