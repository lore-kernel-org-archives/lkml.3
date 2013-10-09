Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3JIRfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:35:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab3JIRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:35:04 -0400
Date: Wed, 9 Oct 2013 10:34:32 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6ebt6x7u64pbbonq1khqu2z9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Reflow task_numa_group()
  to avoid a compiler warning
Git-Commit-ID: 3354781a2184380046c8dd19144628d3c33991e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:34:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3354781a2184380046c8dd19144628d3c33991e6
Gitweb:     http://git.kernel.org/tip/3354781a2184380046c8dd19144628d3c33991e6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 9 Oct 2013 10:24:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:27 +0200

sched/numa: Reflow task_numa_group() to avoid a compiler warning

Reflow the function a bit because GCC gets confused:

  kernel/sched/fair.c: In function ‘task_numa_fault’:
  kernel/sched/fair.c:1448:3: warning: ‘my_grp’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  kernel/sched/fair.c:1463:27: note: ‘my_grp’ was declared here

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-6ebt6x7u64pbbonq1khqu2z9@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e914930..803e343 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1493,28 +1493,28 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	tsk = ACCESS_ONCE(cpu_rq(cpu)->curr);
 
 	if (!cpupid_match_pid(tsk, cpupid))
-		goto unlock;
+		goto no_join;
 
 	grp = rcu_dereference(tsk->numa_group);
 	if (!grp)
-		goto unlock;
+		goto no_join;
 
 	my_grp = p->numa_group;
 	if (grp == my_grp)
-		goto unlock;
+		goto no_join;
 
 	/*
 	 * Only join the other group if its bigger; if we're the bigger group,
 	 * the other task will join us.
 	 */
 	if (my_grp->nr_tasks > grp->nr_tasks)
-		goto unlock;
+		goto no_join;
 
 	/*
 	 * Tie-break on the grp address.
 	 */
 	if (my_grp->nr_tasks == grp->nr_tasks && my_grp > grp)
-		goto unlock;
+		goto no_join;
 
 	/* Always join threads in the same process. */
 	if (tsk->mm == current->mm)
@@ -1528,9 +1528,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	*priv = !join;
 
 	if (join && !get_numa_group(grp))
-		join = false;
+		goto no_join;
 
-unlock:
 	rcu_read_unlock();
 
 	if (!join)
@@ -1555,6 +1554,11 @@ unlock:
 	rcu_assign_pointer(p->numa_group, grp);
 
 	put_numa_group(my_grp);
+	return;
+
+no_join:
+	rcu_read_unlock();
+	return;
 }
 
 void task_numa_free(struct task_struct *p)
