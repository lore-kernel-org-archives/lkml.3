Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869AbaEMOz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:55:59 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38485 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbaEMOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:55:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH 2/5] KVM: x86: retrieve CPL in KVM_GET_SREGS, prepare to be able to set it
Date: Tue, 13 May 2014 16:55:38 +0200
Message-Id: <1399992941-11600-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
References: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the set path, this patch never uses the new code so there
is no semantic change.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/include/uapi/asm/kvm.h |  5 ++++-
 arch/x86/kvm/svm.c              | 13 ++++++++++---
 arch/x86/kvm/vmx.c              | 36 +++++++++++++++++++++++-------------
 arch/x86/kvm/x86.c              | 24 ++++++++++++------------
 5 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e21aee98a5c2..0bc2d91c8a97 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -689,7 +689,7 @@ struct kvm_x86_ops {
 			    struct kvm_segment *var, int seg);
 	int (*get_cpl)(struct kvm_vcpu *vcpu);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg);
+			    struct kvm_segment *var, int seg, bool set_cpl);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*decache_cr0_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*decache_cr3)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d3a87780c70b..4e80c624d0b3 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -126,7 +126,10 @@ struct kvm_segment {
 	__u8  type;
 	__u8  present, dpl, db, s, l, g, avl;
 	__u8  unusable;
-	__u8  padding;
+	union {
+		__u8  padding;
+		__u8  cpl;
+	};
 };
 
 struct kvm_dtable {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0b7d58d0c5fb..647e47653a9b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -203,6 +203,7 @@ module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static int svm_get_cpl(struct kvm_vcpu *vcpu);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_intercept(struct vcpu_svm *svm);
@@ -1445,6 +1446,7 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 		 * Intel's VMENTRY has a check on the 'G' bit.
 		 */
 		var->g = s->limit > 0xfffff;
+		var->cpl = svm_get_cpl(vcpu);
 		break;
 	case VCPU_SREG_TR:
 		/*
@@ -1611,7 +1613,8 @@ static int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg)
+			    struct kvm_segment *var, int seg,
+			    bool set_cpl)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_seg *s = svm_seg(vcpu, seg);
@@ -1631,8 +1634,12 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 		s->attrib |= (var->db & 1) << SVM_SELECTOR_DB_SHIFT;
 		s->attrib |= (var->g & 1) << SVM_SELECTOR_G_SHIFT;
 	}
-	if (seg == VCPU_SREG_CS)
-		svm_update_cpl(vcpu);
+	if (seg == VCPU_SREG_CS) {
+		if (set_cpl)
+			svm->vmcb->save.cpl = var->cpl;
+		else
+			svm_update_cpl(vcpu);
+	}
 
 	mark_dirty(svm->vmcb, VMCB_SEG);
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a56a4acda82c..10256c27694d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -733,9 +733,10 @@ static void kvm_cpu_vmxoff(void);
 static bool vmx_mpx_supported(void);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg);
+			    struct kvm_segment *var, int seg, bool set_cpl);
 static void vmx_get_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
+static int vmx_get_cpl(struct kvm_vcpu *vcpu);
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
 static void vmx_sync_pir_to_irr_dummy(struct kvm_vcpu *vcpu);
@@ -3109,7 +3110,7 @@ static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		save->dpl = save->selector & SELECTOR_RPL_MASK;
 		save->s = 1;
 	}
-	vmx_set_segment(vcpu, save, seg);
+	vmx_set_segment(vcpu, save, seg, false);
 }
 
 static void enter_pmode(struct kvm_vcpu *vcpu)
@@ -3132,7 +3133,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 	vmx_segment_cache_clear(vmx);
 
-	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
+	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR, false);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
 	flags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
@@ -3538,6 +3539,9 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 	var->l = (ar >> 13) & 1;
 	var->db = (ar >> 14) & 1;
 	var->g = (ar >> 15) & 1;
+
+	if (seg == VCPU_SREG_CS)
+		var->cpl = vmx_get_cpl(vcpu);
 }
 
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
@@ -3592,14 +3596,20 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
 }
 
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg)
+			    struct kvm_segment *var, int seg,
+			    bool set_cpl)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
 	vmx_segment_cache_clear(vmx);
-	if (seg == VCPU_SREG_CS)
-		__clear_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
+	if (seg == VCPU_SREG_CS) {
+		if (set_cpl) {
+			__set_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
+			vmx->cpl = var->cpl;
+		} else
+			__clear_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
+	}
 
 	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
 		vmx->rmode.segs[seg] = *var;
@@ -8600,7 +8610,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		seg.l = 1;
 	else
 		seg.db = 1;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_CS);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_CS, false);
 	seg = (struct kvm_segment) {
 		.base = 0,
 		.limit = 0xFFFFFFFF,
@@ -8611,17 +8621,17 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		.g = 1
 	};
 	seg.selector = vmcs12->host_ds_selector;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_DS);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_DS, false);
 	seg.selector = vmcs12->host_es_selector;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_ES);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_ES, false);
 	seg.selector = vmcs12->host_ss_selector;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_SS);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_SS, false);
 	seg.selector = vmcs12->host_fs_selector;
 	seg.base = vmcs12->host_fs_base;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_FS);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_FS, false);
 	seg.selector = vmcs12->host_gs_selector;
 	seg.base = vmcs12->host_gs_base;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_GS);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_GS, false);
 	seg = (struct kvm_segment) {
 		.base = vmcs12->host_tr_base,
 		.limit = 0x67,
@@ -8629,7 +8639,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		.type = 11,
 		.present = 1
 	};
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_TR);
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_TR, false);
 
 	kvm_set_dr(vcpu, 7, 0x400);
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e0532fc4d96..ca0a1d38fa51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4033,9 +4033,9 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 }
 
 static void kvm_set_segment(struct kvm_vcpu *vcpu,
-			struct kvm_segment *var, int seg)
+			struct kvm_segment *var, int seg, int set_cpl)
 {
-	kvm_x86_ops->set_segment(vcpu, var, seg);
+	kvm_x86_ops->set_segment(vcpu, var, seg, set_cpl);
 }
 
 void kvm_get_segment(struct kvm_vcpu *vcpu,
@@ -4848,7 +4848,7 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 	var.unusable = !var.present;
 	var.padding = 0;
 
-	kvm_set_segment(vcpu, &var, seg);
+	kvm_set_segment(vcpu, &var, seg, false);
 	return;
 }
 
@@ -6678,15 +6678,15 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		pr_debug("Set back pending irq %d\n", pending_vec);
 	}
 
-	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS, false);
+	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS, false);
+	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES, false);
+	kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS, false);
+	kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS, false);
+	kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS, false);
 
-	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR, false);
+	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR, false);
 
 	update_cr8_intercept(vcpu);
 
@@ -6976,7 +6976,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, unsigned int vector)
 	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
 	cs.selector = vector << 8;
 	cs.base = vector << 12;
-	kvm_set_segment(vcpu, &cs, VCPU_SREG_CS);
+	kvm_set_segment(vcpu, &cs, VCPU_SREG_CS, false);
 	kvm_rip_write(vcpu, 0);
 }
 
-- 
1.8.3.1


