Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3FMHMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:12:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61518 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3FMHMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:12:50 -0400
Message-ID: <51B970B0.2040907@huawei.com>
Date: Thu, 13 Jun 2013 15:11:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 7/7] cpuset: fix to migrate mm correctly in a corner case
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before moving tasks out of empty cpusets, update_tasks_nodemask()
is called, which calls do_migrate_pages(xx, from, to). Then those
tasks are moved to an ancestor, and do_migrate_pages() is called
again.

The first time: from = node_to_be_offlined, to = empty.
The second time: from = empty, to = ancestor's nodemask.

so looks like no pages will be migrated.

Fix this by:

- Don't call update_tasks_nodemask() on empty cpusets.
- Pass cs->old_mems_allowed to do_migrate_pages().

v4: added comment in cpuset_hotplug_update_tasks() and rephased comment
    in cpuset_attach().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d1d6782..3be9597 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1563,9 +1563,18 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 		struct cpuset *mems_oldcs = effective_nodemask_cpuset(oldcs);
 
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
-		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &mems_oldcs->mems_allowed,
+
+		/*
+		 * old_mems_allowed is the same with mems_allowed here, except
+		 * if this task is being moved automatically due to hotplug.
+		 * In that case @mems_allowed has been updated and is empty,
+		 * so @old_mems_allowed is the right nodesets that we migrate
+		 * mm from.
+		 */
+		if (is_memory_migrate(cs)) {
+			cpuset_migrate_mm(mm, &mems_oldcs->old_mems_allowed,
 					  &cpuset_attach_nodemask_to);
+		}
 		mmput(mm);
 	}
 
@@ -2152,10 +2161,12 @@ retry:
 
 	/*
 	 * If sane_behavior flag is set, we need to update tasks' cpumask
-	 * for empty cpuset to take on ancestor's cpumask.
+	 * for empty cpuset to take on ancestor's cpumask. Otherwise, don't
+	 * call update_tasks_cpumask() if the cpuset becomes empty, as
+	 * the tasks in it will be migrated to an ancestor.
 	 */
 	if ((sane && cpumask_empty(cs->cpus_allowed)) ||
-	    !cpumask_empty(&off_cpus))
+	    (!cpumask_empty(&off_cpus) && !cpumask_empty(cs->cpus_allowed)))
 		update_tasks_cpumask(cs, NULL);
 
 	mutex_lock(&callback_mutex);
@@ -2164,10 +2175,12 @@ retry:
 
 	/*
 	 * If sane_behavior flag is set, we need to update tasks' nodemask
-	 * for empty cpuset to take on ancestor's nodemask.
+	 * for empty cpuset to take on ancestor's nodemask. Otherwise, don't
+	 * call update_tasks_nodemask() if the cpuset becomes empty, as
+	 * the tasks in it will be migratd to an ancestor.
 	 */
 	if ((sane && nodes_empty(cs->mems_allowed)) ||
-	    !nodes_empty(off_mems))
+	    (!nodes_empty(off_mems) && !nodes_empty(cs->mems_allowed)))
 		update_tasks_nodemask(cs, NULL);
 
 	is_empty = cpumask_empty(cs->cpus_allowed) ||
-- 
1.8.0.2
