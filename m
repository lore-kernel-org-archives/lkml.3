Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaFXUcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:32:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaFXUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:32:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>,
        linux-man <linux-man@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 46/65] sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE
Date: Tue, 24 Jun 2014 13:30:06 -0700
Message-Id: <1403641825-12825-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit ce5f7f8200ca2504f6f290044393d73ca314965a upstream.

The way we read POSIX one should only call sched_getparam() when
sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.

Given that we currently return sched_param::sched_priority=0 for all
others, extend the same behaviour to SCHED_DEADLINE.

Requested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: linux-man <linux-man@vger.kernel.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140512205034.GH13467@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ kamal: backport to 3.8-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5e2f7c3..8188769 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4039,7 +4039,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
  */
 SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 {
-	struct sched_param lp;
+	struct sched_param lp = { .sched_priority = 0 };
 	struct task_struct *p;
 	int retval;
 
@@ -4056,7 +4056,8 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	if (retval)
 		goto out_unlock;
 
-	lp.sched_priority = p->rt_priority;
+	if (task_has_rt_policy(p))
+		lp.sched_priority = p->rt_priority;
 	rcu_read_unlock();
 
 	/*
-- 
1.9.1

