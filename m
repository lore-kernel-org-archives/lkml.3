Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3JVHfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:35:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:12361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3JVHfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958473"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 09/14] perf record: Add an option to force per-cpu mmaps
Date: Tue, 22 Oct 2013 10:34:13 +0300
Message-Id: <1382427258-17495-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, when tasks are specified (i.e. -p, -t
or -u options) per-thread mmaps are created.  Add
an option to override that and force per-cpu mmaps.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 6 ++++++
 tools/perf/builtin-record.c              | 2 ++
 tools/perf/util/evlist.c                 | 4 +++-
 tools/perf/util/evsel.c                  | 4 ++--
 tools/perf/util/target.h                 | 1 +
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index f10ab63..2ea6685 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -189,6 +189,12 @@ abort events and some memory events in precise mode on modern Intel CPUs.
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
index ab8d15e..4c0657f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -860,6 +860,8 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
+	OPT_BOOLEAN(0, "force-per-cpu", &record.opts.target.force_per_cpu,
+		    "force the use of per-cpu mmaps"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4bc2a3a..9e2b98c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -792,7 +792,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (perf_target__has_task(target))
+	if (target->force_per_cpu)
+		evlist->cpus = cpu_map__new(target->cpu_list);
+	else if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e09c7e6..f1839b0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -645,7 +645,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (perf_target__has_cpu(&opts->target))
+	if (perf_target__has_cpu(&opts->target) || opts->target.force_per_cpu)
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -653,7 +653,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     perf_target__has_cpu(&opts->target)))
+	     perf_target__has_cpu(&opts->target) || opts->target.force_per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index a4be857..6d7efbd 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -12,6 +12,7 @@ struct perf_target {
 	uid_t	     uid;
 	bool	     system_wide;
 	bool	     uses_mmap;
+	bool	     force_per_cpu;
 };
 
 enum perf_target_errno {
-- 
1.7.11.7

