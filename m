Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3KERCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:02:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50021 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3KERCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:02:04 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: [PATCH v5 1/4] perf: add active_entry list head to struct perf_event
Date: Tue,  5 Nov 2013 18:01:23 +0100
Message-Id: <1383670886-30827-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383670886-30827-1-git-send-email-eranian@google.com>
References: <1383670886-30827-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new field to the struct perf_event.
It is intended to be used to chain events which are
active (enabled). It helps in the hardware layer
for PMUs which do not have actual counter restrictions, i.e.,
free running read-only counters. Active events are chained
as opposed to being tracked via the counter they use.

To save space we use a union with hlist_entry as both
are mutually exclusive (suggested by Jiri Olsa).

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    5 ++++-
 kernel/events/core.c       |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e069d1..8f4a70f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -319,7 +319,10 @@ struct perf_event {
 	 */
 	struct list_head		migrate_entry;
 
-	struct hlist_node		hlist_entry;
+	union {
+		struct hlist_node	hlist_entry;
+		struct list_head	active_entry;
+	};
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 17b3c6c..2de509b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6663,6 +6663,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
+	INIT_LIST_HEAD(&event->active_entry);
 
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
-- 
1.7.9.5

