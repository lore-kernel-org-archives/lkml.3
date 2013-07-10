Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3GJTTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:19:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56788 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3GJTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/23] perf stat: Avoid sending SIGTERM to random processes
Date: Wed, 10 Jul 2013 16:19:07 -0300
Message-Id: <1373483963-19277-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch fixes a problem with perf stat whereby on termination it may
send a SIGTERM signal to random processes on systems with high PID
recycling. I got some actual bug reports on this.

There is race between the SIGCHLD and sig_atexit() handlers.  This patch
addresses this problem by clearing child_pid in the SIGCHLD handler.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130604154426.GA2928@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7e910ba..95768af 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -87,7 +87,7 @@ static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
 static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
-static pid_t			child_pid			= -1;
+static volatile pid_t		child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
 static bool			big_num				=  true;
@@ -1148,13 +1148,34 @@ static void skip_signal(int signo)
 		done = 1;
 
 	signr = signo;
+	/*
+	 * render child_pid harmless
+	 * won't send SIGTERM to a random
+	 * process in case of race condition
+	 * and fast PID recycling
+	 */
+	child_pid = -1;
 }
 
 static void sig_atexit(void)
 {
+	sigset_t set, oset;
+
+	/*
+	 * avoid race condition with SIGCHLD handler
+	 * in skip_signal() which is modifying child_pid
+	 * goal is to avoid send SIGTERM to a random
+	 * process
+	 */
+	sigemptyset(&set);
+	sigaddset(&set, SIGCHLD);
+	sigprocmask(SIG_BLOCK, &set, &oset);
+
 	if (child_pid != -1)
 		kill(child_pid, SIGTERM);
 
+	sigprocmask(SIG_SETMASK, &oset, NULL);
+
 	if (signr == -1)
 		return;
 
-- 
1.8.1.4

