Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3IYMve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab3IYMvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:32 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/21] perf: Support event inheritance for toggle feature
Date: Wed, 25 Sep 2013 14:50:38 +0200
Message-Id: <1380113447-17144-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The toggling sets relationship between events - toggle event
carries pointer and reference for toggled event. This needs
to be configured for child events as well.

During the fork events are processed/cloned with no regards
to the toggle setup, so we have no idea what we get first:
toggle or toggled events.

To avoid extra after-fork scanning for toggle events, we
use child pre-allocation whenever the toggling setup is
detected. This way we can pre-set the toggle dependencies
during the event cloning.

Described in following example.

  Consider following setup:
    - 'event A' toggles 'event B'
    - 'event A' holds pointer/ref to 'event B'

  Now we have fork:
  (and have no idea which event gets inherited/cloned first)

  1) the clone order is 'event A' 'event B'
     - 'event A' is processed:
       - 'event_cloned A' is created
       - 'event_cloned A' needs pointer to 'event_cloned B'
          which does not exist yet
       - we pre-allocate 'event_cloned B' and setup 'event_cloned A's
         toggled_event pointer/ref and also save it in 'event B' as
         toggled_child

     - 'event B' is processed
       - we check if toggled_child is allocated
       - we use it as 'event_cloned B'

  2) the order is 'event B' 'event A'
     - 'event B' is processed
       - toggled_child is not allocated, we allocate 'event_cloned B'
         and store it in 'event B' as toggled_child

     - 'event A' is processed
       - create 'event_cloned A'
       - 'event A' is toggling event and have pointer to 'event B'
       - we check if there's already initialized toggled_child in 'event B'
       - initialize 'event_cloned A' toggled_event pointer with
         'event_cloned B' taken toggled_child

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |   2 +
 kernel/events/core.c       | 103 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 801ff22..baefb79 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -424,6 +424,8 @@ struct perf_event {
 	enum perf_event_toggle_flag	toggle_flag;
 	int				paused;
 	atomic_t			toggled_cnt;
+	struct perf_event		*toggled_child;
+	int				toggled_child_cnt;
 #endif /* CONFIG_PERF_EVENTS */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index fa1d229..edf161b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3156,6 +3156,8 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+	if (event->toggled_child)
+		kfree(event->toggled_child);
 	kfree(event);
 }
 
@@ -6749,6 +6751,9 @@ static int perf_init_event(struct perf_event *event,
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
+	if (parent_event && atomic_read(&parent_event->toggled_cnt))
+		event->toggled_cnt = parent_event->toggled_cnt;
+
 	perf_event__state_init(event);
 
 	pmu = NULL;
@@ -6795,6 +6800,11 @@ err_ns:
 	return err;
 }
 
+static struct perf_event *__perf_event_alloc(void)
+{
+	return kzalloc(sizeof(struct perf_event), GFP_KERNEL);
+}
+
 /*
  * Allocate and initialize a event structure
  */
@@ -6809,7 +6819,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	int err;
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	event = __perf_event_alloc();
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
@@ -7048,6 +7058,10 @@ perf_event_set_toggle(struct perf_event *event,
 	if (toggled_event->ctx->task != ctx->task)
 		return -EINVAL;
 
+	/* Temporary hack for toggled_child_cnt */
+	if (toggled_event->attr.inherit !=  event->attr.inherit)
+		return -EINVAL;
+
 	event->overflow_handler = perf_event_toggle_overflow;
 	event->toggle_flag      = get_toggle_flag(flags);
 	event->toggled_event    = toggled_event;
@@ -7686,6 +7700,66 @@ void perf_event_delayed_put(struct task_struct *task)
 		WARN_ON_ONCE(task->perf_event_ctxp[ctxn]);
 }
 
+static void
+perf_event_toggled_set_child(struct perf_event *event,
+			     struct perf_event *child)
+{
+	event->toggled_child     = child;
+	event->toggled_child_cnt = atomic_read(&event->toggled_cnt) + 1;
+}
+
+static void perf_event_toggled_child_put(struct perf_event *parent)
+{
+	int cnt = --parent->toggled_child_cnt;
+
+	WARN_ON_ONCE(cnt < 0);
+	WARN_ON_ONCE(!parent->toggled_child);
+
+	if (!cnt)
+		parent->toggled_child = NULL;
+}
+
+static int
+perf_event_inherit_toggle(struct perf_event *event,
+			  struct perf_event *parent)
+{
+	struct perf_event *toggled = parent->toggled_event;
+	struct perf_event *toggled_child = parent->toggled_child;
+
+
+	/*
+	 * This @event is toggled by the childs of the its parent's togglers.
+	 * If this child is inherited before its togglers, declare it so.
+	 */
+	if (atomic_read(&event->toggled_cnt)) {
+		if (!parent->toggled_child)
+			perf_event_toggled_set_child(parent, event);
+		perf_event_toggled_child_put(parent);
+	}
+
+	/*
+	 * This @event toggles the child of the event toggled by its @parent.
+	 * If it's inherited before its toggled event, pre-allocate the toggled
+	 * In any case, declare and attach the toggled to the @event.
+	 */
+	if (toggled) {
+		toggled_child = toggled->toggled_child;
+		if (!toggled_child) {
+			toggled_child = __perf_event_alloc();
+			if (!toggled_child)
+				return -ENOMEM;
+			perf_event_toggled_set_child(toggled, toggled_child);
+		}
+
+		/* set inherited toggling */
+		event->toggled_event = toggled_child;
+		event->toggle_flag   = parent->toggle_flag;
+		perf_event_toggled_child_put(toggled);
+	}
+
+	return 0;
+}
+
 /*
  * inherit a event from parent task to child task:
  */
@@ -7697,8 +7771,16 @@ inherit_event(struct perf_event *parent_event,
 	      struct perf_event *group_leader,
 	      struct perf_event_context *child_ctx)
 {
-	struct perf_event *child_event;
+	struct perf_event *child_event, *orig_parent_event = parent_event;
 	unsigned long flags;
+	int err;
+
+	child_event = parent_event->toggled_child;
+	if (!child_event) {
+		child_event = __perf_event_alloc();
+		if (!child_event)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	/*
 	 * Instead of creating recursive hierarchies of events,
@@ -7709,13 +7791,16 @@ inherit_event(struct perf_event *parent_event,
 	if (parent_event->parent)
 		parent_event = parent_event->parent;
 
-	child_event = perf_event_alloc(&parent_event->attr,
-					   parent_event->cpu,
-					   child,
-					   group_leader, parent_event,
-				           NULL, NULL);
-	if (IS_ERR(child_event))
-		return child_event;
+	err = perf_init_event(child_event, &parent_event->attr,
+			      parent_event->cpu, child,
+			      group_leader, parent_event, NULL, NULL);
+	if (err)
+		return ERR_PTR(err);
+
+	if (perf_event_inherit_toggle(child_event, orig_parent_event)) {
+		free_event(child_event);
+		return NULL;
+	}
 
 	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
 		free_event(child_event);
-- 
1.7.11.7

