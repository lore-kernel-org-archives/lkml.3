Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaAJR6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:58:43 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34797 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaAJR6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:58:41 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Jon Medhurst <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] ARM: kprobes: fix instruction fetch order with <asm/opcodes.h>
Date: Fri, 10 Jan 2014 19:58:22 +0200
Message-Id: <1389376706-30051-2-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

If we are running BE8, the data and instruction endianness do not
match, so use <asm/opcodes.h> to correctly translate memory accesses
into ARM instructions.

Acked-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[taras.kondratiuk@linaro.org: fixed Thumb instruction fetch order]
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/kernel/kprobes-common.c |   19 +++++++++++--------
 arch/arm/kernel/kprobes-thumb.c  |   20 ++++++++++++--------
 arch/arm/kernel/kprobes.c        |    9 +++++----
 3 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 18a7628..380c20f 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <asm/system_info.h>
+#include <asm/opcodes.h>
 
 #include "kprobes.h"
 
@@ -305,7 +306,8 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 
 	if (handler) {
 		/* We can emulate the instruction in (possibly) modified form */
-		asi->insn[0] = (insn & 0xfff00000) | (rn << 16) | reglist;
+		asi->insn[0] = __opcode_to_mem_arm((insn & 0xfff00000) |
+						   (rn << 16) | reglist);
 		asi->insn_handler = handler;
 		return INSN_GOOD;
 	}
@@ -334,13 +336,14 @@ prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 #ifdef CONFIG_THUMB2_KERNEL
 	if (thumb) {
 		u16 *thumb_insn = (u16 *)asi->insn;
-		thumb_insn[1] = 0x4770; /* Thumb bx lr */
-		thumb_insn[2] = 0x4770; /* Thumb bx lr */
+		/* Thumb bx lr */
+		thumb_insn[1] = __opcode_to_mem_thumb16(0x4770);
+		thumb_insn[2] = __opcode_to_mem_thumb16(0x4770);
 		return insn;
 	}
-	asi->insn[1] = 0xe12fff1e; /* ARM bx lr */
+	asi->insn[1] = __opcode_to_mem_arm(0xe12fff1e); /* ARM bx lr */
 #else
-	asi->insn[1] = 0xe1a0f00e; /* mov pc, lr */
+	asi->insn[1] = __opcode_to_mem_arm(0xe1a0f00e); /* mov pc, lr */
 #endif
 	/* Make an ARM instruction unconditional */
 	if (insn < 0xe0000000)
@@ -360,12 +363,12 @@ set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	if (thumb) {
 		u16 *ip = (u16 *)asi->insn;
 		if (is_wide_instruction(insn))
-			*ip++ = insn >> 16;
-		*ip++ = insn;
+			*ip++ = __opcode_to_mem_thumb16(insn >> 16);
+		*ip++ = __opcode_to_mem_thumb16(insn);
 		return;
 	}
 #endif
-	asi->insn[0] = insn;
+	asi->insn[0] = __opcode_to_mem_arm(insn);
 }
 
 /*
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 6123daf..b82e798 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -163,9 +163,9 @@ t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi);
 
 	/* Fixup modified instruction to have halfwords in correct order...*/
-	insn = asi->insn[0];
-	((u16 *)asi->insn)[0] = insn >> 16;
-	((u16 *)asi->insn)[1] = insn & 0xffff;
+	insn = __mem_to_opcode_arm(asi->insn[0]);
+	((u16 *)asi->insn)[0] = __opcode_to_mem_thumb16(insn >> 16);
+	((u16 *)asi->insn)[1] = __opcode_to_mem_thumb16(insn & 0xffff);
 
 	return ret;
 }
@@ -1153,7 +1153,7 @@ t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 {
 	insn &= ~0x00ff;
 	insn |= 0x001; /* Set Rdn = R1 and Rm = R0 */
-	((u16 *)asi->insn)[0] = insn;
+	((u16 *)asi->insn)[0] = __opcode_to_mem_thumb16(insn);
 	asi->insn_handler = t16_emulate_hiregs;
 	return INSN_GOOD;
 }
@@ -1182,8 +1182,10 @@ t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 	 * and call it with R9=SP and LR in the register list represented
 	 * by R8.
 	 */
-	((u16 *)asi->insn)[0] = 0xe929;		/* 1st half STMDB R9!,{} */
-	((u16 *)asi->insn)[1] = insn & 0x1ff;	/* 2nd half (register list) */
+	/* 1st half STMDB R9!,{} */
+	((u16 *)asi->insn)[0] = __opcode_to_mem_thumb16(0xe929);
+	/* 2nd half (register list) */
+	((u16 *)asi->insn)[1] = __opcode_to_mem_thumb16(insn & 0x1ff);
 	asi->insn_handler = t16_emulate_push;
 	return INSN_GOOD;
 }
@@ -1232,8 +1234,10 @@ t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 	 * and call it with R9=SP and PC in the register list represented
 	 * by R8.
 	 */
-	((u16 *)asi->insn)[0] = 0xe8b9;		/* 1st half LDMIA R9!,{} */
-	((u16 *)asi->insn)[1] = insn & 0x1ff;	/* 2nd half (register list) */
+	/* 1st half LDMIA R9!,{} */
+	((u16 *)asi->insn)[0] = __opcode_to_mem_thumb16(0xe8b9);
+	/* 2nd half (register list) */
+	((u16 *)asi->insn)[1] = __opcode_to_mem_thumb16(insn & 0x1ff);
 	asi->insn_handler = insn & 0x100 ? t16_emulate_pop_pc
 					 : t16_emulate_pop_nopc;
 	return INSN_GOOD;
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index a7b621e..49a87b6 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -26,6 +26,7 @@
 #include <linux/stop_machine.h>
 #include <linux/stringify.h>
 #include <asm/traps.h>
+#include <asm/opcodes.h>
 #include <asm/cacheflush.h>
 
 #include "kprobes.h"
@@ -62,10 +63,10 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 #ifdef CONFIG_THUMB2_KERNEL
 	thumb = true;
 	addr &= ~1; /* Bit 0 would normally be set to indicate Thumb code */
-	insn = ((u16 *)addr)[0];
+	insn = __mem_to_opcode_thumb16(((u16 *)addr)[0]);
 	if (is_wide_instruction(insn)) {
-		insn <<= 16;
-		insn |= ((u16 *)addr)[1];
+		u16 inst2 = __mem_to_opcode_thumb16(((u16 *)addr)[1]);
+		insn = __opcode_thumb32_compose(insn, inst2);
 		decode_insn = thumb32_kprobe_decode_insn;
 	} else
 		decode_insn = thumb16_kprobe_decode_insn;
@@ -73,7 +74,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	thumb = false;
 	if (addr & 0x3)
 		return -EINVAL;
-	insn = *p->addr;
+	insn = __mem_to_opcode_arm(*p->addr);
 	decode_insn = arm_kprobe_decode_insn;
 #endif
 
-- 
1.7.9.5

