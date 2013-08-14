Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3HNMm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:42:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:33982 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab3HNMmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:42:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,876,1367996400"; 
   d="scan'208";a="346237383"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V11 02/15] perf tools: add debug prints
Date: Wed, 14 Aug 2013 15:48:24 +0300
Message-Id: <1376484517-5339-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to see the arguments to perf_event_open
and whether the perf events ring buffer was mmapped
per-cpu or per-thread.  That information will now be
displayed when verbose is 2 i.e option -vv

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c |  3 +++
 tools/perf/util/evsel.c  | 66 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

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
index 960394e..ad5f701 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -21,6 +21,7 @@
 #include "thread_map.h"
 #include "target.h"
 #include "perf_regs.h"
+#include "debug.h"
 
 static struct {
 	bool sample_id_all;
@@ -861,6 +862,65 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
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
+	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
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
+	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
+
+	return ret;
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
@@ -884,6 +944,9 @@ retry_sample_id:
 	if (perf_missing_features.sample_id_all)
 		evsel->attr.sample_id_all = 0;
 
+	if (verbose >= 2)
+		perf_event_attr__fprintf(&evsel->attr, stderr);
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
 		for (thread = 0; thread < threads->nr; thread++) {
@@ -894,6 +957,9 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+			pr_debug2("perf_event_open: ");
+			pr_debug2("pid %d  cpu %d  group_fd %d  flags %#lx\n",
+				  pid, cpus->map[cpu], group_fd, flags);
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
-- 
1.7.11.7

