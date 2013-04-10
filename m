Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936032Ab3DJNmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:42:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3DJNmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:42:50 -0400
Date: Wed, 10 Apr 2013 06:42:33 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-5f40d804325e925409907e29f46ecb012090b6c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <515536B7.6060602@huawei.com>
References: <515536B7.6060602@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct:
  Remove redundant NULL checks in cpuacct_acount_field()
Git-Commit-ID: 5f40d804325e925409907e29f46ecb012090b6c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:42:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f40d804325e925409907e29f46ecb012090b6c2
Gitweb:     http://git.kernel.org/tip/5f40d804325e925409907e29f46ecb012090b6c2
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:37:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:18 +0200

sched/cpuacct: Remove redundant NULL checks in cpuacct_acount_field()

This is a micro optimazation for a hot path.

- We don't need to check if @ca returned from task_ca() is NULL.
- We don't need to check if @ca returned from parent_ca() is NULL.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/515536B7.6060602@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 45c1682..b2f79ad1 100644
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
