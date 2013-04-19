Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030376Ab3DSM0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:26:12 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21546 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220Ab3DSM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:26:10 -0400
Message-ID: <517137DC.8060401@huawei.com>
Date: Fri, 19 Apr 2013 20:26:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 03/10] cpuset: remove unnecessary variable in cpuset_attach()
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can just use oldcs->mems_allowed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6f9d5e0..66302a9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1406,8 +1406,7 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
-	/* static bufs protected by cpuset_mutex */
-	static nodemask_t cpuset_attach_nodemask_from;
+	/* static buf protected by cpuset_mutex */
 	static nodemask_t cpuset_attach_nodemask_to;
 	struct mm_struct *mm;
 	struct task_struct *task;
@@ -1441,13 +1440,12 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	 * Change mm, possibly for multiple threads in a threadgroup. This is
 	 * expensive and may sleep.
 	 */
-	cpuset_attach_nodemask_from = oldcs->mems_allowed;
 	cpuset_attach_nodemask_to = cs->mems_allowed;
 	mm = get_task_mm(leader);
 	if (mm) {
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &cpuset_attach_nodemask_from,
+			cpuset_migrate_mm(mm, &oldcs->mems_allowed,
 					  &cpuset_attach_nodemask_to);
 		mmput(mm);
 	}
-- 
1.8.0.2
