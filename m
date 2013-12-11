Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3LKMmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:35340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369839"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 57/71] perf record: Add Instruction Trace sampling support
Date: Wed, 11 Dec 2013 14:37:09 +0200
Message-Id: <1386765443-26966-58-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for Instruction Trace sampling.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt |  5 +++++
 tools/perf/builtin-record.c              | 15 +++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index bb01df7..58bd3c1 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -211,6 +211,11 @@ overrides that and uses per-thread mmaps.  A side-effect of that is that
 inheritance is automatically disabled.  --per-thread is ignored with a warning
 if combined with -a or -C options.
 
+-I::
+--itrace::
+Enable Instruction Trace sampling. Each sample captures the specified number of
+bytes (default 4096) of trace. Instruction Tracing config can also be specified.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 344603f..e75a15e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -401,7 +401,7 @@ static void perf_record__init_features(struct perf_record *rec)
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
-	if (!rec->opts.full_itrace)
+	if (!perf_record_opts_itracing(&rec->opts))
 		perf_header__clear_feat(&session->header, HEADER_ITRACE);
 }
 
@@ -507,13 +507,21 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
-	if (rec->opts.full_itrace) {
+	if (perf_record_opts_itracing(&rec->opts)) {
 		err = perf_event__synthesize_itrace_info(rec->itr, tool,
 					session, process_synthesized_event);
 		if (err)
 			goto out_delete_session;
 	}
 
+	if (rec->opts.sample_itrace) {
+		err = perf_event__synthesize_id_index(tool,
+						      process_synthesized_event,
+						      session->evlist, machine);
+		if (err)
+			goto out_delete_session;
+	}
+
 	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
 						 machine, "_text");
 	if (err < 0)
@@ -987,6 +995,9 @@ const struct option record_options[] = {
 		    "sample transaction flags (special events only)"),
 	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
 		    "use per-thread mmaps"),
+	OPT_CALLBACK_OPTARG('I', "itrace", &record.opts, &record.itr, "opts",
+			    "sample Instruction Trace",
+			    itrace_parse_sample_options),
 	OPT_END()
 };
 
-- 
1.8.5.1

