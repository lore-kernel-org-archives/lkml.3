Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3EaLkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:40:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3EaLjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:39:55 -0400
Date: Fri, 31 May 2013 04:39:37 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f3dd19817e5bbcae81e96571a3d42aa30a1581fb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1368497347-9628-6-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Don'
 t bother locking when adding hist entries
Git-Commit-ID: f3dd19817e5bbcae81e96571a3d42aa30a1581fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3dd19817e5bbcae81e96571a3d42aa30a1581fb
Gitweb:     http://git.kernel.org/tip/f3dd19817e5bbcae81e96571a3d42aa30a1581fb
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 14 May 2013 11:09:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:00 +0300

perf report: Don't bother locking when adding hist entries

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
 
