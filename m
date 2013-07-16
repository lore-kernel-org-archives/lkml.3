Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab3GPGbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:31:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:21175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3GPGbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,674,1367996400"; 
   d="scan'208";a="365882580"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V6 01/12] perf tools: add debug prints
Date: Tue, 16 Jul 2013 09:38:07 +0300
Message-Id: <1373956698-27540-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
References: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to see the arguments to perf_event_open
and whether the perf events ring buffer was mmapped
per-cpu or per-thread.  That information will now be
displayed when verbose is 2 i.e option -vv

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c |  3 +++
 tools/perf/util/evsel.c  | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 42ea4e9..2b77b33 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -14,6 +14,7 @@
 #include "target.h"
 #include "evlist.h"
 #include "evsel.h"
+#include "debug.h"
 #include <unistd.h>
 
 #include "parse-events.h"
@@ -454,6 +455,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	int nr_cpus = cpu_map__nr(evlist->cpus);
 	int nr_threads = thread_map__nr(evlist->threads);
 
+	pr_debug2("perf event ring buffer mmapped per cpu\n");
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 
@@ -492,6 +494,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
 
+	pr_debug2("perf event ring buffer mmapped per thread\n");
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a635461..0b9c4fd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -21,6 +21,7 @@
 #include "thread_map.h"
 #include "target.h"
 #include "perf_regs.h"
+#include "debug.h"
 
 static struct {
 	bool sample_id_all;
@@ -817,6 +818,58 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	return fd;
 }
 
+static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
+{
+	size_t ret;
+
+	ret = fprintf(fp, "------------------------------------------------------------\n");
+	ret += fprintf(fp, "perf_event_attr:\n");
+	ret += fprintf(fp, "  type                %u\n", attr->type);
+	ret += fprintf(fp, "  size                %u\n", attr->size);
+	ret += fprintf(fp, "  config              %#"PRIx64"\n", (uint64_t)attr->config);
+	ret += fprintf(fp, "  sample_period       %"PRIu64"\n", (uint64_t)attr->sample_period);
+	ret += fprintf(fp, "  sample_freq         %"PRIu64"\n", (uint64_t)attr->sample_freq);
+	ret += fprintf(fp, "  sample_type         %#"PRIx64"\n", (uint64_t)attr->sample_type);
+	ret += fprintf(fp, "  read_format         %#"PRIx64"\n", (uint64_t)attr->read_format);
+
+	ret += fprintf(fp, "  disabled            %u    ", attr->disabled);
+	ret += fprintf(fp, "inherit             %u\n", attr->inherit);
+	ret += fprintf(fp, "  pinned              %u    ", attr->pinned);
+	ret += fprintf(fp, "exclusive           %u\n", attr->exclusive);
+	ret += fprintf(fp, "  exclude_user        %u    ", attr->exclude_user);
+	ret += fprintf(fp, "exclude_kernel      %u\n", attr->exclude_kernel);
+	ret += fprintf(fp, "  exclude_hv          %u    ", attr->exclude_hv);
+	ret += fprintf(fp, "exclude_idle        %u\n", attr->exclude_idle);
+	ret += fprintf(fp, "  mmap                %u    ", attr->mmap);
+	ret += fprintf(fp, "comm                %u\n", attr->comm);
+	ret += fprintf(fp, "  freq                %u    ", attr->freq);
+	ret += fprintf(fp, "inherit_stat        %u\n", attr->inherit_stat);
+	ret += fprintf(fp, "  enable_on_exec      %u    ", attr->enable_on_exec);
+	ret += fprintf(fp, "task                %u\n", attr->task);
+	ret += fprintf(fp, "  watermark           %u    ", attr->watermark);
+	ret += fprintf(fp, "precise_ip          %u\n", attr->precise_ip);
+	ret += fprintf(fp, "  mmap_data           %u    ", attr->mmap_data);
+	ret += fprintf(fp, "sample_id_all       %u\n", attr->sample_id_all);
+	ret += fprintf(fp, "  exclude_host        %u    ", attr->exclude_host);
+	ret += fprintf(fp, "exclude_guest       %u\n", attr->exclude_guest);
+	ret += fprintf(fp, "  excl.callchain.kern %u    ", attr->exclude_callchain_kernel);
+	ret += fprintf(fp, "excl.callchain.user %u\n", attr->exclude_callchain_user);
+
+	ret += fprintf(fp, "  wakeup_events       %u\n", attr->wakeup_events);
+	ret += fprintf(fp, "  wakeup_watermark    %u\n", attr->wakeup_watermark);
+	ret += fprintf(fp, "  bp_type             %#x\n", attr->bp_type);
+	ret += fprintf(fp, "  bp_addr             %#"PRIx64"\n", (uint64_t)attr->bp_addr);
+	ret += fprintf(fp, "  config1             %#"PRIx64"\n", (uint64_t)attr->config1);
+	ret += fprintf(fp, "  bp_len              %"PRIu64"\n", (uint64_t)attr->bp_len);
+	ret += fprintf(fp, "  config2             %#"PRIx64"\n", (uint64_t)attr->config2);
+	ret += fprintf(fp, "  branch_sample_type  %#"PRIx64"\n", (uint64_t)attr->branch_sample_type);
+	ret += fprintf(fp, "  sample_regs_user    %#"PRIx64"\n", (uint64_t)attr->sample_regs_user);
+	ret += fprintf(fp, "  sample_stack_user   %u\n", attr->sample_stack_user);
+	ret += fprintf(fp, "------------------------------------------------------------\n");
+
+	return ret;
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
@@ -840,6 +893,9 @@ retry_sample_id:
 	if (perf_missing_features.sample_id_all)
 		evsel->attr.sample_id_all = 0;
 
+	if (verbose >= 2)
+		perf_event_attr__fprintf(&evsel->attr, stderr);
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
 		for (thread = 0; thread < threads->nr; thread++) {
@@ -850,6 +906,8 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+				  pid, cpus->map[cpu], group_fd, flags);
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
-- 
1.7.11.7

