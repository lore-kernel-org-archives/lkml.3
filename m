Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaKKOVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:21:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:64540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaKKOUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152340"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 25/25] perf tools: Hit all build ids when Instruction Tracing
Date: Tue, 11 Nov 2014 16:17:03 +0200
Message-Id: <1415715423-15563-26-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to include all buildids when a perf.data
file contains Instruction Tracing data because we
do not decode the trace for that purpose because
it would take too long.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-buildid-list.c |  9 +++++++++
 tools/perf/builtin-inject.c       |  8 +++++++-
 tools/perf/builtin-record.c       | 10 +++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index ed3873b..d694309 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -69,6 +69,15 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	session = perf_session__new(&file, false, &build_id__mark_dso_hit_ops);
 	if (session == NULL)
 		return -1;
+
+	/*
+	 * We take all buildids when the file contains Instruction Tracing data
+	 * because we do not decode the trace because it would take too long.
+	 */
+	if (!perf_data_file__is_pipe(&file) &&
+	    perf_header__has_feat(&session->header, HEADER_ITRACE))
+		with_hits = false;
+
 	/*
 	 * in pipe-mode, the only way to get the buildids is to parse
 	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 4d0fe53..285f159 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -27,6 +27,7 @@ struct perf_inject {
 	struct perf_session	*session;
 	bool			build_ids;
 	bool			sched_stat;
+	bool			have_itrace;
 	const char		*input_name;
 	struct perf_data_file	output;
 	u64			bytes_written;
@@ -115,6 +116,8 @@ static s64 perf_event__repipe_itrace(struct perf_tool *tool,
 						  tool);
 	int ret;
 
+	inject->have_itrace = true;
+
 	if (!inject->output.is_pipe) {
 		off_t offset;
 
@@ -502,9 +505,12 @@ static int __cmd_inject(struct perf_inject *inject)
 	ret = perf_session__process_events(session, &inject->tool);
 
 	if (!file_out->is_pipe) {
-		if (inject->build_ids)
+		if (inject->build_ids) {
 			perf_header__set_feat(&session->header,
 					      HEADER_BUILD_ID);
+			if (inject->have_itrace)
+				dsos__hit_all(session);
+		}
 		/*
 		 * The instruction traces have been removed and replaced with
 		 * synthesized hardware events, so clear the feature flag.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 62211b9..475082f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -613,8 +613,16 @@ out_child:
 	if (!err && !file->is_pipe) {
 		rec->session->header.data_size += rec->bytes_written;
 
-		if (!rec->no_buildid)
+		if (!rec->no_buildid) {
 			process_buildids(rec);
+			/*
+			 * We take all buildids when the file contains
+			 * Instruction Tracing data because we do not decode the
+			 * trace because it would take too long.
+			 */
+			if (rec->opts.full_itrace)
+				dsos__hit_all(rec->session);
+		}
 		perf_session__write_header(rec->session, rec->evlist,
 					   file->fd, true);
 	}
-- 
1.9.1

