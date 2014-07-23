Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaGWTVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:21:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:49203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbaGWTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:21:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="577755792"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf session: Add ability to skip 4GiB or more
Date: Wed, 23 Jul 2014 22:19:58 +0300
Message-Id: <1406143198-20732-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406143198-20732-1-git-send-email-adrian.hunter@intel.com>
References: <20140723144522.GO20303@kernel.org>
 <1406143198-20732-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A session can be made to skip portions of the input
file.  Do not limit that size to 32-bits.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9d468e6..708e1c1 100644
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
@@ -1313,14 +1315,13 @@ int __perf_session__process_events(struct perf_session *session,
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
1.8.3.2

