Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaHDQTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:19:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:39057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaHDQTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:19:17 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/33] perf tools: Make perf_session__deliver_event global
Date: Mon,  4 Aug 2014 13:17:24 -0300
Message-Id: <1407169064-25625-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Making perf_session__deliver_event global function, as it will be called
from another object in following patch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-rz7s2b8uwv567bigckh75gvk@git.kernel.org
[ Fixup naming to match class__method schema, as now is more widely exposed ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 23 ++++++++---------------
 tools/perf/util/session.h |  5 +++++
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bd2483b6b446..ed6b7f14631f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -571,12 +571,6 @@ ordered_events__delete(struct ordered_events *oe, struct ordered_event *event)
 	oe->nr_events--;
 }
 
-static int perf_session_deliver_event(struct perf_session *session,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_tool *tool,
-				      u64 file_offset);
-
 static int __ordered_events__flush(struct perf_session *s,
 				   struct perf_tool *tool)
 {
@@ -607,8 +601,8 @@ static int __ordered_events__flush(struct perf_session *s,
 		if (ret)
 			pr_err("Can't parse sample, err = %d\n", ret);
 		else {
-			ret = perf_session_deliver_event(s, iter->event, &sample, tool,
-							 iter->file_offset);
+			ret = perf_session__deliver_event(s, iter->event, &sample, tool,
+							  iter->file_offset);
 			if (ret)
 				return ret;
 		}
@@ -1003,11 +997,10 @@ perf_session__deliver_sample(struct perf_session *session,
 					    &sample->read.one, machine);
 }
 
-static int perf_session_deliver_event(struct perf_session *session,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_tool *tool,
-				      u64 file_offset)
+int perf_session__deliver_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_tool *tool, u64 file_offset)
 {
 	struct perf_evsel *evsel;
 	struct machine *machine;
@@ -1152,8 +1145,8 @@ static s64 perf_session__process_event(struct perf_session *session,
 			return ret;
 	}
 
-	return perf_session_deliver_event(session, event, &sample, tool,
-					  file_offset);
+	return perf_session__deliver_event(session, event, &sample, tool,
+					   file_offset);
 }
 
 void perf_event_header__bswap(struct perf_event_header *hdr)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a09e3c8d825a..03da1cb14dc1 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -72,6 +72,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
+int perf_session__deliver_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_tool *tool, u64 file_offset);
+
 int perf_session__resolve_callchain(struct perf_session *session,
 				    struct perf_evsel *evsel,
 				    struct thread *thread,
-- 
1.9.3

