Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030216Ab3BAKpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:45:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3BAKp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:45:29 -0500
Date: Fri, 1 Feb 2013 02:45:10 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-5aed9d24934be5b7fec1b66cc2a5f29fab4ec11e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-8-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Convert hpp helpers to a function
Git-Commit-ID: 5aed9d24934be5b7fec1b66cc2a5f29fab4ec11e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:45:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5aed9d24934be5b7fec1b66cc2a5f29fab4ec11e
Gitweb:     http://git.kernel.org/tip/5aed9d24934be5b7fec1b66cc2a5f29fab4ec11e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:35 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:46 -0300

perf hists browser: Convert hpp helpers to a function

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
