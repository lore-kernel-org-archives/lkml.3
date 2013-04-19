Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395Ab3DSM0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:26:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26818 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220Ab3DSM0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:26:18 -0400
Message-ID: <517137CA.9080403@huawei.com>
Date: Fri, 19 Apr 2013 20:25:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 02/10] cpuset: cleanup guarantee_online_{cpus|mems}()
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- We never pass a NULL @cs to these functions.
- The top cpuset always has some online cpus/mems.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4a62dcc..6f9d5e0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -304,53 +304,38 @@ static struct file_system_type cpuset_fs_type = {
 /*
  * Return in pmask the portion of a cpusets's cpus_allowed that
  * are online.  If none are online, walk up the cpuset hierarchy
- * until we find one that does have some online cpus.  If we get
- * all the way to the top and still haven't found any online cpus,
- * return cpu_online_mask.  Or if passed a NULL cs from an exit'ing
- * task, return cpu_online_mask.
+ * until we find one that does have some online cpus.  The top
+ * cpuset always has some cpus online.
  *
  * One way or another, we guarantee to return some non-empty subset
  * of cpu_online_mask.
  *
  * Call with callback_mutex held.
  */
-
 static void guarantee_online_cpus(const struct cpuset *cs,
 				  struct cpumask *pmask)
 {
-	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
+	while (!cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cs = parent_cs(cs);
-	if (cs)
-		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
-	else
-		cpumask_copy(pmask, cpu_online_mask);
-	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
+	cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 }
 
 /*
  * Return in *pmask the portion of a cpusets's mems_allowed that
  * are online, with memory.  If none are online with memory, walk
  * up the cpuset hierarchy until we find one that does have some
- * online mems.  If we get all the way to the top and still haven't
- * found any online mems, return node_states[N_MEMORY].
+ * online mems.  The top cpuset always has some mems online.
  *
  * One way or another, we guarantee to return some non-empty subset
  * of node_states[N_MEMORY].
  *
  * Call with callback_mutex held.
  */
-
 static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 {
-	while (cs && !nodes_intersects(cs->mems_allowed,
-					node_states[N_MEMORY]))
+	while (!nodes_intersects(cs->mems_allowed, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
-	if (cs)
-		nodes_and(*pmask, cs->mems_allowed,
-					node_states[N_MEMORY]);
-	else
-		*pmask = node_states[N_MEMORY];
-	BUG_ON(!nodes_intersects(*pmask, node_states[N_MEMORY]));
+	nodes_and(*pmask, cs->mems_allowed, node_states[N_MEMORY]);
 }
 
 /*
-- 
1.8.0.2
