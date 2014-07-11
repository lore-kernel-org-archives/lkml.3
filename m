Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaGKL4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbaGKL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:56:49 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/5] perf: Initialize owner before calling event_init callback
Date: Fri, 11 Jul 2014 13:56:20 +0200
Message-Id: <1405079782-8139-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

To be able to check the owner task permission in event_init
PMU callback, we need to set the owner before it is called.

Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 37797dd..a36ebfe 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6751,6 +6751,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct task_struct *task,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
+		 struct task_struct *owner,
 		 perf_overflow_handler_t overflow_handler,
 		 void *context)
 {
@@ -6829,6 +6830,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	perf_event__state_init(event);
 
+	if (owner)
+		event->owner = owner;
+
 	pmu = NULL;
 
 	hwc = &event->hw;
@@ -7141,7 +7145,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	get_online_cpus();
 
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
-				 NULL, NULL);
+				 current, NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_cpus;
@@ -7293,8 +7297,6 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	put_online_cpus();
 
-	event->owner = current;
-
 	mutex_lock(&current->perf_event_mutex);
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
@@ -7353,7 +7355,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+	event = perf_event_alloc(attr, cpu, task, NULL, NULL, NULL,
 				 overflow_handler, context);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
@@ -7674,11 +7676,9 @@ inherit_event(struct perf_event *parent_event,
 	if (parent_event->parent)
 		parent_event = parent_event->parent;
 
-	child_event = perf_event_alloc(&parent_event->attr,
-					   parent_event->cpu,
-					   child,
-					   group_leader, parent_event,
-				           NULL, NULL);
+	child_event = perf_event_alloc(&parent_event->attr, parent_event->cpu,
+				       child, group_leader, parent_event,
+				       NULL, NULL, NULL);
 	if (IS_ERR(child_event))
 		return child_event;
 
-- 
1.8.3.1

