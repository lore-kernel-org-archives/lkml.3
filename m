Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935809Ab3IEMWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:22:06 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49955 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3IEMWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:22:04 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [PATCH v2] KVM: mmu: allow page tables to be in read-only slots
Date: Thu,  5 Sep 2013 14:21:53 +0200
Message-Id: <1378383714-9723-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page tables in a read-only memory slot will currently cause a triple
fault when running with shadow paging, because the page walker uses
gfn_to_hva and it fails on such a slot.

TianoCore uses such a page table.  The idea is that, on real hardware,
the firmware can already run in 64-bit flat mode when setting up the
memory controller.  Real hardware seems to be fine with that as long as
the accessed/dirty bits are set.  Thus, this patch saves whether the
slot is readonly, and later checks it when updating the accessed and
dirty bits.

Note that this scenario is not supported by NPT at all, as explained by
comments in the code.

Cc: stable@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h | 20 +++++++++++++++++++-
 include/linux/kvm_host.h   |  1 +
 virt/kvm/kvm_main.c        | 14 +++++++++-----
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 0433301..aa18aca 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -99,6 +99,7 @@ struct guest_walker {
 	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
+	bool pte_writable[PT_MAX_FULL_LEVELS];
 	unsigned pt_access;
 	unsigned pte_access;
 	gfn_t gfn;
@@ -235,6 +236,22 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 		if (pte == orig_pte)
 			continue;
 
+		/*
+		 * If the slot is read-only, simply do not process the accessed
+		 * and dirty bits.  This is the correct thing to do if the slot
+		 * is ROM, and page tables in read-as-ROM/write-as-MMIO slots
+		 * are only supported if the accessed and dirty bits are already
+		 * set in the ROM (so that MMIO writes are never needed).
+		 *
+		 * Note that NPT does not allow this at all and faults, since
+		 * it always wants nested page table entries for the guest
+		 * page tables to be writable.  And EPT works but will simply
+		 * overwrite the read-only memory to set the accessed and dirty
+		 * bits.
+		 */
+		if (unlikely(!walker->pte_writable[level - 1]))
+			continue;
+
 		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
 		if (ret)
 			return ret;
@@ -309,7 +326,8 @@ retry_walk:
 			goto error;
 		real_gfn = gpa_to_gfn(real_gfn);
 
-		host_addr = gfn_to_hva(vcpu->kvm, real_gfn);
+		host_addr = gfn_to_hva_read(vcpu->kvm, real_gfn,
+					    &walker->pte_writable[walker->level - 1]);
 		if (unlikely(kvm_is_error_hva(host_addr)))
 			goto error;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ca645a0..22f9cdf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -533,6 +533,7 @@ int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
+unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f7e4334..418d037 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1078,11 +1078,15 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
 /*
- * The hva returned by this function is only allowed to be read.
- * It should pair with kvm_read_hva() or kvm_read_hva_atomic().
+ * If writable is set to false, the hva returned by this function is only
+ * allowed to be read.
  */
-static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
+unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn, bool *writable)
 {
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	if (writable)
+		*writable = !memslot_is_readonly(slot);
+
 	return __gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL, false);
 }
 
@@ -1450,7 +1454,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 	int r;
 	unsigned long addr;
 
-	addr = gfn_to_hva_read(kvm, gfn);
+	addr = gfn_to_hva_read(kvm, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = kvm_read_hva(data, (void __user *)addr + offset, len);
@@ -1488,7 +1492,7 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int offset = offset_in_page(gpa);
 
-	addr = gfn_to_hva_read(kvm, gfn);
+	addr = gfn_to_hva_read(kvm, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	pagefault_disable();
-- 
1.8.3.1

