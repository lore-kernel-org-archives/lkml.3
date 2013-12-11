Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3LKMlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:50540 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3LKMlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369238"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 40/71] perf evlist: Add ability to mmap itrace buffers
Date: Wed, 11 Dec 2013 14:36:52 +0200
Message-Id: <1386765443-26966-41-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Instruction Tracing data is provided in a separate
mmap made a special offset PERF_EVENT_ITRACE_OFFSET.
Add the ability to mmap that offset.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf |   2 +
 tools/perf/util/evlist.c |  57 +++++++++++++++++++++--
 tools/perf/util/evlist.h |   5 ++
 tools/perf/util/itrace.c | 104 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 118 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 283 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/util/itrace.c
 create mode 100644 tools/perf/util/itrace.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index c1f9a54..6ef50f9 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -293,6 +293,7 @@ LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
 LIB_H += util/tsc.h
+LIB_H += util/itrace.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -372,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
+LIB_OBJS += $(OUTPUT)util/itrace.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 490af37..c720c6c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -659,12 +659,39 @@ void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
 	}
 }
 
+int __weak itrace_mmap__mmap(struct itrace_mmap *mm __maybe_unused,
+			     struct itrace_mmap_params *mp __maybe_unused,
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
 		munmap(evlist->mmap[idx].base, evlist->mmap_len);
 		evlist->mmap[idx].base = NULL;
 	}
+	itrace_mmap__munmap(&evlist->mmap[idx].itrace_mmap);
 }
 
 void perf_evlist__munmap(struct perf_evlist *evlist)
@@ -690,6 +717,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 struct mmap_params {
 	int prot;
 	int mask;
+	struct itrace_mmap_params itrace_mp;
 };
 
 static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
@@ -706,6 +734,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 		return -1;
 	}
 
+	if (itrace_mmap__mmap(&evlist->mmap[idx].itrace_mmap,
+			      &mp->itrace_mp, fd))
+		return -1;
+
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
@@ -756,6 +788,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist,
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 
+		itrace_mmap_params__set_idx(&mp->itrace_mp, evlist, cpu, true);
+
 		for (thread = 0; thread < nr_threads; thread++) {
 			if (perf_evlist__mmap_per_evsel(evlist, cpu, mp, cpu,
 							thread, &output))
@@ -781,6 +815,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
+		itrace_mmap_params__set_idx(&mp->itrace_mp, evlist, thread,
+					    false);
+
 		if (perf_evlist__mmap_per_evsel(evlist, thread, mp, 0, thread,
 						&output))
 			goto out_unmap;
@@ -868,19 +905,25 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
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
@@ -900,6 +943,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
 	mp.mask = evlist->mmap_len - page_size - 1;
 
+	itrace_mmap_params__init(&mp.itrace_mp, itrace_pages, itrace_overwrite);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
@@ -913,6 +958,12 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
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
index 6f3166e..7f56fdc 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -7,6 +7,7 @@
 #include "event.h"
 #include "evsel.h"
 #include "util.h"
+#include "itrace.h"
 #include <unistd.h>
 
 struct pollfd;
@@ -21,6 +22,7 @@ struct perf_mmap {
 	void		 *base;
 	int		 mask;
 	unsigned int	 prev;
+	struct itrace_mmap itrace_mmap;
 	char		 event_copy[PERF_SAMPLE_MAX_SIZE];
 };
 
@@ -111,6 +113,9 @@ int perf_evlist__parse_mmap_pages(const struct option *opt,
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
index 0000000..a889e63
--- /dev/null
+++ b/tools/perf/util/itrace.c
@@ -0,0 +1,104 @@
+/*
+ * itrace.c: Instruction Tracing support
+ * Copyright (c) 2013, Intel Corporation.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <stdbool.h>
+
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+
+#include "../perf.h"
+#include "types.h"
+#include "util.h"
+#include "evlist.h"
+#include "cpumap.h"
+#include "thread_map.h"
+#include "itrace.h"
+
+int itrace_mmap__mmap(struct itrace_mmap *mm, struct itrace_mmap_params *mp,
+		      int fd)
+{
+	off_t offs = PERF_EVENT_ITRACE_OFFSET;
+
+#if BITS_PER_LONG != 64 && !defined(HAVE_SYNC_COMPARE_AND_SWAP_SUPPORT)
+	pr_err("Cannot use Instruction Tracing mmaps\n");
+	return -1;
+#endif
+
+	mm->mask = mp->mask;
+	mm->len = mp->len;
+	mm->mmap_len = mp->mmap_len;
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
+	mm->base = mmap(NULL, mp->mmap_len, mp->prot, MAP_SHARED, fd, offs);
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
+		munmap(mm->base, mm->mmap_len);
+}
+
+void itrace_mmap_params__init(struct itrace_mmap_params *mp,
+			      unsigned int itrace_pages, bool itrace_overwrite)
+{
+	if (itrace_pages) {
+		mp->len = itrace_pages * page_size;
+		mp->mmap_len = mp->len + page_size;
+		mp->mask = is_power_of_2(mp->len) ? mp->len - 1 : 0;
+		mp->prot = PROT_READ | (itrace_overwrite ? 0 : PROT_WRITE);
+		pr_debug2("itrace mmap length %zu\n", mp->mmap_len);
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
index 0000000..4b17aca
--- /dev/null
+++ b/tools/perf/util/itrace.h
@@ -0,0 +1,118 @@
+/*
+ * itrace.h: Instruction Tracing support
+ * Copyright (c) 2013, Intel Corporation.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#include "../perf.h"
+#include "types.h"
+
+struct perf_evlist;
+
+/**
+ * struct itrace_mmap - records an mmap at PERF_EVENT_ITRACE_OFFSET.
+ * @base: address of mapped area
+ * @mask: %0 if @len is not a power of two, otherwise (@len - %1)
+ * @len: size of mapped area excluding perf_event_mmap_page
+ * @mmap_len: size of mapped area including perf_event_mmap_page
+ * @prev: previous data_head
+ * @idx: index of this mmap
+ * @tid: tid for a per-thread mmap (also set if there is only 1 tid on a per-cpu
+ *       mmap) otherwise %0
+ * @cpu: cpu number for a per-cpu mmap otherwise %-1
+ */
+struct itrace_mmap {
+	void		*base;
+	size_t		mask;
+	size_t		len;
+	size_t		mmap_len;
+	u64		prev;
+	int		idx;
+	pid_t		tid;
+	int		cpu;
+};
+
+/**
+ * struct itrace_mmap_params - parameters to set up struct itrace_mmap.
+ * @mask: %0 if @len is not a power of two, otherwise (@len - %1)
+ * @len: size of mapped area excluding perf_event_mmap_page
+ * @mmap_len: size of mapped area including perf_event_mmap_page
+ * @prot: mmap memory protection
+ * @idx: index of this mmap
+ * @tid: tid for a per-thread mmap (also set if there is only 1 tid on a per-cpu
+ *       mmap) otherwise %0
+ * @cpu: cpu number for a per-cpu mmap otherwise %-1
+ */
+struct itrace_mmap_params {
+	size_t		mask;
+	size_t		len;
+	size_t		mmap_len;
+	int		prot;
+	int		idx;
+	pid_t		tid;
+	int		cpu;
+};
+
+static inline u64 itrace_mmap__read_head(struct itrace_mmap *mm)
+{
+	struct perf_event_mmap_page *pc = mm->base;
+#if BITS_PER_LONG == 64 || !defined(HAVE_SYNC_COMPARE_AND_SWAP_SUPPORT)
+	u64 head = ACCESS_ONCE(pc->data_head);
+#else
+	u64 head = __sync_val_compare_and_swap(&pc->data_head, 0, 0);
+#endif
+
+	/* Ensure all reads are done after we read the head */
+	rmb();
+	return head;
+}
+
+static inline void itrace_mmap__write_tail(struct itrace_mmap *mm, u64 tail)
+{
+	struct perf_event_mmap_page *pc = mm->base;
+#if BITS_PER_LONG != 64 && defined(HAVE_SYNC_COMPARE_AND_SWAP_SUPPORT)
+	u64 old_tail;
+#endif
+
+	/* Ensure all reads are done before we write the tail out */
+	mb();
+#if BITS_PER_LONG == 64 || !defined(HAVE_SYNC_COMPARE_AND_SWAP_SUPPORT)
+	pc->data_tail = tail;
+#else
+	do {
+		old_tail = __sync_val_compare_and_swap(&pc->data_tail, 0, 0);
+	} while (!__sync_bool_compare_and_swap(&pc->data_tail, old_tail, tail));
+#endif
+}
+
+int itrace_mmap__mmap(struct itrace_mmap *mm,
+		      struct itrace_mmap_params *mp, int fd);
+void itrace_mmap__munmap(struct itrace_mmap *mm);
+void itrace_mmap_params__init(struct itrace_mmap_params *mp,
+			      unsigned int itrace_pages, bool itrace_overwrite);
+void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
+				 struct perf_evlist *evlist, int idx,
+				 bool per_cpu);
+
+#endif
-- 
1.8.5.1

