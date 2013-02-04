Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3BDTFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab3BDTFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:05:51 -0500
Date: Mon, 4 Feb 2013 20:02:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] perf: Ensure we do not free event->parent before event
Message-ID: <20130204190243.GA10858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204190225.GA10840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__perf_event_exit_task() does:

	sync_child_event(event)
	free_event(event)

sync_child_event() does put_event(event->parent) which can actually
free ->parent. This means that event->destroy(event) is called with
->parent pointing to nowhere.

perf_free_event() does put_parent(parent) before free_event(child)
too.

Afaics, currently this is fine. But the tracing "subclasses" (like
trace_uprobe) may want to track the events and their parents, and even
the fact that parent->destroy() is called before child->destroy() can
complicate this.

Move this put_event() from sync_child_event() to its single caller,
__perf_event_exit_task(). Change perf_free_event() the same way.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/core.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..1b2e516 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6787,12 +6787,6 @@ static void sync_child_event(struct perf_event *child_event,
 	mutex_lock(&parent_event->child_mutex);
 	list_del_init(&child_event->child_list);
 	mutex_unlock(&parent_event->child_mutex);
-
-	/*
-	 * Release the parent event, if this was the last
-	 * reference to it.
-	 */
-	put_event(parent_event);
 }
 
 static void
@@ -6800,7 +6794,9 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	if (child_event->parent) {
+	struct perf_event *parent_event = child_event->parent;
+
+	if (parent_event) {
 		raw_spin_lock_irq(&child_ctx->lock);
 		perf_group_detach(child_event);
 		raw_spin_unlock_irq(&child_ctx->lock);
@@ -6813,9 +6809,14 @@ __perf_event_exit_task(struct perf_event *child_event,
 	 * that are still around due to the child reference. These
 	 * events need to be zapped.
 	 */
-	if (child_event->parent) {
+	if (parent_event) {
 		sync_child_event(child_event, child);
 		free_event(child_event);
+		/*
+		 * Release the parent event, if this was the last
+		 * reference to it.
+		 */
+		put_event(parent_event);
 	}
 }
 
@@ -6867,8 +6868,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * We can recurse on the same lock type through:
 	 *
 	 *   __perf_event_exit_task()
-	 *     sync_child_event()
-	 *       put_event()
+	 *       put_event(parent_event)
 	 *         mutex_lock(&ctx->mutex)
 	 *
 	 * But since its the parent context it won't be the same instance.
@@ -6937,11 +6937,11 @@ static void perf_free_event(struct perf_event *event,
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
 
-	put_event(parent);
-
 	perf_group_detach(event);
 	list_del_event(event, ctx);
 	free_event(event);
+
+	put_event(parent);
 }
 
 /*
-- 
1.5.5.1

