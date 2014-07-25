Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaGYO5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760750AbaGYO5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:57:03 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/19] perf tools: Add ordered_events_init function
Date: Fri, 25 Jul 2014 16:56:10 +0200
Message-Id: <1406300177-31805-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ordered_events_init function for struct
ordered_events struct initialization.

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
index ecdc9012cadd..42d63396600c 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -193,3 +193,12 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 
 	return err;
 }
+
+void ordered_events_init(struct ordered_events *oe)
+{
+	INIT_LIST_HEAD(&oe->events);
+	INIT_LIST_HEAD(&oe->cache);
+	INIT_LIST_HEAD(&oe->to_free);
+	oe->max_alloc_size = (u64) -1;
+	oe->cur_alloc_size = 0;
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 30e39aa825ef..ce3f7f37b188 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -38,4 +38,5 @@ struct ordered_event *ordered_events_new(struct ordered_events *oe, u64 timestam
 void ordered_events_delete(struct ordered_events *oe, struct ordered_event *event);
 int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			 enum oe_flush how);
+void ordered_events_init(struct ordered_events *oe);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b67ea4b78478..40956a3164e8 100644
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
+	ordered_events_init(&session->ordered_events);
 	machines__init(&session->machines);
 
 	if (file) {
-- 
1.8.3.1

