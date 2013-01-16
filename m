Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3APQBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab3APQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 060/222] KVM: Fix user memslot overlap check
Date: Wed, 16 Jan 2013 13:54:20 -0200
Message-Id: <1358351822-7675-61-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 5419369ed6bd4cf711fdda5e52a5999b940413f5 upstream.

Prior to memory slot sorting this loop compared all of the user memory
slots for overlap with new entries.  With memory slot sorting, we're
just checking some number of entries in the array that may or may not
be user slots.  Instead, walk all the slots with kvm_for_each_memslot,
which has the added benefit of terminating early when we hit the first
empty slot, and skip comparison to private slots.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 virt/kvm/kvm_main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 44ee712..7d9d969 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -689,8 +689,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
-	unsigned long i;
-	struct kvm_memory_slot *memslot;
+	struct kvm_memory_slot *memslot, *slot;
 	struct kvm_memory_slot old, new;
 	struct kvm_memslots *slots, *old_memslots;
 
@@ -737,13 +736,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	/* Check for overlaps */
 	r = -EEXIST;
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *s = &kvm->memslots->memslots[i];
-
-		if (s == memslot || !s->npages)
+	kvm_for_each_memslot(slot, kvm->memslots) {
+		if (slot->id >= KVM_MEMORY_SLOTS || slot == memslot)
 			continue;
-		if (!((base_gfn + npages <= s->base_gfn) ||
-		      (base_gfn >= s->base_gfn + s->npages)))
+		if (!((base_gfn + npages <= slot->base_gfn) ||
+		      (base_gfn >= slot->base_gfn + slot->npages)))
 			goto out_free;
 	}
 
-- 
1.7.9.5

