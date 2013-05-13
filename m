Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3EMDEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:04:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51671 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3EMDEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:04:23 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 May 2013 23:04:23 EDT
X-AuditID: 9c93017d-b7b62ae000004f69-18-519054b0645f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf top: Fix -E option behavior
Date: Mon, 13 May 2013 11:49:17 +0900
Message-Id: <1368413358-11685-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -E/--entries option controls how many lines to be printed on stdio
output but it doesn't work as it should be:

If -E option is specified, print that many lines regardless of current
window size, if not automatically adjust number of lines printed to
fit into the window size.

Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 67bdb9f14ad6..55ecae883e14 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -70,10 +70,11 @@
 
 static volatile int done;
 
+#define HEADER_LINE_NR  5
+
 static void perf_top__update_print_entries(struct perf_top *top)
 {
-	if (top->print_entries > 9)
-		top->print_entries -= 9;
+	top->print_entries = top->winsize.ws_row - HEADER_LINE_NR;
 }
 
 static void perf_top__sig_winch(int sig __maybe_unused,
@@ -82,13 +83,6 @@ static void perf_top__sig_winch(int sig __maybe_unused,
 	struct perf_top *top = arg;
 
 	get_term_dimensions(&top->winsize);
-	if (!top->print_entries
-	    || (top->print_entries+4) > top->winsize.ws_row) {
-		top->print_entries = top->winsize.ws_row;
-	} else {
-		top->print_entries += 4;
-		top->winsize.ws_row = top->print_entries;
-	}
 	perf_top__update_print_entries(top);
 }
 
@@ -296,10 +290,10 @@ static void perf_top__print_sym_table(struct perf_top *top)
 				      top->hide_user_symbols,
 				      top->hide_kernel_symbols);
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
-				     top->winsize.ws_row - 3);
+				     top->print_entries - printed);
 	putchar('\n');
 	hists__fprintf(&top->sym_evsel->hists, false,
-		       top->winsize.ws_row - 4 - printed, win_width, stdout);
+		       top->print_entries - printed, win_width, stdout);
 }
 
 static void prompt_integer(int *target, const char *msg)
@@ -477,7 +471,6 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 				perf_top__sig_winch(SIGWINCH, NULL, top);
 				sigaction(SIGWINCH, &act, NULL);
 			} else {
-				perf_top__sig_winch(SIGWINCH, NULL, top);
 				signal(SIGWINCH, SIG_DFL);
 			}
 			break;
-- 
1.7.11.7

