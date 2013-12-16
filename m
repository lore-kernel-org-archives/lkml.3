Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3LPLib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:38:31 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:42630 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3LPLi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:38:29 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: francis.moro@gmail.com, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH backport hints for <3.10] KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)
Date: Mon, 16 Dec 2013 12:38:17 +0100
Message-Id: <1387193897-24658-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM patch "fix vapic memory corruption" applies to most kernels that
have KVM, but the fix does not apply on many older branches.  The APIs it
uses are available in 3.1, but until 3.9 kvm_gfn_to_hva_cache_init had
one fewer parameter.

The comments in this patch should help fixing kvm_lapic_set_vapic_addr
in older kernels.  I will review the backports as they are posted to
LKML (if I am CCed...).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c | 38 +++++++++++++++++++++++++++++---------
 arch/x86/kvm/lapic.h |  4 ++--
 arch/x86/kvm/x86.c   | 33 +--------------------------------
 3 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 858432287ab6..42c75a0fc467 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1278,14 +1278,12 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
-	void *vapic;
 
 	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic);
+	kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+			      sizeof(u32));
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1295,7 +1293,6 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 	u32 data, tpr;
 	int max_irr, max_isr;
 	struct kvm_lapic *apic;
-	void *vapic;
 
 	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
 		return;
@@ -1310,17 +1307,40 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
-	kunmap_atomic(vapic);
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+			       sizeof(u32));
 }
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 {
 	if (!irqchip_in_kernel(vcpu->kvm))
-		return;
+		return -EINVAL;
+
+	if (vapic_addr) {
+		/* For kernels with 3-argument kvm_gfn_to_hva_cache_init.  For
+		 * newer kernels, the original patch sent to stable applies.
+		 */
+		if (offset_in_page(vapic_addr) > PAGE_SIZE - 4)
+			return -EINVAL;
+
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					     &vcpu->arch.apic->vapic_cache,
+					     vapic_addr))
+			return -EINVAL;
+
+#ifdef KVM_APIC_CHECK_VAPIC
+		/* For kernels with KVM_APIC_CHECK_VAPIC #define.  */
+               __set_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention);
+#endif
+       } else {
+#ifdef KVM_APIC_CHECK_VAPIC
+		/* For kernels with KVM_APIC_CHECK_VAPIC #define.  */
+               __clear_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention);
+#endif
+	}
 
 	vcpu->arch.apic->vapic_addr = vapic_addr;
+	return 0;
 }
 
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6f4ce2575d09..6aec0714398e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -15,7 +15,7 @@ struct kvm_lapic {
 	bool irr_pending;
 	void *regs;
 	gpa_t vapic_addr;
-	struct page *vapic_page;
+	struct gfn_to_hva_cache vapic_cache;
 };
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
@@ -46,7 +46,7 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 185a2b823a2d..896a02f15f38 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2737,8 +2737,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&va, argp, sizeof va))
 			goto out;
-		r = 0;
-		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
+		r = kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
 	case KVM_X86_SETUP_MCE: {
@@ -5084,33 +5083,6 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 			!kvm_event_needs_reinjection(vcpu);
 }
 
-static void vapic_enter(struct kvm_vcpu *vcpu)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	struct page *page;
-
-	if (!apic || !apic->vapic_addr)
-		return;
-
-	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-
-	vcpu->arch.apic->vapic_page = page;
-}
-
-static void vapic_exit(struct kvm_vcpu *vcpu)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	int idx;
-
-	if (!apic || !apic->vapic_addr)
-		return;
-
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	kvm_release_page_dirty(apic->vapic_page);
-	mark_page_dirty(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-}
-
 static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 {
 	int max_irr, tpr;
@@ -5394,7 +5366,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
-	vapic_enter(vcpu);
 
 	r = 1;
 	while (r > 0) {
@@ -5451,8 +5422,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
-	vapic_exit(vcpu);
-
 	return r;
 }
 
-- 
1.8.4.2

