Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3LKMj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:21366 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3LKMjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442368668"
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
Subject: [PATCH v0 26/71] perf evsel: Add 'immediate' option
Date: Wed, 11 Dec 2013 14:36:38 +0200
Message-Id: <1386765443-26966-27-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option to cause a selected event
to be enabled immediately when configured
by perf_evsel__config().

This is needed when using the sched_switch
tracepoint to follow object code execution.
By having sched_switch enabled immediately
the first sched_switch event always
precedes the start of other tracing.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 5 +++++
 tools/perf/util/evsel.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dbf737c..5fcd7cb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -661,6 +661,11 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	 */
 	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
 		attr->enable_on_exec = 1;
+
+	if (evsel->immediate) {
+		attr->disabled = 0;
+		attr->enable_on_exec = 0;
+	}
 }
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index af38e2c..de1b36e 100644
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
1.8.5.1

