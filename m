Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3LQSRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:17:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3LQSQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:16:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 098/103] KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)
Date: Tue, 17 Dec 2013 18:13:27 +0000
Message-Id: <1387304012-23805-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: based on pbonzini backport for <3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/lapic.c | 27 +++++++++++++++------------
 arch/x86/kvm/lapic.h |  4 ++--
 arch/x86/kvm/x86.c   | 33 +--------------------------------
 3 files changed, 18 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 399df2f..94e0d9d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1287,14 +1287,12 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
-	void *vapic;
 
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic);
+	kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1304,7 +1302,6 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 	u32 data, tpr;
 	int max_irr, max_isr;
 	struct kvm_lapic *apic;
-	void *vapic;
 
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
@@ -1319,18 +1316,24 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
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
index 6f4ce25..6aec071 100644
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
index 671e5df..494817e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2751,8 +2751,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&va, argp, sizeof va))
 			goto out;
-		r = 0;
-		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
+		r = kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
 	case KVM_X86_SETUP_MCE: {
@@ -5096,33 +5095,6 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
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
@@ -5408,7 +5380,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
-	vapic_enter(vcpu);
 
 	r = 1;
 	while (r > 0) {
@@ -5465,8 +5436,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
-	vapic_exit(vcpu);
-
 	return r;
 }
 
-- 
1.8.3.2

