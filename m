Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaLCXos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:44:48 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:39996 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaLCXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:44:28 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, peterz@infradead.org,
        paul.gortmaker@windriver.com, macro@linux-mips.org, chenhc@lemote.com,
        cl@linux.com, mingo@kernel.org, richard@nod.at, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, tj@kernel.org,
        alex@alex-smith.me.uk, pbonzini@redhat.com, blogic@openwrt.org,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, manuel.lauss@gmail.com,
        lars.persson@axis.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/3] MIPS: Add full ISA emulator.
Date: Wed,  3 Dec 2014 15:44:17 -0800
Message-Id: <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Used in follow-on patch to replace FPU delay-slot instruction
execution on stack.

Only 32-bit instructions are emulated right now, still need to add
64-bit.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/Makefile    |   3 +-
 arch/mips/kernel/insn-emul.c | 815 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 817 insertions(+), 1 deletion(-)
 create mode 100644 arch/mips/kernel/insn-emul.c

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 008a2fe..b6e550d 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -6,7 +6,8 @@ extra-y		:= head.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o idle.o irq.o process.o \
 		   prom.o ptrace.o reset.o setup.o signal.o syscall.o \
-		   time.o topology.o traps.o unaligned.o watch.o vdso.o
+		   time.o topology.o traps.o unaligned.o watch.o vdso.o \
+		   insn-emul.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_ftrace.o = -pg
diff --git a/arch/mips/kernel/insn-emul.c b/arch/mips/kernel/insn-emul.c
new file mode 100644
index 0000000..62e39e9
--- /dev/null
+++ b/arch/mips/kernel/insn-emul.c
@@ -0,0 +1,815 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2014 Cavium, Inc.
+ */
+
+#include <asm/inst.h>
+#include <asm/ptrace.h>
+#include <asm/barrier.h>
+#include <asm/signal.h>
+#include <asm/uaccess.h>
+
+static int mips64_spec_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	return SIGILL;
+}
+
+static int mips_spec_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	union mips_instruction insn;
+	u32 rs32, rt32, rd32;
+	u64 t1_64, t2_64;
+	s64 t1_64s, t2_64s;
+	u32 t1_32, t2_32;
+	s32 t1_32s, t2_32s;
+	s32 rs32s, rt32s, rd32s;
+	int sa;
+
+	insn.word = ir;
+	switch (insn.r_format.func) {
+	case sll_op:
+		if (insn.r_format.rs != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result "NOP" */
+		rt32 = regs->regs[insn.r_format.rt];
+		sa = insn.r_format.re;
+		rd32 = rt32 << sa;
+		regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+		return 0;
+	case srl_op:
+		if (insn.r_format.rs == 0) {
+			/* SRL */
+			if (insn.r_format.rd == 0)
+				return 0; /* ignore result */
+			rt32 = regs->regs[insn.r_format.rt];
+			rd32 = rt32 >> insn.r_format.re;
+			regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+			return 0;
+		} else if (insn.r_format.rs == 1) {
+			/* ROTR */
+			if (insn.r_format.rd == 0)
+				return 0; /* ignore result */
+			rt32 = regs->regs[insn.r_format.rt];
+			sa = insn.r_format.re;
+			rd32 = (rt32 >> sa) | (rt32 << (32 - sa));
+			regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+			return 0;
+		}
+		return SIGILL;
+	case sra_op:
+		if (insn.r_format.rs != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rt32s = regs->regs[insn.r_format.rt];
+		sa = insn.r_format.re;
+		rd32s = rt32s >> sa;
+		regs->regs[insn.r_format.rd] = (long)rd32s;
+		return 0;
+	case sllv_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		sa = rs32 & 0x1f;
+		rd32 = rt32 << sa;
+		regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+		return 0;
+	case srlv_op:
+		if (insn.r_format.re == 0) {
+			/* SRLV */
+			if (insn.r_format.rd == 0)
+				return 0; /* ignore result */
+			rs32 = regs->regs[insn.r_format.rs];
+			rt32 = regs->regs[insn.r_format.rt];
+			sa = rs32 & 0x1f;
+			rd32 = rt32 >> sa;
+			regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+			return 0;
+		} else if (insn.r_format.re == 1) {
+			/* ROTRV */
+			if (insn.r_format.rd == 0)
+				return 0; /* ignore result */
+			rs32 = regs->regs[insn.r_format.rs];
+			rt32 = regs->regs[insn.r_format.rt];
+			sa = rs32 & 0x1f;
+			rd32 = (rt32 >> sa) | (rt32 << (32 - sa));
+			regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+			return 0;
+		}
+		return SIGILL;
+	case srav_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32s = regs->regs[insn.r_format.rt];
+		sa = rs32 & 0x1f;
+		rd32s = rt32s >> sa;
+		regs->regs[insn.r_format.rd] = (long)rd32s;
+		return 0;
+	case movz_op:
+		if (insn.r_format.rs != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		if (regs->regs[insn.r_format.rt] == 0)
+			regs->regs[insn.r_format.rd] = regs->regs[insn.r_format.rs];
+		return 0;
+	case movn_op:
+		if (insn.r_format.rs != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		if (regs->regs[insn.r_format.rt] != 0)
+			regs->regs[insn.r_format.rd] = regs->regs[insn.r_format.rs];
+		return 0;
+	case sync_op:
+		mb(); /* an mb() is a SYNC */
+		return 0;
+	case mfhi_op:
+		if (insn.r_format.rs != 0 || insn.r_format.rt != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] = regs->hi;
+		return 0;
+	case mthi_op:
+		if (insn.r_format.rt != 0 || insn.r_format.rd != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			regs->hi = 0;
+		regs->hi = regs->regs[insn.r_format.rs];
+		return 0;
+	case mflo_op:
+		if (insn.r_format.rs != 0 || insn.r_format.rt != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] = regs->lo;
+		return 0;
+	case mtlo_op:
+		if (insn.r_format.rt != 0 || insn.r_format.rd != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			regs->lo = 0;
+		regs->lo = regs->regs[insn.r_format.rs];
+		return 0;
+	case mult_op:
+		if (insn.r_format.rd != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		rs32s = regs->regs[insn.r_format.rs];
+		rt32s = regs->regs[insn.r_format.rt];
+		t1_64s = rs32s;
+		t2_64s = rt32s;
+		t1_64s *= t2_64s;
+		t1_64 = t1_64s;
+		t1_32 = t1_64 >> 32;
+		t2_32 = t1_64 & 0xffffffffu;
+		regs->lo = (long)(s32)t2_32;
+		regs->hi = (long)(s32)t1_32;
+		return 0;
+	case multu_op:
+		if (insn.r_format.rd != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		t1_64 = rs32;
+		t2_64 = rt32;
+		t1_64 *= t2_64;
+		t1_32 = t1_64 >> 32;
+		t2_32 = t1_64 & 0xffffffffu;
+		regs->lo = (long)(s32)t2_32;
+		regs->hi = (long)(s32)t1_32;
+		return 0;
+	case div_op:
+		if (insn.r_format.rd != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		rs32s = regs->regs[insn.r_format.rs];
+		rt32s = regs->regs[insn.r_format.rt];
+		if (rt32s == 0)
+			return 0; /* Undefined on div/zero, do nothing */
+		t1_32s = rs32s / rt32s;
+		t2_32s = rs32s % rt32s;
+		regs->lo = (long)t1_32s;
+		regs->hi = (long)t2_32s;
+		return 0;
+	case divu_op:
+		if (insn.r_format.rd != 0 || insn.r_format.re != 0)
+			return SIGILL;
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		if (rt32 == 0)
+			return 0; /* Undefined on div/zero, do nothing */
+		t1_32 = rs32 / rt32;
+		t2_32 = rs32 % rt32;
+		regs->lo = (long)(s32)t1_32;
+		regs->hi = (long)(s32)t2_32;
+		return 0;
+	case addu_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		rd32 = rs32 + rt32;
+		regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+		return 0;
+	case subu_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		rd32 = rs32 - rt32;
+		regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+		return 0;
+	case and_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] =
+			regs->regs[insn.r_format.rs] & regs->regs[insn.r_format.rt];
+		return 0;
+	case or_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] =
+			regs->regs[insn.r_format.rs] | regs->regs[insn.r_format.rt];
+		return 0;
+	case xor_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] =
+			regs->regs[insn.r_format.rs] ^ regs->regs[insn.r_format.rt];
+		return 0;
+	case nor_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] =
+			~(regs->regs[insn.r_format.rs] | regs->regs[insn.r_format.rt]);
+		return 0;
+	case slt_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] =
+			((long)regs->regs[insn.r_format.rs]) < ((long)regs->regs[insn.r_format.rt]) ? 1 : 0;
+		return 0;
+	case sltu_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.r_format.rd] =
+			regs->regs[insn.r_format.rs] < regs->regs[insn.r_format.rt] ? 1 : 0;
+		return 0;
+	case dsllv_op:
+	case dsrlv_op:
+	case dsrav_op:
+	case dmult_op:
+	case dmultu_op:
+	case ddiv_op:
+	case ddivu_op:
+	case dadd_op:
+	case daddu_op:
+	case dsub_op:
+	case dsubu_op:
+	case dsll_op:
+	case dsrl_op:
+	case dsra_op:
+	case dsll32_op:
+	case dsrl32_op:
+	case dsra32_op:
+		return mips64_spec_emul(regs, ir);
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips_imm_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	union mips_instruction insn;
+	u32 rs32, rt32;
+	s32 rs32s;
+	u32 t1_32;
+	s32 t1_32s;
+	unsigned long t1;
+
+	insn.word = ir;
+	switch (insn.i_format.opcode) {
+	case addiu_op:
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.i_format.rs];
+		t1_32s = insn.i_format.simmediate;
+		t1_32 = t1_32s;
+		rt32 = rs32 + t1_32;
+		regs->regs[insn.i_format.rt] = (long)(s32)rt32;
+		return 0;
+	case slti_op:
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		rs32s = regs->regs[insn.i_format.rs];
+		t1_32s = insn.i_format.simmediate;
+		regs->regs[insn.i_format.rt] = rs32s > t1_32s ? 1 : 0;
+		return 0;
+	case sltiu_op:
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.i_format.rs];
+		t1_32s = insn.i_format.simmediate;
+		t1_32 = t1_32s;
+		regs->regs[insn.i_format.rt] = rs32 > t1_32 ? 1 : 0;
+		return 0;
+	case andi_op:
+		if (insn.u_format.rt == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.u_format.rs];
+		t1 = insn.u_format.uimmediate;
+		regs->regs[insn.u_format.rt] = t1 & regs->regs[insn.u_format.rs];
+		return 0;
+	case ori_op:
+		if (insn.u_format.rt == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.u_format.rs];
+		t1 = insn.u_format.uimmediate;
+		regs->regs[insn.u_format.rt] = t1 | regs->regs[insn.u_format.rs];
+		return 0;
+	case xori_op:
+		if (insn.u_format.rt == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.u_format.rs];
+		t1 = insn.u_format.uimmediate;
+		regs->regs[insn.u_format.rt] = t1 ^ regs->regs[insn.u_format.rs];
+		return 0;
+	case lui_op:
+		if (insn.u_format.rs != 0)
+			return SIGILL;
+		if (insn.u_format.rt == 0)
+			return 0; /* ignore result */
+		t1_32 = insn.u_format.uimmediate;
+		t1_32 <<= 16;
+		regs->regs[insn.u_format.rt] = (long)(s32)t1_32;
+		return 0;
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips64_imm_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	return SIGILL;
+}
+
+static int mips64_spec2_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	return SIGILL;
+}
+
+static int mips_spec2_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	union mips_instruction insn;
+	s32 rs32s, rt32s;
+	u32 rs32, rt32;
+	s64 t1_64s, t2_64s;
+	u64 t1_64, t2_64, t3_64;
+	u32 t1_32, t2_32;
+	int i;
+
+	insn.word = ir;
+	switch (insn.r_format.func) {
+	case madd_op:
+	case msub_op:
+
+		if (insn.r_format.re != 0 || insn.r_format.rd != 0)
+			return SIGILL;
+		rs32s = regs->regs[insn.r_format.rs];
+		rt32s = regs->regs[insn.r_format.rt];
+		t1_64s = rs32s;
+		t2_64s = rt32s;
+		t1_64s = t1_64s * t2_64s;	/* Product */
+		t1_32 = regs->hi;
+		t2_32 = regs->lo;
+		t1_64 = t1_32;
+		t2_64 = t2_32;
+		t1_64 = (t1_64 << 32) | t2_64;
+		t2_64s = t1_64;			/* (hi, lo) */
+		if (insn.r_format.func == madd_op)
+			t2_64s = t2_64s + t1_64s; /* (hi, lo) + Product */
+		else
+			t2_64s = t2_64s - t1_64s; /* (hi, lo) - Product */
+		t1_64 = t2_64s;
+
+		t2_64 = t1_64 & 0xffffffffu;
+		t1_64 = t1_64 >> 32;
+		t1_32 = t1_64;
+		t2_32 = t2_64;
+		regs->hi = (long)(s32)t1_32;
+		regs->lo = (long)(s32)t2_32;
+		return 0;
+
+	case maddu_op:
+	case msubu_op:
+		if (insn.r_format.re != 0 || insn.r_format.rd != 0)
+			return SIGILL;
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		t1_64 = rs32;
+		t2_64 = rt32;
+		t1_64 = t1_64 * t2_64;		/* Product */
+		t1_32 = regs->hi;
+		t2_32 = regs->lo;
+		t2_64 = t1_32;
+		t3_64 = t2_32;
+		t2_64 = (t2_64 << 32) | t3_64;	/* (hi, lo) */
+
+		if (insn.r_format.func == maddu_op)
+			t1_64 = t2_64 + t1_64;	/* (hi, lo) + Product */
+		else
+			t1_64 = t2_64 - t1_64;	/* (hi, lo) - Product */
+
+		t2_64 = t1_64 & 0xffffffffu;
+		t1_64 = t1_64 >> 32;
+		t1_32 = t1_64;
+		t2_32 = t2_64;
+		regs->hi = (long)(s32)t1_32;
+		regs->lo = (long)(s32)t2_32;
+		return 0;
+
+	case mul_op:
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rs32s = regs->regs[insn.r_format.rs];
+		rt32s = regs->regs[insn.r_format.rt];
+		t1_64s = rs32s;
+		t2_64s = rt32s;
+		t1_64s = t1_64s * t2_64s;
+		t1_64 = t1_64s;
+		t1_32 = t1_64;
+		regs->regs[insn.r_format.rd] = (long)(s32)t1_32;
+		return 0;
+
+	case clz_op:
+	case clo_op:
+		t2_32 = (insn.r_format.func == clz_op) ? 0 : 1;
+		if (insn.r_format.re != 0)
+			return SIGILL;
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.r_format.rs];
+		t1_32 = 0;
+		for (i = 31; i <= 0; i--) {
+			if (((rs32 >> i) & 1) == t2_32)
+				t1_32++;
+			else
+				break;
+		}
+		regs->regs[insn.r_format.rd] = t1_32;
+		return 0;
+
+	case dclz_op:
+	case dclo_op:
+		return mips64_spec2_emul(regs, ir);
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips64_spec3_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	return SIGILL;
+}
+
+static int mips_bshfl_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	union mips_instruction insn;
+	u32 rt32, rd32;
+	s8 t8s;
+	s16 t16s;
+
+	insn.word = ir;
+	if (insn.r_format.rs != 0)
+		return SIGILL;
+
+	switch (insn.r_format.re) {
+	case wsbh_op:
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		rt32 = regs->regs[insn.r_format.rt];
+		rd32 = ((rt32 >> 8) & 0x00ff00ffu) | ((rt32 << 8) & 0xff00ff00u);
+		regs->regs[insn.r_format.rd] = (long)(s32)rd32;
+		return 0;
+	case seb_op:
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		t8s = regs->regs[insn.r_format.rt];
+		regs->regs[insn.r_format.rd] = (long)t8s;
+		return 0;
+	case seh_op:
+		if (insn.r_format.rd == 0)
+			return 0; /* ignore result */
+		t16s = regs->regs[insn.r_format.rt];
+		regs->regs[insn.r_format.rd] = (long)t16s;
+		return 0;
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips_dbshfl_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	union mips_instruction insn;
+
+	insn.word = ir;
+	switch (insn.r_format.re) {
+	case wsbh_op: /* DSBH */
+	case dshd_op:
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips_spec3_emul(struct pt_regs *regs, mips_instruction ir)
+{
+	union mips_instruction insn;
+	u32 rs32, rt32;
+	u32 t1_32;
+
+	insn.word = ir;
+	switch (insn.r_format.func) {
+	case ext_op:
+		if (insn.r_format.rt == 0)
+			return 0; /* ignore result */
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = rs32 >> insn.r_format.re;
+		rt32 = rt32 & (0xffffffffu >> (31 - insn.r_format.rd));
+		regs->regs[insn.r_format.rt] = (long)(s32)rt32;
+		return 0;
+	case ins_op:
+		if (insn.r_format.rt == 0)
+			return 0; /* ignore result */
+		t1_32 = 0xffffffffu >> (31 - insn.r_format.rd + insn.r_format.re);
+		t1_32 = t1_32 << insn.r_format.re; /* Mask */
+		rs32 = regs->regs[insn.r_format.rs];
+		rt32 = regs->regs[insn.r_format.rt];
+		rt32 = (rt32 & ~t1_32);
+		rs32 = (rs32 << insn.r_format.re) & t1_32;
+		rt32 = rt32 | rs32;
+		regs->regs[insn.r_format.rt] = (long)(s32)rt32;
+		return 0;
+	case bshfl_op:
+		return  mips_bshfl_emul(regs, ir);
+	case dbshfl_op:
+		return  mips_dbshfl_emul(regs, ir);
+	case rdhwr_op:
+
+	case dextm_op:
+	case dextu_op:
+	case dext_op:
+	case dinsm_op:
+	case dinsu_op:
+	case dins_op:
+		return mips64_spec3_emul(regs, ir);
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips_load_emul(struct pt_regs *regs, mips_instruction ir, void *__user *fault_addr)
+{
+	s8 __user *va8s;
+	s16 __user *va16s;
+	s32 __user *va32s;
+	u8 __user *va8;
+	u16 __user *va16;
+	union mips_instruction insn;
+	long base;
+	s8 t8s;
+	u8 t8;
+	s16 t16s;
+	u16 t16;
+	s32 t32s;
+
+	insn.word = ir;
+
+	base = regs->regs[insn.i_format.rs];
+	base = base + insn.i_format.simmediate;
+
+	switch (insn.i_format.opcode) {
+	case lb_op:
+		va8s = (s8 __user *)base;
+		if (!access_ok(VERIFY_READ, va8s, sizeof(t8s))) {
+			*fault_addr = va8s;
+			return SIGBUS;
+		}
+		if (__get_user_nocheck(t8s, va8s, sizeof(t8s))) {
+			*fault_addr = va8s;
+			return SIGSEGV;
+		}
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.i_format.rt] = (long)t8s;
+		return 0;
+	case lh_op:
+		va16s = (s16 __user *)base;
+		if (!access_ok(VERIFY_READ, va16s, sizeof(t16s))) {
+			*fault_addr = va16s;
+			return SIGBUS;
+		}
+		if (__get_user_nocheck(t16s, va16s, sizeof(t16s))) {
+			*fault_addr = va16s;
+			return SIGSEGV;
+		}
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.i_format.rt] = (long)t16s;
+		return 0;
+	case lw_op:
+		va32s = (s32 __user *)base;
+		if (!access_ok(VERIFY_READ, va32s, sizeof(t32s))) {
+			*fault_addr = va32s;
+			return SIGBUS;
+		}
+		if (__get_user_nocheck(t32s, va32s, sizeof(t32s))) {
+			*fault_addr = va32s;
+			return SIGSEGV;
+		}
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.i_format.rt] = (long)t32s;
+		return 0;
+	case lbu_op:
+		va8 = (u8 __user *)base;
+		if (!access_ok(VERIFY_READ, va8, sizeof(t8))) {
+			*fault_addr = va8;
+			return SIGBUS;
+		}
+		if (__get_user_nocheck(t8, va8, sizeof(t8))) {
+			*fault_addr = va8;
+			return SIGSEGV;
+		}
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.i_format.rt] = t8;
+		return 0;
+	case lhu_op:
+		va16 = (u16 __user *)base;
+		if (!access_ok(VERIFY_READ, va16, sizeof(t16))) {
+			*fault_addr = va16;
+			return SIGBUS;
+		}
+		if (__get_user_nocheck(t16, va16, sizeof(t16))) {
+			*fault_addr = va16;
+			return SIGSEGV;
+		}
+		if (insn.i_format.rt == 0)
+			return 0; /* ignore result */
+		regs->regs[insn.i_format.rt] = t16;
+		return 0;
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips_store_emul(struct pt_regs *regs, mips_instruction ir, void *__user *fault_addr)
+{
+	u8 __user *va8;
+	u16 __user *va16;
+	u32 __user *va32;
+	u8 t8;
+	u16 t16;
+	u32 t32;
+	union mips_instruction insn;
+	long base;
+
+	insn.word = ir;
+
+	base = regs->regs[insn.i_format.rs];
+	base = base + insn.i_format.simmediate;
+
+	switch (insn.i_format.opcode) {
+	case sb_op:
+		va8 = (u8 __user *)base;
+		if (!access_ok(VERIFY_WRITE, va8, sizeof(t8))) {
+			*fault_addr = va8;
+			return SIGBUS;
+		}
+		t8 = (u8)regs->regs[insn.i_format.rt];
+		if (__put_user_nocheck(t8, va8, sizeof(t8))) {
+			*fault_addr = va8;
+			return SIGSEGV;
+		}
+		return 0;
+	case sh_op:
+		va16 = (u16 __user *)base;
+		if (!access_ok(VERIFY_WRITE, va16, sizeof(t16))) {
+			*fault_addr = va16;
+			return SIGBUS;
+		}
+		t16 = (u16)regs->regs[insn.i_format.rt];
+		if (__put_user_nocheck(t16, va16, sizeof(t16))) {
+			*fault_addr = va16;
+			return SIGSEGV;
+		}
+		return 0;
+	case sw_op:
+		va32 = (u32 __user *)base;
+		if (!access_ok(VERIFY_WRITE, va32, sizeof(t32))) {
+			*fault_addr = va32;
+			return SIGBUS;
+		}
+		t32 = (u32)regs->regs[insn.i_format.rt];
+		if (__put_user_nocheck(t32, va32, sizeof(t32))) {
+			*fault_addr = va32;
+			return SIGSEGV;
+		}
+		return 0;
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips64_load_emul(struct pt_regs *regs, mips_instruction ir, void *__user *fault_addr)
+{
+	union mips_instruction insn;
+
+	insn.word = ir;
+	switch (insn.i_format.opcode) {
+	default:
+		return SIGILL;
+	}
+}
+
+static int mips64_store_emul(struct pt_regs *regs, mips_instruction ir, void *__user *fault_addr)
+{
+	union mips_instruction insn;
+
+	insn.word = ir;
+	switch (insn.i_format.opcode) {
+	default:
+		return SIGILL;
+	}
+}
+
+int mips_insn_emul(struct pt_regs *regs, mips_instruction ir, void *__user *fault_addr)
+{
+	switch (MIPSInst_OPCODE(ir)) {
+	case spec_op:
+		return mips_spec_emul(regs, ir);
+	case addi_op:
+	case addiu_op:
+	case slti_op:
+	case sltiu_op:
+	case andi_op:
+	case ori_op:
+	case xori_op:
+	case lui_op:
+		return mips_imm_emul(regs, ir);
+	case daddi_op:
+	case daddiu_op:
+		return mips64_imm_emul(regs, ir);
+	case spec2_op:
+		return mips_spec2_emul(regs, ir);
+	case spec3_op:
+		return mips_spec3_emul(regs, ir);
+	case lb_op:
+	case lh_op:
+	case lw_op:
+	case lbu_op:
+	case lhu_op:
+		return mips_load_emul(regs, ir, fault_addr);
+	case sb_op:
+	case sh_op:
+	case sw_op:
+		return mips_store_emul(regs, ir, fault_addr);
+	case lwu_op:
+	case ld_op:
+		return mips64_load_emul(regs, ir, fault_addr);
+	case sd_op:
+		return mips64_store_emul(regs, ir, fault_addr);
+	case pref_op:
+		return 0; /* OK to ignore PREF */
+	default:
+		return SIGILL;
+	}
+}
-- 
1.7.11.7

