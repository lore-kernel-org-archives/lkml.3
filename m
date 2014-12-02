Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaLBP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:27:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:44693 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaLBP0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:26:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492314841"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, namhyung@kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V5 1/3] perf tools: enable LBR call stack support
Date: Tue,  2 Dec 2014 10:06:52 -0500
Message-Id: <1417532814-26208-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
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
 tools/perf/Documentation/perf-record.txt |  8 +++++++-
 tools/perf/builtin-record.c              |  6 +++---
 tools/perf/builtin-report.c              |  2 ++
 tools/perf/util/callchain.c              | 10 +++++++++-
 tools/perf/util/callchain.h              |  1 +
 tools/perf/util/evsel.c                  | 21 +++++++++++++++++++--
 6 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index af9a54e..d10cb2c 100644
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
 	--fomit-frame-pointer, using the "fp" method will produce bogus
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
index 8648c6d..6a68c85 100644
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
index 3936760..635bf65 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -262,6 +262,8 @@ static int report__setup_sample_type(struct report *rep)
 		if ((sample_type & PERF_SAMPLE_REGS_USER) &&
 		    (sample_type & PERF_SAMPLE_STACK_USER))
 			callchain_param.record_mode = CALLCHAIN_DWARF;
+		else if (sample_type & PERF_SAMPLE_BRANCH_STACK)
+			callchain_param.record_mode = CALLCHAIN_LBR;
 		else
 			callchain_param.record_mode = CALLCHAIN_FP;
 	}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index cf524a3..64c8913 100644
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
index dbc08cf..b4b61d1 100644
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
index 1e90c85..3430bdf 100644
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
+			if (attr->exclude_user) {
+				pr_warning("LBR callstack option is only available "
+					   "to get user callchain information. "
+					   "Falling back to framepointers.\n");
+			} else {
+				perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
+				attr->branch_sample_type = PERF_SAMPLE_BRANCH_USER |
+							PERF_SAMPLE_BRANCH_CALL_STACK;
+			}
+		} else
+			 pr_warning("Cannot use LBR callstack with branch stack. "
+				    "Falling back to framepointers.\n");
+	}
+
 	if (callchain_param.record_mode == CALLCHAIN_DWARF) {
 		if (!function) {
 			perf_evsel__set_sample_bit(evsel, REGS_USER);
@@ -667,7 +684,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		evsel->attr.exclude_callchain_user = 1;
 
 	if (callchain_param.enabled && !evsel->no_aux_samples)
-		perf_evsel__config_callgraph(evsel);
+		perf_evsel__config_callgraph(evsel, opts);
 
 	if (opts->sample_intr_regs) {
 		attr->sample_regs_intr = PERF_REGS_MASK;
-- 
1.8.3.2

