Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3FHDPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 23:15:47 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53217 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3FHDPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 23:15:44 -0400
Message-ID: <51B2A1D9.6060306@gmail.com>
Date: Sat, 08 Jun 2013 11:15:37 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: x86: fix missed memory synchronization when patch hypercall
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Currently, memory synchronization is missed in emulator_fix_hypercall,
please see the commit 758ccc89b83
(KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall)

This patch fixes it by introducing kvm_vcpus_hang_on_page_start() and
kvm_vcpus_hang_on_page_end which unmap the patched page from guest
and use kvm_flush_remote_tlbs() as the serializing instruction to
ensure the memory coherence
[ The SDM said that INVEPT, INVVPID and MOV (to control register, with
  the exception of MOV CR8) are the serializing instructions. ]

The mmu-lock is held during host patches the page so that it stops vcpus
to fix its further page fault

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 25 +++++++++++++++++++++++++
 arch/x86/kvm/mmu.h |  3 +++
 arch/x86/kvm/x86.c |  7 +++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7d50a2d..35cd0b6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4536,6 +4536,31 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);

+/*
+ * Force vcpu to hang when it is trying to access the specified page.
+ *
+ * kvm_vcpus_hang_on_page_start and kvm_vcpus_hang_on_page_end should
+ * be used in pairs and they are currently used to sync memory access
+ * between vcpus when host cross-modifies the code segment of guest.
+ *
+ * We unmap the page from the guest and do memory synchronization by
+ * kvm_flush_remote_tlbs() under the protection of mmu-lock. If vcpu
+ * accesses the page, it will trigger #PF and be blocked on mmu-lock.
+ */
+void kvm_vcpus_hang_on_page_start(struct kvm *kvm, gfn_t gfn)
+{
+	spin_lock(&kvm->mmu_lock);
+
+	/* kvm_flush_remote_tlbs() can act as serializing instruction. */
+	if (kvm_unmap_hva(kvm, gfn_to_hva(kvm, gfn)))
+		kvm_flush_remote_tlbs(kvm);
+}
+
+void kvm_vcpus_hang_on_page_end(struct kvm *kvm)
+{
+	spin_unlock(&kvm->mmu_lock);
+}
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 5b59c57..35910be 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -115,4 +115,7 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 }

 void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm);
+
+void kvm_vcpus_hang_on_page_start(struct kvm *kvm, gfn_t gfn);
+void kvm_vcpus_hang_on_page_end(struct kvm *kvm);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e4afa7..776bf1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5528,8 +5528,15 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
+	gpa_t gpa;
+
+	gpa = kvm_mmu_gva_to_gpa_fetch(vcpu, rip, NULL);
+	if (gpa == UNMAPPED_GVA)
+		return X86EMUL_PROPAGATE_FAULT;

+	kvm_vcpus_hang_on_page_start(vcpu->kvm, gpa_to_gfn(gpa));
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
+	kvm_vcpus_hang_on_page_end(vcpu->kvm);

 	return emulator_write_emulated(ctxt, rip, instruction, 3, NULL);
 }
-- 
1.8.1.4

