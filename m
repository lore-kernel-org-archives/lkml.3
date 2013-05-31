Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3EaLfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:35:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3EaLes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:34:48 -0400
Date: Fri, 31 May 2013 04:34:28 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-933cbb1c6c617a6ae167538c2fa503efc9c4a832@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1368497347-9628-2-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix -E option behavior
Git-Commit-ID: 933cbb1c6c617a6ae167538c2fa503efc9c4a832
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  933cbb1c6c617a6ae167538c2fa503efc9c4a832
Gitweb:     http://git.kernel.org/tip/933cbb1c6c617a6ae167538c2fa503efc9c4a832
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 14 May 2013 11:08:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:59 +0300

perf top: Fix -E option behavior

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
