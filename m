Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab3EWQt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:49:28 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43425 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746Ab3EWQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:49:21 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v6 5/6] mips/kvm: Fix ABI by moving manipulation of CP0 registers to KVM_{G,S}ET_ONE_REG
Date: Thu, 23 May 2013 09:49:09 -0700
Message-Id: <1369327750-28580-6-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Because not all 256 CP0 registers are ever implemented, we need a
different method of manipulating them.  Use the
KVM_SET_ONE_REG/KVM_GET_ONE_REG mechanism.

Now unused code and definitions are removed.

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Sanjay Lal <sanjayl@kymasys.com>
---
 arch/mips/include/asm/kvm_host.h |   4 -
 arch/mips/include/uapi/asm/kvm.h |  91 +++++++++++---
 arch/mips/kvm/kvm_mips.c         | 252 +++++++++++++++++++++++++++++++++++++--
 arch/mips/kvm/kvm_trap_emul.c    |  50 --------
 4 files changed, 322 insertions(+), 75 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index e68781e..e3d49ec 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
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
diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
index d145ead..3f424f5 100644
--- a/arch/mips/include/uapi/asm/kvm.h
+++ b/arch/mips/include/uapi/asm/kvm.h
@@ -13,10 +13,11 @@
 
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
 
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
@@ -31,12 +32,6 @@ struct kvm_regs {
 	__u64 hi;
 	__u64 lo;
 	__u64 pc;
-
-	__u32 cp0reg[N_MIPS_COPROC_REGS][N_MIPS_COPROC_SEL];
-};
-
-/* for KVM_GET_SREGS and KVM_SET_SREGS */
-struct kvm_sregs {
 };
 
 /*
@@ -55,21 +50,89 @@ struct kvm_fpu {
 	__u32 pad;
 };
 
+
+/*
+ * For MIPS, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access CP0
+ * registers.  The id field is broken down as follows:
+ *
+ *  bits[2..0]   - Register 'sel' index.
+ *  bits[7..3]   - Register 'rd'  index.
+ *  bits[15..8]  - Must be zero.
+ *  bits[63..16] - 1 -> CP0 registers.
+ *
+ * Other sets registers may be added in the future.  Each set would
+ * have its own identifier in bits[63..16].
+ *
+ * The addr field of struct kvm_one_reg must point to an aligned
+ * 64-bit wide location.  For registers that are narrower than
+ * 64-bits, the value is stored in the low order bits of the location,
+ * and sign extended to 64-bits.
+ *
+ * The registers defined in struct kvm_regs are also accessible, the
+ * id values for these are below.
+ */
+
+#define KVM_REG_MIPS_R0 0
+#define KVM_REG_MIPS_R1 1
+#define KVM_REG_MIPS_R2 2
+#define KVM_REG_MIPS_R3 3
+#define KVM_REG_MIPS_R4 4
+#define KVM_REG_MIPS_R5 5
+#define KVM_REG_MIPS_R6 6
+#define KVM_REG_MIPS_R7 7
+#define KVM_REG_MIPS_R8 8
+#define KVM_REG_MIPS_R9 9
+#define KVM_REG_MIPS_R10 10
+#define KVM_REG_MIPS_R11 11
+#define KVM_REG_MIPS_R12 12
+#define KVM_REG_MIPS_R13 13
+#define KVM_REG_MIPS_R14 14
+#define KVM_REG_MIPS_R15 15
+#define KVM_REG_MIPS_R16 16
+#define KVM_REG_MIPS_R17 17
+#define KVM_REG_MIPS_R18 18
+#define KVM_REG_MIPS_R19 19
+#define KVM_REG_MIPS_R20 20
+#define KVM_REG_MIPS_R21 21
+#define KVM_REG_MIPS_R22 22
+#define KVM_REG_MIPS_R23 23
+#define KVM_REG_MIPS_R24 24
+#define KVM_REG_MIPS_R25 25
+#define KVM_REG_MIPS_R26 26
+#define KVM_REG_MIPS_R27 27
+#define KVM_REG_MIPS_R28 28
+#define KVM_REG_MIPS_R29 29
+#define KVM_REG_MIPS_R30 30
+#define KVM_REG_MIPS_R31 31
+
+#define KVM_REG_MIPS_HI 32
+#define KVM_REG_MIPS_LO 33
+#define KVM_REG_MIPS_PC 34
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
diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 71a1fc1..3caa006 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -485,15 +485,253 @@ kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+#define KVM_REG_MIPS_CP0_INDEX (0x10000 + 8 * 0 + 0)
+#define KVM_REG_MIPS_CP0_ENTRYLO0 (0x10000 + 8 * 2 + 0)
+#define KVM_REG_MIPS_CP0_ENTRYLO1 (0x10000 + 8 * 3 + 0)
+#define KVM_REG_MIPS_CP0_CONTEXT (0x10000 + 8 * 4 + 0)
+#define KVM_REG_MIPS_CP0_USERLOCAL (0x10000 + 8 * 4 + 2)
+#define KVM_REG_MIPS_CP0_PAGEMASK (0x10000 + 8 * 5 + 0)
+#define KVM_REG_MIPS_CP0_PAGEGRAIN (0x10000 + 8 * 5 + 1)
+#define KVM_REG_MIPS_CP0_WIRED (0x10000 + 8 * 6 + 0)
+#define KVM_REG_MIPS_CP0_HWRENA (0x10000 + 8 * 7 + 0)
+#define KVM_REG_MIPS_CP0_BADVADDR (0x10000 + 8 * 8 + 0)
+#define KVM_REG_MIPS_CP0_COUNT (0x10000 + 8 * 9 + 0)
+#define KVM_REG_MIPS_CP0_ENTRYHI (0x10000 + 8 * 10 + 0)
+#define KVM_REG_MIPS_CP0_COMPARE (0x10000 + 8 * 11 + 0)
+#define KVM_REG_MIPS_CP0_STATUS (0x10000 + 8 * 12 + 0)
+#define KVM_REG_MIPS_CP0_CAUSE (0x10000 + 8 * 13 + 0)
+#define KVM_REG_MIPS_CP0_EBASE (0x10000 + 8 * 15 + 1)
+#define KVM_REG_MIPS_CP0_CONFIG (0x10000 + 8 * 16 + 0)
+#define KVM_REG_MIPS_CP0_CONFIG1 (0x10000 + 8 * 16 + 1)
+#define KVM_REG_MIPS_CP0_CONFIG2 (0x10000 + 8 * 16 + 2)
+#define KVM_REG_MIPS_CP0_CONFIG3 (0x10000 + 8 * 16 + 3)
+#define KVM_REG_MIPS_CP0_CONFIG7 (0x10000 + 8 * 16 + 7)
+#define KVM_REG_MIPS_CP0_XCONTEXT (0x10000 + 8 * 20 + 0)
+#define KVM_REG_MIPS_CP0_ERROREPC (0x10000 + 8 * 30 + 0)
+
+static u64 kvm_mips_get_one_regs[] = {
+	KVM_REG_MIPS_R0,
+	KVM_REG_MIPS_R1,
+	KVM_REG_MIPS_R2,
+	KVM_REG_MIPS_R3,
+	KVM_REG_MIPS_R4,
+	KVM_REG_MIPS_R5,
+	KVM_REG_MIPS_R6,
+	KVM_REG_MIPS_R7,
+	KVM_REG_MIPS_R8,
+	KVM_REG_MIPS_R9,
+	KVM_REG_MIPS_R10,
+	KVM_REG_MIPS_R11,
+	KVM_REG_MIPS_R12,
+	KVM_REG_MIPS_R13,
+	KVM_REG_MIPS_R14,
+	KVM_REG_MIPS_R15,
+	KVM_REG_MIPS_R16,
+	KVM_REG_MIPS_R17,
+	KVM_REG_MIPS_R18,
+	KVM_REG_MIPS_R19,
+	KVM_REG_MIPS_R20,
+	KVM_REG_MIPS_R21,
+	KVM_REG_MIPS_R22,
+	KVM_REG_MIPS_R23,
+	KVM_REG_MIPS_R24,
+	KVM_REG_MIPS_R25,
+	KVM_REG_MIPS_R26,
+	KVM_REG_MIPS_R27,
+	KVM_REG_MIPS_R28,
+	KVM_REG_MIPS_R29,
+	KVM_REG_MIPS_R30,
+	KVM_REG_MIPS_R31,
+
+	KVM_REG_MIPS_HI,
+	KVM_REG_MIPS_LO,
+	KVM_REG_MIPS_PC,
+
+	KVM_REG_MIPS_CP0_INDEX,
+	KVM_REG_MIPS_CP0_CONTEXT,
+	KVM_REG_MIPS_CP0_PAGEMASK,
+	KVM_REG_MIPS_CP0_WIRED,
+	KVM_REG_MIPS_CP0_BADVADDR,
+	KVM_REG_MIPS_CP0_ENTRYHI,
+	KVM_REG_MIPS_CP0_STATUS,
+	KVM_REG_MIPS_CP0_CAUSE,
+	/* EPC set via kvm_regs, et al. */
+	KVM_REG_MIPS_CP0_CONFIG,
+	KVM_REG_MIPS_CP0_CONFIG1,
+	KVM_REG_MIPS_CP0_CONFIG2,
+	KVM_REG_MIPS_CP0_CONFIG3,
+	KVM_REG_MIPS_CP0_CONFIG7,
+	KVM_REG_MIPS_CP0_ERROREPC
+};
+
+static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
+			    const struct kvm_one_reg *reg)
+{
+	u64 __user *uaddr = (u64 __user *)(long)reg->addr;
+
+	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	s64 v;
+
+	switch (reg->id) {
+	case KVM_REG_MIPS_R0 ... KVM_REG_MIPS_R31:
+		v = (long)vcpu->arch.gprs[reg->id - KVM_REG_MIPS_R0];
+		break;
+	case KVM_REG_MIPS_HI:
+		v = (long)vcpu->arch.hi;
+		break;
+	case KVM_REG_MIPS_LO:
+		v = (long)vcpu->arch.lo;
+		break;
+	case KVM_REG_MIPS_PC:
+		v = (long)vcpu->arch.pc;
+		break;
+
+	case KVM_REG_MIPS_CP0_INDEX:
+		v = (long)kvm_read_c0_guest_index(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CONTEXT:
+		v = (long)kvm_read_c0_guest_context(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_PAGEMASK:
+		v = (long)kvm_read_c0_guest_pagemask(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_WIRED:
+		v = (long)kvm_read_c0_guest_wired(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_BADVADDR:
+		v = (long)kvm_read_c0_guest_badvaddr(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_ENTRYHI:
+		v = (long)kvm_read_c0_guest_entryhi(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_STATUS:
+		v = (long)kvm_read_c0_guest_status(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CAUSE:
+		v = (long)kvm_read_c0_guest_cause(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_ERROREPC:
+		v = (long)kvm_read_c0_guest_errorepc(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CONFIG:
+		v = (long)kvm_read_c0_guest_config(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CONFIG1:
+		v = (long)kvm_read_c0_guest_config1(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CONFIG2:
+		v = (long)kvm_read_c0_guest_config2(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CONFIG3:
+		v = (long)kvm_read_c0_guest_config3(cop0);
+		break;
+	case KVM_REG_MIPS_CP0_CONFIG7:
+		v = (long)kvm_read_c0_guest_config7(cop0);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return put_user(v, uaddr);
+}
+
+static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
+			    const struct kvm_one_reg *reg)
+{
+	u64 __user *uaddr = (u64 __user *)(long)reg->addr;
+	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	u64 v;
+
+	if (get_user(v, uaddr) != 0)
+		return -EFAULT;
+
+	switch (reg->id) {
+	case KVM_REG_MIPS_R0:
+		/* Silently ignore requests to set $0 */
+		break;
+	case KVM_REG_MIPS_R1 ... KVM_REG_MIPS_R31:
+		vcpu->arch.gprs[reg->id - KVM_REG_MIPS_R0] = v;
+		break;
+	case KVM_REG_MIPS_HI:
+		vcpu->arch.hi = v;
+		break;
+	case KVM_REG_MIPS_LO:
+		vcpu->arch.lo = v;
+		break;
+	case KVM_REG_MIPS_PC:
+		vcpu->arch.pc = v;
+		break;
+
+	case KVM_REG_MIPS_CP0_INDEX:
+		kvm_write_c0_guest_index(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_CONTEXT:
+		kvm_write_c0_guest_context(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_PAGEMASK:
+		kvm_write_c0_guest_pagemask(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_WIRED:
+		kvm_write_c0_guest_wired(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_BADVADDR:
+		kvm_write_c0_guest_badvaddr(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_ENTRYHI:
+		kvm_write_c0_guest_entryhi(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_STATUS:
+		kvm_write_c0_guest_status(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_CAUSE:
+		kvm_write_c0_guest_cause(cop0, v);
+		break;
+	case KVM_REG_MIPS_CP0_ERROREPC:
+		kvm_write_c0_guest_errorepc(cop0, v);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 long
 kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	long r;
-	int intr;
 
 	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			return -EFAULT;
+		if (ioctl == KVM_SET_ONE_REG)
+			return kvm_mips_set_reg(vcpu, &reg);
+		else
+			return kvm_mips_get_reg(vcpu, &reg);
+	}
+	case KVM_GET_REG_LIST: {
+		struct kvm_reg_list __user *user_list = argp;
+		u64 __user *reg_dest;
+		struct kvm_reg_list reg_list;
+		unsigned n;
+
+		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
+			return -EFAULT;
+		n = reg_list.n;
+		reg_list.n = ARRAY_SIZE(kvm_mips_get_one_regs);
+		if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
+			return -EFAULT;
+		if (n < reg_list.n)
+			return -E2BIG;
+		reg_dest = user_list->reg;
+		if (copy_to_user(reg_dest, kvm_mips_get_one_regs,
+				 sizeof(kvm_mips_get_one_regs)))
+			return -EFAULT;
+		return 0;
+	}
 	case KVM_NMI:
 		/* Treat the NMI as a CPU reset */
 		r = kvm_mips_reset_vcpu(vcpu);
@@ -505,8 +743,6 @@ kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			if (copy_from_user(&irq, argp, sizeof(irq)))
 				goto out;
 
-			intr = (int)irq.irq;
-
 			kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
 				  irq.irq);
 
@@ -514,7 +750,7 @@ kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			break;
 		}
 	default:
-		r = -EINVAL;
+		r = -ENOIOCTLCMD;
 	}
 
 out:
@@ -627,6 +863,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	int r;
 
 	switch (ext) {
+	case KVM_CAP_ONE_REG:
+		r = 1;
+		break;
 	case KVM_CAP_COALESCED_MMIO:
 		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
 		break;
@@ -635,7 +874,6 @@ int kvm_dev_ioctl_check_extension(long ext)
 		break;
 	}
 	return r;
-
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -684,7 +922,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	vcpu->arch.lo = regs->lo;
 	vcpu->arch.pc = regs->pc;
 
-	return kvm_mips_callbacks->vcpu_ioctl_set_regs(vcpu, regs);
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
@@ -698,7 +936,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	regs->lo = vcpu->arch.lo;
 	regs->pc = vcpu->arch.pc;
 
-	return kvm_mips_callbacks->vcpu_ioctl_get_regs(vcpu, regs);
+	return 0;
 }
 
 void kvm_mips_comparecount_func(unsigned long data)
diff --git a/arch/mips/kvm/kvm_trap_emul.c b/arch/mips/kvm/kvm_trap_emul.c
index 466aeef..30d7253 100644
--- a/arch/mips/kvm/kvm_trap_emul.c
+++ b/arch/mips/kvm/kvm_trap_emul.c
@@ -345,54 +345,6 @@ static int kvm_trap_emul_handle_break(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int
-kvm_trap_emul_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-
-	kvm_write_c0_guest_index(cop0, regs->cp0reg[MIPS_CP0_TLB_INDEX][0]);
-	kvm_write_c0_guest_context(cop0, regs->cp0reg[MIPS_CP0_TLB_CONTEXT][0]);
-	kvm_write_c0_guest_badvaddr(cop0, regs->cp0reg[MIPS_CP0_BAD_VADDR][0]);
-	kvm_write_c0_guest_entryhi(cop0, regs->cp0reg[MIPS_CP0_TLB_HI][0]);
-	kvm_write_c0_guest_epc(cop0, regs->cp0reg[MIPS_CP0_EXC_PC][0]);
-
-	kvm_write_c0_guest_status(cop0, regs->cp0reg[MIPS_CP0_STATUS][0]);
-	kvm_write_c0_guest_cause(cop0, regs->cp0reg[MIPS_CP0_CAUSE][0]);
-	kvm_write_c0_guest_pagemask(cop0,
-				    regs->cp0reg[MIPS_CP0_TLB_PG_MASK][0]);
-	kvm_write_c0_guest_wired(cop0, regs->cp0reg[MIPS_CP0_TLB_WIRED][0]);
-	kvm_write_c0_guest_errorepc(cop0, regs->cp0reg[MIPS_CP0_ERROR_PC][0]);
-
-	return 0;
-}
-
-static int
-kvm_trap_emul_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-
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
-
-	return 0;
-}
-
 static int kvm_trap_emul_vm_init(struct kvm *kvm)
 {
 	return 0;
@@ -471,8 +423,6 @@ static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
 	.dequeue_io_int = kvm_mips_dequeue_io_int_cb,
 	.irq_deliver = kvm_mips_irq_deliver_cb,
 	.irq_clear = kvm_mips_irq_clear_cb,
-	.vcpu_ioctl_get_regs = kvm_trap_emul_ioctl_get_regs,
-	.vcpu_ioctl_set_regs = kvm_trap_emul_ioctl_set_regs,
 };
 
 int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
-- 
1.7.11.7

