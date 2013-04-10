Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936040Ab3DJNlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:41:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3DJNli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:41:38 -0400
Date: Wed, 10 Apr 2013 06:41:22 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-543bc0e76e6bb84300eaf9833edc5a481f788678@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <515536A9.5000700@huawei.com>
References: <515536A9.5000700@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct:
  Remove redundant NULL checks in cpuacct_charge()
Git-Commit-ID: 543bc0e76e6bb84300eaf9833edc5a481f788678
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:41:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  543bc0e76e6bb84300eaf9833edc5a481f788678
Gitweb:     http://git.kernel.org/tip/543bc0e76e6bb84300eaf9833edc5a481f788678
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:37:29 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:18 +0200

sched/cpuacct: Remove redundant NULL checks in cpuacct_charge()

This is a micro optimization for the hot path.

- We don't need to check if @ca is NULL in parent_ca().
- We don't need to check if @ca is NULL in the beginning of the for loop.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/515536A9.5000700@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
