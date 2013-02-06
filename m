Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3BFVoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:44:32 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33177
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758695Ab3BFVo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/17] perf evlist: Make event_copy local to mmaps
Date: Wed,  6 Feb 2013 18:44:10 -0300
Message-Id: <1360187059-12661-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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

2. There is a single evlist->event_copy for all evlist entries.
event_copy is used to handle an event wrapping at the mmap buffer
boundary.

This patch addresses the second problem - making event_copy local to
each perf_mmap. With this change my highly repeatable use case no longer
fails.

The first problem is much more complicated and will be the subject of a
future patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1360098762-61827-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h        | 26 --------------------------
 tools/perf/util/evlist.c |  4 ++--
 tools/perf/util/evlist.h | 29 ++++++++++++++++++++++++++++-
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
index ecf123e..bc4ad79 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -375,7 +375,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 		if ((old & md->mask) + size != ((old + size) & md->mask)) {
 			unsigned int offset = old;
 			unsigned int len = min(sizeof(*event), size), cpy;
-			void *dst = &evlist->event_copy;
+			void *dst = &md->event_copy;
 
 			do {
 				cpy = min(md->mask + 1 - (offset & md->mask), len);
@@ -385,7 +385,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
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
1.8.1.1.361.gec3ae6e

