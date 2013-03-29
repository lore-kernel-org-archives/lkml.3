Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3C2Gik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:38:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52997 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3C2Gij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:38:39 -0400
Message-ID: <515536A9.5000700@huawei.com>
Date: Fri, 29 Mar 2013 14:37:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/7] cpuacct: Remove redundant NULL checks in cpuacct_charge()
References: <5155365F.1010203@huawei.com>
In-Reply-To: <5155365F.1010203@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a micro optimization for the hot path.

- We don't need to check if @ca is NULL in parent_ca().
- We don't need to check if @ca is NULL in the beginning of the for loop.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.c | 6 +++++-
 kernel/sched/cpuacct.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 72bd971..b2aaaba 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -210,9 +210,13 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	ca = task_ca(tsk);
 
-	for (; ca; ca = parent_ca(ca)) {
+	while (true) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
+
+		ca = parent_ca(ca);
+		if (!ca)
+			break;
 	}
 
 	rcu_read_unlock();
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index bd0409b..45c1682 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -36,7 +36,7 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
 
 static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 {
-	if (!ca || !ca->css.cgroup->parent)
+	if (!ca->css.cgroup->parent)
 		return NULL;
 	return cgroup_ca(ca->css.cgroup->parent);
 }
-- 
1.8.0.2
