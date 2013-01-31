Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3AaRZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:25:41 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60076
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab3AaRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/25] perf hists browser: Convert hpp helpers to a function
Date: Thu, 31 Jan 2013 14:25:12 -0300
Message-Id: <1359653128-10433-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The hpp helpers do same job for each field so it was implemented as
macro in order to access those fields easily.  But it gets cumbersome
to maintain a large function in a macro as the function grows. Factor
it out to a function with a little helper macro to access field.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 46 +++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 57b82c2..46242de 100644
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
1.8.1.1.361.gec3ae6e

