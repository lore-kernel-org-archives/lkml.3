Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3D1Att (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 20:49:49 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44284 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3D1Atr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 20:49:47 -0400
Date: Sun, 28 Apr 2013 02:49:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, fernando_b1@lab.ntt.co.jp,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: Add workaround for idle/iowait decreasing problem.
Message-ID: <20130428004940.GA10354@somewhere>
References: <201301152014.AAD52192.FOOHQVtSFMFOJL@I-love.SAKURA.ne.jp>
 <alpine.LFD.2.02.1301151313170.7475@ionos>
 <201301180857.r0I8vK7c052791@www262.sakura.ne.jp>
 <1363660703.4993.3.camel@nexus>
 <201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp>
 <201304232145.AHE52181.HJVOOQSFLMFOtF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304232145.AHE52181.HJVOOQSFLMFOtF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 09:45:23PM +0900, Tetsuo Handa wrote:
> CONFIG_NO_HZ=y can cause idle/iowait values to decrease.
> 
> If /proc/stat is monitored with a short interval (e.g. 1 or 2 secs) using
> sysstat package, sar reports bogus %idle/iowait values because sar expects
> that idle/iowait values do not decrease unless wraparound happens.
> 
> This patch makes idle/iowait values visible from /proc/stat increase
> monotonically, with an assumption that we don't need to worry about
> wraparound.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

It's not clear in the changelog why you see non-monotonic idle/iowait values.

Looking at the previous patch from Fernando, it seems that's because we can
race with concurrent updates from the CPU target when it wakes up from idle?
(could be updated by drivers/cpufreq/cpufreq_governor.c as well).

If so the bug has another symptom: we may also report a wrong iowait/idle time
by accounting the last idle time twice.

In this case we should fix the bug from the source, for example we can force
the given ordering:

= Write side =                          = Read side =

// tick_nohz_start_idle()
write_seqcount_begin(ts->seq)
ts->idle_entrytime = now
ts->idle_active = 1
write_seqcount_end(ts->seq)

// tick_nohz_stop_idle()
write_seqcount_begin(ts->seq)
ts->iowait_sleeptime += now - ts->idle_entrytime
t->idle_active = 0
write_seqcount_end(ts->seq)

                                        // get_cpu_iowait_time_us()
                                        do {
                                            seq = read_seqcount_begin(ts->seq)
                                            if (t->idle_active) {
                                                time = now - ts->idle_entrytime
                                                time += ts->iowait_sleeptime
                                            } else {
                                                time = ts->iowait_sleeptime
                                            }
                                        } while (read_seqcount_retry(ts->seq, seq));

Right? seqcount should be enough to make sure we are getting a consistent result.
I doubt we need harder locking.

Another thing while at it. It seems that an update done from drivers/cpufreq/cpufreq_governor.c
(calling get_cpu_iowait_time_us() -> update_ts_time_stats()) can randomly race with a CPU
entering/exiting idle. I have no idea why drivers/cpufreq/cpufreq_governor.c does the update
itself. It can just compute the delta like any reader. May be we could remove that and only
ever call update_ts_time_stats() from the CPU that exit idle.

What do you think?

Thanks.

	Frederic.

> ---
>  fs/proc/stat.c |   42 ++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index e296572..9fff534 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -19,6 +19,40 @@
>  #define arch_irq_stat() 0
>  #endif
>  
> +/*
> + * CONFIG_NO_HZ=y can cause idle/iowait values to decrease.
> + * Make sure that idle/iowait values visible from /proc/stat do not decrease.
> + */
> +static inline u64 validate_iowait(u64 iowait, const int cpu)
> +{
> +#ifdef CONFIG_NO_HZ
> +	static u64 max_iowait[NR_CPUS];
> +	static DEFINE_SPINLOCK(lock);
> +	spin_lock(&lock);
> +	if (likely(iowait >= max_iowait[cpu]))
> +		max_iowait[cpu] = iowait;
> +	else
> +		iowait = max_iowait[cpu];
> +	spin_unlock(&lock);
> +#endif
> +	return iowait;
> +}
> +
> +static inline u64 validate_idle(u64 idle, const int cpu)
> +{
> +#ifdef CONFIG_NO_HZ
> +	static u64 max_idle[NR_CPUS];
> +	static DEFINE_SPINLOCK(lock);
> +	spin_lock(&lock);
> +	if (likely(idle >= max_idle[cpu]))
> +		max_idle[cpu] = idle;
> +	else
> +		idle = max_idle[cpu];
> +	spin_unlock(&lock);
> +#endif
> +	return idle;
> +}
> +
>  #ifdef arch_idle_time
>  
>  static cputime64_t get_idle_time(int cpu)
> @@ -28,7 +62,7 @@ static cputime64_t get_idle_time(int cpu)
>  	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
>  	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
>  		idle += arch_idle_time(cpu);
> -	return idle;
> +	return validate_idle(idle, cpu);
>  }
>  
>  static cputime64_t get_iowait_time(int cpu)
> @@ -38,7 +72,7 @@ static cputime64_t get_iowait_time(int cpu)
>  	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
>  	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
>  		iowait += arch_idle_time(cpu);
> -	return iowait;
> +	return validate_iowait(iowait, cpu);
>  }
>  
>  #else
> @@ -56,7 +90,7 @@ static u64 get_idle_time(int cpu)
>  	else
>  		idle = usecs_to_cputime64(idle_time);
>  
> -	return idle;
> +	return validate_idle(idle, cpu);
>  }
>  
>  static u64 get_iowait_time(int cpu)
> @@ -72,7 +106,7 @@ static u64 get_iowait_time(int cpu)
>  	else
>  		iowait = usecs_to_cputime64(iowait_time);
>  
> -	return iowait;
> +	return validate_iowait(iowait, cpu);
>  }
>  
>  #endif
> -- 
> 1.7.1
