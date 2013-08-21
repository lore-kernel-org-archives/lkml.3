Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3HUCXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:23:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13332 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3HUCXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:23:49 -0400
Message-ID: <52142464.1060603@huawei.com>
Date: Wed, 21 Aug 2013 10:22:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cpuset: fix a regression in validating config change
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not allowed to clear masks of a cpuset if there're tasks in it,
but it's broken:

  # mkdir /cgroup/sub
  # echo 0 > /cgroup/sub/cpuset.cpus
  # echo 0 > /cgroup/sub/cpuset.mems
  # echo $$ > /cgroup/sub/tasks
  # echo > /cgroup/sub/cpuset.cpus
  (should fail)

This bug was introduced by commit 88fa523bff295f1d60244a54833480b02f775152
("cpuset: allow to move tasks to empty cpusets").

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0b5b9a3..70ab3fd 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -425,6 +425,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	struct cgroup_subsys_state *css;
 	struct cpuset *c, *par;
 	int ret;
+	bool make_cpus_empty;
+	bool make_mems_empty;
 
 	rcu_read_lock();
 
@@ -464,12 +466,15 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
-	 * have empty cpus_allowed or mems_allowed.
+	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
+	make_cpus_empty = !cpumask_empty(cur->cpus_allowed) &&
+			  cpumask_empty(trial->cpus_allowed);
+	make_mems_empty = !nodes_empty(cur->mems_allowed) &&
+			  nodes_empty(trial->mems_allowed);
 	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) &&
-	     nodes_empty(trial->mems_allowed)))
+	    (make_cpus_empty || make_mems_empty))
 		goto out;
 
 	ret = 0;
-- 
1.8.0.2
