Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3AaRZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:25:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48031 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3AaRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/25] perf top: Stop using exit()
Date: Thu, 31 Jan 2013 14:25:04 -0300
Message-Id: <1359653128-10433-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just return to the perf main() routine so that an unified exit path can
be followed and resources released, helping in finding memory leaks.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ro8oeodo96490nrhcph57atr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 56 ++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7978c81..903e4f4 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -68,6 +68,8 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
+static volatile int done;
+
 static void perf_top__update_print_entries(struct perf_top *top)
 {
 	if (top->print_entries > 9)
@@ -431,8 +433,10 @@ static int perf_top__key_mapped(struct perf_top *top, int c)
 	return 0;
 }
 
-static void perf_top__handle_keypress(struct perf_top *top, int c)
+static bool perf_top__handle_keypress(struct perf_top *top, int c)
 {
+	bool ret = true;
+
 	if (!perf_top__key_mapped(top, c)) {
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 		struct termios tc, save;
@@ -453,7 +457,7 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 
 		tcsetattr(0, TCSAFLUSH, &save);
 		if (!perf_top__key_mapped(top, c))
-			return;
+			return ret;
 	}
 
 	switch (c) {
@@ -515,7 +519,8 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 			printf("exiting.\n");
 			if (top->dump_symtab)
 				perf_session__fprintf_dsos(top->session, stderr);
-			exit(0);
+			ret = false;
+			break;
 		case 's':
 			perf_top__prompt_symbol(top, "Enter details symbol");
 			break;
@@ -538,6 +543,8 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 		default:
 			break;
 	}
+
+	return ret;
 }
 
 static void perf_top__sort_new_samples(void *arg)
@@ -579,8 +586,7 @@ static void *display_thread_tui(void *arg)
 	perf_evlist__tui_browse_hists(top->evlist, help, &hbt,
 				      &top->session->header.env);
 
-	exit_browser(0);
-	exit(0);
+	done = 1;
 	return NULL;
 }
 
@@ -604,7 +610,7 @@ repeat:
 	/* trash return*/
 	getc(stdin);
 
-	while (1) {
+	while (!done) {
 		perf_top__print_sym_table(top);
 		/*
 		 * Either timeout expired or we got an EINTR due to SIGWINCH,
@@ -618,15 +624,14 @@ repeat:
 				continue;
 			/* Fall trhu */
 		default:
-			goto process_hotkey;
+			c = getc(stdin);
+			tcsetattr(0, TCSAFLUSH, &save);
+
+			if (perf_top__handle_keypress(top, c))
+				goto repeat;
+			done = 1;
 		}
 	}
-process_hotkey:
-	c = getc(stdin);
-	tcsetattr(0, TCSAFLUSH, &save);
-
-	perf_top__handle_keypress(top, c);
-	goto repeat;
 
 	return NULL;
 }
@@ -705,7 +710,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	}
 
 	if (!machine) {
-		pr_err("%u unprocessable samples recorded.\n",
+		pr_err("%u unprocessable samples recorded.\r",
 		       top->session->stats.nr_unprocessable_samples++);
 		return;
 	}
@@ -868,7 +873,7 @@ static void perf_top__mmap_read(struct perf_top *top)
 		perf_top__mmap_read_idx(top, i);
 }
 
-static void perf_top__start_counters(struct perf_top *top)
+static int perf_top__start_counters(struct perf_top *top)
 {
 	char msg[512];
 	struct perf_evsel *counter;
@@ -900,11 +905,10 @@ try_again:
 		goto out_err;
 	}
 
-	return;
+	return 0;
 
 out_err:
-	exit_browser(0);
-	exit(0);
+	return -1;
 }
 
 static int perf_top__setup_sample_type(struct perf_top *top)
@@ -948,7 +952,11 @@ static int __cmd_top(struct perf_top *top)
 	else
 		perf_event__synthesize_threads(&top->tool, perf_event__process,
 					       &top->session->machines.host);
-	perf_top__start_counters(top);
+
+	ret = perf_top__start_counters(top);
+	if (ret)
+		goto out_delete;
+
 	top->session->evlist = top->evlist;
 	perf_session__set_id_hdr_size(top->session);
 
@@ -968,10 +976,11 @@ static int __cmd_top(struct perf_top *top)
 
 	perf_top__mmap_read(top);
 
+	ret = -1;
 	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
 							    display_thread), top)) {
 		ui__error("Could not create display thread.\n");
-		exit(-1);
+		goto out_delete;
 	}
 
 	if (top->realtime_prio) {
@@ -980,11 +989,11 @@ static int __cmd_top(struct perf_top *top)
 		param.sched_priority = top->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			ui__error("Could not set realtime priority.\n");
-			exit(-1);
+			goto out_delete;
 		}
 	}
 
-	while (1) {
+	while (!done) {
 		u64 hits = top->samples;
 
 		perf_top__mmap_read(top);
@@ -993,11 +1002,12 @@ static int __cmd_top(struct perf_top *top)
 			ret = poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
 	}
 
+	ret = 0;
 out_delete:
 	perf_session__delete(top->session);
 	top->session = NULL;
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
1.8.1.1.361.gec3ae6e

