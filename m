Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936945Ab3DJPse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:48:34 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37488 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752110Ab3DJPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:48:33 -0400
Message-ID: <1365608911.707.65.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 11:48:31 -0400
In-Reply-To: <1365593710.30071.52.camel@laptop>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 13:35 +0200, Peter Zijlstra wrote:
> On Fri, 2013-04-05 at 13:59 -0400, Olivier Langlois wrote:
> > Process timers are moving fasters than their corresponding
> >  cpu clock for various reasons:
> > 
> > 1. There is a race condition when getting a timer sample that makes the sample
> >    be smaller than it should leading to setting the timer expiration to soon.
> > 2. When initializing the cputimer, by including tasks deltas in the initial
> >    timer value, it makes them be counted twice.
> > 3. When a thread autoreap itself when exiting, the last context switch update
> >    will update the cputimer and not the overall process values stored in
> >    signal.
> 
> Please explain these races. Things like task_sched_runtime() on which
> most of this stuff is build read both sum_exec_runtime and compute the
> delta while holding the rq->lock; this should avoid any and all races
> against update_curr() and the sort.
> 
> All this fiddling with conditional deltas seems very ugly, esp. since
> no attempt is made to explain why it would be impossible to tighten the
> synchronization to avoid the races.

Peter,

You have valid concerns and I will attempt to clarify the changes I
propose. Before I do, realise that as a first time patcher, I sincerely
attempted to minimize the changes required to fix the posix cputimers.

The real source of the problem is that the process clock is distinct
from its cputimer. It is not explained why it is done like that in the
code but I understand that the benefit is that you can fetch the
cputimer value and avoiding the cost to traverse the list of tasks
member of the group. The price to pay however it is that it is painful
to make sure that the clock and its corresponding cputimer remain in
sync as they advance. With that in mind, I did all I can to minimize
thread group task list traversal when possible and do it only when
mandatory which is when you set a timer expiration time.

1. To set an accurate expiration time, you need to account for all
thread group tasks delta.

The code used to only get the delta of 1 task when getting a cputimer
sample but this is not enough. Imagine getting this sample on a thread
group of at least same number of tasks than there is processor on the
system just before a timer interrupt. Your timer could fire +- (num of
cores)/HZ sec earlier than requested because just after getting your
sample all these deltas will be added to the process cputimer.

For the race condition, IMO it is not easy or desirable to fix it as it
would be too expensive. Simply acknowledge its presence and work around
it to avoid side effects is wiser. That is what I explain in the comment
inside the function  thread_group_cputimer_withdelta().

To compute the sum of deltas or when calling thread_group_cputime(), the
code locks each task rq one by one. After that thread_group_cputimer()
will lock the cputimer lock to get or set the cputimer value.

If you get the cputimer value first from thread_group_cputimer(), you
could have another thread executing update_curr(), it is maybe blocked
on the cputimer lock. This delta will appear nowhere as it will not be
in the cputimer, nor will it appear when call task_delta_exec() after.

Inverse the order, call delta_exec first and then get cputimer, the
delta can be counted twice. A task running concurently for which you
already collected its delta could update the cputimer while you complete
the call on group_delta_exec.

To really fix the race, you would need to hold all the process tasks rqs
and the cputimer lock at the same time. As a first time patcher, I
didn't want to go there or even dare to contemplate the idea :-) but IMO
if the goal is just to make sure that timers do not fire before their
requested expiration, just order the function calls to be sure you reach
the goal is sufficient to me.

There is another manifestation of the same race condition when
initializing the cputimer. When calling thread_group_cputime() and
before cputimer->running is set, nothing stops another thread to drop
its delta when calling  account_group_exec_runtime().

This one would affect only absolute timers however. If you really wanted
to address it you could:

1. Lock cputimer
2. Set cputimer->running
3. Save to a local variable its value
3. Unlock cputimer call thread_group_cputime()
4. Relock cputimer.
5. substract previous cputimer value from current one.
6. Set cputimer with cputime add the diff computed in #5.

I experimented with this idea and did measure frequently diff of 20000
and sometimes up to 60000.

But going there is really starting to be ugly and I didn't care about
absolute timers. We can explore the idea if you want tho.

> 
> > I have also removed to erractic cputimer start/stop. I am guessing that it
> > was done to 'resync' once in a while the cputimer with the clock but
> > you could start the cputimer by calling timer_settimer that finally
> > do not end up by arming a new posix timer so you could have the cputimer
> > running with 0 armed timers or have 1 periodic process timer.
> 
> No keeping a process wide (over all threads) cputime aggregate running
> is _expensive_, so its important to stop doing this once there's nobody
> who cares about it anymore.
> 
Please explain how expensive it is. All I am seeing is a couple of additions.

If it is important to stop it then the code will require a fix anyway.

1.
As you could start it
indefinitely with 0 timers if calling posix_cpu_timer_set() does not end
up arming a timer or

2.

Having one periodic timer. The cputimer will be stopped in
check_process_timers() to be immediatly restarted in
posix_cpu_timer_schedule() every single time the timer will be fired.

By adding a small printk() when initializing the cputimer, I have been
puzzled and surprised to see how many times it was intialized by
executing glibc2.17/rt/tst-cputimer1 !

I am not sure how expensive it is to run the timer, but I do know
initializing it is _really_expensive_ expecially if it is done when a
periodic high frequency timer is fired.

To conclude, I have tested the patch on a variety of hardware from a
ATOM N450 to a Intel 3930K I7. Since my initial post, I am sad to
announce that it does not always work on very fast system. IMO, all
small fixes that I have presented are valid and do indeed improve the
posix cpu timers accuracy but I still have a small glitch or 2 to nail
down.

Thank you,
Olivier



