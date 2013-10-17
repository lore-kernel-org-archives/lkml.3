Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3JQG3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:29:47 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42707 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3JQG3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:29:45 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v4 2/7] arm64: introduce interfaces to hotpatch kernel and module code
Date: Thu, 17 Oct 2013 14:19:35 +0800
Message-Id: <1381990781-27814-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381990781-27814-1-git-send-email-liuj97@gmail.com>
References: <1381990781-27814-1-git-send-email-liuj97@gmail.com>
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
 arch/arm64/include/asm/insn.h | 24 +++++++++++++-
 arch/arm64/kernel/insn.c      | 77 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 6190016..fc439b9 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -60,8 +60,30 @@ __AARCH64_INSN_FUNCS(nop,	0xFFFFFFFF, 0xD503201F)
 
 #undef	__AARCH64_INSN_FUNCS
 
-enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
+/*
+ * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
+ * little-endian. On the other hand, SCTLR_EL1.EE (bit 25, Exception Endianness)
+ * flag controls endianness for EL1 explicit data accesses and stage 1
+ * translation table walks as below:
+ *	0: little-endian
+ *	1: big-endian
+ * So need to handle endianness when patching kernel code.
+ */
+static __always_inline u32 aarch64_insn_read(void *addr)
+{
+	return le32_to_cpu(*(u32 *)addr);
+}
 
+static __always_inline void aarch64_insn_write(void *addr, u32 insn)
+{
+	*(u32 *)addr = cpu_to_le32(insn);
+}
+
+enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 
+int aarch64_insn_patch_text_nosync(void *addrs[], u32 insns[], int cnt);
+int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
+int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
+
 #endif	/* _ASM_ARM64_INSN_H */
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 1c501f3..8dd5fbe 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -16,6 +16,9 @@
  */
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/stop_machine.h>
+#include <asm/cacheflush.h>
 #include <asm/insn.h>
 
 static int aarch64_insn_encoding_cls[] = {
@@ -70,3 +73,77 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
 	return __aarch64_insn_hotpatch_safe(old_insn) &&
 	       __aarch64_insn_hotpatch_safe(new_insn);
 }
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
+	int ret;
+
+	if (cnt == 1 && aarch64_insn_hotpatch_safe(aarch64_insn_read(addrs[0]),
+						   insns[0])) {
+		/*
+		 * It doesn't guarantee all CPUs see the new instruction
+		 * after returning from aarch64_insn_patch_text_nosync().
+		 * So send a IPI to all other CPUs to achieve instruction
+		 * synchronization.
+		 */
+		ret = aarch64_insn_patch_text_nosync(addrs, insns, cnt);
+		kick_all_cpus_sync();
+	} else {
+		ret = aarch64_insn_patch_text_sync(addrs, insns, cnt);
+	}
+
+	return ret;
+}
-- 
1.8.1.2

