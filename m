Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3GKRug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:50:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49632 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3GKRuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:50:35 -0400
Date: Thu, 11 Jul 2013 10:50:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: Hard lockups using 3.10.0
Message-ID: <20130711175015.GZ16780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <8484013.LsABBJRIOx@devpool02>
 <20130711100721.GA28131@pd.tnic>
 <20130711105207.GE25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711105207.GE25631@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071117-2398-0000-0000-0000004A5F27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:52:07PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 11, 2013 at 12:07:21PM +0200, Borislav Petkov wrote:
> > On Thu, Jul 11, 2013 at 11:38:37AM +0200, Rolf Eike Beer wrote:
> > > Hi,
> > > 
> > > I'm running 3.10.0 (from openSUSE packages) on an "Intel(R) Core(TM) i7-2600 
> > > CPU @ 3.40GHz". I got a hard lockup on one of my CPUs twice, once with 
> > > backtrace (see attached image). Graphics is the builtin Intel, used with X 7.6 
> > > and KDE 4.10beta2 (basically current openSUSE 12.3+KDE).
> > > 
> > > I'm not aware that I had done anything special, just "normal" desktop and 
> > > development usage, but no heavy compile work at the moment the lockups 
> > > happened.
> > 
> > Hmm, I can see commit_creds() doing some rcu pointers assignment and rcu
> > calling into the scheduler which screams about a cpu runqueue of the
> > task we're about to reschedule not being locked. Let's add some more
> > people who should know better.
> 
> Ok, for the other people too lazy to bother finding the picture:
> 
>   http://marc.info/?l=linux-kernel&m=137353587012001&q=p3
> 
> So we bug at:
> 
> kernel/sched/core.c:519 assert_raw_spin_locked(&task_rq(p)->lock);
> 
> and get there through:
> 
>   resched_task()
>   check_preempt_wakeup()
>   check_preempt_curr()
>   try_to_wake_up()
>   autoremove_wake_function()
>   __call_rcu_nocb_enqueue()
>   __call_rcu()
>   commit_creds()
>   ____call_usermodehelper()
>   ret_from_fork()
> 
> That don't make much sense though. Since:
> 
>   try_to_wake_up()
>     ttwu_queue()
>       raw_spin_lock(&rq->lock)
>       ttwu_do_activate()
>         ttwu_do_wakeup()
>           check_preempt_curr()
>             check_preempt_wakeup()
>               resched_task(rq->curr)
>                 assert_raw_spin_locked(task_rq(p)->lock)
> 
> It would somehow mean that 'task_rq(rq->curr) != rq', that's completely
> bonkers, we do after all have rq->lock locked.
> 
> I must also say that I've _never_ seen this bug before.

New one on me as well.  Is this reproducible?  If so, does it happen
when CONFIG_RCU_NOCB_CPU=n?  (Given the call to call_rcu_nocb_enqueue(),
I expect that you built with CONFIG_RCU_NOCB_CPU=y.)  Can't say that I
see how call_rcu_nocb_enqueue() would have caused this, but...

Well, I supposed that if RCU's callback lists got corrupted, this
(and much else besides) could in fact happen.  Does your build have
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y?  If not, could you please try it?

							Thanx, Paul

