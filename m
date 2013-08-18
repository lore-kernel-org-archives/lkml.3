Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3HRRKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 13:10:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab3HRRKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 13:10:38 -0400
Date: Sun, 18 Aug 2013 19:04:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stratos Karafotis <stratosk@semaphore.gr>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/4] nohz: Only update sleeptime stats locally
Message-ID: <20130818170408.GA22417@redhat.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376667753-29014-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for double post. forgot to cc cpufreq maintainers.

On 08/16, Frederic Weisbecker wrote:
>
> To fix this, lets only update the sleeptime stats locally when the CPU
> exits from idle.

I am in no position to ack the changes in this area, but I like this
change very much. Because, as a code reader, I was totally confused by

	if (last_update_time)
		update_ts_time_stats()

code and it looks "obviously wrong".

I added more cc's. It seems to me that 9366d840 "cpufreq: governors:
Calculate iowait time only when necessary" doesn't realize what

	-       u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
	+       u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);

actually means. OTOH, get_cpu_iowait_time_us() was called with
last_update_time != NULL even before this patch...

In short. This looks like the clear fix to me, but I do not understand
this code enough, and I think that cpufreq should know about this change.

>  static void tick_nohz_stop_idle(int cpu, ktime_t now)
>  {
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +	ktime_t delta;
>  
> -	update_ts_time_stats(cpu, ts, now, NULL);
> +	/* Updates the per cpu time idle statistics counters */
> +	delta = ktime_sub(now, ts->idle_entrytime);
> +	if (nr_iowait_cpu(cpu) > 0)
> +		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
> +	else
> +		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> +	ts->idle_entrytime = now;
>  	ts->idle_active = 0;

With or without this change, why we update ->idle_entrytime in this case?
Looks harmless, but a bit confusing.

While this doesn't really matter, we could probably even kill ->idle_active
and use !!ts->idle_entrytime instead.

> @@ -473,17 +458,14 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)

And I think that we should kill this last_update_time argument later.

Oleg.

