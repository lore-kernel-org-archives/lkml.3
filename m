Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750805AbaLOL5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:57:06 -0500
Received: from relay.parallels.com ([195.214.232.42]:48950 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:57:02 -0500
Message-ID: <1418644618.6074.13.camel@tkhai>
Subject: [PATCH] sched/fair: Fix sched_entity::avg::decay_count
 initialization
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Mon, 15 Dec 2014 14:56:58 +0300
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Child has the same decay_count as parent. If it's not zero,
we add it to parent's cfs_rq->removed_load:

wake_up_new_task()->set_task_cpu()->migrate_task_rq_fair().

Child's load is a just garbade after copying of parent,
it hasn't been on cfs_rq yet, and it must not be added to
cfs_rq::removed_load in migrate_task_rq_fair().

The patch moves sched_entity::avg::decay_count intialization
in sched_fork(). So, migrate_task_rq_fair() does not change
removed_load.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |    1 +
 kernel/sched/fair.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bb398c0..2894b69 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1832,6 +1832,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
 	p->se.vruntime			= 0;
+	p->se.avg.decay_count		= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..5f3b5a7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -676,7 +676,6 @@ void init_task_runnable_average(struct task_struct *p)
 {
 	u32 slice;
 
-	p->se.avg.decay_count = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
 	p->se.avg.runnable_avg_sum = slice;
 	p->se.avg.runnable_avg_period = slice;



