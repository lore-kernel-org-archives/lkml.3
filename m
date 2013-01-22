Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3AVJRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:17:10 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42753 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3AVJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:10:34 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-72-50fe57841b26
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/19] perf hist browser: Convert hpp helpers to a function
Date: Tue, 22 Jan 2013 18:09:35 +0900
Message-Id: <1358845787-1350-8-git-send-email-namhyung@kernel.org>
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
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 46 +++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 57b82c26cd05..46242deee8d2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -567,23 +567,41 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
-#define HPP__COLOR_FN(_name, _field)					\
-static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
-					     struct hist_entry *he)	\
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
+	*(double *)hpp->ptr = percent;
+
+	ret = scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+	return ret;
+}
+
+#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
+static u64 __hpp_get_##_field(struct hist_entry *he)			\
+{									\
+	return he->stat._field;						\
+}									\
+									\
+static int hist_browser__hpp_color_##_type(struct perf_hpp *hpp,	\
+					   struct hist_entry *he)	\
 {									\
-	struct hists *hists = he->hists;				\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
-	*(double *)hpp->ptr = percent;					\
-	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
+	return __hpp__color_fmt(hpp, he, __hpp_get_##_field);		\
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
 
 void hist_browser__init_hpp(void)
 {
@@ -646,7 +664,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 			if (fmt->color) {
 				hpp.ptr = &percent;
-				/* It will set percent for us. See HPP__COLOR_FN above. */
+				/* It will set percent for us. See __hpp__color_fmt above. */
 				width -= fmt->color(&hpp, entry);
 
 				ui_browser__set_percent_color(&browser->b, percent, current_entry);
-- 
1.7.11.7

