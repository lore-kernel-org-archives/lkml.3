Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3KGPbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:31:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40814 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3KGPbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:31:40 -0500
Date: Thu, 7 Nov 2013 07:30:26 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-j8setslokt0goiwxq9dogzqm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Ditch evsel->handler.data field
Git-Commit-ID: 744a971940520cf0818e1fe882b64892c528e6de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:30:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  744a971940520cf0818e1fe882b64892c528e6de
Gitweb:     http://git.kernel.org/tip/744a971940520cf0818e1fe882b64892c528e6de
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 6 Nov 2013 10:17:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 10:40:47 -0300

perf evsel: Ditch evsel->handler.data field

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
index 409ceaf..6a25085 100644
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
index a28970f..929462a 100644
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
index 35f9aaa..c852c7a 100644
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
index a81ab18..0f3c6551 100644
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
index e11c61d..41c9bde 100644
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
index b3e57dc..ee59df3 100644
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
index 1c173cc..b939221 100644
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
index 5aa68cd..64ec8e1 100644
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
index 0ce4694..f36d24a 100644
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
