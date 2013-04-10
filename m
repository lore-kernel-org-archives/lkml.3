Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935800Ab3DJNka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:40:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3DJNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:40:29 -0400
Date: Wed, 10 Apr 2013 06:40:11 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-1966aaf7d54608e8ddb7ac454b461840e763409a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <51553692.9060008@huawei.com>
References: <51553692.9060008@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct: Add cpuacct_acount_field()
Git-Commit-ID: 1966aaf7d54608e8ddb7ac454b461840e763409a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:40:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1966aaf7d54608e8ddb7ac454b461840e763409a
Gitweb:     http://git.kernel.org/tip/1966aaf7d54608e8ddb7ac454b461840e763409a
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:37:06 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:17 +0200

sched/cpuacct: Add cpuacct_acount_field()

So we can remove open-coded cpuacct code in cputime.c.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51553692.9060008@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 699d597..33508dc 100644
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
