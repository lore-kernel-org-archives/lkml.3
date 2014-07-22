Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaGVNaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:30:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:45426 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaGVNUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985766"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/52] perf session: Add ability to skip 4GiB or more
Date: Tue, 22 Jul 2014 16:17:30 +0300
Message-Id: <1406035081-14301-22-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A session can be made to skip portions of the input
file.  Do not limit that size to 32-bits.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8aa1be1..708e1c1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1026,8 +1026,10 @@ static int perf_session_deliver_event(struct perf_session *session,
 	}
 }
 
-static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
-					    struct perf_tool *tool, u64 file_offset)
+static s64 perf_session__process_user_event(struct perf_session *session,
+					    union perf_event *event,
+					    struct perf_tool *tool,
+					    u64 file_offset)
 {
 	int fd = perf_data_file__fd(session->file);
 	int err;
@@ -1073,7 +1075,7 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-static int perf_session__process_event(struct perf_session *session,
+static s64 perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
 				       u64 file_offset)
@@ -1184,7 +1186,7 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
 	union perf_event *event;
 	uint32_t size, cur_size = 0;
 	void *buf = NULL;
-	int skip = 0;
+	s64 skip = 0;
 	u64 head;
 	ssize_t err;
 	void *p;
@@ -1313,13 +1315,13 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 file_size, struct perf_tool *tool)
 {
 	int fd = perf_data_file__fd(session->file);
-	u64 head, page_offset, file_offset, file_pos;
+	u64 head, page_offset, file_offset, file_pos, size;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
 	char *buf, *mmaps[NUM_MMAPS];
 	union perf_event *event;
-	uint32_t size;
 	struct ui_progress prog;
+	s64 skip;
 
 	perf_tool__fill_defaults(tool);
 
@@ -1380,7 +1382,8 @@ more:
 	size = event->header.size;
 
 	if (size < sizeof(struct perf_event_header) ||
-	    perf_session__process_event(session, event, tool, file_pos) < 0) {
+	    (skip = perf_session__process_event(session, event, tool, file_pos))
+									< 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
 		       event->header.type);
@@ -1388,6 +1391,9 @@ more:
 		goto out_err;
 	}
 
+	if (skip)
+		size += skip;
+
 	head += size;
 	file_pos += size;
 
-- 
1.8.3.2

