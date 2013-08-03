Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3HCAll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:41:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:11835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3HCAli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:41:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="375428877"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: eranian@google.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] perf, tools: Add support for --initial-delay option to perf stat
Date: Fri,  2 Aug 2013 17:41:11 -0700
Message-Id: <1375490473-1503-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When measuring workloads the startup phase -- doing page faults,
dynamic linking, opening files -- is often very different from
the rest of the workload.  Especially with smaller kernels
and using counter multiplexing this can give significant
measurement errors.

Multiplexing assumes that the workload is mostly the same
over longer periods. But at startup there is typically
some spike of activity which is relatively short.
If many groups are multiplexing the one group seeing
the spike, and which is then scaled up over the time to run all
groups, may see a significant error.

Also in general it's often not useful to measure the startup,
because it is so different from the rest.

One way around this is to use interval mode and discard
the first sample, but this can be awkward because interval
mode doesn't support intervals of less than 100ms,
and also a useful interval is not necessarily the same
as a useful startup delay.

This patch adds a new --initial-delay / -D option to skip measuring
for the startup phase. The time can be specified in ms

Here's a simple example:

perf stat -e page-faults bash -c 'for i in $(seq 100000) ; do true ; done'
...
             3,721 page-faults
...

If we just wait 20 ms the number of page faults is 1/3 less:
perf stat -D 20 -e page-faults bash -c 'for i in $(seq 100000) ; do true ; done'
...
             2,823 page-faults
...

So we filtered out most of the startup noise from bash.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-stat.txt |  5 +++++
 tools/perf/builtin-stat.c              | 22 +++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2fe87fb..73c9759 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -132,6 +132,11 @@ is a useful mode to detect imbalance between physical cores.  To enable this mod
 use --per-core in addition to -a. (system-wide).  The output includes the
 core number and the number of online logical processors on that physical processor.
 
+-D msecs::
+--initial-delay msecs::
+After starting the program, wait msecs before measuring. This is useful to
+filter out the startup phase of the program, which is often very different.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 352fbd7..2e637e4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -100,6 +100,7 @@ static const char		*pre_cmd			= NULL;
 static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
 static unsigned int		interval			= 0;
+static unsigned int		initial_delay			= 0;
 static bool			forever				= false;
 static struct timespec		ref_time;
 static struct cpu_map		*aggr_map;
@@ -254,7 +255,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 	if (!perf_target__has_task(&target) &&
 	    perf_evsel__is_group_leader(evsel)) {
 		attr->disabled = 1;
-		attr->enable_on_exec = 1;
+		if (!initial_delay)
+			attr->enable_on_exec = 1;
 	}
 
 	return perf_evsel__open_per_thread(evsel, evsel_list->threads);
@@ -416,6 +418,20 @@ static void print_interval(void)
 	}
 }
 
+static void handle_initial_delay(void)
+{
+	struct perf_evsel *counter;
+
+	if (initial_delay) {
+		const int ncpus = cpu_map__nr(evsel_list->cpus),
+			nthreads = thread_map__nr(evsel_list->threads);
+
+		usleep(initial_delay * 1000);
+		list_for_each_entry(counter, &evsel_list->entries, node)
+			perf_evsel__enable(counter, ncpus, nthreads);
+	}
+}
+
 static int __run_perf_stat(int argc, const char **argv)
 {
 	char msg[512];
@@ -486,6 +502,7 @@ static int __run_perf_stat(int argc, const char **argv)
 
 	if (forks) {
 		perf_evlist__start_workload(evsel_list);
+		handle_initial_delay();
 
 		if (interval) {
 			while (!waitpid(child_pid, &status, WNOHANG)) {
@@ -497,6 +514,7 @@ static int __run_perf_stat(int argc, const char **argv)
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
 	} else {
+		handle_initial_delay();
 		while (!done) {
 			nanosleep(&ts, NULL);
 			if (interval)
@@ -1419,6 +1437,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "aggregate counts per processor socket", AGGR_SOCKET),
 	OPT_SET_UINT(0, "per-core", &aggr_mode,
 		     "aggregate counts per physical processor core", AGGR_CORE),
+	OPT_UINTEGER('D', "delay", &initial_delay,
+		     "ms to wait before starting measurement after program start"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
-- 
1.8.3.1

