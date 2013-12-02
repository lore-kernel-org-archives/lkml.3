Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3LBTJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:09:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LBTH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.4 56/60] KVM: Fix iommu map/unmap to handle memory slot moves
Date: Mon,  2 Dec 2013 11:06:37 -0800
Message-Id: <20131202190342.594855168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -790,6 +790,8 @@ int __kvm_set_memory_region(struct kvm *
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
+		/* slot was deleted or moved, clear iommu mapping */
+		kvm_iommu_unmap_pages(kvm, &old);
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
 		 *
@@ -805,20 +807,19 @@ int __kvm_set_memory_region(struct kvm *
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
@@ -845,6 +846,8 @@ int __kvm_set_memory_region(struct kvm *
 
 	return 0;
 
+out_slots:
+	kfree(slots);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:


