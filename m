Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3JMOww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 10:52:52 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65350 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3JMOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 10:52:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 2/7] arm64: introduce interfaces to hotpatch kernel and module code
Date: Sun, 13 Oct 2013 22:50:22 +0800
Message-Id: <1381675827-1610-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381675827-1610-1-git-send-email-liuj97@gmail.com>
References: <1381675827-1610-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce three interfaces to patch kernel and module code:
aarch64_insn_patch_text_nosync():
	patch code without synchronization, it's caller's responsibility
	to synchronize all CPUs if needed.
aarch64_insn_patch_text_sync():
	patch code and always synchronize with stop_machine()
aarch64_insn_patch_text():
	patch code and synchronize with stop_machine() if needed

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h |   7 ++-
 arch/arm64/kernel/insn.c      | 101 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index e7d1bc8..2dfcdb4 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -47,7 +47,12 @@ __AARCH64_INSN_FUNCS(nop,	0xFFFFFFFF, 0xD503201F)
 #undef	__AARCH64_INSN_FUNCS
 
 enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
-
+u32 aarch64_insn_read(void *addr);
+void aarch64_insn_write(void *addr, u32 insn);
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 
+int aarch64_insn_patch_text_nosync(void *addrs[], u32 insns[], int cnt);
+int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
+int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
+
 #endif	/* _ASM_ARM64_INSN_H */
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index cc54705..40acf0e 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -15,6 +15,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/kernel.h>
+#include <linux/stop_machine.h>
+#include <asm/cacheflush.h>
 #include <asm/insn.h>
 
 /*
@@ -83,3 +85,102 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
 	return __aarch64_insn_hotpatch_safe(old_insn) &&
 	       __aarch64_insn_hotpatch_safe(new_insn);
 }
+
+/*
+ * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
+ * little-endian. On the other hand, SCTLR_EL1.EE (bit 25, Exception Endianness)
+ * flag controls endianness for EL1 explicit data accesses and stage 1
+ * translation table walks as below:
+ *	0: little-endian
+ *	1: big-endian
+ * So need to handle endianness when patching kernel code.
+ */
+static inline unsigned int __kprobes aarch64_is_el1_big_endian(void)
+{
+	u32 sctlr;
+
+	asm volatile ("mrs %0, sctlr_el1" : "=r" (sctlr));
+	return (sctlr >> 25) & 0x1;
+}
+
+u32 __kprobes aarch64_insn_read(void *addr)
+{
+	u32 insn;
+
+	if (aarch64_is_el1_big_endian())
+		insn = swab32(*(u32 *)addr);
+	else
+		insn = *(u32 *)addr;
+
+	return insn;
+}
+
+void __kprobes aarch64_insn_write(void *addr, u32 insn)
+{
+	if (aarch64_is_el1_big_endian())
+		*(u32 *)addr = swab32(insn);
+	else
+		*(u32 *)addr = insn;
+}
+
+int __kprobes aarch64_insn_patch_text_nosync(void *addrs[], u32 insns[],
+					     int cnt)
+{
+	int i;
+	u32 *tp;
+
+	if (cnt <= 0)
+		return -EINVAL;
+
+	for (i = 0; i < cnt; i++) {
+		tp = addrs[i];
+		/* A64 instructions must be word aligned */
+		if ((uintptr_t)tp & 0x3)
+			return -EINVAL;
+		aarch64_insn_write(tp, insns[i]);
+		flush_icache_range((uintptr_t)tp, (uintptr_t)tp + sizeof(u32));
+	}
+
+	return 0;
+}
+
+struct aarch64_insn_patch {
+	void	**text_addrs;
+	u32	*new_insns;
+	int	insn_cnt;
+};
+
+static int __kprobes aarch64_insn_patch_text_cb(void *arg)
+{
+	struct aarch64_insn_patch *pp = arg;
+
+	return aarch64_insn_patch_text_nosync(pp->text_addrs, pp->new_insns,
+					      pp->insn_cnt);
+}
+
+int __kprobes aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt)
+{
+	struct aarch64_insn_patch patch = {
+		.text_addrs = addrs,
+		.new_insns = insns,
+		.insn_cnt = cnt,
+	};
+
+	if (cnt <= 0)
+		return -EINVAL;
+
+	/*
+	 * Execute __aarch64_insn_patch_text() on every online CPU,
+	 * which ensure serialization among all online CPUs.
+	 */
+	return stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
+}
+
+int __kprobes aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt)
+{
+	if (cnt == 1 && aarch64_insn_hotpatch_safe(aarch64_insn_read(addrs[0]),
+						   insns[0]))
+		return aarch64_insn_patch_text_nosync(addrs, insns, cnt);
+	else
+		return aarch64_insn_patch_text_sync(addrs, insns, cnt);
+}
-- 
1.8.1.2

