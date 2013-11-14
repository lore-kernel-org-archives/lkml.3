Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3KNU0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:26:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36319 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab3KNUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
Date: Thu, 14 Nov 2013 17:25:15 -0300
Message-Id: <1384460715-23198-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

By default, when tasks are specified (i.e. -p, -t or -u options)
per-thread mmaps are created.

Add an option to override that and force per-cpu mmaps.

Further comments by peterz:

So this option allows -t/-p/-u to create one buffer per cpu and attach
all the various thread/process/user tasks' their counters to that one
buffer?

As opposed to the current state where each such counter would have its
own buffer.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt | 6 ++++++
 tools/perf/builtin-record.c              | 2 ++
 tools/perf/util/evlist.c                 | 4 +++-
 tools/perf/util/evsel.c                  | 4 ++--
 tools/perf/util/target.h                 | 1 +
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 052f7c4dc00c..43b42c4f4a91 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -201,6 +201,12 @@ abort events and some memory events in precise mode on modern Intel CPUs.
 --transaction::
 Record transaction flags for transaction related events.
 
+--force-per-cpu::
+Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
+-t or -u options) per-thread mmaps are created.  This option overrides that and
+forces per-cpu mmaps.  A side-effect of that is that inheritance is
+automatically enabled.  Add the -i option also to disable inheritance.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4d644fe2d5b7..7c8020a32784 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -888,6 +888,8 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
+	OPT_BOOLEAN(0, "force-per-cpu", &record.opts.target.force_per_cpu,
+		    "force the use of per-cpu mmaps"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5ce2ace2d6c1..bbc746aa5716 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -819,7 +819,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target__has_task(target))
+	if (target->force_per_cpu)
+		evlist->cpus = cpu_map__new(target->cpu_list);
+	else if (target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 18f7c188ff63..46dd4c2a41ce 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -645,7 +645,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (target__has_cpu(&opts->target))
+	if (target__has_cpu(&opts->target) || opts->target.force_per_cpu)
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -653,7 +653,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     target__has_cpu(&opts->target)))
+	     target__has_cpu(&opts->target) || opts->target.force_per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 89bab7129de4..2d0c50690892 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -12,6 +12,7 @@ struct target {
 	uid_t	     uid;
 	bool	     system_wide;
 	bool	     uses_mmap;
+	bool	     force_per_cpu;
 };
 
 enum target_errno {
-- 
1.8.1.4

