Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbaE2Uws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:52:48 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:35444 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaE2Uwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:52:47 -0400
X-Yandex-Uniq: b7caf977-d408-4674-aa37-f9377e9b0db8
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1401396751.1628.4.camel@localhost.localdomain>
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
Date: Fri, 30 May 2014 00:52:31 +0400
In-Reply-To: <alpine.DEB.2.10.1405282157100.3952@nanos>
References: <5362122B.8060305@yandex.ru>
	  <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de>
	 <1399314660.6978.3.camel@localhost.localdomain>
	 <alpine.DEB.2.10.1405282157100.3952@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 28/05/2014 в 22:26 +0200, Thomas Gleixner пишет:
> On Mon, 5 May 2014, Kirill Tkhai wrote:
> > В Сб, 03/05/2014 в 20:54 +0200, Thomas Gleixner пишет:
> > > Though exercising that code path as much as we can is not a bad thing
> > > either. So I'd like to see that made compile time conditional on one
> > > of the lock testing CONFIG items.
> >  

> > +#ifndef CONFIG_RT_MUTEX_BOOST_ALL
> 
> No, not another pointless config option. Read what I said. What's
> wrong with using an existing config item, e.g DEBUG_RT_MUTEXES?
> 
> > +#define heritable_prio(prio)		(rt_prio(prio) || dl_prio(prio))
> 
> inheritable please. It's not priority heritance and never will be.

Thanks for comments. Here is new version.

[PATCH] rtmutex: Do not boost owner's prio if waiter is SCHED_OTHER

Higher priority does not provide exclusive privilege
of one fair class task over the other. In this case
priority boosting is pointless, and it may worsen
performance.

This patch makes boosting, which is requested by fair
class waiters, optional. It's disabled by default, but
it's possible to enable it for debugging purposes to
have more cases of priority inheritance.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>

 kernel/locking/rtmutex.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index aa4dff0..fa6a9b3 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -189,6 +189,13 @@ rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
 	RB_CLEAR_NODE(&waiter->pi_tree_entry);
 }
 
+#ifndef CONFIG_DEBUG_RT_MUTEXES
+#define inheritable_prio(prio)	(rt_prio(prio) || dl_prio(prio))
+#else
+/* We want to have more cases of priority boosting */
+#define inheritable_prio(prio)	(1)
+#endif
+
 /*
  * Calculate task priority from the waiter tree priority
  *
@@ -197,11 +204,14 @@ rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
-	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+	if (unlikely(task_has_pi_waiters(task))) {
+		int prio = task_top_pi_waiter(task)->prio;
+
+		if (inheritable_prio(prio))
+			return min(prio, task->normal_prio);
+	}
 
-	return min(task_top_pi_waiter(task)->prio,
-		   task->normal_prio);
+	return task->normal_prio;
 }
 
 struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
@@ -218,10 +228,14 @@ struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
  */
 int rt_mutex_check_prio(struct task_struct *task, int newprio)
 {
-	if (!task_has_pi_waiters(task))
-		return 0;
+	if (unlikely(task_has_pi_waiters(task))) {
+		int prio = task_top_pi_waiter(task)->task->prio;
 
-	return task_top_pi_waiter(task)->task->prio <= newprio;
+		if (inheritable_prio(prio))
+			return prio <= newprio;
+	}
+
+	return 0;
 }
 
 /*



