Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaAGWOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:14:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:58673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbaAGWOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:14:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,621,1384329600"; 
   d="scan'208";a="463137832"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, tools: Add --delay support to perf record
Date: Tue,  7 Jan 2014 14:14:07 -0800
Message-Id: <1389132847-31982-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389132847-31982-1-git-send-email-andi@firstfloor.org>
References: <1389132847-31982-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf stat has a --delay option to delay measuring the workload.
This is useful to skip measuring the startup phase of the program, which
is often very different from the main workload.

The same is useful for perf record when sampling. Add --delay to perf record too.
-D was already taken for record, so there is only a long option.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt | 4 ++++
 tools/perf/builtin-record.c              | 9 ++++++++-
 tools/perf/perf.h                        | 1 +
 tools/perf/util/evsel.c                  | 5 +++--
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 43b42c4..e349151 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -207,6 +207,10 @@ Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
 forces per-cpu mmaps.  A side-effect of that is that inheritance is
 automatically enabled.  Add the -i option also to disable inheritance.
 
+--delay msecs::
+After starting the program, wait msecs before measuring. This is useful to
+filter out the startup phase of the program, which is often very different.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7c8020a..110158e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -506,7 +506,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	 * (apart from group members) have enable_on_exec=1 set,
 	 * so don't spoil it by prematurely enabling them.
 	 */
-	if (!target__none(&opts->target))
+	if (!target__none(&opts->target) && !opts->initial_delay)
 		perf_evlist__enable(evsel_list);
 
 	/*
@@ -515,6 +515,11 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(evsel_list);
 
+	if (opts->initial_delay) {
+		usleep(opts->initial_delay * 1000);
+		perf_evlist__enable(evsel_list);
+	}
+
 	for (;;) {
 		int hits = rec->samples;
 
@@ -890,6 +895,8 @@ const struct option record_options[] = {
 		    "sample transaction flags (special events only)"),
 	OPT_BOOLEAN(0, "force-per-cpu", &record.opts.target.force_per_cpu,
 		    "force the use of per-cpu mmaps"),
+	OPT_UINTEGER(0, "delay", &record.opts.initial_delay,
+		  "ms to wait before starting measurement after program start"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b079304..d052f1d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -268,6 +268,7 @@ struct perf_record_opts {
 	u64	     user_interval;
 	u16	     stack_dump_size;
 	bool	     sample_transaction;
+	unsigned     initial_delay;
 };
 
 #endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 46dd4c2..4a70656 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -689,14 +689,15 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	 * Disabling only independent events or group leaders,
 	 * keeping group members enabled.
 	 */
-	if (perf_evsel__is_group_leader(evsel))
+	if (perf_evsel__is_group_leader(evsel) || opts->initial_delay)
 		attr->disabled = 1;
 
 	/*
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

