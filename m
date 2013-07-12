Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3GLIvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:51:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3GLIvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:51:15 -0400
Date: Fri, 12 Jul 2013 01:50:18 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-d07f0b120642f442d81a61f68a9325fb7717004f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20130604154426.GA2928@quad>
References: <20130604154426.GA2928@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  Avoid sending SIGTERM to random processes
Git-Commit-ID: d07f0b120642f442d81a61f68a9325fb7717004f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:50:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d07f0b120642f442d81a61f68a9325fb7717004f
Gitweb:     http://git.kernel.org/tip/d07f0b120642f442d81a61f68a9325fb7717004f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 4 Jun 2013 17:44:26 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:36:33 -0300

perf stat: Avoid sending SIGTERM to random processes

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
 
