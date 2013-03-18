Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3CRQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:28:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49432
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018Ab3CRQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:26:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 53/54] perf stat: Introduce evlist methods to allocate/free the stats
Date: Mon, 18 Mar 2013 13:25:38 -0300
Message-Id: <1363623939-10748-54-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 tools/perf/builtin-stat.c |   67 +++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 24 deletions(-)

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
-- 
1.7.1

