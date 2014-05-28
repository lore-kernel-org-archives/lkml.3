Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaE1JnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:43:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33477 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaE1JnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:43:08 -0400
Date: Wed, 28 May 2014 11:43:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Low <jason.low2@hp.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 6/6] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
In-Reply-To: <CAGQ1y=6DOs0hcdV+NvOdA9hxf6kwu-R0M-c6R2iUK4ufr=pwEg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405281143000.21720@ionos.tec.linutronix.de>
References: <20140522031841.797415507@linutronix.de> <20140522031950.280830190@linutronix.de> <CAGQ1y=6DOs0hcdV+NvOdA9hxf6kwu-R0M-c6R2iUK4ufr=pwEg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Jason Low wrote:
> On Wed, May 21, 2014 at 8:25 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > @@ -440,32 +452,41 @@ static int rt_mutex_adjust_prio_chain(st
> >         get_task_struct(task);
> >         raw_spin_lock_irqsave(&task->pi_lock, flags);
> >
> > -       if (waiter == rt_mutex_top_waiter(lock)) {
> > -               /*
> > -                * The waiter became the top waiter on the
> > -                * lock. Remove the previous top waiter from the tasks
> > -                * pi waiters list and add waiter to it.
> > -                */
> > -               rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
> > -               rt_mutex_enqueue_pi(task, waiter);
> > -               __rt_mutex_adjust_prio(task);
> > -
> > -       } else if (prerequeue_top_waiter == waiter) {
> > -               /*
> > -                * The waiter was the top waiter on the lock. Remove
> > -                * waiter from the tasks pi waiters list and add the
> > -                * new top waiter to it.
> > -                */
> > -               rt_mutex_dequeue_pi(task, waiter);
> > -               waiter = rt_mutex_top_waiter(lock);
> > -               rt_mutex_enqueue_pi(task, waiter);
> > -               __rt_mutex_adjust_prio(task);
> > -
> > -       } else {
> > -               /*
> > -                * Nothing changed. No need to do any priority
> > -                * adjustment.
> > -                */
> > +       /*
> > +        * In case we are just following the lock chain for deadlock
> > +        * detection we can avoid the whole requeue and priority
> > +        * adjustment business.
> > +        */
> > +       if (requeue) {
> > +               if (waiter == rt_mutex_top_waiter(lock)) {
> > +                       /*
> > +                        * The waiter became the top waiter on the
> > +                        * lock. Remove the previous top waiter from
> > +                        * the tasks pi waiters list and add waiter to
> > +                        * it.
> > +                        */
> > +                       rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
> > +                       rt_mutex_enqueue_pi(task, waiter);
> > +                       __rt_mutex_adjust_prio(task);
> > +
> > +               } else if (prerequeue_top_waiter == waiter) {
> > +                       /*
> > +                        * The waiter was the top waiter on the
> > +                        * lock. Remove waiter from the tasks pi
> > +                        * waiters list and add the new top waiter to
> > +                        * it.
> > +                        */
> > +                       rt_mutex_dequeue_pi(task, waiter);
> > +                       waiter = rt_mutex_top_waiter(lock);
> > +                       rt_mutex_enqueue_pi(task, waiter);
> > +                       __rt_mutex_adjust_prio(task);
> > +
> > +               } else {
> > +                       /*
> > +                        * Nothing changed. No need to do any priority
> > +                        * adjustment.
> > +                        */
> > +               }
> >         }
> >
> >         raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> 
> In the above case, could we go 1 step further and avoid taking the pi
> lock as well?
> 
>         if (requeue) {
>                 raw_spin_lock_irqsave(&task->pi_lock, flags);
> 
>                 if (waiter == rt_mutex_top_waiter(lock)) {
>                         /*
>                          * The waiter became the top waiter on the
>                          * lock. Remove the previous top waiter from
>                          * the tasks pi waiters list and add waiter to
>                          * it.
>                          */
>                         rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
>                         rt_mutex_enqueue_pi(task, waiter);
>                         __rt_mutex_adjust_prio(task);
> 
>                 } else if (prerequeue_top_waiter == waiter) {
>                         /*
>                          * The waiter was the top waiter on the
>                          * lock. Remove waiter from the tasks pi
>                          * waiters list and add the new top waiter to
>                          * it.
>                          */
>                         rt_mutex_dequeue_pi(task, waiter);
>                         waiter = rt_mutex_top_waiter(lock);
>                         rt_mutex_enqueue_pi(task, waiter);
>                         __rt_mutex_adjust_prio(task);
> 
>                 } else {
>                         /*
>                          * Nothing changed. No need to do any priority
>                          * adjustment.
>                          */
>                 }
> 
>                 raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>         }

Indeed.

 
