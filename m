Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaEIKis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:38:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46480 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaEIKir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:38:47 -0400
Message-ID: <536CAF29.7070401@linux.vnet.ibm.com>
Date: Fri, 09 May 2014 16:04:17 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, khilman@linaro.org
Subject: Re: [PATCH 1/2] hrtimer: reprogram event for expires=KTIME_MAX in
 hrtimer_force_reprogram()
References: <cover.1399623699.git.viresh.kumar@linaro.org> <189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org>
In-Reply-To: <189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050910-5806-0000-0000-000024D519B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 05/09/2014 02:10 PM, Viresh Kumar wrote:
> In hrtimer_force_reprogram(), we are reprogramming event device only if the next
> timer event is before KTIME_MAX. But what if it is equal to KTIME_MAX? As we
> aren't reprogramming it again, it will be set to the last value it was, probably
> tick interval, i.e. few milliseconds.
> 
> And we will get a interrupt due to that, wouldn't have any hrtimers to service
> and return without doing much. But the implementation of event device's driver
> may make it more stupid. For example: drivers/clocksource/arm_arch_timer.c
> disables the event device only on SHUTDOWN/UNUSED requests in set-mode.
> Otherwise, it will keep giving interrupts at tick interval even if
> hrtimer_interrupt() didn't reprogram tick..
> 
> To get this fixed, lets reprogram event device even for KTIME_MAX, so that the
> timer is scheduled for long enough.

I looked through the code in arm_arch_timer.c and I think the more
fundamental problem lies in the timer handler there. Ideally even before
calling the tick event handler the timer handler must be programming the
tick device to fire at some __MAX__ time.
Then irrespective of whether the core kernel deems it appropriate to
program it or not, the max time by which a timer interrupt will get
deferred is __MAX__ and one will not find anomalies like what you saw.

The reason this got exposed in NOHZ_FULL config is because in a normal
NOHZ scenario when the cpu goes idle, and there are no pending timers in
timer_list, even then tick_sched_timer gets cancelled. Precisely the
scenario that you have described.
   But we don't get continuous interrupts then because the first time we
get an interrupt, we queue the tick_sched_timer and program the tick
device to the time of its expiry and therefore *push* the time at which
your tick device should fire further.
  In case of NOHZ_FULL however I am presuming you will not queue the
tick_sched_timer again unless there is more than one process in the
runqueue. Therefore the tick device keeps firing since its counter
remains in the expired state and is not pushed up.

Moreover from the core kernel's perspective also this does not look like
the right thing to do. The core timer code cannot *shutdown* a clock
device simply because there are no pending timers. Some arch may change
their notion of *shutdown* to rendering the tick device unusable. Some
archs may already do that.
   Hence I don't think we should take a drastic measure as to shutdown
the clock device in case of no pending timers,

My suggestion is as pointed above to set the tick device to a KTIME_MAX
equivalent before calling the timer interrupt event handler.

Regards
Preeti U Murthy
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/hrtimer.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 6b715c0..b21085c 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -591,8 +591,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
>  	if (cpu_base->hang_detected)
>  		return;
> 
> -	if (cpu_base->expires_next.tv64 != KTIME_MAX)
> -		tick_program_event(cpu_base->expires_next, 1);
> +	tick_program_event(cpu_base->expires_next, 1);
>  }
> 
>  /*
> 

