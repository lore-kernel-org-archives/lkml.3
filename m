Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743AbaGRE0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:26:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGRE02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:26:28 -0400
Date: Thu, 17 Jul 2014 21:25:36 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-919d86d3a3109d7d4f0d7347f34711ee2f8e6609@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-28-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-28-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Flag if the event stream is entirely in memory
Git-Commit-ID: 919d86d3a3109d7d4f0d7347f34711ee2f8e6609
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  919d86d3a3109d7d4f0d7347f34711ee2f8e6609
Gitweb:     http://git.kernel.org/tip/919d86d3a3109d7d4f0d7347f34711ee2f8e6609
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:51 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:36 -0300

perf session: Flag if the event stream is entirely in memory

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
index c2f4ca9..eac14ce 100644
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
