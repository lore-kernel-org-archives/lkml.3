Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaHDQTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:19:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:38996 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbaHDQTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:19:06 -0400
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
Subject: [PATCH 11/33] perf tools: Limit ordered events queue size
Date: Mon,  4 Aug 2014 13:17:22 -0300
Message-Id: <1407169064-25625-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Add limit to the ordered events queue allocation. This way we will be
able to control the size of the queue buffers.

There's no limit at the moment (it's set to (u64) -1). The config code
will come in following patches.

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
Link: http://lkml.kernel.org/n/tip-lw1ny3mk4ctb6su5ght5rsng@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 12 +++++++++---
 tools/perf/util/session.h |  2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 72c7b0d3d0dc..8d4538c91076 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -78,6 +78,8 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	INIT_LIST_HEAD(&session->ordered_events.events);
 	INIT_LIST_HEAD(&session->ordered_events.cache);
 	INIT_LIST_HEAD(&session->ordered_events.to_free);
+	session->ordered_events.max_alloc_size = (u64) -1;
+	session->ordered_events.cur_alloc_size = 0;
 	machines__init(&session->machines);
 
 	if (file) {
@@ -518,7 +520,7 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 static struct ordered_event *alloc_event(struct ordered_events *oe)
 {
 	struct list_head *cache = &oe->cache;
-	struct ordered_event *new;
+	struct ordered_event *new = NULL;
 
 	if (!list_empty(cache)) {
 		new = list_entry(cache->next, struct ordered_event, list);
@@ -527,10 +529,14 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
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
1.9.3

