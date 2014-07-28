Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaG1IZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:25:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaG1IZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:25:53 -0400
Date: Mon, 28 Jul 2014 01:24:54 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d5652d865ea734a13a16cf563937291a84d4364d@git.kernel.org>
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
In-Reply-To: <1406143198-20732-2-git-send-email-adrian.hunter@intel.com>
References: <1406143198-20732-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Add ability to skip 4GiB or more
Git-Commit-ID: d5652d865ea734a13a16cf563937291a84d4364d
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

Commit-ID:  d5652d865ea734a13a16cf563937291a84d4364d
Gitweb:     http://git.kernel.org/tip/d5652d865ea734a13a16cf563937291a84d4364d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 23 Jul 2014 22:19:58 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:07:14 -0300

perf session: Add ability to skip 4GiB or more

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
index f4399b2..d3da105 100644
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
 
