Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3LCJAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:00:41 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57245 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3LCJAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:00:36 -0500
X-AuditID: 9c930197-b7c3dae000002c11-dd-529d9daf4a24
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 3/3] perf report: Add --event-time option
Date: Tue,  3 Dec 2013 18:00:29 +0900
Message-Id: <1386061229-19514-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386061229-19514-1-git-send-email-namhyung@kernel.org>
References: <1386061229-19514-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --event-time option is for displaying elapsed sampling time
information for each entry.

  $ perf record -- perf bench sched messaging
  $ perf report --stdio --event-time
  ...
  # Samples: 10K of event 'cycles'
  # Event count (approx.): 5118793536
  # Total sampling time  : 0.184277 (sec)
  #
  # Overhead        Time          Command      Shared Object                       Symbol
  # ........  ..........  ...............  .................  ...........................
  #
       7.26%    0.007413  sched-messaging  [unknown]          [.] 0x0000003153e7a6e7
       4.79%    0.006088  sched-messaging  [kernel.kallsyms]  [k] avc_has_perm_flags
       4.38%    0.004809  sched-messaging  [kernel.kallsyms]  [k] copy_user_generic_string
       3.81%    0.005457  sched-messaging  [kernel.kallsyms]  [k] _raw_spin_lock
       2.92%    0.002745  sched-messaging  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
       2.72%    0.002896  sched-messaging  [kernel.kallsyms]  [k] unix_stream_recvmsg
       2.55%    0.003745  sched-messaging  [kernel.kallsyms]  [k] __slab_free
       2.45%    0.002807  sched-messaging  [kernel.kallsyms]  [k] page_fault
       2.08%    0.002258  sched-messaging  [kernel.kallsyms]  [k] sock_has_perm

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  6 +++
 tools/perf/builtin-report.c              |  2 +
 tools/perf/ui/hist.c                     | 68 ++++++++++++++++++++++++++------
 tools/perf/util/hist.h                   |  1 +
 tools/perf/util/symbol.h                 |  3 +-
 5 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a279871251..f420eef2b77f 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -237,6 +237,12 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--event-time::
+	Show a column with elapsed sample times.  It could be useful when you
+	want to see a relation between time and period of samples.  The elapsed
+	time is a sum of time-diff between two adjacent samples of a event as
+	sample period is a diff of counter values between the two samples.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index eb849e9f7093..c4e958bc96a7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -898,6 +898,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_BOOLEAN(0, "event-time", &symbol_conf.show_event_time,
+		    "Show a column with the elapsed time"),
 	OPT_END()
 	};
 	struct perf_data_file file = {
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 78f4c92e9b73..2f075f447599 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -7,19 +7,24 @@
 #include "../util/evsel.h"
 
 /* hist period print (hpp) functions */
+enum hpp_fmt_type {
+	HPP_FMT__PERCENT,
+	HPP_FMT__RAW,
+	HPP_FMT__TIME,
+};
 
 typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
 
 static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		      u64 (*get_field)(struct hist_entry *),
 		      const char *fmt, hpp_snprint_fn print_fn,
-		      bool fmt_percent)
+		      enum hpp_fmt_type type)
 {
 	int ret;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
 
-	if (fmt_percent) {
+	if (type == HPP_FMT__PERCENT) {
 		double percent = 0.0;
 
 		if (hists->stats.total_period)
@@ -27,8 +32,15 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				  hists->stats.total_period;
 
 		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
-	} else
+	} else if (type == HPP_FMT__RAW) {
 		ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
+	} else if (type == HPP_FMT__TIME) {
+		u64 time = get_field(he);
+		u64 sec = time / NSEC_PER_SEC;
+		u64 usec = (time - sec * NSEC_PER_SEC) / NSEC_PER_USEC;
+
+		ret = print_fn(hpp->buf, hpp->size, fmt, sec, usec);
+	}
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -53,15 +65,22 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 * have no sample
 				 */
 				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 0);
+						fmt, 0, 0);
 			}
 
-			if (fmt_percent)
+			if (type == HPP_FMT__PERCENT)
 				ret += print_fn(hpp->buf + ret, hpp->size - ret,
 						fmt, 100.0 * period / total);
-			else
+			else if (type == HPP_FMT__RAW)
 				ret += print_fn(hpp->buf + ret, hpp->size - ret,
 						fmt, period);
+			else if (type == HPP_FMT__TIME) {
+				u64 sec = period / NSEC_PER_SEC;
+				u64 usec = (period - sec * NSEC_PER_SEC) / NSEC_PER_USEC;
+
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, sec, usec);
+			}
 
 			prev_idx = perf_evsel__group_idx(evsel);
 		}
@@ -73,7 +92,7 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			 * zero-fill group members at last which have no sample
 			 */
 			ret += print_fn(hpp->buf + ret, hpp->size - ret,
-					fmt, 0);
+					fmt, 0, 0);
 		}
 	}
 	return ret;
@@ -117,7 +136,7 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
-			  percent_color_snprintf, true);			\
+			  percent_color_snprintf, HPP_FMT__PERCENT);		\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
@@ -126,7 +145,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
 	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
-			  scnprintf, true);					\
+			  scnprintf, HPP_FMT__PERCENT);				\
 }
 
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
@@ -139,7 +158,23 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf, false);	\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf,		\
+			  HPP_FMT__RAW);					\
+}
+
+#define __HPP_ENTRY_TIME_FN(_type, _field)					\
+static u64 he_get_raw_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat._field;							\
+}										\
+										\
+static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 ".%06"PRIu64 : 	\
+						  " %2"PRIu64 ".%06"PRIu64;	\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf,		\
+			  HPP_FMT__TIME);					\
 }
 
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
@@ -153,6 +188,11 @@ __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
 __HPP_ENTRY_RAW_FN(_type, _field)
 
+#define HPP_TIME_FNS(_type, _str, _field, _min_width, _unit_width)	\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_ENTRY_TIME_FN(_type, _field)
+
 
 HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
 HPP_PERCENT_FNS(overhead_sys, "sys", period_sys, 8, 8)
@@ -163,6 +203,8 @@ HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
 HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
 HPP_RAW_FNS(period, "Period", period, 12, 12)
 
+HPP_TIME_FNS(time, "Time", time, 10, 10)
+
 #define HPP__COLOR_PRINT_FNS(_name)			\
 	{						\
 		.header	= hpp__header_ ## _name,	\
@@ -185,7 +227,8 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	HPP__COLOR_PRINT_FNS(overhead_guest_sys),
 	HPP__COLOR_PRINT_FNS(overhead_guest_us),
 	HPP__PRINT_FNS(samples),
-	HPP__PRINT_FNS(period)
+	HPP__PRINT_FNS(period),
+	HPP__PRINT_FNS(time)
 };
 
 LIST_HEAD(perf_hpp__list);
@@ -223,6 +266,9 @@ void perf_hpp__init(void)
 
 	if (symbol_conf.show_total_period)
 		perf_hpp__column_enable(PERF_HPP__PERIOD);
+
+	if (symbol_conf.show_event_time)
+		perf_hpp__column_enable(PERF_HPP__TIME);
 }
 
 void perf_hpp__column_register(struct perf_hpp_fmt *format)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0433469812dc..17e89fb31db9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -162,6 +162,7 @@ enum {
 	PERF_HPP__OVERHEAD_GUEST_US,
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
+	PERF_HPP__TIME,
 
 	PERF_HPP__MAX_INDEX
 };
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f1031a1358a1..599892b75cbc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -99,7 +99,8 @@ struct symbol_conf {
 			annotate_asm_raw,
 			annotate_src,
 			event_group,
-			demangle;
+			demangle,
+			show_event_time;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

