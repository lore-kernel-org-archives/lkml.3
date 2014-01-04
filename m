Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbaADSWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:22:42 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:18129 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755020AbaADSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:22:40 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: [PATCH RFC v2 4/4] perf/tool: IRQ-bound performance events
Date: Sat,  4 Jan 2014 19:22:36 +0100
Message-Id: <891b359bc77491c4de1692f580f2c70b87ba6ab3.1388858996.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1388858996.git.agordeev@redhat.com>
References: <cover.1388858996.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 tools/perf/builtin-stat.c      |    9 +++++++++
 tools/perf/util/evlist.c       |   38 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h       |    3 +++
 tools/perf/util/evsel.c        |    8 ++++++++
 tools/perf/util/evsel.h        |    3 +++
 tools/perf/util/parse-events.c |   24 ++++++++++++++++++++++++
 tools/perf/util/parse-events.h |    1 +
 7 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b27b264..48c9d90 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -292,6 +292,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	attr->inherit = !no_inherit;
+	attr->hardirq = 1;
 
 	if (target__has_cpu(&target))
 		return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
@@ -590,6 +591,12 @@ static int __run_perf_stat(int argc, const char **argv)
 		return -1;
 	}
 
+	if (perf_evlist__apply_hardirq(evsel_list)) {
+		error("failed to set hardirq with %d (%s)\n", errno,
+			strerror(errno));
+		return -1;
+	}
+
 	/*
 	 * Enable counters and exec the command:
 	 */
@@ -1613,6 +1620,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
+	OPT_CALLBACK('h', "hardirq", &evsel_list, "hardirq",
+		     "stat events on existing hardware IRQ", parse_hardirq),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_STRING('p', "pid", &target.pid, "pid",
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0810f5c..5104232 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -861,6 +861,27 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist)
 	return err;
 }
 
+int perf_evlist__apply_hardirq(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int err = 0;
+	const int ncpus = cpu_map__nr(evlist->cpus),
+		  nthreads = thread_map__nr(evlist->threads);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->hardirq == NULL)
+			continue;
+
+		err = perf_evsel__set_hardirq(evsel, ncpus, nthreads, evsel->hardirq);
+		if (err)
+			break;
+
+		evsel->attr.hardirq = 1;
+	}
+
+	return err;
+}
+
 int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 {
 	struct perf_evsel *evsel;
@@ -877,6 +898,23 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 	return err;
 }
 
+int perf_evlist__set_hardirq(struct perf_evlist *evlist,
+			     const struct perf_hardirq_event_disp *hardirq)
+{
+	struct perf_evsel *evsel;
+	int err = 0;
+	const int ncpus = cpu_map__nr(evlist->cpus),
+		  nthreads = thread_map__nr(evlist->threads);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		err = perf_evsel__set_hardirq(evsel, ncpus, nthreads, hardirq);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 518e521..12dc36d 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -71,6 +71,8 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler);
 
 int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
+int perf_evlist__set_hardirq(struct perf_evlist *evlist,
+			     const struct perf_hardirq_event_disp *hardirq);
 
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);
@@ -136,6 +138,7 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target);
 int perf_evlist__apply_filters(struct perf_evlist *evlist);
+int perf_evlist__apply_hardirq(struct perf_evlist *evlist);
 
 void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ade8d9c..23d52a3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -704,6 +704,14 @@ int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 				     (void *)filter);
 }
 
+int perf_evsel__set_hardirq(struct perf_evsel *evsel, int ncpus, int nthreads,
+			    const struct perf_hardirq_event_disp *disp)
+{
+	return perf_evsel__run_ioctl(evsel, ncpus, nthreads,
+				     PERF_EVENT_IOC_SET_HARDIRQ,
+				     (void *)disp);
+}
+
 int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	return perf_evsel__run_ioctl(evsel, ncpus, nthreads,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f1b3256..f07221b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -59,6 +59,7 @@ struct perf_evsel {
 	struct list_head	node;
 	struct perf_event_attr	attr;
 	char			*filter;
+	struct perf_hardirq_event_disp *hardirq;
 	struct xyarray		*fd;
 	struct xyarray		*sample_id;
 	u64			*id;
@@ -169,6 +170,8 @@ void perf_evsel__set_sample_id(struct perf_evsel *evsel,
 
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
+int perf_evsel__set_hardirq(struct perf_evsel *evsel, int ncpus, int nthreads,
+			    const struct perf_hardirq_event_disp *hardirq);
 int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0153435..7a5114d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -987,6 +987,30 @@ int parse_filter(const struct option *opt, const char *str,
 	return 0;
 }
 
+int parse_hardirq(const struct option *opt, const char *str,
+		  int unset __maybe_unused)
+{
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	struct perf_evsel *evsel;
+	struct perf_hardirq_event_disp *event_disp;
+
+	event_disp = malloc(offsetof(typeof(*event_disp), disp) +
+			    sizeof(event_disp->disp[0]));
+	if (!event_disp) {
+		fprintf(stderr, "not enough memory to hold hardirq disp\n");
+		return -1;
+	}
+
+	event_disp->nr_disp		= 1;
+	event_disp->disp[0].irq_nr	= atoi(str);
+	event_disp->disp[0].actions	= -1;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		evsel->hardirq = event_disp;
+
+	return 0;
+}
+
 static const char * const event_type_descriptors[] = {
 	"Hardware event",
 	"Software event",
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..a6927d6 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,6 +33,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
 extern int parse_events(struct perf_evlist *evlist, const char *str);
 extern int parse_events_terms(struct list_head *terms, const char *str);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
+extern int parse_hardirq(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-- 
1.7.7.6

