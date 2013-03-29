Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3C2Gi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:38:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62227 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3C2GiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:38:25 -0400
Message-ID: <51553687.1060906@huawei.com>
Date: Fri, 29 Mar 2013 14:36:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/7] cpuacct: Add cpuacct_init()
References: <5155365F.1010203@huawei.com>
In-Reply-To: <5155365F.1010203@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we don't open-coded initialization of cpuacct in core.c.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/core.c    | 8 ++------
 kernel/sched/cpuacct.c | 7 +++++++
 kernel/sched/cpuacct.h | 5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c4e2b81..c7016c1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6936,12 +6936,8 @@ void __init sched_init(void)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-#ifdef CONFIG_CGROUP_CPUACCT
-	root_cpuacct.cpustat = &kernel_cpustat;
-	root_cpuacct.cpuusage = alloc_percpu(u64);
-	/* Too early, not expected to fail */
-	BUG_ON(!root_cpuacct.cpuusage);
-#endif
+	cpuacct_init();
+
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 50ec24b..48b5e91 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -218,6 +218,13 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	rcu_read_unlock();
 }
 
+void __init cpuacct_init(void)
+{
+	root_cpuacct.cpustat = &kernel_cpustat;
+	root_cpuacct.cpuusage = alloc_percpu(u64);
+	BUG_ON(!root_cpuacct.cpuusage); /* Too early, not expected to fail */
+}
+
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.css_alloc = cpuacct_css_alloc,
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index a7f3d4a..551acd7 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -41,10 +41,15 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	return cgroup_ca(ca->css.cgroup->parent);
 }
 
+extern void cpuacct_init(void);
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 
 #else
 
+static inline void cpuacct_init(void)
+{
+}
+
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 }
-- 
1.8.0.2
