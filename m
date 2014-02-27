Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaB0OVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:21:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0OVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: lizefan@huawei.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] cpuset: Add missing rcu read locks
Date: Thu, 27 Feb 2014 09:20:55 -0500
Message-Id: <1393510855-8771-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call task_cs() which ends up going into cgroup code without having rcu
read lock. Fix it by grabbing the lock before retrival of task_cs() and usage
of the result.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/cpuset.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index be9c1da..64bd8a4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2240,8 +2240,10 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 
 	mutex_lock(&callback_mutex);
 	task_lock(tsk);
+	rcu_read_lock();
 	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
 	guarantee_online_cpus(cpus_cs, pmask);
+	rcu_read_unlock();
 	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 }
@@ -2296,8 +2298,10 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
 
 	mutex_lock(&callback_mutex);
 	task_lock(tsk);
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &mask);
+	rcu_read_unlock();
 	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 
-- 
1.7.2.5

