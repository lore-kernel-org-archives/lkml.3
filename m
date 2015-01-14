Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbbANODe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:03:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36893 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbANODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:03:32 -0500
Date: Wed, 14 Jan 2015 06:02:49 -0800
From: tip-bot for Yao Dongdong <tipbot@zytor.com>
Message-ID: <tip-1b537c7d1e58c761212a193085f9049b58f672e6@git.kernel.org>
Cc: tglx@linutronix.de, yaodongdong@huawei.com, torvalds@linux-foundation.org,
        mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hpa@zytor.com, torvalds@linux-foundation.org,
        mingo@kernel.org, yaodongdong@huawei.com
In-Reply-To: <1419835303-28958-1-git-send-email-yaodongdong@huawei.com>
References: <1419835303-28958-1-git-send-email-yaodongdong@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core: Remove check of p->sched_class
Git-Commit-ID: 1b537c7d1e58c761212a193085f9049b58f672e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b537c7d1e58c761212a193085f9049b58f672e6
Gitweb:     http://git.kernel.org/tip/1b537c7d1e58c761212a193085f9049b58f672e6
Author:     Yao Dongdong <yaodongdong@huawei.com>
AuthorDate: Mon, 29 Dec 2014 14:41:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:17 +0100

sched/core: Remove check of p->sched_class

Search all usage of p->sched_class in sched/core.c, no one check it
before use, so it seems that every task must belong to one sched_class.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
[ Moved the early class assignment to make it boot. ]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1419835303-28958-1-git-send-email-yaodongdong@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 95ac795..46a2345 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4744,7 +4744,7 @@ static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
 
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
-	if (p->sched_class && p->sched_class->set_cpus_allowed)
+	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
@@ -7254,6 +7254,11 @@ void __init sched_init(void)
 	enter_lazy_tlb(&init_mm, current);
 
 	/*
+	 * During early bootup we pretend to be a normal task:
+	 */
+	current->sched_class = &fair_sched_class;
+
+	/*
 	 * Make us the idle thread. Technically, schedule() should not be
 	 * called from this thread, however somewhere below it might be,
 	 * but because we are the idle thread, we just pick up running again
@@ -7263,11 +7268,6 @@ void __init sched_init(void)
 
 	calc_load_update = jiffies + LOAD_FREQ;
 
-	/*
-	 * During early bootup we pretend to be a normal task:
-	 */
-	current->sched_class = &fair_sched_class;
-
 #ifdef CONFIG_SMP
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 	/* May be allocated at isolcpus cmdline parse time */
