Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaILNgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:36:07 -0400
Received: from shelob.surriel.com ([74.92.59.67]:59603 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaILNgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:36:04 -0400
From: riel@redhat.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        oleg@redhat.com, sgruszka@redhat.com
Subject: [PATCH -tip 2/2] sched,time: fix lock inversion in thread_group_cputime
Date: Fri, 12 Sep 2014 09:12:15 -0400
Message-Id: <1410527535-9814-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410527535-9814-1-git-send-email-riel@redhat.com>
References: <1410527535-9814-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The sig->stats_lock nests inside the tasklist_lock and the
sighand->siglock in __exit_signal and wait_task_zombie.

However, both of those locks can be taken from irq context,
which means we need to use the interrupt safe variant of
read_seqbegin_or_lock. This blocks interrupts when the "lock"
branch is taken (seq is odd), preventing the lock inversion.

On the first (lockless) pass through the loop, irqs are not
blocked.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched/cputime.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 2b57031..64492df 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -289,13 +289,14 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	cputime_t utime, stime;
 	struct task_struct *t;
 	unsigned int seq, nextseq;
+	unsigned long flags;
 
 	rcu_read_lock();
 	/* Attempt a lockless read on the first round. */
 	nextseq = 0;
 	do {
 		seq = nextseq;
-		read_seqbegin_or_lock(&sig->stats_lock, &seq);
+		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
 		times->utime = sig->utime;
 		times->stime = sig->stime;
 		times->sum_exec_runtime = sig->sum_sched_runtime;
@@ -309,7 +310,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 		/* If lockless access failed, take the lock. */
 		nextseq = 1;
 	} while (need_seqretry(&sig->stats_lock, seq));
-	done_seqretry(&sig->stats_lock, seq);
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
 	rcu_read_unlock();
 }
 
-- 
1.9.3

