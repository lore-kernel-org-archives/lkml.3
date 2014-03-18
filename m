Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaCRIa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:30:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaCRIaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:30:24 -0400
Date: Tue, 18 Mar 2014 01:29:51 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4a62109fe94f68a57b239c1516f97497a4d15c14@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1393809254-4480-3-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk: Reuse generic __hpp__fmt() code
Git-Commit-ID: 4a62109fe94f68a57b239c1516f97497a4d15c14
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

Commit-ID:  4a62109fe94f68a57b239c1516f97497a4d15c14
Gitweb:     http://git.kernel.org/tip/4a62109fe94f68a57b239c1516f97497a4d15c14
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 10:14:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:38 -0300

perf ui/gtk: Reuse generic __hpp__fmt() code

The __hpp__color_fmt used in the gtk code can be replace by the generic
code with small change in print_fn callback.

This is a preparation to upcoming changes and no functional changes
intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393809254-4480-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 73 +++++++----------------------------------------
 tools/perf/ui/hist.c      |  9 ++----
 tools/perf/util/hist.h    |  6 ++++
 3 files changed, 19 insertions(+), 69 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 5b95c44..3dab00e 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,16 +8,22 @@
 
 #define MAX_COLUMNS			32
 
-static int __percent_color_snprintf(char *buf, size_t size, double percent)
+static int __percent_color_snprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	int ret = 0;
+	va_list args;
+	double percent;
 	const char *markup;
 
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	va_end(args);
+
 	markup = perf_gtk__get_percent_color(percent);
 	if (markup)
 		ret += scnprintf(buf, size, markup);
 
-	ret += scnprintf(buf + ret, size - ret, " %6.2f%%", percent);
+	ret += scnprintf(buf + ret, size - ret, fmt, percent);
 
 	if (markup)
 		ret += scnprintf(buf + ret, size - ret, "</span>");
@@ -25,66 +31,6 @@ static int __percent_color_snprintf(char *buf, size_t size, double percent)
 	return ret;
 }
 
-
-static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			    u64 (*get_field)(struct hist_entry *))
-{
-	int ret;
-	double percent = 0.0;
-	struct hists *hists = he->hists;
-	struct perf_evsel *evsel = hists_to_evsel(hists);
-
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
-
-	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
-
-	if (perf_evsel__is_group_event(evsel)) {
-		int prev_idx, idx_delta;
-		struct hist_entry *pair;
-		int nr_members = evsel->nr_members;
-
-		prev_idx = perf_evsel__group_idx(evsel);
-
-		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
-			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
-
-			evsel = hists_to_evsel(pair->hists);
-			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
-
-			while (idx_delta--) {
-				/*
-				 * zero-fill group members in the middle which
-				 * have no sample
-				 */
-				ret += __percent_color_snprintf(hpp->buf + ret,
-								hpp->size - ret,
-								0.0);
-			}
-
-			percent = 100.0 * period / total;
-			ret += __percent_color_snprintf(hpp->buf + ret,
-							hpp->size - ret,
-							percent);
-
-			prev_idx = perf_evsel__group_idx(evsel);
-		}
-
-		idx_delta = nr_members - prev_idx - 1;
-
-		while (idx_delta--) {
-			/*
-			 * zero-fill group members at last which have no sample
-			 */
-			ret += __percent_color_snprintf(hpp->buf + ret,
-							hpp->size - ret,
-							0.0);
-		}
-	}
-	return ret;
-}
-
 #define __HPP_COLOR_PERCENT_FN(_type, _field)					\
 static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
@@ -95,7 +41,8 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+			  __percent_color_snprintf, true);			\
 }
 
 __HPP_COLOR_PERCENT_FN(overhead, period)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 6094562..0853534 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,12 +8,9 @@
 
 /* hist period print (hpp) functions */
 
-typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
-
-static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-		      u64 (*get_field)(struct hist_entry *),
-		      const char *fmt, hpp_snprint_fn print_fn,
-		      bool fmt_percent)
+int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+	       u64 (*get_field)(struct hist_entry *),
+	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	int ret;
 	struct hists *hists = he->hists;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a59743f..97f924e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -166,6 +166,12 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
+typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
+
+int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+	       u64 (*get_field)(struct hist_entry *),
+	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
+
 static inline size_t perf_hpp__use_color(void)
 {
 	return !symbol_conf.field_sep;
