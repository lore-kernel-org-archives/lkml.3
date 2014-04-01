Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaDAP1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:27:11 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:60091 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaDAP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:26:58 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 3/6] KVM: export mark_page_dirty_in_slot
Date: Tue,  1 Apr 2014 17:26:43 +0200
Message-Id: <1396366006-22227-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 12 +++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ba3180a5e6d3..56289b487ddd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -582,6 +582,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bf2fa29c8beb..98833e21d580 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -99,8 +99,6 @@ static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *new, u64 last_generation);
 
 static void kvm_release_pfn_dirty(pfn_t pfn);
-static void mark_page_dirty_in_slot(struct kvm *kvm,
-				    struct kvm_memory_slot *memslot, gfn_t gfn);
 
 bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -1583,7 +1581,7 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	r = __copy_to_user((void __user *)ghc->hva, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(ghc->memslot, ghc->gpa >> PAGE_SHIFT);
 
 	return 0;
 }
@@ -1641,9 +1639,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm *kvm,
-				    struct kvm_memory_slot *memslot,
-				    gfn_t gfn)
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
+			      gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
@@ -1651,13 +1648,14 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
+EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
-	mark_page_dirty_in_slot(kvm, memslot, gfn);
+	mark_page_dirty_in_slot(memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
 
-- 
1.8.3.1


