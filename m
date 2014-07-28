Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaG1IZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:25:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaG1IZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:25:33 -0400
Date: Mon, 28 Jul 2014 01:24:40 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-6f917c70998d22bda6d06cb168665068c6066cd4@git.kernel.org>
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
In-Reply-To: <1406143198-20732-1-git-send-email-adrian.hunter@intel.com>
References: <1406143198-20732-1-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Add ability to 'skip'
  a non-piped event stream
Git-Commit-ID: 6f917c70998d22bda6d06cb168665068c6066cd4
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

Commit-ID:  6f917c70998d22bda6d06cb168665068c6066cd4
Gitweb:     http://git.kernel.org/tip/6f917c70998d22bda6d06cb168665068c6066cd4
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 23 Jul 2014 22:19:57 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:00:46 -0300

perf session: Add ability to 'skip' a non-piped event stream

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
index eac14ce..f4399b2 100644
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
 
