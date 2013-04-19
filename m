Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab3DSM1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:27:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58629 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030388Ab3DSM1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:27:09 -0400
Message-ID: <51713819.8050708@huawei.com>
Date: Fri, 19 Apr 2013 20:27:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask in
 an empty cpuset
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this was introduced unintentionally when cpuset hotplug was
made asynchronous. Fortunately it does no harm, as updating tasks'
cpumask will just return failure and there's a guarantee_online_mems()
when updating nodemask, and then the tasks will be moved to an ancestor
cpuset.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 8b0e433..2e4c5af 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2013,7 +2013,9 @@ static void cpuset_propagate_hotplug_workfn(struct work_struct *work)
 		mutex_lock(&callback_mutex);
 		cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
 		mutex_unlock(&callback_mutex);
-		update_tasks_cpumask(cs, NULL);
+
+		if (!cpumask_empty(cs->cpus_allowed))
+			update_tasks_cpumask(cs, NULL);
 	}
 
 	/* remove offline mems from @cs */
@@ -2022,7 +2024,9 @@ static void cpuset_propagate_hotplug_workfn(struct work_struct *work)
 		mutex_lock(&callback_mutex);
 		nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
 		mutex_unlock(&callback_mutex);
-		update_tasks_nodemask(cs, &tmp_mems, NULL);
+
+		if (!nodes_empty(cs->mems_allowed))
+			update_tasks_nodemask(cs, &tmp_mems, NULL);
 	}
 
 	is_empty = cpumask_empty(cs->cpus_allowed) ||
-- 
1.8.0.2
