Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3IAKm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab3IAKhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:37:18 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/25] perf tools: Introduce perf_evlist__new_default function
Date: Sun,  1 Sep 2013 12:36:14 +0200
Message-Id: <1378031796-17892-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new common function to create evlist with default
event. It spares some code lines in automated tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/tests/perf-record.c | 12 +-----------
 tools/perf/tests/task-exit.c   | 14 ++------------
 tools/perf/util/evlist.c       | 12 ++++++++++++
 tools/perf/util/evlist.h       |  1 +
 4 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 72d8881..6143b06 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -45,7 +45,7 @@ int test__PERF_RECORD(void)
 	};
 	cpu_set_t cpu_mask;
 	size_t cpu_mask_size = sizeof(cpu_mask);
-	struct perf_evlist *evlist = perf_evlist__new();
+	struct perf_evlist *evlist = perf_evlist__new_default();
 	struct perf_evsel *evsel;
 	struct perf_sample sample;
 	const char *cmd = "sleep";
@@ -66,16 +66,6 @@ int test__PERF_RECORD(void)
 	}
 
 	/*
-	 * We need at least one evsel in the evlist, use the default
-	 * one: "cycles".
-	 */
-	err = perf_evlist__add_default(evlist);
-	if (err < 0) {
-		pr_debug("Not enough memory to create evsel\n");
-		goto out_delete_evlist;
-	}
-
-	/*
 	 * Create maps of threads and cpus to monitor. In this case
 	 * we start with all threads and cpus (-1, -1) but then in
 	 * perf_evlist__prepare_workload we'll fill in the only thread
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 28fe589..b07f8a1 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -37,20 +37,11 @@ int test__task_exit(void)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGUSR1, sig_handler);
 
-	evlist = perf_evlist__new();
+	evlist = perf_evlist__new_default();
 	if (evlist == NULL) {
-		pr_debug("perf_evlist__new\n");
+		pr_debug("perf_evlist__new_default\n");
 		return -1;
 	}
-	/*
-	 * We need at least one evsel in the evlist, use the default
-	 * one: "cycles".
-	 */
-	err = perf_evlist__add_default(evlist);
-	if (err < 0) {
-		pr_debug("Not enough memory to create evsel\n");
-		goto out_free_evlist;
-	}
 
 	/*
 	 * Create maps of threads and cpus to monitor. In this case
@@ -117,7 +108,6 @@ out_close_evlist:
 	perf_evlist__close(evlist);
 out_delete_maps:
 	perf_evlist__delete_maps(evlist);
-out_free_evlist:
 	perf_evlist__delete(evlist);
 	return err;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8ea933f..998e0d1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -50,6 +50,18 @@ struct perf_evlist *perf_evlist__new(void)
 	return evlist;
 }
 
+struct perf_evlist *perf_evlist__new_default(void)
+{
+	struct perf_evlist *evlist = perf_evlist__new();
+
+	if (evlist && perf_evlist__add_default(evlist)) {
+		perf_evlist__delete(evlist);
+		evlist = NULL;
+	}
+
+	return evlist;
+}
+
 /**
  * perf_evlist__set_id_pos - set the positions of event ids.
  * @evlist: selected event list
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index cae0bf5..ca016b1 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -53,6 +53,7 @@ struct perf_evsel_str_handler {
 };
 
 struct perf_evlist *perf_evlist__new(void);
+struct perf_evlist *perf_evlist__new_default(void);
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads);
 void perf_evlist__exit(struct perf_evlist *evlist);
-- 
1.7.11.7

