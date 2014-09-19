Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaISLr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:47:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaISLpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:45:31 -0400
Date: Fri, 19 Sep 2014 04:44:43 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-9c368b5b6eccce1cbd7f68142106b3b4ddb1c5b5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        tglx@linutronix.de, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        tglx@linutronix.de, sgruszka@redhat.com
In-Reply-To: <1410527535-9814-3-git-send-email-riel@redhat.com>
References: <1410527535-9814-3-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, time:
  Fix lock inversion in thread_group_cputime()
Git-Commit-ID: 9c368b5b6eccce1cbd7f68142106b3b4ddb1c5b5
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

Commit-ID:  9c368b5b6eccce1cbd7f68142106b3b4ddb1c5b5
Gitweb:     http://git.kernel.org/tip/9c368b5b6eccce1cbd7f68142106b3b4ddb1c5b5
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 12 Sep 2014 09:12:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:17 +0200

sched, time: Fix lock inversion in thread_group_cputime()

The sig->stats_lock nests inside the tasklist_lock and the
sighand->siglock in __exit_signal and wait_task_zombie.

However, both of those locks can be taken from irq context,
which means we need to use the interrupt safe variant of
read_seqbegin_or_lock. This blocks interrupts when the "lock"
branch is taken (seq is odd), preventing the lock inversion.

On the first (lockless) pass through the loop, irqs are not
blocked.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: prarit@redhat.com
Cc: oleg@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410527535-9814-3-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
