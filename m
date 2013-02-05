Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3BEVMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:12:51 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:33896 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3BEVMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:12:49 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf: make event_copy local to mmaps
Date: Tue,  5 Feb 2013 14:12:42 -0700
Message-Id: <1360098762-61827-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting segfaults *after* the time sorting of perf samples where
the event type is off the charts:

(gdb) bt
\#0  0x0807b1b2 in hists__inc_nr_events (hists=0x80a99c4, type=1163281902) at util/hist.c:1225
\#1  0x08070795 in perf_session_deliver_event (session=0x80a9b90, event=0xf7a6aff8, sample=0xffffc318, tool=0xffffc520,
    file_offset=0) at util/session.c:884
\#2  0x0806f9b9 in flush_sample_queue (s=0x80a9b90, tool=0xffffc520) at util/session.c:555
\#3  0x0806fc53 in process_finished_round (tool=0xffffc520, event=0x0, session=0x80a9b90) at util/session.c:645

This is bizarre because the event has already been processed once --
before it was added to the samples queue -- and the event was found to
be sane at that time.

There seem to be 2 causes:
1. perf_evlist__mmap_read updates the read location even though there
are outstanding references to events sitting in the mmap buffers via the
ordered samples queue.

2. There is a single evlist->event_copy for all evlist entries. event_copy
is used to handle an event wrapping at the mmap buffer boundary.

This patch addresses the second problem - making event_copy local to each
perf_mmap. With this change my highly repeatable use case no longer fails.

The first problem is much more complicated and will be the subject of a
future patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/perf.h        |   26 --------------------------
 tools/perf/util/evlist.c |    4 ++--
 tools/perf/util/evlist.h |   29 ++++++++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 8f3bf38..c2206c8 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -103,32 +103,6 @@
 #include "util/types.h"
 #include <stdbool.h>
 
-struct perf_mmap {
-	void			*base;
-	int			mask;
-	unsigned int		prev;
-};
-
-static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
-{
-	struct perf_event_mmap_page *pc = mm->base;
-	int head = pc->data_head;
-	rmb();
-	return head;
-}
-
-static inline void perf_mmap__write_tail(struct perf_mmap *md,
-					 unsigned long tail)
-{
-	struct perf_event_mmap_page *pc = md->base;
-
-	/*
-	 * ensure all reads are done before we write the tail out.
-	 */
-	/* mb(); */
-	pc->data_tail = tail;
-}
-
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
  * counters in the current task.
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index eddd5eb..8fe4e52 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -376,7 +376,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 		if ((old & md->mask) + size != ((old + size) & md->mask)) {
 			unsigned int offset = old;
 			unsigned int len = min(sizeof(*event), size), cpy;
-			void *dst = &evlist->event_copy;
+			void *dst = &md->event_copy;
 
 			do {
 				cpy = min(md->mask + 1 - (offset & md->mask), len);
@@ -386,7 +386,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 				len -= cpy;
 			} while (len);
 
-			event = &evlist->event_copy;
+			event = &md->event_copy;
 		}
 
 		old += size;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 73579a2..2dd07bd 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -17,6 +17,13 @@ struct perf_record_opts;
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
+struct perf_mmap {
+	void		 *base;
+	int		 mask;
+	unsigned int	 prev;
+	union perf_event event_copy;
+};
+
 struct perf_evlist {
 	struct list_head entries;
 	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
@@ -30,7 +37,6 @@ struct perf_evlist {
 		pid_t	pid;
 	} workload;
 	bool		 overwrite;
-	union perf_event event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
 	struct thread_map *threads;
@@ -136,4 +142,25 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 }
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
+
+static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
+{
+	struct perf_event_mmap_page *pc = mm->base;
+	int head = pc->data_head;
+	rmb();
+	return head;
+}
+
+static inline void perf_mmap__write_tail(struct perf_mmap *md,
+					 unsigned long tail)
+{
+	struct perf_event_mmap_page *pc = md->base;
+
+	/*
+	 * ensure all reads are done before we write the tail out.
+	 */
+	/* mb(); */
+	pc->data_tail = tail;
+}
+
 #endif /* __PERF_EVLIST_H */
-- 
1.7.10.1

