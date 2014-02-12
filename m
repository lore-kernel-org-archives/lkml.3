Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaBLIPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:15:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbaBLIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:15 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Andy Honig" <ahonig@google.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.104543523@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 25/79] KVM: x86: Convert vapic synchronization to
 _cached functions  (CVE-2013-6368)
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[dannf: backported to Debian's 3.2]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1278,14 +1278,12 @@ void __kvm_migrate_apic_timer(struct kvm
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
-	void *vapic;
 
 	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
-	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic, KM_USER0);
+	kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1295,7 +1293,6 @@ void kvm_lapic_sync_to_vapic(struct kvm_
 	u32 data, tpr;
 	int max_irr, max_isr;
 	struct kvm_lapic *apic;
-	void *vapic;
 
 	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
 		return;
@@ -1310,17 +1307,22 @@ void kvm_lapic_sync_to_vapic(struct kvm_
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
-	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
-	kunmap_atomic(vapic, KM_USER0);
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 }
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 {
 	if (!irqchip_in_kernel(vcpu->kvm))
-		return;
+		return 0;
+
+	if (vapic_addr && kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					  &vcpu->arch.apic->vapic_cache,
+					  vapic_addr, sizeof(u32)))
+		return -EINVAL;
 
 	vcpu->arch.apic->vapic_addr = vapic_addr;
+	return 0;
 }
 
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
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
@@ -45,7 +45,7 @@ int kvm_lapic_find_highest_irr(struct kv
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3140,8 +3140,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&va, argp, sizeof va))
 			goto out;
-		r = 0;
-		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
+		r = kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
 	case KVM_X86_SETUP_MCE: {
@@ -5537,33 +5536,6 @@ static void post_kvm_run_save(struct kvm
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
@@ -5836,7 +5808,6 @@ static int __vcpu_run(struct kvm_vcpu *v
 	}
 
 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
-	vapic_enter(vcpu);
 
 	r = 1;
 	while (r > 0) {
@@ -5893,8 +5864,6 @@ static int __vcpu_run(struct kvm_vcpu *v
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
-	vapic_exit(vcpu);
-
 	return r;
 }
 

