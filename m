Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3D0KAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 06:00:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21800 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3D0KAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 06:00:51 -0400
Message-ID: <517BA01C.6060806@huawei.com>
Date: Sat, 27 Apr 2013 17:53:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

In cpuset_hotplug_workfn(), partition_sched_domains() is called without
hotplug lock held, which is actually needed (stated in the function
header of partition_sched_domains()).

This patch tries to use rebuild_sched_domains() to solve the above
issue, and makes the code looks a little simpler.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 943968d..b0f18ba 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2184,17 +2184,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	flush_workqueue(cpuset_propagate_hotplug_wq);
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated) {
-		struct sched_domain_attr *attr;
-		cpumask_var_t *doms;
-		int ndoms;
-
-		mutex_lock(&cpuset_mutex);
-		ndoms = generate_sched_domains(&doms, &attr);
-		mutex_unlock(&cpuset_mutex);
-
-		partition_sched_domains(ndoms, doms, attr);
-	}
+	if (cpus_updated)
+		rebuild_sched_domains();
 }
 
 void cpuset_update_active_cpus(bool cpu_online)
-- 
1.8.0.2
