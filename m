Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3A3Oue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:50:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57847 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3A3OrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/21] perf evsel: Fix memory leaks on evsel->counts
Date: Wed, 30 Jan 2013 11:46:56 -0300
Message-Id: <1359557222-17547-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ->counts field was never freed in the current code.  Add
perf_evsel__free_counts() function to free it properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1359078284-32080-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c                | 1 +
 tools/perf/tests/open-syscall-all-cpus.c | 1 +
 tools/perf/util/evsel.c                  | 5 +++++
 tools/perf/util/evsel.h                  | 1 +
 4 files changed, 8 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 493043a..0368a10 100644
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
index 9b920a0..b0657a9 100644
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
index dbdcca4..baa26dd 100644
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
index 3a4cd60..cbf4232 100644
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
1.8.1.1.361.gec3ae6e

