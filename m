Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3FJTeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:34:12 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55440 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3FJTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:33:58 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] mips/kvm: Use KVM_REG_MIPS and proper size indicators for *_ONE_REG
Date: Mon, 10 Jun 2013 12:33:48 -0700
Message-Id: <1370892828-21676-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The API requires that the GET_ONE_REG and SET_ONE_REG ioctls have this
extra information encoded in the register identifiers.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/uapi/asm/kvm.h | 81 +++++++++++++++++++--------------------
 arch/mips/kvm/kvm_mips.c         | 83 ++++++++++++++++++++++++++--------------
 2 files changed, 93 insertions(+), 71 deletions(-)

diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
index 3f424f5..f09ff5a 100644
--- a/arch/mips/include/uapi/asm/kvm.h
+++ b/arch/mips/include/uapi/asm/kvm.h
@@ -58,56 +58,53 @@ struct kvm_fpu {
  *  bits[2..0]   - Register 'sel' index.
  *  bits[7..3]   - Register 'rd'  index.
  *  bits[15..8]  - Must be zero.
- *  bits[63..16] - 1 -> CP0 registers.
+ *  bits[31..16] - 1 -> CP0 registers.
+ *  bits[51..32] - Must be zero.
+ *  bits[63..52] - As per linux/kvm.h
  *
  * Other sets registers may be added in the future.  Each set would
- * have its own identifier in bits[63..16].
- *
- * The addr field of struct kvm_one_reg must point to an aligned
- * 64-bit wide location.  For registers that are narrower than
- * 64-bits, the value is stored in the low order bits of the location,
- * and sign extended to 64-bits.
+ * have its own identifier in bits[31..16].
  *
  * The registers defined in struct kvm_regs are also accessible, the
  * id values for these are below.
  */
 
-#define KVM_REG_MIPS_R0 0
-#define KVM_REG_MIPS_R1 1
-#define KVM_REG_MIPS_R2 2
-#define KVM_REG_MIPS_R3 3
-#define KVM_REG_MIPS_R4 4
-#define KVM_REG_MIPS_R5 5
-#define KVM_REG_MIPS_R6 6
-#define KVM_REG_MIPS_R7 7
-#define KVM_REG_MIPS_R8 8
-#define KVM_REG_MIPS_R9 9
-#define KVM_REG_MIPS_R10 10
-#define KVM_REG_MIPS_R11 11
-#define KVM_REG_MIPS_R12 12
-#define KVM_REG_MIPS_R13 13
-#define KVM_REG_MIPS_R14 14
-#define KVM_REG_MIPS_R15 15
-#define KVM_REG_MIPS_R16 16
-#define KVM_REG_MIPS_R17 17
-#define KVM_REG_MIPS_R18 18
-#define KVM_REG_MIPS_R19 19
-#define KVM_REG_MIPS_R20 20
-#define KVM_REG_MIPS_R21 21
-#define KVM_REG_MIPS_R22 22
-#define KVM_REG_MIPS_R23 23
-#define KVM_REG_MIPS_R24 24
-#define KVM_REG_MIPS_R25 25
-#define KVM_REG_MIPS_R26 26
-#define KVM_REG_MIPS_R27 27
-#define KVM_REG_MIPS_R28 28
-#define KVM_REG_MIPS_R29 29
-#define KVM_REG_MIPS_R30 30
-#define KVM_REG_MIPS_R31 31
+#define KVM_REG_MIPS_R0 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 0)
+#define KVM_REG_MIPS_R1 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 1)
+#define KVM_REG_MIPS_R2 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 2)
+#define KVM_REG_MIPS_R3 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 3)
+#define KVM_REG_MIPS_R4 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 4)
+#define KVM_REG_MIPS_R5 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 5)
+#define KVM_REG_MIPS_R6 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 6)
+#define KVM_REG_MIPS_R7 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 7)
+#define KVM_REG_MIPS_R8 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 8)
+#define KVM_REG_MIPS_R9 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 9)
+#define KVM_REG_MIPS_R10 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 10)
+#define KVM_REG_MIPS_R11 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 11)
+#define KVM_REG_MIPS_R12 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 12)
+#define KVM_REG_MIPS_R13 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 13)
+#define KVM_REG_MIPS_R14 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 14)
+#define KVM_REG_MIPS_R15 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 15)
+#define KVM_REG_MIPS_R16 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 16)
+#define KVM_REG_MIPS_R17 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 17)
+#define KVM_REG_MIPS_R18 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 18)
+#define KVM_REG_MIPS_R19 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 19)
+#define KVM_REG_MIPS_R20 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 20)
+#define KVM_REG_MIPS_R21 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 21)
+#define KVM_REG_MIPS_R22 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 22)
+#define KVM_REG_MIPS_R23 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 23)
+#define KVM_REG_MIPS_R24 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 24)
+#define KVM_REG_MIPS_R25 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 25)
+#define KVM_REG_MIPS_R26 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 26)
+#define KVM_REG_MIPS_R27 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 27)
+#define KVM_REG_MIPS_R28 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 28)
+#define KVM_REG_MIPS_R29 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 29)
+#define KVM_REG_MIPS_R30 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 30)
+#define KVM_REG_MIPS_R31 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 31)
 
-#define KVM_REG_MIPS_HI 32
-#define KVM_REG_MIPS_LO 33
-#define KVM_REG_MIPS_PC 34
+#define KVM_REG_MIPS_HI (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 32)
+#define KVM_REG_MIPS_LO (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 33)
+#define KVM_REG_MIPS_PC (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 34)
 
 /*
  * KVM MIPS specific structures and definitions
diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index d934b01..dd203e5 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -485,29 +485,35 @@ kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return -ENOIOCTLCMD;
 }
 
-#define KVM_REG_MIPS_CP0_INDEX (0x10000 + 8 * 0 + 0)
-#define KVM_REG_MIPS_CP0_ENTRYLO0 (0x10000 + 8 * 2 + 0)
-#define KVM_REG_MIPS_CP0_ENTRYLO1 (0x10000 + 8 * 3 + 0)
-#define KVM_REG_MIPS_CP0_CONTEXT (0x10000 + 8 * 4 + 0)
-#define KVM_REG_MIPS_CP0_USERLOCAL (0x10000 + 8 * 4 + 2)
-#define KVM_REG_MIPS_CP0_PAGEMASK (0x10000 + 8 * 5 + 0)
-#define KVM_REG_MIPS_CP0_PAGEGRAIN (0x10000 + 8 * 5 + 1)
-#define KVM_REG_MIPS_CP0_WIRED (0x10000 + 8 * 6 + 0)
-#define KVM_REG_MIPS_CP0_HWRENA (0x10000 + 8 * 7 + 0)
-#define KVM_REG_MIPS_CP0_BADVADDR (0x10000 + 8 * 8 + 0)
-#define KVM_REG_MIPS_CP0_COUNT (0x10000 + 8 * 9 + 0)
-#define KVM_REG_MIPS_CP0_ENTRYHI (0x10000 + 8 * 10 + 0)
-#define KVM_REG_MIPS_CP0_COMPARE (0x10000 + 8 * 11 + 0)
-#define KVM_REG_MIPS_CP0_STATUS (0x10000 + 8 * 12 + 0)
-#define KVM_REG_MIPS_CP0_CAUSE (0x10000 + 8 * 13 + 0)
-#define KVM_REG_MIPS_CP0_EBASE (0x10000 + 8 * 15 + 1)
-#define KVM_REG_MIPS_CP0_CONFIG (0x10000 + 8 * 16 + 0)
-#define KVM_REG_MIPS_CP0_CONFIG1 (0x10000 + 8 * 16 + 1)
-#define KVM_REG_MIPS_CP0_CONFIG2 (0x10000 + 8 * 16 + 2)
-#define KVM_REG_MIPS_CP0_CONFIG3 (0x10000 + 8 * 16 + 3)
-#define KVM_REG_MIPS_CP0_CONFIG7 (0x10000 + 8 * 16 + 7)
-#define KVM_REG_MIPS_CP0_XCONTEXT (0x10000 + 8 * 20 + 0)
-#define KVM_REG_MIPS_CP0_ERROREPC (0x10000 + 8 * 30 + 0)
+#define MIPS_CP0_32(_R, _S)					\
+	(KVM_REG_MIPS | KVM_REG_SIZE_U32 | 0x10000 | (8 * (_R) + (_S)))
+
+#define MIPS_CP0_64(_R, _S)					\
+	(KVM_REG_MIPS | KVM_REG_SIZE_U64 | 0x10000 | (8 * (_R) + (_S)))
+
+#define KVM_REG_MIPS_CP0_INDEX		MIPS_CP0_32(0, 0)
+#define KVM_REG_MIPS_CP0_ENTRYLO0	MIPS_CP0_64(2, 0)
+#define KVM_REG_MIPS_CP0_ENTRYLO1	MIPS_CP0_64(3, 0)
+#define KVM_REG_MIPS_CP0_CONTEXT	MIPS_CP0_64(4, 0)
+#define KVM_REG_MIPS_CP0_USERLOCAL	MIPS_CP0_64(4, 2)
+#define KVM_REG_MIPS_CP0_PAGEMASK	MIPS_CP0_32(5, 0)
+#define KVM_REG_MIPS_CP0_PAGEGRAIN	MIPS_CP0_32(5, 1)
+#define KVM_REG_MIPS_CP0_WIRED		MIPS_CP0_32(6, 0)
+#define KVM_REG_MIPS_CP0_HWRENA		MIPS_CP0_32(7, 0)
+#define KVM_REG_MIPS_CP0_BADVADDR	MIPS_CP0_64(8, 0)
+#define KVM_REG_MIPS_CP0_COUNT		MIPS_CP0_32(9, 0)
+#define KVM_REG_MIPS_CP0_ENTRYHI	MIPS_CP0_64(10, 0)
+#define KVM_REG_MIPS_CP0_COMPARE	MIPS_CP0_32(11, 0)
+#define KVM_REG_MIPS_CP0_STATUS		MIPS_CP0_32(12, 0)
+#define KVM_REG_MIPS_CP0_CAUSE		MIPS_CP0_32(13, 0)
+#define KVM_REG_MIPS_CP0_EBASE		MIPS_CP0_64(15, 1)
+#define KVM_REG_MIPS_CP0_CONFIG		MIPS_CP0_32(16, 0)
+#define KVM_REG_MIPS_CP0_CONFIG1	MIPS_CP0_32(16, 1)
+#define KVM_REG_MIPS_CP0_CONFIG2	MIPS_CP0_32(16, 2)
+#define KVM_REG_MIPS_CP0_CONFIG3	MIPS_CP0_32(16, 3)
+#define KVM_REG_MIPS_CP0_CONFIG7	MIPS_CP0_32(16, 7)
+#define KVM_REG_MIPS_CP0_XCONTEXT	MIPS_CP0_64(20, 0)
+#define KVM_REG_MIPS_CP0_ERROREPC	MIPS_CP0_64(30, 0)
 
 static u64 kvm_mips_get_one_regs[] = {
 	KVM_REG_MIPS_R0,
@@ -567,8 +573,6 @@ static u64 kvm_mips_get_one_regs[] = {
 static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 			    const struct kvm_one_reg *reg)
 {
-	u64 __user *uaddr = (u64 __user *)(long)reg->addr;
-
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
 	s64 v;
 
@@ -631,18 +635,39 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 	default:
 		return -EINVAL;
 	}
-	return put_user(v, uaddr);
+	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
+		u64 __user *uaddr64 = (u64 __user *)(long)reg->addr;
+		return put_user(v, uaddr64);
+	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U32) {
+		u32 __user *uaddr32 = (u32 __user *)(long)reg->addr;
+		u32 v32 = (u32)v;
+		return put_user(v32, uaddr32);
+	} else {
+		return -EINVAL;
+	}
 }
 
 static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
 			    const struct kvm_one_reg *reg)
 {
-	u64 __user *uaddr = (u64 __user *)(long)reg->addr;
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
 	u64 v;
 
-	if (get_user(v, uaddr) != 0)
-		return -EFAULT;
+	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
+		u64 __user *uaddr64 = (u64 __user *)(long)reg->addr;
+
+		if (get_user(v, uaddr64) != 0)
+			return -EFAULT;
+	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U32) {
+		u32 __user *uaddr32 = (u32 __user *)(long)reg->addr;
+		s32 v32;
+
+		if (get_user(v32, uaddr32) != 0)
+			return -EFAULT;
+		v = (s64)v32;
+	} else {
+		return -EINVAL;
+	}
 
 	switch (reg->id) {
 	case KVM_REG_MIPS_R0:
-- 
1.7.11.7

