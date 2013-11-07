Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3KGPb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:31:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3KGPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:31:53 -0500
Date: Thu, 7 Nov 2013 07:31:12 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-7ab75cffd6a1b2195944b8522673522f09e7fcb0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383763297-27066-4-git-send-email-dsahern@gmail.com>
References: <1383763297-27066-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Remove post_processing_offset variable
Git-Commit-ID: 7ab75cffd6a1b2195944b8522673522f09e7fcb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:31:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ab75cffd6a1b2195944b8522673522f09e7fcb0
Gitweb:     http://git.kernel.org/tip/7ab75cffd6a1b2195944b8522673522f09e7fcb0
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 6 Nov 2013 11:41:36 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 11:01:59 -0300

perf record: Remove post_processing_offset variable

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
index 19c4db6..15280b5 100644
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
