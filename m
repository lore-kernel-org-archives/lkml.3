Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaCNViQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:38:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54059 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbaCNVae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/16] perf ui/hists: Pass struct hpp to print functions
Date: Fri, 14 Mar 2014 18:30:03 -0300
Message-Id: <1394832610-17818-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Instead of the pointer to buffer and its size so that it can also get
private argument passed along with hpp.

This is a preparation of further change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393809254-4480-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c  |  4 ++-
 tools/perf/ui/hist.c       | 87 +++++++++++++++++++++++++++++++++++-----------
 tools/perf/ui/stdio/hist.c |  6 ----
 tools/perf/util/hist.h     |  8 ++++-
 4 files changed, 76 insertions(+), 29 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 3dab00e748f2..430fd555b161 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,12 +8,14 @@
 
 #define MAX_COLUMNS			32
 
-static int __percent_color_snprintf(char *buf, size_t size, const char *fmt, ...)
+static int __percent_color_snprintf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	int ret = 0;
 	va_list args;
 	double percent;
 	const char *markup;
+	char *buf = hpp->buf;
+	size_t size = hpp->size;
 
 	va_start(args, fmt);
 	percent = va_arg(args, double);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 085353435f07..0c427e5d37c7 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,6 +8,13 @@
 
 /* hist period print (hpp) functions */
 
+#define hpp__call_print_fn(hpp, fn, fmt, ...)			\
+({								\
+	int __ret = fn(hpp, fmt, ##__VA_ARGS__);		\
+	advance_hpp(hpp, __ret);				\
+	__ret;							\
+})
+
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	       u64 (*get_field)(struct hist_entry *),
 	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
@@ -15,6 +22,8 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	int ret;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	char *buf = hpp->buf;
+	size_t size = hpp->size;
 
 	if (fmt_percent) {
 		double percent = 0.0;
@@ -23,9 +32,9 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			percent = 100.0 * get_field(he) /
 				  hists->stats.total_period;
 
-		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
-		ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -50,22 +59,21 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 * have no sample
 				 */
 				if (fmt_percent) {
-					ret += print_fn(hpp->buf + ret,
-							hpp->size - ret,
-							fmt, 0.0);
+					ret += hpp__call_print_fn(hpp, print_fn,
+								  fmt, 0.0);
 				} else {
-					ret += print_fn(hpp->buf + ret,
-							hpp->size - ret,
-							fmt, 0ULL);
+					ret += hpp__call_print_fn(hpp, print_fn,
+								  fmt, 0ULL);
 				}
 			}
 
-			if (fmt_percent)
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 100.0 * period / total);
-			else
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, period);
+			if (fmt_percent) {
+				ret += hpp__call_print_fn(hpp, print_fn, fmt,
+							  100.0 * period / total);
+			} else {
+				ret += hpp__call_print_fn(hpp, print_fn, fmt,
+							  period);
+			}
 
 			prev_idx = perf_evsel__group_idx(evsel);
 		}
@@ -77,14 +85,22 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			 * zero-fill group members at last which have no sample
 			 */
 			if (fmt_percent) {
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 0.0);
+				ret += hpp__call_print_fn(hpp, print_fn,
+							  fmt, 0.0);
 			} else {
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 0ULL);
+				ret += hpp__call_print_fn(hpp, print_fn,
+							  fmt, 0ULL);
 			}
 		}
 	}
+
+	/*
+	 * Restore original buf and size as it's where caller expects
+	 * the result will be saved.
+	 */
+	hpp->buf = buf;
+	hpp->size = size;
+
 	return ret;
 }
 
@@ -116,6 +132,34 @@ static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
 	return len;							\
 }
 
+static int hpp_color_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
+{
+	va_list args;
+	ssize_t ssize = hpp->size;
+	double percent;
+	int ret;
+
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	ret = value_color_snprintf(hpp->buf, hpp->size, fmt, percent);
+	va_end(args);
+
+	return (ret >= ssize) ? (ssize - 1) : ret;
+}
+
+static int hpp_entry_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
+{
+	va_list args;
+	ssize_t ssize = hpp->size;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vsnprintf(hpp->buf, hpp->size, fmt, args);
+	va_end(args);
+
+	return (ret >= ssize) ? (ssize - 1) : ret;
+}
+
 #define __HPP_COLOR_PERCENT_FN(_type, _field)					\
 static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
@@ -126,7 +170,7 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
-			  percent_color_snprintf, true);			\
+			  hpp_color_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
@@ -135,7 +179,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
 	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
-			  scnprintf, true);					\
+			  hpp_entry_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
@@ -148,7 +192,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf, false);	\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt,			\
+			  hpp_entry_scnprintf, false);				\
 }
 
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 831fbb77d1ff..9bad89228472 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -306,12 +306,6 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
-static inline void advance_hpp(struct perf_hpp *hpp, int inc)
-{
-	hpp->buf  += inc;
-	hpp->size -= inc;
-}
-
 static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 				       struct hist_entry *he)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 97f924ec6af9..d51ed9898229 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -166,12 +166,18 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
-typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
+typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	       u64 (*get_field)(struct hist_entry *),
 	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
 
+static inline void advance_hpp(struct perf_hpp *hpp, int inc)
+{
+	hpp->buf  += inc;
+	hpp->size -= inc;
+}
+
 static inline size_t perf_hpp__use_color(void)
 {
 	return !symbol_conf.field_sep;
-- 
1.8.1.4

