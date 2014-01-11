Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929AbaAKVih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 16:38:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:60755 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaAKVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 16:38:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="457278351"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf, tools: Add --initial-delay support to perf record v3
Date: Sat, 11 Jan 2014 13:38:27 -0800
Message-Id: <1389476307-2124-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf stat has a --delay option to delay measuring the workload.
This is useful to skip measuring the startup phase of the program, which
is often very different from the main workload.

The same is useful for perf record when sampling.

--no-delay was already taken, so add a --initial-delay
to perf record too.
-D was already taken for record, so there is only a long option.

v2: Don't disable group members (Namhyung Kim)
v3: port to latest perf/core
    rename to --initial-delay to avoid conflict with --no-delay
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt | 4 ++++
 tools/perf/builtin-record.c              | 9 ++++++++-
 tools/perf/perf.h                        | 1 +
 tools/perf/util/evsel.c                  | 3 ++-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c407897..82bffac 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -209,6 +209,10 @@ overrides that and uses per-thread mmaps.  A side-effect of that is that
 inheritance is automatically disabled.  --per-thread is ignored with a warning
 if combined with -a or -C options.
 
+--initial-delay msecs::
+After starting the program, wait msecs before measuring. This is useful to
+filter out the startup phase of the program, which is often very different.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8860015..07d4cf8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -499,7 +499,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	 * (apart from group members) have enable_on_exec=1 set,
 	 * so don't spoil it by prematurely enabling them.
 	 */
-	if (!target__none(&opts->target))
+	if (!target__none(&opts->target) && !opts->initial_delay)
 		perf_evlist__enable(rec->evlist);
 
 	/*
@@ -508,6 +508,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(rec->evlist);
 
+	if (opts->initial_delay) {
+		usleep(opts->initial_delay * 1000);
+		perf_evlist__enable(rec->evlist);
+	}
+
 	for (;;) {
 		int hits = rec->samples;
 
@@ -877,6 +882,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &record.evlist, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_UINTEGER(0, "initial-delay", &record.opts.initial_delay,
+		  "ms to wait before starting measurement after program start"),
 	OPT_STRING('u', "uid", &record.opts.target.uid_str, "user",
 		   "user to profile"),
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b1cc84b..af1ce6e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -269,6 +269,7 @@ struct record_opts {
 	u64	     user_interval;
 	u16	     stack_dump_size;
 	bool	     sample_transaction;
+	unsigned     initial_delay;
 };
 
 #endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ade8d9c..cd4630a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -658,7 +658,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	 * Setting enable_on_exec for independent events and
 	 * group leaders for traced executed by perf.
 	 */
-	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
+	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel) &&
+		!opts->initial_delay)
 		attr->enable_on_exec = 1;
 }
 
-- 
1.8.3.1

