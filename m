Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaKKOS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaKKOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151614"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/25] perf evlist: Add initial support for mmapping an Instruction Trace buffer
Date: Tue, 11 Nov 2014 16:16:43 +0200
Message-Id: <1415715423-15563-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch anticipates the addition to the kernel
of an "aux" buffer that can be mmapped separately
from the perf-events buffer.

The expectation is that this buffer can be configured
to contain hardware-produced trace information for
Instruction Tracing, hence the name "itrace".
The first implementation will support Intel BTS and
Intel PT.

One itrace buffer is mmapped per perf-events buffer.
If the requested itrace buffer size is zero, which
it will be until further support is added, then
no itrace mmapping is attempted.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf |  2 +
 tools/perf/util/evlist.c | 60 +++++++++++++++++++++++++++--
 tools/perf/util/evlist.h |  5 +++
 tools/perf/util/itrace.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 259 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/util/itrace.c
 create mode 100644 tools/perf/util/itrace.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 478efa9..f321e2f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -314,6 +314,7 @@ LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
 LIB_H += util/tsc.h
+LIB_H += util/itrace.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -399,6 +400,7 @@ LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
 LIB_OBJS += $(OUTPUT)util/thread-stack.o
+LIB_OBJS += $(OUTPUT)util/itrace.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cfbe2b9..2ee7f46 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -724,6 +724,34 @@ void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
 		perf_evlist__mmap_put(evlist, idx);
 }
 
+int __weak itrace_mmap__mmap(struct itrace_mmap *mm __maybe_unused,
+			     struct itrace_mmap_params *mp __maybe_unused,
+			     void *userpg __maybe_unused,
+			     int fd __maybe_unused)
+{
+	return 0;
+}
+
+void __weak itrace_mmap__munmap(struct itrace_mmap *mm __maybe_unused)
+{
+}
+
+void __weak itrace_mmap_params__init(
+			struct itrace_mmap_params *mp __maybe_unused,
+			off_t itrace_offset __maybe_unused,
+			unsigned int itrace_pages __maybe_unused,
+			bool itrace_overwrite __maybe_unused)
+{
+}
+
+void __weak itrace_mmap_params__set_idx(
+			struct itrace_mmap_params *mp __maybe_unused,
+			struct perf_evlist *evlist __maybe_unused,
+			int idx __maybe_unused,
+			bool per_cpu __maybe_unused)
+{
+}
+
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 {
 	if (evlist->mmap[idx].base != NULL) {
@@ -731,6 +759,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 		evlist->mmap[idx].base = NULL;
 		evlist->mmap[idx].refcnt = 0;
 	}
+	itrace_mmap__munmap(&evlist->mmap[idx].itrace_mmap);
 }
 
 void perf_evlist__munmap(struct perf_evlist *evlist)
@@ -758,6 +787,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 struct mmap_params {
 	int prot;
 	int mask;
+	struct itrace_mmap_params itrace_mp;
 };
 
 static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
@@ -788,6 +818,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 		return -1;
 	}
 
+	if (itrace_mmap__mmap(&evlist->mmap[idx].itrace_mmap,
+			      &mp->itrace_mp, evlist->mmap[idx].base, fd))
+		return -1;
+
 	return 0;
 }
 
@@ -852,6 +886,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist,
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 
+		itrace_mmap_params__set_idx(&mp->itrace_mp, evlist, cpu, true);
+
 		for (thread = 0; thread < nr_threads; thread++) {
 			if (perf_evlist__mmap_per_evsel(evlist, cpu, mp, cpu,
 							thread, &output))
@@ -877,6 +913,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
+		itrace_mmap_params__set_idx(&mp->itrace_mp, evlist, thread,
+					    false);
+
 		if (perf_evlist__mmap_per_evsel(evlist, thread, mp, 0, thread,
 						&output))
 			goto out_unmap;
@@ -966,19 +1005,25 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 }
 
 /**
- * perf_evlist__mmap - Create mmaps to receive events.
+ * perf_evlist__mmap_ex - Create mmaps to receive events.
  * @evlist: list of events
  * @pages: map length in pages
  * @overwrite: overwrite older events?
+ * @itrace_pages - itrace map length in pages
+ * @itrace_overwrite - overwrite older itrace data?
  *
  * If @overwrite is %false the user needs to signal event consumption using
  * perf_mmap__write_tail().  Using perf_evlist__mmap_read() does this
  * automatically.
  *
+ * Similarly, if @itrace_overwrite is %false the user needs to signal data
+ * consumption using itrace_mmap__write_tail().
+ *
  * Return: %0 on success, negative error code otherwise.
  */
-int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite)
+int perf_evlist__mmap_ex(struct perf_evlist *evlist, unsigned int pages,
+			 bool overwrite, unsigned int itrace_pages,
+			 bool itrace_overwrite)
 {
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
@@ -998,6 +1043,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
 	mp.mask = evlist->mmap_len - page_size - 1;
 
+	itrace_mmap_params__init(&mp.itrace_mp, evlist->mmap_len, itrace_pages,
+				 itrace_overwrite);
+
 	evlist__for_each(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
@@ -1011,6 +1059,12 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, &mp);
 }
 
+int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
+		      bool overwrite)
+{
+	return perf_evlist__mmap_ex(evlist, pages, overwrite, 0, false);
+}
+
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 {
 	evlist->threads = thread_map__new_str(target->pid, target->tid,
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649b0c5..f19d89c 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -8,6 +8,7 @@
 #include "event.h"
 #include "evsel.h"
 #include "util.h"
+#include "itrace.h"
 #include <unistd.h>
 
 struct pollfd;
@@ -28,6 +29,7 @@ struct perf_mmap {
 	int		 mask;
 	int		 refcnt;
 	unsigned int	 prev;
+	struct itrace_mmap itrace_mmap;
 	char		 event_copy[PERF_SAMPLE_MAX_SIZE];
 };
 
@@ -123,6 +125,9 @@ int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
 
+int perf_evlist__mmap_ex(struct perf_evlist *evlist, unsigned int pages,
+			 bool overwrite, unsigned int itrace_pages,
+			 bool itrace_overwrite);
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
new file mode 100644
index 0000000..c950b4f
--- /dev/null
+++ b/tools/perf/util/itrace.c
@@ -0,0 +1,99 @@
+/*
+ * itrace.c: Instruction Tracing support
+ * Copyright (c) 2013-2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <stdbool.h>
+
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "../perf.h"
+#include "util.h"
+#include "evlist.h"
+#include "cpumap.h"
+#include "thread_map.h"
+#include "itrace.h"
+
+int itrace_mmap__mmap(struct itrace_mmap *mm, struct itrace_mmap_params *mp,
+		      void *userpg, int fd)
+{
+#if BITS_PER_LONG != 64 && !defined(HAVE_SYNC_COMPARE_AND_SWAP_SUPPORT)
+	pr_err("Cannot use Instruction Tracing mmaps\n");
+	return -1;
+#endif
+
+	mm->userpg = userpg;
+	mm->mask = mp->mask;
+	mm->len = mp->len;
+	mm->prev = 0;
+	mm->idx = mp->idx;
+	mm->tid = mp->tid;
+	mm->cpu = mp->cpu;
+
+	if (!mp->len) {
+		mm->base = NULL;
+		return 0;
+	}
+
+	mm->base = mmap(NULL, mp->len, mp->prot, MAP_SHARED, fd, mp->offset);
+	if (mm->base == MAP_FAILED) {
+		pr_debug2("failed to mmap itrace ring buffer\n");
+		mm->base = NULL;
+		return -1;
+	}
+
+	return 0;
+}
+
+void itrace_mmap__munmap(struct itrace_mmap *mm)
+{
+	if (mm->base)
+		munmap(mm->base, mm->len);
+}
+
+void itrace_mmap_params__init(struct itrace_mmap_params *mp,
+			      off_t itrace_offset,
+			      unsigned int itrace_pages, bool itrace_overwrite)
+{
+	if (itrace_pages) {
+		mp->offset = itrace_offset;
+		mp->len = itrace_pages * (size_t)page_size;
+		mp->mask = is_power_of_2(mp->len) ? mp->len - 1 : 0;
+		mp->prot = PROT_READ | (itrace_overwrite ? 0 : PROT_WRITE);
+		pr_debug2("itrace mmap length %zu\n", mp->len);
+	} else {
+		mp->len = 0;
+	}
+}
+
+void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
+				 struct perf_evlist *evlist, int idx,
+				 bool per_cpu)
+{
+	mp->idx = idx;
+
+	if (per_cpu) {
+		mp->cpu = evlist->cpus->map[idx];
+		if (evlist->threads)
+			mp->tid = evlist->threads->map[0];
+		else
+			mp->tid = -1;
+	} else {
+		mp->cpu = -1;
+		mp->tid = evlist->threads->map[idx];
+	}
+}
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
new file mode 100644
index 0000000..00ba409
--- /dev/null
+++ b/tools/perf/util/itrace.h
@@ -0,0 +1,96 @@
+/*
+ * itrace.h: Instruction Tracing support
+ * Copyright (c) 2013-2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __PERF_ITRACE_H
+#define __PERF_ITRACE_H
+
+#include <sys/types.h>
+#include <stdbool.h>
+
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "../perf.h"
+
+struct perf_evlist;
+
+/**
+ * struct itrace_mmap - records an mmap of the itrace buffer.
+ * @base: address of mapped area
+ * @userpg: pointer to buffer's perf_event_mmap_page
+ * @mask: %0 if @len is not a power of two, otherwise (@len - %1)
+ * @len: size of mapped area
+ * @prev: previous aux_head
+ * @idx: index of this mmap
+ * @tid: tid for a per-thread mmap (also set if there is only 1 tid on a per-cpu
+ *       mmap) otherwise %0
+ * @cpu: cpu number for a per-cpu mmap otherwise %-1
+ */
+struct itrace_mmap {
+	void		*base;
+	void		*userpg;
+	size_t		mask;
+	size_t		len;
+	u64		prev;
+	int		idx;
+	pid_t		tid;
+	int		cpu;
+};
+
+/**
+ * struct itrace_mmap_params - parameters to set up struct itrace_mmap.
+ * @mask: %0 if @len is not a power of two, otherwise (@len - %1)
+ * @offset: file offset of mapped area
+ * @len: size of mapped area
+ * @prot: mmap memory protection
+ * @idx: index of this mmap
+ * @tid: tid for a per-thread mmap (also set if there is only 1 tid on a per-cpu
+ *       mmap) otherwise %0
+ * @cpu: cpu number for a per-cpu mmap otherwise %-1
+ */
+struct itrace_mmap_params {
+	size_t		mask;
+	off_t		offset;
+	size_t		len;
+	int		prot;
+	int		idx;
+	pid_t		tid;
+	int		cpu;
+};
+
+static inline u64 itrace_mmap__read_head(struct itrace_mmap *mm __maybe_unused)
+{
+	/* Not yet implemented */
+	return 0;
+}
+
+static inline void itrace_mmap__write_tail(struct itrace_mmap *mm __maybe_unused,
+					   u64 tail __maybe_unused)
+{
+	/* Not yet implemented */
+}
+
+int itrace_mmap__mmap(struct itrace_mmap *mm,
+		      struct itrace_mmap_params *mp,
+		      void *userpg, int fd);
+void itrace_mmap__munmap(struct itrace_mmap *mm);
+void itrace_mmap_params__init(struct itrace_mmap_params *mp,
+			      off_t itrace_offset,
+			      unsigned int itrace_pages, bool itrace_overwrite);
+void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
+				 struct perf_evlist *evlist, int idx,
+				 bool per_cpu);
+
+#endif
-- 
1.9.1

