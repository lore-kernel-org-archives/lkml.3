Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3KGPGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:06:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3KGPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/7] perf evsel: Ditch evsel->handler.data field
Date: Thu,  7 Nov 2013 12:04:12 -0300
Message-Id: <1383836658-10518-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383836658-10518-1-git-send-email-acme@infradead.org>
References: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Not needed since this cset:

  fcf65bf149af: perf evsel: Cache associated event_format

So lets trim this struct a bit.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j8setslokt0goiwxq9dogzqm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c    | 10 +++++-----
 tools/perf/builtin-kmem.c      |  4 ++--
 tools/perf/builtin-lock.c      |  4 ++--
 tools/perf/builtin-sched.c     |  4 ++--
 tools/perf/builtin-timechart.c |  4 ++--
 tools/perf/builtin-trace.c     |  6 +++---
 tools/perf/util/evlist.c       |  2 +-
 tools/perf/util/evsel.h        |  5 +----
 tools/perf/util/session.c      |  4 ++--
 9 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 409ceaf3b9b9..6a2508589460 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -106,8 +106,8 @@ static int perf_event__repipe_sample(struct perf_tool *tool,
 				     struct perf_evsel *evsel,
 				     struct machine *machine)
 {
-	if (evsel->handler.func) {
-		inject_handler f = evsel->handler.func;
+	if (evsel->handler) {
+		inject_handler f = evsel->handler;
 		return f(tool, event, sample, evsel, machine);
 	}
 
@@ -383,11 +383,11 @@ static int __cmd_inject(struct perf_inject *inject)
 				if (perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID"))
 					return -EINVAL;
 
-				evsel->handler.func = perf_inject__sched_switch;
+				evsel->handler = perf_inject__sched_switch;
 			} else if (!strcmp(name, "sched:sched_process_exit"))
-				evsel->handler.func = perf_inject__sched_process_exit;
+				evsel->handler = perf_inject__sched_process_exit;
 			else if (!strncmp(name, "sched:sched_stat_", 17))
-				evsel->handler.func = perf_inject__sched_stat;
+				evsel->handler = perf_inject__sched_stat;
 		}
 	}
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index a28970f7ddfb..929462aa4943 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -317,8 +317,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 
-	if (evsel->handler.func != NULL) {
-		tracepoint_handler f = evsel->handler.func;
+	if (evsel->handler != NULL) {
+		tracepoint_handler f = evsel->handler;
 		return f(evsel, sample);
 	}
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 35f9aaa565cc..c852c7a85d32 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -819,8 +819,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (evsel->handler.func != NULL) {
-		tracepoint_handler f = evsel->handler.func;
+	if (evsel->handler != NULL) {
+		tracepoint_handler f = evsel->handler;
 		return f(evsel, sample);
 	}
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a81ab1828aa5..0f3c65518a2c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1427,8 +1427,8 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 
-	if (evsel->handler.func != NULL) {
-		tracepoint_handler f = evsel->handler.func;
+	if (evsel->handler != NULL) {
+		tracepoint_handler f = evsel->handler;
 		err = f(tool, evsel, sample, machine);
 	}
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index e11c61d9bda4..41c9bde2fb67 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -483,8 +483,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (sample->cpu > numcpus)
 		numcpus = sample->cpu;
 
-	if (evsel->handler.func != NULL) {
-		tracepoint_handler f = evsel->handler.func;
+	if (evsel->handler != NULL) {
+		tracepoint_handler f = evsel->handler;
 		return f(evsel, sample);
 	}
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b3e57dc64546..ee59df300a34 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1570,7 +1570,7 @@ static int trace__process_sample(struct perf_tool *tool,
 	struct trace *trace = container_of(tool, struct trace, tool);
 	int err = 0;
 
-	tracepoint_handler handler = evsel->handler.func;
+	tracepoint_handler handler = evsel->handler;
 
 	if (skip_sample(trace, sample))
 		return 0;
@@ -1656,7 +1656,7 @@ static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
 		return;
 	}
 
-	evsel->handler.func = trace__vfs_getname;
+	evsel->handler = trace__vfs_getname;
 	perf_evlist__add(evlist, evsel);
 }
 
@@ -1768,7 +1768,7 @@ again:
 				goto next_event;
 			}
 
-			handler = evsel->handler.func;
+			handler = evsel->handler;
 			handler(trace, evsel, &sample);
 next_event:
 			perf_evlist__mmap_consume(evlist, i);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1c173ccb0ef2..b939221efd8d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -255,7 +255,7 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
 	if (evsel == NULL)
 		return -1;
 
-	evsel->handler.func = handler;
+	evsel->handler = handler;
 	perf_evlist__add(evlist, evsel);
 	return 0;
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 5aa68cddc7d9..64ec8e1a7a28 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -74,10 +74,7 @@ struct perf_evsel {
 		off_t		id_offset;
 	};
 	struct cgroup_sel	*cgrp;
-	struct {
-		void		*func;
-		void		*data;
-	} handler;
+	void			*handler;
 	struct cpu_map		*cpus;
 	unsigned int		sample_size;
 	int			id_pos;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0ce46943d627..f36d24a02445 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1650,9 +1650,9 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 			continue;
 
 		err = -EEXIST;
-		if (evsel->handler.func != NULL)
+		if (evsel->handler != NULL)
 			goto out;
-		evsel->handler.func = assocs[i].handler;
+		evsel->handler = assocs[i].handler;
 	}
 
 	err = 0;
-- 
1.8.1.4

