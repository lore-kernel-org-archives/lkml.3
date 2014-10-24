Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaJXIhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:37:03 -0400
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:6656
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755732AbaJXIZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:03 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 05/29] nios2: Traps exception handling
Date: Fri, 24 Oct 2014 16:24:07 +0800
Message-ID: <1414139071-3818-6-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(22564002)(104166001)(44976005)(19580395003)(19580405001)(86362001)(93916002)(87936001)(15975445006)(68736004)(42186005)(15202345003)(6806004)(77096002)(47776003)(64706001)(102836001)(4396001)(50226001)(95666004)(88136002)(89996001)(20776003)(92726001)(85852003)(87286001)(2201001)(92566001)(107046002)(105596002)(229853001)(106466001)(31966008)(84676001)(33646002)(48376002)(50466002)(36756003)(76482002)(97736003)(77156001)(76176999)(50986999)(46102003)(99396003)(62966002)(85306004)(80022003)(120916001)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains traps exception handling.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/traps.h |  19 ++
 arch/nios2/kernel/insnemu.S    | 592 +++++++++++++++++++++++++++++++++++++++++
 arch/nios2/kernel/traps.c      | 185 +++++++++++++
 3 files changed, 796 insertions(+)
 create mode 100644 arch/nios2/include/asm/traps.h
 create mode 100644 arch/nios2/kernel/insnemu.S
 create mode 100644 arch/nios2/kernel/traps.c

diff --git a/arch/nios2/include/asm/traps.h b/arch/nios2/include/asm/traps.h
new file mode 100644
index 0000000..82a4847
--- /dev/null
+++ b/arch/nios2/include/asm/traps.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_TRAPS_H
+#define _ASM_NIOS2_TRAPS_H
+
+#define TRAP_ID_SYSCALL		0
+
+#ifndef __ASSEMBLY__
+void _exception(int signo, struct pt_regs *regs, int code, unsigned long addr);
+#endif
+
+#endif /* _ASM_NIOS2_TRAPS_H */
diff --git a/arch/nios2/kernel/insnemu.S b/arch/nios2/kernel/insnemu.S
new file mode 100644
index 0000000..8a47a77
--- /dev/null
+++ b/arch/nios2/kernel/insnemu.S
@@ -0,0 +1,592 @@
+/*
+ *  Copyright (C) 2003-2013 Altera Corporation
+ *  All rights reserved.
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
+ */
+
+
+#include <linux/linkage.h>
+#include <asm/entry.h>
+
+.set noat
+.set nobreak
+
+/*
+* Explicitly allow the use of r1 (the assembler temporary register)
+* within this code. This register is normally reserved for the use of
+* the compiler.
+*/
+
+ENTRY(instruction_trap)
+	ldw	r1, PT_R1(sp)		// Restore registers
+	ldw	r2, PT_R2(sp)
+	ldw	r3, PT_R3(sp)
+	ldw	r4, PT_R4(sp)
+	ldw	r5, PT_R5(sp)
+	ldw	r6, PT_R6(sp)
+	ldw	r7, PT_R7(sp)
+	ldw	r8, PT_R8(sp)
+	ldw	r9, PT_R9(sp)
+	ldw	r10, PT_R10(sp)
+	ldw	r11, PT_R11(sp)
+	ldw	r12, PT_R12(sp)
+	ldw	r13, PT_R13(sp)
+	ldw	r14, PT_R14(sp)
+	ldw	r15, PT_R15(sp)
+	ldw	ra, PT_RA(sp)
+	ldw	fp, PT_FP(sp)
+	ldw	gp, PT_GP(sp)
+	ldw	et, PT_ESTATUS(sp)
+	wrctl	estatus, et
+	ldw	ea, PT_EA(sp)
+	ldw	et, PT_SP(sp)		/* backup sp in et */
+
+	addi	sp, sp, PT_REGS_SIZE
+
+	/* INSTRUCTION EMULATION
+	*  ---------------------
+	*
+	* Nios II processors generate exceptions for unimplemented instructions.
+	* The routines below emulate these instructions.  Depending on the
+	* processor core, the only instructions that might need to be emulated
+	* are div, divu, mul, muli, mulxss, mulxsu, and mulxuu.
+	*
+	* The emulations match the instructions, except for the following
+	* limitations:
+	*
+	* 1) The emulation routines do not emulate the use of the exception
+	*    temporary register (et) as a source operand because the exception
+	*    handler already has modified it.
+	*
+	* 2) The routines do not emulate the use of the stack pointer (sp) or
+	*    the exception return address register (ea) as a destination because
+	*    modifying these registers crashes the exception handler or the
+	*    interrupted routine.
+	*
+	* Detailed Design
+	* ---------------
+	*
+	* The emulation routines expect the contents of integer registers r0-r31
+	* to be on the stack at addresses sp, 4(sp), 8(sp), ... 124(sp).  The
+	* routines retrieve source operands from the stack and modify the
+	* destination register's value on the stack prior to the end of the
+	* exception handler.  Then all registers except the destination register
+	* are restored to their previous values.
+	*
+	* The instruction that causes the exception is found at address -4(ea).
+	* The instruction's OP and OPX fields identify the operation to be
+	* performed.
+	*
+	* One instruction, muli, is an I-type instruction that is identified by
+	* an OP field of 0x24.
+	*
+	* muli   AAAAA,BBBBB,IIIIIIIIIIIIIIII,-0x24-
+	*           27    22                6      0    <-- LSB of field
+	*
+	* The remaining emulated instructions are R-type and have an OP field
+	* of 0x3a.  Their OPX fields identify them.
+	*
+	* R-type AAAAA,BBBBB,CCCCC,XXXXXX,NNNNN,-0x3a-
+	*           27    22    17     11     6      0  <-- LSB of field
+	*
+	*
+	* Opcode Encoding.  muli is identified by its OP value.  Then OPX & 0x02
+	* is used to differentiate between the division opcodes and the
+	* remaining multiplication opcodes.
+	*
+	* Instruction   OP      OPX    OPX & 0x02
+	* -----------   ----    ----   ----------
+	* muli          0x24
+	* divu          0x3a    0x24         0
+	* div           0x3a    0x25         0
+	* mul           0x3a    0x27      != 0
+	* mulxuu        0x3a    0x07      != 0
+	* mulxsu        0x3a    0x17      != 0
+	* mulxss        0x3a    0x1f      != 0
+	*/
+
+
+	/*
+	* Save everything on the stack to make it easy for the emulation
+	* routines to retrieve the source register operands.
+	*/
+
+	addi sp, sp, -128
+	stw zero, 0(sp)	/* Save zero on stack to avoid special case for r0. */
+	stw r1, 4(sp)
+	stw r2,  8(sp)
+	stw r3, 12(sp)
+	stw r4, 16(sp)
+	stw r5, 20(sp)
+	stw r6, 24(sp)
+	stw r7, 28(sp)
+	stw r8, 32(sp)
+	stw r9, 36(sp)
+	stw r10, 40(sp)
+	stw r11, 44(sp)
+	stw r12, 48(sp)
+	stw r13, 52(sp)
+	stw r14, 56(sp)
+	stw r15, 60(sp)
+	stw r16, 64(sp)
+	stw r17, 68(sp)
+	stw r18, 72(sp)
+	stw r19, 76(sp)
+	stw r20, 80(sp)
+	stw r21, 84(sp)
+	stw r22, 88(sp)
+	stw r23, 92(sp)
+		/* Don't bother to save et.  It's already been changed. */
+	rdctl r5, estatus
+	stw r5,  100(sp)
+
+	stw gp, 104(sp)
+	stw et, 108(sp)	/* et containts previous sp value. */
+	stw fp, 112(sp)
+	stw ea, 116(sp)
+	stw ra, 120(sp)
+
+
+	/*
+	* Split the instruction into its fields.  We need 4*A, 4*B, and 4*C as
+	* offsets to the stack pointer for access to the stored register values.
+	*/
+	ldw r2,-4(ea)	/* r2 = AAAAA,BBBBB,IIIIIIIIIIIIIIII,PPPPPP */
+	roli r3, r2, 7	/* r3 = BBB,IIIIIIIIIIIIIIII,PPPPPP,AAAAA,BB */
+	roli r4, r3, 3	/* r4 = IIIIIIIIIIIIIIII,PPPPPP,AAAAA,BBBBB */
+	roli r5, r4, 2	/* r5 = IIIIIIIIIIIIII,PPPPPP,AAAAA,BBBBB,II */
+	srai r4, r4, 16	/* r4 = (sign-extended) IMM16 */
+	roli r6, r5, 5	/* r6 = XXXX,NNNNN,PPPPPP,AAAAA,BBBBB,CCCCC,XX */
+	andi r2, r2, 0x3f	/* r2 = 00000000000000000000000000,PPPPPP */
+	andi r3, r3, 0x7c	/* r3 = 0000000000000000000000000,AAAAA,00 */
+	andi r5, r5, 0x7c	/* r5 = 0000000000000000000000000,BBBBB,00 */
+	andi r6, r6, 0x7c	/* r6 = 0000000000000000000000000,CCCCC,00 */
+
+	/* Now
+	* r2 = OP
+	* r3 = 4*A
+	* r4 = IMM16 (sign extended)
+	* r5 = 4*B
+	* r6 = 4*C
+	*/
+
+	/*
+	* Get the operands.
+	*
+	* It is necessary to check for muli because it uses an I-type
+	* instruction format, while the other instructions are have an R-type
+	* format.
+	*
+	*  Prepare for either multiplication or division loop.
+	*  They both loop 32 times.
+	*/
+	movi r14, 32
+
+	add  r3, r3, sp		/* r3 = address of A-operand. */
+	ldw  r3, 0(r3)		/* r3 = A-operand. */
+	movi r7, 0x24		/* muli opcode (I-type instruction format) */
+	beq r2, r7, mul_immed /* muli doesn't use the B register as a source */
+
+	add  r5, r5, sp		/* r5 = address of B-operand. */
+	ldw  r5, 0(r5)		/* r5 = B-operand. */
+				/* r4 = SSSSSSSSSSSSSSSS,-----IMM16------ */
+				/* IMM16 not needed, align OPX portion */
+				/* r4 = SSSSSSSSSSSSSSSS,CCCCC,-OPX--,00000 */
+	srli r4, r4, 5		/* r4 = 00000,SSSSSSSSSSSSSSSS,CCCCC,-OPX-- */
+	andi r4, r4, 0x3f	/* r4 = 00000000000000000000000000,-OPX-- */
+
+	/* Now
+	* r2 = OP
+	* r3 = src1
+	* r5 = src2
+	* r4 = OPX (no longer can be muli)
+	* r6 = 4*C
+	*/
+
+
+	/*
+	*  Multiply or Divide?
+	*/
+	andi r7, r4, 0x02	/* For R-type multiply instructions,
+				   OPX & 0x02 != 0 */
+	bne r7, zero, multiply
+
+
+	/* DIVISION
+	*
+	* Divide an unsigned dividend by an unsigned divisor using
+	* a shift-and-subtract algorithm.  The example below shows
+	* 43 div 7 = 6 for 8-bit integers.  This classic algorithm uses a
+	* single register to store both the dividend and the quotient,
+	* allowing both values to be shifted with a single instruction.
+	*
+	*                               remainder dividend:quotient
+	*                               --------- -----------------
+	*   initialize                   00000000     00101011:
+	*   shift                        00000000     0101011:_
+	*   remainder >= divisor? no     00000000     0101011:0
+	*   shift                        00000000     101011:0_
+	*   remainder >= divisor? no     00000000     101011:00
+	*   shift                        00000001     01011:00_
+	*   remainder >= divisor? no     00000001     01011:000
+	*   shift                        00000010     1011:000_
+	*   remainder >= divisor? no     00000010     1011:0000
+	*   shift                        00000101     011:0000_
+	*   remainder >= divisor? no     00000101     011:00000
+	*   shift                        00001010     11:00000_
+	*   remainder >= divisor? yes    00001010     11:000001
+	*       remainder -= divisor   - 00000111
+	*                              ----------
+	*                                00000011     11:000001
+	*   shift                        00000111     1:000001_
+	*   remainder >= divisor? yes    00000111     1:0000011
+	*       remainder -= divisor   - 00000111
+	*                              ----------
+	*                                00000000     1:0000011
+	*   shift                        00000001     :0000011_
+	*   remainder >= divisor? no     00000001     :00000110
+	*
+	* The quotient is 00000110.
+	*/
+
+divide:
+	/*
+	*  Prepare for division by assuming the result
+	*  is unsigned, and storing its "sign" as 0.
+	*/
+	movi r17, 0
+
+
+	/* Which division opcode? */
+	xori r7, r4, 0x25		/* OPX of div */
+	bne r7, zero, unsigned_division
+
+
+	/*
+	*  OPX is div.  Determine and store the sign of the quotient.
+	*  Then take the absolute value of both operands.
+	*/
+	xor r17, r3, r5		/* MSB contains sign of quotient */
+	bge r3,zero,dividend_is_nonnegative
+	sub r3, zero, r3	/* -r3 */
+dividend_is_nonnegative:
+	bge r5, zero, divisor_is_nonnegative
+	sub r5, zero, r5	/* -r5 */
+divisor_is_nonnegative:
+
+
+unsigned_division:
+	/* Initialize the unsigned-division loop. */
+	movi r13, 0	/* remainder = 0 */
+
+	/* Now
+	* r3 = dividend : quotient
+	* r4 = 0x25 for div, 0x24 for divu
+	* r5 = divisor
+	* r13 = remainder
+	* r14 = loop counter (already initialized to 32)
+	* r17 = MSB contains sign of quotient
+	*/
+
+
+	/*
+	*   for (count = 32; count > 0; --count)
+	*   {
+	*/
+divide_loop:
+
+	/*
+	*       Division:
+	*
+	*       (remainder:dividend:quotient) <<= 1;
+	*/
+	slli r13, r13, 1
+	cmplt r7, r3, zero	/* r7 = MSB of r3 */
+	or r13, r13, r7
+	slli r3, r3, 1
+
+
+	/*
+	*       if (remainder >= divisor)
+	*       {
+	*           set LSB of quotient
+	*           remainder -= divisor;
+	*       }
+	*/
+	bltu r13, r5, div_skip
+	ori r3, r3, 1
+	sub r13, r13, r5
+div_skip:
+
+	/*
+	*   }
+	*/
+	subi r14, r14, 1
+	bne r14, zero, divide_loop
+
+
+	/* Now
+	* r3 = quotient
+	* r4 = 0x25 for div, 0x24 for divu
+	* r6 = 4*C
+	* r17 = MSB contains sign of quotient
+	*/
+
+
+	/*
+	*  Conditionally negate signed quotient.  If quotient is unsigned,
+	*  the sign already is initialized to 0.
+	*/
+	bge r17, zero, quotient_is_nonnegative
+	sub r3, zero, r3		/* -r3 */
+	quotient_is_nonnegative:
+
+
+	/*
+	*  Final quotient is in r3.
+	*/
+	add r6, r6, sp
+	stw r3, 0(r6)	/* write quotient to stack */
+	br restore_registers
+
+
+
+
+	/* MULTIPLICATION
+	*
+	* A "product" is the number that one gets by summing a "multiplicand"
+	* several times.  The "multiplier" specifies the number of copies of the
+	* multiplicand that are summed.
+	*
+	* Actual multiplication algorithms don't use repeated addition, however.
+	* Shift-and-add algorithms get the same answer as repeated addition, and
+	* they are faster.  To compute the lower half of a product (pppp below)
+	* one shifts the product left before adding in each of the partial
+	* products (a * mmmm) through (d * mmmm).
+	*
+	* To compute the upper half of a product (PPPP below), one adds in the
+	* partial products (d * mmmm) through (a * mmmm), each time following
+	* the add by a right shift of the product.
+	*
+	*     mmmm
+	*   * abcd
+	*   ------
+	*     ####  = d * mmmm
+	*    ####   = c * mmmm
+	*   ####    = b * mmmm
+	*  ####     = a * mmmm
+	* --------
+	* PPPPpppp
+	*
+	* The example above shows 4 partial products.  Computing actual Nios II
+	* products requires 32 partials.
+	*
+	* It is possible to compute the result of mulxsu from the result of
+	* mulxuu because the only difference between the results of these two
+	* opcodes is the value of the partial product associated with the sign
+	* bit of rA.
+	*
+	*   mulxsu = mulxuu - (rA < 0) ? rB : 0;
+	*
+	* It is possible to compute the result of mulxss from the result of
+	* mulxsu because the only difference between the results of these two
+	* opcodes is the value of the partial product associated with the sign
+	* bit of rB.
+	*
+	*   mulxss = mulxsu - (rB < 0) ? rA : 0;
+	*
+	*/
+
+mul_immed:
+	/* Opcode is muli.  Change it into mul for remainder of algorithm. */
+	mov r6, r5		/* Field B is dest register, not field C. */
+	mov r5, r4		/* Field IMM16 is src2, not field B. */
+	movi r4, 0x27		/* OPX of mul is 0x27 */
+
+multiply:
+	/* Initialize the multiplication loop. */
+	movi r9, 0	/* mul_product    = 0 */
+	movi r10, 0	/* mulxuu_product = 0 */
+	mov r11, r5	/* save original multiplier for mulxsu and mulxss */
+	mov r12, r5	/* mulxuu_multiplier (will be shifted) */
+	movi r16, 1	/* used to create "rori B,A,1" from "ror B,A,r16" */
+
+	/* Now
+	* r3 = multiplicand
+	* r5 = mul_multiplier
+	* r6 = 4 * dest_register (used later as offset to sp)
+	* r7 = temp
+	* r9 = mul_product
+	* r10 = mulxuu_product
+	* r11 = original multiplier
+	* r12 = mulxuu_multiplier
+	* r14 = loop counter (already initialized)
+	* r16 = 1
+	*/
+
+
+	/*
+	*   for (count = 32; count > 0; --count)
+	*   {
+	*/
+multiply_loop:
+
+	/*
+	*       mul_product <<= 1;
+	*       lsb = multiplier & 1;
+	*/
+	slli r9, r9, 1
+	andi r7, r12, 1
+
+	/*
+	*       if (lsb == 1)
+	*       {
+	*           mulxuu_product += multiplicand;
+	*       }
+	*/
+	beq r7, zero, mulx_skip
+	add r10, r10, r3
+	cmpltu r7, r10, r3 /* Save the carry from the MSB of mulxuu_product. */
+	ror r7, r7, r16	/* r7 = 0x80000000 on carry, or else 0x00000000 */
+mulx_skip:
+
+	/*
+	*       if (MSB of mul_multiplier == 1)
+	*       {
+	*           mul_product += multiplicand;
+	*       }
+	*/
+	bge r5, zero, mul_skip
+	add r9, r9, r3
+mul_skip:
+
+	/*
+	*       mulxuu_product >>= 1;           logical shift
+	*       mul_multiplier <<= 1;           done with MSB
+	*       mulx_multiplier >>= 1;          done with LSB
+	*/
+	srli r10, r10, 1
+	or r10, r10, r7		/* OR in the saved carry bit. */
+	slli r5, r5, 1
+	srli r12, r12, 1
+
+
+	/*
+	*   }
+	*/
+	subi r14, r14, 1
+	bne r14, zero, multiply_loop
+
+
+	/*
+	*  Multiply emulation loop done.
+	*/
+
+	/* Now
+	* r3 = multiplicand
+	* r4 = OPX
+	* r6 = 4 * dest_register (used later as offset to sp)
+	* r7 = temp
+	* r9 = mul_product
+	* r10 = mulxuu_product
+	* r11 = original multiplier
+	*/
+
+
+	/* Calculate address for result from 4 * dest_register */
+	add r6, r6, sp
+
+
+	/*
+	* Select/compute the result based on OPX.
+	*/
+
+
+	/* OPX == mul?  Then store. */
+	xori r7, r4, 0x27
+	beq r7, zero, store_product
+
+	/* It's one of the mulx.. opcodes.  Move over the result. */
+	mov r9, r10
+
+	/* OPX == mulxuu?  Then store. */
+	xori r7, r4, 0x07
+	beq r7, zero, store_product
+
+	/* Compute mulxsu
+	 *
+	 * mulxsu = mulxuu - (rA < 0) ? rB : 0;
+	 */
+	bge r3, zero, mulxsu_skip
+	sub r9, r9, r11
+mulxsu_skip:
+
+	/* OPX == mulxsu?  Then store. */
+	xori r7, r4, 0x17
+	beq r7, zero, store_product
+
+	/* Compute mulxss
+	 *
+	 * mulxss = mulxsu - (rB < 0) ? rA : 0;
+	 */
+	bge r11,zero,mulxss_skip
+	sub r9, r9, r3
+mulxss_skip:
+	/* At this point, assume that OPX is mulxss, so store*/
+
+
+store_product:
+	stw r9, 0(r6)
+
+
+restore_registers:
+			/* No need to restore r0. */
+	ldw r5, 100(sp)
+	wrctl estatus, r5
+
+	ldw r1, 4(sp)
+	ldw r2, 8(sp)
+	ldw r3, 12(sp)
+	ldw r4, 16(sp)
+	ldw r5, 20(sp)
+	ldw r6, 24(sp)
+	ldw r7, 28(sp)
+	ldw r8, 32(sp)
+	ldw r9, 36(sp)
+	ldw r10, 40(sp)
+	ldw r11, 44(sp)
+	ldw r12, 48(sp)
+	ldw r13, 52(sp)
+	ldw r14, 56(sp)
+	ldw r15, 60(sp)
+	ldw r16, 64(sp)
+	ldw r17, 68(sp)
+	ldw r18, 72(sp)
+	ldw r19, 76(sp)
+	ldw r20, 80(sp)
+	ldw r21, 84(sp)
+	ldw r22, 88(sp)
+	ldw r23, 92(sp)
+			/* Does not need to restore et */
+	ldw gp, 104(sp)
+
+	ldw fp, 112(sp)
+	ldw ea, 116(sp)
+	ldw ra, 120(sp)
+	ldw sp, 108(sp)	/* last restore sp */
+	eret
+
+.set at
+.set break
diff --git a/arch/nios2/kernel/traps.c b/arch/nios2/kernel/traps.c
new file mode 100644
index 0000000..b7b9764
--- /dev/null
+++ b/arch/nios2/kernel/traps.c
@@ -0,0 +1,185 @@
+/*
+ * Hardware exception handling
+ *
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ * Copyright (C) 2001 Vic Phillips
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/ptrace.h>
+
+#include <asm/traps.h>
+#include <asm/sections.h>
+#include <asm/uaccess.h>
+
+static DEFINE_SPINLOCK(die_lock);
+
+void die(const char *str, struct pt_regs *regs, long err)
+{
+	console_verbose();
+	spin_lock_irq(&die_lock);
+	pr_warn("Oops: %s, sig: %ld\n", str, err);
+	show_regs(regs);
+	spin_unlock_irq(&die_lock);
+	/*
+	 * do_exit() should take care of panic'ing from an interrupt
+	 * context so we don't handle it here
+	 */
+	do_exit(err);
+}
+
+void _exception(int signo, struct pt_regs *regs, int code, unsigned long addr)
+{
+	siginfo_t info;
+
+	if (!user_mode(regs))
+		die("Exception in kernel mode", regs, signo);
+
+	info.si_signo = signo;
+	info.si_errno = 0;
+	info.si_code = code;
+	info.si_addr = (void __user *) addr;
+	force_sig_info(signo, &info, current);
+}
+
+/*
+ * The show_stack is an external API which we do not use ourselves.
+ */
+
+int kstack_depth_to_print = 48;
+
+void show_stack(struct task_struct *task, unsigned long *stack)
+{
+	unsigned long *endstack, addr;
+	int i;
+
+	if (!stack) {
+		if (task)
+			stack = (unsigned long *)task->thread.ksp;
+		else
+			stack = (unsigned long *)&stack;
+	}
+
+	addr = (unsigned long) stack;
+	endstack = (unsigned long *) PAGE_ALIGN(addr);
+
+	pr_emerg("Stack from %08lx:", (unsigned long)stack);
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (stack + 1 > endstack)
+			break;
+		if (i % 8 == 0)
+			pr_emerg("\n       ");
+		pr_emerg(" %08lx", *stack++);
+	}
+
+	pr_emerg("\nCall Trace:");
+	i = 0;
+	while (stack + 1 <= endstack) {
+		addr = *stack++;
+		/*
+		 * If the address is either in the text segment of the
+		 * kernel, or in the region which contains vmalloc'ed
+		 * memory, it *may* be the address of a calling
+		 * routine; if so, print it so that someone tracing
+		 * down the cause of the crash will be able to figure
+		 * out the call path that was taken.
+		 */
+		if (((addr >= (unsigned long) _stext) &&
+		     (addr <= (unsigned long) _etext))) {
+			if (i % 4 == 0)
+				pr_emerg("\n       ");
+			pr_emerg(" [<%08lx>]", addr);
+			i++;
+		}
+	}
+	pr_emerg("\n");
+}
+
+void __init trap_init(void)
+{
+	/* Nothing to do here */
+}
+
+/* Breakpoint handler */
+asmlinkage void breakpoint_c(struct pt_regs *fp)
+{
+	/*
+	 * The breakpoint entry code has moved the PC on by 4 bytes, so we must
+	 * move it back. This could be done on the host but we do it here
+	 * because monitor.S of JTAG gdbserver does it too.
+	 */
+	fp->ea -= 4;
+	_exception(SIGTRAP, fp, TRAP_BRKPT, fp->ea);
+}
+
+#ifndef CONFIG_NIOS2_ALIGNMENT_TRAP
+/* Alignment exception handler */
+asmlinkage void handle_unaligned_c(struct pt_regs *fp, int cause)
+{
+	unsigned long addr = RDCTL(CTL_BADADDR);
+
+	cause >>= 2;
+	fp->ea -= 4;
+
+	if (fixup_exception(fp))
+		return;
+
+	if (!user_mode(fp)) {
+		pr_alert("Unaligned access from kernel mode, this might be a hardware\n");
+		pr_alert("problem, dump registers and restart the instruction\n");
+		pr_alert("  BADADDR 0x%08lx\n", addr);
+		pr_alert("  cause   %d\n", cause);
+		pr_alert("  op-code 0x%08lx\n", *(unsigned long *)(fp->ea));
+		show_regs(fp);
+		return;
+	}
+
+	_exception(SIGBUS, fp, BUS_ADRALN, addr);
+}
+#endif /* CONFIG_NIOS2_ALIGNMENT_TRAP */
+
+/* Illegal instruction handler */
+asmlinkage void handle_illegal_c(struct pt_regs *fp)
+{
+	fp->ea -= 4;
+	_exception(SIGILL, fp, ILL_ILLOPC, fp->ea);
+}
+
+/* Supervisor instruction handler */
+asmlinkage void handle_supervisor_instr(struct pt_regs *fp)
+{
+	fp->ea -= 4;
+	_exception(SIGILL, fp, ILL_PRVOPC, fp->ea);
+}
+
+/* Division error handler */
+asmlinkage void handle_diverror_c(struct pt_regs *fp)
+{
+	fp->ea -= 4;
+	_exception(SIGFPE, fp, FPE_INTDIV, fp->ea);
+}
+
+/* Unhandled exception handler */
+asmlinkage void unhandled_exception(struct pt_regs *regs, int cause)
+{
+	unsigned long addr = RDCTL(CTL_BADADDR);
+
+	cause /= 4;
+
+	pr_emerg("Unhandled exception #%d in %s mode (badaddr=0x%08lx)\n",
+			cause, user_mode(regs) ? "user" : "kernel", addr);
+
+	regs->ea -= 4;
+	show_regs(regs);
+
+	pr_emerg("opcode: 0x%08lx\n", *(unsigned long *)(regs->ea));
+}
-- 
1.8.2.1

