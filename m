Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaEUF4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:56:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEUFz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:55:58 -0400
Date: Tue, 20 May 2014 22:55:27 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-3418f9667e8cc4070a86215e6c12baa5bc2f2799@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, jean.pihet@linaro.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, will.deacon@arm.com,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1400229672-16104-2-git-send-email-jean.pihet@linaro.org>
References: <1400229672-16104-2-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Introduce perf_regs_load function on ARM
Git-Commit-ID: 3418f9667e8cc4070a86215e6c12baa5bc2f2799
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3418f9667e8cc4070a86215e6c12baa5bc2f2799
Gitweb:     http://git.kernel.org/tip/3418f9667e8cc4070a86215e6c12baa5bc2f2799
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Fri, 16 May 2014 10:41:10 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 16 May 2014 11:39:05 +0200

perf tests: Introduce perf_regs_load function on ARM

Introducing perf_regs_load function, which is going
to be used for dwarf unwind test in following patches.

It takes single argument as a pointer to the regs dump
buffer and populates it with current registers values.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1400229672-16104-2-git-send-email-jean.pihet@linaro.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/arm/Makefile            |  1 +
 tools/perf/arch/arm/include/perf_regs.h |  2 ++
 tools/perf/arch/arm/tests/regs_load.S   | 58 +++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 67e9b3d..9b8f87e 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -4,4 +4,5 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 endif
diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
index bcca511..33abcfa 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <asm/perf_regs.h>
 
+void perf_regs_load(u64 *regs);
+
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
diff --git a/tools/perf/arch/arm/tests/regs_load.S b/tools/perf/arch/arm/tests/regs_load.S
new file mode 100644
index 0000000..e09e983
--- /dev/null
+++ b/tools/perf/arch/arm/tests/regs_load.S
@@ -0,0 +1,58 @@
+#include <linux/linkage.h>
+
+#define R0 0x00
+#define R1 0x08
+#define R2 0x10
+#define R3 0x18
+#define R4 0x20
+#define R5 0x28
+#define R6 0x30
+#define R7 0x38
+#define R8 0x40
+#define R9 0x48
+#define SL 0x50
+#define FP 0x58
+#define IP 0x60
+#define SP 0x68
+#define LR 0x70
+#define PC 0x78
+
+/*
+ * Implementation of void perf_regs_load(u64 *regs);
+ *
+ * This functions fills in the 'regs' buffer from the actual registers values,
+ * in the way the perf built-in unwinding test expects them:
+ * - the PC at the time at the call to this function. Since this function
+ *   is called using a bl instruction, the PC value is taken from LR.
+ * The built-in unwinding test then unwinds the call stack from the dwarf
+ * information in unwind__get_entries.
+ *
+ * Notes:
+ * - the 8 bytes stride in the registers offsets comes from the fact
+ * that the registers are stored in an u64 array (u64 *regs),
+ * - the regs buffer needs to be zeroed before the call to this function,
+ * in this case using a calloc in dwarf-unwind.c.
+ */
+
+.text
+.type perf_regs_load,%function
+ENTRY(perf_regs_load)
+	str r0, [r0, #R0]
+	str r1, [r0, #R1]
+	str r2, [r0, #R2]
+	str r3, [r0, #R3]
+	str r4, [r0, #R4]
+	str r5, [r0, #R5]
+	str r6, [r0, #R6]
+	str r7, [r0, #R7]
+	str r8, [r0, #R8]
+	str r9, [r0, #R9]
+	str sl, [r0, #SL]
+	str fp, [r0, #FP]
+	str ip, [r0, #IP]
+	str sp, [r0, #SP]
+	str lr, [r0, #LR]
+	str lr, [r0, #PC]	// store pc as lr in order to skip the call
+	                        //  to this function
+	mov pc, lr
+ENDPROC(perf_regs_load)
