Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaGNKLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:11:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:42003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbaGNKFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434712"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 32/41] perf evsel: Add 'no_aux_samples' option
Date: Mon, 14 Jul 2014 13:02:56 +0300
Message-Id: <1405332185-4050-33-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an option to prevent additional
samples being added to a selected
event by perf_evsel__config().

This is needed when using the sched_switch
tracepoint to follow object code execution.
Since sched_switch will be used only for
switch information, additional sampling is
wasteful.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 6 +++---
 tools/perf/util/evsel.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b760d32..40626e5 100644
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
index a52e9a5..8dfec05 100644
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
1.8.3.2

