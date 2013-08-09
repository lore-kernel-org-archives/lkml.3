Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967188Ab3HIKqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:46:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:22271 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab3HIKp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:45:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,845,1367996400"; 
   d="scan'208";a="279834318"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V10 01/13] perf tools: add debug prints
Date: Fri,  9 Aug 2013 13:51:47 +0300
Message-Id: <1376045519-13832-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to see the arguments to perf_event_open
and whether the perf events ring buffer was mmapped
per-cpu or per-thread.  That information will now be
displayed when verbose is 2 i.e option -vv

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c |  3 +++
 tools/perf/util/evsel.c  | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/python.c | 20 ++++++++++++++
 3 files changed, 91 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c7d111f..1f5105a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -14,6 +14,7 @@
 #include "target.h"
 #include "evlist.h"
 #include "evsel.h"
+#include "debug.h"
 #include <unistd.h>
 
 #include "parse-events.h"
@@ -486,6 +487,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	int nr_cpus = cpu_map__nr(evlist->cpus);
 	int nr_threads = thread_map__nr(evlist->threads);
 
+	pr_debug2("perf event ring buffer mmapped per cpu\n");
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 
@@ -524,6 +526,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
 
+	pr_debug2("perf event ring buffer mmapped per thread\n");
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 960394e..4114463 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -21,6 +21,7 @@
 #include "thread_map.h"
 #include "target.h"
 #include "perf_regs.h"
+#include "debug.h"
 
 static struct {
 	bool sample_id_all;
@@ -861,6 +862,67 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	return fd;
 }
 
+#define __PRINT_ATTR(fmt, cast, field)  \
+	fprintf(fp, "  %-19s "fmt"\n", #field, cast attr->field)
+
+#define PRINT_ATTR_U32(field)  __PRINT_ATTR("%u" , , field)
+#define PRINT_ATTR_X32(field)  __PRINT_ATTR("%#x", , field)
+#define PRINT_ATTR_U64(field)  __PRINT_ATTR("%" PRIu64, (uint64_t), field)
+#define PRINT_ATTR_X64(field)  __PRINT_ATTR("%#"PRIx64, (uint64_t), field)
+
+#define PRINT_ATTR2N(name1, field1, name2, field2)	\
+	fprintf(fp, "  %-19s %u    %-19s %u\n",		\
+	name1, attr->field1, name2, attr->field2)
+
+#define PRINT_ATTR2(field1, field2) \
+	PRINT_ATTR2N(#field1, field1, #field2, field2)
+
+static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
+{
+	size_t ret = 0;
+
+	ret += fprintf(fp, "------------------------------");
+	ret += fprintf(fp, "------------------------------\n");
+	ret += fprintf(fp, "perf_event_attr:\n");
+
+	ret += PRINT_ATTR_U32(type);
+	ret += PRINT_ATTR_U32(size);
+	ret += PRINT_ATTR_X64(config);
+	ret += PRINT_ATTR_U64(sample_period);
+	ret += PRINT_ATTR_U64(sample_freq);
+	ret += PRINT_ATTR_X64(sample_type);
+	ret += PRINT_ATTR_X64(read_format);
+
+	ret += PRINT_ATTR2(disabled, inherit);
+	ret += PRINT_ATTR2(pinned, exclusive);
+	ret += PRINT_ATTR2(exclude_user, exclude_kernel);
+	ret += PRINT_ATTR2(exclude_hv, exclude_idle);
+	ret += PRINT_ATTR2(mmap, comm);
+	ret += PRINT_ATTR2(freq, inherit_stat);
+	ret += PRINT_ATTR2(enable_on_exec, task);
+	ret += PRINT_ATTR2(watermark, precise_ip);
+	ret += PRINT_ATTR2(mmap_data, sample_id_all);
+	ret += PRINT_ATTR2(exclude_host, exclude_guest);
+	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
+			    "excl.callchain_user", exclude_callchain_user);
+
+	ret += PRINT_ATTR_U32(wakeup_events);
+	ret += PRINT_ATTR_U32(wakeup_watermark);
+	ret += PRINT_ATTR_X32(bp_type);
+	ret += PRINT_ATTR_X64(bp_addr);
+	ret += PRINT_ATTR_X64(config1);
+	ret += PRINT_ATTR_U64(bp_len);
+	ret += PRINT_ATTR_X64(config2);
+	ret += PRINT_ATTR_X64(branch_sample_type);
+	ret += PRINT_ATTR_X64(sample_regs_user);
+	ret += PRINT_ATTR_U32(sample_stack_user);
+
+	ret += fprintf(fp, "------------------------------");
+	ret += fprintf(fp, "------------------------------\n");
+
+	return ret;
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
@@ -884,6 +946,9 @@ retry_sample_id:
 	if (perf_missing_features.sample_id_all)
 		evsel->attr.sample_id_all = 0;
 
+	if (verbose >= 2)
+		perf_event_attr__fprintf(&evsel->attr, stderr);
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
 		for (thread = 0; thread < threads->nr; thread++) {
@@ -894,6 +959,9 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+			pr_debug2("perf_event_open: ");
+			pr_debug2("pid %d  cpu %d  group_fd %d  flags %#lx\n",
+				  pid, cpus->map[cpu], group_fd, flags);
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 925e0c3..381f4fd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -8,6 +8,26 @@
 #include "cpumap.h"
 #include "thread_map.h"
 
+/*
+ * Support debug printing even though util/debug.c is not linked.  That means
+ * implementing 'verbose' and 'eprintf'.
+ */
+int verbose;
+
+int eprintf(int level, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (verbose >= level) {
+		va_start(args, fmt);
+		ret = vfprintf(stderr, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
 #ifndef PyVarObject_HEAD_INIT
 # define PyVarObject_HEAD_INIT(type, size) PyObject_HEAD_INIT(type) size,
-- 
1.7.11.7

