Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3C1EOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:14:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:35405 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3C1EOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:14:48 -0400
Message-ID: <5153C35F.10706@huawei.com>
Date: Thu, 28 Mar 2013 12:13:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] cpuacct: Remove redundant NULL checks in cpuacct_acount_field()
References: <5153C2D6.7050103@huawei.com>
In-Reply-To: <5153C2D6.7050103@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a micro optimazation for a hot path.

- We don't need to check if @ca returned from task_ca() is NULL.
- We don't need to check if @ca returned from parent_ca() is NULL.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.c | 4 ++--
 kernel/sched/cpuacct.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index b2aaaba..071ae8d 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -237,10 +237,10 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 
 	rcu_read_lock();
 	ca = task_ca(p);
-	while (ca && (ca != &root_cpuacct)) {
+	while (ca != &root_cpuacct) {
 		kcpustat = this_cpu_ptr(ca->cpustat);
 		kcpustat->cpustat[index] += val;
-		ca = parent_ca(ca);
+		ca = __parent_ca(ca);
 	}
 	rcu_read_unlock();
 }
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index 45c1682..b2f79ad 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -34,6 +34,11 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
 			    struct cpuacct, css);
 }
 
+static inline struct cpuacct *__parent_ca(struct cpuacct *ca)
+{
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
 static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 {
 	if (!ca->css.cgroup->parent)
-- 
1.8.0.2
