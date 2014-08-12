Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaHLGmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:42:45 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41222 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaHLGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 05/13] perf inject: Move session handling out of __cmd_inject()
Date: Tue, 12 Aug 2014 15:40:37 +0900
Message-Id: <1407825645-24586-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-inject.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ee875cca13b1..18eaefd3cd0c 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -23,6 +23,7 @@
 
 struct perf_inject {
 	struct perf_tool	tool;
+	struct perf_session	*session;
 	bool			build_ids;
 	bool			sched_stat;
 	const char		*input_name;
@@ -340,12 +341,8 @@ static int perf_evsel__check_stype(struct perf_evsel *evsel,
 
 static int __cmd_inject(struct perf_inject *inject)
 {
-	struct perf_session *session;
 	int ret = -EINVAL;
-	struct perf_data_file file = {
-		.path = inject->input_name,
-		.mode = PERF_DATA_MODE_READ,
-	};
+	struct perf_session *session = inject->session;
 	struct perf_data_file *file_out = &inject->output;
 
 	signal(SIGINT, sig_handler);
@@ -357,10 +354,6 @@ static int __cmd_inject(struct perf_inject *inject)
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(&file, true, &inject->tool);
-	if (session == NULL)
-		return -ENOMEM;
-
 	if (inject->build_ids) {
 		inject->tool.sample = perf_event__inject_buildid;
 	} else if (inject->sched_stat) {
@@ -396,8 +389,6 @@ static int __cmd_inject(struct perf_inject *inject)
 		perf_session__write_header(session, session->evlist, file_out->fd, true);
 	}
 
-	perf_session__delete(session);
-
 	return ret;
 }
 
@@ -427,6 +418,11 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.mode = PERF_DATA_MODE_WRITE,
 		},
 	};
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_READ,
+	};
+	int ret;
+
 	const struct option options[] = {
 		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
 			    "Inject build-ids into the output stream"),
@@ -461,8 +457,17 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		return -1;
 	}
 
+	file.path = inject.input_name;
+	inject.session = perf_session__new(&file, true, &inject.tool);
+	if (inject.session == NULL)
+		return -ENOMEM;
+
 	if (symbol__init() < 0)
 		return -1;
 
-	return __cmd_inject(&inject);
+	ret = __cmd_inject(&inject);
+
+	perf_session__delete(inject.session);
+
+	return ret;
 }
-- 
2.0.0

