Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3EaIs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:48:57 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46713 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EaIsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:22 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 08/16] perf, persistent: Remove rb_put()
Date: Fri, 31 May 2013 10:47:28 +0200
Message-Id: <1369990056-10310-9-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

rb_put() is called already in perf_event_release_kernel(), so no need
to do the same in del_persistent_event(). We also don't need it in
add_persistent_event_on_cpu() after a rework. Since there are no users
of rb_put() anymore, we can make it private again to only
events/core.c.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/core.c       |  4 +++-
 kernel/events/internal.h   |  1 -
 kernel/events/persistent.c | 29 +++++++++++------------------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a9b6470..8f85caa 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3021,6 +3021,8 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
+static void rb_put(struct ring_buffer *rb);
+
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -3680,7 +3682,7 @@ static struct ring_buffer *rb_get(struct perf_event *event)
 	return rb;
 }
 
-void rb_put(struct ring_buffer *rb)
+static void rb_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 3b481be..3647289 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -38,7 +38,6 @@ struct ring_buffer {
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
-extern void rb_put(struct ring_buffer *rb);
 extern void perf_event_wakeup(struct perf_event *event);
 
 extern void
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 22297e5..ff1ce3b 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -20,22 +20,22 @@ static struct perf_event *
 add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
 			    unsigned nr_pages)
 {
-	struct perf_event *event = ERR_PTR(-ENOMEM);
+	struct perf_event *event;
 	struct pers_event_desc *desc;
 	struct ring_buffer *buf;
 
 	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
 	if (!desc)
-		goto out;
-
-	buf = rb_alloc(nr_pages, 0, cpu, 0);
-	if (!buf)
-		goto err_rb;
+		return ERR_PTR(-ENOMEM);
 
 	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
 	if (IS_ERR(event))
 		goto err_event;
 
+	buf = rb_alloc(nr_pages, 0, cpu, 0);
+	if (!buf)
+		goto err_rb;
+
 	rcu_assign_pointer(event->rb, buf);
 
 	desc->event = event;
@@ -47,14 +47,12 @@ add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
 	perf_event_enable(event);
 
 	goto out;
-
- err_event:
-	rb_put(buf);
-
- err_rb:
+err_rb:
+	perf_event_release_kernel(event);
+	event = ERR_PTR(-ENOMEM);
+err_event:
 	kfree(desc);
-
- out:
+out:
 	return event;
 }
 
@@ -76,11 +74,6 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 	list_del(&desc->plist);
 
 	perf_event_disable(event);
-	if (event->rb) {
-		rb_put(event->rb);
-		rcu_assign_pointer(event->rb, NULL);
-	}
-
 	perf_event_release_kernel(event);
 	put_unused_fd(desc->fd);
 	kfree(desc);
-- 
1.8.1.1

