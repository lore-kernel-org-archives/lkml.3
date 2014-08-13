Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaHMFPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:15:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44834 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaHMFPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:15:03 -0400
Date: Tue, 12 Aug 2014 22:14:44 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-lw1ny3mk4ctb6su5ght5rsng@git.kernel.org>
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
Subject: [tip:perf/core] perf tools: Limit ordered events queue size
Git-Commit-ID: 8d99a6ceebe862ac4afd832cdab332ee7b3b5599
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

Commit-ID:  8d99a6ceebe862ac4afd832cdab332ee7b3b5599
Gitweb:     http://git.kernel.org/tip/8d99a6ceebe862ac4afd832cdab332ee7b3b5599
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 11 Jun 2014 15:09:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:57 -0300

perf tools: Limit ordered events queue size

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
index 72c7b0d..8d4538c 100644
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
index 419eb50..e2fbaf2 100644
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
