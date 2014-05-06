Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbaEFP1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:27:08 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:36385 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255AbaEFP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:26:41 -0400
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
Subject: [PATCH 2/3] perf tests: Add dwarf unwind test on ARM
Date: Tue,  6 May 2014 17:26:18 +0200
Message-Id: <1399389979-11279-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399389979-11279-1-git-send-email-jean.pihet@linaro.org>
References: <1399389979-11279-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding dwarf unwind test, that setups live machine data over
the perf test thread and does the remote unwind.

Need to use -fno-optimize-sibling-calls for test compilation,
otherwise 'krava_*' function calls are optimized into jumps
and ommited from the stack unwind.

So far it was enabled only for x86.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/Makefile.perf                 |  2 +-
 tools/perf/arch/arm/Makefile             |  1 +
 tools/perf/arch/arm/include/perf_regs.h  |  3 ++
 tools/perf/arch/arm/tests/dwarf-unwind.c | 59 ++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c          |  2 +-
 tools/perf/tests/tests.h                 |  2 +-
 6 files changed, 66 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2baf61c..dea2d633 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -411,7 +411,7 @@ LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
 ifndef NO_DWARF_UNWIND
-ifeq ($(ARCH),x86)
+ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
 endif
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 9b8f87e..221f21d 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -5,4 +5,5 @@ endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
index 1476ae7..c2cefff 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -8,6 +8,9 @@
 void perf_regs_load(u64 *regs);
 
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
+#define PERF_REGS_MAX	PERF_REG_ARM_MAX
+#define PERF_SAMPLE_REGS_ABI	PERF_SAMPLE_REGS_ABI_32
+
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
 
diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
new file mode 100644
index 0000000..d618f5f
--- /dev/null
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -0,0 +1,59 @@
+#include <string.h>
+#include "perf_regs.h"
+#include "thread.h"
+#include "map.h"
+#include "event.h"
+#include "tests/tests.h"
+
+#define STACK_SIZE 8192
+
+static int sample_ustack(struct perf_sample *sample,
+			 struct thread *thread, u64 *regs)
+{
+	struct stack_dump *stack = &sample->user_stack;
+	struct map *map;
+	unsigned long sp;
+	u64 stack_size, *buf;
+
+	buf = malloc(STACK_SIZE);
+	if (!buf) {
+		pr_debug("failed to allocate sample uregs data\n");
+		return -1;
+	}
+
+	sp = (unsigned long) regs[PERF_REG_ARM_SP];
+
+	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
+	if (!map) {
+		pr_debug("failed to get stack map\n");
+		return -1;
+	}
+
+	stack_size = map->end - sp;
+	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
+
+	memcpy(buf, (void *) sp, stack_size);
+	stack->data = (char *) buf;
+	stack->size = stack_size;
+	return 0;
+}
+
+int test__arch_unwind_sample(struct perf_sample *sample,
+			     struct thread *thread)
+{
+	struct regs_dump *regs = &sample->user_regs;
+	u64 *buf;
+
+	buf = malloc(sizeof(u64) * PERF_REGS_MAX);
+	if (!buf) {
+		pr_debug("failed to allocate sample uregs data\n");
+		return -1;
+	}
+
+	perf_regs_load(buf);
+	regs->abi  = PERF_SAMPLE_REGS_ABI;
+	regs->regs = buf;
+	regs->mask = PERF_REGS_MASK;
+
+	return sample_ustack(sample, thread, buf);
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0d5afaf..5e0764b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -115,7 +115,7 @@ static struct test {
 		.desc = "Test parsing with no sample_id_all bit set",
 		.func = test__parse_no_sample_id_all,
 	},
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 	{
 		.desc = "Test dwarf unwind",
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a9d7cb0..8f91fb0 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -45,7 +45,7 @@ int test__hists_filter(void);
 int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 struct thread;
 struct perf_sample;
-- 
1.7.11.7

