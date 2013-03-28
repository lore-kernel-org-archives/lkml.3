Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3C1ENW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:13:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:28368 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3C1ENU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:13:20 -0400
Message-ID: <5153C33E.2010004@huawei.com>
Date: Thu, 28 Mar 2013 12:12:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] cpuacct: Add cpuacct_acount_field()
References: <5153C2D6.7050103@huawei.com>
In-Reply-To: <5153C2D6.7050103@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can remove open-coded cpuacct code in cputime.c.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.c | 23 +++++++++++++++++++++++
 kernel/sched/cpuacct.h |  6 ++++++
 kernel/sched/cputime.c | 18 +-----------------
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 48b5e91..72bd971 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -218,6 +218,29 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	rcu_read_unlock();
 }
 
+/*
+ * Add user/system time to cpuacct.
+ *
+ * Note: it's the caller that updates the account of the root cgroup.
+ */
+void cpuacct_account_field(struct task_struct *p, int index, u64 val)
+{
+	struct kernel_cpustat *kcpustat;
+	struct cpuacct *ca;
+
+	if (unlikely(!cpuacct_subsys.active))
+		return;
+
+	rcu_read_lock();
+	ca = task_ca(p);
+	while (ca && (ca != &root_cpuacct)) {
+		kcpustat = this_cpu_ptr(ca->cpustat);
+		kcpustat->cpustat[index] += val;
+		ca = parent_ca(ca);
+	}
+	rcu_read_unlock();
+}
+
 void __init cpuacct_init(void)
 {
 	root_cpuacct.cpustat = &kernel_cpustat;
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index 551acd7..bd0409b 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -43,6 +43,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 
 extern void cpuacct_init(void);
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+extern void cpuacct_account_field(struct task_struct *p, int index, u64 val);
 
 #else
 
@@ -54,4 +55,9 @@ static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 }
 
+static inline void
+cpuacct_account_field(struct task_struct *p, int index, u64 val)
+{
+}
+
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..a5129c7 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -115,10 +115,6 @@ static int irqtime_account_si_update(void)
 static inline void task_group_account_field(struct task_struct *p, int index,
 					    u64 tmp)
 {
-#ifdef CONFIG_CGROUP_CPUACCT
-	struct kernel_cpustat *kcpustat;
-	struct cpuacct *ca;
-#endif
 	/*
 	 * Since all updates are sure to touch the root cgroup, we
 	 * get ourselves ahead and touch it first. If the root cgroup
@@ -127,19 +123,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 */
 	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
 
-#ifdef CONFIG_CGROUP_CPUACCT
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	rcu_read_lock();
-	ca = task_ca(p);
-	while (ca && (ca != &root_cpuacct)) {
-		kcpustat = this_cpu_ptr(ca->cpustat);
-		kcpustat->cpustat[index] += tmp;
-		ca = parent_ca(ca);
-	}
-	rcu_read_unlock();
-#endif
+	cpuacct_account_field(p, index, tmp);
 }
 
 /*
-- 
1.8.0.2
