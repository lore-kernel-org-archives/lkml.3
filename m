Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaCOFrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:47:25 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56249 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaCOFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:47:20 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v7 6/7] arm64: ftrace: Add CALLER_ADDRx macros
Date: Sat, 15 Mar 2014 14:45:52 +0900
Message-Id: <1394862353-28963-7-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CALLER_ADDRx returns caller's address at specified level in call stacks.
They are used for several tracers like irqsoff and preemptoff.
Strange to say, however, they are refered even without FTRACE.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/ftrace.h    | 13 ++++++++-
 arch/arm64/kernel/Makefile         |  3 ++-
 arch/arm64/kernel/return_address.c | 55 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kernel/return_address.c

diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index ed5c448..c44c4b1 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -18,6 +18,7 @@
 
 #ifndef __ASSEMBLY__
 extern void _mcount(unsigned long);
+extern void *return_address(unsigned int);
 
 struct dyn_arch_ftrace {
 	/* No extra data needed for arm64 */
@@ -33,6 +34,16 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 	 */
 	return addr;
 }
-#endif /* __ASSEMBLY__ */
+
+#define HAVE_ARCH_CALLER_ADDR
+
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#define CALLER_ADDR1 ((unsigned long)return_address(1))
+#define CALLER_ADDR2 ((unsigned long)return_address(2))
+#define CALLER_ADDR3 ((unsigned long)return_address(3))
+#define CALLER_ADDR4 ((unsigned long)return_address(4))
+#define CALLER_ADDR5 ((unsigned long)return_address(5))
+#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#endif /* ifndef __ASSEMBLY__ */
 
 #endif /* __ASM_FTRACE_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index ac67fd0..b5bfa7f 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -7,12 +7,13 @@ AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_insn.o = -pg
+CFLAGS_REMOVE_return_address.o = -pg
 
 # Object file lists.
 arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
-			   hyp-stub.o psci.o cpu_ops.o insn.o
+			   hyp-stub.o psci.o cpu_ops.o insn.o return_address.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
new file mode 100644
index 0000000..89102a6
--- /dev/null
+++ b/arch/arm64/kernel/return_address.c
@@ -0,0 +1,55 @@
+/*
+ * arch/arm64/kernel/return_address.c
+ *
+ * Copyright (C) 2013 Linaro Limited
+ * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/export.h>
+#include <linux/ftrace.h>
+
+#include <asm/stacktrace.h>
+
+struct return_address_data {
+	unsigned int level;
+	void *addr;
+};
+
+static int save_return_addr(struct stackframe *frame, void *d)
+{
+	struct return_address_data *data = d;
+
+	if (!data->level) {
+		data->addr = (void *)frame->pc;
+		return 1;
+	} else {
+		--data->level;
+		return 0;
+	}
+}
+
+void *return_address(unsigned int level)
+{
+	struct return_address_data data;
+	struct stackframe frame;
+	register unsigned long current_sp asm ("sp");
+
+	data.level = level + 2;
+	data.addr = NULL;
+
+	frame.fp = (unsigned long)__builtin_frame_address(0);
+	frame.sp = current_sp;
+	frame.pc = (unsigned long)return_address; /* dummy */
+
+	walk_stackframe(&frame, save_return_addr, &data);
+
+	if (!data.level)
+		return data.addr;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(return_address);
-- 
1.8.3.2

