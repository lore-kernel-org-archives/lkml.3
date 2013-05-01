Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443Ab3EAPR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:17:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761464Ab3EAPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:17:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf stat: Add support to process formulas
Date: Wed,  1 May 2013 17:15:45 +0200
Message-Id: <1367421346-18257-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -f option to specify the formula configuration file
to load. The formula name itself is specified within the
'-e' option.

With following formula.conf config file:

---
cpi {
        events {
                CY = cycles:u
                IN = instructions:u
        }

        cpi = CY / IN

        print cpi
}

branch {
        events {
                IN = instructions:u
                BI = branch-instructions:u
                BM = branch-misses:u
        }

        branch-rate       = BI / IN
        branch-miss-rate  = BM / IN
        branch-miss-ratio = BM / BI

        print branch-rate
        print branch-miss-rate
        print branch-miss-ratio
}
---

You'll get following result:

  $ ./perf stat -f formula.conf -e formula-branch kill
  usage: kill [ -s signal | -p ] [ -a ] pid ...
         kill -l [ signal ]

   Performance counter stats for 'kill':

           187,342  instructions:u           #    0.00  insns per cycle
            41,996  branch-instructions:u
             4,826  branch-misses:u          #   11.49% of all branches

       0.054313993 seconds time elapsed

        0.22416757 branch-rate
        0.02576037 branch-miss-rate
        0.11491571 branch-miss-ratio

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7e910ba..b703307 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -56,6 +56,7 @@
 #include "util/cpumap.h"
 #include "util/thread.h"
 #include "util/thread_map.h"
+#include "util/formula.h"
 
 #include <stdlib.h>
 #include <sys/prctl.h>
@@ -72,6 +73,10 @@ static void print_aggr(char *prefix);
 
 static struct perf_evlist	*evsel_list;
 
+static struct perf_formula	 formula;
+static struct perf_formula_set	*formula_set;
+static bool			 formula_no_preload;
+
 static struct perf_target	target = {
 	.uid	= UINT_MAX,
 };
@@ -380,6 +385,12 @@ static void print_interval(void)
 	diff_timespec(&rs, &ts, &ref_time);
 	sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
 
+	if (formula_set) {
+		perf_formula__print(output, &formula, formula_set,
+				    evsel_list, NULL);
+		return;
+	}
+
 	if (num_print_interval == 0 && !csv_output) {
 		switch (aggr_mode) {
 		case AGGR_SOCKET:
@@ -1340,6 +1351,51 @@ static int add_default_attributes(void)
 	return perf_evlist__add_default_attrs(evsel_list, very_very_detailed_attrs);
 }
 
+static int formula_option(const struct option *opt __maybe_unused,
+			  const char *str, int unset __maybe_unused)
+{
+	if (perf_formula__load(&formula, (char *) str)) {
+		pr_err("formula: failed to load formula file '%s'\n", str);
+		return -1;
+	}
+
+	formula_no_preload = true;
+
+	pr_debug("formula file '%s'\n", str);
+	return 0;
+}
+
+static int formula_resolve(struct perf_evlist *evlist)
+{
+	char **f = evlist->formulas;
+	char *name = *f;
+
+	if (!formula_no_preload && perf_formula__preload(&formula)) {
+		pr_err("formula: failed to preload default formulas\n");
+		return -1;
+	}
+
+	if (f[1]) {
+		pr_err("formula: only single formula supported for stat\n");
+		return -1;
+	}
+
+	formula_set = perf_formula__set(&formula, name);
+	if (!formula_set) {
+		pr_err("formula: failed to find formula '%s'\n", name);
+		return -1;
+	}
+
+	if (perf_formula__evlist(&formula, formula_set, evlist)) {
+		pr_err("formula: failed to load formula events for %s\n",
+		       name);
+		return -1;
+	}
+
+	pr_debug("loaded formula '%s'\n", name);
+	return 0;
+}
+
 int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool append_file = false;
@@ -1351,6 +1407,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
+	OPT_CALLBACK('f', "formula", NULL, "formula",
+		     "counters formula file",
+		     formula_option),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_STRING('p', "pid", &target.pid, "pid",
@@ -1412,9 +1471,22 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
+	perf_formula__init(&formula);
+
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 
+	if (perf_evlist__has_formulas(evsel_list)) {
+		if (aggr_mode == AGGR_NONE) {
+			pr_err("formula: Cannot run formulas with "
+			       "no aggr mode\n");
+			return -1;
+		}
+
+		if (formula_resolve(evsel_list))
+			usage_with_options(stat_usage, options);
+	}
+
 	output = stderr;
 	if (output_name && strcmp(output_name, "-"))
 		output = NULL;
@@ -1540,13 +1612,22 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 	}
 
-	if (!forever && status != -1 && !interval)
+	if (!forever && status != -1 && !interval) {
 		print_stat(argc, argv);
 
+		if (formula_set)
+			perf_formula__print(output, &formula, formula_set,
+					    evsel_list, NULL);
+	}
+
 	perf_evlist__free_stats(evsel_list);
 out_free_maps:
 	perf_evlist__delete_maps(evsel_list);
 out:
 	perf_evlist__delete(evsel_list);
+
+	if (formula_set)
+		perf_formula__free(&formula);
+
 	return status;
 }
-- 
1.7.11.7

