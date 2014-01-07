Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaAGMvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:51:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaAGMs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:27 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 12/16] perf tools: Separate perf_reg_value function in perf_regs object
Date: Tue,  7 Jan 2014 13:47:29 +0100
Message-Id: <1389098853-14466-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making perf_reg_value function global (formely reg_value), because
it's going to be used globaly across all code providing the dwarf
post unwind feature.

Changing its prototype to be generic:
  -int reg_value(unw_word_t *valp, struct regs_dump *regs, int id)
  +int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);

Changing the valp type from libunwind specific
'unw_word_t' to u64.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/Makefile.perf           |  1 +
 tools/perf/util/perf_regs.c        | 19 +++++++++++++++++++
 tools/perf/util/perf_regs.h        | 13 +++++++++++++
 tools/perf/util/unwind-libunwind.c | 38 ++++++++++++--------------------------
 4 files changed, 45 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/util/perf_regs.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 29e7e2b..33c8782 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -537,6 +537,7 @@ ifeq ($(NO_PERF_REGS),0)
   ifeq ($(ARCH),x86)
     LIB_H += arch/x86/include/perf_regs.h
   endif
+  LIB_OBJS += $(OUTPUT)util/perf_regs.o
 endif
 
 ifndef NO_LIBNUMA
diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
new file mode 100644
index 0000000..a3539ef
--- /dev/null
+++ b/tools/perf/util/perf_regs.c
@@ -0,0 +1,19 @@
+#include <errno.h>
+#include "perf_regs.h"
+
+int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
+{
+	int i, idx = 0;
+	u64 mask = regs->mask;
+
+	if (!(mask & (1 << id)))
+		return -EINVAL;
+
+	for (i = 0; i < id; i++) {
+		if (mask & (1 << i))
+			idx++;
+	}
+
+	*valp = regs->regs[idx];
+	return 0;
+}
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index a3d42cd..d6e8b6a 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,8 +1,14 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
+#include "types.h"
+#include "event.h"
+
 #ifdef HAVE_PERF_REGS_SUPPORT
 #include <perf_regs.h>
+
+int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
+
 #else
 #define PERF_REGS_MASK	0
 
@@ -10,5 +16,12 @@ static inline const char *perf_reg_name(int id __maybe_unused)
 {
 	return NULL;
 }
+
+static inline int perf_reg_value(u64 *valp __maybe_unused,
+				 struct regs_dump *regs __maybe_unused,
+				 int id __maybe_unused)
+{
+	return 0;
+}
 #endif /* HAVE_PERF_REGS_SUPPORT */
 #endif /* __PERF_REGS_H */
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 95cfb54..cd3a330 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -406,30 +406,13 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	return !(size == sizeof(*data));
 }
 
-static int reg_value(unw_word_t *valp, struct regs_dump *regs, int id)
-{
-	int i, idx = 0;
-	u64 mask = regs->mask;
-
-	if (!(mask & (1 << id)))
-		return -EINVAL;
-
-	for (i = 0; i < id; i++) {
-		if (mask & (1 << i))
-			idx++;
-	}
-
-	*valp = regs->regs[idx];
-	return 0;
-}
-
 static int access_mem(unw_addr_space_t __maybe_unused as,
 		      unw_word_t addr, unw_word_t *valp,
 		      int __write, void *arg)
 {
 	struct unwind_info *ui = arg;
 	struct stack_dump *stack = &ui->sample->user_stack;
-	unw_word_t start, end;
+	u64 start, end;
 	int offset;
 	int ret;
 
@@ -439,7 +422,7 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	ret = reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
+	ret = perf_reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
 	if (ret)
 		return ret;
 
@@ -452,8 +435,9 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 	if (addr < start || addr + sizeof(unw_word_t) >= end) {
 		ret = access_dso_mem(ui, addr, valp);
 		if (ret) {
-			pr_debug("unwind: access_mem %p not inside range %p-%p\n",
-				(void *)addr, (void *)start, (void *)end);
+			pr_debug("unwind: access_mem %p not inside range"
+				 " 0x%" PRIx64 "-0x%" PRIx64 "\n",
+				 (void *) addr, start, end);
 			*valp = 0;
 			return ret;
 		}
@@ -462,8 +446,8 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 
 	offset = addr - start;
 	*valp  = *(unw_word_t *)&stack->data[offset];
-	pr_debug("unwind: access_mem addr %p, val %lx, offset %d\n",
-		 (void *)addr, (unsigned long)*valp, offset);
+	pr_debug("unwind: access_mem addr %p val %lx, offset %d\n",
+		 (void *) addr, (unsigned long)*valp, offset);
 	return 0;
 }
 
@@ -473,6 +457,7 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 {
 	struct unwind_info *ui = arg;
 	int id, ret;
+	u64 val;
 
 	/* Don't support write, I suspect we don't need it. */
 	if (__write) {
@@ -489,12 +474,13 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 	if (id < 0)
 		return -EINVAL;
 
-	ret = reg_value(valp, &ui->sample->user_regs, id);
+	ret = perf_reg_value(&val, &ui->sample->user_regs, id);
 	if (ret) {
 		pr_err("unwind: can't read reg %d\n", regnum);
 		return ret;
 	}
 
+	*valp = (unw_word_t) val;
 	pr_debug("unwind: reg %d, val %lx\n", regnum, (unsigned long)*valp);
 	return 0;
 }
@@ -588,7 +574,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine, struct thread *thread,
 			struct perf_sample *data, int max_stack)
 {
-	unw_word_t ip;
+	u64 ip;
 	struct unwind_info ui = {
 		.sample       = data,
 		.thread       = thread,
@@ -599,7 +585,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (!data->user_regs.regs)
 		return -EINVAL;
 
-	ret = reg_value(&ip, &data->user_regs, PERF_REG_IP);
+	ret = perf_reg_value(&ip, &data->user_regs, PERF_REG_IP);
 	if (ret)
 		return ret;
 
-- 
1.8.3.1

