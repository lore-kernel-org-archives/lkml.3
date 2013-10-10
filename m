Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3JJOu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:50:28 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60871 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3JJOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:50:24 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de
Subject: [PATCH v2 1/3] perf: add active_entry list head to struct perf_event
Date: Thu, 10 Oct 2013 16:50:06 +0200
Message-Id: <1381416608-2741-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381416608-2741-1-git-send-email-eranian@google.com>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new fields to the struct perf_event.
It is intended to be used to chain events which are
active (enabled). It helps in the hardware layer
for PMU which do not have actual counter restrictions, i.e.,
free running read-only counters. Active events are chained
as opposed to being tracked via the counter they use.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |    1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e069d1..a376384 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -435,6 +435,7 @@ struct perf_event {
 	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
 	int				cgrp_defer_enabled;
 #endif
+	struct list_head		active_entry;
 
 #endif /* CONFIG_PERF_EVENTS */
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c716385..b1dbf79 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6629,6 +6629,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
+	INIT_LIST_HEAD(&event->active_entry);
 
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
-- 
1.7.9.5

