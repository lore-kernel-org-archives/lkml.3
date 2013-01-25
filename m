Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3AYLd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:33:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3AYLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:33:24 -0500
Date: Fri, 25 Jan 2013 03:32:56 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9b494ea2f5638184bc203a30062b32b9a9a05d9e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, namhyung.kim@lge.com, h.mitake@gmail.com,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, mitake@dcl.info.waseda.ac.jp,
        namhyung@kernel.org, h.mitake@gmail.com, tglx@linutronix.de
In-Reply-To: <1357637966-8216-1-git-send-email-namhyung@kernel.org>
References: <1357637966-8216-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench:
  Flush stdout before starting bench suite
Git-Commit-ID: 9b494ea2f5638184bc203a30062b32b9a9a05d9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:33:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b494ea2f5638184bc203a30062b32b9a9a05d9e
Gitweb:     http://git.kernel.org/tip/9b494ea2f5638184bc203a30062b32b9a9a05d9e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 8 Jan 2013 18:39:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:19 -0300

perf bench: Flush stdout before starting bench suite

perf bench prints header message for bench suite before starting the
benchmark.  However if the stdout is redirected to a file and bench
suite forks child processes this (and possibly other debugging
messages too) will be repeated multiple times.

  $ perf bench sched messaging
  # Running sched/messaging benchmark...
  # 20 sender and receiver processes per group
  # 10 groups == 400 processes run

       Total time: 0.100 [sec]

  $ perf bench sched messaging > result.txt
  $ wc -l result.txt
  391

In this file, there were so many "Running sched/messaging benchmark..."
lines.  This was because stdout is converted to fully-buffered due to
the redirection and inherited child processes.  Other lines are printed
after reaping all those tasks.

So fix it by flushing stdout before starting bench suites.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1357637966-8216-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-bench.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index cae9a5f..afd1255 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -159,6 +159,7 @@ static void all_suite(struct bench_subsys *subsys)	  /* FROM HERE */
 		printf("# Running %s/%s benchmark...\n",
 		       subsys->name,
 		       suites[i].name);
+		fflush(stdout);
 
 		argv[1] = suites[i].name;
 		suites[i].fn(1, argv, NULL);
@@ -225,6 +226,7 @@ int cmd_bench(int argc, const char **argv, const char *prefix __maybe_unused)
 				printf("# Running %s/%s benchmark...\n",
 				       subsystems[i].name,
 				       subsystems[i].suites[j].name);
+			fflush(stdout);
 			status = subsystems[i].suites[j].fn(argc - 1,
 							    argv + 1, prefix);
 			goto end;
