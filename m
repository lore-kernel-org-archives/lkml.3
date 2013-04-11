Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936167Ab3DKD34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:29:56 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:33429 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935759Ab3DKD3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:29:55 -0400
Message-ID: <1365650992.707.83.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 23:29:52 -0400
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
In my previous reply, I have explained in length the race condition but
I didn't realize that you were also mentioning my refactoring of
task_sched_runtime() so I comment a little bit more about this proposal:

currently:

- cputimer is initialized with the result of thread_group_cputime()
which is (accounted time + tasks deltas)
- cputimer sample value is then cputimer + 1 more task_delta_exec() 
- After all active tasks pass through update_curr(), cputimer is
(accounted time + 2*(tasks deltas))

By being able to get separately get accounted time and delta, you can:

- Initialize cputimer to accounted time
- thread group cputimer sample will be cputimer + delta (which is
essentially equivalent to what would thread_group_cputime() return)
- After all the deltas are in by having called
account_group_exec_runtime(), cputimer will be set to (accounted time +
tasks delta) and have the exact same value of the corresponding process
clock.

In other words, currently the way the cputimer is initialized contribute
to make it advance faster than its corressponding process clock.

This part of the patch has nothing to do with race condition, as far as
I can tell, thread_group_cputime() and task_delta_exec() are rock solid.
It is just that you need delta and accounted time separately and
preferably atomically to be able to initialize posix cpu timer
correctly.

Greetings,
Olivier



