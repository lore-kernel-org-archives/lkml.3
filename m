Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3AOORi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:17:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3AOORh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:17:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH 3/4] perf stat: Adding -f option to load and process ratios
Date: Tue, 15 Jan 2013 14:39:53 +0100
Message-Id: <1358257194-8204-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -f option to specify the formula definition to use.
Its value needs to be specified in following form:
  'file:set'

where 'file' is the formula definition file and the 'set'
is the name of the set to use for output.

With following formula.conf config file:
---
  cpi {
          events = {cycles,instructions}:u

          CPI {
                  formula = cycles / instructions
                  desc = cycles per instruction
          }
  }

  branch {
          events = {instructions,branch-instructions,branch-misses}:u

          branch-rate {
                  formula = branch-instructions / instructions
                  desc = branch rate
          }

          branch-miss-rate {
                  formula = branch-misses / instructions
                  desc = branch misprediction rate
          }

          branch-miss-ratio{
                  formula = branch-misses / branch-instructions
                  desc = branch misprediction ratio
          }
  }
---

You'll get following result:

  $ perf stat -f formula.conf:branch kill
  usage: kill [ -s signal | -p ] [ -a ] pid ...
         kill -l [ signal ]

   Performance counter stats for 'kill':

             184,195 instructions              #    0.00  insns per cycle
              40,907 branch-instructions
               4,815 branch-misses             #   11.77% of all branches

         0.000655767 seconds time elapsed

          0.22208529 branch-rate               #  branch rate
          0.02614077 branch-miss-rate          #  branch misprediction rate
          0.11770602 branch-miss-ratio         #  branch misprediction ratio

  $ perf stat -f formula.conf:cpi kill
  usage: kill [ -s signal | -p ] [ -a ] pid ...
         kill -l [ signal ]

   Performance counter stats for 'kill':

             356,635 cycles                    #    0.000 GHz
             187,191 instructions              #    0.52  insns per cycle

         0.001907600 seconds time elapsed

          1.90519309 CPI                       #  cycles per instruction

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
---
 tools/perf/builtin-stat.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1c2ac14..06f79e5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -56,6 +56,7 @@
 #include "util/cpumap.h"
 #include "util/thread.h"
 #include "util/thread_map.h"
+#include "util/formula.h"
 
 #include <stdlib.h>
 #include <sys/prctl.h>
@@ -67,6 +68,9 @@
 
 static struct perf_evlist	*evsel_list;
 
+static struct perf_formula	 formula;
+static struct perf_formula__set	*formula_set;
+
 static struct perf_target	target = {
 	.uid	= UINT_MAX,
 };
@@ -1065,6 +1069,42 @@ static int add_default_attributes(void)
 	return perf_evlist__add_default_attrs(evsel_list, very_very_detailed_attrs);
 }
 
+static int formula_option(const struct option *opt __maybe_unused,
+			  const char *str, int unset __maybe_unused)
+{
+	char *name;
+
+	if (no_aggr) {
+		pr_err("failed to run formulas with no aggr mode\n");
+		return -1;
+	}
+
+	name = strrchr(str, ':');
+	if (!name) {
+		pr_err("need to specify set name\n");
+		return -1;
+	}
+
+	*name++ = 0x0;
+
+	pr_debug("formula file '%s', name '%s'\n", str, name);
+
+	perf_formula__init(&formula);
+
+	if (perf_formula__load(&formula, (char *) str)) {
+		pr_err("failed to load formula file '%s'\n", str);
+		return -1;
+	}
+
+	formula_set = perf_formula__set(&formula, name);
+	if (!formula_set) {
+		pr_err("failed to find formula counter '%s'\n", name);
+		return -1;
+	}
+
+	return 0;
+}
+
 int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool append_file = false;
@@ -1076,6 +1116,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
+	OPT_CALLBACK('f', "formula", NULL, "formula",
+		     "counters formula, file[:name]",
+		     formula_option),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_STRING('p', "pid", &target.pid, "pid",
@@ -1134,6 +1177,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 
+	if (formula_set &&
+	    perf_formula__evlist(formula_set, evsel_list)) {
+		fprintf(stderr, "failed to load formula events\n");
+		usage_with_options(stat_usage, options);
+	}
+
 	output = stderr;
 	if (output_name && strcmp(output_name, "-"))
 		output = NULL;
@@ -1242,13 +1291,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		status = run_perf_stat(argc, argv);
 	}
 
-	if (status != -1)
+	if (status != -1) {
 		print_stat(argc, argv);
+
+		if (formula_set)
+			perf_formula__print(output, formula_set,
+					    evsel_list, NULL);
+	}
+
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list->entries, node)
 		perf_evsel__free_stat_priv(pos);
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

