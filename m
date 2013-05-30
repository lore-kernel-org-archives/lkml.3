Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab3E3QCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:02:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934453Ab3E3QCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/66] perf report: Don't bother locking when adding hist entries
Date: Thu, 30 May 2013 19:00:55 +0300
Message-Id: <1369929699-8724-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The 'perf report'command is single-threaded, so no need to grab a lock.

Although the fast path of pthread_mutex_[un]lock() is very fast, there's
a ~3% gain by eliminating it when we have huge sample data.

  $ perf record -a -F 100000 -o perf.data.bench -- perf bench sched all
  $ perf record -e cycles:upp -o perf.data.before -- \
  > perf report -i perf.data.bench --stdio > /dev/null
  ... apply this patch ...
  $ perf record -e cycles:upp -o perf.data.after -- \
  > perf report -i perf.data.bench --stdio > /dev/null
  $ perf diff perf.data.{before,after} | grep pthread
             +0.02%  libpthread-2.15.so  [.] _pthread_cleanup_push_defer
             +0.02%  libpthread-2.15.so  [.] _pthread_cleanup_pop_restore
     0.05%   -0.05%  perf                [.] pthread_mutex_unlock@plt
     0.05%   -0.05%  perf                [.] pthread_mutex_lock@plt
     1.01%   -1.01%  libpthread-2.15.so  [.] pthread_mutex_lock
     1.68%   -1.68%  libpthread-2.15.so  [.] __pthread_mutex_unlock_usercnt
     0.05%   -0.05%  libpthread-2.15.so  [.] pthread_mutex_unlock

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 63febd2..0f0cf24 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -312,8 +312,6 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	pthread_mutex_lock(&evsel->hists.lock);
-
 	if (sort__mode == SORT_MODE__BRANCH) {
 		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
 							 evsel, machine);
@@ -332,8 +330,6 @@ static int process_sample_event(struct perf_tool *tool,
 		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
 	}
-	pthread_mutex_unlock(&evsel->hists.lock);
-
 	return ret;
 }
 
-- 
1.8.1.4

