Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbaGXT50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:57:26 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34766 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:57:25 -0400
Message-ID: <53D165A5.6010206@gmail.com>
Date: Thu, 24 Jul 2014 15:59:33 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 11/16] rcu: Check for spurious wakeup using return value
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com> <1406092194-13004-12-git-send-email-bobby.prani@gmail.com> <20140723122608.GL11241@linux.vnet.ibm.com> <CAJhHMCC7_GLmBroGhKWMJJKuWqhojQGf=9So1_x4nb2adQvqFg@mail.gmail.com> <20140724034315.GJ11241@linux.vnet.ibm.com> <CAJhHMCDhwnKF5tiWvHyGrz3KhCab+QUnAfEmkzjsBrNn5O3gyQ@mail.gmail.com> <20140724181223.GO11241@linux.vnet.ibm.com>
In-Reply-To: <20140724181223.GO11241@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding peterz to CC as git blames him for wait_event code. :)

(original LKML link: https://lkml.org/lkml/2014/7/23/45)

On Thu, Jul 24, 2014 at 2:12 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

>> >> > How does this added check help?  I don't see that it does.  If the flag
>> >> > is set, we want to wake up.  If we get a spurious wakeup, but then the
>> >> > flag gets set before we actually wake up, we still want to wake up.
>> >>
>> >> So I took a look at the docs again, and using the return value is the
>> >> recommended way to check for spurious wakeups.
>> >>
>> >> The condition in wait_event_interruptible() is checked when the task
>> >> is woken up (either due to stray signals or explicitly) and it returns
>> >> true if condition evaluates to true.
>>
>> this should be returns '0' if the condition evaluates to true.
>
> Ah, but if the condition changes while wait_event_interruptible() is in
> the process of returning, it is quite possible that the answer will be
> different afterwards.  For example, consider this scenario:
>
> o       wait_event_interruptible() decides to return spuriously for
>         whatever reason, and thus returns a non-zero value.
>
> o       An invocation of (say) rcu_start_gp_advanced() sets ->gp_flags
>         to RCU_GP_FLAG_INIT, thus requesting that a new grace period
>         start.
>
> o       At this point, the return value says that we should not start
>         a new grace period, but the ->gp_flags value says that we
>         should.
>
> Because it is the ->gp_flags value that really knows, the current code
> ignores wait_event_interruptible()'s return value and just checks
> the ->gp_flags value.

OK. Let me simplify what wait_event_interruptible is doing. That will
give you an idea why checking the return value is sufficient.

In highly simplified form wait_event() does the following:

ret = wait_event(wq, condition):

	ret = -ERESTARTSYS;
	if (condition) {
		ret = 0;
		goto out;
	}
	sleep();
	/* wakes up */
	if (condition)
		ret = 0;
out:
	return ret;

Considering this, the above situation will now be:

o       wait_event_interruptible() decides to return spuriously for
        whatever reason, and thus returns a non-zero value.

o       An invocation of (say) rcu_start_gp_advanced() sets ->gp_flags
        to RCU_GP_FLAG_INIT, thus requesting that a new grace period
        start.

o       At this point, the return value says that we should not start
        a new grace period, but the ->gp_flags value says that we
        should.

o	We see that return value is non-zero and go back to wait_event

o	In wait_event, we check that the condition is actually true and 
	return immediately without sleeping and with a return value of 0.

If ->gp_flags is set after returning from wait_event_interruptible and we 
get back to waiting again, we will immediately see that the condition is true
and return and continue with rcu_gpu_init().

The basic idea is that in cases of spurious wakeup we return to waiting as
soon as possible and if the condition becomes true while we are going back to
wait_event, we return immediately with a value of 0.

>
>> >> In the current scenario, if we get a spurious wakeup, we take the
>> >> costly path of checking this condition again (with a barrier and lock)
>> >> before going back to wait.
>> >>
>> >> The scenario of getting an actual wakeup after getting a spurious
>> >> wakeup exists even today, this is the window after detecting a
>> >> spurious wakeup and before going back to wait. I am not sure if using
>> >> the return value enlarges that window as we are going back to sleep
>> >> immediately.
>> >>
>> >> Thoughts?
>> >
>> > If the flag is set, why should we care whether or not the wakeup was
>> > spurious?  If the flag is not set, why should we care whether or not
>> > wait_event_interruptible() thought that the wakeup was not spurious?
>>
>> A correction about the return value above: return will be 0 if the
>> condition is true, in this case if the flag is set.
>>
>> If the flag is set, ret will be 0 and we will go ahead with
>> rcu_gp_init(). (no change wrt current behavior)
>
> Sorry, this is not always correct.  RCU is highly concurrent, so you do
> need to start thinking in terms of concurrency.  Your reasoning above
> is a symptom of single-threaded thinking.  Please see my scenario above
> showing how the return can be non-zero even though ->gp_flags is set.
>
>> If the flag is not set, currently we go ahead and call rcu_gp_init()
>> from where we check if the flag is set (after a lock+barrier) and
>> return.
>
> True enough.  Is that really a problem?  If so, exactly why is it a
> problem?

The problem is that we are detecting a spurious wakeup after unnecessary work
which we can avoid by checking the return value.

>
>> If we care about what wait_event_interruptible() returns, we can go
>> back and wait for an actual wakeup much earlier without the additional
>> overhead of calling rcu_gp_init().
>
> The key phrase here is "If we care".  Should we care?  If so, why?
>
> I suggest running some random benchmark and counting how many times
> rcu_gp_init() is called and how many times rcu_gp_init() returns
> because ->gp_flags is not set.  If rcu_gp_init() returns because
> ->gp_flags is not set a significant fraction of the time, then this
> -might- be worth worrying about.  (Extra credit: Under what conditions

In the grand scheme of things, I agree that minor optimizations may not seem
to be worth much. But when the optimizationss are straight forward and 
are _actually_ improving things, even by a small margin, I think they are
worth considering.

Think of the billions of cycles we will save ;-)

> -might- be worth worrying about.  (Extra credit: Under what conditions
> would it be worth worrying about, and how would you go about checking
> to see whether those conditions hold?)
>


-- 
Pranith
