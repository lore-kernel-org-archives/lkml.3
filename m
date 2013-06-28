Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3F1IiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:38:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:10888 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab3F1IiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:38:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="323821382"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 10/15] perf tools: add debug prints
Date: Fri, 28 Jun 2013 11:43:21 +0300
Message-Id: <1372409006-8431-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/util/evsel.c  | 52 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3c8b569..a660f56 100644
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
index 63b6f8c..d01d2cd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -21,6 +21,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
 #include "perf_regs.h"
+#include "debug.h"
 
 static struct {
 	bool sample_id_all;
@@ -817,6 +818,54 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	return fd;
 }
 
+static void show_attr(struct perf_event_attr *attr)
+{
+	pr_debug2("------------------------------------------------------------\n");
+	pr_debug2("perf_event_attr:\n");
+	pr_debug2("  type                %u\n", attr->type);
+	pr_debug2("  size                %u\n", attr->size);
+	pr_debug2("  config              %#"PRIx64"\n", (uint64_t)attr->config);
+	pr_debug2("  sample_period       %"PRIu64"\n", (uint64_t)attr->sample_period);
+	pr_debug2("  sample_freq         %"PRIu64"\n", (uint64_t)attr->sample_freq);
+	pr_debug2("  sample_type         %#"PRIx64"\n", (uint64_t)attr->sample_type);
+	pr_debug2("  read_format         %#"PRIx64"\n", (uint64_t)attr->read_format);
+
+	pr_debug2("  disabled            %u    ", attr->disabled);
+	pr_debug2("inherit             %u\n", attr->inherit);
+	pr_debug2("  pinned              %u    ", attr->pinned);
+	pr_debug2("exclusive           %u\n", attr->exclusive);
+	pr_debug2("  exclude_user        %u    ", attr->exclude_user);
+	pr_debug2("exclude_kernel      %u\n", attr->exclude_kernel);
+	pr_debug2("  exclude_hv          %u    ", attr->exclude_hv);
+	pr_debug2("exclude_idle        %u\n", attr->exclude_idle);
+	pr_debug2("  mmap                %u    ", attr->mmap);
+	pr_debug2("comm                %u\n", attr->comm);
+	pr_debug2("  freq                %u    ", attr->freq);
+	pr_debug2("inherit_stat        %u\n", attr->inherit_stat);
+	pr_debug2("  enable_on_exec      %u    ", attr->enable_on_exec);
+	pr_debug2("task                %u\n", attr->task);
+	pr_debug2("  watermark           %u    ", attr->watermark);
+	pr_debug2("precise_ip          %u\n", attr->precise_ip);
+	pr_debug2("  mmap_data           %u    ", attr->mmap_data);
+	pr_debug2("sample_id_all       %u\n", attr->sample_id_all);
+	pr_debug2("  exclude_host        %u    ", attr->exclude_host);
+	pr_debug2("exclude_guest       %u\n", attr->exclude_guest);
+	pr_debug2("  excl.callchain.kern %u    ", attr->exclude_callchain_kernel);
+	pr_debug2("excl.callchain.user %u\n", attr->exclude_callchain_user);
+
+	pr_debug2("  wakeup_events       %u\n", attr->wakeup_events);
+	pr_debug2("  wakeup_watermark    %u\n", attr->wakeup_watermark);
+	pr_debug2("  bp_type             %#x\n", attr->bp_type);
+	pr_debug2("  bp_addr             %#"PRIx64"\n", (uint64_t)attr->bp_addr);
+	pr_debug2("  config1             %#"PRIx64"\n", (uint64_t)attr->config1);
+	pr_debug2("  bp_len              %"PRIu64"\n", (uint64_t)attr->bp_len);
+	pr_debug2("  config2             %#"PRIx64"\n", (uint64_t)attr->config2);
+	pr_debug2("  branch_sample_type  %#"PRIx64"\n", (uint64_t)attr->branch_sample_type);
+	pr_debug2("  sample_regs_user    %#"PRIx64"\n", (uint64_t)attr->sample_regs_user);
+	pr_debug2("  sample_stack_user   %u\n", attr->sample_stack_user);
+	pr_debug2("------------------------------------------------------------\n");
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
@@ -840,6 +889,7 @@ retry_sample_id:
 	if (perf_missing_features.sample_id_all)
 		evsel->attr.sample_id_all = 0;
 
+	show_attr(&evsel->attr);
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
 		for (thread = 0; thread < threads->nr; thread++) {
@@ -850,6 +900,8 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+				  pid, cpus->map[cpu], group_fd, flags);
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
-- 
1.7.11.7

