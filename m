Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaAPNlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:41:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaAPNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:41:02 -0500
Date: Thu, 16 Jan 2014 05:40:30 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-39fd8fd22b3224ec6819d33b3e34ae4da6a35f05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        fengguang.wu@intel.com, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        fengguang.wu@intel.com, juri.lelli@gmail.com
In-Reply-To: <20140115153320.GH31570@twins.programming.kicks-ass.net>
References: <20140115153320.GH31570@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix up scheduler syscall LTP fails
Git-Commit-ID: 39fd8fd22b3224ec6819d33b3e34ae4da6a35f05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:40:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39fd8fd22b3224ec6819d33b3e34ae4da6a35f05
Gitweb:     http://git.kernel.org/tip/39fd8fd22b3224ec6819d33b3e34ae4da6a35f05
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 15 Jan 2014 16:33:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:15 +0100

sched: Fix up scheduler syscall LTP fails

Wu reported LTP failures:

  > ltp.sched_setparam02.1.TFAIL
  > ltp.sched_setparam02.2.TFAIL
  > ltp.sched_setparam02.3.TFAIL
  > ltp.sched_setparam03.1.TFAIL

There were 2 things wrong; firstly __setscheduler() failed on
sched_setparam()'s policy = -1, fix that by reading from p->policy in
that case.

Secondly, getparam() (and getattr()) would still report !0
sched_priority for !FIFO/RR tasks after having been such. So
unconditionally set p->rt_priority.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Link: http://lkml.kernel.org/r/20140115153320.GH31570@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1b3d7e..e9212eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3172,15 +3172,23 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 {
 	int policy = attr->sched_policy;
 
+	if (policy == -1) /* setparam */
+		policy = p->policy;
+
 	p->policy = policy;
 
 	if (dl_policy(policy))
 		__setparam_dl(p, attr);
-	else if (rt_policy(policy))
-		p->rt_priority = attr->sched_priority;
-	else
+	else if (fair_policy(policy))
 		p->static_prio = NICE_TO_PRIO(attr->sched_nice);
 
+	/*
+	 * __sched_setscheduler() ensures attr->sched_priority == 0 when
+	 * !rt_policy. Always setting this ensures that things like
+	 * getparam()/getattr() don't report silly values for !rt tasks.
+	 */
+	p->rt_priority = attr->sched_priority;
+
 	p->normal_prio = normal_prio(p);
 	p->prio = rt_mutex_getprio(p);
 
