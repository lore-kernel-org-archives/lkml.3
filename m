Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3C2Gpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:45:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:54751 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3C2GpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:45:21 -0400
Message-ID: <51553834.9090701@huawei.com>
Date: Fri, 29 Mar 2013 14:44:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 2/5] cpuacct: Initialize root cpuacct earlier
References: <51553813.10004@huawei.com>
In-Reply-To: <51553813.10004@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we don't need cpuacct_init(), and instead we just initialize
root_cpuacct when it's defined.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/core.c    |  2 --
 kernel/sched/cpuacct.c | 11 ++++-------
 kernel/sched/cpuacct.h |  5 -----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7016c1..5338e6d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6936,8 +6936,6 @@ void __init sched_init(void)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-	cpuacct_init();
-
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index a691c4d..0425581 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -59,7 +59,10 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 }
 
 static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
-static struct cpuacct root_cpuacct;
+static struct cpuacct root_cpuacct = {
+	.cpustat	= &kernel_cpustat,
+	.cpuusage	= &root_cpuacct_cpuusage,
+};
 
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
@@ -288,12 +291,6 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 	rcu_read_unlock();
 }
 
-void __init cpuacct_init(void)
-{
-	root_cpuacct.cpustat = &kernel_cpustat;
-	root_cpuacct.cpuusage = &root_cpuacct_cpuusage;
-}
-
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.css_alloc = cpuacct_css_alloc,
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index 51cd76e..ed60562 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -1,15 +1,10 @@
 #ifdef CONFIG_CGROUP_CPUACCT
 
-extern void cpuacct_init(void);
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 extern void cpuacct_account_field(struct task_struct *p, int index, u64 val);
 
 #else
 
-static inline void cpuacct_init(void)
-{
-}
-
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 }
-- 
1.8.0.2
