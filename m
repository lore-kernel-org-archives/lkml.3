Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3CLC2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:28:55 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:57757 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3CLC2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:28:53 -0400
Message-ID: <513E92D7.9050903@huawei.com>
Date: Tue, 12 Mar 2013 10:28:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cpuset: fix RCU lockdep splat in cpuset_print_task_mems_allowed()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha reported a lockdep warning when OOM was triggered. The reason
is cgroup_name() should be called with rcu_read_lock() held.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---

This fix is for 3.10

---
 kernel/cpuset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c55763b..98d458a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2599,6 +2599,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 
 	struct cgroup *cgrp = task_cs(tsk)->css.cgroup;
 
+	rcu_read_lock();
 	spin_lock(&cpuset_buffer_lock);
 
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
@@ -2607,6 +2608,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 	       tsk->comm, cgroup_name(cgrp), cpuset_nodelist);
 
 	spin_unlock(&cpuset_buffer_lock);
+	rcu_read_unlock();
 }
 
 /*
-- 
1.8.0.2
