Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaCRIao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:30:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaCRIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:30:38 -0400
Date: Tue, 18 Mar 2014 01:30:14 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2f6d9009af1df0f7cba1fdfe012a089babd8c747@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1393809254-4480-5-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/tui: Reuse generic __hpp__fmt() code
Git-Commit-ID: 2f6d9009af1df0f7cba1fdfe012a089babd8c747
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

Commit-ID:  2f6d9009af1df0f7cba1fdfe012a089babd8c747
Gitweb:     http://git.kernel.org/tip/2f6d9009af1df0f7cba1fdfe012a089babd8c747
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 10:14:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:39 -0300

perf ui/tui: Reuse generic __hpp__fmt() code

The __hpp__color_fmt used in the TUI code can be replace by the generic
code with small change in print_fn callback.  And it also needs to move
callback function to the generic __hpp__fmt().

No functional changes intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393809254-4480-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 122 ++++++++++++++---------------------------
 tools/perf/ui/gtk/hists.c      |   2 +-
 tools/perf/ui/hist.c           |  26 ++++++---
 tools/perf/util/hist.h         |   4 +-
 4 files changed, 63 insertions(+), 91 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b720b92..7ec871a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -587,95 +587,52 @@ struct hpp_arg {
 	bool current_entry;
 };
 
-static int __hpp__color_callchain(struct hpp_arg *arg)
+static int __hpp__overhead_callback(struct perf_hpp *hpp, bool front)
 {
-	if (!symbol_conf.use_callchain)
-		return 0;
-
-	slsmg_printf("%c ", arg->folded_sign);
-	return 2;
-}
-
-static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			    u64 (*get_field)(struct hist_entry *),
-			    int (*callchain_cb)(struct hpp_arg *))
-{
-	int ret = 0;
-	double percent = 0.0;
-	struct hists *hists = he->hists;
 	struct hpp_arg *arg = hpp->ptr;
 
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
-
-	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
-
-	if (callchain_cb)
-		ret += callchain_cb(arg);
-
-	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-	slsmg_printf("%s", hpp->buf);
-
-	if (symbol_conf.event_group) {
-		int prev_idx, idx_delta;
-		struct perf_evsel *evsel = hists_to_evsel(hists);
-		struct hist_entry *pair;
-		int nr_members = evsel->nr_members;
-
-		if (nr_members <= 1)
-			goto out;
+	if (arg->current_entry && arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_SELECTED);
+	else
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
 
-		prev_idx = perf_evsel__group_idx(evsel);
+	if (front) {
+		if (!symbol_conf.use_callchain)
+			return 0;
 
-		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
-			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+		slsmg_printf("%c ", arg->folded_sign);
+		return 2;
+	}
 
-			if (!total)
-				continue;
+	return 0;
+}
 
-			evsel = hists_to_evsel(pair->hists);
-			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+static int __hpp__color_callback(struct perf_hpp *hpp, bool front __maybe_unused)
+{
+	struct hpp_arg *arg = hpp->ptr;
 
-			while (idx_delta--) {
-				/*
-				 * zero-fill group members in the middle which
-				 * have no sample
-				 */
-				ui_browser__set_percent_color(arg->b, 0.0,
-							arg->current_entry);
-				ret += scnprintf(hpp->buf, hpp->size,
-						 " %6.2f%%", 0.0);
-				slsmg_printf("%s", hpp->buf);
-			}
+	if (!arg->current_entry || !arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+	return 0;
+}
 
-			percent = 100.0 * period / total;
-			ui_browser__set_percent_color(arg->b, percent,
-						      arg->current_entry);
-			ret += scnprintf(hpp->buf, hpp->size,
-					 " %6.2f%%", percent);
-			slsmg_printf("%s", hpp->buf);
+static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
+{
+	struct hpp_arg *arg = hpp->ptr;
+	int ret;
+	va_list args;
+	double percent;
 
-			prev_idx = perf_evsel__group_idx(evsel);
-		}
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	va_end(args);
 
-		idx_delta = nr_members - prev_idx - 1;
+	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
 
-		while (idx_delta--) {
-			/*
-			 * zero-fill group members at last which have no sample
-			 */
-			ui_browser__set_percent_color(arg->b, 0.0,
-						      arg->current_entry);
-			ret += scnprintf(hpp->buf, hpp->size,
-					 " %6.2f%%", 0.0);
-			slsmg_printf("%s", hpp->buf);
-		}
-	}
-out:
-	if (!arg->current_entry || !arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);
+	slsmg_printf("%s", hpp->buf);
 
+	advance_hpp(hpp, ret);
 	return ret;
 }
 
@@ -690,14 +647,15 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
-	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, _cb);	\
+	return __hpp__fmt(hpp, he, __hpp_get_##_field, _cb, " %6.2f%%",	\
+			  __hpp__slsmg_color_printf, true);		\
 }
 
-__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__color_callchain)
-__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, NULL)
-__HPP_COLOR_PERCENT_FN(overhead_us, period_us, NULL)
-__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, NULL)
-__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, NULL)
+__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__overhead_callback)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, __hpp__color_callback)
 
 #undef __HPP_COLOR_PERCENT_FN
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 430fd55..7912dab 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -43,7 +43,7 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
 			  __percent_color_snprintf, true);			\
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0c427e5..ac39313 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -16,15 +16,20 @@
 })
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       u64 (*get_field)(struct hist_entry *),
+	       hpp_field_fn get_field, hpp_callback_fn callback,
 	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
 {
-	int ret;
+	int ret = 0;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
 	char *buf = hpp->buf;
 	size_t size = hpp->size;
 
+	if (callback) {
+		ret = callback(hpp, true);
+		advance_hpp(hpp, ret);
+	}
+
 	if (fmt_percent) {
 		double percent = 0.0;
 
@@ -32,9 +37,9 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			percent = 100.0 * get_field(he) /
 				  hists->stats.total_period;
 
-		ret = hpp__call_print_fn(hpp, print_fn, fmt, percent);
+		ret += hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
-		ret = hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
+		ret += hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -94,6 +99,13 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		}
 	}
 
+	if (callback) {
+		int __ret = callback(hpp, false);
+
+		advance_hpp(hpp, __ret);
+		ret += __ret;
+	}
+
 	/*
 	 * Restore original buf and size as it's where caller expects
 	 * the result will be saved.
@@ -169,7 +181,7 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
 			  hpp_color_scnprintf, true);				\
 }
 
@@ -178,7 +190,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
+	return __hpp__fmt(hpp, he, he_get_##_field, NULL, fmt,			\
 			  hpp_entry_scnprintf, true);				\
 }
 
@@ -192,7 +204,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt,			\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, NULL, fmt,		\
 			  hpp_entry_scnprintf, false);				\
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d51ed98..9e1cada 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -166,10 +166,12 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
+typedef u64 (*hpp_field_fn)(struct hist_entry *he);
+typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
 typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       u64 (*get_field)(struct hist_entry *),
+	       hpp_field_fn get_field, hpp_callback_fn callback,
 	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
