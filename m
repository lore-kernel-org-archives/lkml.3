Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3FDPoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:44:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34737 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3FDPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:44:30 -0400
Date: Tue, 4 Jun 2013 17:44:26 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org
Subject: [PATCH] perf stat: avoid sending SIGTERM to random processes
Message-ID: <20130604154426.GA2928@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a problem with perf stat whereby on termination
it may send a SIGTERM signal to random processes on systems
with high PID recycling. I got some actual bug reports on this.

There is race between the SIGCHLD and sig_atexit() handlers.
This patch addresses this problem by clearing child_pid in the
SIGCHLD handler.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
 
