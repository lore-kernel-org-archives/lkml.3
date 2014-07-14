Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaGNKLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:11:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:42021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaGNKFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434741"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 33/41] perf evsel: Add 'immediate' option
Date: Mon, 14 Jul 2014 13:02:57 +0300
Message-Id: <1405332185-4050-34-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an option to cause a selected event
to be enabled immediately when configured
by perf_evsel__config().

This is needed when using the sched_switch
tracepoint to follow object code execution.
By having sched_switch enabled immediately
the first sched_switch event precedes
the start of other tracing.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 5 +++++
 tools/perf/util/evsel.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 40626e5..90f58cd 100644
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
index 8dfec05..d7f93ce 100644
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
1.8.3.2

