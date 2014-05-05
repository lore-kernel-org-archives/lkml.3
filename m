Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaEESbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:31:09 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:50687 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEESbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:31:07 -0400
X-Yandex-Uniq: 2aa8a95c-1f86-4dc7-b91f-7716f6730434
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1399314660.6978.3.camel@localhost.localdomain>
Subject: Re: [RFC] rtmutex: Do not boost fair tasks each other
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Date: Mon, 05 May 2014 22:31:00 +0400
In-Reply-To: <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de>
References: <5362122B.8060305@yandex.ru>
	 <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.0-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Сб, 03/05/2014 в 20:54 +0200, Thomas Gleixner пишет:
> On Thu, 1 May 2014, Kirill Tkhai wrote:
> > Higher priority does not provide exclusive privilege
> > of one fair task over the other. In this case priority
> > boosting looks excess.
> > 
> > On RT patch with enabled PREEMPT_RT_FULL I see a lot of
> > rt_mutex_setprio() actions like
> > 
> > 	120 -> 118
> > 	118 -> 120
> > 
> > They harm RT tasks.
> 
> That's not the main problem. The point is that it is useless and
> therefor harming performace and throughput as well.
>  
> > RT patch has lazy preemtion feature, so if idea is we care
> > about excess preemption inside fair class, we should care
> > about excess priority inheritance too.
> > 
> > In case of vanila kernel the problem is the same, but there
> > are no so many rt mutexes. Do I skip anything?
> 
> Almost a decade ago we decided to do the boosting for everything
> including SCHED_OTHER due to the very simple reason that exercising
> that code path more is likely to trigger more bugs.
>  
> But yes in a production environment, it's pointless for SCHED_OTHER
> tasks.
> 
> Though exercising that code path as much as we can is not a bad thing
> either. So I'd like to see that made compile time conditional on one
> of the lock testing CONFIG items.
> 
> And the patch should be made against mainline, where we have the same
> issue (reduced to PI-futexes).
> 

How about this?

[PATCH] rtmutex: Do not boost owner's prio if waiter is SCHED_OTHER

Higher priority does not provide exclusive privilege
of one fair class task over the other. In this case
priority boosting is pointless, and it may worsen
performance.

This patch makes boosting, which is requested by fair
class waiter, optional. It's disabled by default, but
it's possible to enable it for debugging purposes to
have more cases of priority inheritance.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---
 kernel/locking/rtmutex.c | 27 ++++++++++++++++++++-------
 lib/Kconfig.debug        | 11 +++++++++++
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index aa4dff0..1f3dda1 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -189,6 +189,12 @@ rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
 	RB_CLEAR_NODE(&waiter->pi_tree_entry);
 }
 
+#ifndef CONFIG_RT_MUTEX_BOOST_ALL
+#define heritable_prio(prio)		(rt_prio(prio) || dl_prio(prio))
+#else
+#define heritable_prio(prio)		(1)
+#endif
+
 /*
  * Calculate task priority from the waiter tree priority
  *
@@ -197,11 +203,14 @@ rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
-	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+	if (unlikely(task_has_pi_waiters(task))) {
+		int prio = task_top_pi_waiter(task)->prio;
+
+		if (heritable_prio(prio))
+			return min(prio, task->normal_prio);
+	}
 
-	return min(task_top_pi_waiter(task)->prio,
-		   task->normal_prio);
+	return task->normal_prio;
 }
 
 struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
@@ -218,10 +227,14 @@ struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
  */
 int rt_mutex_check_prio(struct task_struct *task, int newprio)
 {
-	if (!task_has_pi_waiters(task))
-		return 0;
+	if (unlikely(task_has_pi_waiters(task))) {
+		int prio = task_top_pi_waiter(task)->task->prio;
 
-	return task_top_pi_waiter(task)->task->prio <= newprio;
+		if (heritable_prio(prio))
+			return prio <= newprio;
+	}
+
+	return 0;
 }
 
 /*
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 819ac51..5f845b0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -834,6 +834,17 @@ config RT_MUTEX_TESTER
 	help
 	  This option enables a rt-mutex tester.
 
+config RT_MUTEX_BOOST_ALL
+	bool "RT Mutex: inherit priority of any scheduler class"
+	depends on DEBUG_KERNEL && RT_MUTEXES
+	help
+	  Normally priority inheritance is pointless for SCHED_OTHER
+	  tasks, because higher prio does not provide exclusive privilege
+	  of one fair_sched_class task over the other.
+
+	  Say Y here if you debug RT mutex code and want to have more
+	  cases of priority boosting.
+
 config DEBUG_SPINLOCK
 	bool "Spinlock and rw-lock debugging: basic checks"
 	depends on DEBUG_KERNEL


