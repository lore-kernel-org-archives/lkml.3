Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3IYKq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:46:26 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36416 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3IYKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:46:25 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 2/7] arm64: introduce interfaces to hotpatch kernel and module code
Date: Wed, 25 Sep 2013 18:44:22 +0800
Message-Id: <1380105868-31985-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce aarch64_insn_patch_text() and __aarch64_insn_patch_text()
to patch kernel and module code.

Function aarch64_insn_patch_text() is a heavy version which may use
stop_machine() to serialize all online CPUs, and function
__aarch64_insn_patch_text() is light version without explicitly
serialization.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h |  2 ++
 arch/arm64/kernel/insn.c      | 64 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index e7d1bc8..0ea7193 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -49,5 +49,7 @@ __AARCH64_INSN_FUNCS(nop,	0xFFFFFFFF, 0xD503201F)
 enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
 
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
+int aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
+int __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
 
 #endif	/* _ASM_ARM64_INSN_H */
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 8541c3a..50facfc 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -15,6 +15,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/kernel.h>
+#include <linux/stop_machine.h>
+#include <asm/cacheflush.h>
 #include <asm/insn.h>
 
 static int aarch64_insn_cls[] = {
@@ -69,3 +71,65 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
 	return __aarch64_insn_hotpatch_safe(old_insn) &&
 	       __aarch64_insn_hotpatch_safe(new_insn);
 }
+
+struct aarch64_insn_patch {
+	void	*text_addr;
+	u32	*new_insns;
+	int	insn_cnt;
+};
+
+int __kprobes __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
+{
+	int i;
+	u32 *tp = addr;
+
+	/* instructions must be word aligned */
+	if (cnt <= 0 || ((uintptr_t)addr & 0x3))
+		return -EINVAL;
+
+	for (i = 0; i < cnt; i++)
+		tp[i] = insns[i];
+
+	flush_icache_range((uintptr_t)tp, (uintptr_t)tp + cnt * sizeof(u32));
+
+	return 0;
+}
+
+static int __kprobes aarch64_insn_patch_text_cb(void *arg)
+{
+	struct aarch64_insn_patch *pp = arg;
+
+	return __aarch64_insn_patch_text(pp->text_addr, pp->new_insns,
+					 pp->insn_cnt);
+}
+
+int __kprobes aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
+{
+	int ret;
+	bool safe = false;
+
+	/* instructions must be word aligned */
+	if (cnt <= 0 || ((uintptr_t)addr & 0x3))
+		return -EINVAL;
+
+	if (cnt == 1)
+		safe = aarch64_insn_hotpatch_safe(*(u32 *)addr, insns[0]);
+
+	if (safe) {
+		ret = __aarch64_insn_patch_text(addr, insns, cnt);
+	} else {
+		struct aarch64_insn_patch patch = {
+			.text_addr = addr,
+			.new_insns = insns,
+			.insn_cnt = cnt,
+		};
+
+		/*
+		 * Execute __aarch64_insn_patch_text() on every online CPU,
+		 * which ensure serialization among all online CPUs.
+		 */
+		ret = stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
+	}
+
+	return ret;
+}
-- 
1.8.1.2

