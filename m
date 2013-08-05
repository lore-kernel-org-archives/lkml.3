Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3HERKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:10:16 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:57376 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3HERKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:10:14 -0400
Date: Mon, 5 Aug 2013 13:10:08 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] memcg: rename cgroup_event to mem_cgroup_event
Message-ID: <20130805171008.GC23751@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375632446-2581-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2d3340a32a52602ec4cda348b26affeae52d1964 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 5 Aug 2013 12:00:24 -0400

cgroup_event is only available in memcg now.  Let's brand it that way.
While at it, add a comment encouraging deprecation of the feature and
remove the respective section from cgroup documentation.

This patch is cosmetic.

v2: Index in cgroups.txt updated accordingly as suggested by Li Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 Documentation/cgroups/cgroups.txt | 20 --------------
 mm/memcontrol.c                   | 57 +++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 638bf17..821de56 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -24,7 +24,6 @@ CONTENTS:
   2.1 Basic Usage
   2.2 Attaching processes
   2.3 Mounting hierarchies by name
-  2.4 Notification API
 3. Kernel API
   3.1 Overview
   3.2 Synchronization
@@ -472,25 +471,6 @@ you give a subsystem a name.
 The name of the subsystem appears as part of the hierarchy description
 in /proc/mounts and /proc/<pid>/cgroups.
 
-2.4 Notification API
---------------------
-
-There is mechanism which allows to get notifications about changing
-status of a cgroup.
-
-To register a new notification handler you need to:
- - create a file descriptor for event notification using eventfd(2);
- - open a control file to be monitored (e.g. memory.usage_in_bytes);
- - write "<event_fd> <control_fd> <args>" to cgroup.event_control.
-   Interpretation of args is defined by control file implementation;
-
-eventfd will be woken up by control file implementation or when the
-cgroup is removed.
-
-To unregister a notification handler just close eventfd.
-
-NOTE: Support of notifications should be implemented for the control
-file. See documentation for the subsystem.
 
 3. Kernel API
 =============
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 023077d..24f5843 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -243,7 +243,7 @@ struct mem_cgroup_eventfd_list {
 /*
  * cgroup_event represents events which userspace want to receive.
  */
-struct cgroup_event {
+struct mem_cgroup_event {
 	/*
 	 * css which the event belongs to.
 	 */
@@ -5978,14 +5978,27 @@ static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 #endif
 
 /*
+ * DO NOT USE IN NEW FILES.
+ *
+ * "cgroup.event_control" implementation.
+ *
+ * This is way over-engineered.  It tries to support fully configureable
+ * events for each user.  Such level of flexibility is completely
+ * unnecessary especially in the light of the planned unified hierarchy.
+ *
+ * Please deprecate this and replace with something simpler if at all
+ * possible.
+ */
+
+/*
  * Unregister event and free resources.
  *
  * Gets called from workqueue.
  */
-static void cgroup_event_remove(struct work_struct *work)
+static void memcg_event_remove(struct work_struct *work)
 {
-	struct cgroup_event *event = container_of(work, struct cgroup_event,
-			remove);
+	struct mem_cgroup_event *event = container_of(work,
+					struct mem_cgroup_event, remove);
 	struct cgroup_subsys_state *css = event->css;
 	struct cgroup *cgrp = css->cgroup;
 
@@ -6006,11 +6019,11 @@ static void cgroup_event_remove(struct work_struct *work)
  *
  * Called with wqh->lock held and interrupts disabled.
  */
-static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
-		int sync, void *key)
+static int memcg_event_wake(wait_queue_t *wait, unsigned mode,
+			    int sync, void *key)
 {
-	struct cgroup_event *event = container_of(wait,
-			struct cgroup_event, wait);
+	struct mem_cgroup_event *event =
+		container_of(wait, struct mem_cgroup_event, wait);
 	struct mem_cgroup *memcg = mem_cgroup_from_css(event->css);
 	unsigned long flags = (unsigned long)key;
 
@@ -6039,28 +6052,30 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	return 0;
 }
 
-static void cgroup_event_ptable_queue_proc(struct file *file,
+static void memcg_event_ptable_queue_proc(struct file *file,
 		wait_queue_head_t *wqh, poll_table *pt)
 {
-	struct cgroup_event *event = container_of(pt,
-			struct cgroup_event, pt);
+	struct mem_cgroup_event *event =
+		container_of(pt, struct mem_cgroup_event, pt);
 
 	event->wqh = wqh;
 	add_wait_queue(wqh, &event->wait);
 }
 
 /*
+ * DO NOT USE IN NEW FILES.
+ *
  * Parse input and register new memcg event handler.
  *
  * Input must be in format '<event_fd> <control_fd> <args>'.
  * Interpretation of args is defined by control file implementation.
  */
-static int cgroup_write_event_control(struct cgroup_subsys_state *css,
-				      struct cftype *cft, const char *buffer)
+static int memcg_write_event_control(struct cgroup_subsys_state *css,
+				     struct cftype *cft, const char *buffer)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct cgroup *cgrp = css->cgroup;
-	struct cgroup_event *event;
+	struct mem_cgroup_event *event;
 	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile;
@@ -6083,9 +6098,9 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 		return -ENOMEM;
 	event->css = css;
 	INIT_LIST_HEAD(&event->list);
-	init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
-	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
-	INIT_WORK(&event->remove, cgroup_event_remove);
+	init_poll_funcptr(&event->pt, memcg_event_ptable_queue_proc);
+	init_waitqueue_func_entry(&event->wait, memcg_event_wake);
+	INIT_WORK(&event->remove, memcg_event_remove);
 
 	efile = eventfd_fget(efd);
 	if (IS_ERR(efile)) {
@@ -6131,6 +6146,8 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 	 * to be done via struct cftype but cgroup core no longer knows
 	 * about these events.  The following is crude but the whole thing
 	 * is for compatibility anyway.
+	 *
+	 * DO NOT ADD NEW FILES.
 	 */
 	if (!strcmp(event->cft->name, "usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -6228,8 +6245,8 @@ static struct cftype mem_cgroup_files[] = {
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
 	{
-		.name = "cgroup.event_control",
-		.write_string = cgroup_write_event_control,
+		.name = "cgroup.event_control",		/* XXX: for compat */
+		.write_string = memcg_write_event_control,
 		.flags = CFTYPE_NO_PREFIX,
 		.mode = S_IWUGO,
 	},
@@ -6562,7 +6579,7 @@ static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
 static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct cgroup_event *event, *tmp;
+	struct mem_cgroup_event *event, *tmp;
 
 	/*
 	 * Unregister events and notify userspace.
-- 
1.8.3.1

