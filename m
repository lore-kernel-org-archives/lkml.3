Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3JVHfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:35:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:12361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab3JVHfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958552"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 12/14] perf sched: Fix optimized build time
Date: Tue, 22 Oct 2013 10:34:16 +0300
Message-Id: <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-sched.c took a log time to build with
-O6 optimization. This turned out to be caused
by:

	.curr_pid = { [0 ... MAX_CPUS - 1] = -1 },

Fix by initializing curr_pid programmatically.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5a33856..ddb5dc1 100644
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
1.7.11.7

