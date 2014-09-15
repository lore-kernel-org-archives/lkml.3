Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbaIOXXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:23:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaIOWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/187] kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)
Date: Mon, 15 Sep 2014 15:06:52 -0700
Message-Id: <1410818997-9432-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 350b8bdd689cd2ab2c67c8a86a0be86cfa0751a7 upstream.

The third parameter of kvm_iommu_put_pages is wrong,
It should be 'gfn - slot->base_gfn'.

By making gfn very large, malicious guest or userspace can cause kvm to
go to this error path, and subsequently to pass a huge value as size.
Alternatively if gfn is small, then pages would be pinned but never
unpinned, causing host memory leak and local DOS.

Passing a reasonable but large value could be the most dangerous case,
because it would unpin a page that should have stayed pinned, and thus
allow the device to DMA into arbitrary memory.  However, this cannot
happen because of the condition that can trigger the error:

- out of memory (where you can't allocate even a single page)
  should not be possible for the attacker to trigger

- when exceeding the iommu's address space, guest pages after gfn
  will also exceed the iommu's address space, and inside
  kvm_iommu_put_pages() the iommu_iova_to_phys() will fail.  The
  page thus would not be unpinned at all.

Reported-by: Jack Morgenstein <jackm@mellanox.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/iommu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 0df7d4b..714b949 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -61,6 +61,14 @@ static pfn_t kvm_pin_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 	return pfn;
 }
 
+static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npages)
+{
+	unsigned long i;
+
+	for (i = 0; i < npages; ++i)
+		kvm_release_pfn_clean(pfn + i);
+}
+
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	gfn_t gfn, end_gfn;
@@ -123,6 +131,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%llx\n", pfn);
+			kvm_unpin_pages(kvm, pfn, page_size);
 			goto unmap_pages;
 		}
 
@@ -134,7 +143,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 	return 0;
 
 unmap_pages:
-	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn);
+	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn - slot->base_gfn);
 	return r;
 }
 
@@ -266,14 +275,6 @@ out_unlock:
 	return r;
 }
 
-static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npages)
-{
-	unsigned long i;
-
-	for (i = 0; i < npages; ++i)
-		kvm_release_pfn_clean(pfn + i);
-}
-
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages)
 {
-- 
1.9.1

