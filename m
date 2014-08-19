Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaHSPEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:04:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:37083 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaHSPEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:04:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="578794101"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Add PERF_PID
Date: Tue, 19 Aug 2014 08:04:03 -0700
Message-Id: <1408460643-27283-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

It's currently difficult to filter out perf itself using a filter.
This can give cascading effects during IO tracing when the IO
perf does itself causes more trace output.

The best way to filter is to use the pid. But it's difficult to get the pid
of perf without using hacks.

Add a PERF_PID meta variable to the perf filter that contains the current pid.

With this patch the following works

% perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...

This won't work for more complex perf pipe lines with multiple processes,
but at least solves the problem nicely for a single perf.

v2: Remove debug code. Don't use zero padding (Namhyung)
v3: Correct patch.
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt | 2 +-
 tools/perf/util/parse-events.c           | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d460049..b6c5e51 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -41,7 +41,7 @@ OPTIONS
           'mem:0x1000:rw'.
 
 --filter=<filter>::
-        Event filter.
+        Event filter. PERF_PID represents the perf pid.
 
 -a::
 --all-cpus::
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1e15df1..def8651 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -967,6 +967,7 @@ int parse_filter(const struct option *opt, const char *str,
 {
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_evsel *last = NULL;
+	char *pid;
 
 	if (evlist->nr_entries > 0)
 		last = perf_evlist__last(evlist);
@@ -983,6 +984,13 @@ int parse_filter(const struct option *opt, const char *str,
 		return -1;
 	}
 
+	/* Assume a pid has not more than 8 characters */
+	pid = strstr(last->filter, "PERF_PID");
+	if (pid) {
+		char buf[9];
+		snprintf(buf, 9, "%8d", getpid());
+		memcpy(pid, buf, 8);
+	}
 	return 0;
 }
 
-- 
1.9.3

