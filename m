Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030523Ab3DSMa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:30:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:59570 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab3DSMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:30:27 -0400
Message-ID: <517138B1.6070502@huawei.com>
Date: Fri, 19 Apr 2013 20:29:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 10/10] cpuset: allow to move tasks to empty cpusets
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently some cpuset behaviors are not friendly when cpuset is co-mounted
with other cgroup controllers.

Now with this patchset if cpuset is mounted with sane_behavior option,
it behaves differently:

- Tasks will be kept in empty cpusets when hotplug happens and take
  masks of ancestors with non-empty cpus/mems, instead of being moved to
  an ancestor.

- A task can be moved into an empty cpuset, and again it takes masks of
  ancestors, so we drop a task into a newly created cgroup without the
  user having to do anything for it.

As tasks can reside in empy cpusets, here're some rules:

- They can be moved to another cpuset, regardless it's empty or not.

- Though it takes masks from ancestors, it takes other configs from the
  empty cpuset.

- If the ancestors' masks are changed, those tasks will also be updated
  to take new masks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 95e9394..646c794 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -489,7 +489,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 	 */
 	ret = -ENOSPC;
 	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) ||
+	    (cpumask_empty(trial->cpus_allowed) &&
 	     nodes_empty(trial->mems_allowed)))
 		goto out;
 
@@ -1502,8 +1502,13 @@ static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 
 	mutex_lock(&cpuset_mutex);
 
+	/*
+	 * We allow to move tasks into an empty cpuset if sane_behavior
+	 * flag is set.
+	 */
 	ret = -ENOSPC;
-	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
+	if (!cgroup_sane_behavior(cgrp) &&
+	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, cgrp, tset) {
@@ -1608,7 +1613,8 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	 * propagation if @cs doesn't have any CPU or memory.  It will move
 	 * the newly added tasks to the nearest parent which can execute.
 	 */
-	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
+	if (!cgroup_sane_behavior(cgrp) &&
+	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		schedule_cpuset_propagate_hotplug(cs);
 
 	mutex_unlock(&cpuset_mutex);
-- 
1.8.0.2
