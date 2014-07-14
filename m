Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaGNKE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:04:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:29944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbaGNKEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434090"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/41] perf script: Display PERF_RECORD_MISC_COMM_EXEC flag
Date: Mon, 14 Jul 2014 13:02:27 +0300
Message-Id: <1405332185-4050-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.c | 9 ++++++++-
 tools/perf/util/evsel.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d0281bd..198c4cc 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -603,7 +603,14 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
 {
-	return fprintf(fp, ": %s:%d\n", event->comm.comm, event->comm.tid);
+	const char *s;
+
+	if (event->header.misc & PERF_RECORD_MISC_COMM_EXEC)
+		s = " exec";
+	else
+		s = "";
+
+	return fprintf(fp, "%s: %s:%d\n", s, event->comm.comm, event->comm.tid);
 }
 
 int perf_event__process_comm(struct perf_tool *tool __maybe_unused,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8606175..b760d32 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -960,6 +960,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_user, exclude_kernel);
 	ret += PRINT_ATTR2(exclude_hv, exclude_idle);
 	ret += PRINT_ATTR2(mmap, comm);
+	ret += PRINT_ATTR2(mmap2, comm_exec);
 	ret += PRINT_ATTR2(freq, inherit_stat);
 	ret += PRINT_ATTR2(enable_on_exec, task);
 	ret += PRINT_ATTR2(watermark, precise_ip);
@@ -967,7 +968,6 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
-	ret += PRINT_ATTR_U32(mmap2);
 
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
@@ -1940,6 +1940,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(mmap);
 		if_print(mmap2);
 		if_print(comm);
+		if_print(comm_exec);
 		if_print(freq);
 		if_print(inherit_stat);
 		if_print(enable_on_exec);
-- 
1.8.3.2

