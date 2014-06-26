Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaFZVDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:03:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:44742 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaFZVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:02:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf trace: Add perf_event parameter to tracepoint_handler
Date: Thu, 26 Jun 2014 18:01:44 -0300
Message-Id: <1403816507-12943-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403816507-12943-1-git-send-email-acme@kernel.org>
References: <1403816507-12943-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

It will be used by next pagefault tracing patches in the series.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403799268-1367-2-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5549cee61680..4a9e26b731fe 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1538,6 +1538,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 }
 
 typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
+				  union perf_event *event,
 				  struct perf_sample *sample);
 
 static struct syscall *trace__syscall_info(struct trace *trace,
@@ -1610,6 +1611,7 @@ static void thread__update_stats(struct thread_trace *ttrace,
 }
 
 static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
+			    union perf_event *event __maybe_unused,
 			    struct perf_sample *sample)
 {
 	char *msg;
@@ -1658,6 +1660,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 }
 
 static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
+			   union perf_event *event __maybe_unused,
 			   struct perf_sample *sample)
 {
 	int ret;
@@ -1735,6 +1738,7 @@ out:
 }
 
 static int trace__vfs_getname(struct trace *trace, struct perf_evsel *evsel,
+			      union perf_event *event __maybe_unused,
 			      struct perf_sample *sample)
 {
 	trace->last_vfs_getname = perf_evsel__rawptr(evsel, sample, "pathname");
@@ -1742,6 +1746,7 @@ static int trace__vfs_getname(struct trace *trace, struct perf_evsel *evsel,
 }
 
 static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evsel,
+				     union perf_event *event __maybe_unused,
 				     struct perf_sample *sample)
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
@@ -1781,7 +1786,7 @@ static bool skip_sample(struct trace *trace, struct perf_sample *sample)
 }
 
 static int trace__process_sample(struct perf_tool *tool,
-				 union perf_event *event __maybe_unused,
+				 union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __maybe_unused)
@@ -1799,7 +1804,7 @@ static int trace__process_sample(struct perf_tool *tool,
 
 	if (handler) {
 		++trace->nr_events;
-		handler(trace, evsel, sample);
+		handler(trace, evsel, event, sample);
 	}
 
 	return err;
@@ -1990,7 +1995,7 @@ again:
 			}
 
 			handler = evsel->handler;
-			handler(trace, evsel, &sample);
+			handler(trace, evsel, event, &sample);
 next_event:
 			perf_evlist__mmap_consume(evlist, i);
 
-- 
1.9.3

