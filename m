Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaHMFPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:15:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaHMFPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:15:38 -0400
Date: Tue, 12 Aug 2014 22:15:09 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-rz7s2b8uwv567bigckh75gvk@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make perf_session__deliver_event global
Git-Commit-ID: 79a30fe4f3758c98e1b7a474952b9701d513e580
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

Commit-ID:  79a30fe4f3758c98e1b7a474952b9701d513e580
Gitweb:     http://git.kernel.org/tip/79a30fe4f3758c98e1b7a474952b9701d513e580
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Tue, 10 Jun 2014 22:31:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:58 -0300

perf tools: Make perf_session__deliver_event global

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
---
 tools/perf/util/session.c | 23 ++++++++---------------
 tools/perf/util/session.h |  5 +++++
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bd2483b..ed6b7f1 100644
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
index a09e3c8..03da1cb 100644
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
