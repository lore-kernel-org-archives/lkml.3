Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab3D2RQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:16:34 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52495 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757755Ab3D2RQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:16:31 -0400
Message-ID: <1367255788.8833.7.camel@Wailaba2>
Subject: Re: [PATCH v2 3/3] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 13:16:28 -0400
In-Reply-To: <517E125E.4050003@gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367036552.7911.63.camel@Wailaba2>
	 <1367037663.7911.68.camel@Wailaba2> <517E125E.4050003@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 02:25 -0400, KOSAKI Motohiro wrote:
> (4/27/13 12:41 AM), Olivier Langlois wrote:
> > 
> > 
> > Add thread group delta to cpu timer sample when computing a timer expiration.
> > 
> > This is mandatory to make sure that the posix cpu timer does not fire too
> > soon relative to the process cpu clock which do include the task group delta.
> > 
> > test case to validate the patch is glibc-2.17/rt/tst-cputimer1.c
> 
> First, I could reproduce this issue. thanks. Second, actually, this issue is not
> cause by race. This just occur by timer initialization mistake. I'll show you
> the smallest fix.
> 
> 
Great!
> 
> > @@ -697,7 +755,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
> >         if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
> >                 cpu_clock_sample(timer->it_clock, p, &val);
> >         } else {
> > -               cpu_timer_sample_group(timer->it_clock, p, &val);
> > +               cpu_timer_sample_group(timer->it_clock, p, &val,
> > +                                      CPUTIMER_NEED_DELTA);
> 
> POSIX says, 
> 
> http://pubs.opengroup.org/onlinepubs/7908799/xsh/timer_gettime.html
> > If the argument ovalue is not NULL, the function timer_settime() stores, 
> > in the location referenced by ovalue, a value representing the previous 
> > amount of time before the timer would have expired or zero if the timer 
> > was disarmed, together with the previous timer reload value. The members 
> > of ovalue are subject to the resolution of the timer, and they are the 
> > same values that would be returned by a timer_gettime() call at that point in time.
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 
> but your posix_cpu_timer_set() and posix_cpu_timer_get() are not consistent. I'm worry
> about this.
> 
> 
> >         }
> >  
> >         if (old) {
> > @@ -845,7 +904,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
> >                         read_unlock(&tasklist_lock);
> >                         goto dead;
> >                 } else {
> > -                       cpu_timer_sample_group(timer->it_clock, p, &now);
> > +                       cpu_timer_sample_group(timer->it_clock, p, &now,
> > +                                              CPUTIMER_NO_DELTA);
> >
> >                         clear_dead = (unlikely(p->exit_state) &&
> >                                       thread_group_empty(p));
> >                 }
> 
> --
I have tried to minimize rq locks contention to strict minimum. If to
remain POSIX compliant, it is required to also use CPUTIMER_NEED_DELTA,
so be it. I have no objections.



