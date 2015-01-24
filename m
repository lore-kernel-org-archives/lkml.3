Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbAXVSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:18:43 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38793 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAXVSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:18:40 -0500
Date: Sat, 24 Jan 2015 13:18:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at
 kernel/rcu/tree_plugin.h:337 rcu_read_unlock_special+0x369/0x550()
Message-ID: <20150124211834.GD9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150121025754.GV9719@linux.vnet.ibm.com>
 <54BFC979.8040107@oracle.com>
 <20150122004305.GJ9719@linux.vnet.ibm.com>
 <54C1BFFD.9060707@oracle.com>
 <20150123035158.GP9719@linux.vnet.ibm.com>
 <54C1C7D2.906@oracle.com>
 <54C1C899.8000106@oracle.com>
 <20150123065542.GQ9719@linux.vnet.ibm.com>
 <20150123093644.GA11175@linux.vnet.ibm.com>
 <54C300DD.9070608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C300DD.9070608@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012421-0025-0000-0000-0000080821A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 10:18:05AM +0800, Lai Jiangshan wrote:
> On 01/23/2015 05:36 PM, Paul E. McKenney wrote:
> > On Thu, Jan 22, 2015 at 10:55:42PM -0800, Paul E. McKenney wrote:
> >> On Thu, Jan 22, 2015 at 11:05:45PM -0500, Sasha Levin wrote:
> >>> On 01/22/2015 11:02 PM, Sasha Levin wrote:
> >>>> On 01/22/2015 10:51 PM, Paul E. McKenney wrote:
> >>>>> On Thu, Jan 22, 2015 at 10:29:01PM -0500, Sasha Levin wrote:
> >>>>>>> On 01/21/2015 07:43 PM, Paul E. McKenney wrote:
> >>>>>>>>> On Wed, Jan 21, 2015 at 10:44:57AM -0500, Sasha Levin wrote:
> >>>>>>>>>>> On 01/20/2015 09:57 PM, Paul E. McKenney wrote:
> >>>>>>>>>>>>>>>>> So RCU believes that an RCU read-side critical section that ended within
> >>>>>>>>>>>>>>>>>>>>> an interrupt handler (in this case, an hrtimer) somehow got preempted.
> >>>>>>>>>>>>>>>>>>>>> Which is not supposed to happen.
> >>>>>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>>>>> Do you have CONFIG_PROVE_RCU enabled?  If not, could you please enable it
> >>>>>>>>>>>>>>>>>>>>> and retry?
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> I did have CONFIG_PROVE_RCU, and didn't see anything else besides what I pasted here.
> >>>>>>>>>>>>> OK, fair enough.  I do have a stack of RCU CPU stall-warning changes on
> >>>>>>>>>>>>> their way in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> These handle the problems that Dave Jones, yourself, and a few others
> >>>>>>>>>>>>> located this past December.  Could you please give them a spin?
> >>>>>>>>>>>
> >>>>>>>>>>> They seem to be a part of -next already, so this testing already includes them.
> >>>>>>>>>>>
> >>>>>>>>>>> I seem to be getting them about once a day, anything I can add to debug it?
> >>>>>>>>>
> >>>>>>>>> Could you please try reproducing with the following patch?
> >>>>>>>
> >>>>>>> Yes, and I've got mixed results. It reproduced, and all I got was:
> >>>>>>>
> >>>>>>> [  717.645572] ===============================
> >>>>>>> [  717.645572] [ INFO: suspicious RCU usage. ]
> >>>>>>> [  717.645572] 3.19.0-rc5-next-20150121-sasha-00064-g3c37e35-dirty #1809 Tainted: G        W
> >>>>>>> [  717.645572] -------------------------------
> >>>>>>> [  717.645572] kernel/rcu/tree_plugin.h:337 rcu_read_unlock() from irq or softirq with blocking in critical section!!!
> >>>>>>> [  717.645572] !
> >>>>>>> [  717.645572]
> >>>>>>> [  717.645572] other info that might help us debug this:
> >>>>>>> [  717.645572]
> >>>>>>> [  717.645572]
> >>>>>>> [  717.645572] rcu_scheduler_active = 1, debug_locks = 1
> >>>>>>> [  717.645572] 3 locks held by trinity-c29/16497:
> >>>>>>> [  717.645572]  #0:  (&sb->s_type->i_mutex_key){+.+.+.}, at: [<ffffffff81bec373>] lookup_slow+0xd3/0x420
> >>>>>>> [  717.645572]  #1:
> >>>>>>> [hang]
> >>>>>>>
> >>>>>>> So the rest of the locks/stack trace didn't get printed, nor the pr_alert() which
> >>>>>>> should follow that.
> >>>>>>>
> >>>>>>> I've removed the lockdep call and will re-run it.
> >>>>> Thank you!  You are keeping the pr_alert(), correct?
> >>>>
> >>>> Yup, just the lockdep call goes away.
> >>>
> >>> Okay, this reproduced faster than I anticipated:
> >>>
> >>> [  786.160131] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.239513] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.240503] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.242575] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
> >>>
> >>> It seems like the WARN_ON_ONCE was hiding the fact it actually got hit couple
> >>> of times in a very short interval. Maybe that would also explain lockdep crapping
> >>> itself.
> >>
> >> OK, that was what I thought was the situation.  I have not yet fully
> >> worked out how RCU gets into that state, but in the meantime, here
> >> is a patch that should prevent the splats.  (It requires a subtle
> >> interaction of quiescent-state detection and the scheduling-clock
> >> interrupt.)
> > 
> > And I did finally figure out how this can happen.  Please see below
> > for an updated patch with this information recorded in the commit log.
> > Sasha, I am impressed -- your testing not only located a true RCU bug,
> > but an RCU bug that can happen on a uniprocessor!  ;-)
> > 
> > As far as I know, the bug is harmless apart from the splat, but still...
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Clear need_qs flag to prevent splat
> > 
> > If the scheduling-clock interrupt sets the current tasks need_qs flag,
> > but if the current CPU passes through a quiescent state in the meantime,
> > then rcu_preempt_qs() will fail to clear the need_qs flag, which can fool
> > RCU into thinking that additional rcu_read_unlock_special() processing
> > is needed.  This commit therefore clears the need_qs flag before checking
> > for additional processing.
> > 
> > For this problem to occur, we need rcu_preempt_data.passed_quiesce equal
> > to true and current->rcu_read_unlock_special.b.need_qs also equal to true.
> > This condition can occur as follows:
> 
> 
> Hi, Paul
> I still can't draw the sequence map.
> 
> > 
> > 1.	CPU 0 is aware of the current preemptible RCU grace period,
> >     	but has not yet passed through a quiescent state.  Among other
> >     	things, this means that rcu_preempt_data.passed_quiesce is false.
> >     
> > 2.	Task A running on CPU 0 enters a preemptible RCU read-side
> >     	critical section.
> >     
> > 3.	CPU 0 takes a scheduling-clock interrupt, which notices the
> >     	RCU read-side critical section and the need for a quiescent state,
> >     	and thus sets current->rcu_read_unlock_special.b.need_qs to true.
> 
> 
> So, Task A is still in the preemptible RCU read-side critical section here.
> 
> >     
> > 4.	Task A is preempted, enters the scheduler, eventually invoking
> >     	rcu_preempt_note_context_switch() which in turn invokes
> >     	rcu_preempt_qs().
> >     
> >     	Because rcu_preempt_data.passed_quiesce is false,
> >     	control enters the body of the "if" statement, which sets
> >     	rcu_preempt_data.passed_quiesce to true.
> >     
> > 5.	At this point, CPU 0 takes an interrupt.  The interrupt
> >     	handler contains an RCU read-side critical section, and
> >     	the rcu_read_unlock() notes that current->rcu_read_unlock_special
> >     	is nonzero, and thus invokes rcu_read_unlock_special().
> 
> If the previous critical section is not ended, this new critical section
> is nested, and this new critical section will not call rcu_read_unlock_special().
> 
> If the previous critical section is ended, the conditions were changed between
> step#3,#4,#5, and the following #6... can't happen.

Good point!  In my scenario, CPU 0 would not yet have switched away from
Task A.  Hmmm...  Yet Sasha really does see this failure.  Will give it
some more thought.

Any ideas?

							Thanx, Paul

> Thanks,
> Lai
> 
> >     
> > 6.	Once in rcu_read_unlock_special(), the fact that
> >     	current->rcu_read_unlock_special.b.need_qs is true becomes
> >     	apparent, so rcu_read_unlock_special() invokes rcu_preempt_qs().
> >     	Recursively, given that we interrupted out of that same
> >     	function in the preceding step.
> >     
> > 7.	Because rcu_preempt_data.passed_quiesce is now true,
> >     	rcu_preempt_qs() does nothing, and simply returns.
> >     
> > 8.	Upon return to rcu_read_unlock_special(), it is noted that
> >     	current->rcu_read_unlock_special is still nonzero (because
> >     	the interrupted rcu_preempt_qs() had not yet gotten around
> >     	to clearing current->rcu_read_unlock_special.b.need_qs).
> >     
> > 9.	Execution proceeds to the WARN_ON_ONCE(), which notes that
> >     	we are in an interrupt handler and thus duly splats.
> > 
> > The solution, as noted above, is to make rcu_read_unlock_special()
> > clear out current->rcu_read_unlock_special.b.need_qs after calling
> > rcu_preempt_qs().  The interrupted rcu_preempt_qs() will clear it again,
> > but this is harmless.  The worst that happens is that we clobber another
> > attempt to set this field, but this is not a problem because we just
> > got done reporting a quiescent state.
> > 
> > Reported-by: Sasha Levin <sasha.levin@oracle.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 8669de884445..ec99dc16aa38 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -322,6 +322,7 @@ void rcu_read_unlock_special(struct task_struct *t)
> >  	special = t->rcu_read_unlock_special;
> >  	if (special.b.need_qs) {
> >  		rcu_preempt_qs();
> > +		t->rcu_read_unlock_special.need_qs = false;
> >  		if (!t->rcu_read_unlock_special.s) {
> >  			local_irq_restore(flags);
> >  			return;
> > 
> > .
> > 
> 

