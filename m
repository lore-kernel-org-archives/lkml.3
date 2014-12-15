Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaLOOvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:51:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53342 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaLOOvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:51:11 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [PATCHv2 5/8] perf probe powerpc: Allow matching against dot symbols
Date: Mon, 15 Dec 2014 20:20:35 +0530
Message-Id: <062b1dbee6747d8013ea91d7020216969aefb128.1418654436.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121514-0033-0000-0000-000000BF859F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow perf probe to work on powerpc ABIv1 without the need to specify
the leading dot '.' for functions. 'perf probe do_fork' works with this
patch.

Introduce HAVE_ARCH_SYMBOL_HANDLING to indicate need for special
handling of symbols. In this patch, we override probe_function_filter()
on powerpc to account for dot symbols.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
Changes from the previous patchset:
Introduced arch helper to override the way probe function filter works.

 tools/perf/arch/powerpc/Makefile            |  1 +
 tools/perf/arch/powerpc/util/sym-handling.c | 28 ++++++++++++++++++++++++++++
 tools/perf/config/Makefile                  |  1 +
 tools/perf/util/probe-event.c               | 10 +++++-----
 tools/perf/util/probe-event.h               |  5 +++++
 5 files changed, 40 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/sym-handling.c

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 6f7782b..1c3d435 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -3,4 +3,5 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/sym-handling.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/powerpc/util/sym-handling.c b/tools/perf/arch/powerpc/util/sym-handling.c
new file mode 100644
index 0000000..0a77825
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/sym-handling.c
@@ -0,0 +1,28 @@
+/*
+ * Special symbol handling for PowerPC:
+ * - Handle dot symbols on ABIv1
+ *
+ * Copyright (C) 2014 Naveen N Rao, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include "map.h"
+#include "symbol.h"
+#include "probe-event.h"
+
+int probe_function_filter(struct map *map __maybe_unused, struct symbol *sym)
+{
+	if (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) {
+		if ((strcmp(looking_function_name, sym->name) == 0) ||
+		    (sym->name[0] == '.' && looking_function_name[0] != '.' &&
+		     strcmp(looking_function_name, sym->name+1) == 0)) {
+			num_matched_functions++;
+			return 0;
+		}
+	}
+	return 1;
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039..35cf934 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -383,6 +383,7 @@ ifeq ($(ARCH),powerpc)
   ifndef NO_DWARF
     CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
   endif
+  CFLAGS += -DHAVE_ARCH_SYMBOL_HANDLING
 endif
 
 ifndef NO_LIBUNWIND
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 74b7fef..7eb9b27 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -50,6 +50,8 @@
 #define PERFPROBE_GROUP "probe"
 
 bool probe_event_dry_run;	/* Dry run flag */
+char *looking_function_name;
+int num_matched_functions;
 
 #define semantic_error(msg ...) pr_err("Semantic error :" msg)
 
@@ -2210,11 +2212,8 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static char *looking_function_name;
-static int num_matched_functions;
-
-static int probe_function_filter(struct map *map __maybe_unused,
-				      struct symbol *sym)
+#ifndef HAVE_ARCH_SYMBOL_HANDLING
+int probe_function_filter(struct map *map __maybe_unused, struct symbol *sym)
 {
 	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
 	    strcmp(looking_function_name, sym->name) == 0) {
@@ -2223,6 +2222,7 @@ static int probe_function_filter(struct map *map __maybe_unused,
 	}
 	return 1;
 }
+#endif /* HAVE_ARCH_SYMBOL_HANDLING */
 
 #define strdup_or_goto(str, label)	\
 	({ char *__p = strdup(str); if (!__p) goto label; __p; })
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index e01e994..8564451 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -7,6 +7,8 @@
 #include "strfilter.h"
 
 extern bool probe_event_dry_run;
+extern char *looking_function_name;
+extern int num_matched_functions;
 
 /* kprobe-tracer and uprobe-tracer tracing point */
 struct probe_trace_point {
@@ -136,6 +138,9 @@ extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 extern int show_available_funcs(const char *module, struct strfilter *filter,
 				bool user);
 
+extern int probe_function_filter(struct map *map __maybe_unused,
+					struct symbol *sym);
+
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
 
-- 
2.1.3

