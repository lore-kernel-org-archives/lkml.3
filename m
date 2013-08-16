Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3HPQJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab3HPQJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:09:09 -0400
Date: Fri, 16 Aug 2013 18:02:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130816160201.GA31682@redhat.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Frederic!

I'll try to read this series carefully later. Not that I think
I can help, you certainly understand this much better.

Just one question below,

On 08/16, Frederic Weisbecker wrote:
>
> @@ -499,12 +509,15 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>  	if (last_update_time)
>  		*last_update_time = ktime_to_us(now);
>  
> -	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> -		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> -		iowait = ktime_add(ts->iowait_sleeptime, delta);
> -	} else {
> -		iowait = ts->iowait_sleeptime;
> -	}
> +	do {
> +		seq = read_seqcount_begin(&ts->sleeptime_seq);
> +		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> +			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> +			iowait = ktime_add(ts->iowait_sleeptime, delta);
> +		} else {
> +			iowait = ts->iowait_sleeptime;
> +		}
> +	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));

Unless I missread this patch, this is still racy a bit.

Suppose it is called on CPU_0 and cpu == 1. Suppose that
ts->idle_active == T and nr_iowait_cpu(cpu) == 1.

So we return iowait_sleeptime + delta.

Suppose that we call get_cpu_iowait_time_us() again. By this time
the task which incremented ->nr_iowait can be woken up on another
CPU, and it can do atomic_dec(rq->nr_iowait). So the next time
we return iowait_sleeptime, and this is not monotonic again.

No?

Oleg.

