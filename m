Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbaGWTVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:21:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:49203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbaGWTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:21:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="577755756"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf session: Add ability to 'skip' a non-piped event stream
Date: Wed, 23 Jul 2014 22:19:57 +0300
Message-Id: <1406143198-20732-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140723144522.GO20303@kernel.org>
References: <20140723144522.GO20303@kernel.org>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A piped event stream may contain arbitary sized tracepoint
information following a PERF_RECORD_HEADER_TRACING_DATA
event.  The position in the stream has to be 'skipped'
to match the start of the next event.

Provide the same ability to a non-piped event stream
to allow for Instruction Trace data that may also be
in a non-piped event stream.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8aa1be1..9d468e6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1320,6 +1320,7 @@ int __perf_session__process_events(struct perf_session *session,
 	union perf_event *event;
 	uint32_t size;
 	struct ui_progress prog;
+	int skip;
 
 	perf_tool__fill_defaults(tool);
 
@@ -1380,7 +1381,8 @@ more:
 	size = event->header.size;
 
 	if (size < sizeof(struct perf_event_header) ||
-	    perf_session__process_event(session, event, tool, file_pos) < 0) {
+	    (skip = perf_session__process_event(session, event, tool, file_pos))
+									< 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
 		       event->header.type);
@@ -1388,6 +1390,9 @@ more:
 		goto out_err;
 	}
 
+	if (skip)
+		size += skip;
+
 	head += size;
 	file_pos += size;
 
-- 
1.8.3.2

