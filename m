Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3FCJl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3FCJly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:41:54 -0400
Date: Mon, 3 Jun 2013 11:42:52 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC -tip 6/6] perf/tool: Hack 'pid' as 'irq' for
 sys_perf_event_open()
Message-ID: <20130603094251.GH30878@dhcp-26-207.brq.redhat.com>
References: <cover.1370251263.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370251263.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a decent change, just a quick fix to make
possible testing of IRQ-bound performance events.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 tools/perf/builtin-record.c  |    8 ++++++++
 tools/perf/builtin-stat.c    |    8 ++++++++
 tools/perf/util/evlist.c     |    4 +++-
 tools/perf/util/evsel.c      |    3 +++
 tools/perf/util/evsel.h      |    1 +
 tools/perf/util/target.c     |    4 ++++
 tools/perf/util/thread_map.c |   16 ++++++++++++++++
 7 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fff985c..6d67a37 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -226,11 +226,17 @@ static int perf_record__open(struct perf_record *rec)
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
 	struct perf_record_opts *opts = &rec->opts;
+	int irq = false;
 	int rc = 0;
 
 	perf_evlist__config(evlist, opts);
 
+	if (perf_target__has_cpu(&opts->target) &&
+	    perf_target__has_task(&opts->target))
+		irq = true;
+
 	list_for_each_entry(pos, &evlist->entries, node) {
+		pos->irq = irq;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
 			if (perf_evsel__fallback(pos, errno, msg, sizeof(msg))) {
@@ -894,6 +900,8 @@ const struct option record_options[] = {
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &record.evlist, "filter",
 		     "event filter", parse_filter),
+	OPT_STRING('I', "irq", &record.opts.target.pid, "irq",
+		    "record events on existing irq handler"),
 	OPT_STRING('p', "pid", &record.opts.target.pid, "pid",
 		    "record events on existing process id"),
 	OPT_STRING('t', "tid", &record.opts.target.tid, "tid",
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7e910ba..a173551a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -248,6 +248,12 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 
 	attr->inherit = !no_inherit;
 
+	if (perf_target__has_cpu(&target) && perf_target__has_task(&target)) {
+		evsel->irq = true;
+		return perf_evsel__open(evsel, perf_evsel__cpus(evsel),
+					evsel_list->threads);
+	}
+
 	if (perf_target__has_cpu(&target))
 		return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
 
@@ -1353,6 +1359,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
+	OPT_STRING('I', "irq", &target.pid, "irq",
+		   "stat events on existing irq handler"),
 	OPT_STRING('p', "pid", &target.pid, "pid",
 		   "stat events on existing process id"),
 	OPT_STRING('t', "tid", &target.tid, "tid",
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 99b43dd..4dcc155 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -588,7 +588,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (perf_target__has_task(target))
+	if (perf_target__has_task(target) && perf_target__has_cpu(target))
+		evlist->cpus = cpu_map__new(target->cpu_list);
+	else if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 63b6f8c..b2bfe5e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -833,6 +833,9 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		pid = evsel->cgrp->fd;
 	}
 
+	if (evsel->irq)
+		flags = PERF_FLAG_PID_IRQ;
+
 fallback_missing_features:
 	if (perf_missing_features.exclude_guest)
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3f156cc..418f5d5 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -73,6 +73,7 @@ struct perf_evsel {
 	unsigned int		sample_size;
 	bool 			supported;
 	bool 			needs_swap;
+	bool			irq;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 065528b..a4469db 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -20,12 +20,14 @@ enum perf_target_errno perf_target__validate(struct perf_target *target)
 	if (target->pid)
 		target->tid = target->pid;
 
+#if (0)
 	/* CPU and PID are mutually exclusive */
 	if (target->tid && target->cpu_list) {
 		target->cpu_list = NULL;
 		if (ret == PERF_ERRNO_TARGET__SUCCESS)
 			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_CPU;
 	}
+#endif
 
 	/* UID and PID are mutually exclusive */
 	if (target->tid && target->uid_str) {
@@ -41,12 +43,14 @@ enum perf_target_errno perf_target__validate(struct perf_target *target)
 			ret = PERF_ERRNO_TARGET__UID_OVERRIDE_CPU;
 	}
 
+#if (0)
 	/* PID and SYSTEM are mutually exclusive */
 	if (target->tid && target->system_wide) {
 		target->system_wide = false;
 		if (ret == PERF_ERRNO_TARGET__SUCCESS)
 			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM;
 	}
+#endif
 
 	/* UID and SYSTEM are mutually exclusive */
 	if (target->uid_str && target->system_wide) {
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 9b5f856..48cc8ec 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -159,8 +159,12 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 	struct thread_map *threads = NULL, *nt;
 	char name[256];
 	int items, total_tasks = 0;
+#if (0)
 	struct dirent **namelist = NULL;
 	int i, j = 0;
+#else
+	int j = 0;
+#endif
 	pid_t pid, prev_pid = INT_MAX;
 	char *end_ptr;
 	struct str_node *pos;
@@ -180,7 +184,11 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 			continue;
 
 		sprintf(name, "/proc/%d/task", pid);
+#if (0)
 		items = scandir(name, &namelist, filter, NULL);
+#else
+		items = 1;
+#endif
 		if (items <= 0)
 			goto out_free_threads;
 
@@ -192,12 +200,18 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 
 		threads = nt;
 
+#if (0)
 		for (i = 0; i < items; i++) {
 			threads->map[j++] = atoi(namelist[i]->d_name);
 			free(namelist[i]);
 		}
+#else
+		threads->map[j++] = pid;
+#endif
 		threads->nr = total_tasks;
+#if (0)
 		free(namelist);
+#endif
 	}
 
 out:
@@ -205,9 +219,11 @@ out:
 	return threads;
 
 out_free_namelist:
+#if (0)
 	for (i = 0; i < items; i++)
 		free(namelist[i]);
 	free(namelist);
+#endif
 
 out_free_threads:
 	free(threads);
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
