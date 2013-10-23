Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3JWVBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:01:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55413 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3JWU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf sched: Optimize build time
Date: Wed, 23 Oct 2013 17:58:07 -0300
Message-Id: <1382561895-8237-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

builtin-sched.c took a log time to build with -O6 optimization. This
turned out to be caused by:

	.curr_pid = { [0 ... MAX_CPUS - 1] = -1 },

Fix by initializing curr_pid programmatically.

This addresses the problem cured in f36f83f947ed using a smaller hammer.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-13-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5a338566195e..ddb5dc15be17 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1670,7 +1670,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
 		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
 		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
-		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
 		.sort_order	      = default_sort_order,
 		.replay_repeat	      = 10,
 		.profile_cpu	      = -1,
@@ -1732,6 +1731,10 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		.switch_event	    = replay_switch_event,
 		.fork_event	    = replay_fork_event,
 	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
+		sched.curr_pid[i] = -1;
 
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
-- 
1.8.1.4

