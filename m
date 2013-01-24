Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3AXUa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:30:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3AXUIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/74] perf evsel: Do missing feature fallbacks in just one place
Date: Thu, 24 Jan 2013 17:07:16 -0300
Message-Id: <1359058103-31645-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of doing it in stat, top, record or any other tool that opens
event descriptors.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vr8hzph83d5t2mdlkf565h84@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 36 ------------------------------------
 tools/perf/builtin-stat.c   | 30 +++---------------------------
 tools/perf/builtin-top.c    | 20 --------------------
 tools/perf/perf.h           |  2 --
 tools/perf/util/evsel.c     | 31 ++++++++++++++++++++++++++++---
 tools/perf/util/top.h       |  2 --
 6 files changed, 31 insertions(+), 90 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 028de72..a4b9726 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -234,25 +234,6 @@ static int perf_record__open(struct perf_record *rec)
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
-		/*
-		 * Check if parse_single_tracepoint_event has already asked for
-		 * PERF_SAMPLE_TIME.
-		 *
-		 * XXX this is kludgy but short term fix for problems introduced by
-		 * eac23d1c that broke 'perf script' by having different sample_types
-		 * when using multiple tracepoint events when we use a perf binary
-		 * that tries to use sample_id_all on an older kernel.
-		 *
-		 * We need to move counter creation to perf_session, support
-		 * different sample_types, etc.
-		 */
-		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
-
-fallback_missing_features:
-		if (opts->exclude_guest_missing)
-			attr->exclude_guest = attr->exclude_host = 0;
-retry_sample_id:
-		attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
 			int err = errno;
@@ -266,23 +247,6 @@ try_again:
 				       " an out-of-range profile CPU?\n");
 				rc = -err;
 				goto out;
-			} else if (err == EINVAL) {
-				if (!opts->exclude_guest_missing &&
-				    (attr->exclude_guest || attr->exclude_host)) {
-					pr_debug("Old kernel, cannot exclude "
-						 "guest or host samples.\n");
-					opts->exclude_guest_missing = true;
-					goto fallback_missing_features;
-				} else if (!opts->sample_id_all_missing) {
-					/*
-					 * Old kernel, no attr->sample_id_type_all field
-					 */
-					opts->sample_id_all_missing = true;
-					if (!opts->sample_time && !opts->raw_samples && !time_needed)
-						perf_evsel__reset_sample_bit(pos, TIME);
-
-					goto retry_sample_id;
-				}
 			}
 
 			/*
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c12655a..ef067c1 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -132,8 +132,6 @@ static struct stats walltime_nsecs_stats;
 static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
-	bool exclude_guest_missing = false;
-	int ret;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -141,16 +139,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 
 	attr->inherit = !no_inherit;
 
-retry:
-	if (exclude_guest_missing)
-		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
-
-	if (perf_target__has_cpu(&target)) {
-		ret = perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
-		if (ret)
-			goto check_ret;
-		return 0;
-	}
+	if (perf_target__has_cpu(&target))
+		return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
 
 	if (!perf_target__has_task(&target) &&
 	    perf_evsel__is_group_leader(evsel)) {
@@ -158,21 +148,7 @@ retry:
 		attr->enable_on_exec = 1;
 	}
 
-	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads);
-	if (!ret)
-		return 0;
-	/* fall through */
-check_ret:
-	if (ret && errno == EINVAL) {
-		if (!exclude_guest_missing &&
-		    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
-			pr_debug("Old kernel, cannot exclude "
-				 "guest or host samples.\n");
-			exclude_guest_missing = true;
-			goto retry;
-		}
-	}
-	return ret;
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads);
 }
 
 /*
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b7d2ea6..74fca61 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -900,12 +900,6 @@ static void perf_top__start_counters(struct perf_top *top)
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
-
-fallback_missing_features:
-		if (top->exclude_guest_missing)
-			attr->exclude_guest = attr->exclude_host = 0;
-retry_sample_id:
-		attr->sample_id_all = top->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
 				     top->evlist->threads) < 0) {
@@ -914,20 +908,6 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
-			} else if (err == EINVAL) {
-				if (!top->exclude_guest_missing &&
-				    (attr->exclude_guest || attr->exclude_host)) {
-					pr_debug("Old kernel, cannot exclude "
-						 "guest or host samples.\n");
-					top->exclude_guest_missing = true;
-					goto fallback_missing_features;
-				} else if (!top->sample_id_all_missing) {
-					/*
-					 * Old kernel, no attr->sample_id_type_all field
-					 */
-					top->sample_id_all_missing = true;
-					goto retry_sample_id;
-				}
 			}
 			/*
 			 * If it's cycles then fall back to hrtimer
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2c340e7..7622f15 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -237,8 +237,6 @@ struct perf_record_opts {
 	bool	     raw_samples;
 	bool	     sample_address;
 	bool	     sample_time;
-	bool	     sample_id_all_missing;
-	bool	     exclude_guest_missing;
 	bool	     period;
 	unsigned int freq;
 	unsigned int mmap_pages;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7a2a3dc..ee6ee3f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -22,6 +22,11 @@
 #include <linux/perf_event.h>
 #include "perf_regs.h"
 
+static struct {
+	bool sample_id_all;
+	bool exclude_guest;
+} perf_missing_features;
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
 static int __perf_evsel__sample_size(u64 sample_type)
@@ -463,7 +468,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
-	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
+	attr->sample_id_all = perf_missing_features.sample_id_all ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 
 	perf_evsel__set_sample_bit(evsel, IP);
@@ -513,7 +518,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->period)
 		perf_evsel__set_sample_bit(evsel, PERIOD);
 
-	if (!opts->sample_id_all_missing &&
+	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
 	     perf_target__has_cpu(&opts->target)))
 		perf_evsel__set_sample_bit(evsel, TIME);
@@ -761,6 +766,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		pid = evsel->cgrp->fd;
 	}
 
+fallback_missing_features:
+	if (perf_missing_features.exclude_guest)
+		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
+retry_sample_id:
+	if (perf_missing_features.sample_id_all)
+		evsel->attr.sample_id_all = 0;
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
 		for (thread = 0; thread < threads->nr; thread++) {
@@ -777,13 +789,26 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
-				goto out_close;
+				goto try_fallback;
 			}
 		}
 	}
 
 	return 0;
 
+try_fallback:
+	if (err != -EINVAL || cpu > 0 || thread > 0)
+		goto out_close;
+
+	if (!perf_missing_features.exclude_guest &&
+	    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+		perf_missing_features.exclude_guest = true;
+		goto fallback_missing_features;
+	} else if (!perf_missing_features.sample_id_all) {
+		perf_missing_features.sample_id_all = true;
+		goto retry_sample_id;
+	}
+
 out_close:
 	do {
 		while (--thread >= 0) {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 927c229..7ebf357 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -29,8 +29,6 @@ struct perf_top {
 	bool		   sort_has_symbols;
 	bool		   kptr_restrict_warned;
 	bool		   vmlinux_warned;
-	bool		   sample_id_all_missing;
-	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
-- 
1.8.1.1.361.gec3ae6e

