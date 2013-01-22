Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3AVJKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:10:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42753 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3AVJKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:10:40 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-82-50fe578801d9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 08/19] perf gtk/browser: Convert hpp helpers to a function
Date: Tue, 22 Jan 2013 18:09:36 +0900
Message-Id: <1358845787-1350-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The hpp helpers do same job for each field so it was implemented as
macro in order to access those fields easily.  But it gets cumbersome
to maintain a large function in a macro as the function grows. Factor
it out to a function with a little helper macro to access field.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 68 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index c03da79d524f..38be79d4b5c6 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,32 +8,58 @@
 
 #define MAX_COLUMNS			32
 
-#define HPP__COLOR_FN(_name, _field)						\
-static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
-					 struct hist_entry *he)			\
+static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
+					    double percent)
+{
+	int ret = 0;
+	const char *markup;
+
+	markup = perf_gtk__get_percent_color(percent);
+	if (markup)
+		ret += scnprintf(buf, size, markup);
+
+	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
+
+	if (markup)
+		ret += scnprintf(buf + ret, size - ret, "</span>");
+
+	return ret;
+}
+
+
+static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			    u64 (*get_field)(struct hist_entry *))
+{
+	int ret;
+	double percent = 0.0;
+	struct hists *hists = he->hists;
+
+	if (hists->stats.total_period)
+		percent = 100.0 * get_field(he) / hists->stats.total_period;
+
+	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, percent);
+	return ret;
+}
+
+#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
+static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
-	struct hists *hists = he->hists;					\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
-	const char *markup;							\
-	int ret = 0;								\
-										\
-	markup = perf_gtk__get_percent_color(percent);				\
-	if (markup)								\
-		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
-	if (markup)								\
-		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
+	return he->stat._field;							\
+}										\
 										\
-	return ret;								\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp *hpp,			\
+				       struct hist_entry *he)			\
+{										\
+	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
 }
 
-HPP__COLOR_FN(overhead, period)
-HPP__COLOR_FN(overhead_sys, period_sys)
-HPP__COLOR_FN(overhead_us, period_us)
-HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
-HPP__COLOR_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_PERCENT_FN(overhead, period)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
-#undef HPP__COLOR_FN
+#undef __HPP_COLOR_PERCENT_FN
 
 
 void perf_gtk__init_hpp(void)
-- 
1.7.11.7

