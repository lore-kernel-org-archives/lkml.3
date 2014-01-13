Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaAMUsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:48:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40369 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaAMUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/38] perf record: Add --initial-delay option
Date: Mon, 13 Jan 2014 17:47:32 -0300
Message-Id: <1389646059-24881-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
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

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1389476307-2124-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt | 4 ++++
 tools/perf/builtin-record.c              | 9 ++++++++-
 tools/perf/perf.h                        | 1 +
 tools/perf/util/evsel.c                  | 3 ++-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c407897f0435..82bffac036e1 100644
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
index 88600158400e..07d4cf8d3fd3 100644
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
index b1cc84b01d5b..af1ce6e14a93 100644
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
index ade8d9c1c431..cd4630abfa43 100644
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
1.8.1.4

