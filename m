Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbaGYO4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760602AbaGYO4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:56:50 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/19] perf tools: Limit ordered events queue size
Date: Fri, 25 Jul 2014 16:56:05 +0200
Message-Id: <1406300177-31805-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
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
index f94ec7e55749..ebb87318c073 100644
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
@@ -520,7 +522,7 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 static struct ordered_event *alloc_event(struct ordered_events *oe)
 {
 	struct list_head *cache = &oe->cache;
-	struct ordered_event *new;
+	struct ordered_event *new = NULL;
 
 	if (!list_empty(cache)) {
 		new = list_entry(cache->next, struct ordered_event, list);
@@ -529,10 +531,14 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		new = oe->buffer + oe->buffer_idx;
 		if (++oe->buffer_idx == MAX_SAMPLE_BUFFER)
 			oe->buffer = NULL;
-	} else {
-		oe->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+	} else if (oe->cur_alloc_size < oe->max_alloc_size) {
+		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
+
+		oe->buffer = malloc(size);
 		if (!oe->buffer)
 			return NULL;
+
+		oe->cur_alloc_size += size;
 		list_add(&oe->buffer->list, &oe->to_free);
 
 		/* First entry is abused to maintain the to_free list. */
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 419eb50e1cd3..e2fbaf2567e1 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,6 +20,8 @@ struct ordered_events {
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

