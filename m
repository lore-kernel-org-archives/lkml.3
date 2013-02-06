Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3BFWH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:07:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3BFWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:07:23 -0500
Date: Wed, 6 Feb 2013 14:07:02 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-0479b8b9cf4377df5d2c81506ce93326c31eff40@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1360098762-61827-1-git-send-email-dsahern@gmail.com>
References: <1360098762-61827-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Make event_copy local to mmaps
Git-Commit-ID: 0479b8b9cf4377df5d2c81506ce93326c31eff40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:07:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0479b8b9cf4377df5d2c81506ce93326c31eff40
Gitweb:     http://git.kernel.org/tip/0479b8b9cf4377df5d2c81506ce93326c31eff40
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 5 Feb 2013 14:12:42 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:26 -0300

perf evlist: Make event_copy local to mmaps

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
