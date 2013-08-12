Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3HLKXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:23:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:43 -0400
Date: Mon, 12 Aug 2013 03:23:03 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-e30b88a77cc8ae2a1febf268c8443a6cdd696417@git.kernel.org>
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
In-Reply-To: <1375753297-69645-2-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Export queue_event function
Git-Commit-ID: e30b88a77cc8ae2a1febf268c8443a6cdd696417
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:23:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e30b88a77cc8ae2a1febf268c8443a6cdd696417
Gitweb:     http://git.kernel.org/tip/e30b88a77cc8ae2a1febf268c8443a6cdd696417
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 5 Aug 2013 21:41:33 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:37 -0300

perf session: Export queue_event function

Taking a lesson from perf-trace and bringing in control of event
processing to perf-kvm-stat-live: parse the sample to get access the
time leaving just the need to queue it to the ordered samples list.  For
that the queue_event function needs to be exported.

Unexport perf_session__process_event.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375753297-69645-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 10 +++++-----
 tools/perf/util/session.h |  6 ++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ebd47..dedaeb2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -643,7 +643,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
-static int perf_session_queue_event(struct perf_session *s, union perf_event *event,
+int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
@@ -1049,10 +1049,10 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-int perf_session__process_event(struct perf_session *session,
-				union perf_event *event,
-				struct perf_tool *tool,
-				u64 file_offset)
+static int perf_session__process_event(struct perf_session *session,
+				       union perf_event *event,
+				       struct perf_tool *tool,
+				       u64 file_offset)
 {
 	struct perf_sample sample;
 	int ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9818fc2..8bed17e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -56,10 +56,8 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool);
 
-int perf_session__process_event(struct perf_session *session,
-				union perf_event *event,
-				struct perf_tool *tool,
-				u64 file_offset);
+int perf_session_queue_event(struct perf_session *s, union perf_event *event,
+			     struct perf_sample *sample, u64 file_offset);
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
