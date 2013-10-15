Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab3JOFZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:25:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016Ab3JOFZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:25:39 -0400
Date: Mon, 14 Oct 2013 22:25:13 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-b22d54b09a5448d3706929c6f0eae36429f4ec5d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1378031796-17892-4-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Introduce perf_evlist__new_default function
Git-Commit-ID: b22d54b09a5448d3706929c6f0eae36429f4ec5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:25:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b22d54b09a5448d3706929c6f0eae36429f4ec5d
Gitweb:     http://git.kernel.org/tip/b22d54b09a5448d3706929c6f0eae36429f4ec5d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 1 Sep 2013 12:36:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:24:34 -0300

perf evlist: Introduce perf_evlist__new_default function

Adding new common function to create evlist with default event. It
spares some code lines in automated tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378031796-17892-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/perf-record.c | 12 +-----------
 tools/perf/tests/task-exit.c   | 14 ++------------
 tools/perf/util/evlist.c       | 12 ++++++++++++
 tools/perf/util/evlist.h       |  1 +
 4 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index b8a7056..82ac715 100644
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
index d21ab08..f0d71a9 100644
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
index 4edb500..871b55a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -53,6 +53,7 @@ struct perf_evsel_str_handler {
 };
 
 struct perf_evlist *perf_evlist__new(void);
+struct perf_evlist *perf_evlist__new_default(void);
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads);
 void perf_evlist__exit(struct perf_evlist *evlist);
