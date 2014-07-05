Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaGEKlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:41:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaGEKlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:41:20 -0400
Date: Sat, 5 Jul 2014 03:40:59 -0700
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-0c82adcf141935b6312593a53f87342dbb12b704@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, stfomichev@yandex-team.ru,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, stfomichev@yandex-team.ru, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1403799268-1367-2-git-send-email-stfomichev@yandex-team.ru>
References: <1403799268-1367-2-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add perf_event parameter to tracepoint_handler
Git-Commit-ID: 0c82adcf141935b6312593a53f87342dbb12b704
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

Commit-ID:  0c82adcf141935b6312593a53f87342dbb12b704
Gitweb:     http://git.kernel.org/tip/0c82adcf141935b6312593a53f87342dbb12b704
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Thu, 26 Jun 2014 20:14:24 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Jun 2014 16:00:45 -0300

perf trace: Add perf_event parameter to tracepoint_handler

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
index 5549cee..4a9e26b 100644
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
 
