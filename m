Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaDGPFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:05:07 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51032 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDGPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:04:59 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 02/16] perf, mmap: Factor out try_get_event()/put_event()
Date: Mon,  7 Apr 2014 17:04:24 +0200
Message-Id: <1396883078-25320-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Implement try_get_event() as counter part to put_event(). Put both in
internal.h to make it available to other perf files.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 kernel/events/core.c     |  9 +++------
 kernel/events/internal.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8867236..5eaba42 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3311,13 +3311,10 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
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
@@ -3884,7 +3881,7 @@ static void ring_buffer_detach_all(struct ring_buffer *rb)
 again:
 	rcu_read_lock();
 	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
-		if (!atomic_long_inc_not_zero(&event->refcount)) {
+		if (!try_get_event(event)) {
 			/*
 			 * This event is en-route to free_event() which will
 			 * detach it and remove it from the list.
@@ -7606,7 +7603,7 @@ inherit_event(struct perf_event *parent_event,
 	if (IS_ERR(child_event))
 		return child_event;
 
-	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
+	if (!try_get_event(parent_event)) {
 		free_event(child_event);
 		return NULL;
 	}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b2187..3bd89d4 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -195,4 +195,16 @@ static inline bool arch_perf_have_user_stack_dump(void)
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
1.7.11.7

