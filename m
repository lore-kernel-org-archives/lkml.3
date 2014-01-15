Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaAOW0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:26:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaAOV5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 053/166] KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)
Date: Wed, 15 Jan 2014 13:51:07 -0800
Message-Id: <1389822780-4729-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit fda4e2e85589191b123d31cdc21fd33ee70f50fd upstream.

In kvm_lapic_sync_from_vapic and kvm_lapic_sync_to_vapic there is the
potential to corrupt kernel memory if userspace provides an address that
is at the end of a page.  This patches concerts those functions to use
kvm_write_guest_cached and kvm_read_guest_cached.  It also checks the
vapic_address specified by userspace during ioctl processing and returns
an error to userspace if the address is not a valid GPA.

This is generally not guest triggerable, because the required write is
done by firmware that runs before the guest.  Also, it only affects AMD
processors and oldish Intel that do not have the FlexPriority feature
(unless you disable FlexPriority, of course; then newer processors are
also affected).

Fixes: b93463aa59d6 ('KVM: Accelerated apic support')

Reported-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/lapic.c | 27 +++++++++++++++------------
 arch/x86/kvm/lapic.h |  4 ++--
 arch/x86/kvm/x86.c   | 40 +---------------------------------------
 3 files changed, 18 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8d11f7735..b8a559b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1633,7 +1633,6 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
-	void *vapic;
 
 	if (test_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention))
 		apic_sync_pv_eoi_from_guest(vcpu, vcpu->arch.apic);
@@ -1641,9 +1640,8 @@ void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic);
+	kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1679,7 +1677,6 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 	u32 data, tpr;
 	int max_irr, max_isr;
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	void *vapic;
 
 	apic_sync_pv_eoi_to_guest(vcpu, apic);
 
@@ -1695,18 +1692,24 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
-	kunmap_atomic(vapic);
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 }
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 {
-	vcpu->arch.apic->vapic_addr = vapic_addr;
-	if (vapic_addr)
+	if (vapic_addr) {
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					&vcpu->arch.apic->vapic_cache,
+					vapic_addr, sizeof(u32)))
+			return -EINVAL;
 		__set_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention);
-	else
+	} else {
 		__clear_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention);
+	}
+
+	vcpu->arch.apic->vapic_addr = vapic_addr;
+	return 0;
 }
 
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e5ebf9f..de61f21 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,7 +31,7 @@ struct kvm_lapic {
 	 */
 	void *regs;
 	gpa_t vapic_addr;
-	struct page *vapic_page;
+	struct gfn_to_hva_cache vapic_cache;
 };
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
@@ -64,7 +64,7 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e2af7b..c22ab85 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3094,8 +3094,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&va, argp, sizeof va))
 			goto out;
-		r = 0;
-		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
+		r = kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
 	case KVM_X86_SETUP_MCE: {
@@ -5450,36 +5449,6 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 			!kvm_event_needs_reinjection(vcpu);
 }
 
-static int vapic_enter(struct kvm_vcpu *vcpu)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	struct page *page;
-
-	if (!apic || !apic->vapic_addr)
-		return 0;
-
-	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-	if (is_error_page(page))
-		return -EFAULT;
-
-	vcpu->arch.apic->vapic_page = page;
-	return 0;
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
@@ -5796,11 +5765,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
-	r = vapic_enter(vcpu);
-	if (r) {
-		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-		return r;
-	}
 
 	r = 1;
 	while (r > 0) {
@@ -5857,8 +5821,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
-	vapic_exit(vcpu);
-
 	return r;
 }
 
-- 
1.8.3.2

