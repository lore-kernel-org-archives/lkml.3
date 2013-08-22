Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3HVOOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:14:43 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45951 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3HVOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:39 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 02/12] perf, mmap: Factor out try_get_event()/put_event()
Date: Thu, 22 Aug 2013 16:13:17 +0200
Message-Id: <1377180807-12758-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Implement try_get_event() as counter part to put_event(). Put both in
internal.h to make it available to other perf files.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/core.c     |  9 +++------
 kernel/events/internal.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5dcc5fe..c9a5d4c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3242,13 +3242,10 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 /*
  * Called when the last reference to the file is gone.
  */
-static void put_event(struct perf_event *event)
+void __put_event(struct perf_event *event)
 {
 	struct task_struct *owner;
 
-	if (!atomic_long_dec_and_test(&event->refcount))
-		return;
-
 	rcu_read_lock();
 	owner = ACCESS_ONCE(event->owner);
 	/*
@@ -3781,7 +3778,7 @@ static void ring_buffer_detach_all(struct ring_buffer *rb)
 again:
 	rcu_read_lock();
 	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
-		if (!atomic_long_inc_not_zero(&event->refcount)) {
+		if (!try_get_event(event)) {
 			/*
 			 * This event is en-route to free_event() which will
 			 * detach it and remove it from the list.
@@ -7445,7 +7442,7 @@ inherit_event(struct perf_event *parent_event,
 	if (IS_ERR(child_event))
 		return child_event;
 
-	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
+	if (!try_get_event(parent_event)) {
 		free_event(child_event);
 		return NULL;
 	}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ca65997..96a07d2 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -178,4 +178,16 @@ static inline bool arch_perf_have_user_stack_dump(void)
 #define perf_user_stack_pointer(regs) 0
 #endif /* CONFIG_HAVE_PERF_USER_STACK_DUMP */
 
+static inline bool try_get_event(struct perf_event *event)
+{
+	return atomic_long_inc_not_zero(&event->refcount) != 0;
+}
+extern void __put_event(struct perf_event *event);
+static inline void put_event(struct perf_event *event)
+{
+	if (!atomic_long_dec_and_test(&event->refcount))
+		return;
+	__put_event(event);
+}
+
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
-- 
1.8.3.2

