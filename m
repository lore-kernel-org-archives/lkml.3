Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaKFPO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:14:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:59875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaKFPNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:13:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="632672592"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/2] perf tools: enable LBR call stack support
Date: Thu,  6 Nov 2014 09:58:05 -0500
Message-Id: <1415285886-16949-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
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
 tools/perf/builtin-record.c |  6 +++---
 tools/perf/builtin-report.c |  2 ++
 tools/perf/util/callchain.c |  8 ++++++++
 tools/perf/util/callchain.h |  1 +
 tools/perf/util/evsel.c     | 15 +++++++++++++--
 5 files changed, 27 insertions(+), 5 deletions(-)

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
index 0022980..72ed39b 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
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
+					"needed for -g lbr\n");
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
index 2f9e680..8c23607 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -537,13 +537,24 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
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
+			attr->exclude_user = 0;
+		} else
+			 pr_info("Cannot use LBR callstack with branch stack\n");
+	}
+
 	if (callchain_param.record_mode == CALLCHAIN_DWARF) {
 		if (!function) {
 			perf_evsel__set_sample_bit(evsel, REGS_USER);
@@ -659,7 +670,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 
 	if (callchain_param.enabled && !evsel->no_aux_samples)
-		perf_evsel__config_callgraph(evsel);
+		perf_evsel__config_callgraph(evsel, opts);
 
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
-- 
1.8.3.2

