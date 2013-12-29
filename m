Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3L2DA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:00:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54998 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab3L2CJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Gleb Natapov" <gleb@redhat.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.793664959@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 175/185] KVM: Fix iommu map/unmap to handle memory
 slot moves
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -788,6 +788,8 @@ skip_lpage:
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
+		/* slot was deleted or moved, clear iommu mapping */
+		kvm_iommu_unmap_pages(kvm, &old);
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
 		 *
@@ -803,14 +805,6 @@ skip_lpage:
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
 	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!slots)
@@ -820,6 +814,13 @@ skip_lpage:
 		slots->nmemslots = mem->slot + 1;
 	slots->generation++;
 
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
@@ -847,6 +848,8 @@ skip_lpage:
 
 	return 0;
 
+out_slots:
+	kfree(slots);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:

