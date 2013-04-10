Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936220Ab3DJNq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:46:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab3DJNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:46:25 -0400
Date: Wed, 10 Apr 2013 06:46:08 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-14c6d3c8a47ced185b6375c4940b5b393f1a294e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
In-Reply-To: <51553834.9090701@huawei.com>
References: <51553834.9090701@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct: Initialize root cpuacct earlier
Git-Commit-ID: 14c6d3c8a47ced185b6375c4940b5b393f1a294e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:46:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14c6d3c8a47ced185b6375c4940b5b393f1a294e
Gitweb:     http://git.kernel.org/tip/14c6d3c8a47ced185b6375c4940b5b393f1a294e
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:44:04 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:20 +0200

sched/cpuacct: Initialize root cpuacct earlier

Now we don't need cpuacct_init(), and instead we just initialize
root_cpuacct when it's defined.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51553834.9090701@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c    |  2 --
 kernel/sched/cpuacct.c | 11 ++++-------
 kernel/sched/cpuacct.h |  5 -----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 92930a8..ee8c1bd 100644
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
