Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3LKMpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:45:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:59606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab3LKMnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442370113"
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
Subject: [PATCH v0 64/71] perf tools: Hit all build ids when Instruction Tracing
Date: Wed, 11 Dec 2013 14:37:16 +0200
Message-Id: <1386765443-26966-65-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

We need to include all buildids when a perf.data
file contains Instruction Tracing data because we
do not decode the trace for that purpose because
it would take too long.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-buildid-list.c |  9 +++++++++
 tools/perf/builtin-inject.c       |  8 ++++++++
 tools/perf/builtin-record.c       | 10 +++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

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
index ce1f298..cafa6ab 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -26,6 +26,7 @@ struct perf_inject {
 	struct perf_tool tool;
 	bool		 build_ids;
 	bool		 sched_stat;
+	bool		 have_itrace;
 	const char	 *input_name;
 	int		 pipe_output,
 			 output;
@@ -120,6 +121,8 @@ static s64 perf_event__repipe_itrace(struct perf_tool *tool,
 						  tool);
 	int ret;
 
+	inject->have_itrace = true;
+
 	if (!inject->pipe_output) {
 		off_t offset;
 
@@ -544,6 +547,11 @@ static int __cmd_inject(struct perf_inject *inject)
 	ret = perf_session__process_events(session, &inject->tool);
 
 	if (!inject->pipe_output) {
+		if (inject->build_ids && inject->have_itrace) {
+			perf_header__set_feat(&session->header,
+					      HEADER_BUILD_ID);
+			dsos__hit_all(session);
+		}
 		/*
 		 * The instruction traces have been removed and replaced with
 		 * synthesized hardware events, so clear the feature flag.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b35963f..d51fba6 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -341,8 +341,16 @@ static void perf_record__exit(int status, void *arg)
 	if (!file->is_pipe) {
 		rec->session->header.data_size += rec->bytes_written;
 
-		if (!rec->no_buildid)
+		if (!rec->no_buildid) {
 			process_buildids(rec);
+			/*
+			 * We take all buildids when the file contains
+			 * Instruction Tracing data because we do not decode the
+			 * trace because it would take too long.
+			 */
+			if (perf_record_opts_itracing(&rec->opts))
+				dsos__hit_all(rec->session);
+		}
 		perf_session__write_header(rec->session, rec->evlist,
 					   file->fd, true);
 		perf_session__delete(rec->session);
-- 
1.8.5.1

