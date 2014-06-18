Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaFRO7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaFRO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:44 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/18] perf tools: Add ordered_events_queue_init function
Date: Wed, 18 Jun 2014 16:58:53 +0200
Message-Id: <1403103539-16807-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ordered_events_queue_init function for struct
ordered_events_queue initialization.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/ordered-events.c | 9 +++++++++
 tools/perf/util/ordered-events.h | 1 +
 tools/perf/util/session.c        | 6 +-----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 022be55..42b1bbc 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -192,3 +192,12 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 
 	return err;
 }
+
+void ordered_events_queue_init(struct ordered_events_queue *q)
+{
+	INIT_LIST_HEAD(&q->events);
+	INIT_LIST_HEAD(&q->cache);
+	INIT_LIST_HEAD(&q->to_free);
+	q->max_alloc_size = (u64) -1;
+	q->cur_alloc_size = 0;
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index c0dc00e..0633b09 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -40,4 +40,5 @@ void ordered_event_put(struct ordered_events_queue *q,
 		       struct ordered_event *iter);
 int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			 enum oeq_flush how);
+void ordered_events_queue_init(struct ordered_events_queue *q);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2b97ada..59d13a7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -76,11 +76,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		goto out;
 
 	session->repipe = repipe;
-	INIT_LIST_HEAD(&session->ordered_events.events);
-	INIT_LIST_HEAD(&session->ordered_events.cache);
-	INIT_LIST_HEAD(&session->ordered_events.to_free);
-	session->ordered_events.max_alloc_size = (u64) -1;
-	session->ordered_events.cur_alloc_size = 0;
+	ordered_events_queue_init(&session->ordered_events);
 	machines__init(&session->machines);
 
 	if (file) {
-- 
1.8.3.1

