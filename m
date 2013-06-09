Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3FIJSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:18:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15757 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3FIJSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:18:23 -0400
Message-ID: <51B4480F.2050400@huawei.com>
Date: Sun, 9 Jun 2013 17:17:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v3 7/7] cpuset: fix to migrate mm correctly in a corner case
References: <51B4475A.8030509@huawei.com>
In-Reply-To: <51B4475A.8030509@huawei.com>
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

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d1d6782..3cd68b8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1563,9 +1563,16 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 		struct cpuset *mems_oldcs = effective_nodemask_cpuset(oldcs);
 
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
-		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &mems_oldcs->mems_allowed,
+		if (is_memory_migrate(cs)) {
+			/*
+			 * old_mems_allowed is the same with mems_allowed here,
+			 * except if this task is being moved automatically due
+			 * to hotplug, and in this case mems_allowed is empty
+			 * and old_mems_allowed is the offlined node.
+			 */
+			cpuset_migrate_mm(mm, &mems_oldcs->old_mems_allowed,
 					  &cpuset_attach_nodemask_to);
+		}
 		mmput(mm);
 	}
 
@@ -2155,7 +2162,7 @@ retry:
 	 * for empty cpuset to take on ancestor's cpumask.
 	 */
 	if ((sane && cpumask_empty(cs->cpus_allowed)) ||
-	    !cpumask_empty(&off_cpus))
+	    (!cpumask_empty(&off_cpus) && !cpumask_empty(cs->cpus_allowed)))
 		update_tasks_cpumask(cs, NULL);
 
 	mutex_lock(&callback_mutex);
@@ -2167,7 +2174,7 @@ retry:
 	 * for empty cpuset to take on ancestor's nodemask.
 	 */
 	if ((sane && nodes_empty(cs->mems_allowed)) ||
-	    !nodes_empty(off_mems))
+	    (!nodes_empty(off_mems) && !nodes_empty(cs->mems_allowed)))
 		update_tasks_nodemask(cs, NULL);
 
 	is_empty = cpumask_empty(cs->cpus_allowed) ||
-- 
1.8.0.2
