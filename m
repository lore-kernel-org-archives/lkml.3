Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaKVOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:25:29 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56443 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKVOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:25:28 -0500
From: Wincy Van <fanwenyi0529@gmail.com>
To: pbonzini@redhat.com, gleb@kernel.org, jan.kiszka@web.de
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, fanwenyi0529@gmail.com
Subject: [PATCH] KVM: nVMX: nested MSR auto load/restore emulation.
Date: Sat, 22 Nov 2014 22:24:32 +0800
Message-Id: <1416666272-6760-1-git-send-email-fanwenyi0529@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hypervisors need MSR auto load/restore feature.

We read MSRs from vm-entry MSR load area which specified by L1,
and load them via kvm_set_msr in the nested entry.
When nested exit occurs, we get MSRs via kvm_get_msr, writing
them to L1`s MSR store area. After this, we read MSRs from vm-exit
MSR load area, and load them via kvm_set_msr.

VirtualBox will work fine with this patch.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/include/uapi/asm/vmx.h |    5 ++
 arch/x86/kvm/vmx.c              |  123 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |    1 +
 virt/kvm/kvm_main.c             |    1 +
 4 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 990a2fe..986af3f 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -56,6 +56,7 @@
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_INVALID_STATE       33
+#define EXIT_REASON_MSR_LOAD_FAIL       34
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
 #define EXIT_REASON_MONITOR_INSTRUCTION 39
 #define EXIT_REASON_PAUSE_INSTRUCTION   40
@@ -114,8 +115,12 @@
 	{ EXIT_REASON_APIC_WRITE,            "APIC_WRITE" }, \
 	{ EXIT_REASON_EOI_INDUCED,           "EOI_INDUCED" }, \
 	{ EXIT_REASON_INVALID_STATE,         "INVALID_STATE" }, \
+	{ EXIT_REASON_MSR_LOAD_FAIL,         "MSR_LOAD_FAIL" }, \
 	{ EXIT_REASON_INVD,                  "INVD" }, \
 	{ EXIT_REASON_INVVPID,               "INVVPID" }, \
 	{ EXIT_REASON_INVPCID,               "INVPCID" }
 
+#define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
+#define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
+
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 330a08a..03daefc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6088,6 +6088,13 @@ static void nested_vmx_failValid(struct kvm_vcpu *vcpu,
 	 */
 }
 
+static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
+{
+	/* TODO: not to reset guest simply here. */
+	kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+	pr_warn("kvm: nested vmx abort, indicator %d\n", indicator);
+}
+
 static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
 {
 	struct vcpu_vmx *vmx =
@@ -8215,6 +8222,92 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
 		      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL);
 }
 
+static inline int nested_msr_check_common(struct vmx_msr_entry *e)
+{
+	if (e->index >> 8 == 0x8 || e->reserved != 0)
+		return -EINVAL;
+	return 0;
+}
+
+static inline int nested_load_msr_check(struct vmx_msr_entry *e)
+{
+	if (e->index == MSR_FS_BASE ||
+	    e->index == MSR_GS_BASE ||
+		nested_msr_check_common(e))
+		return -EINVAL;
+	return 0;
+}
+
+/* load guest msr at nested entry.
+ * return 0 for success, entry index for failed.
+ */
+static u32 nested_entry_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
+{
+	u32 i = 0;
+	struct vmx_msr_entry e;
+	struct msr_data msr;
+
+	msr.host_initiated = false;
+	while (i < count) {
+		kvm_read_guest(vcpu->kvm,
+				gpa + i * sizeof(struct vmx_msr_entry),
+				&e, sizeof(struct vmx_msr_entry));
+		if (nested_load_msr_check(&e))
+			goto fail;
+		msr.index = e.index;
+		msr.data = e.value;
+		if (kvm_set_msr(vcpu, &msr))
+			goto fail;
+		++i;
+	}
+	return 0;
+fail:
+	return i + 1;
+}
+
+static int nested_exit_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
+{
+	u32 i = 0;
+	struct vmx_msr_entry e;
+
+	while (i < count) {
+		kvm_read_guest(vcpu->kvm,
+				gpa + i * sizeof(struct vmx_msr_entry),
+				&e, sizeof(struct vmx_msr_entry));
+		if (nested_msr_check_common(&e))
+			return -EINVAL;
+		if (kvm_get_msr(vcpu, e.index, &e.value))
+			return -EINVAL;
+		kvm_write_guest(vcpu->kvm,
+				gpa + i * sizeof(struct vmx_msr_entry),
+				&e, sizeof(struct vmx_msr_entry));
+		++i;
+	}
+	return 0;
+}
+
+static int nested_exit_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
+{
+	u32 i = 0;
+	struct vmx_msr_entry e;
+	struct msr_data msr;
+
+	msr.host_initiated = false;
+	while (i < count) {
+		kvm_read_guest(vcpu->kvm,
+				gpa + i * sizeof(struct vmx_msr_entry),
+				&e, sizeof(struct vmx_msr_entry));
+		if (nested_load_msr_check(&e))
+			return -EINVAL;
+		msr.index = e.index;
+		msr.data = e.value;
+		if (kvm_set_msr(vcpu, &msr))
+			return -EINVAL;
+		++i;
+	}
+	return 0;
+}
+
 /*
  * prepare_vmcs02 is called when the L1 guest hypervisor runs its nested
  * L2 guest. L1 has a vmcs for L2 (vmcs12), and this function "merges" it
@@ -8509,6 +8598,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	int cpu;
 	struct loaded_vmcs *vmcs02;
 	bool ia32e;
+	u32 msr_entry_idx;
 
 	if (!nested_vmx_check_permission(vcpu) ||
 	    !nested_vmx_check_vmcs12(vcpu))
@@ -8556,11 +8646,12 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return 1;
 	}
 
-	if (vmcs12->vm_entry_msr_load_count > 0 ||
-	    vmcs12->vm_exit_msr_load_count > 0 ||
-	    vmcs12->vm_exit_msr_store_count > 0) {
-		pr_warn_ratelimited("%s: VMCS MSR_{LOAD,STORE} unsupported\n",
-				    __func__);
+	if ((vmcs12->vm_entry_msr_load_count > 0 &&
+		!IS_ALIGNED(vmcs12->vm_entry_msr_load_addr, 16)) ||
+	    (vmcs12->vm_exit_msr_load_count > 0 &&
+		!IS_ALIGNED(vmcs12->vm_exit_msr_load_addr, 16)) ||
+	    (vmcs12->vm_exit_msr_store_count > 0 &&
+		!IS_ALIGNED(vmcs12->vm_exit_msr_store_addr, 16))) {
 		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
 	}
@@ -8666,10 +8757,21 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 
 	vmx_segment_cache_clear(vmx);
 
-	vmcs12->launch_state = 1;
-
 	prepare_vmcs02(vcpu, vmcs12);
 
+	msr_entry_idx = nested_entry_load_msr(vcpu,
+		vmcs12->vm_entry_msr_load_addr,
+		vmcs12->vm_entry_msr_load_count);
+	if (msr_entry_idx) {
+		leave_guest_mode(vcpu);
+		vmx_load_vmcs01(vcpu);
+		nested_vmx_entry_failure(vcpu, vmcs12,
+			EXIT_REASON_MSR_LOAD_FAIL, msr_entry_idx);
+		return 1;
+	}
+
+	vmcs12->launch_state = 1;
+
 	if (vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT)
 		return kvm_emulate_halt(vcpu);
 
@@ -9097,6 +9198,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 
 	kvm_set_dr(vcpu, 7, 0x400);
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+
+	if (nested_exit_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
+		vmcs12->vm_exit_msr_load_count))
+		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
 }
 
 /*
@@ -9118,6 +9223,10 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 		       exit_qualification);
 
+	if (nested_exit_store_msr(vcpu, vmcs12->vm_exit_msr_store_addr,
+		vmcs12->vm_exit_msr_store_count))
+		nested_vmx_abort(vcpu, VMX_ABORT_SAVE_GUEST_MSR_FAIL);
+
 	vmx_load_vmcs01(vcpu);
 
 	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8f53a6..1c7eecc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2323,6 +2323,7 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	return kvm_x86_ops->get_msr(vcpu, msr_index, pdata);
 }
+EXPORT_SYMBOL_GPL(kvm_get_msr);
 
 static int get_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 751ece6..be02556 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1585,6 +1585,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len)
-- 
1.7.1

