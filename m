Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaFJRjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:39:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:54300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaFJRjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:39:44 -0400
Date: Tue, 10 Jun 2014 19:39:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 5/7] rtmutex: Confine deadlock logic to futex
In-Reply-To: <20140609205908.521f7eba@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406101939100.5170@nanos>
References: <20140609201118.387571774@linutronix.de> <20140609202336.338874430@linutronix.de> <20140609205908.521f7eba@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Steven Rostedt wrote:
> On Mon, 09 Jun 2014 20:28:09 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
>   
> > +/*
> > + * Futex variant to allow full deadlock detection.
> > + */
> > +int __rt_mutex_timed_lock(struct rt_mutex *lock,
> > +			  struct hrtimer_sleeper *timeout)
> > +{
> > +	might_sleep();
> > +
> > +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> > +				       rt_mutex_slowlock);
> > +}
> > +
> >  /**
> >   * rt_mutex_timed_lock - lock a rt_mutex interruptible
> >   *			the timeout structure is provided
> >   *			by the caller
> >   *
> > - * @lock: 		the rt_mutex to be locked
> > + * @lock:		the rt_mutex to be locked
> >   * @timeout:		timeout structure or NULL (no timeout)
> > - * @detect_deadlock:	deadlock detection on/off
> >   *
> >   * Returns:
> > - *  0 		on success
> > - * -EINTR 	when interrupted by a signal
> > + *  0		on success
> > + * -EINTR	when interrupted by a signal
> >   * -ETIMEDOUT	when the timeout expired
> > - * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
> >   */
> >  int
> > -rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
> > -		    int detect_deadlock)
> > +rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
> >  {
> >  	might_sleep();
> >  
> > -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> > -				       detect_deadlock, rt_mutex_slowlock);
> > +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> > +				       rt_mutex_slowlock);
> >  }
> >  EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
> >  
> 
> I must be missing something. What's the difference between the above
> and the futex variant one? They both do the exact same thing:
> 
> 
> int foo(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
> {
> 	might_sleep();
> 
> 	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timout,
> 				       0, rt_mutex_slowlock);
> }

Right. The one for futex must have s/0/1/. Fixed.

Thanks,

	tglx
