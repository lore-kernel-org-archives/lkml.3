Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaJXIjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:39:10 -0400
Received: from mail-bn1bn0100.outbound.protection.outlook.com ([157.56.110.100]:32384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbaJXIYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:24:49 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 02/29] nios2: Assembly macros and definitions
Date: Fri, 24 Oct 2014 16:24:04 +0800
Message-ID: <1414139071-3818-3-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(80022003)(99396003)(102836001)(93916002)(21056001)(50986999)(84676001)(19580405001)(68736004)(19580395003)(97736003)(92726001)(86362001)(120916001)(76482002)(77156001)(36756003)(46102003)(2201001)(92566001)(42186005)(95666004)(64706001)(87286001)(31966008)(50226001)(50466002)(20776003)(47776003)(229853001)(44976005)(33646002)(85852003)(88136002)(87936001)(15202345003)(105596002)(48376002)(6806004)(4396001)(76176999)(85306004)(15975445006)(89996001)(104166001)(62966002)(107046002)(77096002)(106466001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB220;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB220;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add assembly macros and definitions used in
the .S files across arch/nios2/ and together with asm-offsets.c.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/asm-macros.h  | 309 +++++++++++++++++++++++++++++++++++
 arch/nios2/include/asm/asm-offsets.h |  20 +++
 arch/nios2/kernel/asm-offsets.c      |  88 ++++++++++
 3 files changed, 417 insertions(+)
 create mode 100644 arch/nios2/include/asm/asm-macros.h
 create mode 100644 arch/nios2/include/asm/asm-offsets.h
 create mode 100644 arch/nios2/kernel/asm-offsets.c

diff --git a/arch/nios2/include/asm/asm-macros.h b/arch/nios2/include/asm/asm-macros.h
new file mode 100644
index 0000000..29fa2e4
--- /dev/null
+++ b/arch/nios2/include/asm/asm-macros.h
@@ -0,0 +1,309 @@
+/*
+ * Macro used to simplify coding multi-line assembler.
+ * Some of the bit test macro can simplify down to one line
+ * depending on the mask value.
+ *
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ */
+#ifndef _ASM_NIOS2_ASMMACROS_H
+#define _ASM_NIOS2_ASMMACROS_H
+/*
+ * ANDs reg2 with mask and places the result in reg1.
+ *
+ * You cannnot use the same register for reg1 & reg2.
+ */
+
+.macro ANDI32	reg1, reg2, mask
+.if \mask & 0xffff
+	.if \mask & 0xffff0000
+		movhi	\reg1, %hi(\mask)
+		movui	\reg1, %lo(\mask)
+		and	\reg1, \reg1, \reg2
+	.else
+		andi	\reg1, \reg2, %lo(\mask)
+	.endif
+.else
+	andhi	\reg1, \reg2, %hi(\mask)
+.endif
+.endm
+
+/*
+ * ORs reg2 with mask and places the result in reg1.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro ORI32	reg1, reg2, mask
+.if \mask & 0xffff
+	.if \mask & 0xffff0000
+		orhi	\reg1, \reg2, %hi(\mask)
+		ori	\reg1, \reg2, %lo(\mask)
+	.else
+		ori	\reg1, \reg2, %lo(\mask)
+	.endif
+.else
+	orhi	\reg1, \reg2, %hi(\mask)
+.endif
+.endm
+
+/*
+ * XORs reg2 with mask and places the result in reg1.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro XORI32	reg1, reg2, mask
+.if \mask & 0xffff
+	.if \mask & 0xffff0000
+		xorhi	\reg1, \reg2, %hi(\mask)
+		xori	\reg1, \reg1, %lo(\mask)
+	.else
+		xori	\reg1, \reg2, %lo(\mask)
+	.endif
+.else
+	xorhi	\reg1, \reg2, %hi(\mask)
+.endif
+.endm
+
+/*
+ * This is a support macro for BTBZ & BTBNZ.  It checks
+ * the bit to make sure it is valid 32 value.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro BT	reg1, reg2, bit
+.if \bit > 31
+	.err
+.else
+	.if \bit < 16
+		andi	\reg1, \reg2, (1 << \bit)
+	.else
+		andhi	\reg1, \reg2, (1 << (\bit - 16))
+	.endif
+.endif
+.endm
+
+/*
+ * Tests the bit in reg2 and branches to label if the
+ * bit is zero.  The result of the bit test is stored in reg1.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTBZ	reg1, reg2, bit, label
+	BT	\reg1, \reg2, \bit
+	beq	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and branches to label if the
+ * bit is non-zero.  The result of the bit test is stored in reg1.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTBNZ	reg1, reg2, bit, label
+	BT	\reg1, \reg2, \bit
+	bne	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and then compliments the bit in reg2.
+ * The result of the bit test is stored in reg1.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTC	reg1, reg2, bit
+.if \bit > 31
+	.err
+.else
+	.if \bit < 16
+		andi	\reg1, \reg2, (1 << \bit)
+		xori	\reg2, \reg2, (1 << \bit)
+	.else
+		andhi	\reg1, \reg2, (1 << (\bit - 16))
+		xorhi	\reg2, \reg2, (1 << (\bit - 16))
+	.endif
+.endif
+.endm
+
+/*
+ * Tests the bit in reg2 and then sets the bit in reg2.
+ * The result of the bit test is stored in reg1.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTS	reg1, reg2, bit
+.if \bit > 31
+	.err
+.else
+	.if \bit < 16
+		andi	\reg1, \reg2, (1 << \bit)
+		ori	\reg2, \reg2, (1 << \bit)
+	.else
+		andhi	\reg1, \reg2, (1 << (\bit - 16))
+		orhi	\reg2, \reg2, (1 << (\bit - 16))
+	.endif
+.endif
+.endm
+
+/*
+ * Tests the bit in reg2 and then resets the bit in reg2.
+ * The result of the bit test is stored in reg1.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTR	reg1, reg2, bit
+.if \bit > 31
+	.err
+.else
+	.if \bit < 16
+		andi	\reg1, \reg2, (1 << \bit)
+		andi	\reg2, \reg2, %lo(~(1 << \bit))
+	.else
+		andhi	\reg1, \reg2, (1 << (\bit - 16))
+		andhi	\reg2, \reg2, %lo(~(1 << (\bit - 16)))
+	.endif
+.endif
+.endm
+
+/*
+ * Tests the bit in reg2 and then compliments the bit in reg2.
+ * The result of the bit test is stored in reg1.  If the
+ * original bit was zero it branches to label.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTCBZ	reg1, reg2, bit, label
+	BTC	\reg1, \reg2, \bit
+	beq	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and then compliments the bit in reg2.
+ * The result of the bit test is stored in reg1.  If the
+ * original bit was non-zero it branches to label.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTCBNZ	reg1, reg2, bit, label
+	BTC	\reg1, \reg2, \bit
+	bne	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and then sets the bit in reg2.
+ * The result of the bit test is stored in reg1.  If the
+ * original bit was zero it branches to label.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTSBZ	reg1, reg2, bit, label
+	BTS	\reg1, \reg2, \bit
+	beq	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and then sets the bit in reg2.
+ * The result of the bit test is stored in reg1.  If the
+ * original bit was non-zero it branches to label.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTSBNZ	reg1, reg2, bit, label
+	BTS	\reg1, \reg2, \bit
+	bne	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and then resets the bit in reg2.
+ * The result of the bit test is stored in reg1.  If the
+ * original bit was zero it branches to label.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTRBZ	reg1, reg2, bit, label
+	BTR	\reg1, \reg2, \bit
+	bne	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bit in reg2 and then resets the bit in reg2.
+ * The result of the bit test is stored in reg1.  If the
+ * original bit was non-zero it branches to label.
+ *
+ * It is NOT safe to use the same register for reg1 & reg2.
+ */
+
+.macro BTRBNZ	reg1, reg2, bit, label
+	BTR	\reg1, \reg2, \bit
+	bne	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bits in mask against reg2 stores the result in reg1.
+ * If the all the bits in the mask are zero it branches to label.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro TSTBZ	reg1, reg2, mask, label
+	ANDI32	\reg1, \reg2, \mask
+	beq	\reg1, r0, \label
+.endm
+
+/*
+ * Tests the bits in mask against reg2 stores the result in reg1.
+ * If the any of the bits in the mask are 1 it branches to label.
+ *
+ * It is safe to use the same register for reg1 & reg2.
+ */
+
+.macro TSTBNZ	reg1, reg2, mask, label
+	ANDI32	\reg1, \reg2, \mask
+	bne	\reg1, r0, \label
+.endm
+
+/*
+ * Pushes reg onto the stack.
+ */
+
+.macro PUSH	reg
+	addi	sp, sp, -4
+	stw	\reg, 0(sp)
+.endm
+
+/*
+ * Pops the top of the stack into reg.
+ */
+
+.macro POP	reg
+	ldw	\reg, 0(sp)
+	addi	sp, sp, 4
+.endm
+
+
+#endif /* _ASM_NIOS2_ASMMACROS_H */
diff --git a/arch/nios2/include/asm/asm-offsets.h b/arch/nios2/include/asm/asm-offsets.h
new file mode 100644
index 0000000..5b9f5e0
--- /dev/null
+++ b/arch/nios2/include/asm/asm-offsets.h
@@ -0,0 +1,20 @@
+/*
+ *  Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ *  Copyright (C) 2009 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <generated/asm-offsets.h>
diff --git a/arch/nios2/kernel/asm-offsets.c b/arch/nios2/kernel/asm-offsets.c
new file mode 100644
index 0000000..3852f5c
--- /dev/null
+++ b/arch/nios2/kernel/asm-offsets.c
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/stddef.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/ptrace.h>
+#include <linux/hardirq.h>
+#include <linux/thread_info.h>
+#include <linux/kbuild.h>
+
+int main(void)
+{
+	/* struct task_struct */
+	OFFSET(TASK_THREAD, task_struct, thread);
+	BLANK();
+
+	/* struct thread_struct */
+	OFFSET(THREAD_KSP, thread_struct, ksp);
+	OFFSET(THREAD_KPSR, thread_struct, kpsr);
+	BLANK();
+
+	/* struct pt_regs */
+	OFFSET(PT_ORIG_R2, pt_regs, orig_r2);
+	OFFSET(PT_ORIG_R7, pt_regs, orig_r7);
+
+	OFFSET(PT_R1, pt_regs, r1);
+	OFFSET(PT_R2, pt_regs, r2);
+	OFFSET(PT_R3, pt_regs, r3);
+	OFFSET(PT_R4, pt_regs, r4);
+	OFFSET(PT_R5, pt_regs, r5);
+	OFFSET(PT_R6, pt_regs, r6);
+	OFFSET(PT_R7, pt_regs, r7);
+	OFFSET(PT_R8, pt_regs, r8);
+	OFFSET(PT_R9, pt_regs, r9);
+	OFFSET(PT_R10, pt_regs, r10);
+	OFFSET(PT_R11, pt_regs, r11);
+	OFFSET(PT_R12, pt_regs, r12);
+	OFFSET(PT_R13, pt_regs, r13);
+	OFFSET(PT_R14, pt_regs, r14);
+	OFFSET(PT_R15, pt_regs, r15);
+	OFFSET(PT_EA, pt_regs, ea);
+	OFFSET(PT_RA, pt_regs, ra);
+	OFFSET(PT_FP, pt_regs, fp);
+	OFFSET(PT_SP, pt_regs, sp);
+	OFFSET(PT_GP, pt_regs, gp);
+	OFFSET(PT_ESTATUS, pt_regs, estatus);
+	DEFINE(PT_REGS_SIZE, sizeof(struct pt_regs));
+	BLANK();
+
+	/* struct switch_stack */
+	OFFSET(SW_R16, switch_stack, r16);
+	OFFSET(SW_R17, switch_stack, r17);
+	OFFSET(SW_R18, switch_stack, r18);
+	OFFSET(SW_R19, switch_stack, r19);
+	OFFSET(SW_R20, switch_stack, r20);
+	OFFSET(SW_R21, switch_stack, r21);
+	OFFSET(SW_R22, switch_stack, r22);
+	OFFSET(SW_R23, switch_stack, r23);
+	OFFSET(SW_FP, switch_stack, fp);
+	OFFSET(SW_GP, switch_stack, gp);
+	OFFSET(SW_RA, switch_stack, ra);
+	DEFINE(SWITCH_STACK_SIZE, sizeof(struct switch_stack));
+	BLANK();
+
+	/* struct thread_info */
+	OFFSET(TI_TASK, thread_info, task);
+	OFFSET(TI_FLAGS, thread_info, flags);
+	OFFSET(TI_PREEMPT_COUNT, thread_info, preempt_count);
+	BLANK();
+
+	return 0;
+}
-- 
1.8.2.1

