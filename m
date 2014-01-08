Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaAHKQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:16:10 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37986 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbaAHKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:16:04 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 1/2] perf/x86: fix active_entry initialization
Date: Wed,  8 Jan 2014 11:15:52 +0100
Message-Id: <1389176153-3128-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389176153-3128-1-git-send-email-eranian@google.com>
References: <1389176153-3128-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a problem with the initialization of the
struct perf_event active_entry field. It is defined inside
an anonymous union and was initialized in perf_event_alloc()
using INIT_LIST_HEAD(). However at that time, we do not know
whether the event is going to use active_entry or hlist_entry (SW).
Or at last, we don't want to make that determination there.
The problem is that hlist and list_head are not initialized
the same way. One is okay with NULL (from kzmalloc), the other
needs to pointers to point to self.

This patch resolves this problem by dropping the union.
This will avoid problems later on, if someone starts using
active_entry or hlist_entry without verifying that they
actually overlap. This also solves the initialization
problem.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    6 ++----
 kernel/events/core.c       |    2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8f4a70f..e56b07f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -319,10 +319,8 @@ struct perf_event {
 	 */
 	struct list_head		migrate_entry;
 
-	union {
-		struct hlist_node	hlist_entry;
-		struct list_head	active_entry;
-	};
+	struct hlist_node		hlist_entry;
+	struct list_head		active_entry;
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4b743b2..74fdef5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6685,6 +6685,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
 	INIT_LIST_HEAD(&event->active_entry);
+	INIT_HLIST_NODE(&event->hlist_entry);
+
 
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
-- 
1.7.9.5

