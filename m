Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaIXUvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:51:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:13034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIXUv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:51:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,591,1406617200"; 
   d="scan'208";a="604862675"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, tools: Add PERF_PID
Date: Wed, 24 Sep 2014 13:51:08 -0700
Message-Id: <1411591869-325-1-git-send-email-andi@firstfloor.org>
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
v4: Handle arbitary pid length.
v5: Fix a warning
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |  2 +-
 tools/perf/util/parse-events.c           | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

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
index 1e15df1..9c4bab8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -967,6 +967,9 @@ int parse_filter(const struct option *opt, const char *str,
 {
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_evsel *last = NULL;
+	char *pid, buf[30], *o;
+	int len, plen;
+	const char *p;
 
 	if (evlist->nr_entries > 0)
 		last = perf_evlist__last(evlist);
@@ -977,12 +980,28 @@ int parse_filter(const struct option *opt, const char *str,
 		return -1;
 	}
 
-	last->filter = strdup(str);
+	plen = sprintf(buf, "%d", getpid());
+	len = strlen(str) + 1;
+	for (pid = strstr(str, "PERF_PID"); pid;
+	     pid = strstr(pid + 1, "PERF_PID")) {
+		len += plen - 8;
+	}
+
+	last->filter = malloc(len);
 	if (last->filter == NULL) {
 		fprintf(stderr, "not enough memory to hold filter string\n");
 		return -1;
 	}
 
+	o = last->filter;
+	for (p = str; *p; ) {
+		if (*p == 'P' && !strncmp(p, "PERF_PID", 8)) {
+			strcpy(o, buf);
+			o += plen;
+			p += sizeof("PERF_PID") - 1;
+		} else
+			*o++ = *p++;
+	}
 	return 0;
 }
 
-- 
1.9.3

