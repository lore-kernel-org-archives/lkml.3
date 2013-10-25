Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3JYKfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:35:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3JYKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:32:36 -0400
Date: Fri, 25 Oct 2013 03:32:13 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-156a2b022907687f28c72d1ba601015f295cd99e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Optimize build time
Git-Commit-ID: 156a2b022907687f28c72d1ba601015f295cd99e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:32:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  156a2b022907687f28c72d1ba601015f295cd99e
Gitweb:     http://git.kernel.org/tip/156a2b022907687f28c72d1ba601015f295cd99e
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:16 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 10:24:29 -0300

perf sched: Optimize build time

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
