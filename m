Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaBBVkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaBBVkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:13 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 13/22] perf tools: Factor hpp_arg struct to carry hist_browser
Date: Sun,  2 Feb 2014 22:39:01 +0100
Message-Id: <1391377150-23920-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hpp_arg struct is used within the hist browser
specific code, so it could pass the hist_browser
struct itself.

We'll need access to hist browser struct within
__hpp__color_fmt function in following patch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browsers/hists.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 9a95fdc..3dd71d6 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -574,7 +574,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 }
 
 struct hpp_arg {
-	struct ui_browser *b;
+	struct hist_browser *hb;
 	char folded_sign;
 	bool current_entry;
 };
@@ -600,7 +600,7 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
-	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
+	ui_browser__set_percent_color(&arg->hb->b, percent, arg->current_entry);
 
 	if (callchain_cb)
 		ret += callchain_cb(arg);
@@ -634,7 +634,7 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 * zero-fill group members in the middle which
 				 * have no sample
 				 */
-				ui_browser__set_percent_color(arg->b, 0.0,
+				ui_browser__set_percent_color(&arg->hb->b, 0.0,
 							arg->current_entry);
 				ret += scnprintf(hpp->buf, hpp->size,
 						 " %6.2f%%", 0.0);
@@ -642,7 +642,7 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			}
 
 			percent = 100.0 * period / total;
-			ui_browser__set_percent_color(arg->b, percent,
+			ui_browser__set_percent_color(&arg->hb->b, percent,
 						      arg->current_entry);
 			ret += scnprintf(hpp->buf, hpp->size,
 					 " %6.2f%%", percent);
@@ -657,7 +657,7 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			/*
 			 * zero-fill group members at last which have no sample
 			 */
-			ui_browser__set_percent_color(arg->b, 0.0,
+			ui_browser__set_percent_color(&arg->hb->b, 0.0,
 						      arg->current_entry);
 			ret += scnprintf(hpp->buf, hpp->size,
 					 " %6.2f%%", 0.0);
@@ -665,8 +665,8 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		}
 	}
 out:
-	if (!arg->current_entry || !arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+	if (!arg->current_entry || !arg->hb->b.navkeypressed)
+		ui_browser__set_color(&arg->hb->b, HE_COLORSET_NORMAL);
 
 	return ret;
 }
@@ -751,7 +751,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 	if (row_offset == 0) {
 		struct hpp_arg arg = {
-			.b 		= &browser->b,
+			.hb		= browser,
 			.folded_sign	= folded_sign,
 			.current_entry	= current_entry,
 		};
-- 
1.8.3.1

