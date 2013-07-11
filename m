Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3GKKw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:52:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3GKKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:52:58 -0400
Date: Thu, 11 Jul 2013 12:52:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Hard lockups using 3.10.0
Message-ID: <20130711105207.GE25631@dyad.programming.kicks-ass.net>
References: <8484013.LsABBJRIOx@devpool02>
 <20130711100721.GA28131@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711100721.GA28131@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:07:21PM +0200, Borislav Petkov wrote:
> On Thu, Jul 11, 2013 at 11:38:37AM +0200, Rolf Eike Beer wrote:
> > Hi,
> > 
> > I'm running 3.10.0 (from openSUSE packages) on an "Intel(R) Core(TM) i7-2600 
> > CPU @ 3.40GHz". I got a hard lockup on one of my CPUs twice, once with 
> > backtrace (see attached image). Graphics is the builtin Intel, used with X 7.6 
> > and KDE 4.10beta2 (basically current openSUSE 12.3+KDE).
> > 
> > I'm not aware that I had done anything special, just "normal" desktop and 
> > development usage, but no heavy compile work at the moment the lockups 
> > happened.
> 
> Hmm, I can see commit_creds() doing some rcu pointers assignment and rcu
> calling into the scheduler which screams about a cpu runqueue of the
> task we're about to reschedule not being locked. Let's add some more
> people who should know better.

Ok, for the other people too lazy to bother finding the picture:

  http://marc.info/?l=linux-kernel&m=137353587012001&q=p3

So we bug at:

kernel/sched/core.c:519 assert_raw_spin_locked(&task_rq(p)->lock);

and get there through:

  resched_task()
  check_preempt_wakeup()
  check_preempt_curr()
  try_to_wake_up()
  autoremove_wake_function()
  __call_rcu_nocb_enqueue()
  __call_rcu()
  commit_creds()
  ____call_usermodehelper()
  ret_from_fork()

That don't make much sense though. Since:

  try_to_wake_up()
    ttwu_queue()
      raw_spin_lock(&rq->lock)
      ttwu_do_activate()
        ttwu_do_wakeup()
          check_preempt_curr()
            check_preempt_wakeup()
              resched_task(rq->curr)
                assert_raw_spin_locked(task_rq(p)->lock)

It would somehow mean that 'task_rq(rq->curr) != rq', that's completely
bonkers, we do after all have rq->lock locked.

I must also say that I've _never_ seen this bug before.
