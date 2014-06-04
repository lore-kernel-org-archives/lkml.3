Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaFDUI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:08:28 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:41623 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbaFDUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:08:27 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Wed, 4 Jun 2014 15:07:51 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Brad Mouring <bmouring@ni.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140604200750.GA10343@linuxgetsreal>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
 <1400855410-14773-2-git-send-email-brad.mouring@ni.com>
 <20140603210609.62de6451@gandalf.local.home>
 <alpine.DEB.2.10.1406041623170.3319@nanos>
 <20140604114411.0fe51c1d@gandalf.local.home>
 <alpine.DEB.2.10.1406041951210.3319@nanos>
 <20140604192541.GA9496@linuxgetsreal>
 <alpine.DEB.2.10.1406042147080.18296@nanos>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406042147080.18296@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/04/2014 03:07:52 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/04/2014 03:07:52 PM,
	Serialize complete at 06/04/2014 03:07:52 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-04_04:2014-06-04,2014-06-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:53:16PM +0200, Thomas Gleixner wrote:
> On Wed, 4 Jun 2014, Brad Mouring wrote:
> > On Wed, Jun 04, 2014 at 08:02:16PM +0200, Thomas Gleixner wrote:
> > > I'll fixup the check so it wont break the real deadlock case and queue
> > > it.
> > 
> > How would the change break the real deadlock case?
> 
> > >  	/* Deadlock detection */
> > >  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> > > +		/*
> > > +		 * If the prio chain has changed out from under us, set the task
> > > +		 * to the current owner of the lock in the current waiter and
> > > +		 * continue walking the prio chain
> > > +		 */
> > > +		if (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task) {
> 
> No, sorry. That's wrong.
> 
> Your change wreckages the rt_mutex_owner(lock) == top_task test
> simply because in that case:
> 
>    (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task)
> 
> evaluates to true.

Ah. Yeah. I haven't tested this but it seems sane to me.

> 
> So we want this:
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -375,6 +375,26 @@ static int rt_mutex_adjust_prio_chain(st
>  	 * walk, we detected a deadlock.
>  	 */
>  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> +		/*
> +		 * If the prio chain has changed out from under us, set the task
> +		 * to the current owner of the lock in the current waiter and
> +		 * continue walking the prio chain
> +		 */
> +		if (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task &&
> +		    rt_mutex_owner(lock) != top_task) {
> +			/* Release the old owner */
> +			raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +			put_task_struct(task);
> +
> +			/* Move to the new owner */
> +			task = rt_mutex_owner(lock);
> +			get_task_struct(task);
> +
> +			/* Let's try this again */
> +			raw_spin_unlock(&lock->wait_lock);
> +			goto retry;
> +		}
> +
>  		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
>  		raw_spin_unlock(&lock->wait_lock);
>  		ret = deadlock_detect ? -EDEADLK : 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
