Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3DBHQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:16:45 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42114 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3DBHQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:16:44 -0400
Message-ID: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [PATCH cpuset] Use rebuild_sched_domains() in
 cpuset_hotplug_workfn()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org
Date: Tue, 02 Apr 2013 15:16:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040207-5140-0000-0000-000002F938FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpuset_hotplug_workfn(), partition_sched_domains() is called without
hotplug lock held, which is actually needed (stated in the function
header of partition_sched_domains()). 

This patch tries to use rebuild_sched_domains() to solve the above
issue, and makes the code looks a little simpler.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/cpuset.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4f9dfe4..515a713 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2222,17 +2222,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
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


