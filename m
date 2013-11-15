Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3KOH1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:27:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab3KOH0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:51 -0500
Date: Thu, 14 Nov 2013 23:25:55 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-539e6bb71e350541105e67e3d6c31392d9da25ef@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record:
  Add an option to force per-cpu mmaps
Git-Commit-ID: 539e6bb71e350541105e67e3d6c31392d9da25ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:26:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  539e6bb71e350541105e67e3d6c31392d9da25ef
Gitweb:     http://git.kernel.org/tip/539e6bb71e350541105e67e3d6c31392d9da25ef
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:34 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:10:27 -0300

perf record: Add an option to force per-cpu mmaps

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
index 052f7c4..43b42c4 100644
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
index 4d644fe..7c8020a 100644
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
index 5ce2ace..bbc746a 100644
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
index 18f7c18..46dd4c2 100644
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
index 89bab71..2d0c506 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -12,6 +12,7 @@ struct target {
 	uid_t	     uid;
 	bool	     system_wide;
 	bool	     uses_mmap;
+	bool	     force_per_cpu;
 };
 
 enum target_errno {
