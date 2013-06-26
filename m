Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3FZFgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:36:07 -0400
Received: from [216.32.180.188] ([216.32.180.188]:2092 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751414Ab3FZFgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:36:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zz853kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <tiejun.chen@windriver.com>,
        <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <mikey@neuling.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 6/6 v5] KVM: PPC: Add userspace debug stub support
Date: Wed, 26 Jun 2013 11:12:26 +0530
Message-ID: <1372225346-5029-7-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the debug stub support on booke/bookehv.
Now QEMU debug stub can use hw breakpoint, watchpoint and
software breakpoint to debug guest.

This is how we save/restore debug register context when switching
between guest, userspace and kernel user-process:

When QEMU is running
 -> thread->debug_reg == QEMU debug register context.
 -> Kernel will handle switching the debug register on context switch.
 -> no vcpu_load() called

QEMU makes ioctls (except RUN)
 -> This will call vcpu_load()
 -> should not change context.
 -> Some ioctls can change vcpu debug register, context saved in vcpu->debug_regs

QEMU Makes RUN ioctl
 -> Save thread->debug_reg on STACK
 -> Store thread->debug_reg == vcpu->debug_reg
 -> load thread->debug_reg
 -> RUN VCPU ( So thread points to vcpu context )

Context switch happens When VCPU running
 -> makes vcpu_load() should not load any context
 -> kernel loads the vcpu context as thread->debug_regs points to vcpu context.

On heavyweight_exit
 -> Load the context saved on stack in thread->debug_reg

Currently we do not support debug resource emulation to guest,
On debug exception, always exit to user space irrespective of
user space is expecting the debug exception or not. If this is
unexpected exception (breakpoint/watchpoint event not set by
userspace) then let us leave the action on user space. This
is similar to what it was before, only thing is that now we
have proper exit state available to user space.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/include/asm/kvm_host.h |    3 +
 arch/powerpc/include/uapi/asm/kvm.h |    1 +
 arch/powerpc/kvm/booke.c            |  239 ++++++++++++++++++++++++++++++++---
 arch/powerpc/kvm/booke.h            |    5 +
 4 files changed, 230 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 838a577..aeb490d 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -524,7 +524,10 @@ struct kvm_vcpu_arch {
 	u32 eptcfg;
 	u32 epr;
 	u32 crit_save;
+	/* guest debug registers*/
 	struct debug_reg dbg_reg;
+	/* hardware visible debug registers when in guest state */
+	struct debug_reg shadow_dbg_reg;
 #endif
 	gpa_t paddr_accessed;
 	gva_t vaddr_accessed;
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index ded0607..f5077c2 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -27,6 +27,7 @@
 #define __KVM_HAVE_PPC_SMT
 #define __KVM_HAVE_IRQCHIP
 #define __KVM_HAVE_IRQ_LINE
+#define __KVM_HAVE_GUEST_DEBUG
 
 struct kvm_regs {
 	__u64 pc;
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 3e9fc1d..8cd8d41 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -133,6 +133,29 @@ static void kvmppc_vcpu_sync_fpu(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static void kvmppc_vcpu_sync_debug(struct kvm_vcpu *vcpu)
+{
+	/* Synchronize guest's desire to get debug interrupts into shadow MSR */
+#ifndef CONFIG_KVM_BOOKE_HV
+	vcpu->arch.shadow_msr &= ~MSR_DE;
+	vcpu->arch.shadow_msr |= vcpu->arch.shared->msr & MSR_DE;
+#endif
+
+	/* Force enable debug interrupts when user space wants to debug */
+	if (vcpu->guest_debug) {
+#ifdef CONFIG_KVM_BOOKE_HV
+		/*
+		 * Since there is no shadow MSR, sync MSR_DE into the guest
+		 * visible MSR.
+		 */
+		vcpu->arch.shared->msr |= MSR_DE;
+#else
+		vcpu->arch.shadow_msr |= MSR_DE;
+		vcpu->arch.shared->msr &= ~MSR_DE;
+#endif
+	}
+}
+
 /*
  * Helper function for "full" MSR writes.  No need to call this if only
  * EE/CE/ME/DE/RI are changing.
@@ -150,6 +173,7 @@ void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
 	kvmppc_mmu_msr_notify(vcpu, old_msr);
 	kvmppc_vcpu_sync_spe(vcpu);
 	kvmppc_vcpu_sync_fpu(vcpu);
+	kvmppc_vcpu_sync_debug(vcpu);
 }
 
 static void kvmppc_booke_queue_irqprio(struct kvm_vcpu *vcpu,
@@ -655,6 +679,7 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
 int kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	int ret, s;
+	struct thread_struct thread;
 #ifdef CONFIG_PPC_FPU
 	unsigned int fpscr;
 	int fpexc_mode;
@@ -698,12 +723,21 @@ int kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	kvmppc_load_guest_fp(vcpu);
 #endif
+	/* Switch to guest debug context */
+	thread.debug = vcpu->arch.shadow_dbg_reg;
+	switch_booke_debug_regs(&thread);
+	thread.debug = current->thread.debug;
+	current->thread.debug = vcpu->arch.shadow_dbg_reg;
 
 	ret = __kvmppc_vcpu_run(kvm_run, vcpu);
 
 	/* No need for kvm_guest_exit. It's done in handle_exit.
 	   We also get here with interrupts enabled. */
 
+	/* Switch back to user space debug context */
+	switch_booke_debug_regs(&thread);
+	current->thread.debug = thread.debug;
+
 #ifdef CONFIG_PPC_FPU
 	kvmppc_save_guest_fp(vcpu);
 
@@ -759,6 +793,30 @@ static int emulation_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	}
 }
 
+static int kvmppc_handle_debug(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	struct debug_reg *dbg_reg = &(vcpu->arch.shadow_dbg_reg);
+	u32 dbsr = vcpu->arch.dbsr;
+
+	run->debug.arch.status = 0;
+	run->debug.arch.address = vcpu->arch.pc;
+
+	if (dbsr & (DBSR_IAC1 | DBSR_IAC2 | DBSR_IAC3 | DBSR_IAC4)) {
+		run->debug.arch.status |= KVMPPC_DEBUG_BREAKPOINT;
+	} else {
+		if (dbsr & (DBSR_DAC1W | DBSR_DAC2W))
+			run->debug.arch.status |= KVMPPC_DEBUG_WATCH_WRITE;
+		else if (dbsr & (DBSR_DAC1R | DBSR_DAC2R))
+			run->debug.arch.status |= KVMPPC_DEBUG_WATCH_READ;
+		if (dbsr & (DBSR_DAC1R | DBSR_DAC1W))
+			run->debug.arch.address = dbg_reg->dac1;
+		else if (dbsr & (DBSR_DAC2R | DBSR_DAC2W))
+			run->debug.arch.address = dbg_reg->dac2;
+	}
+
+	return RESUME_HOST;
+}
+
 static void kvmppc_fill_pt_regs(struct pt_regs *regs)
 {
 	ulong r1, ip, msr, lr;
@@ -819,6 +877,11 @@ static void kvmppc_restart_interrupt(struct kvm_vcpu *vcpu,
 	case BOOKE_INTERRUPT_CRITICAL:
 		unknown_exception(&regs);
 		break;
+	case BOOKE_INTERRUPT_DEBUG:
+		/* Save DBSR before preemption is enabled */
+		vcpu->arch.dbsr = mfspr(SPRN_DBSR);
+		kvmppc_clear_dbsr();
+		break;
 	}
 }
 
@@ -1118,18 +1181,10 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	}
 
 	case BOOKE_INTERRUPT_DEBUG: {
-		u32 dbsr;
-
-		vcpu->arch.pc = mfspr(SPRN_CSRR0);
-
-		/* clear IAC events in DBSR register */
-		dbsr = mfspr(SPRN_DBSR);
-		dbsr &= DBSR_IAC1 | DBSR_IAC2 | DBSR_IAC3 | DBSR_IAC4;
-		mtspr(SPRN_DBSR, dbsr);
-
-		run->exit_reason = KVM_EXIT_DEBUG;
+		r = kvmppc_handle_debug(run, vcpu);
+		if (r == RESUME_HOST)
+			run->exit_reason = KVM_EXIT_DEBUG;
 		kvmppc_account_exit(vcpu, DEBUG_EXITS);
-		r = RESUME_HOST;
 		break;
 	}
 
@@ -1180,7 +1235,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	kvmppc_set_msr(vcpu, 0);
 
 #ifndef CONFIG_KVM_BOOKE_HV
-	vcpu->arch.shadow_msr = MSR_USER | MSR_DE | MSR_IS | MSR_DS;
+	vcpu->arch.shadow_msr = MSR_USER | MSR_IS | MSR_DS;
 	vcpu->arch.shadow_pid = 1;
 	vcpu->arch.shared->msr = 0;
 #endif
@@ -1557,12 +1612,6 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 	return r;
 }
 
-int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
-					 struct kvm_guest_debug *dbg)
-{
-	return -EINVAL;
-}
-
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	return -ENOTSUPP;
@@ -1668,6 +1717,157 @@ void kvmppc_decrementer_func(unsigned long data)
 	kvmppc_set_tsr_bits(vcpu, TSR_DIS);
 }
 
+static int kvmppc_booke_add_breakpoint(struct debug_reg *dbg_reg,
+				       uint64_t addr, int index)
+{
+	switch (index) {
+	case 0:
+		dbg_reg->dbcr0 |= DBCR0_IAC1;
+		dbg_reg->iac1 = addr;
+		break;
+	case 1:
+		dbg_reg->dbcr0 |= DBCR0_IAC2;
+		dbg_reg->iac2 = addr;
+		break;
+#if CONFIG_PPC_ADV_DEBUG_IACS > 2
+	case 2:
+		dbg_reg->dbcr0 |= DBCR0_IAC3;
+		dbg_reg->iac3 = addr;
+		break;
+	case 3:
+		dbg_reg->dbcr0 |= DBCR0_IAC4;
+		dbg_reg->iac4 = addr;
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	dbg_reg->dbcr0 |= DBCR0_IDM;
+	return 0;
+}
+
+static int kvmppc_booke_add_watchpoint(struct debug_reg *dbg_reg, uint64_t addr,
+				       int type, int index)
+{
+	switch (index) {
+	case 0:
+		if (type & KVMPPC_DEBUG_WATCH_READ)
+			dbg_reg->dbcr0 |= DBCR0_DAC1R;
+		if (type & KVMPPC_DEBUG_WATCH_WRITE)
+			dbg_reg->dbcr0 |= DBCR0_DAC1W;
+		dbg_reg->dac1 = addr;
+		break;
+	case 1:
+		if (type & KVMPPC_DEBUG_WATCH_READ)
+			dbg_reg->dbcr0 |= DBCR0_DAC2R;
+		if (type & KVMPPC_DEBUG_WATCH_WRITE)
+			dbg_reg->dbcr0 |= DBCR0_DAC2W;
+		dbg_reg->dac2 = addr;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dbg_reg->dbcr0 |= DBCR0_IDM;
+	return 0;
+}
+void kvm_guest_protect_msr(struct kvm_vcpu *vcpu, ulong prot_bitmap, bool set)
+{
+	/* XXX: Add similar MSR protection for BookE-PR */
+#ifdef CONFIG_KVM_BOOKE_HV
+	BUG_ON(prot_bitmap & ~(MSRP_UCLEP | MSRP_DEP | MSRP_PMMP));
+	if (set) {
+		if (prot_bitmap & MSR_UCLE)
+			vcpu->arch.shadow_msrp |= MSRP_UCLEP;
+		if (prot_bitmap & MSR_DE)
+			vcpu->arch.shadow_msrp |= MSRP_DEP;
+		if (prot_bitmap & MSR_PMM)
+			vcpu->arch.shadow_msrp |= MSRP_PMMP;
+	} else {
+		if (prot_bitmap & MSR_UCLE)
+			vcpu->arch.shadow_msrp &= ~MSRP_UCLEP;
+		if (prot_bitmap & MSR_DE)
+			vcpu->arch.shadow_msrp &= ~MSRP_DEP;
+		if (prot_bitmap & MSR_PMM)
+			vcpu->arch.shadow_msrp &= ~MSRP_PMMP;
+	}
+#endif
+}
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					 struct kvm_guest_debug *dbg)
+{
+	struct debug_reg *dbg_reg;
+	int n, b = 0, w = 0;
+
+	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
+		vcpu->arch.shadow_dbg_reg.dbcr0 = 0;
+		vcpu->guest_debug = 0;
+		kvm_guest_protect_msr(vcpu, MSR_DE, false);
+		return 0;
+	}
+
+	kvm_guest_protect_msr(vcpu, MSR_DE, true);
+	vcpu->guest_debug = dbg->control;
+	vcpu->arch.shadow_dbg_reg.dbcr0 = 0;
+	/* Set DBCR0_EDM in guest visible DBCR0 register. */
+	vcpu->arch.dbg_reg.dbcr0 = DBCR0_EDM;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		vcpu->arch.shadow_dbg_reg.dbcr0 |= DBCR0_IDM | DBCR0_IC;
+
+	/* Code below handles only HW breakpoints */
+	dbg_reg = &(vcpu->arch.shadow_dbg_reg);
+
+#ifdef CONFIG_KVM_BOOKE_HV
+	/*
+	 * On BookE-HV (e500mc) the guest is always executed with MSR.GS=1
+	 * DBCR1 and DBCR2 are set to trigger debug events when MSR.PR is 0
+	 */
+	dbg_reg->dbcr1 = 0;
+	dbg_reg->dbcr2 = 0;
+#else
+	/*
+	 * On BookE-PR (e500v2) the guest is always executed with MSR.PR=1
+	 * We set DBCR1 and DBCR2 to only trigger debug events when MSR.PR
+	 * is set.
+	 */
+	dbg_reg->dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US | DBCR1_IAC3US |
+			  DBCR1_IAC4US;
+	dbg_reg->dbcr2 = DBCR2_DAC1US | DBCR2_DAC2US;
+#endif
+
+	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
+		return 0;
+
+	for (n = 0; n < (KVMPPC_BOOKE_IAC_NUM + KVMPPC_BOOKE_DAC_NUM); n++) {
+		uint64_t addr = dbg->arch.bp[n].addr;
+		uint32_t type = dbg->arch.bp[n].type;
+
+		if (type == KVMPPC_DEBUG_NONE)
+			continue;
+
+		if (type & !(KVMPPC_DEBUG_WATCH_READ |
+			     KVMPPC_DEBUG_WATCH_WRITE |
+			     KVMPPC_DEBUG_BREAKPOINT))
+			return -EINVAL;
+
+		if (type & KVMPPC_DEBUG_BREAKPOINT) {
+			/* Setting H/W breakpoint */
+			if (kvmppc_booke_add_breakpoint(dbg_reg, addr, b++))
+				return -EINVAL;
+		} else {
+			/* Setting H/W watchpoint */
+			if (kvmppc_booke_add_watchpoint(dbg_reg, addr,
+							type, w++))
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 void kvmppc_booke_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = smp_processor_id();
@@ -1678,6 +1878,9 @@ void kvmppc_booke_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	current->thread.kvm_vcpu = NULL;
 	vcpu->cpu = -1;
+
+	/* Clear pending debug event in DBSR */
+	kvmppc_clear_dbsr();
 }
 
 int __init kvmppc_booke_init(void)
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index 5fd1ba6..a1ff67d 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -129,4 +129,9 @@ static inline void kvmppc_save_guest_fp(struct kvm_vcpu *vcpu)
 		giveup_fpu(current);
 #endif
 }
+
+static inline void kvmppc_clear_dbsr(void)
+{
+	mtspr(SPRN_DBSR, mfspr(SPRN_DBSR));
+}
 #endif /* __KVM_BOOKE_H__ */
-- 
1.7.0.4


