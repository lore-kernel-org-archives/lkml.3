Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaBEVSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:18:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:54138 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaBEUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 007/213] KVM: unmap pages from the iommu when slots are removed
Date: Wed, 5 Feb 2014 14:59:22 -0500
Message-ID: <1391630568-49251-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 32f6daad4651a748a58a3ab6da0611862175722f upstream.

We've been adding new mappings, but not destroying old mappings.
This can lead to a page leak as pages are pinned using
get_user_pages, but only unpinned with put_page if they still
exist in the memslots list on vm shutdown.  A memslot that is
destroyed while an iommu domain is enabled for the guest will
therefore result in an elevated page reference count that is
never cleared.

Additionally, without this fix, the iommu is only programmed
with the first translation for a gpa.  This can result in
peer-to-peer errors if a mapping is destroyed and replaced by a
new mapping at the same gpa as the iommu will still be pointing
to the original, pinned memory address.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[PG: minor tweak since 2.6.34 doesnt have kvm_for_each_memslot]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/kvm_host.h | 6 ++++++
 virt/kvm/iommu.c         | 8 ++++++--
 virt/kvm/kvm_main.c      | 5 +++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 94cb72cfc2c3..5072583996f9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -454,6 +454,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
@@ -468,6 +469,11 @@ static inline int kvm_iommu_map_pages(struct kvm *kvm,
 	return 0;
 }
 
+static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
+					 struct kvm_memory_slot *slot)
+{
+}
+
 static inline int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	return -ENODEV;
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 80fd3ad3b2de..ac765f648218 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -212,6 +212,11 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 	iommu_unmap_range(domain, gfn_to_gpa(base_gfn), PAGE_SIZE * npages);
 }
 
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	kvm_iommu_put_pages(kvm, slot->base_gfn, slot->npages);
+}
+
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
 	int i;
@@ -220,8 +225,7 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 	slots = rcu_dereference(kvm->memslots);
 
 	for (i = 0; i < slots->nmemslots; i++) {
-		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
-				    slots->memslots[i].npages);
+		kvm_iommu_unmap_pages(kvm, &slots->memslots[i]);
 	}
 
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b624139aea6e..3d2974fab62e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -697,12 +697,13 @@ skip_lpage:
 		goto out_free;
 
 #ifdef CONFIG_DMAR
-	/* map the pages in iommu page table */
+	/* map/unmap the pages in iommu page table */
 	if (npages) {
 		r = kvm_iommu_map_pages(kvm, &new);
 		if (r)
 			goto out_free;
-	}
+	} else
+		kvm_iommu_unmap_pages(kvm, &old);
 #endif
 
 	r = -ENOMEM;
-- 
1.8.5.2

