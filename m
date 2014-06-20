Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967053AbaFTKvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:51:24 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:39493 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966681AbaFTKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:50:19 -0400
X-Yandex-Uniq: d9e4953f-4e8a-4551-a9b9-2e3d6b343a3c
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] perf trace: add perf_event parameter to tracepoint_handler
Date: Fri, 20 Jun 2014 14:49:43 +0400
Message-Id: <1403261389-13423-2-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be used by next pagefault tracing patches in the series.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-trace.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26de231..a9b542918da0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1535,6 +1535,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 }
 
 typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
+				  union perf_event *event,
 				  struct perf_sample *sample);
 
 static struct syscall *trace__syscall_info(struct trace *trace,
@@ -1607,6 +1608,7 @@ static void thread__update_stats(struct thread_trace *ttrace,
 }
 
 static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
+			    union perf_event *event __maybe_unused,
 			    struct perf_sample *sample)
 {
 	char *msg;
@@ -1656,6 +1658,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
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
1.8.3.2

