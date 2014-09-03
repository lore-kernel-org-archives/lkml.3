Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaICJzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:55:46 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57301 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756008AbaICJzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 47/56] kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)
Date: Wed,  3 Sep 2014 11:27:06 +0200
Message-Id: <612e505bc034b6169d366ee11bf4686f60a765d6.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 virt/kvm/iommu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index c329c8fc57f4..dec997188dfb 100644
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
 
@@ -272,14 +281,6 @@ out_unlock:
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
2.1.0

