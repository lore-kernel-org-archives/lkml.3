Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbbA2IKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:11 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51004 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbbA2IKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:00 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/42] perf tools: Use perf_data_file__fd() consistently
Date: Thu, 29 Jan 2015 17:06:48 +0900
Message-Id: <1422518843-25818-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not reference file->fd directly since we want hide the
implementation details from outside for possible future changes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-inject.c |  5 +++--
 tools/perf/builtin-record.c | 14 +++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84df2deed988..a13641e066f5 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -343,6 +343,7 @@ static int __cmd_inject(struct perf_inject *inject)
 	int ret = -EINVAL;
 	struct perf_session *session = inject->session;
 	struct perf_data_file *file_out = &inject->output;
+	int fd = perf_data_file__fd(file_out);
 
 	signal(SIGINT, sig_handler);
 
@@ -376,7 +377,7 @@ static int __cmd_inject(struct perf_inject *inject)
 	}
 
 	if (!file_out->is_pipe)
-		lseek(file_out->fd, session->header.data_offset, SEEK_SET);
+		lseek(fd, session->header.data_offset, SEEK_SET);
 
 	ret = perf_session__process_events(session, &inject->tool);
 
@@ -385,7 +386,7 @@ static int __cmd_inject(struct perf_inject *inject)
 			perf_header__set_feat(&session->header,
 					      HEADER_BUILD_ID);
 		session->header.data_size = inject->bytes_written;
-		perf_session__write_header(session, session->evlist, file_out->fd, true);
+		perf_session__write_header(session, session->evlist, fd, true);
 	}
 
 	return ret;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9900b433e861..404ab3434052 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -208,7 +208,7 @@ static int process_buildids(struct record *rec)
 	struct perf_data_file *file  = &rec->file;
 	struct perf_session *session = rec->session;
 
-	u64 size = lseek(file->fd, 0, SEEK_CUR);
+	u64 size = lseek(perf_data_file__fd(file), 0, SEEK_CUR);
 	if (size == 0)
 		return 0;
 
@@ -334,6 +334,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	struct perf_data_file *file = &rec->file;
 	struct perf_session *session;
 	bool disabled = false, draining = false;
+	int fd;
 
 	rec->progname = argv[0];
 
@@ -348,6 +349,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		return -1;
 	}
 
+	fd = perf_data_file__fd(file);
 	rec->session = session;
 
 	record__init_features(rec);
@@ -372,12 +374,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
 
 	if (file->is_pipe) {
-		err = perf_header__write_pipe(file->fd);
+		err = perf_header__write_pipe(fd);
 		if (err < 0)
 			goto out_child;
 	} else {
-		err = perf_session__write_header(session, rec->evlist,
-						 file->fd, false);
+		err = perf_session__write_header(session, rec->evlist, fd, false);
 		if (err < 0)
 			goto out_child;
 	}
@@ -409,7 +410,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(tool, file->fd, rec->evlist,
+			err = perf_event__synthesize_tracing_data(tool,	fd, rec->evlist,
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
@@ -545,8 +546,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 		if (!rec->no_buildid)
 			process_buildids(rec);
-		perf_session__write_header(rec->session, rec->evlist,
-					   file->fd, true);
+		perf_session__write_header(rec->session, rec->evlist, fd, true);
 	}
 
 	if (!err && !quiet) {
-- 
2.2.2

