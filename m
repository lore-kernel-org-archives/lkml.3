Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaEESxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaEESxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:53:45 -0400
Date: Mon, 5 May 2014 20:53:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] signal: Simplify __lock_task_sighand()
Message-ID: <20140505185308.GA17507@redhat.com>
References: <20140503161133.GA8838@redhat.com> <20140504180145.GC8754@linux.vnet.ibm.com> <20140504191757.GA11319@redhat.com> <20140504223804.GF8754@linux.vnet.ibm.com> <20140505132659.GA17996@redhat.com> <20140505152610.GK8754@linux.vnet.ibm.com> <20140505164719.GA31758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505164719.GA31758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05, Oleg Nesterov wrote:
>
> On 05/05, Paul E. McKenney wrote:
> >
> > Does the patch below cover it?
>
> Yes, thanks.
>
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Yes, but please consider the cleanup below, on top of your change.

This is subjective of course, but imho the code looks better without
the extra unlock/restore inside the loop.

-------------------------------------------------------------------------------
Subject: [PATCH] signal: Simplify __lock_task_sighand()

__lock_task_sighand() does local_irq_save() to prevent the potential
deadlock, we can use preempt_disable() with the same effect. And in
this case we can do preempt_disable/enable + rcu_read_lock/unlock only
once outside of the main loop and simplify the code. Also shaves 112
bytes from signal.o.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4368370..03a0fd4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1260,30 +1260,25 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 					   unsigned long *flags)
 {
 	struct sighand_struct *sighand;
-
+	/*
+	 * We are going to do rcu_read_unlock() under spin_lock_irqsave().
+	 * Make sure we can not be preempted after rcu_read_unlock(), see
+	 * rcu_read_unlock comment header for details.
+	 */
+	preempt_disable();
+	rcu_read_lock();
 	for (;;) {
-		/*
-		 * Disable interrupts early to avoid deadlocks.
-		 * See rcu_read_unlock comment header for details.
-		 */
-		local_irq_save(*flags);
-		rcu_read_lock();
 		sighand = rcu_dereference(tsk->sighand);
-		if (unlikely(sighand == NULL)) {
-			rcu_read_unlock();
-			local_irq_restore(*flags);
+		if (unlikely(sighand == NULL))
 			break;
-		}
 
-		spin_lock(&sighand->siglock);
-		if (likely(sighand == tsk->sighand)) {
-			rcu_read_unlock();
+		spin_lock_irqsave(&sighand->siglock, *flags);
+		if (likely(sighand == tsk->sighand))
 			break;
-		}
-		spin_unlock(&sighand->siglock);
-		rcu_read_unlock();
-		local_irq_restore(*flags);
+		spin_unlock_irqrestore(&sighand->siglock, *flags);
 	}
+	rcu_read_unlock();
+	preempt_enable();
 
 	return sighand;
 }
-- 
1.5.5.1


