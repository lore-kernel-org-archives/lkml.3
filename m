Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3AXTHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:07:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33236 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXTHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:07:49 -0500
Date: Thu, 24 Jan 2013 11:07:21 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-22shm0ptkch2kgl7rtqlligx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Set the leader in the perf_evlist__config method
Git-Commit-ID: f77a951826b44b763e4d9fbd2479b6132d2bd7fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:07:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f77a951826b44b763e4d9fbd2479b6132d2bd7fc
Gitweb:     http://git.kernel.org/tip/f77a951826b44b763e4d9fbd2479b6132d2bd7fc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 16:41:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Dec 2012 17:19:01 -0300

perf evlist: Set the leader in the perf_evlist__config method

Since we need to ensure the leader is set before configuring the
evsel perf_event_attrs.

Reducing the boilerplate needed by tools, helping, for instance,
'perf trace', that wasn't setting the leader.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-22shm0ptkch2kgl7rtqlligx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |  9 +--------
 tools/perf/builtin-trace.c     |  2 +-
 tools/perf/tests/perf-record.c |  2 +-
 tools/perf/util/evlist.c       | 10 ++++++++--
 tools/perf/util/evlist.h       |  4 ++--
 5 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0be6605..fc4f080 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -230,14 +230,7 @@ static int perf_record__open(struct perf_record *rec)
 	struct perf_record_opts *opts = &rec->opts;
 	int rc = 0;
 
-	/*
-	 * Set the evsel leader links before we configure attributes,
-	 * since some might depend on this info.
-	 */
-	if (opts->group)
-		perf_evlist__set_leader(evlist);
-
-	perf_evlist__config_attrs(evlist, opts);
+	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7932ffa..d222d7f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -455,7 +455,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
-	perf_evlist__config_attrs(evlist, &trace->opts);
+	perf_evlist__config(evlist, &trace->opts);
 
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 5902772..6ea66cf 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -106,7 +106,7 @@ int test__PERF_RECORD(void)
 	perf_evsel__set_sample_bit(evsel, CPU);
 	perf_evsel__set_sample_bit(evsel, TID);
 	perf_evsel__set_sample_bit(evsel, TIME);
-	perf_evlist__config_attrs(evlist, &opts);
+	perf_evlist__config(evlist, &opts);
 
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5a0878d..dc8aee9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -49,10 +49,16 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 	return evlist;
 }
 
-void perf_evlist__config_attrs(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts)
+void perf_evlist__config(struct perf_evlist *evlist,
+			struct perf_record_opts *opts)
 {
 	struct perf_evsel *evsel;
+	/*
+	 * Set the evsel leader links before we configure attributes,
+	 * since some might depend on this info.
+	 */
+	if (opts->group)
+		perf_evlist__set_leader(evlist);
 
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 56003f7..457e235 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -76,8 +76,8 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
 
-void perf_evlist__config_attrs(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts);
+void perf_evlist__config(struct perf_evlist *evlist,
+			 struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_record_opts *opts,
