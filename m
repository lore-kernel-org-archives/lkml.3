Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3KFSm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:42:26 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52051 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3KFSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:41:49 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf record: Remove post_processing_offset variable
Date: Wed,  6 Nov 2013 11:41:36 -0700
Message-Id: <1383763297-27066-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duplicates the data_offset from header in the session.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
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
1.8.3.4 (Apple Git-47)

