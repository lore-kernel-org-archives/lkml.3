Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaKMAev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:34:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:14182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbaKMAdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:33:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415729813"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 1/3] perf tools: enable LBR call stack support
Date: Wed, 12 Nov 2014 19:18:13 -0500
Message-Id: <1415837895-10275-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
References: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Currently, there are two call chain recording options, fp and dwarf.
Haswell has a new feature that utilizes the existing LBR facility to
record call chains. So it provides the third options to record call
chain. This patch enables the lbr call stack support.

LBR call stack has some limitations. It reuses current LBR facility, so
LBR call stack and branch record can not be enabled at the same time. It
is only available for user callchain.
However, LBR call stack can work on the user app which doesn't have
frame-pointer or dwarf debug info compiled. It is a good alternative
when nothing else works.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 10 ++++++++--
 tools/perf/builtin-record.c              |  6 +++---
 tools/perf/builtin-report.c              |  2 ++
 tools/perf/util/callchain.c              | 10 +++++++++-
 tools/perf/util/callchain.h              |  1 +
 tools/perf/util/evsel.c                  | 21 +++++++++++++++++++--
 6 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 398f8d5..0808460 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -100,13 +100,19 @@ OPTIONS
 	implies -g.
 
 	Allows specifying "fp" (frame pointer) or "dwarf"
-	(DWARF's CFI - Call Frame Information) as the method to collect
+	(DWARF's CFI - Call Frame Information) or "lbr"
+	(Hardware Last Branch Record facility) as the method to collect
 	the information used to show the call graphs.
 
 	In some systems, where binaries are build with gcc
-	--fomit-frame-pointer, using the "fp" method will produce bogus
+	--fomit-frame-pointer, using the "fp" method will produce bogus
 	call graphs, using "dwarf", if available (perf tools linked to
 	the libunwind library) should be used instead.
+	Using the "lbr" method doesn't require any compiler options. It
+	will produce call graphs from the hardware LBR registers. The
+	main limition is that it is only available on new Intel
+	platforms, such as Haswell. It can only get user call chain. It
+	doesn't work with branch stack sampling at the same time.
 
 -q::
 --quiet::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 582c4da..e486627 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -639,7 +639,7 @@ error:
 
 static void callchain_debug(void)
 {
-	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
+	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF", "LBR" };
 
 	pr_debug("callchain: type %s\n", str[callchain_param.record_mode]);
 
@@ -725,9 +725,9 @@ static struct record record = {
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf lbr";
 #else
-const char record_callchain_help[] = CALLCHAIN_HELP "fp";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp lbr";
 #endif
 
 /*
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 140a6cd..43babdb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -261,6 +261,8 @@ static int report__setup_sample_type(struct report *rep)
 		if ((sample_type & PERF_SAMPLE_REGS_USER) &&
 		    (sample_type & PERF_SAMPLE_STACK_USER))
 			callchain_param.record_mode = CALLCHAIN_DWARF;
+		else if (sample_type & PERF_SAMPLE_BRANCH_STACK)
+			callchain_param.record_mode = CALLCHAIN_LBR;
 		else
 			callchain_param.record_mode = CALLCHAIN_FP;
 	}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 0022980..2d98b86 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -77,7 +77,7 @@ int parse_callchain_record_opt(const char *arg)
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
-				       "needed for -g fp\n");
+				       "needed for --call-graph fp\n");
 			break;
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
@@ -97,6 +97,14 @@ int parse_callchain_record_opt(const char *arg)
 				callchain_param.dump_size = size;
 			}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
+		} else if (!strncmp(name, "lbr", sizeof("lbr"))) {
+			if (!strtok_r(NULL, ",", &saveptr)) {
+				callchain_param.record_mode = CALLCHAIN_LBR;
+				ret = 0;
+			} else
+				pr_err("callchain: No more arguments "
+					"needed for --call-graph lbr\n");
+			break;
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 3caccc2..c0d026f 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -11,6 +11,7 @@ enum perf_call_graph_mode {
 	CALLCHAIN_NONE,
 	CALLCHAIN_FP,
 	CALLCHAIN_DWARF,
+	CALLCHAIN_LBR,
 	CALLCHAIN_MAX
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 12b4396..7cbe2e9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -537,13 +537,30 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
 }
 
 static void
-perf_evsel__config_callgraph(struct perf_evsel *evsel)
+perf_evsel__config_callgraph(struct perf_evsel *evsel,
+			     struct record_opts *opts)
 {
 	bool function = perf_evsel__is_function_event(evsel);
 	struct perf_event_attr *attr = &evsel->attr;
 
 	perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
+	if (callchain_param.record_mode == CALLCHAIN_LBR) {
+		if (!opts->branch_stack) {
+			perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
+			attr->branch_sample_type = PERF_SAMPLE_BRANCH_USER |
+						PERF_SAMPLE_BRANCH_CALL_STACK;
+			if (attr->exclude_user) {
+				attr->exclude_user = 0;
+
+				pr_warning("LBR callstack option is only available"
+					   " to get user callchain information."
+					   " Force exclude_user to 0.\n");
+			}
+		} else
+			 pr_info("Cannot use LBR callstack with branch stack\n");
+	}
+
 	if (callchain_param.record_mode == CALLCHAIN_DWARF) {
 		if (!function) {
 			perf_evsel__set_sample_bit(evsel, REGS_USER);
@@ -659,7 +676,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 
 	if (callchain_param.enabled && !evsel->no_aux_samples)
-		perf_evsel__config_callgraph(evsel);
+		perf_evsel__config_callgraph(evsel, opts);
 
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
-- 
1.8.3.2

