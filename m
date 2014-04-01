Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaDAP1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:27:09 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58295 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaDAP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:27:00 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 4/6] KVM: emulate: introduce memory_prepare callback to speed up memory access
Date: Tue,  1 Apr 2014 17:26:44 +0200
Message-Id: <1396366006-22227-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulating a RMW instruction currently walks the page tables
twice.  To avoid this, store the virtual address in the host
and access it directly.

In fact, it turns out that the optimizations we can do
actually benefit all memory accesses.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 26 +++++++++++++++
 arch/x86/kvm/x86.c                 | 67 ++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h           |  5 +++
 virt/kvm/kvm_main.c                |  5 ---
 4 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index f7b1e45eb753..4a580be2553e 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -167,6 +167,32 @@ struct x86_emulate_ops {
 				const void *new,
 				unsigned int bytes,
 				struct x86_exception *fault);
+
+	/*
+	 * memory_prepare: Prepare userspace access fastpath.
+	 *   @addr:     [IN ] Linear address to access.
+	 *   @bytes:    [IN ] Number of bytes to access.
+	 *   @write:    [IN ] True if *p_hva will be written to.
+	 *   @p_opaque: [OUT] Value passed back to memory_finish.
+	 *   @p_hva:    [OUT] Host virtual address for __copy_from/to_user.
+	 */
+	int (*memory_prepare)(struct x86_emulate_ctxt *ctxt,
+			      unsigned long addr,
+			      unsigned int bytes,
+			      struct x86_exception *exception,
+			      bool write,
+			      void **p_opaque,
+			      unsigned long *p_hva);
+
+	/*
+	 * memory_finish: Complete userspace access fastpath.
+	 *   @opaque: [OUT] Value passed back from memory_prepare.
+	 *   @hva:    [OUT] Host virtual address computed in memory_prepare.
+	 */
+	void (*memory_finish)(struct x86_emulate_ctxt *ctxt,
+			      void *p_opaque,
+			      unsigned long p_hva);
+
 	void (*invlpg)(struct x86_emulate_ctxt *ctxt, ulong addr);
 
 	int (*pio_in_emulated)(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e70a0e3227b1..64d0f171996b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4273,6 +4273,71 @@ static const struct read_write_emulator_ops write_emultor = {
 	.write = true,
 };
 
+static int emulator_memory_prepare(struct x86_emulate_ctxt *ctxt,
+				   unsigned long addr,
+				   unsigned int bytes,
+				   struct x86_exception *exception,
+				   bool write,
+				   void **p_opaque,
+				   unsigned long *p_hva)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	struct kvm_memory_slot *memslot;
+	int ret;
+	gpa_t gpa;
+	gfn_t gfn;
+	unsigned long hva;
+	
+	if (unlikely(((addr + bytes - 1) ^ addr) & PAGE_MASK))
+		goto no_hva;
+
+	ret = vcpu_mmio_gva_to_gpa(vcpu, addr, &gpa, exception, true);
+	if (ret != 0) {
+		if (ret < 0)
+			return X86EMUL_PROPAGATE_FAULT;
+		goto no_hva;
+	}
+
+	/* A (heavily) simplified version of kvm_gfn_to_hva_cache_init.  */
+	gfn = gpa >> PAGE_SHIFT;
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot)
+		goto no_hva;
+
+	if (write) {
+		if (memslot_is_readonly(memslot))
+			goto no_hva;
+
+		*p_opaque = memslot->dirty_bitmap ? memslot : NULL;
+	}
+
+	hva = __gfn_to_hva_memslot(memslot, gfn);
+	if (kvm_is_error_hva(hva))
+		goto no_hva;
+
+	*p_hva = hva + offset_in_page(gpa);
+	return X86EMUL_CONTINUE;
+
+no_hva:
+	*p_hva = KVM_HVA_ERR_BAD;
+	return X86EMUL_CONTINUE;
+}
+
+static void emulator_memory_finish(struct x86_emulate_ctxt *ctxt,
+				   void *opaque,
+				   unsigned long hva)
+{
+	struct kvm_memory_slot *memslot;
+	gfn_t gfn;
+
+	if (!opaque)
+		return;
+
+	memslot = opaque;
+	gfn = hva_to_gfn_memslot(hva, memslot);
+	mark_page_dirty_in_slot(memslot, gfn);
+}
+
 static int emulator_read_write_onepage(unsigned long addr, void *val,
 				       unsigned int bytes,
 				       struct x86_exception *exception,
@@ -4816,6 +4881,8 @@ static const struct x86_emulate_ops emulate_ops = {
 	.read_std            = kvm_read_guest_virt_system,
 	.write_std           = kvm_write_guest_virt_system,
 	.fetch               = kvm_fetch_guest_virt,
+	.memory_prepare      = emulator_memory_prepare,
+	.memory_finish       = emulator_memory_finish,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 56289b487ddd..d4f213621c40 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -841,6 +841,11 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 	return NULL;
 }
 
+static inline bool memslot_is_readonly(struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_READONLY;
+}
+
 static inline struct kvm_memory_slot *
 __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 98833e21d580..edfc901c012f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1026,11 +1026,6 @@ out:
 	return size;
 }
 
-static bool memslot_is_readonly(struct kvm_memory_slot *slot)
-{
-	return slot->flags & KVM_MEM_READONLY;
-}
-
 static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				       gfn_t *nr_pages, bool write)
 {
-- 
1.8.3.1


