Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3LCHRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:17:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:32337 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab3LCHPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838578"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/7] perf script: Add an option to print the source line number
Date: Tue,  3 Dec 2013 09:23:05 +0200
Message-Id: <1386055390-13757-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add field 'srcline' that displays the source file name
and line number associated with the sample ip.  The
information displayed is the same as from addr2line.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-script.txt |  2 +-
 tools/perf/builtin-script.c              | 29 +++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index cfdbb1e..c2a5071 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff.
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff, srcline.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5b865a9..9d0febc 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -43,6 +43,7 @@ enum perf_output_field {
 	PERF_OUTPUT_DSO             = 1U << 9,
 	PERF_OUTPUT_ADDR            = 1U << 10,
 	PERF_OUTPUT_SYMOFFSET       = 1U << 11,
+	PERF_OUTPUT_SRCLINE         = 1U << 12,
 };
 
 struct output_option {
@@ -61,6 +62,7 @@ struct output_option {
 	{.str = "dso",   .field = PERF_OUTPUT_DSO},
 	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
 	{.str = "symoff", .field = PERF_OUTPUT_SYMOFFSET},
+	{.str = "srcline", .field = PERF_OUTPUT_SRCLINE},
 };
 
 /* default set to maintain compatibility with current format */
@@ -210,6 +212,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		       "to DSO.\n");
 		return -EINVAL;
 	}
+	if (PRINT_FIELD(SRCLINE) && !PRINT_FIELD(IP)) {
+		pr_err("Display of source line number requested but sample IP is not\n"
+		       "selected. Hence, no address to lookup the source line number.\n");
+		return -EINVAL;
+	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
 		perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID",
@@ -348,6 +355,24 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 }
 
+static void print_sample_finish(struct perf_evsel *evsel,
+				struct addr_location *al)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
+	if (PRINT_FIELD(SRCLINE) && al->map && al->map->dso) {
+		char *srcline;
+
+		srcline = get_srcline(al->map->dso,
+				      map__rip_2objdump(al->map, al->addr));
+		if (srcline != SRCLINE_UNKNOWN)
+			printf("\n  %s", srcline);
+		free_srcline(srcline);
+	}
+
+	printf("\n");
+}
+
 static bool is_bts_event(struct perf_event_attr *attr)
 {
 	return ((attr->type == PERF_TYPE_HARDWARE) &&
@@ -438,7 +463,7 @@ static void print_sample_bts(union perf_event *event,
 	     !output[attr->type].user_set))
 		print_sample_addr(event, sample, machine, thread, attr);
 
-	printf("\n");
+	print_sample_finish(evsel, al);
 }
 
 static void process_event(union perf_event *event, struct perf_sample *sample,
@@ -480,7 +505,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 				     PERF_MAX_STACK_DEPTH);
 	}
 
-	printf("\n");
+	print_sample_finish(evsel, al);
 }
 
 static int default_start_script(const char *script __maybe_unused,
-- 
1.7.11.7

