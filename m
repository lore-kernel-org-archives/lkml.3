Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3LERoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:44:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3LERiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 72/90] KVM: Fix iommu map/unmap to handle memory slot moves
Date: Thu,  5 Dec 2013 17:35:54 +0000
Message-Id: <1386264972-5399-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit e40f193f5bb022e927a57a4f5d5194e4f12ddb74 upstream.

The iommu integration into memory slots expects memory slots to be
added or removed and doesn't handle the move case.  We can unmap
slots from the iommu after we mark them invalid and map them before
installing the final memslot array.  Also re-order the kmemdup vs
map so we don't leave iommu mappings if we get ENOMEM.

Reviewed-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/kvm_main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9e97f68..1b29357 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -786,6 +786,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
+		/* slot was deleted or moved, clear iommu mapping */
+		kvm_iommu_unmap_pages(kvm, &old);
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
 		 *
@@ -801,20 +803,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_free;
 
-	/* map/unmap the pages in iommu page table */
-	if (npages) {
-		r = kvm_iommu_map_pages(kvm, &new);
-		if (r)
-			goto out_free;
-	} else
-		kvm_iommu_unmap_pages(kvm, &old);
-
 	r = -ENOMEM;
 	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
 			GFP_KERNEL);
 	if (!slots)
 		goto out_free;
 
+	/* map new memory slot into the iommu */
+	if (npages) {
+		r = kvm_iommu_map_pages(kvm, &new);
+		if (r)
+			goto out_slots;
+	}
+
 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (!npages) {
 		new.rmap = NULL;
@@ -841,6 +842,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	return 0;
 
+out_slots:
+	kfree(slots);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:
-- 
1.8.3.2

