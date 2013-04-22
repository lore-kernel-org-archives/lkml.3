Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3DVO3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51428 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab3DVO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Honig" <ahonig@google.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.112111845@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [72/75] KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use
 gfn_to_hva_cache functions (CVE-2013-1797)
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 0b79459b482e85cb7426aa7da683a9f2c97aeae1 upstream.

There is a potential use after free issue with the handling of
MSR_KVM_SYSTEM_TIME.  If the guest specifies a GPA in a movable or removable
memory such as frame buffers then KVM might continue to write to that
address even after it's removed via KVM_SET_USER_MEMORY_REGION.  KVM pins
the page in memory so it's unlikely to cause an issue, but if the user
space component re-purposes the memory previously used for the guest, then
the guest will be able to corrupt that memory.

Tested: Tested against kvmclock unit test

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - We do not implement the PVCLOCK_GUEST_STOPPED flag]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -393,8 +393,8 @@ struct kvm_vcpu_arch {
 	gpa_t time;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned int hw_tsc_khz;
-	unsigned int time_offset;
-	struct page *time_page;
+	struct gfn_to_hva_cache pv_time;
+	bool pv_time_enabled;
 
 	struct {
 		u64 msr_val;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1105,7 +1105,6 @@ static int kvm_guest_time_update(struct
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	void *shared_kaddr;
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
@@ -1141,7 +1140,7 @@ static int kvm_guest_time_update(struct
 
 	local_irq_restore(flags);
 
-	if (!vcpu->time_page)
+	if (!vcpu->pv_time_enabled)
 		return 0;
 
 	/*
@@ -1199,14 +1198,9 @@ static int kvm_guest_time_update(struct
 	 */
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
-
-	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
-	       sizeof(vcpu->hv_clock));
-
-	kunmap_atomic(shared_kaddr, KM_USER0);
-
-	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
+				&vcpu->hv_clock,
+				sizeof(vcpu->hv_clock));
 	return 0;
 }
 
@@ -1496,10 +1490,7 @@ static int kvm_pv_enable_async_pf(struct
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.time_page) {
-		kvm_release_page_dirty(vcpu->arch.time_page);
-		vcpu->arch.time_page = NULL;
-	}
+	vcpu->arch.pv_time_enabled = false;
 }
 
 static void accumulate_steal_time(struct kvm_vcpu *vcpu)
@@ -1591,6 +1582,7 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
+		u64 gpa_offset;
 		kvmclock_reset(vcpu);
 
 		vcpu->arch.time = data;
@@ -1600,21 +1592,17 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		if (!(data & 1))
 			break;
 
-		/* ...but clean it before doing the actual write */
-		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
+		gpa_offset = data & ~(PAGE_MASK | 1);
 
 		/* Check that the address is 32-byte aligned. */
-		if (vcpu->arch.time_offset &
-				(sizeof(struct pvclock_vcpu_time_info) - 1))
+		if (gpa_offset & (sizeof(struct pvclock_vcpu_time_info) - 1))
 			break;
 
-		vcpu->arch.time_page =
-				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
-
-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		     &vcpu->arch.pv_time, data & ~1ULL))
+			vcpu->arch.pv_time_enabled = false;
+		else
+			vcpu->arch.pv_time_enabled = true;
 		break;
 	}
 	case MSR_KVM_ASYNC_PF_EN:
@@ -6554,6 +6542,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask, GFP_KERNEL))
 		goto fail_free_mce_banks;
 
+	vcpu->arch.pv_time_enabled = false;
 	kvm_async_pf_hash_reset(vcpu);
 
 	return 0;

