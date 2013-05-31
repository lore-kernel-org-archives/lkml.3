Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3EaIsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:48:47 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40835 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3EaIsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:21 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 07/16] perf, persistent: Rework struct pers_event_desc
Date: Fri, 31 May 2013 10:47:27 +0200
Message-Id: <1369990056-10310-8-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Struct pers_event_desc is only used in kernel/events/persistent.c.
Moving it there. Also, removing attr member as this is a copy of
event->attr.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 include/linux/perf_event.h |  7 -------
 kernel/events/persistent.c | 12 ++++++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d2a42b7..dc72c93 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -518,13 +518,6 @@ struct perf_output_handle {
 	int				page;
 };
 
-struct pers_event_desc {
-	struct perf_event_attr *attr;
-	struct perf_event *event;
-	struct list_head plist;
-	int fd;
-};
-
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 190aa75..22297e5 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -8,6 +8,12 @@
 /* 512 kiB: default perf tools memory size, see perf_evlist__mmap() */
 #define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
 
+struct pers_event_desc {
+	struct perf_event *event;
+	struct list_head plist;
+	int fd;
+};
+
 static DEFINE_PER_CPU(struct list_head, pers_events);
 
 static struct perf_event *
@@ -33,7 +39,6 @@ add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
 	rcu_assign_pointer(event->rb, buf);
 
 	desc->event = event;
-	desc->attr  = attr;
 
 	INIT_LIST_HEAD(&desc->plist);
 	list_add_tail(&desc->plist, &per_cpu(pers_events, cpu));
@@ -59,7 +64,7 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 	struct perf_event *event = NULL;
 
 	list_for_each_entry_safe(desc, tmp, &per_cpu(pers_events, cpu), plist) {
-		if (desc->attr->config == attr->config) {
+		if (desc->event->attr.config == attr->config) {
 			event = desc->event;
 			break;
 		}
@@ -78,7 +83,6 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 
 	perf_event_release_kernel(event);
 	put_unused_fd(desc->fd);
-	kfree(desc->attr);
 	kfree(desc);
 }
 
@@ -162,7 +166,7 @@ int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 	struct pers_event_desc *desc;
 
 	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist)
-		if (desc->attr->config == attr->config)
+		if (desc->event->attr.config == attr->config)
 			return __alloc_persistent_event_fd(desc);
 
 	return -ENODEV;
-- 
1.8.1.1

