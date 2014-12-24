Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaLXHXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:23:22 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39600 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaLXHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:52 -0500
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
Subject: [PATCH 08/37] perf tools: Handle multi-file session properly
Date: Wed, 24 Dec 2014 16:15:04 +0900
Message-Id: <1419405333-27952-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf detects multi-file data directory, process header file first
and then rest data files in a row.  Note that the multi-file data is
recorded for each cpu/thread separately, it's already ordered with
respect to themselves so no need to use the ordered event queue
interface.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/data.c    | 17 +++++++++++++++++
 tools/perf/util/session.c | 41 +++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 8dacd34659cc..b6f7cdc4a39f 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -52,6 +52,21 @@ static int check_backup(struct perf_data_file *file)
 	return 0;
 }
 
+static void check_multi(struct perf_data_file *file)
+{
+	struct stat st;
+
+	/*
+	 * For write, it'll be determined by user (perf record -M)
+	 * whether to enable multi file data storage.
+	 */
+	if (perf_data_file__is_write(file))
+		return;
+
+	if (!stat(file->path, &st) && S_ISDIR(st.st_mode))
+		file->is_multi = true;
+}
+
 static int scandir_filter(const struct dirent *d)
 {
 	return !prefixcmp(d->d_name, "perf.data.");
@@ -206,6 +221,8 @@ int perf_data_file__open(struct perf_data_file *file)
 	if (check_pipe(file))
 		return 0;
 
+	check_multi(file);
+
 	if (!file->path)
 		file->path = default_data_path(file);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 88aa2f09df93..4f0fcd2d3901 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1252,11 +1252,10 @@ fetch_mmaped_event(struct perf_session *session,
 #define NUM_MMAPS 128
 #endif
 
-static int __perf_session__process_events(struct perf_session *session,
+static int __perf_session__process_events(struct perf_session *session, int fd,
 					  u64 data_offset, u64 data_size,
 					  u64 file_size, struct perf_tool *tool)
 {
-	int fd = perf_data_file__fd(session->file);
 	u64 head, page_offset, file_offset, file_pos, size;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
@@ -1362,18 +1361,40 @@ int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool)
 {
 	u64 size = perf_data_file__size(session->file);
-	int err;
+	int err, i;
 
 	if (perf_session__register_idle_thread(session) == NULL)
 		return -ENOMEM;
 
-	if (!perf_data_file__is_pipe(session->file))
-		err = __perf_session__process_events(session,
-						     session->header.data_offset,
-						     session->header.data_size,
-						     size, tool);
-	else
-		err = __perf_session__process_pipe_events(session, tool);
+	if (perf_data_file__is_pipe(session->file))
+		return __perf_session__process_pipe_events(session, tool);
+
+	err = __perf_session__process_events(session,
+					     perf_data_file__fd(session->file),
+					     session->header.data_offset,
+					     session->header.data_size,
+					     size, tool);
+	if (!session->file->is_multi || err)
+		return err;
+
+	/*
+	 * For multi-file data storage, events are processed for each
+	 * cpu/thread so it's already ordered.
+	 */
+	tool->ordered_events = false;
+
+	for (i = 0; i < session->file->nr_multi; i++) {
+		int fd = perf_data_file__multi_fd(session->file, i);
+
+		size = lseek(fd, 0, SEEK_END);
+		if (size == 0)
+			continue;
+
+		err = __perf_session__process_events(session, fd,
+						     0, size, size, tool);
+		if (err < 0)
+			break;
+	}
 
 	return err;
 }
-- 
2.1.3

