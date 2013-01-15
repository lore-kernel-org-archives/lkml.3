Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3AOX6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:58:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:44896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab3AOWpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:45:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 007/171] KVM: Fix user memslot overlap check
Date: Tue, 15 Jan 2013 14:42:52 -0800
Message-Id: <20130115224313.945515795@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -693,8 +693,7 @@ int __kvm_set_memory_region(struct kvm *
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
-	unsigned long i;
-	struct kvm_memory_slot *memslot;
+	struct kvm_memory_slot *memslot, *slot;
 	struct kvm_memory_slot old, new;
 	struct kvm_memslots *slots, *old_memslots;
 
@@ -741,13 +740,11 @@ int __kvm_set_memory_region(struct kvm *
 
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
 


