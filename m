Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaHNIrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:47:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaHNIq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:46:57 -0400
Date: Thu, 14 Aug 2014 01:46:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-1cb8bdcca0e2f738a492c3857568cf34ba4a4373@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-6-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject:
  Move session handling out of __cmd_inject()
Git-Commit-ID: 1cb8bdcca0e2f738a492c3857568cf34ba4a4373
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cb8bdcca0e2f738a492c3857568cf34ba4a4373
Gitweb:     http://git.kernel.org/tip/1cb8bdcca0e2f738a492c3857568cf34ba4a4373
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:37 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:32:39 -0300

perf inject: Move session handling out of __cmd_inject()

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ee875cc..18eaefd 100644
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
