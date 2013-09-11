Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3IKSyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:54:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43620 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754311Ab3IKSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:54:46 -0400
Date: Wed, 11 Sep 2013 14:54:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130911185441.GC23532@Krystal>
References: <20130911150853.GA19800@Krystal> <52309D13.3020305@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52309D13.3020305@linaro.org>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Stultz (john.stultz@linaro.org) wrote:
> On 09/11/2013 08:08 AM, Mathieu Desnoyers wrote:
[...]

Now focusing on features (the fix discussion is in a separate
sub-thread):

> 
> > LTTng uses ktime to have the same time-base across kernel and
> > user-space, so traces gathered from LTTng-modules and LTTng-UST can be
> > correlated. We plan on using ktime until a fast, scalable, and
> > fine-grained time-source for tracing that can be used across kernel and
> > user-space, and which does not rely on read seqlock for kernel-level
> > synchronization, makes its way into the kernel.
> 
> So my fix for the issue aside, I could see cases where using timekeeping
> for tracing could run into similar issues, so something like your
> timekeeping_is_busy() check sounds reasonable.

Yep, it would certainly make those use of ktime_get() more robust
against internal changes.

> I might suggest we wrap
> the timekeeper locking in a helper function so we don't have the
> spinlock(); set_owner(); write_seqcount(); pattern all over the place
> (and it avoids me forgetting to set the owner in some future change,
> further mucking things up :).

Good idea.

> As for your waiting for "fast, scalable, and fine-grained time-source
> for tracing that can be used across kernel and user-space, and which
> does not rely on read seqlock for kernel-level synchronization" wish,
> I'd be interested in hearing ideas if anyone has them.

So far, the best I could come up with is this: using a RCU (or RCU-like)
scheme to protect in-kernel timestamp reads (possibly with RCU sched,
which is based on preemption disabling), and use a sequence lock to
protect reads from user-space.

Time updates within the kernel would have to deal with both RCU pointer
update and track quiescent state, and would need to hold a write seqlock
to synchronize against concurrent user-space reads.

> After getting the recent lock-hold reduction work merged in 3.10, I had
> some thoughts that maybe we could do some sort of rcu style timekeeper
> switch. The down side is that there really is a time bound in which the
> timekeeper state is valid for, so there would have to be some sort of
> seqcount style "retry if we didn't finish the calculation within the
> valid bound" (which can run into similar deadlock problems if the
> updater is delayed by a reader spinning waiting for an update).

What could make a reader fail to finish the calculation within the valid
time bound ? Besides preemption ? If it's caused by a too long
interrupt, this will have an effect on the entire timekeeping, because
the timer interrupt will likely be delayed, and therefore the periodical
update changing the write seqlock value will be delayed too. So for the
interrupt case, it looks like a "too long" interrupt (or interrupt
disable section) will already disrupt timekeeping with the current
design.

> 
> Also there is the memory issue of having N timekeeper structures hanging
> around, since there could be many readers delayed mid-calculation, but
> that could probably be bound by falling back to a seqcount (and again,
> that opens up deadlock possibilities). Anyway, it all gets pretty
> complicated pretty quickly, which makes ensuring correctness even harder. :(
> 
> But yea, I'd be interested in other ideas and approaches.

If we can afford a synchronize_rcu_sched() wherever the write seqlock is
needed, we could go with the following. Please note that I use
synchronize_rcu_sched() rather than call_rcu_sched() here because I try
to avoid having too many timekeeper structures hanging around, and I
think it can be generally a good think to ensure timekeeping core does
not depend on the memory allocator (but I could very well be wrong).

In kernel/time/timekeeper.c:

static DEFINE_MUTEX(timekeeper_mutex);
static seqcount_t timekeeper_user_seq;

struct timekeeper_rcu {
        struct a[2];
        struct timekeeper *p;   /* current */
};

/* Timekeeper structure for kernel readers */
static struct timekeeper_rcu timekeeper_rcu;

/* Timekeeper structure for userspace readers */
static struct timekeeper timekeeper_user;

/* for updates */
update_time()
{
        struct timekeeper *next_p;

        mutex_lock(&timekeeper_mutex);

        /* RCU update, for kernel readers */
        if (timekeeper_rcu.p == &timekeeper_rcu.a[0])
                next_p = &timekeeper_rcu.a[1];
        else
                next_p = &timekeeper_rcu.a[0];

        timekeeper_copy(next_p, timekeeper_rcu.p);
        timekeeper_do_update(next_p, ...);

        rcu_assign_pointer(timekeeper_rcu.p, next_p);

        /*
         * Ensure there are no more readers in flight accessing the old
         * element.
         */
        synchronize_rcu_sched();

        /* seqlock update, for user-space readers */
        write_seqcount_begin(&timekeeper_user_seq);
        timekeeper_do_update_user(&timekeeper_user);
        write_seqcount_end(&timekeeper_user_seq);

        mutex_unlock(&timekeeper_mutex);
}


/*
 * Accessing time from kernel. Should be called with preemption
 * disabled.
 */
u64 __read_time_kernel()
{
        struct timekeeper *p;

        p = rcu_dereference(timekeeper_rcu.p);
        return get_value_from(p);
}

/* Accessing time from user-space (vDSO) */

u64 read_time_user()
{
        /*
         * Read timekeeper_user within a read_seqcount loop.
         */
}


As far as I see, the write seqcount is currently taken by:

- do_settimeofday()
- timekeeping_inject_offset()
- timekeeping_set_tai_offset()
- change_clocksource()
- timekeeping_init()
- timekeeping_inject_sleeptime()
- timekeeping_resume()
- timekeeping_suspend()
- update_wall_time()
- do_adjtimex()
- hardpps()

It might be good to breakdown which of these functions could afford a
synchronize_rcu_sched(), and which can't. Maybe part of the solution
could be to use different data structures, and separate synchronization,
for the ajdtime part (executed in thread context) vs for
update_wall_time, AFAIK executed in interrupt context. We might also
want to consider that the adjtime part needs to be global, vs
update_wall_time which could possibly be done on per-cpu data
structures, which could simplify synchronization.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
