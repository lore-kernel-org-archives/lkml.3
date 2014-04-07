Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaDGSRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:17:48 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:60096 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbaDGSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:17:46 -0400
Date: Mon, 7 Apr 2014 20:17:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
Message-ID: <20140407181736.GA4106@localhost.localdomain>
References: <5338CC86.9080602@jp.fujitsu.com>
 <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
 <20140404160328.GA10042@localhost.localdomain>
 <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
 <20140405100813.GA16696@localhost.localdomain>
 <CAK1hOcO2X7juCSkKrd85q8_i8Xv4vhZg2YKtzybwmWukoCEyow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcO2X7juCSkKrd85q8_i8Xv4vhZg2YKtzybwmWukoCEyow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 04:56:54PM +0200, Denys Vlasenko wrote:
> On Sat, Apr 5, 2014 at 12:08 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > Iowait makes sense but not per cpu. Eventually it's a global
> >> > stat. Or per task.
> >>
> >> There a lot of situations where admins want to know
> >> how much, on average, their CPUs are idle because
> >> they wait for IO.
> >>
> >> If you are running, say, a Web cache,
> >> you need to know that stat in order to be able to
> >> conjecture "looks like I'm IO bound, perhaps caching
> >> some data in RAM will speed it up".
> >
> > But then accounting iowait time waited until completion on the CPU
> > that the task wakes up should work for that.
> >
> > Doesn't it?
> 
> It can easily make iowait count higher than idle count,
> or even higher than idle+sys+user+nice count.
> 
> IOW, it can show that the system is way more
> than 100% IO bound, which doesn't make sense.

I'm talking about a semantic change, not just an implementation change.
Of course if we change iowait to "account _all_ iowait time" while it's still
interpreted with the old semantics that only "account iowait & idle time from the
CPU source", we have a problem.

Well this breakage is inevitable actually. It's just going to be leveraged
by the fact that CONFIG_NO_HZ actually never accounted correctly this iowait.

So, since it's already broken, I think we meet the conditions for an ABI change.


> 
> 
> > So we save, per task, the time when the task went to sleep. And when it wakes up
> > we just flush the pending time since that sleep time to the waking CPU:
> > iowait[$CPU] += NOW() - tsk->sleeptime;
> >
> >> Is such counter meaningful for the admin?
> >
> > Well, you get the iowait time accounting.
> 
> Admin wants to know "how often do I have CPU idled
> because they have nothing to do until IO is complete?"
> 
> Merely knowing how much tasks waited for IO
> doesn't answer that question.

If the admin asks this question on a per CPU basis, it's simply a
wrong question. Because a task waiting on an IO to complete is a
sleeping task. And a sleeping task doesn't belong to any CPU.

It's a pure per task property that can't be mapped on the lower
CPU level.

OTOH it can make sense to ask how much time did we wait on IO
and account this on the CPU which either initiated the IO or
ran the task on IO completion. Why not, it can give you an overview
of where these IO things happen most.

But the accounting we are doing today does not that.
Instead, it accounts the time spent on the CPU which initiated
the IO and only when it is idle. It is a terrible misconception that
is completly subject to scheduler randomness:

The following example displays all the nonsense of that stat:

    CPU 0                     CPU 1

    task A block on IO        ...
    task B runs for 1 min     ...
    task A completes IO

So in the above we've been waiting on IO for 1 minute. But none of that
have been accounted. OTOH if task B were to run on CPU 1 (it could have,
really here this is about scheduler load balancing internals, hence pure
randomness for the user), the iowait time would have been accounted.

I doubt that users are interested in such random accounting. They want
to know either:

1) how much time was spent waiting on IO by the whole system
2) how much time was spent waiting on IO per task
3) how much time was spent waiting on IO per CPU that initiated
   IOs, or per CPU which ran task completing IOs. In order to have
   an overview on where these mostly happened.

Given my above practical example, the current accounting is unable
to reliably report any of these informations. Because it is misdesigned
and doesn't account the right thing.

Now I'm repeating, why are we accounting iowait that way then?
Because it was very convenient from an implementation POV on periodic
tick systems. But it's certainly not convenient for the users given
this accounting randomness.

Now we run dynticks kernels, mostly. And this accounting is just not
possible anymore. Not if we want to keep our kernel scalable.

Hence I think we must change the semantics of our iowait accounting.
This stat is broken since the very beginning and is a strong candidate
for a semantical ABI change.

You guys can argue as much as you want. I'll maintain my position.

Unless you find a way to maintain the current accounting semantics while
keeping it scalable and correct, good luck!
