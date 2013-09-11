Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3IKQk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:40:58 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59386 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3IKQk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:40:56 -0400
Message-ID: <52309D13.3020305@linaro.org>
Date: Wed, 11 Sep 2013 09:40:51 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
References: <20130911150853.GA19800@Krystal>
In-Reply-To: <20130911150853.GA19800@Krystal>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 08:08 AM, Mathieu Desnoyers wrote:
> Starting from commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
> "timekeeping: Hold timekeepering locks in do_adjtimex and hardpps"
> (3.10 kernels), the xtime write seqlock is held across calls to
> __do_adjtimex(), which includes a call to notify_cmos_timer(), and hence
> schedule_delayed_work().
>
> This introduces a side-effect for a set of tracepoints, including mainly
> the workqueue tracepoints: a tracer hooking on those tracepoints and
> reading current time with ktime_get() will cause hard system LOCKUP such
> as:
Oh bummer. I had just worked this issue out the other day:
    https://lkml.org/lkml/2013/9/9/476

Apparently it was a schroedinbug of sorts. My apologies for time you
spent chasing this down.

My plan is to pull the notify_cmos_timer call to outside of the
timekeeper locking (see the patch at the very end of the mail in the
above link), as well as try to add lockdep support to seqcount/seqlocks
so we can catch these sorts of issues more easily.


> LTTng uses ktime to have the same time-base across kernel and
> user-space, so traces gathered from LTTng-modules and LTTng-UST can be
> correlated. We plan on using ktime until a fast, scalable, and
> fine-grained time-source for tracing that can be used across kernel and
> user-space, and which does not rely on read seqlock for kernel-level
> synchronization, makes its way into the kernel.

So my fix for the issue aside, I could see cases where using timekeeping
for tracing could run into similar issues, so something like your
timekeeping_is_busy() check sounds reasonable. I might suggest we wrap
the timekeeper locking in a helper function so we don't have the
spinlock(); set_owner(); write_seqcount(); pattern all over the place
(and it avoids me forgetting to set the owner in some future change,
further mucking things up :).


As for your waiting for "fast, scalable, and fine-grained time-source
for tracing that can be used across kernel and user-space, and which
does not rely on read seqlock for kernel-level synchronization" wish,
I'd be interested in hearing ideas if anyone has them.

After getting the recent lock-hold reduction work merged in 3.10, I had
some thoughts that maybe we could do some sort of rcu style timekeeper
switch. The down side is that there really is a time bound in which the
timekeeper state is valid for, so there would have to be some sort of
seqcount style "retry if we didn't finish the calculation within the
valid bound" (which can run into similar deadlock problems if the
updater is delayed by a reader spinning waiting for an update).

Also there is the memory issue of having N timekeeper structures hanging
around, since there could be many readers delayed mid-calculation, but
that could probably be bound by falling back to a seqcount (and again,
that opens up deadlock possibilities). Anyway, it all gets pretty
complicated pretty quickly, which makes ensuring correctness even harder. :(

But yea, I'd be interested in other ideas and approaches.

thanks
-john



