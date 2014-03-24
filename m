Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaCXHp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:45:56 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49226 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaCXHpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <532FA20E.7090709@jp.fujitsu.com>
References: <532FA0E8.4050106@jp.fujitsu.com>
	<532FA20E.7090709@jp.fujitsu.com>
Date: Mon, 24 Mar 2014 13:15:54 +0530
Message-ID: <CAM4v1pPPmiHXNQ19My1Jd8XUQQh+VnbvWwGXq0mVGk4G1vYNfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, preeti@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hidetoshi,

The patch looks good to me except the comments around the monotonicity
of the return value of the idle stats observer. I am unable to relate them
to the dependency on nr_iowait_cpu.

I see that when the reader queries for the idle stats and calls
get_cpu_idle_time_us(), the nr_iowait_cpu might be 0. When he later
queries get_cpu_iowait_time_us(), it may be >0 . Hence we will be
accounting for the idle time in both idle time and iowait time. This
is definitely a problem. But I do not understand what this has got to
do with the monotonicity of the time
returned. This is just for my understanding.

Thanks!

Regards
Preeti U Murthy
On 3/24/14, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

<snip>
> + * Known bug: Return value is not monotonic in case if @last_update_time
> + * is NULL and therefore update is not performed. Because it includes
> + * cputime which is not determined idle or iowait so not accounted yet.
> + *
>   * This function returns -1 if NOHZ is not enabled.
>   */
>  u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
> @@ -467,16 +489,28 @@ u64 get_cpu_idle_time_us(int cpu, u64
> *last_update_time)
>
>  	now = ktime_get();
>  	if (last_update_time) {
> -		update_ts_time_stats(cpu, ts, now, last_update_time);
> -		idle = ts->idle_sleeptime;
> +		update_ts_time_stats(cpu, ts, now, &idle, NULL, 0);
> +		*last_update_time = ktime_to_us(now);
>  	} else {
> -		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> -			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> +		unsigned int seq;
>
> -			idle = ktime_add(ts->idle_sleeptime, delta);
> -		} else {
> +		do {
> +			seq = read_seqbegin(&ts->idle_sleeptime_seq);
>  			idle = ts->idle_sleeptime;
> -		}
> +			/*
> +			 * FIXME: At this point, delta is determined neither
> +			 * idle nor iowait. This function temporarily treat
> +			 * this delta depending on the value of nr_iowait
> +			 * when this function reaches here. It will result
> +			 * in non-monotonic return value. So user of this
> +			 * function must not expect monotonicity here.
> +			 */
> +			if (ts->idle_active && !nr_iowait_cpu(cpu)
> +			    && (ktime_compare(now, ts->idle_entrytime) > 0)) {
> +				ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> +				idle = ktime_add(ts->idle_sleeptime, delta);
> +			}
> +		} while (read_seqretry(&ts->idle_sleeptime_seq, seq));
>  	}
>
>  	return ktime_to_us(idle);
> @@ -496,6 +530,10 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
>   * This time is measured via accounting rather than sampling,
>   * and is as accurate as ktime_get() is.
>   *
> + * Known bug: Return value is not monotonic in case if @last_update_time
> + * is NULL and therefore update is not performed. Because it includes
> + * cputime which is not determined idle or iowait so not accounted yet.
> + *
>   * This function returns -1 if NOHZ is not enabled.
>   */
>  u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> @@ -508,16 +546,28 @@ u64 get_cpu_iowait_time_us(int cpu, u64
> *last_update_time)
>
>  	now = ktime_get();
>  	if (last_update_time) {
> -		update_ts_time_stats(cpu, ts, now, last_update_time);
> -		iowait = ts->iowait_sleeptime;
> +		update_ts_time_stats(cpu, ts, now, NULL, &iowait, 0);
> +		*last_update_time = ktime_to_us(now);
>  	} else {
> -		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> -			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> +		unsigned int seq;
>
> -			iowait = ktime_add(ts->iowait_sleeptime, delta);
> -		} else {
> +		do {
> +			seq = read_seqbegin(&ts->idle_sleeptime_seq);
>  			iowait = ts->iowait_sleeptime;
> -		}
> +			/*
> +			 * FIXME: At this point, delta is determined neither
> +			 * idle nor iowait. This function temporarily treat
> +			 * this delta depending on the value of nr_iowait
> +			 * when this function reaches here. It will result
> +			 * in non-monotonic return value. So user of this
> +			 * function must not expect monotonicity here.
> +			 */
> +			if (ts->idle_active && nr_iowait_cpu(cpu) > 0
> +			    && (ktime_compare(now, ts->idle_entrytime) > 0)) {
> +				ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> +				iowait = ktime_add(ts->iowait_sleeptime, delta);
> +			}
> +		} while (read_seqretry(&ts->idle_sleeptime_seq, seq));
>  	}
>
>  	return ktime_to_us(iowait);
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
