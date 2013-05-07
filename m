Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab3EGEat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:30:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab3EGEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:57 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eJ7bGSCbJCQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Svk4FA74UMIA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=xRfJKs44TRSbNWNmjF4A:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=g6jQtUTZHdoCEopf:21 a=so1MYOJiXRvj_tL5:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035852.261093152@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [068/126] KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache
 functions (CVE-2013-1797)
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0068-KVM-x86-Convert-MSR_KVM_SYSTEM_TIME-to-use-gfn_to_hv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

[ Upstream commit 0b79459b482e85cb7426aa7da683a9f2c97aeae1 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 arch/x86/kvm/x86.c              |   41 ++++++++++++++-------------------------
 2 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09155d6..69c9a92 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,8 +418,8 @@ struct kvm_vcpu_arch {
 	gpa_t time;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned int hw_tsc_khz;
-	unsigned int time_offset;
-	struct page *time_page;
+	struct gfn_to_hva_cache pv_time;
+	bool pv_time_enabled;
 
 	struct {
 		u64 msr_val;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 142e18a..2bf95c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1136,7 +1136,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	void *shared_kaddr;
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
@@ -1172,7 +1171,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	local_irq_restore(flags);
 
-	if (!vcpu->time_page)
+	if (!vcpu->pv_time_enabled)
 		return 0;
 
 	/*
@@ -1230,14 +1229,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 */
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page);
-
-	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
-	       sizeof(vcpu->hv_clock));
-
-	kunmap_atomic(shared_kaddr);
-
-	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
+				&vcpu->hv_clock,
+				sizeof(vcpu->hv_clock));
 	return 0;
 }
 
@@ -1526,10 +1520,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.time_page) {
-		kvm_release_page_dirty(vcpu->arch.time_page);
-		vcpu->arch.time_page = NULL;
-	}
+	vcpu->arch.pv_time_enabled = false;
 }
 
 static void accumulate_steal_time(struct kvm_vcpu *vcpu)
@@ -1624,6 +1615,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
+		u64 gpa_offset;
 		kvmclock_reset(vcpu);
 
 		vcpu->arch.time = data;
@@ -1633,21 +1625,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
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
@@ -2641,7 +2629,7 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 {
 	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
-	if (!vcpu->arch.time_page)
+	if (!vcpu->arch.pv_time_enabled)
 		return -EINVAL;
 	src->flags |= PVCLOCK_GUEST_STOPPED;
 	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
@@ -6237,6 +6225,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask, GFP_KERNEL))
 		goto fail_free_mce_banks;
 
+	vcpu->arch.pv_time_enabled = false;
 	kvm_async_pf_hash_reset(vcpu);
 	kvm_pmu_init(vcpu);
 
-- 
1.7.10.4


