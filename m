Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3BAKrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:47:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161009Ab3BAKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:46:43 -0500
Date: Fri, 1 Feb 2013 02:46:20 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-843985e953ddcc3d57a62641b377c8d3222859e2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-9-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/browser:
  Convert hpp helpers to a function
Git-Commit-ID: 843985e953ddcc3d57a62641b377c8d3222859e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:46:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  843985e953ddcc3d57a62641b377c8d3222859e2
Gitweb:     http://git.kernel.org/tip/843985e953ddcc3d57a62641b377c8d3222859e2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:46 -0300

perf gtk/browser: Convert hpp helpers to a function

The hpp helpers do same job for each field so it was implemented as
macro in order to access those fields easily.  But it gets cumbersome to
maintain a large function in a macro as the function grows. Factor it
out to a function with a little helper macro to access field.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 68 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index c03da79..38be79d 100644
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
