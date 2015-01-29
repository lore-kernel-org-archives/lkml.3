Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbbA2ITT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:19:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51171 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbA2IKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:05 -0500
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
Subject: [PATCH 13/42] perf tools: Handle indexed data file properly
Date: Thu, 29 Jan 2015 17:06:54 +0900
Message-Id: <1422518843-25818-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf detects data file has index table, process header file first
and then rest data files in a row.  Note that the indexed data is
recorded for each cpu/thread separately, it's already ordered with
respect to themselves so no need to use the ordered event queue
interface.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/session.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 tools/perf/util/session.h |  5 +++++
 2 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0baf75f12b7c..ff4d5913220c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1251,11 +1251,10 @@ fetch_mmaped_event(struct perf_session *session,
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
@@ -1278,7 +1277,9 @@ static int __perf_session__process_events(struct perf_session *session,
 	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size) {
 		mmap_size = file_size;
-		session->one_mmap = true;
+
+		if (!perf_session__has_index(session))
+			session->one_mmap = true;
 	}
 
 	memset(mmaps, 0, sizeof(mmaps));
@@ -1360,19 +1361,43 @@ static int __perf_session__process_events(struct perf_session *session,
 int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool)
 {
-	u64 size = perf_data_file__size(session->file);
-	int err;
+	struct perf_data_file *file = session->file;
+	u64 size = perf_data_file__size(file);
+	int err, i;
 
 	if (perf_session__register_idle_thread(session) == NULL)
 		return -ENOMEM;
 
-	if (!perf_data_file__is_pipe(session->file))
+	if (perf_data_file__is_pipe(file))
+		return __perf_session__process_pipe_events(session, tool);
+
+	err = __perf_session__process_events(session,
+					     perf_data_file__fd(file),
+					     session->header.data_offset,
+					     session->header.data_size,
+					     size, tool);
+
+	if (err < 0 || !perf_session__has_index(session))
+		return err;
+
+	/*
+	 * For indexed data file, events are processed for
+	 * each cpu/thread so it's already ordered.
+	 */
+	tool->ordered_events = false;
+
+	for (i = 0; i < (int)session->header.nr_index; i++) {
+		if (!session->header.index[i].size)
+			continue;
+
 		err = __perf_session__process_events(session,
-						     session->header.data_offset,
-						     session->header.data_size,
-						     size, tool);
-	else
-		err = __perf_session__process_pipe_events(session, tool);
+						perf_data_file__fd(file),
+						session->header.index[i].offset,
+						session->header.index[i].size,
+						size, tool);
+		if (err < 0)
+			break;
+	}
 
 	return err;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6d663dc76404..419976d74b51 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -138,4 +138,9 @@ int perf_event__synthesize_id_index(struct perf_tool *tool,
 				    struct perf_evlist *evlist,
 				    struct machine *machine);
 
+static inline bool perf_session__has_index(struct perf_session *session)
+{
+	return perf_header__has_feat(&session->header, HEADER_DATA_INDEX);
+}
+
 #endif /* __PERF_SESSION_H */
-- 
2.2.2

