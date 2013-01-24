Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3AXWEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:04:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab3AXWEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:04:07 -0500
Subject: [PATCH 1/2] kvm: Force IOMMU remapping on memory slot read-only
 flag changes
To: gleb@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Date: Thu, 24 Jan 2013 15:04:03 -0700
Message-ID: <20130124220403.11061.61738.stgit@bling.home>
In-Reply-To: <20130124220027.11061.76400.stgit@bling.home>
References: <20130124220027.11061.76400.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory slot flags can be altered without changing other parameters of
the slot.  The read-only attribute is the only one the IOMMU cares
about, so generate an un-map, re-map when this occurs.  This also
avoid unnecessarily re-mapping the slot when no IOMMU visible changes
are made.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 virt/kvm/kvm_main.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5e709eb..3fec2cd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -731,6 +731,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
 	struct kvm_memslots *slots = NULL, *old_memslots;
+	bool old_iommu_mapped;
 
 	r = check_memory_region_flags(mem);
 	if (r)
@@ -772,6 +773,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.npages = npages;
 	new.flags = mem->flags;
 
+	old_iommu_mapped = old.npages;
+
 	/*
 	 * Disallow changing a memory slot's size or changing anything about
 	 * zero sized slots that doesn't involve making them non-zero.
@@ -835,6 +838,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 		/* slot was deleted or moved, clear iommu mapping */
 		kvm_iommu_unmap_pages(kvm, &old);
+		old_iommu_mapped = false;
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
 		 *
@@ -863,11 +867,27 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			goto out_free;
 	}
 
-	/* map new memory slot into the iommu */
+	/*
+	 * IOMMU mapping:  New slots need to be mapped.  Old slots need to be
+	 * un-mapped and re-mapped if their base changes or if flags that the
+	 * iommu cares about change (read-only).  Base change unmapping is
+	 * handled above with slot deletion, so we only unmap incompatible
+	 * flags here.  Anything else the iommu might care about for existing
+	 * slots (size changes, userspace addr changes) is disallowed above,
+	 * so any other attribute changes getting here can be skipped.
+	 */
 	if (npages) {
-		r = kvm_iommu_map_pages(kvm, &new);
-		if (r)
-			goto out_slots;
+		if (old_iommu_mapped &&
+		    ((new.flags ^ old.flags) & KVM_MEM_READONLY)) {
+			kvm_iommu_unmap_pages(kvm, &old);
+			old_iommu_mapped = false;
+		}
+
+		if (!old_iommu_mapped) {
+			r = kvm_iommu_map_pages(kvm, &new);
+			if (r)
+				goto out_slots;
+		}
 	}
 
 	/* actual memory is freed via old in kvm_free_physmem_slot below */

