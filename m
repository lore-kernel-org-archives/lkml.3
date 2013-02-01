Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249Ab3BALDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:03:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222Ab3BAKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:44:19 -0500
Date: Fri, 1 Feb 2013 02:43:59 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4fb71074a570aab9ba8a30b7a756a3c637a14c03@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-7-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/hist: Consolidate hpp helpers
Git-Commit-ID: 4fb71074a570aab9ba8a30b7a756a3c637a14c03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:44:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fb71074a570aab9ba8a30b7a756a3c637a14c03
Gitweb:     http://git.kernel.org/tip/4fb71074a570aab9ba8a30b7a756a3c637a14c03
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:34 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:45 -0300

perf ui/hist: Consolidate hpp helpers

Most of hpp helper functions do same jobs for different fields thus
consolidate them to appropriate functions/macros.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c | 238 ++++++++++++++++++---------------------------------
 1 file changed, 84 insertions(+), 154 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 1889c12..849c400 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -3,151 +3,107 @@
 #include "../util/hist.h"
 #include "../util/util.h"
 #include "../util/sort.h"
-
+#include "../util/evsel.h"
 
 /* hist period print (hpp) functions */
-static int hpp__header_overhead(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "Overhead");
-}
-
-static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
-{
-	return 8;
-}
-
-static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
-}
-
-static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_sys(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
-}
-
-static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
-}
-
-static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-}
+typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
 
-static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
+static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			      u64 (*get_field)(struct hist_entry *),
+			      const char *fmt, hpp_snprint_fn print_fn)
 {
+	int ret;
+	double percent = 0.0;
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_us(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, "user");
-}
+	if (hists->stats.total_period)
+		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
-static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
+	ret = print_fn(hpp->buf, hpp->size, fmt, percent);
+	return ret;
 }
 
-static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
+static int __hpp__raw_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			  u64 (*get_field)(struct hist_entry *),
+			  const char *fmt, hpp_snprint_fn print_fn)
 {
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
+	int ret;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+	ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
+	return ret;
 }
 
-static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+#define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
+static int hpp__header_##_type(struct perf_hpp *hpp)			\
+{									\
+	int len = _min_width;						\
+									\
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
 }
 
-static int hpp__header_overhead_guest_sys(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "guest sys");
+#define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
+static int hpp__width_##_type(struct perf_hpp *hpp __maybe_unused)	\
+{									\
+	int len = _min_width;						\
+									\
+	return len;							\
 }
 
-static int hpp__width_overhead_guest_sys(struct perf_hpp *hpp __maybe_unused)
-{
-	return 9;
+#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
+static u64 he_get_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat._field;							\
+}										\
+										\
+static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	return __hpp__percent_fmt(hpp, he, he_get_##_field, " %6.2f%%",		\
+				  (hpp_snprint_fn)percent_color_snprintf); 	\
 }
 
-static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
-					 struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
+#define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
+static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
+	return __hpp__percent_fmt(hpp, he, he_get_##_field, fmt,		\
+				  scnprintf);					\
 }
 
-static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
-					 struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+#define __HPP_ENTRY_RAW_FN(_type, _field)					\
+static u64 he_get_raw_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat._field;							\
+}										\
+										\
+static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
+	return __hpp__raw_fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf);	\
 }
 
-static int hpp__header_overhead_guest_us(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "guest usr");
-}
+#define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_COLOR_PERCENT_FN(_type, _field)					\
+__HPP_ENTRY_PERCENT_FN(_type, _field)
 
-static int hpp__width_overhead_guest_us(struct perf_hpp *hpp __maybe_unused)
-{
-	return 9;
-}
+#define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_ENTRY_RAW_FN(_type, _field)
 
-static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
-					struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
-}
+HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
+HPP_PERCENT_FNS(overhead_sys, "sys", period_sys, 8, 8)
+HPP_PERCENT_FNS(overhead_us, "usr", period_us, 8, 8)
+HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys, 9, 8)
+HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
 
-static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
-					struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
+HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
+HPP_RAW_FNS(period, "Period", period, 12, 12)
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
 
 static int hpp__header_baseline(struct perf_hpp *hpp)
 {
@@ -179,7 +135,7 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
-	if (hist_entry__has_pairs(he))
+	if (hist_entry__has_pairs(he) || symbol_conf.field_sep)
 		return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 	else
 		return scnprintf(hpp->buf, hpp->size, "        ");
@@ -196,44 +152,6 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
-static int hpp__header_samples(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Samples");
-}
-
-static int hpp__width_samples(struct perf_hpp *hpp __maybe_unused)
-{
-	return 11;
-}
-
-static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
-
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
-}
-
-static int hpp__header_period(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Period");
-}
-
-static int hpp__width_period(struct perf_hpp *hpp __maybe_unused)
-{
-	return 12;
-}
-
-static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
-
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
-}
-
 static int hpp__header_period_baseline(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
@@ -254,6 +172,7 @@ static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *h
 
 	return scnprintf(hpp->buf, hpp->size, fmt, period);
 }
+
 static int hpp__header_delta(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
@@ -408,9 +327,20 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 
 LIST_HEAD(perf_hpp__list);
 
+
 #undef HPP__COLOR_PRINT_FNS
 #undef HPP__PRINT_FNS
 
+#undef HPP_PERCENT_FNS
+#undef HPP_RAW_FNS
+
+#undef __HPP_HEADER_FN
+#undef __HPP_WIDTH_FN
+#undef __HPP_COLOR_PERCENT_FN
+#undef __HPP_ENTRY_PERCENT_FN
+#undef __HPP_ENTRY_RAW_FN
+
+
 void perf_hpp__init(void)
 {
 	if (symbol_conf.show_cpu_utilization) {
