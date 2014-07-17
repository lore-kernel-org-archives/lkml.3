Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934909AbaGQQOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:52572 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030222AbaGQQOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:41 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/33] perf evsel: Add 'immediate' option
Date: Thu, 17 Jul 2014 13:12:26 -0300
Message-Id: <1405613555-23380-25-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option to cause a selected event to be enabled immediately when
configured by perf_evsel__config().

This is needed when using the sched_switch tracepoint to follow object
code execution.  By having sched_switch enabled immediately the first
sched_switch event precedes the start of other tracing.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-34-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 5 +++++
 tools/perf/util/evsel.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 40626e5fc1c0..90f58cdd0fb0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -681,6 +681,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel) &&
 		!opts->initial_delay)
 		attr->enable_on_exec = 1;
+
+	if (evsel->immediate) {
+		attr->disabled = 0;
+		attr->enable_on_exec = 0;
+	}
 }
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8dfec05bcec2..d7f93ce0ebc1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -84,6 +84,7 @@ struct perf_evsel {
 	bool 			supported;
 	bool 			needs_swap;
 	bool			no_aux_samples;
+	bool			immediate;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
-- 
1.9.3

