Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3AXUSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:18:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50176 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AXUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 38/74] perf bench: Flush stdout before starting bench suite
Date: Thu, 24 Jan 2013 17:07:47 -0300
Message-Id: <1359058103-31645-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.8.1.1.361.gec3ae6e

