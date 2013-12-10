Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3LJQIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:08:50 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60874 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3LJQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:08:38 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v6 2/7] arm64: introduce interfaces to hotpatch kernel and module code
Date: Wed, 11 Dec 2013 00:03:48 +0800
Message-Id: <1386691433-6827-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce three interfaces to patch kernel and module code:
aarch64_insn_patch_text_nosync():
	patch code without synchronization, it's caller's responsibility
	to synchronize all CPUs if needed.
aarch64_insn_patch_text_sync():
	patch code and always synchronize with stop_machine()
aarch64_insn_patch_text():
	patch code and synchronize with stop_machine() if needed

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h |  10 +++-
 arch/arm64/kernel/insn.c      | 117 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 1bdc44c..bf8085f 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -18,6 +18,9 @@
 #define	__ASM_INSN_H
 #include <linux/types.h>
 
+/* A64 instructions are always 32 bits. */
+#define	AARCH64_INSN_SIZE		4
+
 /*
  * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
  * Section C3.1 "A64 instruction index by encoding":
@@ -70,8 +73,13 @@ __AARCH64_INSN_FUNCS(hint,	0xFFFFF01F, 0xD503201F)
 
 bool aarch64_insn_is_nop(u32 insn);
 
+int aarch64_insn_read(void *addr, u32 *insnp);
+int aarch64_insn_write(void *addr, u32 insn);
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
-
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 
+int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
+int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
+int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
+
 #endif	/* __ASM_INSN_H */
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 56a2498..c1b002a8 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -16,6 +16,10 @@
  */
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/stop_machine.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
 #include <asm/insn.h>
 
 static int aarch64_insn_encoding_class[] = {
@@ -60,6 +64,28 @@ bool __kprobes aarch64_insn_is_nop(u32 insn)
 	}
 }
 
+/*
+ * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
+ * little-endian.
+ */
+int __kprobes aarch64_insn_read(void *addr, u32 *insnp)
+{
+	int ret;
+	u32 val;
+
+	ret = probe_kernel_read(&val, addr, AARCH64_INSN_SIZE);
+	if (!ret)
+		*insnp = le32_to_cpu(val);
+
+	return ret;
+}
+
+int __kprobes aarch64_insn_write(void *addr, u32 insn)
+{
+	insn = cpu_to_le32(insn);
+	return probe_kernel_write(addr, &insn, AARCH64_INSN_SIZE);
+}
+
 static bool __kprobes __aarch64_insn_hotpatch_safe(u32 insn)
 {
 	if (aarch64_get_insn_class(insn) != AARCH64_INSN_CLS_BR_SYS)
@@ -89,3 +115,94 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
 	return __aarch64_insn_hotpatch_safe(old_insn) &&
 	       __aarch64_insn_hotpatch_safe(new_insn);
 }
+
+int __kprobes aarch64_insn_patch_text_nosync(void *addr, u32 insn)
+{
+	u32 *tp = addr;
+	int ret;
+
+	/* A64 instructions must be word aligned */
+	if ((uintptr_t)tp & 0x3)
+		return -EINVAL;
+
+	ret = aarch64_insn_write(tp, insn);
+	if (ret == 0)
+		flush_icache_range((uintptr_t)tp,
+				   (uintptr_t)tp + AARCH64_INSN_SIZE);
+
+	return ret;
+}
+
+struct aarch64_insn_patch {
+	void		**text_addrs;
+	u32		*new_insns;
+	int		insn_cnt;
+	atomic_t	cpu_count;
+};
+
+static int __kprobes aarch64_insn_patch_text_cb(void *arg)
+{
+	int i, ret = 0;
+	struct aarch64_insn_patch *pp = arg;
+
+	/* The first CPU becomes master */
+	if (atomic_inc_return(&pp->cpu_count) == 1) {
+		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
+			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
+							     pp->new_insns[i]);
+		/* Make sure changes are visible to other CPUs and let them continue */
+		smp_wmb();
+		atomic_set(&pp->cpu_count, -1);
+	} else {
+		while (atomic_read(&pp->cpu_count) != -1)
+			cpu_relax();
+		smp_rmb();
+		isb();
+	}
+
+	return ret;
+}
+
+int __kprobes aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt)
+{
+	struct aarch64_insn_patch patch = {
+		.text_addrs = addrs,
+		.new_insns = insns,
+		.insn_cnt = cnt,
+		.cpu_count = ATOMIC_INIT(0),
+	};
+
+	if (cnt <= 0)
+		return -EINVAL;
+
+	return stop_machine(aarch64_insn_patch_text_cb, &patch,
+			    cpu_online_mask);
+}
+
+int __kprobes aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt)
+{
+	int ret;
+	u32 insn;
+
+	/* Unsafe to patch multiple instructions without synchronizaiton */
+	if (cnt == 1) {
+		ret = aarch64_insn_read(addrs[0], &insn);
+		if (ret)
+			return ret;
+
+		if (aarch64_insn_hotpatch_safe(insn, insns[0])) {
+			/*
+			 * ARMv8 architecture doesn't guarantee all CPUs see
+			 * the new instruction after returning from function
+			 * aarch64_insn_patch_text_nosync(). So send IPIs to
+			 * all other CPUs to achieve instruction
+			 * synchronization.
+			 */
+			ret = aarch64_insn_patch_text_nosync(addrs[0], insns[0]);
+			kick_all_cpus_sync();
+			return ret;
+		}
+	}
+
+	return aarch64_insn_patch_text_sync(addrs, insns, cnt);
+}
-- 
1.8.1.2

