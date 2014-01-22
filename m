Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaAVSbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:31:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaAVSbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:31:41 -0500
Date: Wed, 22 Jan 2014 19:31:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: uninline rcu_lock_acquire/etc ?
Message-ID: <20140122183125.GA31289@redhat.com>
References: <20140120181942.GA20783@redhat.com> <20140120182019.GA26515@redhat.com> <20140121141022.GX31570@twins.programming.kicks-ass.net> <20140121173534.GA25642@redhat.com> <20140121184310.GA24702@redhat.com> <20140121193909.GA17497@redhat.com> <20140122035440.GW10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122035440.GW10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Paul E. McKenney wrote:
>
> On Tue, Jan 21, 2014 at 08:39:09PM +0100, Oleg Nesterov wrote:
> > On 01/21, Oleg Nesterov wrote:
> > >
> > > But I agreed that the code looks simpler with bitfields, so perhaps
> > > this patch is better.
> >
> > Besides, I guess the major offender is rcu...
> >
> > Paul, can't we do something like below? Saves 19.5 kilobytes,
> >
> > 	-       5255131 2974376 10125312        18354819        1181283 vmlinux
> > 	+	5235227 2970344 10125312        18330883        117b503 vmlinux
> >
> > probably we can also uninline rcu_lockdep_assert()...
>
> Looks mostly plausible, some questions inline below.

Thanks!

> >  static inline void rcu_read_lock(void)
> >  {
> > -	__rcu_read_lock();
> >  	__acquire(RCU);
> > -	rcu_lock_acquire(&rcu_lock_map);
> > -	rcu_lockdep_assert(rcu_is_watching(),
> > -			   "rcu_read_lock() used illegally while idle");
> > +	__rcu_read_lock();
> > +	rcu_lock_acquire();
>
> Not sure why __rcu_read_lock() needs to be in any particular order
> with respect to the sparse __acquire(RCU), but should work either way.
> Same question about the other reorderings of similar statements.

I did this unconsciously and for no reason, will revert this accidental
change.

> >  static inline void rcu_read_lock_sched(void)
> >  {
> > -	preempt_disable();
> >  	__acquire(RCU_SCHED);
> > -	rcu_lock_acquire(&rcu_sched_lock_map);
> > +	preempt_disable();
> > +	rcu_lock_acquire_sched();
> >  	rcu_lockdep_assert(rcu_is_watching(),
> >  			   "rcu_read_lock_sched() used illegally while idle");
>
> The above pair of lines (rcu_lockdep_assert()) should also be removed,
> correct?

yes, sure, thanks,

> > @@ -862,8 +867,8 @@ static inline void rcu_read_lock_sched(void)
> >  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
> >  static inline notrace void rcu_read_lock_sched_notrace(void)
> >  {
> > -	preempt_disable_notrace();
> >  	__acquire(RCU_SCHED);
> > +	preempt_disable_notrace();
>
> I cannot help repeating myself on this one...  ;-)
>
> Why the change in order?

see above ;)

> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -333,4 +333,47 @@ static int __init check_cpu_stall_init(void)
> >  }
> >  early_initcall(check_cpu_stall_init);
> >
> > +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)
> > +
> > +static void ck_rcu_is_watching(const char *message)
> > +{
> > +	rcu_lockdep_assert(rcu_is_watching(), message);
> > +}
> > +
> > +void rcu_lock_acquire(void)
> > +{
> > +	__rcu_lock_acquire(&rcu_lock_map, _RET_IP_);
> > +	ck_rcu_is_watching("rcu_read_lock() used illegally while idle");
> > +}
> > +
> > +void rcu_lock_release(void)
> > +{
> > +	ck_rcu_is_watching("rcu_read_unlock() used illegally while idle");
> > +	__rcu_lock_release(&rcu_lock_map, _RET_IP_);
> > +}
> > ...

Also, this all should be exported. And I think cleanuped somehow.

Oleg.

