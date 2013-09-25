Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3IYKrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:47:04 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52921 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3IYKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:47:00 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 3/7] arm64: move encode_insn_immediate() from module.c to insn.c
Date: Wed, 25 Sep 2013 18:44:23 +0800
Message-Id: <1380105868-31985-4-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function encode_insn_immediate() will be used by other instruction
manipulate related functions, so move it into insn.c and rename it
as aarch64_insn_encode_immediate().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h |  14 ++++
 arch/arm64/kernel/insn.c      |  77 +++++++++++++++++++++
 arch/arm64/kernel/module.c    | 151 +++++++++---------------------------------
 3 files changed, 123 insertions(+), 119 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 0ea7193..0c715c1 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -28,6 +28,18 @@ enum aarch64_insn_class {
 					 * system instructions */
 };
 
+enum aarch64_insn_imm_type {
+	AARCH64_INSN_IMM_MOVNZ,
+	AARCH64_INSN_IMM_MOVK,
+	AARCH64_INSN_IMM_ADR,
+	AARCH64_INSN_IMM_26,
+	AARCH64_INSN_IMM_19,
+	AARCH64_INSN_IMM_16,
+	AARCH64_INSN_IMM_14,
+	AARCH64_INSN_IMM_12,
+	AARCH64_INSN_IMM_9,
+};
+
 #define	__AARCH64_INSN_FUNCS(abbr, mask, val)	\
 static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
 { return (code & (mask)) == (val); }	\
@@ -47,6 +59,8 @@ __AARCH64_INSN_FUNCS(nop,	0xFFFFFFFF, 0xD503201F)
 #undef	__AARCH64_INSN_FUNCS
 
 enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
+u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
+				  u32 insn, u64 imm);
 
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 int aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 50facfc..0bae0d9 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -133,3 +133,80 @@ int __kprobes aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
 
 	return ret;
 }
+
+u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
+				  u32 insn, u64 imm)
+{
+	u32 immlo, immhi, lomask, himask, mask;
+	int shift;
+
+	switch (type) {
+	case AARCH64_INSN_IMM_MOVNZ:
+		/*
+		 * For signed MOVW relocations, we have to manipulate the
+		 * instruction encoding depending on whether or not the
+		 * immediate is less than zero.
+		 */
+		insn &= ~(3 << 29);
+		if ((s64)imm >= 0) {
+			/* >=0: Set the instruction to MOVZ (opcode 10b). */
+			insn |= 2 << 29;
+		} else {
+			/*
+			 * <0: Set the instruction to MOVN (opcode 00b).
+			 *     Since we've masked the opcode already, we
+			 *     don't need to do anything other than
+			 *     inverting the new immediate field.
+			 */
+			imm = ~imm;
+		}
+	case AARCH64_INSN_IMM_MOVK:
+		mask = BIT(16) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_ADR:
+		lomask = 0x3;
+		himask = 0x7ffff;
+		immlo = imm & lomask;
+		imm >>= 2;
+		immhi = imm & himask;
+		imm = (immlo << 24) | (immhi);
+		mask = (lomask << 24) | (himask);
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_26:
+		mask = BIT(26) - 1;
+		shift = 0;
+		break;
+	case AARCH64_INSN_IMM_19:
+		mask = BIT(19) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_16:
+		mask = BIT(16) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_14:
+		mask = BIT(14) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_12:
+		mask = BIT(12) - 1;
+		shift = 10;
+		break;
+	case AARCH64_INSN_IMM_9:
+		mask = BIT(9) - 1;
+		shift = 12;
+		break;
+	default:
+		pr_err("aarch64_insn_encode_immediate: unknown immediate encoding %d\n",
+			type);
+		return 0;
+	}
+
+	/* Update the immediate field. */
+	insn &= ~(mask << shift);
+	insn |= (imm & mask) << shift;
+
+	return insn;
+}
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index ca0e3d5..69e3c31 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
+#include <asm/insn.h>
 
 void *module_alloc(unsigned long size)
 {
@@ -94,96 +95,8 @@ static int reloc_data(enum aarch64_reloc_op op, void *place, u64 val, int len)
 	return 0;
 }
 
-enum aarch64_imm_type {
-	INSN_IMM_MOVNZ,
-	INSN_IMM_MOVK,
-	INSN_IMM_ADR,
-	INSN_IMM_26,
-	INSN_IMM_19,
-	INSN_IMM_16,
-	INSN_IMM_14,
-	INSN_IMM_12,
-	INSN_IMM_9,
-};
-
-static u32 encode_insn_immediate(enum aarch64_imm_type type, u32 insn, u64 imm)
-{
-	u32 immlo, immhi, lomask, himask, mask;
-	int shift;
-
-	switch (type) {
-	case INSN_IMM_MOVNZ:
-		/*
-		 * For signed MOVW relocations, we have to manipulate the
-		 * instruction encoding depending on whether or not the
-		 * immediate is less than zero.
-		 */
-		insn &= ~(3 << 29);
-		if ((s64)imm >= 0) {
-			/* >=0: Set the instruction to MOVZ (opcode 10b). */
-			insn |= 2 << 29;
-		} else {
-			/*
-			 * <0: Set the instruction to MOVN (opcode 00b).
-			 *     Since we've masked the opcode already, we
-			 *     don't need to do anything other than
-			 *     inverting the new immediate field.
-			 */
-			imm = ~imm;
-		}
-	case INSN_IMM_MOVK:
-		mask = BIT(16) - 1;
-		shift = 5;
-		break;
-	case INSN_IMM_ADR:
-		lomask = 0x3;
-		himask = 0x7ffff;
-		immlo = imm & lomask;
-		imm >>= 2;
-		immhi = imm & himask;
-		imm = (immlo << 24) | (immhi);
-		mask = (lomask << 24) | (himask);
-		shift = 5;
-		break;
-	case INSN_IMM_26:
-		mask = BIT(26) - 1;
-		shift = 0;
-		break;
-	case INSN_IMM_19:
-		mask = BIT(19) - 1;
-		shift = 5;
-		break;
-	case INSN_IMM_16:
-		mask = BIT(16) - 1;
-		shift = 5;
-		break;
-	case INSN_IMM_14:
-		mask = BIT(14) - 1;
-		shift = 5;
-		break;
-	case INSN_IMM_12:
-		mask = BIT(12) - 1;
-		shift = 10;
-		break;
-	case INSN_IMM_9:
-		mask = BIT(9) - 1;
-		shift = 12;
-		break;
-	default:
-		pr_err("encode_insn_immediate: unknown immediate encoding %d\n",
-			type);
-		return 0;
-	}
-
-	/* Update the immediate field. */
-	insn &= ~(mask << shift);
-	insn |= (imm & mask) << shift;
-
-	return insn;
-}
-
 static int reloc_insn_movw(enum aarch64_reloc_op op, void *place, u64 val,
-			   int lsb, enum aarch64_imm_type imm_type)
+			   int lsb, enum aarch64_insn_imm_type imm_type)
 {
 	u64 imm, limit = 0;
 	s64 sval;
@@ -194,7 +107,7 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, void *place, u64 val,
 	imm = sval & 0xffff;
 
 	/* Update the instruction with the new encoding. */
-	*(u32 *)place = encode_insn_immediate(imm_type, insn, imm);
+	*(u32 *)place = aarch64_insn_encode_immediate(imm_type, insn, imm);
 
 	/* Shift out the immediate field. */
 	sval >>= 16;
@@ -203,9 +116,9 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, void *place, u64 val,
 	 * For unsigned immediates, the overflow check is straightforward.
 	 * For signed immediates, the sign bit is actually the bit past the
 	 * most significant bit of the field.
-	 * The INSN_IMM_16 immediate type is unsigned.
+	 * The AARCH64_INSN_IMM_16 immediate type is unsigned.
 	 */
-	if (imm_type != INSN_IMM_16) {
+	if (imm_type != AARCH64_INSN_IMM_16) {
 		sval++;
 		limit++;
 	}
@@ -218,7 +131,7 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, void *place, u64 val,
 }
 
 static int reloc_insn_imm(enum aarch64_reloc_op op, void *place, u64 val,
-			  int lsb, int len, enum aarch64_imm_type imm_type)
+			  int lsb, int len, enum aarch64_insn_imm_type imm_type)
 {
 	u64 imm, imm_mask;
 	s64 sval;
@@ -233,7 +146,7 @@ static int reloc_insn_imm(enum aarch64_reloc_op op, void *place, u64 val,
 	imm = sval & imm_mask;
 
 	/* Update the instruction's immediate field. */
-	*(u32 *)place = encode_insn_immediate(imm_type, insn, imm);
+	*(u32 *)place = aarch64_insn_encode_immediate(imm_type, insn, imm);
 
 	/*
 	 * Extract the upper value bits (including the sign bit) and
@@ -315,125 +228,125 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			overflow_check = false;
 		case R_AARCH64_MOVW_UABS_G0:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,
-					      INSN_IMM_16);
+					      AARCH64_INSN_IMM_16);
 			break;
 		case R_AARCH64_MOVW_UABS_G1_NC:
 			overflow_check = false;
 		case R_AARCH64_MOVW_UABS_G1:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,
-					      INSN_IMM_16);
+					      AARCH64_INSN_IMM_16);
 			break;
 		case R_AARCH64_MOVW_UABS_G2_NC:
 			overflow_check = false;
 		case R_AARCH64_MOVW_UABS_G2:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,
-					      INSN_IMM_16);
+					      AARCH64_INSN_IMM_16);
 			break;
 		case R_AARCH64_MOVW_UABS_G3:
 			/* We're using the top bits so we can't overflow. */
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 48,
-					      INSN_IMM_16);
+					      AARCH64_INSN_IMM_16);
 			break;
 		case R_AARCH64_MOVW_SABS_G0:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 		case R_AARCH64_MOVW_SABS_G1:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 		case R_AARCH64_MOVW_SABS_G2:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 		case R_AARCH64_MOVW_PREL_G0_NC:
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,
-					      INSN_IMM_MOVK);
+					      AARCH64_INSN_IMM_MOVK);
 			break;
 		case R_AARCH64_MOVW_PREL_G0:
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 		case R_AARCH64_MOVW_PREL_G1_NC:
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,
-					      INSN_IMM_MOVK);
+					      AARCH64_INSN_IMM_MOVK);
 			break;
 		case R_AARCH64_MOVW_PREL_G1:
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 		case R_AARCH64_MOVW_PREL_G2_NC:
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,
-					      INSN_IMM_MOVK);
+					      AARCH64_INSN_IMM_MOVK);
 			break;
 		case R_AARCH64_MOVW_PREL_G2:
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 		case R_AARCH64_MOVW_PREL_G3:
 			/* We're using the top bits so we can't overflow. */
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 48,
-					      INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ);
 			break;
 
 		/* Immediate instruction relocations. */
 		case R_AARCH64_LD_PREL_LO19:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,
-					     INSN_IMM_19);
+					     AARCH64_INSN_IMM_19);
 			break;
 		case R_AARCH64_ADR_PREL_LO21:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 0, 21,
-					     INSN_IMM_ADR);
+					     AARCH64_INSN_IMM_ADR);
 			break;
 		case R_AARCH64_ADR_PREL_PG_HI21_NC:
 			overflow_check = false;
 		case R_AARCH64_ADR_PREL_PG_HI21:
 			ovf = reloc_insn_imm(RELOC_OP_PAGE, loc, val, 12, 21,
-					     INSN_IMM_ADR);
+					     AARCH64_INSN_IMM_ADR);
 			break;
 		case R_AARCH64_ADD_ABS_LO12_NC:
 		case R_AARCH64_LDST8_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 0, 12,
-					     INSN_IMM_12);
+					     AARCH64_INSN_IMM_12);
 			break;
 		case R_AARCH64_LDST16_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 1, 11,
-					     INSN_IMM_12);
+					     AARCH64_INSN_IMM_12);
 			break;
 		case R_AARCH64_LDST32_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 2, 10,
-					     INSN_IMM_12);
+					     AARCH64_INSN_IMM_12);
 			break;
 		case R_AARCH64_LDST64_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 3, 9,
-					     INSN_IMM_12);
+					     AARCH64_INSN_IMM_12);
 			break;
 		case R_AARCH64_LDST128_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 4, 8,
-					     INSN_IMM_12);
+					     AARCH64_INSN_IMM_12);
 			break;
 		case R_AARCH64_TSTBR14:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 14,
-					     INSN_IMM_14);
+					     AARCH64_INSN_IMM_14);
 			break;
 		case R_AARCH64_CONDBR19:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,
-					     INSN_IMM_19);
+					     AARCH64_INSN_IMM_19);
 			break;
 		case R_AARCH64_JUMP26:
 		case R_AARCH64_CALL26:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 26,
-					     INSN_IMM_26);
+					     AARCH64_INSN_IMM_26);
 			break;
 
 		default:
-- 
1.8.1.2

