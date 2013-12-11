Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3LKMxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:53:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:35059 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3LKMjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448280302"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 25/71] perf evsel: Add 'no_aux_samples' option
Date: Wed, 11 Dec 2013 14:36:37 +0200
Message-Id: <1386765443-26966-26-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index 7b510fd..dbf737c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -596,7 +596,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph) {
+	if (opts->call_graph && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
@@ -619,7 +619,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	     target__has_cpu(&opts->target) || per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
-	if (opts->raw_samples) {
+	if (opts->raw_samples && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, TIME);
 		perf_evsel__set_sample_bit(evsel, RAW);
 		perf_evsel__set_sample_bit(evsel, CPU);
@@ -632,7 +632,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
 	}
-	if (opts->branch_stack) {
+	if (opts->branch_stack && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
 		attr->branch_sample_type = opts->branch_stack;
 	}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8120eeb..af38e2c 100644
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
1.8.5.1

