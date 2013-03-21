Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab3CULvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:51:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab3CULvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:51:43 -0400
Date: Thu, 21 Mar 2013 04:49:58 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-o219lnci04hlilxi6711wtcr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Introduce evlist methods to allocate/
 free the stats
Git-Commit-ID: d134ffb919ab142b2359ae45a0cf4a5bfa1ff283
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:50:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d134ffb919ab142b2359ae45a0cf4a5bfa1ff283
Gitweb:     http://git.kernel.org/tip/d134ffb919ab142b2359ae45a0cf4a5bfa1ff283
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 18 Mar 2013 11:24:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 18 Mar 2013 11:34:09 -0300

perf stat: Introduce evlist methods to allocate/free the stats

Reducing the noise in the main logic.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-o219lnci04hlilxi6711wtcr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 67 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 021783a..ba0bdd8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -166,6 +166,35 @@ static void perf_evsel__free_prev_raw_counts(struct perf_evsel *evsel)
 	evsel->prev_raw_counts = NULL;
 }
 
+static void perf_evlist__free_stats(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__free_stat_priv(evsel);
+		perf_evsel__free_counts(evsel);
+		perf_evsel__free_prev_raw_counts(evsel);
+	}
+}
+
+static int perf_evlist__alloc_stats(struct perf_evlist *evlist, bool alloc_raw)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (perf_evsel__alloc_stat_priv(evsel) < 0 ||
+		    perf_evsel__alloc_counts(evsel, perf_evsel__nr_cpus(evsel)) < 0 ||
+		    (alloc_raw && perf_evsel__alloc_prev_raw_counts(evsel) < 0))
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	perf_evlist__free_stats(evlist);
+	return -1;
+}
+
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
 static struct stats runtime_cycles_stats[MAX_NR_CPUS];
 static struct stats runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
@@ -179,8 +208,15 @@ static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
 
-static void reset_stats(void)
+static void perf_stat__reset_stats(struct perf_evlist *evlist)
 {
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__reset_stat_priv(evsel);
+		perf_evsel__reset_counts(evsel, perf_evsel__nr_cpus(evsel));
+	}
+
 	memset(runtime_nsecs_stats, 0, sizeof(runtime_nsecs_stats));
 	memset(runtime_cycles_stats, 0, sizeof(runtime_cycles_stats));
 	memset(runtime_stalled_cycles_front_stats, 0, sizeof(runtime_stalled_cycles_front_stats));
@@ -1308,7 +1344,6 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf stat [<options>] [<command>]",
 		NULL
 	};
-	struct perf_evsel *pos;
 	int status = -ENOMEM, run_idx;
 	const char *mode;
 
@@ -1420,17 +1455,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		return -1;
 	}
 
-	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
-			goto out_free_fd;
-	}
-	if (interval) {
-		list_for_each_entry(pos, &evsel_list->entries, node) {
-			if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
-				goto out_free_fd;
-		}
-	}
+	if (perf_evlist__alloc_stats(evsel_list, interval))
+		goto out_free_maps;
 
 	/*
 	 * We dont want to block the signals - that would cause
@@ -1454,22 +1480,15 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		status = run_perf_stat(argc, argv);
 		if (forever && status != -1) {
 			print_stat(argc, argv);
-			list_for_each_entry(pos, &evsel_list->entries, node) {
-				perf_evsel__reset_stat_priv(pos);
-				perf_evsel__reset_counts(pos, perf_evsel__nr_cpus(pos));
-			}
-			reset_stats();
+			perf_stat__reset_stats(evsel_list);
 		}
 	}
 
 	if (!forever && status != -1 && !interval)
 		print_stat(argc, argv);
-out_free_fd:
-	list_for_each_entry(pos, &evsel_list->entries, node) {
-		perf_evsel__free_stat_priv(pos);
-		perf_evsel__free_counts(pos);
-		perf_evsel__free_prev_raw_counts(pos);
-	}
+
+	perf_evlist__free_stats(evsel_list);
+out_free_maps:
 	perf_evlist__delete_maps(evsel_list);
 out:
 	perf_evlist__delete(evsel_list);
