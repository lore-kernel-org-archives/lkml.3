Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbaEFP0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:26:43 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62127 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEFP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:26:39 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, will.deacon@arm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] perf tests: Introduce perf_regs_load function on ARM
Date: Tue,  6 May 2014 17:26:17 +0200
Message-Id: <1399389979-11279-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399389979-11279-1-git-send-email-jean.pihet@linaro.org>
References: <1399389979-11279-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf_regs_load function, which is going
to be used for dwarf unwind test in following patches.

It takes single argument as a pointer to the regs dump
buffer and populates it with current registers values.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/arch/arm/Makefile            |  1 +
 tools/perf/arch/arm/include/perf_regs.h |  2 ++
 tools/perf/arch/arm/tests/regs_load.S   | 60 +++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)
 create mode 100644 tools/perf/arch/arm/tests/regs_load.S

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
index 2a1cfde..1476ae7 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -5,6 +5,8 @@
 #include "../../util/types.h"
 #include <asm/perf_regs.h>
 
+void perf_regs_load(u64 *regs);
+
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
diff --git a/tools/perf/arch/arm/tests/regs_load.S b/tools/perf/arch/arm/tests/regs_load.S
new file mode 100644
index 0000000..66a10b6
--- /dev/null
+++ b/tools/perf/arch/arm/tests/regs_load.S
@@ -0,0 +1,60 @@
+#include <linux/linkage.h>
+#include <asm/assembler.h>
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
+ * - the return values (i.e. caller values) of fp, sp and lr are retrieved
+ *   and stored from the fp, in order to skip the call to this function.
+ * The built-in unwinding test then unwinds the call stack from the dwarf
+ * information in unwind__get_entries.
+ *
+ * Notes:
+ * - the 8 bytes stride in the registers offsets comes from the fact
+ * that the registers are stored in an u64 array (u64 *regs),
+ * - since perf is built with -fno-omit-frame-pointer, the fp value can
+ * be used to retrieve the caller values of fp, sp, lr.
+ */
+
+.text
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
+	ldr r2, [fp, #-12]	@ retrieve and save return fp
+	str r2, [r0, #FP]
+	str ip, [r0, #IP]
+	ldr r2, [fp, #-8]	@ retrieve and save return sp
+	str r2, [r0, #SP]
+	ldr r2, [fp, #-4]	@ retrieve and save return lr
+	str r2, [r0, #LR]
+	str pc, [r0, #PC]
+	mov pc, lr
+ENDPROC(perf_regs_load)
-- 
1.7.11.7

