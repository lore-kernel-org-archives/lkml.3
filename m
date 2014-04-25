Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaDYD2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:28:18 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42193 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaDYD2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:28:16 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/2] perf tests: Factor out fake_setup_machine()
Date: Fri, 25 Apr 2014 12:28:13 +0900
Message-Id: <1398396494-12811-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fake_setup_machine() is for setting up a environment for testing
various hists operations.  As it'll be used for other test cases it'd
better factoring it out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf        |   1 +
 tools/perf/tests/hists_common.c | 148 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/hists_common.h |  44 ++++++++++++
 tools/perf/tests/hists_link.c   | 141 +-------------------------------------
 4 files changed, 195 insertions(+), 139 deletions(-)
 create mode 100644 tools/perf/tests/hists_common.c
 create mode 100644 tools/perf/tests/hists_common.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index eb57e2cf1b4c..1490afeb7252 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -396,6 +396,7 @@ LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
+LIB_OBJS += $(OUTPUT)tests/hists_common.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
new file mode 100644
index 000000000000..44655b395bb9
--- /dev/null
+++ b/tools/perf/tests/hists_common.c
@@ -0,0 +1,148 @@
+#include "perf.h"
+#include "util/debug.h"
+#include "util/symbol.h"
+#include "util/sort.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/machine.h"
+#include "util/thread.h"
+#include "tests/hists_common.h"
+
+static struct {
+	u32 pid;
+	const char *comm;
+} fake_threads[] = {
+	{ 100, "perf" },
+	{ 200, "perf" },
+	{ 300, "bash" },
+};
+
+static struct {
+	u32 pid;
+	u64 start;
+	const char *filename;
+} fake_mmap_info[] = {
+	{ 100, 0x40000, "perf" },
+	{ 100, 0x50000, "libc" },
+	{ 100, 0xf0000, "[kernel]" },
+	{ 200, 0x40000, "perf" },
+	{ 200, 0x50000, "libc" },
+	{ 200, 0xf0000, "[kernel]" },
+	{ 300, 0x40000, "bash" },
+	{ 300, 0x50000, "libc" },
+	{ 300, 0xf0000, "[kernel]" },
+};
+
+struct fake_sym {
+	u64 start;
+	u64 length;
+	const char *name;
+};
+
+static struct fake_sym perf_syms[] = {
+	{ 700, 100, "main" },
+	{ 800, 100, "run_command" },
+	{ 900, 100, "cmd_record" },
+};
+
+static struct fake_sym bash_syms[] = {
+	{ 700, 100, "main" },
+	{ 800, 100, "xmalloc" },
+	{ 900, 100, "xfree" },
+};
+
+static struct fake_sym libc_syms[] = {
+	{ 700, 100, "malloc" },
+	{ 800, 100, "free" },
+	{ 900, 100, "realloc" },
+};
+
+static struct fake_sym kernel_syms[] = {
+	{ 700, 100, "schedule" },
+	{ 800, 100, "page_fault" },
+	{ 900, 100, "sys_perf_event_open" },
+};
+
+static struct {
+	const char *dso_name;
+	struct fake_sym *syms;
+	size_t nr_syms;
+} fake_symbols[] = {
+	{ "perf", perf_syms, ARRAY_SIZE(perf_syms) },
+	{ "bash", bash_syms, ARRAY_SIZE(bash_syms) },
+	{ "libc", libc_syms, ARRAY_SIZE(libc_syms) },
+	{ "[kernel]", kernel_syms, ARRAY_SIZE(kernel_syms) },
+};
+
+struct machine *setup_fake_machine(struct machines *machines)
+{
+	struct machine *machine = machines__find(machines, HOST_KERNEL_ID);
+	size_t i;
+
+	if (machine == NULL) {
+		pr_debug("Not enough memory for machine setup\n");
+		return NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
+		struct thread *thread;
+
+		thread = machine__findnew_thread(machine, fake_threads[i].pid,
+						 fake_threads[i].pid);
+		if (thread == NULL)
+			goto out;
+
+		thread__set_comm(thread, fake_threads[i].comm, 0);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fake_mmap_info); i++) {
+		union perf_event fake_mmap_event = {
+			.mmap = {
+				.header = { .misc = PERF_RECORD_MISC_USER, },
+				.pid = fake_mmap_info[i].pid,
+				.tid = fake_mmap_info[i].pid,
+				.start = fake_mmap_info[i].start,
+				.len = 0x1000ULL,
+				.pgoff = 0ULL,
+			},
+		};
+
+		strcpy(fake_mmap_event.mmap.filename,
+		       fake_mmap_info[i].filename);
+
+		machine__process_mmap_event(machine, &fake_mmap_event, NULL);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fake_symbols); i++) {
+		size_t k;
+		struct dso *dso;
+
+		dso = __dsos__findnew(&machine->user_dsos,
+				      fake_symbols[i].dso_name);
+		if (dso == NULL)
+			goto out;
+
+		/* emulate dso__load() */
+		dso__set_loaded(dso, MAP__FUNCTION);
+
+		for (k = 0; k < fake_symbols[i].nr_syms; k++) {
+			struct symbol *sym;
+			struct fake_sym *fsym = &fake_symbols[i].syms[k];
+
+			sym = symbol__new(fsym->start, fsym->length,
+					  STB_GLOBAL, fsym->name);
+			if (sym == NULL)
+				goto out;
+
+			symbols__insert(&dso->symbols[MAP__FUNCTION], sym);
+		}
+	}
+
+	return machine;
+
+out:
+	pr_debug("Not enough memory for machine setup\n");
+	machine__delete_threads(machine);
+	machine__delete(machine);
+	return NULL;
+}
diff --git a/tools/perf/tests/hists_common.h b/tools/perf/tests/hists_common.h
new file mode 100644
index 000000000000..2528b8fc105a
--- /dev/null
+++ b/tools/perf/tests/hists_common.h
@@ -0,0 +1,44 @@
+#ifndef __PERF_TESTS__HISTS_COMMON_H__
+#define __PERF_TESTS__HISTS_COMMON_H__
+
+struct machine;
+struct machines;
+
+/*
+ * The setup_fake_machine() provides a test environment which consists
+ * of 3 processes that have 3 mappings and in turn, have 3 symbols
+ * respectively.  See below table:
+ *
+ * Command:  Pid  Shared Object               Symbol
+ * .............  .............  ...................
+ *    perf:  100           perf  main
+ *    perf:  100           perf  run_command
+ *    perf:  100           perf  comd_record
+ *    perf:  100           libc  malloc
+ *    perf:  100           libc  free
+ *    perf:  100           libc  realloc
+ *    perf:  100       [kernel]  schedule
+ *    perf:  100       [kernel]  page_fault
+ *    perf:  100       [kernel]  sys_perf_event_open
+ *    perf:  200           perf  main
+ *    perf:  200           perf  run_command
+ *    perf:  200           perf  comd_record
+ *    perf:  200           libc  malloc
+ *    perf:  200           libc  free
+ *    perf:  200           libc  realloc
+ *    perf:  200       [kernel]  schedule
+ *    perf:  200       [kernel]  page_fault
+ *    perf:  200       [kernel]  sys_perf_event_open
+ *    bash:  300           bash  main
+ *    bash:  300           bash  xmalloc
+ *    bash:  300           bash  xfree
+ *    bash:  300           libc  malloc
+ *    bash:  300           libc  free
+ *    bash:  300           libc  realloc
+ *    bash:  300       [kernel]  schedule
+ *    bash:  300       [kernel]  page_fault
+ *    bash:  300       [kernel]  sys_perf_event_open
+ */
+struct machine *setup_fake_machine(struct machines *machines);
+
+#endif /* __PERF_TESTS__HISTS_COMMON_H__ */
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 7ccbc7b6ae77..e42d6790811a 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -8,145 +8,7 @@
 #include "machine.h"
 #include "thread.h"
 #include "parse-events.h"
-
-static struct {
-	u32 pid;
-	const char *comm;
-} fake_threads[] = {
-	{ 100, "perf" },
-	{ 200, "perf" },
-	{ 300, "bash" },
-};
-
-static struct {
-	u32 pid;
-	u64 start;
-	const char *filename;
-} fake_mmap_info[] = {
-	{ 100, 0x40000, "perf" },
-	{ 100, 0x50000, "libc" },
-	{ 100, 0xf0000, "[kernel]" },
-	{ 200, 0x40000, "perf" },
-	{ 200, 0x50000, "libc" },
-	{ 200, 0xf0000, "[kernel]" },
-	{ 300, 0x40000, "bash" },
-	{ 300, 0x50000, "libc" },
-	{ 300, 0xf0000, "[kernel]" },
-};
-
-struct fake_sym {
-	u64 start;
-	u64 length;
-	const char *name;
-};
-
-static struct fake_sym perf_syms[] = {
-	{ 700, 100, "main" },
-	{ 800, 100, "run_command" },
-	{ 900, 100, "cmd_record" },
-};
-
-static struct fake_sym bash_syms[] = {
-	{ 700, 100, "main" },
-	{ 800, 100, "xmalloc" },
-	{ 900, 100, "xfree" },
-};
-
-static struct fake_sym libc_syms[] = {
-	{ 700, 100, "malloc" },
-	{ 800, 100, "free" },
-	{ 900, 100, "realloc" },
-};
-
-static struct fake_sym kernel_syms[] = {
-	{ 700, 100, "schedule" },
-	{ 800, 100, "page_fault" },
-	{ 900, 100, "sys_perf_event_open" },
-};
-
-static struct {
-	const char *dso_name;
-	struct fake_sym *syms;
-	size_t nr_syms;
-} fake_symbols[] = {
-	{ "perf", perf_syms, ARRAY_SIZE(perf_syms) },
-	{ "bash", bash_syms, ARRAY_SIZE(bash_syms) },
-	{ "libc", libc_syms, ARRAY_SIZE(libc_syms) },
-	{ "[kernel]", kernel_syms, ARRAY_SIZE(kernel_syms) },
-};
-
-static struct machine *setup_fake_machine(struct machines *machines)
-{
-	struct machine *machine = machines__find(machines, HOST_KERNEL_ID);
-	size_t i;
-
-	if (machine == NULL) {
-		pr_debug("Not enough memory for machine setup\n");
-		return NULL;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
-		struct thread *thread;
-
-		thread = machine__findnew_thread(machine, fake_threads[i].pid,
-						 fake_threads[i].pid);
-		if (thread == NULL)
-			goto out;
-
-		thread__set_comm(thread, fake_threads[i].comm, 0);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(fake_mmap_info); i++) {
-		union perf_event fake_mmap_event = {
-			.mmap = {
-				.header = { .misc = PERF_RECORD_MISC_USER, },
-				.pid = fake_mmap_info[i].pid,
-				.tid = fake_mmap_info[i].pid,
-				.start = fake_mmap_info[i].start,
-				.len = 0x1000ULL,
-				.pgoff = 0ULL,
-			},
-		};
-
-		strcpy(fake_mmap_event.mmap.filename,
-		       fake_mmap_info[i].filename);
-
-		machine__process_mmap_event(machine, &fake_mmap_event, NULL);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(fake_symbols); i++) {
-		size_t k;
-		struct dso *dso;
-
-		dso = __dsos__findnew(&machine->user_dsos,
-				      fake_symbols[i].dso_name);
-		if (dso == NULL)
-			goto out;
-
-		/* emulate dso__load() */
-		dso__set_loaded(dso, MAP__FUNCTION);
-
-		for (k = 0; k < fake_symbols[i].nr_syms; k++) {
-			struct symbol *sym;
-			struct fake_sym *fsym = &fake_symbols[i].syms[k];
-
-			sym = symbol__new(fsym->start, fsym->length,
-					  STB_GLOBAL, fsym->name);
-			if (sym == NULL)
-				goto out;
-
-			symbols__insert(&dso->symbols[MAP__FUNCTION], sym);
-		}
-	}
-
-	return machine;
-
-out:
-	pr_debug("Not enough memory for machine setup\n");
-	machine__delete_threads(machine);
-	machine__delete(machine);
-	return NULL;
-}
+#include "hists_common.h"
 
 struct sample {
 	u32 pid;
@@ -156,6 +18,7 @@ struct sample {
 	struct symbol *sym;
 };
 
+/* For the numbers, see hists_common.c */
 static struct sample fake_common_samples[] = {
 	/* perf [kernel] schedule() */
 	{ .pid = 100, .ip = 0xf0000 + 700, },
-- 
1.9.2

