Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889Ab3IFRl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:41:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33699 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IFRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:41:25 -0400
Date: Fri, 6 Sep 2013 10:41:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130906174117.GU3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378488088.31445.39.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090617-0928-0000-0000-0000015590CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:21:28AM -0700, Eric Dumazet wrote:
> On Fri, 2013-09-06 at 08:18 -0700, Paul E. McKenney wrote:
> 
> > int rcu_is_cpu_idle(void)
> > {
> > 	int ret;
> > 
> > 	preempt_disable();
> > 	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> > 	preempt_enable();
> > 	return ret;
> > }
> 
> Paul I find this very confusing.
> 
> If caller doesn't have preemption disabled, what could be the meaning of
> this rcu_is_cpu_idle() call ?
> 
> Its result is meaningless if suddenly thread is preempted, so what is
> the point ?
> 
> Sorry if this is obvious to you.

It is a completely fair question.  In fact, this might well now be
pointing to a bug given NO_HZ_FULL.

The assumption is that if you don't have preemption disabled, you had
better be running on a CPU that RCU is paying attention to.  The rationale
involves preemptible RCU.

Suppose that you just did rcu_read_lock() on a CPU that RCU is paying
attention to.  All is well, and rcu_is_cpu_idle() will return false, as
expected.  Suppose now that it is possible to be preempted and suddenly
find yourself running on a CPU that RCU is not paying attention to.
This would have the effect of making your RCU read-side critical section
be ignored.  Therefore, it had better not be possible to be preempted
from a CPU to which RCU is paying attention to a CPU that RCU is ignoring.

So if rcu_is_cpu_idle() returns false, you had better be guaranteed
that whatever CPU you are running on (which might well be a different
one than the rcu_is_cpu_idle() was running on) is being watched by RCU.

So, Frederic, does this still work with NO_HZ_FULL?  If not, I believe
we have a bigger problem than the preempt_disable() in rcu_is_cpu_idle()!

							Thanx, Paul

