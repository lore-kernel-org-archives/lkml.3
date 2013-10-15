Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab3JOFZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:25:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3JOFZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:25:23 -0400
Date: Mon, 14 Oct 2013 22:24:47 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-f37376cd721a539ac398cbb7718b72fce83cd49b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1378693159-8747-8-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-8-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Account for lock average wait time
Git-Commit-ID: f37376cd721a539ac398cbb7718b72fce83cd49b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:24:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f37376cd721a539ac398cbb7718b72fce83cd49b
Gitweb:     http://git.kernel.org/tip/f37376cd721a539ac398cbb7718b72fce83cd49b
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Sun, 8 Sep 2013 19:19:19 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:24:01 -0300

perf lock: Account for lock average wait time

While perf-lock currently reports both the total wait time and the
number of contentions, it doesn't explicitly show the average wait time.
Having this value immediately in the report can be quite useful when
looking into performance issues.

Furthermore, allowing report to sort by averages is another handy
feature to have - and thus do not only print the value, but add it to
the lock_stat structure.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378693159-8747-8-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-lock.txt |  2 +-
 tools/perf/builtin-lock.c              | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index c7f5f55..ab25be2 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -48,7 +48,7 @@ REPORT OPTIONS
 -k::
 --key=<value>::
         Sorting key. Possible values: acquired (default), contended,
-        wait_total, wait_max, wait_min.
+	avg_wait, wait_total, wait_max, wait_min.
 
 INFO OPTIONS
 ------------
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 972310c..6a9076f 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -56,7 +56,9 @@ struct lock_stat {
 
 	unsigned int		nr_readlock;
 	unsigned int		nr_trylock;
+
 	/* these times are in nano sec. */
+	u64                     avg_wait_time;
 	u64			wait_time_total;
 	u64			wait_time_min;
 	u64			wait_time_max;
@@ -208,6 +210,7 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
 
 SINGLE_KEY(nr_acquired)
 SINGLE_KEY(nr_contended)
+SINGLE_KEY(avg_wait_time)
 SINGLE_KEY(wait_time_total)
 SINGLE_KEY(wait_time_max)
 
@@ -244,6 +247,7 @@ static struct rb_root		result;	/* place to store sorted data */
 struct lock_key keys[] = {
 	DEF_KEY_LOCK(acquired, nr_acquired),
 	DEF_KEY_LOCK(contended, nr_contended),
+	DEF_KEY_LOCK(avg_wait, avg_wait_time),
 	DEF_KEY_LOCK(wait_total, wait_time_total),
 	DEF_KEY_LOCK(wait_min, wait_time_min),
 	DEF_KEY_LOCK(wait_max, wait_time_max),
@@ -516,6 +520,7 @@ static int report_lock_acquired_event(struct perf_evsel *evsel,
 
 	seq->state = SEQ_STATE_ACQUIRED;
 	ls->nr_acquired++;
+	ls->avg_wait_time = ls->nr_contended ? ls->wait_time_total/ls->nr_contended : 0;
 	seq->prev_event_time = sample->time;
 end:
 	return 0;
@@ -570,6 +575,7 @@ static int report_lock_contended_event(struct perf_evsel *evsel,
 
 	seq->state = SEQ_STATE_CONTENDED;
 	ls->nr_contended++;
+	ls->avg_wait_time = ls->wait_time_total/ls->nr_contended;
 	seq->prev_event_time = sample->time;
 end:
 	return 0;
@@ -703,6 +709,7 @@ static void print_result(void)
 	pr_info("%10s ", "acquired");
 	pr_info("%10s ", "contended");
 
+	pr_info("%15s ", "avg wait (ns)");
 	pr_info("%15s ", "total wait (ns)");
 	pr_info("%15s ", "max wait (ns)");
 	pr_info("%15s ", "min wait (ns)");
@@ -734,6 +741,7 @@ static void print_result(void)
 		pr_info("%10u ", st->nr_acquired);
 		pr_info("%10u ", st->nr_contended);
 
+		pr_info("%15" PRIu64 " ", st->avg_wait_time);
 		pr_info("%15" PRIu64 " ", st->wait_time_total);
 		pr_info("%15" PRIu64 " ", st->wait_time_max);
 		pr_info("%15" PRIu64 " ", st->wait_time_min == ULLONG_MAX ?
@@ -940,7 +948,7 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	};
 	const struct option report_options[] = {
 	OPT_STRING('k', "key", &sort_key, "acquired",
-		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
+		    "key for sorting (acquired / contended / avg_wait / wait_total / wait_max / wait_min)"),
 	/* TODO: type */
 	OPT_END()
 	};
