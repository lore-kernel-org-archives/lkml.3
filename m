Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309AbaGQQOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:52557 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030222AbaGQQOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:37 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/33] perf evsel: Add 'no_aux_samples' option
Date: Thu, 17 Jul 2014 13:12:25 -0300
Message-Id: <1405613555-23380-24-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option to prevent additional samples being added to a selected
event by perf_evsel__config().

This is needed when using the sched_switch tracepoint to follow object
code execution.  Since sched_switch will be used only for switch
information, additional sampling is wasteful.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-33-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 6 +++---
 tools/perf/util/evsel.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b760d32aae06..40626e5fc1c0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -623,7 +623,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph_enabled)
+	if (opts->call_graph_enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel, opts);
 
 	if (target__has_cpu(&opts->target))
@@ -637,7 +637,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	     target__has_cpu(&opts->target) || per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
-	if (opts->raw_samples) {
+	if (opts->raw_samples && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, TIME);
 		perf_evsel__set_sample_bit(evsel, RAW);
 		perf_evsel__set_sample_bit(evsel, CPU);
@@ -650,7 +650,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
 	}
-	if (opts->branch_stack) {
+	if (opts->branch_stack && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
 		attr->branch_sample_type = opts->branch_stack;
 	}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a52e9a5bb2d0..8dfec05bcec2 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -83,6 +83,7 @@ struct perf_evsel {
 	int			is_pos;
 	bool 			supported;
 	bool 			needs_swap;
+	bool			no_aux_samples;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
-- 
1.9.3

