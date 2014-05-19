Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaESNHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:07:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59261 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaESNHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:07:49 -0400
Date: Mon, 19 May 2014 06:06:52 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-339d8f7bbf4a54fc09650b24ce505a4c04236bb3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, linux-man@vger.kernel.org,
        tglx@linutronix.de, mtk.manpages@gmail.com, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, linux-man@vger.kernel.org,
        tglx@linutronix.de, juri.lelli@gmail.com, mtk.manpages@gmail.com
In-Reply-To: <20140512205034.GH13467@laptop.programming.kicks-ass.net>
References: <20140512205034.GH13467@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core]
  peter_zijlstra-sched-change_sched_getparam_behaviour_vs_sched_deadline
Git-Commit-ID: 339d8f7bbf4a54fc09650b24ce505a4c04236bb3
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

Commit-ID:  339d8f7bbf4a54fc09650b24ce505a4c04236bb3
Gitweb:     http://git.kernel.org/tip/339d8f7bbf4a54fc09650b24ce505a4c04236bb3
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 12 May 2014 22:50:34 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:47:33 +0900

peter_zijlstra-sched-change_sched_getparam_behaviour_vs_sched_deadline

The way we read POSIX one should only call sched_getparam() when
sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.

Given that we currently return sched_param::sched_priority=0 for all
others, extend the same behaviour to SCHED_DEADLINE.

Cc: stable@vger.kernel.org
Cc: Dario Faggioli <raistlin@linux.it>
Cc: linux-man <linux-man@vger.kernel.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>
Requested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140512205034.GH13467@laptop.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cdefcf7..f3f08bf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3713,7 +3713,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
  */
 SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 {
-	struct sched_param lp;
+	struct sched_param lp = { .sched_priority = 0 };
 	struct task_struct *p;
 	int retval;
 
@@ -3730,11 +3730,8 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	if (retval)
 		goto out_unlock;
 
-	if (task_has_dl_policy(p)) {
-		retval = -EINVAL;
-		goto out_unlock;
-	}
-	lp.sched_priority = p->rt_priority;
+	if (task_has_rt_policy(p))
+		lp.sched_priority = p->rt_priority;
 	rcu_read_unlock();
 
 	/*
