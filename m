Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3LVPbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 10:31:13 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46129 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3LVPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 10:31:12 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v7 6/7] arm64, jump label: optimize jump label implementation
Date: Sun, 22 Dec 2013 23:25:42 +0800
Message-Id: <1387725944-810-7-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387725944-810-1-git-send-email-liuj97@gmail.com>
References: <1387725944-810-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize jump label implementation for ARM64 by dynamically patching
kernel text.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/Kconfig                  |  1 +
 arch/arm64/include/asm/jump_label.h | 51 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile          |  1 +
 arch/arm64/kernel/jump_label.c      | 58 +++++++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+)
 create mode 100644 arch/arm64/include/asm/jump_label.h
 create mode 100644 arch/arm64/kernel/jump_label.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d4dd22..5f962e8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -19,6 +19,7 @@ config ARM64
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
+	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
new file mode 100644
index 0000000..47cd130
--- /dev/null
+++ b/arch/arm64/include/asm/jump_label.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2013 Huawei Ltd.
+ * Author: Jiang Liu <liuj97@gmail.com>
+ *
+ * Based on arch/arm/include/asm/jump_label.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef _ASM_JUMP_LABEL_H
+#define _ASM_JUMP_LABEL_H
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+
+#define JUMP_LABEL_NOP_SIZE		4
+
+static __always_inline bool arch_static_branch(struct static_key *key)
+{
+	asm goto("1: nop\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 3\n\t"
+		 ".quad 1b, %l[l_yes], %c0\n\t"
+		 ".popsection\n\t"
+		 :  :  "i"(key) :  : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+#endif /* __KERNEL__ */
+
+typedef u64 jump_label_t;
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
+};
+
+#endif	/* _ASM_JUMP_LABEL_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cd95a25..e155d56 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/jump_label.c b/arch/arm64/kernel/jump_label.c
new file mode 100644
index 0000000..263a166
--- /dev/null
+++ b/arch/arm64/kernel/jump_label.c
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2013 Huawei Ltd.
+ * Author: Jiang Liu <liuj97@gmail.com>
+ *
+ * Based on arch/arm/kernel/jump_label.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/kernel.h>
+#include <linux/jump_label.h>
+#include <asm/insn.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+static void __arch_jump_label_transform(struct jump_entry *entry,
+					enum jump_label_type type,
+					bool is_static)
+{
+	void *addr = (void *)entry->code;
+	u32 insn;
+
+	if (type == JUMP_LABEL_ENABLE) {
+		insn = aarch64_insn_gen_branch_imm(entry->code,
+						   entry->target,
+						   AARCH64_INSN_BRANCH_NOLINK);
+	} else {
+		insn = aarch64_insn_gen_nop();
+	}
+
+	if (is_static)
+		aarch64_insn_patch_text_nosync(addr, insn);
+	else
+		aarch64_insn_patch_text(&addr, &insn, 1);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	__arch_jump_label_transform(entry, type, false);
+}
+
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type)
+{
+	__arch_jump_label_transform(entry, type, true);
+}
+
+#endif	/* HAVE_JUMP_LABEL */
-- 
1.8.1.2

