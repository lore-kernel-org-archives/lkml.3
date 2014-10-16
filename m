Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaJPFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:25:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJPFZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:25:23 -0400
Date: Wed, 15 Oct 2014 22:24:56 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-54bf53b1cb9150b894213a705c562d52388376ef@git.kernel.org>
Cc: jolsa@redhat.com, paulus@samba.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
        eranian@google.com, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, acme@redhat.com, yarygin@linux.vnet.ibm.com,
        jolsa@kernel.org, namhyung.kim@lge.com, borntraeger@de.ibm.com,
        efault@gmx.de, linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: jolsa@redhat.com, paulus@samba.org, hpa@zytor.com,
        a.p.zijlstra@chello.nl, eranian@google.com, dsahern@gmail.com,
        mingo@kernel.org, fweisbec@gmail.com, acme@redhat.com,
        yarygin@linux.vnet.ibm.com, jolsa@kernel.org, namhyung.kim@lge.com,
        borntraeger@de.ibm.com, efault@gmx.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <1412347212-28237-2-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1412347212-28237-2-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Add option to copy events when queueing
Git-Commit-ID: 54bf53b1cb9150b894213a705c562d52388376ef
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

Commit-ID:  54bf53b1cb9150b894213a705c562d52388376ef
Gitweb:     http://git.kernel.org/tip/54bf53b1cb9150b894213a705c562d52388376ef
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Fri, 3 Oct 2014 18:40:11 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 17:39:03 -0300

perf session: Add option to copy events when queueing

When processing events the session code has an ordered samples queue
which is used to time-sort events coming in across multiple mmaps. At a
later point in time samples on the queue are flushed up to some
timestamp at which point the event is actually processed.

When analyzing events live (ie., record/analysis path in the same
command) there is a race that leads to corrupted events and parse errors
which cause perf to terminate. The problem is that when the event is
placed in the ordered samples queue it is only a reference to the event
which is really sitting in the mmap buffer. Even though the event is
queued for later processing the mmap tail pointer is updated which
indicates to the kernel that the event has been processed. The race is
flushing the event from the queue before it gets overwritten by some
other event. For commands trying to process events live (versus just
writing to a file) and processing a high rate of events this leads to
parse failures and perf terminates.

Examples hitting this problem are 'perf kvm stat live', especially with
nested VMs which generate 100,000+ traces per second, and a command
processing scheduling events with a high rate of context switching --
e.g., running 'perf bench sched pipe'.

This patch offers live commands an option to copy the event when it is
placed in the ordered samples queue.

Based on a patch from David Ahern <dsahern@gmail.com>

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1412347212-28237-2-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ordered-events.c | 49 ++++++++++++++++++++++++++++++++++++----
 tools/perf/util/ordered-events.h | 10 +++++++-
 tools/perf/util/session.c        |  5 ++--
 3 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 706ce1a..fd4be94 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -1,5 +1,6 @@
 #include <linux/list.h>
 #include <linux/compiler.h>
+#include <linux/string.h>
 #include "ordered-events.h"
 #include "evlist.h"
 #include "session.h"
@@ -57,11 +58,45 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 	}
 }
 
+static union perf_event *__dup_event(struct ordered_events *oe,
+				     union perf_event *event)
+{
+	union perf_event *new_event = NULL;
+
+	if (oe->cur_alloc_size < oe->max_alloc_size) {
+		new_event = memdup(event, event->header.size);
+		if (new_event)
+			oe->cur_alloc_size += event->header.size;
+	}
+
+	return new_event;
+}
+
+static union perf_event *dup_event(struct ordered_events *oe,
+				   union perf_event *event)
+{
+	return oe->copy_on_queue ? __dup_event(oe, event) : event;
+}
+
+static void free_dup_event(struct ordered_events *oe, union perf_event *event)
+{
+	if (oe->copy_on_queue) {
+		oe->cur_alloc_size -= event->header.size;
+		free(event);
+	}
+}
+
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
-static struct ordered_event *alloc_event(struct ordered_events *oe)
+static struct ordered_event *alloc_event(struct ordered_events *oe,
+					 union perf_event *event)
 {
 	struct list_head *cache = &oe->cache;
 	struct ordered_event *new = NULL;
+	union perf_event *new_event;
+
+	new_event = dup_event(oe, event);
+	if (!new_event)
+		return NULL;
 
 	if (!list_empty(cache)) {
 		new = list_entry(cache->next, struct ordered_event, list);
@@ -74,8 +109,10 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
 
 		oe->buffer = malloc(size);
-		if (!oe->buffer)
+		if (!oe->buffer) {
+			free_dup_event(oe, new_event);
 			return NULL;
+		}
 
 		pr("alloc size %" PRIu64 "B (+%zu), max %" PRIu64 "B\n",
 		   oe->cur_alloc_size, size, oe->max_alloc_size);
@@ -90,15 +127,17 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		pr("allocation limit reached %" PRIu64 "B\n", oe->max_alloc_size);
 	}
 
+	new->event = new_event;
 	return new;
 }
 
 struct ordered_event *
-ordered_events__new(struct ordered_events *oe, u64 timestamp)
+ordered_events__new(struct ordered_events *oe, u64 timestamp,
+		    union perf_event *event)
 {
 	struct ordered_event *new;
 
-	new = alloc_event(oe);
+	new = alloc_event(oe, event);
 	if (new) {
 		new->timestamp = timestamp;
 		queue_event(oe, new);
@@ -111,6 +150,7 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
 {
 	list_move(&event->list, &oe->cache);
 	oe->nr_events--;
+	free_dup_event(oe, event->event);
 }
 
 static int __ordered_events__flush(struct perf_session *s,
@@ -240,6 +280,7 @@ void ordered_events__free(struct ordered_events *oe)
 
 		event = list_entry(oe->to_free.next, struct ordered_event, list);
 		list_del(&event->list);
+		free_dup_event(oe, event->event);
 		free(event);
 	}
 }
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 3b2f205..7b8f9b0 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -34,9 +34,11 @@ struct ordered_events {
 	int			buffer_idx;
 	unsigned int		nr_events;
 	enum oe_flush		last_flush_type;
+	bool                    copy_on_queue;
 };
 
-struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp);
+struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp,
+					  union perf_event *event);
 void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event);
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
@@ -48,4 +50,10 @@ void ordered_events__set_alloc_size(struct ordered_events *oe, u64 size)
 {
 	oe->max_alloc_size = size;
 }
+
+static inline
+void ordered_events__set_copy_on_queue(struct ordered_events *oe, bool copy)
+{
+	oe->copy_on_queue = copy;
+}
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 896bac7..6702ac2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -532,17 +532,16 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 			return -EINVAL;
 	}
 
-	new = ordered_events__new(oe, timestamp);
+	new = ordered_events__new(oe, timestamp, event);
 	if (!new) {
 		ordered_events__flush(s, tool, OE_FLUSH__HALF);
-		new = ordered_events__new(oe, timestamp);
+		new = ordered_events__new(oe, timestamp, event);
 	}
 
 	if (!new)
 		return -ENOMEM;
 
 	new->file_offset = file_offset;
-	new->event = event;
 	return 0;
 }
 
