Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3K0URv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:17:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab3K0URI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/34] perf record: Make per-cpu mmaps the default.
Date: Wed, 27 Nov 2013 17:16:10 -0300
Message-Id: <1385583394-3703-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

This affects the -p, -t and -u options that previously defaulted to
per-thread mmaps.

Consequently add an option to select per-thread mmaps to support the old
behaviour.

Note that per-thread can be used with a workload-only (i.e. none of -p,
-t, -u, -a or -C is selected) to get a per-thread mmap with no
inheritance.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/5286271D.3020808@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 43b42c4f4a91..6ac867e7667f 100644
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
index 7c8020a32784..f5b18b8fe8c9 100644
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
index 9079a25cd643..44edcb2edcd5 100644
--- a/tools/perf/tests/attr/test-record-no-inherit
+++ b/tools/perf/tests/attr/test-record-no-inherit
@@ -3,5 +3,5 @@ command = record
 args    = -i kill >/dev/null 2>&1
 
 [event:base-record]
-sample_type=259
+sample_type=263
 inherit=0
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bbc746aa5716..76fa76431329 100644
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
index dad64926170f..b5fe7f9b2e15 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -574,6 +574,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	struct perf_evsel *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
+	bool per_cpu = opts->target.default_per_cpu && !opts->target.per_thread;
 
 	attr->sample_id_all = perf_missing_features.sample_id_all ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
@@ -647,7 +648,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (target__has_cpu(&opts->target) || opts->target.force_per_cpu)
+	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -655,7 +656,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     target__has_cpu(&opts->target) || opts->target.force_per_cpu))
+	     target__has_cpu(&opts->target) || per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3c778a07b7cc..e74c5963dc7a 100644
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
index 2d0c50690892..31dd2e9a27d0 100644
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
1.8.1.4

