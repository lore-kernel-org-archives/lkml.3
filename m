Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3IIMpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:45:53 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42844 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3IIMpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:45:52 -0400
Date: Mon, 9 Sep 2013 14:45:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909124547.GB16280@somewhere>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909083926.3eceebef@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:39:26AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 14:13:31 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> 
> > > In any case the preempt_disable/enable pair there is just plain wrong as
> > > Eric pointed out.
> > 
> > Check this:
> > 
> > 34240697d619c439c55f21989680024dcb604aab "rcu: Disable preemption in rcu_is_cpu_idle()"
> 
> 
> Ug, and that patch does nothing to fix the bug that it reported!
> 
>     1.  Task A on CPU 1 enters rcu_is_cpu_idle() and picks up the
>     pointer to CPU 1's per-CPU variables.
>     
>     2.  Task B preempts Task A and starts running on CPU 1.
> 
> Let's say that B preempts Task A here:
> 
>        preempt_disable();
>        ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) &  0x1) == 0;
>        preempt_enable();
>  <preempt>
>        return ret;
> 
>     
>     3.  Task A migrates to CPU 2.
>     
>     4.  Task B blocks, leaving CPU 1 idle.
>     
>     5.  Task A continues execution on CPU 2, accessing CPU 1's
>     dyntick-idle information using the pointer fetched in step 1 above,
>     and finds that CPU 1 is idle.
> 
> Yeah, and Task A is using the "ret" from CPU 1!
>     
>     6.  Task A therefore incorrectly concludes that it is executing in
>         an extended quiescent state, possibly issuing a spurious splat.
>     
>     Therefore, this commit disables preemption within the
>     rcu_is_cpu_idle() function.
> 
> Where this commit is totally bogus. Sorry, but it is.
> 
> This just proves that the caller of rcu_is_cpu_idle() must disable
> preemption itself for the entire time that it needs to use the result
> of rcu_is_cpu_idle().

Sorry, I don't understand your point here. What's wrong with checking the
ret from another CPU?
