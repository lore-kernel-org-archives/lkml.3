Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3EMGRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:17:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46879 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3EMGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:16:58 -0400
X-AuditID: 9c93016f-b7b9bae000002df2-73-519085567279
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/3] perf report: Don't be bothered with locking when adding hist entries
Date: Mon, 13 May 2013 15:16:34 +0900
Message-Id: <1368425794-17515-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368425794-17515-1-git-send-email-namhyung@kernel.org>
References: <1368425794-17515-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf report is single-threaded, so no need to grab a lock.
Although the fast path of pthread_mutex_[un]lock() is very fast,
there's ~3% gain by eliminating it when we have huge sample data.

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
---
 tools/perf/builtin-report.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 63febd24e912..0f0cf2472d9d 100644
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
1.7.11.7

