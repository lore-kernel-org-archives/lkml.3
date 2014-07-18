Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbaGRE10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:27:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33316 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760429AbaGRE1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:27:23 -0400
Date: Thu, 17 Jul 2014 21:26:29 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-6ff1ce763921f605aaf98c7a828b7df24d6923dc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-33-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-33-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Add 'no_aux_samples' option
Git-Commit-ID: 6ff1ce763921f605aaf98c7a828b7df24d6923dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ff1ce763921f605aaf98c7a828b7df24d6923dc
Gitweb:     http://git.kernel.org/tip/6ff1ce763921f605aaf98c7a828b7df24d6923dc
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:56 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:36 -0300

perf evsel: Add 'no_aux_samples' option

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
