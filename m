Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3IEVhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:37:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59727 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3IEVhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:37:06 -0400
Date: Thu, 5 Sep 2013 13:59:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130905205959.GN3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130905162558.6f13add0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905162558.6f13add0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090521-0928-0000-0000-0000014E89B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 04:25:58PM -0400, Steven Rostedt wrote:
> On Thu, 5 Sep 2013 12:52:34 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > There is currently no way for kernel code to determine whether it
> > is safe to enter an RCU read-side critical section, in other words,
> > whether or not RCU is paying attention to the currently running CPU.
> > Given the large and increasing quantity of code shared by the idle loop
> > and non-idle code, the this shortcoming is becoming increasingly painful.
> > 
> > This commit therefore adds rcu_watching_this_cpu(), which returns true
> > if it is safe to enter an RCU read-side critical section on the currently
> > running CPU.  This function is quite fast, using only a __this_cpu_read().
> > However, the caller must disable preemption.
> > 
> > Reported-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks Paul!
> 
> > 
> >  include/linux/rcupdate.h |    1 +
> >  kernel/rcutree.c         |   12 ++++++++++++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 15d33d9..1c7112c 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -225,6 +225,7 @@ extern void rcu_idle_enter(void);
> >  extern void rcu_idle_exit(void);
> >  extern void rcu_irq_enter(void);
> >  extern void rcu_irq_exit(void);
> > +extern bool rcu_watching_this_cpu(void);
> >  
> >  #ifdef CONFIG_RCU_USER_QS
> >  extern void rcu_user_enter(void);
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index a06d172..7b8fcee 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> 
> Don't we also need a rcutiny version too? Otherwise I'm guessing that
> it wont compile if I use it with rcutiny (even if it always returns
> true).

Yep, there needs to be an rcutiny version, and it must work in the
same way.  So what I currently have is that the rcutiny version is under
CONFIG_RCU_TRACE.  This will require some Kconfig monkeying somewhere
to select CONFIG_RCU_TRACE if CONFIG_SMP and tracing is enabled.

Just trying to keep rcutiny tiny...

							Thanx, Paul

> -- Steve
> 
> > @@ -710,6 +710,18 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
> >  #endif /* #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU) */
> >  
> >  /**
> > + * rcu_watching_this_cpu - are RCU read-side critical sections safe?
> > + *
> > + * Return true if RCU is watching the running CPU, which means that this
> > + * CPU can safely enter RCU read-side critical sections.  The caller must
> > + * have at least disabled preemption.
> > + */
> > +bool rcu_watching_this_cpu(void)
> > +{
> > +	return !!__this_cpu_read(rcu_dynticks.dynticks_nesting);
> > +}
> > +
> > +/**
> >   * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
> >   *
> >   * If the current CPU is idle or running at a first-level (not nested)
> 

