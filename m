Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040AbaGQQNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:13:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:52217 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986AbaGQQNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:35 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/33] perf script: Display PERF_RECORD_MISC_COMM_EXEC flag
Date: Thu, 17 Jul 2014 13:12:11 -0300
Message-Id: <1405613555-23380-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 9 ++++++++-
 tools/perf/util/evsel.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d0281bdfa582..198c4cc313a1 100644
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
index 8606175fe1e8..b760d32aae06 100644
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
1.9.3

