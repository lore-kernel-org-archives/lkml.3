Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaAGOV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:21:59 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62020 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaAGOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:21:54 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v8 4/7] arm64: introduce aarch64_insn_gen_{nop|branch_imm}() helper functions
Date: Tue,  7 Jan 2014 22:17:11 +0800
Message-Id: <1389104234-15239-5-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
References: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce aarch64_insn_gen_{nop|branch_imm}() helper functions, which
will be used to implement jump label on ARM64.

Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h | 10 ++++++++++
 arch/arm64/kernel/insn.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index fb44660..c44ad39 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -66,6 +66,11 @@ enum aarch64_insn_imm_type {
 	AARCH64_INSN_IMM_MAX
 };
 
+enum aarch64_insn_branch_type {
+	AARCH64_INSN_BRANCH_NOLINK,
+	AARCH64_INSN_BRANCH_LINK,
+};
+
 #define	__AARCH64_INSN_FUNCS(abbr, mask, val)	\
 static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
 { return (code & (mask)) == (val); } \
@@ -89,6 +94,11 @@ int aarch64_insn_write(void *addr, u32 insn);
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
+u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
+				enum aarch64_insn_branch_type type);
+u32 aarch64_insn_gen_hint(enum aarch64_insn_hint_op op);
+u32 aarch64_insn_gen_nop(void);
+
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 
 int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 7df0807..92f3683 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -14,6 +14,7 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+#include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/smp.h>
@@ -262,3 +263,42 @@ u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 
 	return insn;
 }
+
+u32 __kprobes aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
+					  enum aarch64_insn_branch_type type)
+{
+	u32 insn;
+	long offset;
+
+	/*
+	 * PC: A 64-bit Program Counter holding the address of the current
+	 * instruction. A64 instructions must be word-aligned.
+	 */
+	BUG_ON((pc & 0x3) || (addr & 0x3));
+
+	/*
+	 * B/BL support [-128M, 128M) offset
+	 * ARM64 virtual address arrangement guarantees all kernel and module
+	 * texts are within +/-128M.
+	 */
+	offset = ((long)addr - (long)pc);
+	BUG_ON(offset < -SZ_128M || offset >= SZ_128M);
+
+	if (type == AARCH64_INSN_BRANCH_LINK)
+		insn = aarch64_insn_get_bl_value();
+	else
+		insn = aarch64_insn_get_b_value();
+
+	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
+					     offset >> 2);
+}
+
+u32 __kprobes aarch64_insn_gen_hint(enum aarch64_insn_hint_op op)
+{
+	return aarch64_insn_get_hint_value() | op;
+}
+
+u32 __kprobes aarch64_insn_gen_nop(void)
+{
+	return aarch64_insn_gen_hint(AARCH64_INSN_HINT_NOP);
+}
-- 
1.8.1.2

