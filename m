Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3AYBpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:45:01 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45316 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3AYBoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:44:54 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-a4-5101e394ed2f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf evsel:  Fix memory leaks on evsel->counts
Date: Fri, 25 Jan 2013 10:44:44 +0900
Message-Id: <1359078284-32080-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ->counts field was never freed in the current code.  Add
perf_evsel__free_counts() function to free it properly.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
This patch is based on Stephane's interval printing patchset v6.

 tools/perf/builtin-stat.c                | 1 +
 tools/perf/tests/open-syscall-all-cpus.c | 1 +
 tools/perf/util/evsel.c                  | 5 +++++
 tools/perf/util/evsel.h                  | 1 +
 4 files changed, 8 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 493043abd164..0368a1036ad6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1372,6 +1372,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		perf_evsel__free_stat_priv(pos);
+		perf_evsel__free_counts(pos);
 		perf_evsel__free_prev_raw_counts(pos);
 	}
 	perf_evlist__delete_maps(evsel_list);
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index 9b920a0cce79..b0657a9ccda6 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -98,6 +98,7 @@ int test__open_syscall_event_on_all_cpus(void)
 		}
 	}
 
+	perf_evsel__free_counts(evsel);
 out_close_fd:
 	perf_evsel__close_fd(evsel, 1, threads->nr);
 out_evsel_delete:
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dbdcca43cac6..baa26ddbcc7b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -640,6 +640,11 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 		}
 }
 
+void perf_evsel__free_counts(struct perf_evsel *evsel)
+{
+	free(evsel->counts);
+}
+
 void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3a4cd60044ea..cbf42322a27e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -117,6 +117,7 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
+void perf_evsel__free_counts(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
-- 
1.7.11.7

