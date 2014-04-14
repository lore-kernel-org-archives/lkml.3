Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaDNRpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:45:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39964 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbaDNRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:44:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: vegard.nossum@oracle.com, penberg@kernel.org
Cc: jamie.iles@oracle.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 4/4] kmemcheck: Switch to using kernel disassembler
Date: Mon, 14 Apr 2014 13:44:10 -0400
Message-Id: <1397497450-6440-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemcheck used to do it's own basic instruction decoding, which is
just a duplication of the work done in arch/x86/lib/insn.c.

Instead, switch it to using the already existing dissasembler, and
switch the magic opcode numbers into something meaningful.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/mm/kmemcheck/Makefile    |    2 +-
 arch/x86/mm/kmemcheck/kmemcheck.c |  105 ++++++++++++++++++------------------
 arch/x86/mm/kmemcheck/opcode.c    |  106 -------------------------------------
 arch/x86/mm/kmemcheck/opcode.h    |    9 ----
 arch/x86/mm/kmemcheck/selftest.c  |   12 +++--
 arch/x86/mm/kmemcheck/selftest.h  |    1 +
 6 files changed, 61 insertions(+), 174 deletions(-)
 delete mode 100644 arch/x86/mm/kmemcheck/opcode.c
 delete mode 100644 arch/x86/mm/kmemcheck/opcode.h

diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
index 520b3bc..f1749ad 100644
--- a/arch/x86/mm/kmemcheck/Makefile
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -1 +1 @@
-obj-y := error.o kmemcheck.o opcode.o pte.o selftest.o shadow.o
+obj-y := error.o kmemcheck.o pte.o selftest.o shadow.o
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index dd89a13..571664d 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -25,9 +25,10 @@
 #include <asm/kmemcheck.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/insn.h>
+#include <asm/inat-tables.h>
 
 #include "error.h"
-#include "opcode.h"
 #include "pte.h"
 #include "selftest.h"
 #include "shadow.h"
@@ -521,13 +522,30 @@ enum kmemcheck_method {
 	KMEMCHECK_WRITE,
 };
 
+char kmemcheck_get_addr_size(struct insn *insn)
+{
+	switch (insn->opcode.value) {
+	case 0xa4:
+	case 0xbe0f:
+	case 0xb60f:
+		return 1;
+
+	case 0xbf0f:
+	case 0xb70f:
+		return 2;
+	case 0x63:
+		if (!X86_REX_W(insn->rex_prefix.value))
+			break;
+		return 4;
+	}
+
+	return insn->mem_bytes;
+}
+
 static void kmemcheck_access(struct pt_regs *regs,
 	unsigned long fallback_address, enum kmemcheck_method fallback_method)
 {
-	const uint8_t *insn;
-	const uint8_t *insn_primary;
-	unsigned int size;
-
+	struct insn insn;
 	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
 
 	/* Recursive fault -- ouch. */
@@ -539,63 +557,42 @@ static void kmemcheck_access(struct pt_regs *regs,
 
 	data->busy = true;
 
-	insn = (const uint8_t *) regs->ip;
-	insn_primary = kmemcheck_opcode_get_primary(insn);
-
-	kmemcheck_opcode_decode(insn, &size);
+	kernel_insn_init(&insn, (const void *)regs->ip);
+	insn_get_length(&insn);
 
-	switch (insn_primary[0]) {
+	switch (insn.mnemonic) {
 #ifdef CONFIG_KMEMCHECK_BITOPS_OK
-		/* AND, OR, XOR */
-		/*
-		 * Unfortunately, these instructions have to be excluded from
-		 * our regular checking since they access only some (and not
-		 * all) bits. This clears out "bogus" bitfield-access warnings.
-		 */
-	case 0x80:
-	case 0x81:
-	case 0x82:
-	case 0x83:
-		switch ((insn_primary[1] >> 3) & 7) {
-			/* OR */
-		case 1:
-			/* AND */
-		case 4:
-			/* XOR */
-		case 6:
-			kmemcheck_write(regs, fallback_address, size);
-			goto out;
-
-			/* ADD */
-		case 0:
-			/* ADC */
-		case 2:
-			/* SBB */
-		case 3:
-			/* SUB */
-		case 5:
-			/* CMP */
-		case 7:
-			break;
-		}
+	/*
+	 * Unfortunately, these instructions have to be excluded from
+	 * our regular checking since they access only some (and not
+	 * all) bits. This clears out "bogus" bitfield-access warnings.
+	 */
+	case INSN_OPC_OR:
+	case INSN_OPC_AND:
+	case INSN_OPC_XOR:
+		kmemcheck_write(regs, fallback_address, insn.mem_bytes);
+		goto out;
+
+	case INSN_OPC_ADD:
+	case INSN_OPC_ADC:
+	case INSN_OPC_SBB:
+	case INSN_OPC_SUB:
+	case INSN_OPC_CMP:
 		break;
 #endif
-
-		/* MOVS, MOVSB, MOVSW, MOVSD */
-	case 0xa4:
-	case 0xa5:
+	case INSN_OPC_MOVS_B:
+	case INSN_OPC_MOVS_W_D_Q:
 		/*
 		 * These instructions are special because they take two
 		 * addresses, but we only get one page fault.
 		 */
-		kmemcheck_copy(regs, regs->si, regs->di, size);
+		kmemcheck_copy(regs, regs->si, regs->di, insn.mem_bytes);
 		goto out;
 
-		/* CMPS, CMPSB, CMPSW, CMPSD */
-	case 0xa6:
-	case 0xa7:
-		kmemcheck_read(regs, regs->si, size);
-		kmemcheck_read(regs, regs->di, size);
+	case INSN_OPC_CMPS_B:
+	case INSN_OPC_CMPS_W_D:
+		kmemcheck_read(regs, regs->si, insn.mem_bytes);
+		kmemcheck_read(regs, regs->di, insn.mem_bytes);
 		goto out;
 	}
 
@@ -606,10 +603,10 @@ static void kmemcheck_access(struct pt_regs *regs,
 	 */
 	switch (fallback_method) {
 	case KMEMCHECK_READ:
-		kmemcheck_read(regs, fallback_address, size);
+		kmemcheck_read(regs, fallback_address, insn.mem_bytes);
 		goto out;
 	case KMEMCHECK_WRITE:
-		kmemcheck_write(regs, fallback_address, size);
+		kmemcheck_write(regs, fallback_address, insn.mem_bytes);
 		goto out;
 	}
 
diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
deleted file mode 100644
index 324aa3f..0000000
--- a/arch/x86/mm/kmemcheck/opcode.c
+++ /dev/null
@@ -1,106 +0,0 @@
-#include <linux/types.h>
-
-#include "opcode.h"
-
-static bool opcode_is_prefix(uint8_t b)
-{
-	return
-		/* Group 1 */
-		b == 0xf0 || b == 0xf2 || b == 0xf3
-		/* Group 2 */
-		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
-		|| b == 0x64 || b == 0x65
-		/* Group 3 */
-		|| b == 0x66
-		/* Group 4 */
-		|| b == 0x67;
-}
-
-#ifdef CONFIG_X86_64
-static bool opcode_is_rex_prefix(uint8_t b)
-{
-	return (b & 0xf0) == 0x40;
-}
-#else
-static bool opcode_is_rex_prefix(uint8_t b)
-{
-	return false;
-}
-#endif
-
-#define REX_W (1 << 3)
-
-/*
- * This is a VERY crude opcode decoder. We only need to find the size of the
- * load/store that caused our #PF and this should work for all the opcodes
- * that we care about. Moreover, the ones who invented this instruction set
- * should be shot.
- */
-void kmemcheck_opcode_decode(const uint8_t *op, unsigned int *size)
-{
-	/* Default operand size */
-	int operand_size_override = 4;
-
-	/* prefixes */
-	for (; opcode_is_prefix(*op); ++op) {
-		if (*op == 0x66)
-			operand_size_override = 2;
-	}
-
-	/* REX prefix */
-	if (opcode_is_rex_prefix(*op)) {
-		uint8_t rex = *op;
-
-		++op;
-		if (rex & REX_W) {
-			switch (*op) {
-			case 0x63:
-				*size = 4;
-				return;
-			case 0x0f:
-				++op;
-
-				switch (*op) {
-				case 0xb6:
-				case 0xbe:
-					*size = 1;
-					return;
-				case 0xb7:
-				case 0xbf:
-					*size = 2;
-					return;
-				}
-
-				break;
-			}
-
-			*size = 8;
-			return;
-		}
-	}
-
-	/* escape opcode */
-	if (*op == 0x0f) {
-		++op;
-
-		/*
-		 * This is move with zero-extend and sign-extend, respectively;
-		 * we don't have to think about 0xb6/0xbe, because this is
-		 * already handled in the conditional below.
-		 */
-		if (*op == 0xb7 || *op == 0xbf)
-			operand_size_override = 2;
-	}
-
-	*size = (*op & 1) ? operand_size_override : 1;
-}
-
-const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op)
-{
-	/* skip prefixes */
-	while (opcode_is_prefix(*op))
-		++op;
-	if (opcode_is_rex_prefix(*op))
-		++op;
-	return op;
-}
diff --git a/arch/x86/mm/kmemcheck/opcode.h b/arch/x86/mm/kmemcheck/opcode.h
deleted file mode 100644
index 6956aad..0000000
--- a/arch/x86/mm/kmemcheck/opcode.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef ARCH__X86__MM__KMEMCHECK__OPCODE_H
-#define ARCH__X86__MM__KMEMCHECK__OPCODE_H
-
-#include <linux/types.h>
-
-void kmemcheck_opcode_decode(const uint8_t *op, unsigned int *size);
-const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op);
-
-#endif
diff --git a/arch/x86/mm/kmemcheck/selftest.c b/arch/x86/mm/kmemcheck/selftest.c
index c898d33..8976938 100644
--- a/arch/x86/mm/kmemcheck/selftest.c
+++ b/arch/x86/mm/kmemcheck/selftest.c
@@ -1,7 +1,9 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 
-#include "opcode.h"
+#include <asm/insn.h>
+#include <asm/inat-tables.h>
+
 #include "selftest.h"
 
 struct selftest_opcode {
@@ -46,10 +48,12 @@ static const struct selftest_opcode selftest_opcodes[] = {
 
 static bool selftest_opcode_one(const struct selftest_opcode *op)
 {
-	unsigned size;
-
-	kmemcheck_opcode_decode(op->insn, &size);
+	struct insn insn;
+	char size;
 
+	kernel_insn_init(&insn, op->insn);
+	insn_get_length(&insn);
+	size = kmemcheck_get_addr_size(&insn);
 	if (size == op->expected_size)
 		return true;
 
diff --git a/arch/x86/mm/kmemcheck/selftest.h b/arch/x86/mm/kmemcheck/selftest.h
index 8fed4fe..4cd1c5e 100644
--- a/arch/x86/mm/kmemcheck/selftest.h
+++ b/arch/x86/mm/kmemcheck/selftest.h
@@ -2,5 +2,6 @@
 #define ARCH_X86_MM_KMEMCHECK_SELFTEST_H
 
 bool kmemcheck_selftest(void);
+extern char kmemcheck_get_addr_size(struct insn *insn);
 
 #endif
-- 
1.7.10.4

