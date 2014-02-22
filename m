Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaBVSBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:01:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBVSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:01:14 -0500
Date: Sat, 22 Feb 2014 09:58:51 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c9b951c4d12f0b2e9a07dd459c554bc05628d092@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-13-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-13-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Separate perf_reg_value function in perf_regs object
Git-Commit-ID: c9b951c4d12f0b2e9a07dd459c554bc05628d092
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

Commit-ID:  c9b951c4d12f0b2e9a07dd459c554bc05628d092
Gitweb:     http://git.kernel.org/tip/c9b951c4d12f0b2e9a07dd459c554bc05628d092
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:29 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:49 -0300

perf callchain: Separate perf_reg_value function in perf_regs object

Making perf_reg_value function global (formely reg_value), because it's
going to be used globaly across all code providing the dwarf post unwind
feature.

Changing its prototype to be generic:

  -int reg_value(unw_word_t *valp, struct regs_dump *regs, int id)
  +int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);

Changing the valp type from libunwind specific 'unw_word_t' to u64.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-13-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf           |  1 +
 tools/perf/util/perf_regs.c        | 19 +++++++++++++++++++
 tools/perf/util/perf_regs.h        | 13 +++++++++++++
 tools/perf/util/unwind-libunwind.c | 38 ++++++++++++--------------------------
 4 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9ef6b33..f99a392 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -538,6 +538,7 @@ ifeq ($(NO_PERF_REGS),0)
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
index 79dbfbb..bd5768d 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -390,30 +390,13 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
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
 
@@ -423,7 +406,7 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	ret = reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
+	ret = perf_reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
 	if (ret)
 		return ret;
 
@@ -436,8 +419,9 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
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
@@ -446,8 +430,8 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 
 	offset = addr - start;
 	*valp  = *(unw_word_t *)&stack->data[offset];
-	pr_debug("unwind: access_mem addr %p, val %lx, offset %d\n",
-		 (void *)addr, (unsigned long)*valp, offset);
+	pr_debug("unwind: access_mem addr %p val %lx, offset %d\n",
+		 (void *) addr, (unsigned long)*valp, offset);
 	return 0;
 }
 
@@ -457,6 +441,7 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 {
 	struct unwind_info *ui = arg;
 	int id, ret;
+	u64 val;
 
 	/* Don't support write, I suspect we don't need it. */
 	if (__write) {
@@ -473,12 +458,13 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
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
@@ -572,7 +558,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine, struct thread *thread,
 			struct perf_sample *data, int max_stack)
 {
-	unw_word_t ip;
+	u64 ip;
 	struct unwind_info ui = {
 		.sample       = data,
 		.thread       = thread,
@@ -583,7 +569,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (!data->user_regs.regs)
 		return -EINVAL;
 
-	ret = reg_value(&ip, &data->user_regs, PERF_REG_IP);
+	ret = perf_reg_value(&ip, &data->user_regs, PERF_REG_IP);
 	if (ret)
 		return ret;
 
