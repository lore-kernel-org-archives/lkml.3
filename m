Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbaFINDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:03:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:44564 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758AbaFIM7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:32 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 09/25] KVM: export mark_page_dirty_in_slot
Date: Mon,  9 Jun 2014 14:58:57 +0200
Message-Id: <1402318753-23362-10-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 12 +++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 970c68197c69..5be9805b0aeb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -583,6 +583,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c86be0f983db..2f9bc20ae2a7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -99,8 +99,6 @@ static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *new, u64 last_generation);
 
 static void kvm_release_pfn_dirty(pfn_t pfn);
-static void mark_page_dirty_in_slot(struct kvm *kvm,
-				    struct kvm_memory_slot *memslot, gfn_t gfn);
 
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -1585,7 +1583,7 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	r = __copy_to_user((void __user *)ghc->hva, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(ghc->memslot, ghc->gpa >> PAGE_SHIFT);
 
 	return 0;
 }
@@ -1643,9 +1641,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
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
@@ -1653,13 +1650,14 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
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


