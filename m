Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3EaItB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:49:01 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:35176 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3EaIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:37 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 16/16] perf, persistent: Allow multiple users for an event
Date: Fri, 31 May 2013 10:47:36 +0200
Message-Id: <1369990056-10310-17-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Usually a fd close leads to the release of the event too. For
persistent events this is different as the events should be
permanently enabled in the system. Using reference counting to avoid
releasing an event during a fd close. This also allows it to have
multiple users (open file descriptors) for a single persistent event.

While at this, we don't need desc->fd any longer. The fd is attached
to a task and reference counting keeps the event. Removing desc->fd.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index a764144..4920702 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -11,7 +11,6 @@
 struct pers_event_desc {
 	struct perf_event *event;
 	struct list_head plist;
-	int fd;
 };
 
 struct pers_event {
@@ -88,6 +87,18 @@ out:
 	return event;
 }
 
+static void detach_persistent_event(struct pers_event_desc *desc)
+{
+	list_del(&desc->plist);
+	kfree(desc);
+}
+
+static void release_persistent_event(struct perf_event *event)
+{
+	perf_event_disable(event);
+	perf_event_release_kernel(event);
+}
+
 static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 {
 	struct pers_event_desc *desc;
@@ -100,12 +111,14 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 		goto out;
 	event = desc->event;
 
-	list_del(&desc->plist);
-
-	perf_event_disable(event);
-	perf_event_release_kernel(event);
-	put_unused_fd(desc->fd);
-	kfree(desc);
+	/*
+	 * We primarily want to remove desc from the list. If there
+	 * are no open files, the refcount is 0 and we need to release
+	 * the event too.
+	 */
+	detach_persistent_event(desc);
+	if (atomic_long_dec_and_test(&event->refcount))
+		release_persistent_event(event);
 out:
 	mutex_unlock(&per_cpu(pers_events_lock, cpu));
 }
@@ -182,18 +195,31 @@ fail:
 int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 {
 	struct pers_event_desc *desc;
+	struct perf_event *event;
 	int event_fd = -ENODEV;
 
 	mutex_lock(&per_cpu(pers_events_lock, cpu));
 
 	desc = get_persistent_event(cpu, attr);
-	if (!desc)
+
+	/* Increment refcount to keep event on put_event() */
+	if (!desc || !atomic_long_inc_not_zero(&desc->event->refcount))
 		goto out;
 
 	event_fd = anon_inode_getfd("[pers_event]", &perf_fops,
 				desc->event, O_RDONLY);
-	if (event_fd >= 0)
-		desc->fd = event_fd;
+
+	if (event_fd < 0) {
+		event = desc->event;
+		if (WARN_ON(atomic_long_dec_and_test(&event->refcount))) {
+			/*
+			 * May not happen since decrementing refcount is
+			 * protected by pers_events_lock.
+			 */
+			detach_persistent_event(desc);
+			release_persistent_event(event);
+		}
+	}
 out:
 	mutex_unlock(&per_cpu(pers_events_lock, cpu));
 
-- 
1.8.1.1

