Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaFFDVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:21:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33620 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFFDVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:21:35 -0400
Date: Thu, 5 Jun 2014 20:21:09 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Anton Blanchard <anton@au1.ibm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Ulrich.Weigand@de.ibm.com, michael@ellerman.id.au,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2]: Allow architectures to skip a callchain entry
Message-ID: <20140606032109.GA16600@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060603-1542-0000-0000-0000025F934F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel code in Powerpc conservatively saves excess information in
the callchain. While most entries are often needed, under some specific
conditions, some of the entries are redundant and cause duplicate arcs
in the call-graph.

Eg: the value in the link register (LR) is needed only when it holds
the return address of a function. At other times it must be ignored.

In the next commit, we will use the application's DWARF debug information
to identify and skip over the redundant entries.

To minimize performance impact on other architectures, define and use two
following static inline interfaces:

	arch_skip_callchain_idx()
	next_callchain_ip()

Reported-by: Maynard Johnson <maynard@us.ibm.com>
Tested-by: Maynard Johnson <maynard@us.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog[v4]
	Move Powerpc-specific code to separate patch
	[Jiri Olsa] Minimize performance impact to other architectures

 include/uapi/linux/perf_event.h                   |    2 ++
 tools/perf/arch/powerpc/Makefile                  |    1 +
 tools/perf/arch/powerpc/util/skip-callchain-idx.c |   25 ++++++++++++++
 tools/perf/config/Makefile                        |    4 +++
 tools/perf/util/callchain.h                       |   37 +++++++++++++++++++++
 tools/perf/util/machine.c                         |   11 +++---
 6 files changed, 76 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/skip-callchain-idx.c

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e3fc8f0..b671abf 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -719,6 +719,8 @@ enum perf_callchain_context {
 	PERF_CONTEXT_GUEST_KERNEL	= (__u64)-2176,
 	PERF_CONTEXT_GUEST_USER		= (__u64)-2560,
 
+	PERF_CONTEXT_IGNORE		= (__u64)-3840,
+
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..b92219b 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
new file mode 100644
index 0000000..7350c36
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -0,0 +1,25 @@
+/*
+ * Use DWARF Debug information to skip unnecessary callchain entries.
+ *
+ * Copyright (C) 2014 Sukadev Bhattiprolu, IBM Corporation.
+ * Copyright (C) 2014 Ulrich Weigand, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <inttypes.h>
+#include <dwarf.h>
+#include <elfutils/libdwfl.h>
+
+#include "util/thread.h"
+#include "util/callchain.h"
+
+/* Stub for now */
+int arch_skip_callchain_idx(struct machine *machine __maybe_unused,
+			    struct thread *thread __maybe_unused,
+			    struct ip_callchain *chain __maybe_unused)
+{
+	return -1;
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 729bbdf..8d1417d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,6 +48,10 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
+ifeq ($(ARCH),powerpc)
+  CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8f84423..57d3d33 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -176,4 +176,41 @@ static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
 	dest->first = src->curr;
 	dest->nr -= src->pos;
 }
+
+/*
+ * Some architectures (eg: Powerpc), check DWARF debug information
+ * and skip a specific callchain entry in the @chain->ips[] list.
+ *
+ * Return index of the entry to skip or -1 to not skip any entry.
+ */
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+extern int
+arch_skip_callchain_idx(struct machine *machine __maybe_unused,
+			struct thread *thread __maybe_unused,
+			struct ip_callchain *chain __maybe_unused);
+#else
+static inline int
+arch_skip_callchain_idx(struct machine *machine __maybe_unused,
+			struct thread *thread __maybe_unused,
+			struct ip_callchain *chain __maybe_unused)
+{
+	return -1;
+}
+#endif
+
+static inline u64
+next_callchain_ip(struct ip_callchain *chain,
+			enum chain_order order,
+			int idx,
+			int skip_idx __maybe_unused)
+{
+	if (order != ORDER_CALLEE)
+		idx = chain->nr - idx - 1;
+
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+	if (idx == skip_idx)
+		return PERF_CONTEXT_IGNORE;
+#endif
+	return chain->ips[idx];
+}
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7409ac8..3f97cf2 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1288,8 +1288,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
+	enum chain_order order = callchain_param.order;
 	int i;
 	int err;
+	int skip_idx;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1298,14 +1300,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
+	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
+
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
 		struct addr_location al;
 
-		if (callchain_param.order == ORDER_CALLEE)
-			ip = chain->ips[i];
-		else
-			ip = chain->ips[chain->nr - i - 1];
+		ip = next_callchain_ip(chain, order, i, skip_idx);
 
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
@@ -1318,6 +1319,8 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			case PERF_CONTEXT_USER:
 				cpumode = PERF_RECORD_MISC_USER;
 				break;
+			case PERF_CONTEXT_IGNORE:
+				break;
 			default:
 				pr_debug("invalid callchain context: "
 					 "%"PRId64"\n", (s64) ip);
-- 
1.7.9.5

