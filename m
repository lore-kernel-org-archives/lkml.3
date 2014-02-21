Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaBUUcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:32:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaBUUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:32:41 -0500
Date: Fri, 21 Feb 2014 12:32:03 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-495163420ab5398c84af96ca3eae2c6aa4a140da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <1392107067-19907-3-git-send-email-juri.lelli@gmail.com>
References: <1392107067-19907-3-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/core: Make dl_b->lock IRQ safe
Git-Commit-ID: 495163420ab5398c84af96ca3eae2c6aa4a140da
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

Commit-ID:  495163420ab5398c84af96ca3eae2c6aa4a140da
Gitweb:     http://git.kernel.org/tip/495163420ab5398c84af96ca3eae2c6aa4a140da
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Tue, 11 Feb 2014 09:24:27 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched/core: Make dl_b->lock IRQ safe

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
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392107067-19907-3-git-send-email-juri.lelli@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 98d33c1..33d030a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7422,6 +7422,7 @@ static int sched_dl_global_constraints(void)
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
 	int cpu, ret = 0;
+	unsigned long flags;
 
 	/*
 	 * Here we want to check the bandwidth not being set to some
@@ -7435,10 +7436,10 @@ static int sched_dl_global_constraints(void)
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
@@ -7451,6 +7452,7 @@ static void sched_dl_do_global(void)
 {
 	u64 new_bw = -1;
 	int cpu;
+	unsigned long flags;
 
 	def_dl_bandwidth.dl_period = global_rt_period();
 	def_dl_bandwidth.dl_runtime = global_rt_runtime();
@@ -7464,9 +7466,9 @@ static void sched_dl_do_global(void)
 	for_each_possible_cpu(cpu) {
 		struct dl_bw *dl_b = dl_bw_of(cpu);
 
-		raw_spin_lock(&dl_b->lock);
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		dl_b->bw = new_bw;
-		raw_spin_unlock(&dl_b->lock);
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
 }
 
