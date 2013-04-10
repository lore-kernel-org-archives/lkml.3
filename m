Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935712Ab3DJNjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:39:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab3DJNjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:39:16 -0400
Date: Wed, 10 Apr 2013 06:38:59 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-dbe4b41f9800223949ce72e4289814697e0ea91a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <51553687.1060906@huawei.com>
References: <51553687.1060906@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct: Add cpuacct_init()
Git-Commit-ID: dbe4b41f9800223949ce72e4289814697e0ea91a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:39:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbe4b41f9800223949ce72e4289814697e0ea91a
Gitweb:     http://git.kernel.org/tip/dbe4b41f9800223949ce72e4289814697e0ea91a
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:36:55 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:16 +0200

sched/cpuacct: Add cpuacct_init()

So we don't open-coded initialization of cpuacct in core.c.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51553687.1060906@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c    | 8 ++------
 kernel/sched/cpuacct.c | 7 +++++++
 kernel/sched/cpuacct.h | 5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c28222f..92930a8 100644
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
