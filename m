Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbaGYPiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:35084 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760987AbaGYPiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:17 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/27] perf session: Add ability to skip 4GiB or more
Date: Fri, 25 Jul 2014 12:36:56 -0300
Message-Id: <1406302629-11790-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

A session can be made to skip portions of the input file.  Do not limit
that size to 32-bits.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406143198-20732-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f4399b2087c4..d3da1055239f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -994,8 +994,10 @@ static int perf_session_deliver_event(struct perf_session *session,
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
@@ -1037,7 +1039,7 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-static int perf_session__process_event(struct perf_session *session,
+static s64 perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
 				       u64 file_offset)
@@ -1148,7 +1150,7 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
 	union perf_event *event;
 	uint32_t size, cur_size = 0;
 	void *buf = NULL;
-	int skip = 0;
+	s64 skip = 0;
 	u64 head;
 	ssize_t err;
 	void *p;
@@ -1277,14 +1279,13 @@ int __perf_session__process_events(struct perf_session *session,
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
-	int skip;
+	s64 skip;
 
 	perf_tool__fill_defaults(tool);
 
-- 
1.9.3

