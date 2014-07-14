Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaGNKMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:12:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:41983 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbaGNKFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434615"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 27/41] perf session: Flag if the event stream is entirely in memory
Date: Mon, 14 Jul 2014 13:02:51 +0300
Message-Id: <1405332185-4050-28-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flag if the event stream is a file that has been mmapped
in one go.

This is useful, for example, if a tool needs to keep an
event for later reference.  If the new flag is set, a
pointer to the event can be retained, otherwise the
event must be copied.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 9 ++++++++-
 tools/perf/util/session.h | 3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c1abe6b..7b0fb03 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1319,8 +1319,10 @@ int __perf_session__process_events(struct perf_session *session,
 	ui_progress__init(&prog, file_size, "Processing events...");
 
 	mmap_size = MMAP_SIZE;
-	if (mmap_size > file_size)
+	if (mmap_size > file_size) {
 		mmap_size = file_size;
+		session->one_mmap = true;
+	}
 
 	memset(mmaps, 0, sizeof(mmaps));
 
@@ -1342,6 +1344,10 @@ remap:
 	mmaps[map_idx] = buf;
 	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
 	file_pos = file_offset + head;
+	if (session->one_mmap) {
+		session->one_mmap_addr = buf;
+		session->one_mmap_offset = file_offset;
+	}
 
 more:
 	event = fetch_mmaped_event(session, head, mmap_size, buf);
@@ -1387,6 +1393,7 @@ out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
+	session->one_mmap = false;
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3140f8a..0321013 100644
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
1.8.3.2

