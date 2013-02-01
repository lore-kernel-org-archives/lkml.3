Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197Ab3BAKtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:49:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161186Ab3BAKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:49:09 -0500
Date: Fri, 1 Feb 2013 02:48:41 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-897014603c4786ef33450e675e02a5e74dc63785@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1358845787-1350-11-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-11-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Move coloring logic to hpp functions
Git-Commit-ID: 897014603c4786ef33450e675e02a5e74dc63785
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:48:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  897014603c4786ef33450e675e02a5e74dc63785
Gitweb:     http://git.kernel.org/tip/897014603c4786ef33450e675e02a5e74dc63785
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:47 -0300

perf hists browser: Move coloring logic to hpp functions

Move coloring logic into the hpp functions so that each value can
be colored independently.  It'd required for event group view.

For overhead column, add a callback for printing 'folded_sign' of
callchains of a hist entry.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1358845787-1350-11-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 72 ++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 46242de..852e4e1 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -567,23 +567,48 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
+struct hpp_arg {
+	struct ui_browser *b;
+	char folded_sign;
+	bool current_entry;
+};
+
+static int __hpp__color_callchain(struct hpp_arg *arg)
+{
+	if (!symbol_conf.use_callchain)
+		return 0;
+
+	slsmg_printf("%c ", arg->folded_sign);
+	return 2;
+}
+
 static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			    u64 (*get_field)(struct hist_entry *))
+			    u64 (*get_field)(struct hist_entry *),
+			    int (*callchain_cb)(struct hpp_arg *))
 {
-	int ret;
+	int ret = 0;
 	double percent = 0.0;
 	struct hists *hists = he->hists;
+	struct hpp_arg *arg = hpp->ptr;
 
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
-	*(double *)hpp->ptr = percent;
+	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
+
+	if (callchain_cb)
+		ret += callchain_cb(arg);
+
+	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+	slsmg_printf("%s", hpp->buf);
+
+	if (!arg->current_entry || !arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
 
-	ret = scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 	return ret;
 }
 
-#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
+#define __HPP_COLOR_PERCENT_FN(_type, _field, _cb)			\
 static u64 __hpp_get_##_field(struct hist_entry *he)			\
 {									\
 	return he->stat._field;						\
@@ -592,14 +617,14 @@ static u64 __hpp_get_##_field(struct hist_entry *he)			\
 static int hist_browser__hpp_color_##_type(struct perf_hpp *hpp,	\
 					   struct hist_entry *he)	\
 {									\
-	return __hpp__color_fmt(hpp, he, __hpp_get_##_field);		\
+	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, _cb);	\
 }
 
-__HPP_COLOR_PERCENT_FN(overhead, period)
-__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
-__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
-__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
-__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__color_callchain)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, NULL)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us, NULL)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, NULL)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, NULL)
 
 #undef __HPP_COLOR_PERCENT_FN
 
@@ -626,7 +651,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 				    unsigned short row)
 {
 	char s[256];
-	double percent;
 	int printed = 0;
 	int width = browser->b.width;
 	char folded_sign = ' ';
@@ -646,16 +670,20 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	}
 
 	if (row_offset == 0) {
+		struct hpp_arg arg = {
+			.b 		= &browser->b,
+			.folded_sign	= folded_sign,
+			.current_entry	= current_entry,
+		};
 		struct perf_hpp hpp = {
 			.buf		= s,
 			.size		= sizeof(s),
+			.ptr		= &arg,
 		};
-		int i = 0;
 
 		ui_browser__gotorc(&browser->b, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
-
 			if (!first) {
 				slsmg_printf("  ");
 				width -= 2;
@@ -663,27 +691,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			first = false;
 
 			if (fmt->color) {
-				hpp.ptr = &percent;
-				/* It will set percent for us. See __hpp__color_fmt above. */
 				width -= fmt->color(&hpp, entry);
-
-				ui_browser__set_percent_color(&browser->b, percent, current_entry);
-
-				if (!i && symbol_conf.use_callchain) {
-					slsmg_printf("%c ", folded_sign);
-					width -= 2;
-				}
-
-				slsmg_printf("%s", s);
-
-				if (!current_entry || !browser->b.navkeypressed)
-					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
 			} else {
 				width -= fmt->entry(&hpp, entry);
 				slsmg_printf("%s", s);
 			}
-
-			i++;
 		}
 
 		/* The scroll bar isn't being used */
