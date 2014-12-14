Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaLNU1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:27:01 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44514 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaLNU0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:26:51 -0500
Date: Sun, 14 Dec 2014 12:26:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/3] tracing: Move enabling tracepoints to just after
 mm_init()
Message-ID: <20141214202644.GI5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214164104.307127356@goodmis.org>
 <20141214164804.150181588@goodmis.org>
 <20141214181444.GE5310@linux.vnet.ibm.com>
 <20141214132020.4ddf323b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214132020.4ddf323b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121420-0017-0000-0000-0000071B844E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 01:20:20PM -0500, Steven Rostedt wrote:
> On Sun, 14 Dec 2014 10:14:44 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > > diff --git a/init/main.c b/init/main.c
> > > index 800a0daede7e..060e60b6aa59 100644
> > > --- a/init/main.c
> > > +++ b/init/main.c
> > > @@ -561,6 +561,9 @@ asmlinkage __visible void __init start_kernel(void)
> > >  	trap_init();
> > >  	mm_init();
> > > 
> > > +	/* trace_printk() and trace points may be used after this */
> > > +	trace_init();
> > 
> > Or if you aren't going to use call_rcu_sched() before this point, I could
> > move the call_rcu_sched()-relevant initialization to this point.  Or make
> > the compiler do it -- I am pretty sure that the per-CPU variables are in
> > place at this point.
> 
> Well, we could move trace_init() after rcu_init() for now too, and
> remove my tracepoint patch. But I'd like to have trace_init() go before
> sched_init() since that could possibly use debugging tracepoints as
> well.
> 
> So if you could add a rcu_partial_init() that makes calling
> call_rcu_sched() work, that would be great. That could be for 3.20
> then, and for now, I just move trace_init() after rcu_init() which is
> still before irq_init() that Thomas needs for his work.

Sounds like a good approach.  I also need to check up on documentation of
which RCU primitives can be used where, I suspect.

							Thanx, Paul

