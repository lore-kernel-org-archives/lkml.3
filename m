Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbaEFPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:55:54 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43805 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbaEFPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:55:51 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, will.deacon@arm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        Steve Capper <steve.capper@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] perf tests: Introduce perf_regs_load function on ARM64
Date: Tue,  6 May 2014 17:55:31 +0200
Message-Id: <1399391733-11927-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399391733-11927-1-git-send-email-jean.pihet@linaro.org>
References: <1399391733-11927-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf_regs_load function, which is going
to be used for dwarf unwind test in following patches.

It takes single argument as a pointer to the regs dump
buffer and populates it with current registers values, as
expected by the perf built-in unwinding test.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Steve Capper <steve.capper@linaro.org>
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
 tools/perf/arch/arm64/Makefile            |  1 +
 tools/perf/arch/arm64/include/perf_regs.h |  2 ++
 tools/perf/arch/arm64/tests/regs_load.S   | 39 +++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)
 create mode 100644 tools/perf/arch/arm64/tests/regs_load.S

diff --git a/tools/perf/arch/arm64/Makefile b/tools/perf/arch/arm64/Makefile
index 67e9b3d..9b8f87e 100644
--- a/tools/perf/arch/arm64/Makefile
+++ b/tools/perf/arch/arm64/Makefile
@@ -4,4 +4,5 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 endif
diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
index 2359546..1e052f1 100644
--- a/tools/perf/arch/arm64/include/perf_regs.h
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -9,6 +9,8 @@
 #define PERF_REG_IP	PERF_REG_ARM64_PC
 #define PERF_REG_SP	PERF_REG_ARM64_SP
 
+void perf_regs_load(u64 *regs);
+
 static inline const char *perf_reg_name(int id)
 {
 	switch (id) {
diff --git a/tools/perf/arch/arm64/tests/regs_load.S b/tools/perf/arch/arm64/tests/regs_load.S
new file mode 100644
index 0000000..92ab968
--- /dev/null
+++ b/tools/perf/arch/arm64/tests/regs_load.S
@@ -0,0 +1,39 @@
+#include <linux/linkage.h>
+
+/*
+ * Implementation of void perf_regs_load(u64 *regs);
+ *
+ * This functions fills in the 'regs' buffer from the actual registers values,
+ * in the way the perf built-in unwinding test expects them:
+ * - the PC at the time at the call to this function. Since this function
+ *   is called using a bl instruction, the PC value is taken from LR,
+ * - the current SP (not touched by this function),
+ * - the current value of LR is merely retrieved and stored because the
+ *   value before the call to this function is unknown at this time; it will
+ *   be unwound from the dwarf information in unwind__get_entries.
+ */
+
+.text
+.type perf_regs_load,%function
+ENTRY(perf_regs_load)
+	stp x0,  x1,  [x0], #16	// store x0..x29
+	stp x2,  x3,  [x0], #16
+	stp x4,  x5,  [x0], #16
+	stp x6,  x7,  [x0], #16
+	stp x8,  x9,  [x0], #16
+	stp x10, x11, [x0], #16
+	stp x12, x13, [x0], #16
+	stp x14, x15, [x0], #16
+	stp x16, x17, [x0], #16
+	stp x18, x19, [x0], #16
+	stp x20, x21, [x0], #16
+	stp x22, x23, [x0], #16
+	stp x24, x25, [x0], #16
+	stp x26, x27, [x0], #16
+	stp x28, x29, [x0], #16
+	mov x1,  sp
+	stp x30, x1,  [x0], #16	// store lr and sp
+	str x30, [x0]		// store pc as lr in order to skip the call
+				//  to this function
+	ret
+ENDPROC(perf_regs_load)
-- 
1.7.11.7

