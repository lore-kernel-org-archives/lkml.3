Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3EFWkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:40:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47902 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3EFWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:39:58 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Sanjay Lal <sanjayl@kymasys.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH] mips/kvm: Fix ABI for compatibility with 64-bit guests.
Date: Mon,  6 May 2013 15:39:40 -0700
Message-Id: <1367879980-2440-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

There are several parts to this:

o All registers are 64-bits wide, 32-bit guests use the least
  significant portion of the register storage fields.

o FPU register formats are defined.

o CP0 Registers are manipulated via the KVM_GET_MSRS/KVM_SET_MSRS
  mechanism.

The vcpu_ioctl_get_regs and vcpu_ioctl_set_regs function pointers
become unused so they were removed.

Some IOCTL functions were moved to kvm_trap_emul because the
implementations are only for that flavor of KVM host.  In the future, if
hardware based virtualization is added, they can be hidden behind
function pointers as appropriate.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/kvm.h      | 106 ++++++++++---
 arch/mips/include/asm/kvm_host.h |   6 +-
 arch/mips/kernel/asm-offsets.c   |  64 ++++----
 arch/mips/kvm/kvm_mips.c         | 124 +++------------
 arch/mips/kvm/kvm_mips_emul.c    | 108 ++++++-------
 arch/mips/kvm/kvm_trap_emul.c    | 330 ++++++++++++++++++++++++++++++++++-----
 6 files changed, 480 insertions(+), 258 deletions(-)

diff --git a/arch/mips/include/asm/kvm.h b/arch/mips/include/asm/kvm.h
index 85789ea..83c44d8 100644
--- a/arch/mips/include/asm/kvm.h
+++ b/arch/mips/include/asm/kvm.h
@@ -1,55 +1,113 @@
 /*
-* This file is subject to the terms and conditions of the GNU General Public
-* License.  See the file "COPYING" in the main directory of this archive
-* for more details.
-*
-* Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
-* Authors: Sanjay Lal <sanjayl@kymasys.com>
-*/
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
+ * Copyright (C) 2013 Cavium, Inc.
+ * Authors: Sanjay Lal <sanjayl@kymasys.com>
+ */
 
 #ifndef __LINUX_KVM_MIPS_H
 #define __LINUX_KVM_MIPS_H
 
 #include <linux/types.h>
 
-#define __KVM_MIPS
-
-#define N_MIPS_COPROC_REGS      32
-#define N_MIPS_COPROC_SEL   	8
+/*
+ * KVM MIPS specific structures and definitions.
+ *
+ * Some parts derived from the x86 version of this file.
+ */
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
+/*
+ * If Config[AT] is zero (32-bit CPU), the register contents are
+ * stored in the lower 32-bits of the struct kvm_regs fields and sign
+ * extended to 64-bits.
+ */
 struct kvm_regs {
-	__u32 gprs[32];
-	__u32 hi;
-	__u32 lo;
-	__u32 pc;
+	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
+	__u64 gpr[32];
+	__u64 hi, lo;
+	__u64 pc;
+};
 
-	__u32 cp0reg[N_MIPS_COPROC_REGS][N_MIPS_COPROC_SEL];
+/* for KVM_GET_FPU and KVM_SET_FPU */
+/*
+ * If Status[FR] is zero (32-bit FPU), the upper 32-bits of the FPRs
+ * are zero filled.
+ */
+struct kvm_fpu {
+	__u64 fpr[32];
+	__u32 fir;
+	__u32 fccr;
+	__u32 fexr;
+	__u32 fenr;
+	__u32 fcsr;
+	__u32 pad;
 };
 
-/* for KVM_GET_SREGS and KVM_SET_SREGS */
-struct kvm_sregs {
+
+/*
+ * For MIPS, we use the same APIs as x86, where 'msr' corresponds to a
+ * CP0 register.  The index field is broken down as follows:
+ *
+ *  bits[2..0]   - Register 'sel' index.
+ *  bits[7..3]   - Register 'rd'  index.
+ *  bits[15..8]  - Must be zero.
+ *  bits[31..16] - 0 -> CP0 registers.
+ *
+ * Other sets registers may be added in the future.  Each set would
+ * have its own identifier in bits[31..16].
+ *
+ * For MSRs that are narrower than 64-bits, the value is stored in the
+ * low order bits of the data field, and sign extended to 64-bits.
+ */
+#define KVM_MIPS_MSR_CP0 0
+struct kvm_msr_entry {
+	__u32 index;
+	__u32 reserved;
+	__u64 data;
 };
 
-/* for KVM_GET_FPU and KVM_SET_FPU */
-struct kvm_fpu {
+/* for KVM_GET_MSRS and KVM_SET_MSRS */
+struct kvm_msrs {
+	__u32 nmsrs; /* number of msrs in entries */
+	__u32 pad;
+
+	struct kvm_msr_entry entries[0];
 };
 
+/* for KVM_GET_MSR_INDEX_LIST */
+struct kvm_msr_list {
+	__u32 nmsrs; /* number of msrs in entries */
+	__u32 indices[0];
+};
+
+/*
+ * KVM MIPS specific structures and definitions
+ *
+ */
 struct kvm_debug_exit_arch {
+	__u64 epc;
 };
 
 /* for KVM_SET_GUEST_DEBUG */
 struct kvm_guest_debug_arch {
 };
 
+/* definition of registers in kvm_run */
+struct kvm_sync_regs {
+};
+
+/* dummy definition */
+struct kvm_sregs {
+};
+
 struct kvm_mips_interrupt {
 	/* in */
 	__u32 cpu;
 	__u32 irq;
 };
 
-/* definition of registers in kvm_run */
-struct kvm_sync_regs {
-};
-
 #endif /* __LINUX_KVM_MIPS_H */
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index e68781e..3a5b2c8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -360,7 +360,7 @@ struct kvm_vcpu_arch {
 	uint32_t guest_inst;
 
 	/* GPRS */
-	unsigned long gprs[32];
+	unsigned long gpr[32];
 	unsigned long hi;
 	unsigned long lo;
 	unsigned long pc;
@@ -496,10 +496,6 @@ struct kvm_mips_callbacks {
 			    uint32_t cause);
 	int (*irq_clear) (struct kvm_vcpu *vcpu, unsigned int priority,
 			  uint32_t cause);
-	int (*vcpu_ioctl_get_regs) (struct kvm_vcpu *vcpu,
-				    struct kvm_regs *regs);
-	int (*vcpu_ioctl_set_regs) (struct kvm_vcpu *vcpu,
-				    struct kvm_regs *regs);
 };
 extern struct kvm_mips_callbacks *kvm_mips_callbacks;
 int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks);
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index 0845091..a8d4c44 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -351,38 +351,38 @@ void output_kvm_defines(void)
 
 	OFFSET(VCPU_GUEST_INST, kvm_vcpu_arch, guest_inst);
 
-	OFFSET(VCPU_R0, kvm_vcpu_arch, gprs[0]);
-	OFFSET(VCPU_R1, kvm_vcpu_arch, gprs[1]);
-	OFFSET(VCPU_R2, kvm_vcpu_arch, gprs[2]);
-	OFFSET(VCPU_R3, kvm_vcpu_arch, gprs[3]);
-	OFFSET(VCPU_R4, kvm_vcpu_arch, gprs[4]);
-	OFFSET(VCPU_R5, kvm_vcpu_arch, gprs[5]);
-	OFFSET(VCPU_R6, kvm_vcpu_arch, gprs[6]);
-	OFFSET(VCPU_R7, kvm_vcpu_arch, gprs[7]);
-	OFFSET(VCPU_R8, kvm_vcpu_arch, gprs[8]);
-	OFFSET(VCPU_R9, kvm_vcpu_arch, gprs[9]);
-	OFFSET(VCPU_R10, kvm_vcpu_arch, gprs[10]);
-	OFFSET(VCPU_R11, kvm_vcpu_arch, gprs[11]);
-	OFFSET(VCPU_R12, kvm_vcpu_arch, gprs[12]);
-	OFFSET(VCPU_R13, kvm_vcpu_arch, gprs[13]);
-	OFFSET(VCPU_R14, kvm_vcpu_arch, gprs[14]);
-	OFFSET(VCPU_R15, kvm_vcpu_arch, gprs[15]);
-	OFFSET(VCPU_R16, kvm_vcpu_arch, gprs[16]);
-	OFFSET(VCPU_R17, kvm_vcpu_arch, gprs[17]);
-	OFFSET(VCPU_R18, kvm_vcpu_arch, gprs[18]);
-	OFFSET(VCPU_R19, kvm_vcpu_arch, gprs[19]);
-	OFFSET(VCPU_R20, kvm_vcpu_arch, gprs[20]);
-	OFFSET(VCPU_R21, kvm_vcpu_arch, gprs[21]);
-	OFFSET(VCPU_R22, kvm_vcpu_arch, gprs[22]);
-	OFFSET(VCPU_R23, kvm_vcpu_arch, gprs[23]);
-	OFFSET(VCPU_R24, kvm_vcpu_arch, gprs[24]);
-	OFFSET(VCPU_R25, kvm_vcpu_arch, gprs[25]);
-	OFFSET(VCPU_R26, kvm_vcpu_arch, gprs[26]);
-	OFFSET(VCPU_R27, kvm_vcpu_arch, gprs[27]);
-	OFFSET(VCPU_R28, kvm_vcpu_arch, gprs[28]);
-	OFFSET(VCPU_R29, kvm_vcpu_arch, gprs[29]);
-	OFFSET(VCPU_R30, kvm_vcpu_arch, gprs[30]);
-	OFFSET(VCPU_R31, kvm_vcpu_arch, gprs[31]);
+	OFFSET(VCPU_R0, kvm_vcpu_arch, gpr[0]);
+	OFFSET(VCPU_R1, kvm_vcpu_arch, gpr[1]);
+	OFFSET(VCPU_R2, kvm_vcpu_arch, gpr[2]);
+	OFFSET(VCPU_R3, kvm_vcpu_arch, gpr[3]);
+	OFFSET(VCPU_R4, kvm_vcpu_arch, gpr[4]);
+	OFFSET(VCPU_R5, kvm_vcpu_arch, gpr[5]);
+	OFFSET(VCPU_R6, kvm_vcpu_arch, gpr[6]);
+	OFFSET(VCPU_R7, kvm_vcpu_arch, gpr[7]);
+	OFFSET(VCPU_R8, kvm_vcpu_arch, gpr[8]);
+	OFFSET(VCPU_R9, kvm_vcpu_arch, gpr[9]);
+	OFFSET(VCPU_R10, kvm_vcpu_arch, gpr[10]);
+	OFFSET(VCPU_R11, kvm_vcpu_arch, gpr[11]);
+	OFFSET(VCPU_R12, kvm_vcpu_arch, gpr[12]);
+	OFFSET(VCPU_R13, kvm_vcpu_arch, gpr[13]);
+	OFFSET(VCPU_R14, kvm_vcpu_arch, gpr[14]);
+	OFFSET(VCPU_R15, kvm_vcpu_arch, gpr[15]);
+	OFFSET(VCPU_R16, kvm_vcpu_arch, gpr[16]);
+	OFFSET(VCPU_R17, kvm_vcpu_arch, gpr[17]);
+	OFFSET(VCPU_R18, kvm_vcpu_arch, gpr[18]);
+	OFFSET(VCPU_R19, kvm_vcpu_arch, gpr[19]);
+	OFFSET(VCPU_R20, kvm_vcpu_arch, gpr[20]);
+	OFFSET(VCPU_R21, kvm_vcpu_arch, gpr[21]);
+	OFFSET(VCPU_R22, kvm_vcpu_arch, gpr[22]);
+	OFFSET(VCPU_R23, kvm_vcpu_arch, gpr[23]);
+	OFFSET(VCPU_R24, kvm_vcpu_arch, gpr[24]);
+	OFFSET(VCPU_R25, kvm_vcpu_arch, gpr[25]);
+	OFFSET(VCPU_R26, kvm_vcpu_arch, gpr[26]);
+	OFFSET(VCPU_R27, kvm_vcpu_arch, gpr[27]);
+	OFFSET(VCPU_R28, kvm_vcpu_arch, gpr[28]);
+	OFFSET(VCPU_R29, kvm_vcpu_arch, gpr[29]);
+	OFFSET(VCPU_R30, kvm_vcpu_arch, gpr[30]);
+	OFFSET(VCPU_R31, kvm_vcpu_arch, gpr[31]);
 	OFFSET(VCPU_LO, kvm_vcpu_arch, lo);
 	OFFSET(VCPU_HI, kvm_vcpu_arch, hi);
 	OFFSET(VCPU_PC, kvm_vcpu_arch, pc);
diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 2e60b1c..09bac08 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -51,16 +51,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{NULL}
 };
 
-static int kvm_mips_reset_vcpu(struct kvm_vcpu *vcpu)
-{
-	int i;
-	for_each_possible_cpu(i) {
-		vcpu->arch.guest_kernel_asid[i] = 0;
-		vcpu->arch.guest_user_asid[i] = 0;
-	}
-	return 0;
-}
-
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn;
@@ -192,12 +182,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 }
 
-long
-kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
-{
-	return -EINVAL;
-}
-
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
 {
@@ -435,42 +419,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	return r;
 }
-
-int
-kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_mips_interrupt *irq)
-{
-	int intr = (int)irq->irq;
-	struct kvm_vcpu *dvcpu = NULL;
-
-	if (intr == 3 || intr == -3 || intr == 4 || intr == -4)
-		kvm_debug("%s: CPU: %d, INTR: %d\n", __func__, irq->cpu,
-			  (int)intr);
-
-	if (irq->cpu == -1)
-		dvcpu = vcpu;
-	else
-		dvcpu = vcpu->kvm->vcpus[irq->cpu];
-
-	if (intr == 2 || intr == 3 || intr == 4) {
-		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
-
-	} else if (intr == -2 || intr == -3 || intr == -4) {
-		kvm_mips_callbacks->dequeue_io_int(dvcpu, irq);
-	} else {
-		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
-			irq->cpu, irq->irq);
-		return -EINVAL;
-	}
-
-	dvcpu->arch.wait = 0;
-
-	if (waitqueue_active(&dvcpu->wq)) {
-		wake_up_interruptible(&dvcpu->wq);
-	}
-
-	return 0;
-}
-
 int
 kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				struct kvm_mp_state *mp_state)
@@ -485,42 +433,6 @@ kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
-long
-kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
-{
-	struct kvm_vcpu *vcpu = filp->private_data;
-	void __user *argp = (void __user *)arg;
-	long r;
-	int intr;
-
-	switch (ioctl) {
-	case KVM_NMI:
-		/* Treat the NMI as a CPU reset */
-		r = kvm_mips_reset_vcpu(vcpu);
-		break;
-	case KVM_INTERRUPT:
-		{
-			struct kvm_mips_interrupt irq;
-			r = -EFAULT;
-			if (copy_from_user(&irq, argp, sizeof(irq)))
-				goto out;
-
-			intr = (int)irq.irq;
-
-			kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
-				  irq.irq);
-
-			r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
-			break;
-		}
-	default:
-		r = -EINVAL;
-	}
-
-out:
-	return r;
-}
-
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
@@ -657,9 +569,9 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < 32; i += 4) {
 		printk("\tgpr%02d: %08lx %08lx %08lx %08lx\n", i,
-		       vcpu->arch.gprs[i],
-		       vcpu->arch.gprs[i + 1],
-		       vcpu->arch.gprs[i + 2], vcpu->arch.gprs[i + 3]);
+		       vcpu->arch.gpr[i],
+		       vcpu->arch.gpr[i + 1],
+		       vcpu->arch.gpr[i + 2], vcpu->arch.gpr[i + 3]);
 	}
 	printk("\thi: 0x%08lx\n", vcpu->arch.hi);
 	printk("\tlo: 0x%08lx\n", vcpu->arch.lo);
@@ -673,32 +585,32 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	int i;
 
-	for (i = 0; i < 32; i++)
-		vcpu->arch.gprs[i] = regs->gprs[i];
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gpr); i++)
+		regs->gpr[i] = vcpu->arch.gpr[i];
 
-	vcpu->arch.hi = regs->hi;
-	vcpu->arch.lo = regs->lo;
-	vcpu->arch.pc = regs->pc;
+	regs->hi = vcpu->arch.hi;
+	regs->lo = vcpu->arch.lo;
+	regs->pc = vcpu->arch.pc;
 
-	return kvm_mips_callbacks->vcpu_ioctl_set_regs(vcpu, regs);
+	return 0;
 }
 
-int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	int i;
 
-	for (i = 0; i < 32; i++)
-		regs->gprs[i] = vcpu->arch.gprs[i];
-
-	regs->hi = vcpu->arch.hi;
-	regs->lo = vcpu->arch.lo;
-	regs->pc = vcpu->arch.pc;
+	for (i = 1; i < ARRAY_SIZE(vcpu->arch.gpr); i++)
+		vcpu->arch.gpr[i] = regs->gpr[i];
+	vcpu->arch.gpr[0] = 0; /* zero is special, and cannot be set. */
+	vcpu->arch.hi = regs->hi;
+	vcpu->arch.lo = regs->lo;
+	vcpu->arch.pc = regs->pc;
 
-	return kvm_mips_callbacks->vcpu_ioctl_get_regs(vcpu, regs);
+	return 0;
 }
 
 void kvm_mips_comparecount_func(unsigned long data)
diff --git a/arch/mips/kvm/kvm_mips_emul.c b/arch/mips/kvm/kvm_mips_emul.c
index 2b2bac9..cc2f2a9 100644
--- a/arch/mips/kvm/kvm_mips_emul.c
+++ b/arch/mips/kvm/kvm_mips_emul.c
@@ -65,10 +65,10 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 	case spec_op:
 		switch (insn.r_format.func) {
 		case jalr_op:
-			arch->gprs[insn.r_format.rd] = epc + 8;
+			arch->gpr[insn.r_format.rd] = epc + 8;
 			/* Fall through */
 		case jr_op:
-			nextpc = arch->gprs[insn.r_format.rs];
+			nextpc = arch->gpr[insn.r_format.rs];
 			break;
 		}
 		break;
@@ -82,7 +82,7 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 		switch (insn.i_format.rt) {
 		case bltz_op:
 		case bltzl_op:
-			if ((long)arch->gprs[insn.i_format.rs] < 0)
+			if ((long)arch->gpr[insn.i_format.rs] < 0)
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
 			else
 				epc += 8;
@@ -91,7 +91,7 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 
 		case bgez_op:
 		case bgezl_op:
-			if ((long)arch->gprs[insn.i_format.rs] >= 0)
+			if ((long)arch->gpr[insn.i_format.rs] >= 0)
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
 			else
 				epc += 8;
@@ -100,8 +100,8 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 
 		case bltzal_op:
 		case bltzall_op:
-			arch->gprs[31] = epc + 8;
-			if ((long)arch->gprs[insn.i_format.rs] < 0)
+			arch->gpr[31] = epc + 8;
+			if ((long)arch->gpr[insn.i_format.rs] < 0)
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
 			else
 				epc += 8;
@@ -110,8 +110,8 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 
 		case bgezal_op:
 		case bgezall_op:
-			arch->gprs[31] = epc + 8;
-			if ((long)arch->gprs[insn.i_format.rs] >= 0)
+			arch->gpr[31] = epc + 8;
+			if ((long)arch->gpr[insn.i_format.rs] >= 0)
 				epc = epc + 4 + (insn.i_format.simmediate << 2);
 			else
 				epc += 8;
@@ -136,7 +136,7 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 		 * These are unconditional and in j_format.
 		 */
 	case jal_op:
-		arch->gprs[31] = instpc + 8;
+		arch->gpr[31] = instpc + 8;
 	case j_op:
 		epc += 4;
 		epc >>= 28;
@@ -150,8 +150,8 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 		 */
 	case beq_op:
 	case beql_op:
-		if (arch->gprs[insn.i_format.rs] ==
-		    arch->gprs[insn.i_format.rt])
+		if (arch->gpr[insn.i_format.rs] ==
+		    arch->gpr[insn.i_format.rt])
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
 		else
 			epc += 8;
@@ -160,8 +160,8 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 
 	case bne_op:
 	case bnel_op:
-		if (arch->gprs[insn.i_format.rs] !=
-		    arch->gprs[insn.i_format.rt])
+		if (arch->gpr[insn.i_format.rs] !=
+		    arch->gpr[insn.i_format.rt])
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
 		else
 			epc += 8;
@@ -171,7 +171,7 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 	case blez_op:		/* not really i_format */
 	case blezl_op:
 		/* rt field assumed to be zero */
-		if ((long)arch->gprs[insn.i_format.rs] <= 0)
+		if ((long)arch->gpr[insn.i_format.rs] <= 0)
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
 		else
 			epc += 8;
@@ -181,7 +181,7 @@ unsigned long kvm_compute_return_epc(struct kvm_vcpu *vcpu,
 	case bgtz_op:
 	case bgtzl_op:
 		/* rt field assumed to be zero */
-		if ((long)arch->gprs[insn.i_format.rs] > 0)
+		if ((long)arch->gpr[insn.i_format.rs] > 0)
 			epc = epc + 4 + (insn.i_format.simmediate << 2);
 		else
 			epc += 8;
@@ -479,15 +479,15 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 			/* Get reg */
 			if ((rd == MIPS_CP0_COUNT) && (sel == 0)) {
 				/* XXXKYMA: Run the Guest count register @ 1/4 the rate of the host */
-				vcpu->arch.gprs[rt] = (read_c0_count() >> 2);
+				vcpu->arch.gpr[rt] = (read_c0_count() >> 2);
 			} else if ((rd == MIPS_CP0_ERRCTL) && (sel == 0)) {
-				vcpu->arch.gprs[rt] = 0x0;
+				vcpu->arch.gpr[rt] = 0x0;
 #ifdef CONFIG_KVM_MIPS_DYN_TRANS
 				kvm_mips_trans_mfc0(inst, opc, vcpu);
 #endif
 			}
 			else {
-				vcpu->arch.gprs[rt] = cop0->reg[rd][sel];
+				vcpu->arch.gpr[rt] = cop0->reg[rd][sel];
 
 #ifdef CONFIG_KVM_MIPS_DYN_TRANS
 				kvm_mips_trans_mfc0(inst, opc, vcpu);
@@ -495,13 +495,13 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 			}
 
 			kvm_debug
-			    ("[%#x] MFCz[%d][%d], vcpu->arch.gprs[%d]: %#lx\n",
-			     pc, rd, sel, rt, vcpu->arch.gprs[rt]);
+			    ("[%#x] MFCz[%d][%d], vcpu->arch.gpr[%d]: %#lx\n",
+			     pc, rd, sel, rt, vcpu->arch.gpr[rt]);
 
 			break;
 
 		case dmfc_op:
-			vcpu->arch.gprs[rt] = cop0->reg[rd][sel];
+			vcpu->arch.gpr[rt] = cop0->reg[rd][sel];
 			break;
 
 		case mtc_op:
@@ -509,10 +509,10 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 			cop0->stat[rd][sel]++;
 #endif
 			if ((rd == MIPS_CP0_TLB_INDEX)
-			    && (vcpu->arch.gprs[rt] >=
+			    && (vcpu->arch.gpr[rt] >=
 				KVM_MIPS_GUEST_TLB_SIZE)) {
 				printk("Invalid TLB Index: %ld",
-				       vcpu->arch.gprs[rt]);
+				       vcpu->arch.gpr[rt]);
 				er = EMULATE_FAIL;
 				break;
 			}
@@ -521,12 +521,12 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 				/* Preserve CORE number */
 				kvm_change_c0_guest_ebase(cop0,
 							  ~(C0_EBASE_CORE_MASK),
-							  vcpu->arch.gprs[rt]);
+							  vcpu->arch.gpr[rt]);
 				printk("MTCz, cop0->reg[EBASE]: %#lx\n",
 				       kvm_read_c0_guest_ebase(cop0));
 			} else if (rd == MIPS_CP0_TLB_HI && sel == 0) {
-				uint32_t nasid = ASID_MASK(vcpu->arch.gprs[rt]);
-				if ((KSEGX(vcpu->arch.gprs[rt]) != CKSEG0)
+				uint32_t nasid = ASID_MASK(vcpu->arch.gpr[rt]);
+				if ((KSEGX(vcpu->arch.gpr[rt]) != CKSEG0)
 				    &&
 				    (ASID_MASK(kvm_read_c0_guest_entryhi(cop0))
 				      != nasid)) {
@@ -534,13 +534,13 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 					kvm_debug
 					    ("MTCz, change ASID from %#lx to %#lx\n",
 					     ASID_MASK(kvm_read_c0_guest_entryhi(cop0)),
-					     ASID_MASK(vcpu->arch.gprs[rt]));
+					     ASID_MASK(vcpu->arch.gpr[rt]));
 
 					/* Blow away the shadow host TLBs */
 					kvm_mips_flush_host_tlb(1);
 				}
 				kvm_write_c0_guest_entryhi(cop0,
-							   vcpu->arch.gprs[rt]);
+							   vcpu->arch.gpr[rt]);
 			}
 			/* Are we writing to COUNT */
 			else if ((rd == MIPS_CP0_COUNT) && (sel == 0)) {
@@ -552,16 +552,16 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 			} else if ((rd == MIPS_CP0_COMPARE) && (sel == 0)) {
 				kvm_debug("[%#x] MTCz, COMPARE %#lx <- %#lx\n",
 					  pc, kvm_read_c0_guest_compare(cop0),
-					  vcpu->arch.gprs[rt]);
+					  vcpu->arch.gpr[rt]);
 
 				/* If we are writing to COMPARE */
 				/* Clear pending timer interrupt, if any */
 				kvm_mips_callbacks->dequeue_timer_int(vcpu);
 				kvm_write_c0_guest_compare(cop0,
-							   vcpu->arch.gprs[rt]);
+							   vcpu->arch.gpr[rt]);
 			} else if ((rd == MIPS_CP0_STATUS) && (sel == 0)) {
 				kvm_write_c0_guest_status(cop0,
-							  vcpu->arch.gprs[rt]);
+							  vcpu->arch.gpr[rt]);
 				/* Make sure that CU1 and NMI bits are never set */
 				kvm_clear_c0_guest_status(cop0,
 							  (ST0_CU1 | ST0_NMI));
@@ -570,7 +570,7 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 				kvm_mips_trans_mtc0(inst, opc, vcpu);
 #endif
 			} else {
-				cop0->reg[rd][sel] = vcpu->arch.gprs[rt];
+				cop0->reg[rd][sel] = vcpu->arch.gpr[rt];
 #ifdef CONFIG_KVM_MIPS_DYN_TRANS
 				kvm_mips_trans_mtc0(inst, opc, vcpu);
 #endif
@@ -592,7 +592,7 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 			cop0->stat[MIPS_CP0_STATUS][0]++;
 #endif
 			if (rt != 0) {
-				vcpu->arch.gprs[rt] =
+				vcpu->arch.gpr[rt] =
 				    kvm_read_c0_guest_status(cop0);
 			}
 			/* EI */
@@ -620,8 +620,8 @@ kvm_mips_emulate_CP0(uint32_t inst, uint32_t *opc, uint32_t cause,
 					break;
 				}
 				kvm_debug("WRPGPR[%d][%d] = %#lx\n", pss, rd,
-					  vcpu->arch.gprs[rt]);
-				vcpu->arch.gprs[rd] = vcpu->arch.gprs[rt];
+					  vcpu->arch.gpr[rt]);
+				vcpu->arch.gpr[rd] = vcpu->arch.gpr[rt];
 			}
 			break;
 		default:
@@ -693,9 +693,9 @@ kvm_mips_emulate_store(uint32_t inst, uint32_t cause,
 		run->mmio.is_write = 1;
 		vcpu->mmio_needed = 1;
 		vcpu->mmio_is_write = 1;
-		*(u8 *) data = vcpu->arch.gprs[rt];
+		*(u8 *) data = vcpu->arch.gpr[rt];
 		kvm_debug("OP_SB: eaddr: %#lx, gpr: %#lx, data: %#x\n",
-			  vcpu->arch.host_cp0_badvaddr, vcpu->arch.gprs[rt],
+			  vcpu->arch.host_cp0_badvaddr, vcpu->arch.gpr[rt],
 			  *(uint8_t *) data);
 
 		break;
@@ -718,11 +718,11 @@ kvm_mips_emulate_store(uint32_t inst, uint32_t cause,
 		run->mmio.is_write = 1;
 		vcpu->mmio_needed = 1;
 		vcpu->mmio_is_write = 1;
-		*(uint32_t *) data = vcpu->arch.gprs[rt];
+		*(uint32_t *) data = vcpu->arch.gpr[rt];
 
 		kvm_debug("[%#lx] OP_SW: eaddr: %#lx, gpr: %#lx, data: %#x\n",
 			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
-			  vcpu->arch.gprs[rt], *(uint32_t *) data);
+			  vcpu->arch.gpr[rt], *(uint32_t *) data);
 		break;
 
 	case sh_op:
@@ -743,11 +743,11 @@ kvm_mips_emulate_store(uint32_t inst, uint32_t cause,
 		run->mmio.is_write = 1;
 		vcpu->mmio_needed = 1;
 		vcpu->mmio_is_write = 1;
-		*(uint16_t *) data = vcpu->arch.gprs[rt];
+		*(uint16_t *) data = vcpu->arch.gpr[rt];
 
 		kvm_debug("[%#lx] OP_SH: eaddr: %#lx, gpr: %#lx, data: %#x\n",
 			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
-			  vcpu->arch.gprs[rt], *(uint32_t *) data);
+			  vcpu->arch.gpr[rt], *(uint32_t *) data);
 		break;
 
 	default:
@@ -937,10 +937,10 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
 	cache = (inst >> 16) & 0x3;
 	op = (inst >> 18) & 0x7;
 
-	va = arch->gprs[base] + offset;
+	va = arch->gpr[base] + offset;
 
 	kvm_debug("CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-		  cache, op, base, arch->gprs[base], offset);
+		  cache, op, base, arch->gpr[base], offset);
 
 	/* Treat INDEX_INV as a nop, basically issued by Linux on startup to invalidate
 	 * the caches entirely by stepping through all the ways/indexes
@@ -948,8 +948,8 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
 	if (op == MIPS_CACHE_OP_INDEX_INV) {
 		kvm_debug
 		    ("@ %#lx/%#lx CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-		     vcpu->arch.pc, vcpu->arch.gprs[31], cache, op, base,
-		     arch->gprs[base], offset);
+		     vcpu->arch.pc, vcpu->arch.gpr[31], cache, op, base,
+		     arch->gpr[base], offset);
 
 		if (cache == MIPS_CACHE_DCACHE)
 			r4k_blast_dcache();
@@ -1013,7 +1013,7 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
 	} else {
 		printk
 		    ("INVALID CACHE INDEX/ADDRESS (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-		     cache, op, base, arch->gprs[base], offset);
+		     cache, op, base, arch->gpr[base], offset);
 		er = EMULATE_FAIL;
 		preempt_enable();
 		goto dont_update_pc;
@@ -1042,7 +1042,7 @@ skip_fault:
 	} else {
 		printk
 		    ("NO-OP CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-		     cache, op, base, arch->gprs[base], offset);
+		     cache, op, base, arch->gpr[base], offset);
 		er = EMULATE_FAIL;
 		preempt_enable();
 		goto dont_update_pc;
@@ -1543,29 +1543,29 @@ kvm_mips_handle_ri(unsigned long cause, uint32_t *opc,
 		int rt = (inst & RT) >> 16;
 		switch (rd) {
 		case 0:	/* CPU number */
-			arch->gprs[rt] = 0;
+			arch->gpr[rt] = 0;
 			break;
 		case 1:	/* SYNCI length */
-			arch->gprs[rt] = min(current_cpu_data.dcache.linesz,
+			arch->gpr[rt] = min(current_cpu_data.dcache.linesz,
 					     current_cpu_data.icache.linesz);
 			break;
 		case 2:	/* Read count register */
 			printk("RDHWR: Cont register\n");
-			arch->gprs[rt] = kvm_read_c0_guest_count(cop0);
+			arch->gpr[rt] = kvm_read_c0_guest_count(cop0);
 			break;
 		case 3:	/* Count register resolution */
 			switch (current_cpu_data.cputype) {
 			case CPU_20KC:
 			case CPU_25KF:
-				arch->gprs[rt] = 1;
+				arch->gpr[rt] = 1;
 				break;
 			default:
-				arch->gprs[rt] = 2;
+				arch->gpr[rt] = 2;
 			}
 			break;
 		case 29:
 #if 1
-			arch->gprs[rt] = kvm_read_c0_guest_userlocal(cop0);
+			arch->gpr[rt] = kvm_read_c0_guest_userlocal(cop0);
 #else
 			/* UserLocal not implemented */
 			er = kvm_mips_emulate_ri_exc(cause, opc, run, vcpu);
@@ -1594,7 +1594,7 @@ kvm_mips_handle_ri(unsigned long cause, uint32_t *opc,
 enum emulation_result
 kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
+	unsigned long *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
 	enum emulation_result er = EMULATE_DONE;
 	unsigned long curr_pc;
 
diff --git a/arch/mips/kvm/kvm_trap_emul.c b/arch/mips/kvm/kvm_trap_emul.c
index 466aeef..df98dcb 100644
--- a/arch/mips/kvm/kvm_trap_emul.c
+++ b/arch/mips/kvm/kvm_trap_emul.c
@@ -13,7 +13,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
-
+#include <linux/fs.h>
 #include <linux/kvm_host.h>
 
 #include "kvm_mips_opcode.h"
@@ -345,54 +345,312 @@ static int kvm_trap_emul_handle_break(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int
-kvm_trap_emul_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+#define MSR_MIPS_CP0_INDEX (8 * 0 + 0)
+#define MSR_MIPS_CP0_ENTRYLO0 (8 * 2 + 0)
+#define MSR_MIPS_CP0_ENTRYLO1 (8 * 3 + 0)
+#define MSR_MIPS_CP0_CONTEXT (8 * 4 + 0)
+#define MSR_MIPS_CP0_USERLOCAL (8 * 4 + 2)
+#define MSR_MIPS_CP0_PAGEMASK (8 * 5 + 0)
+#define MSR_MIPS_CP0_PAGEGRAIN (8 * 5 + 1)
+#define MSR_MIPS_CP0_WIRED (8 * 6 + 0)
+#define MSR_MIPS_CP0_HWRENA (8 * 7 + 0)
+#define MSR_MIPS_CP0_BADVADDR (8 * 8 + 0)
+#define MSR_MIPS_CP0_COUNT (8 * 9 + 0)
+#define MSR_MIPS_CP0_ENTRYHI (8 * 10 + 0)
+#define MSR_MIPS_CP0_COMPARE (8 * 11 + 0)
+#define MSR_MIPS_CP0_STATUS (8 * 12 + 0)
+#define MSR_MIPS_CP0_CAUSE (8 * 13 + 0)
+#define MSR_MIPS_CP0_EBASE (8 * 15 + 1)
+#define MSR_MIPS_CP0_CONFIG (8 * 16 + 0)
+#define MSR_MIPS_CP0_CONFIG1 (8 * 16 + 1)
+#define MSR_MIPS_CP0_CONFIG2 (8 * 16 + 2)
+#define MSR_MIPS_CP0_CONFIG3 (8 * 16 + 3)
+#define MSR_MIPS_CP0_CONFIG7 (8 * 16 + 7)
+#define MSR_MIPS_CP0_XCONTEXT (8 * 20 + 0)
+#define MSR_MIPS_CP0_ERROREPC (8 * 30 + 0)
+
+static u32 msrs_to_save[] = {
+	MSR_MIPS_CP0_INDEX,
+	MSR_MIPS_CP0_CONTEXT,
+	MSR_MIPS_CP0_PAGEMASK,
+	MSR_MIPS_CP0_WIRED,
+	MSR_MIPS_CP0_BADVADDR,
+	MSR_MIPS_CP0_ENTRYHI,
+	MSR_MIPS_CP0_STATUS,
+	MSR_MIPS_CP0_CAUSE,
+	/* EPC set via kvm_regs, et al. */
+	MSR_MIPS_CP0_CONFIG,
+	MSR_MIPS_CP0_CONFIG1,
+	MSR_MIPS_CP0_CONFIG2,
+	MSR_MIPS_CP0_CONFIG3,
+	MSR_MIPS_CP0_CONFIG7,
+	MSR_MIPS_CP0_XCONTEXT,
+	MSR_MIPS_CP0_ERROREPC
+};
+
+#define MAX_IO_MSRS 128
+
+static int mipsvz_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	s64 v;
 
-	kvm_write_c0_guest_index(cop0, regs->cp0reg[MIPS_CP0_TLB_INDEX][0]);
-	kvm_write_c0_guest_context(cop0, regs->cp0reg[MIPS_CP0_TLB_CONTEXT][0]);
-	kvm_write_c0_guest_badvaddr(cop0, regs->cp0reg[MIPS_CP0_BAD_VADDR][0]);
-	kvm_write_c0_guest_entryhi(cop0, regs->cp0reg[MIPS_CP0_TLB_HI][0]);
-	kvm_write_c0_guest_epc(cop0, regs->cp0reg[MIPS_CP0_EXC_PC][0]);
+	switch (index) {
+	case MSR_MIPS_CP0_INDEX:
+		v = (long)kvm_read_c0_guest_index(cop0);
+		break;
+	case MSR_MIPS_CP0_CONTEXT:
+		v = (long)kvm_read_c0_guest_context(cop0);
+		break;
+	case MSR_MIPS_CP0_PAGEMASK:
+		v = (long)kvm_read_c0_guest_pagemask(cop0);
+		break;
+	case MSR_MIPS_CP0_WIRED:
+		v = (long)kvm_read_c0_guest_wired(cop0);
+		break;
+	case MSR_MIPS_CP0_BADVADDR:
+		v = (long)kvm_read_c0_guest_badvaddr(cop0);
+		break;
+	case MSR_MIPS_CP0_ENTRYHI:
+		v = (long)kvm_read_c0_guest_entryhi(cop0);
+		break;
+	case MSR_MIPS_CP0_STATUS:
+		v = (long)kvm_read_c0_guest_status(cop0);
+		break;
+	case MSR_MIPS_CP0_CAUSE:
+		v = (long)kvm_read_c0_guest_cause(cop0);
+		break;
+	case MSR_MIPS_CP0_ERROREPC:
+		v = (long)kvm_read_c0_guest_errorepc(cop0);
+		break;
+	case MSR_MIPS_CP0_CONFIG:
+		v = (long)kvm_read_c0_guest_config(cop0);
+		break;
+	case MSR_MIPS_CP0_CONFIG1:
+		v = (long)kvm_read_c0_guest_config1(cop0);
+		break;
+	case MSR_MIPS_CP0_CONFIG2:
+		v = (long)kvm_read_c0_guest_config2(cop0);
+		break;
+	case MSR_MIPS_CP0_CONFIG3:
+		v = (long)kvm_read_c0_guest_config3(cop0);
+		break;
+	case MSR_MIPS_CP0_CONFIG7:
+		v = (long)kvm_read_c0_guest_config7(cop0);
+		break;
+	default:
+		return -EINVAL;
+	}
+	*data = v;
+	return 0;
+}
 
-	kvm_write_c0_guest_status(cop0, regs->cp0reg[MIPS_CP0_STATUS][0]);
-	kvm_write_c0_guest_cause(cop0, regs->cp0reg[MIPS_CP0_CAUSE][0]);
-	kvm_write_c0_guest_pagemask(cop0,
-				    regs->cp0reg[MIPS_CP0_TLB_PG_MASK][0]);
-	kvm_write_c0_guest_wired(cop0, regs->cp0reg[MIPS_CP0_TLB_WIRED][0]);
-	kvm_write_c0_guest_errorepc(cop0, regs->cp0reg[MIPS_CP0_ERROR_PC][0]);
+static int mipsvz_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
+{
+	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	u64 v = *data;
 
+	switch (index) {
+	case MSR_MIPS_CP0_INDEX:
+		kvm_write_c0_guest_index(cop0, v);
+		break;
+	case MSR_MIPS_CP0_CONTEXT:
+		kvm_write_c0_guest_context(cop0, v);
+		break;
+	case MSR_MIPS_CP0_PAGEMASK:
+		kvm_write_c0_guest_pagemask(cop0, v);
+		break;
+	case MSR_MIPS_CP0_WIRED:
+		kvm_write_c0_guest_wired(cop0, v);
+		break;
+	case MSR_MIPS_CP0_BADVADDR:
+		kvm_write_c0_guest_badvaddr(cop0, v);
+		break;
+	case MSR_MIPS_CP0_ENTRYHI:
+		kvm_write_c0_guest_entryhi(cop0, v);
+		break;
+	case MSR_MIPS_CP0_STATUS:
+		kvm_write_c0_guest_status(cop0, v);
+		break;
+	case MSR_MIPS_CP0_CAUSE:
+		kvm_write_c0_guest_cause(cop0, v);
+		break;
+	case MSR_MIPS_CP0_ERROREPC:
+		kvm_write_c0_guest_errorepc(cop0, v);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
-static int
-kvm_trap_emul_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+/*
+ * Read or write a bunch of msrs. Parameters are user addresses.
+ *
+ * @return number of msrs set successfully.
+ */
+static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
+		  int (*do_msr)(struct kvm_vcpu *vcpu,
+				unsigned index, u64 *data),
+		  bool writeback)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct kvm_msrs msrs;
+	struct kvm_msr_entry *entries;
+	int r, n;
+	unsigned size;
+
+	r = -EFAULT;
+	if (copy_from_user(&msrs, user_msrs, sizeof(msrs)))
+		goto out;
+
+	r = -E2BIG;
+	if (msrs.nmsrs >= MAX_IO_MSRS)
+		goto out;
+
+	size = sizeof(struct kvm_msr_entry) * msrs.nmsrs;
+	entries = memdup_user(user_msrs->entries, size);
+	if (IS_ERR(entries)) {
+		r = PTR_ERR(entries);
+		goto out;
+	}
 
-	regs->cp0reg[MIPS_CP0_TLB_INDEX][0] = kvm_read_c0_guest_index(cop0);
-	regs->cp0reg[MIPS_CP0_TLB_CONTEXT][0] = kvm_read_c0_guest_context(cop0);
-	regs->cp0reg[MIPS_CP0_BAD_VADDR][0] = kvm_read_c0_guest_badvaddr(cop0);
-	regs->cp0reg[MIPS_CP0_TLB_HI][0] = kvm_read_c0_guest_entryhi(cop0);
-	regs->cp0reg[MIPS_CP0_EXC_PC][0] = kvm_read_c0_guest_epc(cop0);
-
-	regs->cp0reg[MIPS_CP0_STATUS][0] = kvm_read_c0_guest_status(cop0);
-	regs->cp0reg[MIPS_CP0_CAUSE][0] = kvm_read_c0_guest_cause(cop0);
-	regs->cp0reg[MIPS_CP0_TLB_PG_MASK][0] =
-	    kvm_read_c0_guest_pagemask(cop0);
-	regs->cp0reg[MIPS_CP0_TLB_WIRED][0] = kvm_read_c0_guest_wired(cop0);
-	regs->cp0reg[MIPS_CP0_ERROR_PC][0] = kvm_read_c0_guest_errorepc(cop0);
-
-	regs->cp0reg[MIPS_CP0_CONFIG][0] = kvm_read_c0_guest_config(cop0);
-	regs->cp0reg[MIPS_CP0_CONFIG][1] = kvm_read_c0_guest_config1(cop0);
-	regs->cp0reg[MIPS_CP0_CONFIG][2] = kvm_read_c0_guest_config2(cop0);
-	regs->cp0reg[MIPS_CP0_CONFIG][3] = kvm_read_c0_guest_config3(cop0);
-	regs->cp0reg[MIPS_CP0_CONFIG][7] = kvm_read_c0_guest_config7(cop0);
+	for (n = 0; n < msrs.nmsrs; ++n)
+		if (do_msr(vcpu, entries[n].index, &entries[n].data))
+			break;
+
+	r = -EFAULT;
+	if (writeback && copy_to_user(user_msrs->entries, entries, size))
+		goto out_free;
+
+	r = n;
+
+out_free:
+	kfree(entries);
+out:
+	return r;
+}
+
+static int kvm_mips_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	int i;
+	for_each_possible_cpu(i) {
+		vcpu->arch.guest_kernel_asid[i] = 0;
+		vcpu->arch.guest_user_asid[i] = 0;
+	}
+	return 0;
+}
+
+int
+kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_mips_interrupt *irq)
+{
+	int intr = (int)irq->irq;
+	struct kvm_vcpu *dvcpu = NULL;
+
+	if (intr == 3 || intr == -3 || intr == 4 || intr == -4)
+		kvm_debug("%s: CPU: %d, INTR: %d\n", __func__, irq->cpu,
+			  (int)intr);
+
+	if (irq->cpu == -1)
+		dvcpu = vcpu;
+	else
+		dvcpu = vcpu->kvm->vcpus[irq->cpu];
+
+	if (intr == 2 || intr == 3 || intr == 4) {
+		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
+
+	} else if (intr == -2 || intr == -3 || intr == -4) {
+		kvm_mips_callbacks->dequeue_io_int(dvcpu, irq);
+	} else {
+		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
+			irq->cpu, irq->irq);
+		return -EINVAL;
+	}
+
+	dvcpu->arch.wait = 0;
+
+	if (waitqueue_active(&dvcpu->wq))
+		wake_up_interruptible(&dvcpu->wq);
 
 	return 0;
 }
 
+long
+kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	long r;
+
+	switch (ioctl) {
+	case KVM_GET_MSRS:
+		r = msr_io(vcpu, argp, mipsvz_get_msr, true);
+		break;
+	case KVM_SET_MSRS:
+		r = msr_io(vcpu, argp, mipsvz_set_msr, false);
+		break;
+	case KVM_NMI:
+		/* Treat the NMI as a CPU reset */
+		r = kvm_mips_reset_vcpu(vcpu);
+		break;
+	case KVM_INTERRUPT:
+		{
+			struct kvm_mips_interrupt irq;
+			r = -EFAULT;
+			if (copy_from_user(&irq, argp, sizeof(irq)))
+				goto out;
+
+			kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
+				  irq.irq);
+
+			r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+			break;
+		}
+	default:
+		r = -ENOIOCTLCMD;
+	}
+
+out:
+	return r;
+}
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	long r;
+	void __user *argp = (void __user *)arg;
+
+	switch (ioctl) {
+	case KVM_GET_MSR_INDEX_LIST: {
+		struct kvm_msr_list __user *user_msr_list = argp;
+		struct kvm_msr_list msr_list;
+		unsigned n;
+		unsigned num_msrs_to_save;
+
+		r = -EFAULT;
+		if (copy_from_user(&msr_list, user_msr_list, sizeof(msr_list)))
+			goto out;
+		n = msr_list.nmsrs;
+		msr_list.nmsrs = ARRAY_SIZE(msrs_to_save);
+		num_msrs_to_save = min(n, msr_list.nmsrs);
+		if (copy_to_user(user_msr_list, &msr_list, sizeof(msr_list)))
+			goto out;
+		r = -E2BIG;
+		if (n < msr_list.nmsrs)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
+				 num_msrs_to_save * sizeof(u32)))
+			goto out;
+		r = 0;
+		break;
+	}
+	default:
+		r = -ENOIOCTLCMD;
+	}
+out:
+	return r;
+}
+
 static int kvm_trap_emul_vm_init(struct kvm *kvm)
 {
 	return 0;
@@ -471,8 +729,6 @@ static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
 	.dequeue_io_int = kvm_mips_dequeue_io_int_cb,
 	.irq_deliver = kvm_mips_irq_deliver_cb,
 	.irq_clear = kvm_mips_irq_clear_cb,
-	.vcpu_ioctl_get_regs = kvm_trap_emul_ioctl_get_regs,
-	.vcpu_ioctl_set_regs = kvm_trap_emul_ioctl_set_regs,
 };
 
 int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
-- 
1.7.11.7

