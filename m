Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaHMFQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:16:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44942 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaHMFQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:16:30 -0400
Date: Tue, 12 Aug 2014 22:16:08 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-urraa8ccay4o14wambjraws7@git.kernel.org>
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
Subject: [tip:perf/core] perf tools: Add ordered_events__free function
Git-Commit-ID: adc56ed1e01f1c43fc7bf75340f11f4ad5e11145
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

Commit-ID:  adc56ed1e01f1c43fc7bf75340f11f4ad5e11145
Gitweb:     http://git.kernel.org/tip/adc56ed1e01f1c43fc7bf75340f11f4ad5e11145
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Tue, 10 Jun 2014 22:50:03 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:00 -0300

perf tools: Add ordered_events__free function

Adding ordered_events__free function to release all the struct
ordered_events data. It's replacement for former
perf_session_free_sample_buffers function.

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
Link: http://lkml.kernel.org/n/tip-urraa8ccay4o14wambjraws7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ordered-events.c | 11 +++++++++++
 tools/perf/util/ordered-events.h |  1 +
 tools/perf/util/session.c        | 17 ++---------------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 7b8923e..381d5fe 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -202,3 +202,14 @@ void ordered_events__init(struct ordered_events *oe)
 	oe->max_alloc_size = (u64) -1;
 	oe->cur_alloc_size = 0;
 }
+
+void ordered_events__free(struct ordered_events *oe)
+{
+	while (!list_empty(&oe->to_free)) {
+		struct ordered_event *event;
+
+		event = list_entry(oe->to_free.next, struct ordered_event, list);
+		list_del(&event->list);
+		free(event);
+	}
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 62f9945..6036bd6 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -39,4 +39,5 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
 void ordered_events__init(struct ordered_events *oe);
+void ordered_events__free(struct ordered_events *oe);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7f5851e..7d8dbf2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -442,19 +442,6 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-static void perf_session_free_sample_buffers(struct perf_session *session)
-{
-	struct ordered_events *oe = &session->ordered_events;
-
-	while (!list_empty(&oe->to_free)) {
-		struct ordered_event *event;
-
-		event = list_entry(oe->to_free.next, struct ordered_event, list);
-		list_del(&event->list);
-		free(event);
-	}
-}
-
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
@@ -1092,7 +1079,7 @@ done:
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events__free(&session->ordered_events);
 	return err;
 }
 
@@ -1237,7 +1224,7 @@ out:
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events__free(&session->ordered_events);
 	session->one_mmap = false;
 	return err;
 }
