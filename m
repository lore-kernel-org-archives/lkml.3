Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaLXHYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:24:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39521 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLXHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:51 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/37] perf tools: Use perf_data_file__fd() consistently
Date: Wed, 24 Dec 2014 16:14:59 +0900
Message-Id: <1419405333-27952-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not reference file->fd directly since we want hide the
implementation details from outside to support multi-file store.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-inject.c |  9 ++++++---
 tools/perf/builtin-record.c | 14 ++++++++------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84df2deed988..d8b13407594d 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -375,8 +375,10 @@ static int __cmd_inject(struct perf_inject *inject)
 		}
 	}
 
-	if (!file_out->is_pipe)
-		lseek(file_out->fd, session->header.data_offset, SEEK_SET);
+	if (!file_out->is_pipe) {
+		lseek(perf_data_file__fd(file_out), session->header.data_offset,
+		      SEEK_SET);
+	}
 
 	ret = perf_session__process_events(session, &inject->tool);
 
@@ -385,7 +387,8 @@ static int __cmd_inject(struct perf_inject *inject)
 			perf_header__set_feat(&session->header,
 					      HEADER_BUILD_ID);
 		session->header.data_size = inject->bytes_written;
-		perf_session__write_header(session, session->evlist, file_out->fd, true);
+		perf_session__write_header(session, session->evlist,
+					   perf_data_file__fd(file_out), true);
 	}
 
 	return ret;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index aa5fa6aabb31..054c6e57d3b9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -196,7 +196,7 @@ static int process_buildids(struct record *rec)
 	struct perf_session *session = rec->session;
 	u64 start = session->header.data_offset;
 
-	u64 size = lseek(file->fd, 0, SEEK_CUR);
+	u64 size = lseek(perf_data_file__fd(file), 0, SEEK_CUR);
 	if (size == 0)
 		return 0;
 
@@ -360,12 +360,12 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
 
 	if (file->is_pipe) {
-		err = perf_header__write_pipe(file->fd);
+		err = perf_header__write_pipe(perf_data_file__fd(file));
 		if (err < 0)
 			goto out_child;
 	} else {
 		err = perf_session__write_header(session, rec->evlist,
-						 file->fd, false);
+						 perf_data_file__fd(file), false);
 		if (err < 0)
 			goto out_child;
 	}
@@ -397,8 +397,10 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(tool, file->fd, rec->evlist,
-								  process_synthesized_event);
+			err = perf_event__synthesize_tracing_data(tool,
+						perf_data_file__fd(file),
+						rec->evlist,
+						process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
 				goto out_child;
@@ -541,7 +543,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (!rec->no_buildid)
 			process_buildids(rec);
 		perf_session__write_header(rec->session, rec->evlist,
-					   file->fd, true);
+					   perf_data_file__fd(&rec->file), true);
 	}
 
 out_delete_session:
-- 
2.1.3

