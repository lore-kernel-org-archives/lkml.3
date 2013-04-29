Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3D2GZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 02:25:38 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:32778 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3D2GZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 02:25:37 -0400
Message-ID: <517E125E.4050003@gmail.com>
Date: Mon, 29 Apr 2013 02:25:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] process cputimer is moving faster than its corresponding
 clock
References: <1365184746.874.103.camel@Wailaba2>  <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>  <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>  <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>  <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>  <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>  <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>  <517AD0AE.1030404@gmail.com> <1367036552.7911.63.camel@Wailaba2> <1367037663.7911.68.camel@Wailaba2>
In-Reply-To: <1367037663.7911.68.camel@Wailaba2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/27/13 12:41 AM), Olivier Langlois wrote:
> 
> 
> Add thread group delta to cpu timer sample when computing a timer expiration.
> 
> This is mandatory to make sure that the posix cpu timer does not fire too
> soon relative to the process cpu clock which do include the task group delta.
> 
> test case to validate the patch is glibc-2.17/rt/tst-cputimer1.c

First, I could reproduce this issue. thanks. Second, actually, this issue is not
cause by race. This just occur by timer initialization mistake. I'll show you
the smallest fix.



> @@ -697,7 +755,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
>         if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
>                 cpu_clock_sample(timer->it_clock, p, &val);
>         } else {
> -               cpu_timer_sample_group(timer->it_clock, p, &val);
> +               cpu_timer_sample_group(timer->it_clock, p, &val,
> +                                      CPUTIMER_NEED_DELTA);

POSIX says, 

http://pubs.opengroup.org/onlinepubs/7908799/xsh/timer_gettime.html
> If the argument ovalue is not NULL, the function timer_settime() stores, 
> in the location referenced by ovalue, a value representing the previous 
> amount of time before the timer would have expired or zero if the timer 
> was disarmed, together with the previous timer reload value. The members 
> of ovalue are subject to the resolution of the timer, and they are the 
> same values that would be returned by a timer_gettime() call at that point in time.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


but your posix_cpu_timer_set() and posix_cpu_timer_get() are not consistent. I'm worry
about this.


>         }
>  
>         if (old) {
> @@ -845,7 +904,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
>                         read_unlock(&tasklist_lock);
>                         goto dead;
>                 } else {
> -                       cpu_timer_sample_group(timer->it_clock, p, &now);
> +                       cpu_timer_sample_group(timer->it_clock, p, &now,
> +                                              CPUTIMER_NO_DELTA);
>
>                         clear_dead = (unlikely(p->exit_state) &&
>                                       thread_group_empty(p));
>                 }

