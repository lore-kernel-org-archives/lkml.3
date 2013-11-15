Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3KOKxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:53:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:18148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3KOKx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:53:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409285911"
Message-ID: <5285FECE.7020802@intel.com>
Date: Fri, 15 Nov 2013 13:00:30 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
References: <1384460715-23198-1-git-send-email-acme@infradead.org> <1384460715-23198-11-git-send-email-acme@infradead.org> <20131115060643.GA9237@gmail.com>
In-Reply-To: <20131115060643.GA9237@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/13 08:06, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
>> +--force-per-cpu::
>> + Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
>> + -t or -u options) per-thread mmaps are created.  This option overrides that and
>> + forces per-cpu mmaps.  A side-effect of that is that inheritance is
>> + automatically enabled.  Add the -i option also to disable inheritance.
> 
> So I still haven't seen an explanation why it's called 'force' 
> anything. AFAICS nothing is 'forced' really, this is simply another 
> trace-ringbuffer setup method, right?

The option itself does not determine whether or not per-cpu mmaps are used.
For example you cannot get a per-thread mmap for a workload by:

    perf record --no-force-per-cpu ls

So the option, as implemented, is a modifier of other options, not an option
in itself.  That is why its called 'force'.

To drop 'force':




From: Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 15 Nov 2013 09:40:00 +0200
Subject: [PATCH] perf record: Drop 'force' from --force-per-cpu option

'force' is confusing so rename the option and
change the documentation accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 10 +++++-----
 tools/perf/builtin-record.c              |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 43b42c4..98a7d66 100644
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
+--per-cpu::
+Use per-cpu mmaps.  By default, when tasks are specified (i.e. -p, -t or -u
+options) per-thread mmaps are created.  This option overrides that and uses
+per-cpu mmaps.  A side-effect of that is that inheritance is automatically
+enabled.  Add the -i option also to disable inheritance.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7c8020a..56ca57d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -888,8 +888,8 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
-	OPT_BOOLEAN(0, "force-per-cpu", &record.opts.target.force_per_cpu,
-		    "force the use of per-cpu mmaps"),
+	OPT_BOOLEAN(0, "per-cpu", &record.opts.target.force_per_cpu,
+		    "use per-cpu mmaps"),
 	OPT_END()
 };
 
-- 
1.7.11.7




But really then --no-per-cpu needs to be implemented:




From: Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 15 Nov 2013 10:26:50 +0200
Subject: [PATCH 2/2] perf record: Allow --no-per-cpu to select per-thread
 mmaps

The effect of --no-per-cpu is:

	-p, -t, -u	no difference
	-C, -a		no difference (causes a
			warning)
	otherwise	record the workload as a
			single thread i.e.
			no-inheritance

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 20 ++++++++++++++++++--
 tools/perf/util/evlist.c    |  2 +-
 tools/perf/util/target.c    | 11 ++++++++++-
 tools/perf/util/target.h    |  2 ++
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 56ca57d..d2dbb01 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -776,6 +776,22 @@ int record_callchain_opt(const struct option *opt,
 	return 0;
 }
 
+static int parse_per_cpu(const struct option *opt,
+			 const char *arg __maybe_unused, int unset)
+{
+	struct target *target = opt->value;
+
+	if (unset) {
+		target->force_per_cpu = false;
+		target->force_per_thread = true;
+	} else {
+		target->force_per_cpu = true;
+		target->force_per_thread = false;
+	}
+
+	return 0;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -888,8 +904,8 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
-	OPT_BOOLEAN(0, "per-cpu", &record.opts.target.force_per_cpu,
-		    "use per-cpu mmaps"),
+	OPT_CALLBACK_NOOPT(0, "per-cpu", &record.opts.target, "per-cpu",
+			   "use per-cpu mmaps", parse_per_cpu),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bbc746a..3ed4674 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -821,7 +821,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 
 	if (target->force_per_cpu)
 		evlist->cpus = cpu_map__new(target->cpu_list);
-	else if (target__has_task(target))
+	else if (target__has_task(target) || target->force_per_thread)
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3c778a0..11d4527 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -55,6 +55,13 @@ enum target_errno target__validate(struct target *target)
 			ret = TARGET_ERRNO__UID_OVERRIDE_SYSTEM;
 	}
 
+	if (target->force_per_thread &&
+	    (target->system_wide || target->cpu_list)) {
+		target->force_per_thread = false;
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
+	"SYSTEM/CPU switch overriding NO-PER-CPU",
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
index 2d0c506..65494c1b 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -13,6 +13,7 @@ struct target {
 	bool	     system_wide;
 	bool	     uses_mmap;
 	bool	     force_per_cpu;
+	bool	     force_per_thread;
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




> 
> And I also raised why this shouldn't be the default event tracing 
> method instead of a weird config option. Per-cpu tracing is cache 
> compact, it is easier to size properly and in general it is pretty 
> easy to think about. (It also has less of the TSC timestamp ordering 
> problems as per thread tracing, at least in theory.)
> 
> Is there something that makes per cpu tracing undesirable as the 
> default?

One reason is to avoid changing the meaning of existing options.

To flip it around, ignore the patches above and apply:



From: Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 15 Nov 2013 11:17:56 +0200
Subject: [PATCH] perf record: Make per-cpu mmaps the default.

This affects the -p, -t and -u options that
previously defaulted to per-thread mmaps.

Consequently add an option to select
per-thread mmaps to support the old
behaviour.

Note that per-thread can be used with a
workload-only (i.e. none of -p, -t, -u,
-a or -C is selected) to get a per-thread
mmap with no inheritance.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 10 +++++-----
 tools/perf/builtin-record.c              |  5 +++--
 tools/perf/util/evlist.c                 |  6 ++++--
 tools/perf/util/evsel.c                  |  4 ++--
 tools/perf/util/target.c                 | 11 ++++++++++-
 tools/perf/util/target.h                 |  4 +++-
 6 files changed, 27 insertions(+), 13 deletions(-)

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
index 46dd4c2..18f7c18 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -645,7 +645,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (target__has_cpu(&opts->target) || opts->target.force_per_cpu)
+	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -653,7 +653,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     target__has_cpu(&opts->target) || opts->target.force_per_cpu))
+	     target__has_cpu(&opts->target)))
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





