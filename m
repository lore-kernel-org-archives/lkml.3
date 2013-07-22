Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3GVGNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:13:36 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:35692 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GVGNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:13:33 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <riel@redhat.com>,
        <drjones@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Mon, 22 Jul 2013 11:50:51 +0530
Message-Id: <20130722062051.24737.52043.sendpatchset@codeblue>
In-Reply-To: <20130722061631.24737.75508.sendpatchset@codeblue>
References: <20130722061631.24737.75508.sendpatchset@codeblue>
Subject: [PATCH RFC V11 18/18] kvm hypervisor: Add directed yield in vcpu block path
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072206-6102-0000-0000-000003E547D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm hypervisor: Add directed yield in vcpu block path

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

We use the improved PLE handler logic in vcpu block patch for
scheduling rather than plain schedule, so that we can make
intelligent decisions.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Changes: 
 Added stubs for missing architecture (Gleb)

 arch/arm/include/asm/kvm_host.h     |    5 +++++
 arch/arm64/include/asm/kvm_host.h   |    5 +++++
 arch/ia64/include/asm/kvm_host.h    |    5 +++++
 arch/mips/include/asm/kvm_host.h    |    5 +++++
 arch/powerpc/include/asm/kvm_host.h |    5 +++++
 arch/s390/include/asm/kvm_host.h    |    5 +++++
 arch/x86/include/asm/kvm_host.h     |    2 +-
 arch/x86/kvm/x86.c                  |    8 ++++++++
 include/linux/kvm_host.h            |    2 +-
 virt/kvm/kvm_main.c                 |    6 ++++--
 10 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 7d22517..94836c0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -226,6 +226,11 @@ static inline int kvm_arch_dev_ioctl_check_extension(long ext)
 	return 0;
 }
 
+static inline void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	schedule();
+}
+
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 644d739..cd18913 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -186,6 +186,11 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+static inline void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	schedule();
+}
+
 static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 				       phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 989dd3f..999ab15 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -595,6 +595,11 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 void kvm_sal_emul(struct kvm_vcpu *vcpu);
 
+static inline void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	schedule();
+}
+
 #define __KVM_HAVE_ARCH_VM_ALLOC 1
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 4d6fa0b..2c4aae9 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -655,6 +655,11 @@ extern int kvm_mips_trans_mtc0(uint32_t inst, uint32_t *opc,
 			       struct kvm_vcpu *vcpu);
 
 /* Misc */
+static inline void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	schedule();
+}
+
 extern void mips32_SyncICache(unsigned long addr, unsigned long size);
 extern int kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
 extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index af326cd..1aeecc0 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -628,4 +628,9 @@ struct kvm_vcpu_arch {
 #define __KVM_HAVE_ARCH_WQP
 #define __KVM_HAVE_CREATE_DEVICE
 
+static inline void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	schedule();
+}
+
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3238d40..d3409fa 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -274,6 +274,11 @@ struct kvm_arch{
 	int css_support;
 };
 
+static inline void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	schedule();
+}
+
 extern int sie64a(struct kvm_s390_sie_block *, u64 *);
 extern char sie_exit;
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d1f711..ed06ecd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1053,5 +1053,5 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
-
+void kvm_do_schedule(struct kvm_vcpu *vcpu);
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 640d112..ea64481 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7319,6 +7319,14 @@ bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
 			kvm_x86_ops->interrupt_allowed(vcpu);
 }
 
+void kvm_do_schedule(struct kvm_vcpu *vcpu)
+{
+	/* We try to yield to a kicked vcpu else do a schedule */
+	if (kvm_vcpu_on_spin(vcpu) <= 0)
+		schedule();
+}
+EXPORT_SYMBOL_GPL(kvm_do_schedule);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a63d83e..fab21ec 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -568,7 +568,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_yield_to(struct kvm_vcpu *target);
-void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1580dd4..72c49f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1685,7 +1685,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (signal_pending(current))
 			break;
 
-		schedule();
+		kvm_do_schedule(vcpu);
 	}
 
 	finish_wait(&vcpu->wq, &wait);
@@ -1786,7 +1786,7 @@ bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 }
 #endif
 
-void kvm_vcpu_on_spin(struct kvm_vcpu *me)
+bool kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
@@ -1835,6 +1835,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 
 	/* Ensure vcpu is not eligible during next spinloop */
 	kvm_vcpu_set_dy_eligible(me, false);
+
+	return yielded;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 

