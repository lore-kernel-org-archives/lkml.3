Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3KGPFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:05:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab3KGPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/7] perf record: Remove post_processing_offset variable
Date: Thu,  7 Nov 2013 12:04:17 -0300
Message-Id: <1383836658-10518-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383836658-10518-1-git-send-email-acme@infradead.org>
References: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Duplicates the data_offset from header in the session.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383763297-27066-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 19c4db6bdd6f..15280b5e5574 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -74,7 +74,6 @@ struct perf_record {
 	bool			no_buildid;
 	bool			no_buildid_cache;
 	long			samples;
-	off_t			post_processing_offset;
 };
 
 static int write_output(struct perf_record *rec, void *buf, size_t size)
@@ -247,13 +246,14 @@ static int process_buildids(struct perf_record *rec)
 {
 	struct perf_data_file *file  = &rec->file;
 	struct perf_session *session = rec->session;
+	u64 start = session->header.data_offset;
 
 	u64 size = lseek(file->fd, 0, SEEK_CUR);
 	if (size == 0)
 		return 0;
 
-	return __perf_session__process_events(session, rec->post_processing_offset,
-					      size - rec->post_processing_offset,
+	return __perf_session__process_events(session, start,
+					      size - start,
 					      size, &build_id__mark_dso_hit_ops);
 }
 
@@ -429,8 +429,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
-	rec->post_processing_offset = lseek(file->fd, 0, SEEK_CUR);
-
 	machine = &session->machines.host;
 
 	if (file->is_pipe) {
-- 
1.8.1.4

