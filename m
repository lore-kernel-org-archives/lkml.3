Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaFLWJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:09:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFLWJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:09:21 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/17] perf tools: Limit ordered events queue size
Date: Fri, 13 Jun 2014 00:08:23 +0200
Message-Id: <1402610913-19059-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add limit to the ordered events queue allocation. This way
we will be able to control the size of the queue buffers.

There's no limit at the moment (it's set to (u64) -1). The config
code will come in following patches.

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
 tools/perf/util/session.c | 12 +++++++++---
 tools/perf/util/session.h |  2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 76df5c9..1ff4695 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -79,6 +79,8 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	INIT_LIST_HEAD(&session->ordered_events.events);
 	INIT_LIST_HEAD(&session->ordered_events.cache);
 	INIT_LIST_HEAD(&session->ordered_events.to_free);
+	session->ordered_events.max_alloc_size = (u64) -1;
+	session->ordered_events.cur_alloc_size = 0;
 	machines__init(&session->machines);
 
 	if (file) {
@@ -520,7 +522,7 @@ static void queue_event(struct ordered_events_queue *q, struct ordered_event *ne
 static struct ordered_event *alloc_event(struct ordered_events_queue *q)
 {
 	struct list_head *cache = &q->cache;
-	struct ordered_event *new;
+	struct ordered_event *new = NULL;
 
 	if (!list_empty(cache)) {
 		new = list_entry(cache->next, struct ordered_event, list);
@@ -529,10 +531,14 @@ static struct ordered_event *alloc_event(struct ordered_events_queue *q)
 		new = q->buffer + q->buffer_idx;
 		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
 			q->buffer = NULL;
-	} else {
-		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+	} else if (q->cur_alloc_size < q->max_alloc_size) {
+		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
+
+		q->buffer = malloc(size);
 		if (!q->buffer)
 			return NULL;
+
+		q->cur_alloc_size += size;
 		list_add(&q->buffer->list, &q->to_free);
 		q->buffer_idx = 2;
 		new = q->buffer + 1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 76b897f..9f64ac9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,6 +20,8 @@ struct ordered_events_queue {
 	u64			last_flush;
 	u64			next_flush;
 	u64			max_timestamp;
+	u64			max_alloc_size;
+	u64			cur_alloc_size;
 	struct list_head	events;
 	struct list_head	cache;
 	struct list_head	to_free;
-- 
1.8.3.1

