Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3HLKUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:20:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab3HLKUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:20:13 -0400
Date: Mon, 12 Aug 2013 03:19:26 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-9c5014022f5d5b09abc8b713da81b3d2db319699@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375473947-64285-4-git-send-email-dsahern@gmail.com>
References: <1375473947-64285-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Export a few functions for event processing
Git-Commit-ID: 9c5014022f5d5b09abc8b713da81b3d2db319699
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:19:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c5014022f5d5b09abc8b713da81b3d2db319699
Gitweb:     http://git.kernel.org/tip/9c5014022f5d5b09abc8b713da81b3d2db319699
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:41 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:27 -0300

perf session: Export a few functions for event processing

Allows kvm live mode to reuse the event processing and ordered samples
processing used by the perf-report path.

v2: removed flush_sample_queue as noticed by Jiri

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375473947-64285-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 12 ++++++------
 tools/perf/util/session.h |  7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a0ce5a4..b5ebd47 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -250,7 +250,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
-static void perf_tool__fill_defaults(struct perf_tool *tool)
+void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
 		tool->sample = process_event_sample_stub;
@@ -495,7 +495,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      u64 file_offset);
 
 static int flush_sample_queue(struct perf_session *s,
-			       struct perf_tool *tool)
+		       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
@@ -1049,10 +1049,10 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-static int perf_session__process_event(struct perf_session *session,
-				       union perf_event *event,
-				       struct perf_tool *tool,
-				       u64 file_offset)
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset)
 {
 	struct perf_sample sample;
 	int ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ad8d3d4..9818fc2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -56,6 +56,13 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool);
 
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset);
+
+void perf_tool__fill_defaults(struct perf_tool *tool);
+
 int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
 				    struct ip_callchain *chain,
