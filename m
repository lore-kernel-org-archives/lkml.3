Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab3IFR4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:56:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34888 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3IFR4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:56:15 -0400
Date: Fri, 6 Sep 2013 10:56:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130906175601.GA7714@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <20130906113320.46b2ea3e@gandalf.local.home>
 <20130906164016.GB2706@somewhere>
 <20130906125238.3c5ef919@gandalf.local.home>
 <20130906170006.GC2706@somewhere>
 <20130906131631.6a0a192d@gandalf.local.home>
 <20130906175238.GV3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906175238.GV3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090617-0320-0000-0000-000000EB007C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:52:38AM -0700, Paul E. McKenney wrote:
> On Fri, Sep 06, 2013 at 01:16:31PM -0400, Steven Rostedt wrote:
> > On Fri, 6 Sep 2013 19:00:08 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Fri, Sep 06, 2013 at 12:52:38PM -0400, Steven Rostedt wrote:
> > > > On Fri, 6 Sep 2013 18:40:18 +0200
> > > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > >  
> > > > > > I can't use plain preempt_disable() in function tracing.
> > > > > > 
> > > > > > Also, since it's a misnomer to say the cpu is idle in NO_HZ_FULL when
> > > > > > we are coming from userspace, can we rename that?
> > > > > > 
> > > > > > Perhaps we can also have a __rcu_is_cpu_tracking() (or whatever), with
> > > > > > the "__" appended that does not do the preempt disable.
> > > > > 
> > > > > rcu_is_cpu_eqs() is probably better. It refers to other related "eqs" naming
> > > > > in RCU APIs.
> > > > 
> > > > But that will just confuse the heck out of people. When I see "eqs" I
> > > > equate that with "equals". What does the rcu cpu equal?
> > > 
> > > It's "extended quiescent state". There is already rcu_eqs_enter() and rcu_eqs_exit().
> > > You're right, may be we can rename that to avoid confusion with "equals". I don't mind much.
> > > I'm happy as long as the reader rcu_is_cpu_foo() and the writers rcu_foo_enter() and
> > > rcu_foo_exit() have consistant naming.
> > > 
> > 
> > What exactly does "extended quiescent state" mean? (Note, that's a
> > rhetorical question)
> 
> In which case my rhetorical (and therefore useless) answer has to be
> "it is a quiescent state that is extended".  ;-)
> 
> Sorry, couldn't resist...
> 
> > I wonder if we should change "rcu_cpu_ignore()" for "rcu_eqs_enter()"
> > and "rcu_cpu_heed()" for "rcu_eqs_exit()", as IMHO that's much more
> > straight forward to understand than trying to wrap you head around what
> > a quiescent state is, and why we are entering it or exiting it.
> > 
> > It also flat out explains to people that rcu is not processing that
> > current CPU, and things like rcu_read_lock() should not be used.
> > 
> > Then we can say "rcu_cpu_is_ignored()" for things like
> > "rcu_is_cpu_eqs()".
> 
> Currently, none of RCU's _eqs functions are exported, so they have
> the potential to confuse only people working on the RCU implementation
> itself, who had better understand what "eqs" means.
> 
> But I do count your vote against "eqs" appearing in the name of any
> function exported by RCU.
> 
> How about if I made rcu_is_cpu_idle() be as follows?
> 
> int rcu_is_cpu_idle(void)
> {
> 	int ret;
> 
> 	ret = (atomic_read(&per_cpu(rcu_dynticks.dynticks,
> 				    raw_smp_processor_id())) & 0x1) == 0;
> 	return ret;
> }
> 
> This should allow existing uses to function properly and should allow
> you to use it as well.

Never mind, I remember why this doesn't work...  The problem is that the
offset is calculated on one CPU, the task is preempted, the original CPU
goes idle, the task starts running on some other CPU, and then lockdep
complains about the CPU entering an RCU read-side critical section on
an idle CPU.

Blech.

But I -can- make them the same function on rcutiny, courtesy of the
ever-present C preprocessor.  ;-)

							Thanx, Paul

