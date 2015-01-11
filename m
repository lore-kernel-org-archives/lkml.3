Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbbAKEDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:03:40 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59475 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAKED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:03:27 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] arm64: Add more test functions to insn.c
Date: Sat, 10 Jan 2015 23:03:17 -0500
Message-Id: <1420949002-3726-3-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Certain instructions are hard to execute correctly out-of-line (as in
kprobes).  Test functions are added to insn.[hc] to identify these.  The
instructions include any that use PC-relative addressing, change the PC,
or change interrupt masking. For efficiency and simplicity test
functions are also added for small collections of related instructions.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm64/include/asm/insn.h | 21 +++++++++++++++++++--
 arch/arm64/kernel/insn.c      | 18 ++++++++++++++++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index e2ff32a..466afd4 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -223,8 +223,13 @@ static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
 static __always_inline u32 aarch64_insn_get_##abbr##_value(void) \
 { return (val); }
 
+__AARCH64_INSN_FUNCS(adr,	0x9F000000, 0x10000000)
+__AARCH64_INSN_FUNCS(prfm_lit,	0xFF000000, 0xD8000000)
 __AARCH64_INSN_FUNCS(str_reg,	0x3FE0EC00, 0x38206800)
 __AARCH64_INSN_FUNCS(ldr_reg,	0x3FE0EC00, 0x38606800)
+__AARCH64_INSN_FUNCS(ldr_lit,	0xBF000000, 0x18000000)
+__AARCH64_INSN_FUNCS(ldrsw_lit,	0xFF000000, 0x98000000)
+__AARCH64_INSN_FUNCS(exclusive,	0x3F000000, 0x08000000)
 __AARCH64_INSN_FUNCS(stp_post,	0x7FC00000, 0x28800000)
 __AARCH64_INSN_FUNCS(ldp_post,	0x7FC00000, 0x28C00000)
 __AARCH64_INSN_FUNCS(stp_pre,	0x7FC00000, 0x29800000)
@@ -264,9 +269,15 @@ __AARCH64_INSN_FUNCS(ands,	0x7F200000, 0x6A000000)
 __AARCH64_INSN_FUNCS(bics,	0x7F200000, 0x6A200000)
 __AARCH64_INSN_FUNCS(b,		0xFC000000, 0x14000000)
 __AARCH64_INSN_FUNCS(bl,	0xFC000000, 0x94000000)
-__AARCH64_INSN_FUNCS(cbz,	0xFE000000, 0x34000000)
-__AARCH64_INSN_FUNCS(cbnz,	0xFE000000, 0x35000000)
+__AARCH64_INSN_FUNCS(b_bl,	0x7C000000, 0x14000000)
+__AARCH64_INSN_FUNCS(cb,	0x7E000000, 0x34000000)
+__AARCH64_INSN_FUNCS(cbz,	0x7F000000, 0x34000000)
+__AARCH64_INSN_FUNCS(cbnz,	0x7F000000, 0x35000000)
 __AARCH64_INSN_FUNCS(bcond,	0xFF000010, 0x54000000)
+__AARCH64_INSN_FUNCS(tb,	0x7E000000, 0x36000000)
+__AARCH64_INSN_FUNCS(tbz,	0x7F000000, 0x36000000)
+__AARCH64_INSN_FUNCS(tbnz,	0x7F000000, 0x37000000)
+__AARCH64_INSN_FUNCS(b_bl_cb_tb, 0x5C000000, 0x14000000)
 __AARCH64_INSN_FUNCS(svc,	0xFFE0001F, 0xD4000001)
 __AARCH64_INSN_FUNCS(hvc,	0xFFE0001F, 0xD4000002)
 __AARCH64_INSN_FUNCS(smc,	0xFFE0001F, 0xD4000003)
@@ -274,7 +285,11 @@ __AARCH64_INSN_FUNCS(brk,	0xFFE0001F, 0xD4200000)
 __AARCH64_INSN_FUNCS(hint,	0xFFFFF01F, 0xD503201F)
 __AARCH64_INSN_FUNCS(br,	0xFFFFFC1F, 0xD61F0000)
 __AARCH64_INSN_FUNCS(blr,	0xFFFFFC1F, 0xD63F0000)
+__AARCH64_INSN_FUNCS(br_blr,	0xFFDFFC1F, 0xD61F0000)
 __AARCH64_INSN_FUNCS(ret,	0xFFFFFC1F, 0xD65F0000)
+__AARCH64_INSN_FUNCS(msr_imm,	0xFFF8F000, 0xD5004000)
+__AARCH64_INSN_FUNCS(msr_reg,	0xFFF00000, 0xD5100000)
+__AARCH64_INSN_FUNCS(msr_daif,	0xFFFFF0DF, 0xD50340DF)
 
 #undef	__AARCH64_INSN_FUNCS
 
@@ -283,6 +298,8 @@ bool aarch64_insn_is_nop(u32 insn);
 int aarch64_insn_read(void *addr, u32 *insnp);
 int aarch64_insn_write(void *addr, u32 insn);
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
+bool aarch64_insn_uses_literal(u32 insn);
+bool aarch64_insn_is_branch(u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
 u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 7e9327a..8021722 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -72,6 +72,24 @@ bool __kprobes aarch64_insn_is_nop(u32 insn)
 	}
 }
 
+bool aarch64_insn_uses_literal(u32 insn)
+{
+	/* ldr/ldrsw (literal), prfm */
+
+	return aarch64_insn_is_ldr_lit(insn) ||
+		aarch64_insn_is_ldrsw_lit(insn) ||
+		aarch64_insn_is_prfm_lit(insn);
+}
+
+bool aarch64_insn_is_branch(u32 insn)
+{
+	/* b, bl, cb*, tb*, b.cond, br, blr */
+
+	return aarch64_insn_is_b_bl_cb_tb(insn) ||
+		aarch64_insn_is_br_blr(insn) ||
+		aarch64_insn_is_bcond(insn);
+}
+
 /*
  * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
  * little-endian.
-- 
1.8.1.2

