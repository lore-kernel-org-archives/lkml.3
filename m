Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbaGQQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:52449 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934273AbaGQQOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:18 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/33] perf session: Flag if the event stream is entirely in memory
Date: Thu, 17 Jul 2014 13:12:21 -0300
Message-Id: <1405613555-23380-20-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Flag if the event stream is a file that has been mmapped in one go.

This is useful, for example, if a tool needs to keep an event for later
reference.  If the new flag is set, a pointer to the event can be
retained, otherwise the event must be copied.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-28-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 9 ++++++++-
 tools/perf/util/session.h | 3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c2f4ca917469..eac14ce0ae8d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1297,8 +1297,10 @@ int __perf_session__process_events(struct perf_session *session,
 	ui_progress__init(&prog, file_size, "Processing events...");
 
 	mmap_size = MMAP_SIZE;
-	if (mmap_size > file_size)
+	if (mmap_size > file_size) {
 		mmap_size = file_size;
+		session->one_mmap = true;
+	}
 
 	memset(mmaps, 0, sizeof(mmaps));
 
@@ -1320,6 +1322,10 @@ remap:
 	mmaps[map_idx] = buf;
 	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
 	file_pos = file_offset + head;
+	if (session->one_mmap) {
+		session->one_mmap_addr = buf;
+		session->one_mmap_offset = file_offset;
+	}
 
 more:
 	event = fetch_mmaped_event(session, head, mmap_size, buf);
@@ -1365,6 +1371,7 @@ out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
+	session->one_mmap = false;
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3140f8ae6148..0321013bd9fd 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -36,6 +36,9 @@ struct perf_session {
 	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
+	bool			one_mmap;
+	void			*one_mmap_addr;
+	u64			one_mmap_offset;
 	struct ordered_samples	ordered_samples;
 	struct perf_data_file	*file;
 };
-- 
1.9.3

