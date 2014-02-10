Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaBJRfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:35:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbaBJRbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:31:01 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 16/21] perf, c2c: Fixup tid because of perf map is broken
Date: Mon, 10 Feb 2014 12:29:11 -0500
Message-Id: <1392053356-23024-17-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf tries to load the initial mmaps, it graps data from /proc/<pid>/maps files
and feeds them into perf as generated MMAP events.  Unfortunately, when the system
has threads running, those thread maps are not generated (because perf doesn't know the
history of the fork events leading to the threads).

As a result when trying to map a data source address (not IP), to a thread map, it fails
and the map returns NULL.  Feeding perf the pid instead gets us the correct map, however
the TID is now incorrect for the thread struct (it now has a PID for a TID instead).

Performing any cache-to-cache contention analysis leads to problems, so for now save the
TID for local use and do not rely on the perf maps' TID.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 0760f6a..32c2319 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -62,6 +62,7 @@ struct c2c_entry {
 	struct rb_node		rb_node;
 	struct list_head	scratch;  /* scratch list for resorting */
 	struct thread		*thread;
+	int			tid;  /* FIXME perf maps broken */
 	struct mem_info		*mi;
 	u32			cpu;
 	u8			cpumode;
@@ -397,8 +398,8 @@ static int physid_cmp(struct c2c_entry *left, struct c2c_entry *right)
 		if (left->thread->pid_ > right->thread->pid_) return 1;
 		if (left->thread->pid_ < right->thread->pid_) return -1;
 
-		if (left->thread->tid > right->thread->tid) return 1;
-		if (left->thread->tid < right->thread->tid) return -1;
+		if (left->tid > right->tid) return 1;
+		if (left->tid < right->tid) return -1;
 	} else if (left->cpumode == PERF_RECORD_MISC_KERNEL) {
 		/* kernel mapped areas where 'start' doesn't matter */
 
@@ -416,15 +417,15 @@ static int physid_cmp(struct c2c_entry *left, struct c2c_entry *right)
 		if (left->thread->pid_ > right->thread->pid_) return 1;
 		if (left->thread->pid_ < right->thread->pid_) return -1;
 
-		if (left->thread->tid > right->thread->tid) return 1;
-		if (left->thread->tid < right->thread->tid) return -1;
+		if (left->tid > right->tid) return 1;
+		if (left->tid < right->tid) return -1;
 	} else {
 		/* userspace anonymous */
 		if (left->thread->pid_ > right->thread->pid_) return 1;
 		if (left->thread->pid_ < right->thread->pid_) return -1;
 
-		if (left->thread->tid > right->thread->tid) return 1;
-		if (left->thread->tid < right->thread->tid) return -1;
+		if (left->tid > right->tid) return 1;
+		if (left->tid < right->tid) return -1;
 
 		/* hack to mark similar regions, 'right' is new entry */
 		/* userspace anonymous address space is contained within pid */
@@ -574,6 +575,7 @@ static struct c2c_entry *c2c_entry__new(struct perf_sample *sample,
 	if (entry != NULL) {
 		entry->thread = thread;
 		entry->mi = mi;
+		entry->tid = sample->tid;
 		entry->cpu = sample->cpu;
 		entry->cpumode = cpumode;
 		entry->weight = sample->weight;
@@ -695,7 +697,7 @@ static struct c2c_hit *c2c_hit__new(u64 cacheline, struct c2c_entry *entry)
 	h->tree = RB_ROOT;
 	h->cacheline = cacheline;
 	h->pid = entry->thread->pid_;
-	h->tid = entry->thread->tid;
+	h->tid = entry->tid;
 	if (symbol_conf.use_callchain)
 		callchain_init(h->callchain);
 
@@ -713,7 +715,7 @@ static void c2c_hit__update_strings(struct c2c_hit *h,
 	if (h->pid != n->thread->pid_)
 		h->pid = -1;
 
-	if (h->tid != n->thread->tid)
+	if (h->tid != n->tid)
 		h->tid = -1;
 
 	/* use original addresses here, not adjusted al_addr */
@@ -743,7 +745,7 @@ static inline bool matching_coalescing(struct c2c_hit *h,
 		case LVL1:
 			value = ((h->daddr == mi->daddr.addr) &&
 				 (h->pid   == e->thread->pid_) &&
-				 (h->tid   == e->thread->tid) &&
+				 (h->tid   == e->tid) &&
 				 (h->iaddr == mi->iaddr.addr));
 			break;
 
@@ -775,7 +777,7 @@ static inline bool matching_coalescing(struct c2c_hit *h,
 		case LVL0:
 			value = ((h->daddr == mi->daddr.addr) &&
 				 (h->pid   == e->thread->pid_) &&
-				 (h->tid   == e->thread->tid) &&
+				 (h->tid   == e->tid) &&
 				 (h->iaddr == mi->iaddr.addr));
 			break;
 
@@ -850,7 +852,7 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 	if (evsel->handler.func == NULL)
 		return 0;
 
-	thread = machine__find_thread(machine, sample->tid);
+	thread = machine__find_thread(machine, sample->pid);
 	if (thread == NULL)
 		goto err;
 
-- 
1.7.11.7

