Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab3E3QCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:02:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50849 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432Ab3E3QCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/66] perf top: Fix -E option behavior
Date: Thu, 30 May 2013 19:00:51 +0300
Message-Id: <1369929699-8724-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -E/--entries option controls how many lines to be printed on stdio
output but it doesn't work as it should be:

If -E option is specified, print that many lines regardless of current
window size, if not automatically adjust number of lines printed to fit
into the window size.

Reported-by: Minchan Kim <minchan@kernel.org>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index df9e06a..81adcaf 100644
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
1.8.1.4

