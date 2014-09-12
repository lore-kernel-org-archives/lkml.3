Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaILQ2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:28:05 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:56243 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaILQ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:28:03 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RFC] perf kvm stat live: cache mmap()ed events
Date: Fri, 12 Sep 2014 20:27:43 +0400
Message-Id: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091216-0342-0000-0000-00000109D7F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During mmap() process 'perf kvm stat live' gets a pointer to events and
passes them to the session queue. Events are stored in shared memory and
eventually they will be overwritten by the kernel. The problem is, that
when events come too fast, old events can be overwritten before they
have been processed that can lead to perf crash.

To prevent that happening, we can copy upcoming events and pass a copy
to the session queue. There is a safe place to copy event: before
perf_evlist__mmap_consume() is executed. There are 3 places to free it:
when event is processed, when it's lost and on exit, if it's turned out
unprocessed.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-kvm.c   | 88 +++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/kvm-stat.h |  2 ++
 2 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43367eb..183e613 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -625,6 +625,62 @@ static void print_result(struct perf_kvm_stat *kvm)
 }

 #ifdef HAVE_TIMERFD_SUPPORT
+
+struct events_cache {
+	union perf_event event;
+	struct list_head list;
+};
+
+static void init_events_cache(struct perf_kvm_stat *kvm)
+{
+	kvm->cache = malloc(sizeof(struct events_cache));
+	INIT_LIST_HEAD(&kvm->cache->list);
+}
+
+static union perf_event *alloc_event_cache(struct events_cache *cache,
+					   union perf_event *event)
+{
+	struct events_cache *new = malloc(sizeof(struct events_cache));
+
+	memmove(&new->event, event, event->header.size);
+	list_add(&new->list, &cache->list);
+
+	return &new->event;
+}
+
+static void free_event_cache(struct events_cache *cache,
+			     union perf_event *event)
+{
+	struct list_head *p, *p2;
+
+	list_for_each_safe(p, p2, &cache->list) {
+		struct events_cache *entry;
+
+		entry = list_entry(p, struct events_cache, list);
+
+		if (&entry->event == event) {
+			list_del(&entry->list);
+			free(entry);
+
+			break;
+		}
+	}
+}
+
+static void clear_events_cache(struct events_cache *cache)
+{
+	struct list_head *p, *p2;
+
+	list_for_each_safe(p, p2, &cache->list) {
+		struct event_cache *entry;
+
+		entry = list_entry(p, struct events_cache, list);
+		list_del(&entry->list);
+		free(entry);
+	}
+	free(cache);
+}
+
 static int process_lost_event(struct perf_tool *tool,
 			      union perf_event *event __maybe_unused,
 			      struct perf_sample *sample __maybe_unused,
@@ -633,6 +689,10 @@ static int process_lost_event(struct perf_tool *tool,
 	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat, tool);

 	kvm->lost_events++;
+
+	if (kvm->live)
+		free_event_cache(kvm->cache, event);
+
 	return 0;
 }
 #endif
@@ -655,6 +715,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct thread *thread;
 	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
 						 tool);
+	int err;

 	if (skip_sample(kvm, sample))
 		return 0;
@@ -663,13 +724,20 @@ static int process_sample_event(struct perf_tool *tool,
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
-		return -1;
+
+		err = -1;
+		goto out;
 	}

-	if (!handle_kvm_event(kvm, thread, evsel, sample))
-		return -1;
+	err = !handle_kvm_event(kvm, thread, evsel, sample);

-	return 0;
+out:
+#ifdef HAVE_TIMERFD_SUPPORT
+	if (kvm->live)
+		free_event_cache(kvm->cache, event);
+#endif
+
+	return err;
 }

 static int cpu_isa_config(struct perf_kvm_stat *kvm)
@@ -732,15 +800,15 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
 			return -1;
 		}

-		err = perf_session_queue_event(kvm->session, event, &sample, 0);
-		/*
-		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
-		 *        point to it, and it'll get possibly overwritten by the kernel.
-		 */
+		event = alloc_event_cache(kvm->cache, event);
+
 		perf_evlist__mmap_consume(kvm->evlist, idx);

+		err = perf_session_queue_event(kvm->session, event, &sample, 0);
+
 		if (err) {
 			pr_err("Failed to enqueue sample: %d\n", err);
+			free_event_cache(kvm->cache, event);
 			return -1;
 		}

@@ -959,6 +1027,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)

 	/* everything is good - enable the events and process */
 	perf_evlist__enable(kvm->evlist);
+	init_events_cache(kvm);

 	while (!done) {
 		int rc;
@@ -978,6 +1047,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 			err = poll(pollfds, nr_fds, 100);
 	}

+	clear_events_cache(kvm->cache);
 	perf_evlist__disable(kvm->evlist);

 	if (err == 0) {
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index 0b5a8cd..856dbf7 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -97,6 +97,8 @@ struct perf_kvm_stat {

 	struct rb_root result;

+	struct events_cache *cache;
+
 	int timerfd;
 	unsigned int display_time;
 	bool live;
--
1.9.1

