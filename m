Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LKMjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:53589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3LKMjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448280109"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 18/71] perf session: Flag if the event stream is entirely in memory
Date: Wed, 11 Dec 2013 14:36:30 +0200
Message-Id: <1386765443-26966-19-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index 8a7da6f..10ac07a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1305,8 +1305,10 @@ int __perf_session__process_events(struct perf_session *session,
 	ui_progress__init(&prog, file_size, "Processing events...");
 
 	mmap_size = MMAP_SIZE;
-	if (mmap_size > file_size)
+	if (mmap_size > file_size) {
 		mmap_size = file_size;
+		session->one_mmap = true;
+	}
 
 	memset(mmaps, 0, sizeof(mmaps));
 
@@ -1328,6 +1330,10 @@ remap:
 	mmaps[map_idx] = buf;
 	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
 	file_pos = file_offset + head;
+	if (session->one_mmap) {
+		session->one_mmap_addr = buf;
+		session->one_mmap_offset = file_offset;
+	}
 
 more:
 	event = fetch_mmaped_event(session, head, mmap_size, buf);
@@ -1373,6 +1379,7 @@ out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
+	session->one_mmap = false;
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 004d3e8..ca1d734 100644
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
1.8.5.1

