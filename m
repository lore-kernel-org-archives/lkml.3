Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaGHPuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:50:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51507 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGHPuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:50:17 -0400
Date: Tue, 8 Jul 2014 08:50:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 03/17] signal: Explain local_irq_save() call
Message-ID: <20140708155005.GO4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <53BBB37F.6030807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBB37F.6030807@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070815-7164-0000-0000-000002F91D4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:01:51PM +0800, Lai Jiangshan wrote:
> On 07/08/2014 06:38 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The explicit local_irq_save() in __lock_task_sighand() is needed to avoid
> > a potential deadlock condition, as noted in a841796f11c90d53 (signal:
> > align __lock_task_sighand() irq disabling and RCU).  However, someone
> > reading the code might be forgiven for concluding that this separate
> > local_irq_save() was completely unnecessary.  This commit therefore adds
> > a comment referencing the shiny new block comment on rcu_read_unlock().
> > 
> > Reported-by: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Acked-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  kernel/signal.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index a4077e90f19f..46161e744760 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1263,6 +1263,10 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
> >  	struct sighand_struct *sighand;
> >  
> >  	for (;;) {
> > +		/*
> > +		 * Disable interrupts early to avoid deadlocks.
> > +		 * See rcu_read_unlock comment header for details.
> > +		 */
> 
> A pair of brackets are missing here: rcu_read_unlock()
> after that, please add:
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Good point, added the "()" and your Reviewed-by.

> It reminds me that I should keep my effort to solve the deadlock
> problem where rcu_read_unlock() is overlapped with schedule locks.

That would be good!  I vaguely remember an earlier patch of yours that
Steven Rostedt gave feedback on, but have not been able to locate either
email.

							Thanx, Paul

> >  		local_irq_save(*flags);
> >  		rcu_read_lock();
> >  		sighand = rcu_dereference(tsk->sighand);
> 

