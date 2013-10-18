Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3JRP0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:26:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55134 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3JRP0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:26:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v5 4/7] arm64: introduce aarch64_insn_gen_{nop|branch_imm}() helper functions
Date: Fri, 18 Oct 2013 23:19:58 +0800
Message-Id: <1382109602-27432-5-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce aarch64_insn_gen_{nop|branch_imm}() helper functions, which
will be used to implement jump label on ARM64.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h | 13 +++++++++++++
 arch/arm64/kernel/insn.c      | 28 ++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 8f94e48..ee4a60d 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -96,9 +96,22 @@ static __always_inline void aarch64_insn_write(void *addr, u32 insn)
 	*(u32 *)addr = cpu_to_le32(insn);
 }
 
+static __always_inline u32 aarch64_insn_gen_hint(enum aarch64_insn_hint_op op)
+{
+	return aarch64_insn_get_hint_value() | op;
+}
+
+static __always_inline u32 aarch64_insn_gen_nop(void)
+{
+	return aarch64_insn_gen_hint(AARCH64_INSN_HINT_NOP);
+}
+
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
+u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
+				bool link);
+
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 
 int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 886821f..f7498cc 100644
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
@@ -233,3 +234,30 @@ u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 
 	return insn;
 }
+
+u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr, bool link)
+{
+	u32 insn;
+	long offset;
+
+	/*
+	 * PC: A 64-bit Program Counter holding the address of the current
+	 * instruction. A64 instructions may be word-aligned.
+	 */
+	BUG_ON((pc & 0x3) || (addr & 0x3));
+
+	/*
+	 * B/BL support [-128M, 128M) offset
+	 * ARM64 virtual address arrangement garantees all kernel and module
+	 * texts are within +/-128M.
+	 */
+	offset = ((long)addr - (long)pc) >> 2;
+	BUG_ON(abs(offset) > BIT(25) || offset == BIT(25));
+
+	if (link)
+		insn = aarch64_insn_get_bl_value();
+	else
+		insn = aarch64_insn_get_b_value();
+
+	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn, offset);
+}
-- 
1.8.1.2

