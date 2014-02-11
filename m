Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBKIYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:24:53 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57148 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaBKIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:24:49 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH 2/2] sched/core: make dl_b->lock IRQ safe
Date: Tue, 11 Feb 2014 09:24:27 +0100
Message-Id: <1392107067-19907-3-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
References: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this lockdep warning:

[   44.804600] =========================================================
[   44.805746] [ INFO: possible irq lock inversion dependency detected ]
[   44.805746] 3.14.0-rc2-test+ #14 Not tainted
[   44.805746] ---------------------------------------------------------
[   44.805746] bash/3674 just changed the state of lock:
[   44.805746]  (&dl_b->lock){+.....}, at: [<ffffffff8106ad15>] sched_rt_handler+0x132/0x248
[   44.805746] but this lock was taken by another, HARDIRQ-safe lock in the past:
[   44.805746]  (&rq->lock){-.-.-.}

and interrupts could create inverse lock ordering between them.

[   44.805746]
[   44.805746] other info that might help us debug this:
[   44.805746]  Possible interrupt unsafe locking scenario:
[   44.805746]
[   44.805746]        CPU0                    CPU1
[   44.805746]        ----                    ----
[   44.805746]   lock(&dl_b->lock);
[   44.805746]                                local_irq_disable();
[   44.805746]                                lock(&rq->lock);
[   44.805746]                                lock(&dl_b->lock);
[   44.805746]   <Interrupt>
[   44.805746]     lock(&rq->lock);

by making dl_b->lock acquiring always IRQ safe.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 604dd4e..ed006be 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7412,6 +7412,7 @@ static int sched_dl_global_constraints(void)
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
 	int cpu, ret = 0;
+	unsigned long flags;
 
 	/*
 	 * Here we want to check the bandwidth not being set to some
@@ -7425,10 +7426,10 @@ static int sched_dl_global_constraints(void)
 	for_each_possible_cpu(cpu) {
 		struct dl_bw *dl_b = dl_bw_of(cpu);
 
-		raw_spin_lock(&dl_b->lock);
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		if (new_bw < dl_b->total_bw)
 			ret = -EBUSY;
-		raw_spin_unlock(&dl_b->lock);
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
 		if (ret)
 			break;
@@ -7441,6 +7442,7 @@ static void sched_dl_do_global(void)
 {
 	u64 new_bw = -1;
 	int cpu;
+	unsigned long flags;
 
 	def_dl_bandwidth.dl_period = global_rt_period();
 	def_dl_bandwidth.dl_runtime = global_rt_runtime();
@@ -7454,9 +7456,9 @@ static void sched_dl_do_global(void)
 	for_each_possible_cpu(cpu) {
 		struct dl_bw *dl_b = dl_bw_of(cpu);
 
-		raw_spin_lock(&dl_b->lock);
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		dl_b->bw = new_bw;
-		raw_spin_unlock(&dl_b->lock);
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
 }
 
-- 
1.7.9.5

