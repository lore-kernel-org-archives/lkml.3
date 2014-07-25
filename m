Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbaGYPoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:44:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:35060 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760970AbaGYPiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:12 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/27] perf session: Add ability to 'skip' a non-piped event stream
Date: Fri, 25 Jul 2014 12:36:55 -0300
Message-Id: <1406302629-11790-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

A piped event stream may contain arbitary sized tracepoint information
following a PERF_RECORD_HEADER_TRACING_DATA event.  The position in the
stream has to be 'skipped' to match the start of the next event.

Provide the same ability to a non-piped event stream to allow for
Instruction Trace data that may also be in a non-piped event stream.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406143198-20732-1-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index eac14ce0ae8d..f4399b2087c4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1284,6 +1284,7 @@ int __perf_session__process_events(struct perf_session *session,
 	union perf_event *event;
 	uint32_t size;
 	struct ui_progress prog;
+	int skip;
 
 	perf_tool__fill_defaults(tool);
 
@@ -1344,7 +1345,8 @@ more:
 	size = event->header.size;
 
 	if (size < sizeof(struct perf_event_header) ||
-	    perf_session__process_event(session, event, tool, file_pos) < 0) {
+	    (skip = perf_session__process_event(session, event, tool, file_pos))
+									< 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
 		       event->header.type);
@@ -1352,6 +1354,9 @@ more:
 		goto out_err;
 	}
 
+	if (skip)
+		size += skip;
+
 	head += size;
 	file_pos += size;
 
-- 
1.9.3

