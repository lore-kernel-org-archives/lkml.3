Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaELGcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:32:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57521 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaELG3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:29:06 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 10/20] perf tools: Call perf_hpp__init() before setting up GUI browsers
Date: Mon, 12 May 2014 15:28:43 +0900
Message-Id: <1399876133-17963-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can be set properly prior to set up output fields.  That
makes easy to handle/warn errors during the setup since it doesn't
need to be bothered with the GUI.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    | 6 +++---
 tools/perf/builtin-top.c       | 2 ++
 tools/perf/ui/browsers/hists.c | 2 --
 tools/perf/ui/gtk/hists.c      | 2 --
 tools/perf/ui/setup.c          | 2 --
 5 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8c9fbbdc6505..76d8d0b4f7f5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -825,16 +825,16 @@ repeat:
 			goto error;
 	}
 
+	perf_hpp__init();
+
 	/* Force tty output for header output. */
 	if (report.header || report.header_only)
 		use_browser = 0;
 
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
-	else {
+	else
 		use_browser = 0;
-		perf_hpp__init();
-	}
 
 	if (report.header || report.header_only) {
 		perf_session__fprintf_info(session, stdout,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bb2aa6645a7e..9309629394dd 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1147,6 +1147,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	/* display thread wants entries to be collapsed in a different tree */
 	sort__need_collapse = 1;
 
+	perf_hpp__init();
+
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 3ed9212d2a63..69c2b0e536ab 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -661,8 +661,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				hist_browser__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 2237245bfac0..fd52669018ee 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -58,8 +58,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				perf_gtk__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 5df5140a9f29..ba51fa8a1176 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -86,8 +86,6 @@ void setup_browser(bool fallback_to_pager)
 		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
-
-		perf_hpp__init();
 		break;
 	}
 }
-- 
1.9.2

