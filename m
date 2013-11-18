Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3KRJtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:49:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:2056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3KRJss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:48:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,722,1378882800"; 
   d="scan'208";a="435266901"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf record: Make per-cpu mmaps the default.
Date: Mon, 18 Nov 2013 11:55:54 +0200
Message-Id: <1384768557-23331-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This affects the -p, -t and -u options that
previously defaulted to per-thread mmaps.
A side-effect is that inheritance is
automatically enabled by default.  A later
patch will disable it by default for the -t
option.

Consequently add an option to select
per-thread mmaps to support the old
behaviour.

Note that per-thread can be used with a
workload-only (i.e. none of -p, -t, -u,
-a or -C is selected) to get a per-thread
mmap with no inheritance.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Requested-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Documentation/perf-record.txt     | 10 +++++-----
 tools/perf/builtin-record.c                  |  5 +++--
 tools/perf/tests/attr/test-record-no-inherit |  2 +-
 tools/perf/util/evlist.c                     |  6 ++++--
 tools/perf/util/evsel.c                      |  5 +++--
 tools/perf/util/target.c                     | 11 ++++++++++-
 tools/perf/util/target.h                     |  4 +++-
 7 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 43b42c4..6ac867e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -201,11 +201,11 @@ abort events and some memory events in precise mode on modern Intel CPUs.
 --transaction::
 Record transaction flags for transaction related events.
 
---force-per-cpu::
-Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
--t or -u options) per-thread mmaps are created.  This option overrides that and
-forces per-cpu mmaps.  A side-effect of that is that inheritance is
-automatically enabled.  Add the -i option also to disable inheritance.
+--per-thread::
+Use per-thread mmaps.  By default per-cpu mmaps are created.  This option
+overrides that and uses per-thread mmaps.  A side-effect of that is that
+inheritance is automatically disabled.  --per-thread is ignored with a warning
+if combined with -a or -C options.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7c8020a..f5b18b8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -800,6 +800,7 @@ static struct perf_record record = {
 		.freq		     = 4000,
 		.target		     = {
 			.uses_mmap   = true,
+			.default_per_cpu = true,
 		},
 	},
 };
@@ -888,8 +889,8 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
-	OPT_BOOLEAN(0, "force-per-cpu", &record.opts.target.force_per_cpu,
-		    "force the use of per-cpu mmaps"),
+	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
+		    "use per-thread mmaps"),
 	OPT_END()
 };
 
diff --git a/tools/perf/tests/attr/test-record-no-inherit b/tools/perf/tests/attr/test-record-no-inherit
index 9079a25..44edcb2 100644
--- a/tools/perf/tests/attr/test-record-no-inherit
+++ b/tools/perf/tests/attr/test-record-no-inherit
@@ -3,5 +3,5 @@ command = record
 args    = -i kill >/dev/null 2>&1
 
 [event:base-record]
-sample_type=259
+sample_type=263
 inherit=0
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bbc746a..76fa764 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -819,8 +819,10 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->force_per_cpu)
-		evlist->cpus = cpu_map__new(target->cpu_list);
+	if (target->default_per_cpu)
+		evlist->cpus = target->per_thread ?
+					cpu_map__dummy_new() :
+					cpu_map__new(target->cpu_list);
 	else if (target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!target__has_cpu(target) && !target->uses_mmap)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 46dd4c2..77e38ff 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -572,6 +572,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	struct perf_evsel *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
+	bool per_cpu = opts->target.default_per_cpu && !opts->target.per_thread;
 
 	attr->sample_id_all = perf_missing_features.sample_id_all ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
@@ -645,7 +646,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (target__has_cpu(&opts->target) || opts->target.force_per_cpu)
+	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -653,7 +654,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     target__has_cpu(&opts->target) || opts->target.force_per_cpu))
+	     target__has_cpu(&opts->target) || per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3c778a0..e74c596 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -55,6 +55,13 @@ enum target_errno target__validate(struct target *target)
 			ret = TARGET_ERRNO__UID_OVERRIDE_SYSTEM;
 	}
 
+	/* THREAD and SYSTEM/CPU are mutually exclusive */
+	if (target->per_thread && (target->system_wide || target->cpu_list)) {
+		target->per_thread = false;
+		if (ret == TARGET_ERRNO__SUCCESS)
+			ret = TARGET_ERRNO__SYSTEM_OVERRIDE_THREAD;
+	}
+
 	return ret;
 }
 
@@ -100,6 +107,7 @@ static const char *target__error_str[] = {
 	"UID switch overriding CPU",
 	"PID/TID switch overriding SYSTEM",
 	"UID switch overriding SYSTEM",
+	"SYSTEM/CPU switch overriding PER-THREAD",
 	"Invalid User: %s",
 	"Problems obtaining information for user %s",
 };
@@ -131,7 +139,8 @@ int target__strerror(struct target *target, int errnum,
 	msg = target__error_str[idx];
 
 	switch (errnum) {
-	case TARGET_ERRNO__PID_OVERRIDE_CPU ... TARGET_ERRNO__UID_OVERRIDE_SYSTEM:
+	case TARGET_ERRNO__PID_OVERRIDE_CPU ...
+	     TARGET_ERRNO__SYSTEM_OVERRIDE_THREAD:
 		snprintf(buf, buflen, "%s", msg);
 		break;
 
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 2d0c506..31dd2e9 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -12,7 +12,8 @@ struct target {
 	uid_t	     uid;
 	bool	     system_wide;
 	bool	     uses_mmap;
-	bool	     force_per_cpu;
+	bool	     default_per_cpu;
+	bool	     per_thread;
 };
 
 enum target_errno {
@@ -33,6 +34,7 @@ enum target_errno {
 	TARGET_ERRNO__UID_OVERRIDE_CPU,
 	TARGET_ERRNO__PID_OVERRIDE_SYSTEM,
 	TARGET_ERRNO__UID_OVERRIDE_SYSTEM,
+	TARGET_ERRNO__SYSTEM_OVERRIDE_THREAD,
 
 	/* for target__parse_uid() */
 	TARGET_ERRNO__INVALID_UID,
-- 
1.7.11.7

