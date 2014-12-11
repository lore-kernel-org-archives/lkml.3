Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaLKQuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:50:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44277 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaLKQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:50:19 -0500
Date: Thu, 11 Dec 2014 08:50:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched stall detected, but no state dump
Message-ID: <20141211165010.GI25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1412101334380.22639@pobox.suse.cz>
 <20141210162823.GT25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121116-0013-0000-0000-000006FC0572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 10:35:15AM +0100, Miroslav Benes wrote:
> On Wed, 10 Dec 2014, Paul E. McKenney wrote:
> 
> > On Wed, Dec 10, 2014 at 01:52:02PM +0100, Miroslav Benes wrote:
> > > 
> > > Hi,
> > > 
> > > today I came across RCU stall which was correctly detected, but there is 
> > > no state dump. This is a bit suspicious, I think. 
> > > 
> > > This is the output in serial console:
> > > 
> > > [  105.727003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  105.727003]  (detected by 0, t=21002 jiffies, g=3269, c=3268, q=138)
> > > [  105.727003] INFO: Stall ended before state dump start
> > > [  168.732006] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  168.732006]  (detected by 0, t=84007 jiffies, g=3269, c=3268, q=270)
> > > [  168.732006] INFO: Stall ended before state dump start
> > > [  231.737003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  231.737003]  (detected by 0, t=147012 jiffies, g=3269, c=3268, q=388)
> > > [  231.737003] INFO: Stall ended before state dump start
> > > [  294.742003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  294.742003]  (detected by 0, t=210017 jiffies, g=3269, c=3268, q=539)
> > > [  294.742003] INFO: Stall ended before state dump start
> > > [  357.747003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  357.747003]  (detected by 0, t=273022 jiffies, g=3269, c=3268, q=693)
> > > [  357.747003] INFO: Stall ended before state dump start
> > > [  420.752003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  420.752003]  (detected by 0, t=336027 jiffies, g=3269, c=3268, q=806)
> > > [  420.752003] INFO: Stall ended before state dump start
> > > ...
> > > 
> > > It can be reproduced by trivial code attached to this mail (infinite 
> > > loop in kernel thread created in kernel module). I have CONFIG_PREEMPT=n. 
> > > The kernel thread is scheduled on the same CPU which causes soft lockup 
> > > (reliably detected when lockup detector is on). There is certainly RCU 
> > > stall, but I would expect a state dump. Is this an expected behaviour? 
> > > Maybe I overlooked some config option, don't know.
> > 
> > Definitely not expected behavior!  Unless you have only one CPU, but in
> > that case you should be running tiny RCU, not tree RCU.
> 
> So indeed I messed up my configs somehow and run the code on uniprocessor 
> with SMP=y and tree RCU. With more processors RCU stall is detected and 
> correct state is dumped. On uniprocessor with SMP=n and tiny RCU 
> softlockup is detected, but no RCU stall in the log (is this correct?). So 
> I'm really sorry for the noise.
> 
> Anyway I still think that running SMP kernel with tree RCU on 
> uniprocessor is possible option (albeit suboptimal and maybe improbable). 
> Should I proceed with your patch below and bisection or am I mistaken 
> completely and we can leave it because there is no problem?

Not a problem, there have been some interesting RCU CPU stall warnings
recently, and your data did add some insight.

So the combination SMP=n PREEMPT=y can happen straightforwardly via
kbuild.  The combination SMP=n PREEMPT=n can happen (somewhat less)
straightforwardly by running an SMP=y PREEMPT=n kernel on a single-CPU
system.  In both cases, what can happen is that RCU's grace-period
kthreads are starved, which can result in those reports.

And these reports are confusing.  I am considering attempting to improve
the diagnostics.  If I do, would you be willing to test the resulting
patches?

							Thanx, Paul

> Thanks,
> Miroslav
> 
> > > I tested 3.18 and also next-20141210. If it is improper behaviour I could 
> > > try to find a good kernel release and bisect it.
> > 
> > Please!  Could you also please try the (untested) diagnostic patch below
> > on either 3.18 or -next?  It should print messages covering all your
> > CPUs, and the CPU that your kernel module's kthread is running on should
> > show up as a one bit in the corresponding "mask" printout.
> > 
> > Could you also please check what CPU the rcu_sched kthread is running on?
> > One possibility is that this kthread is for some reason pinned on the
> > same CPU that is running your kthread.
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 884e0ff020f1..d4018c025ac6 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -1129,6 +1129,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
> >  	print_cpu_stall_info_begin();
> >  	rcu_for_each_leaf_node(rsp, rnp) {
> >  		raw_spin_lock_irqsave(&rnp->lock, flags);
> > +		pr_err("[ CPUs %d-%d mask %#lx ]\n", rnp->grplo, rnp->grphi, rnp->qsmask);
> >  		ndetected += rcu_print_task_stall(rnp);
> >  		if (rnp->qsmask != 0) {
> >  			for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
> > 
> 

