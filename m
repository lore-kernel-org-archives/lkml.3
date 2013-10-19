Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3JSPfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:35:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3JSPfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:35:53 -0400
Date: Sat, 19 Oct 2013 17:35:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131019153535.GA2490@laptop.programming.kicks-ass.net>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
 <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 05:17:20PM +0200, Frederic Weisbecker wrote:
> +u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> +{
> +	ktime_t iowait, delta = { .tv64 = 0 };
> +	struct rq *rq = cpu_rq(cpu);
> +	ktime_t now = ktime_get();
> +	unsigned int seq;
> +
> +	do {
> +		seq = read_seqbegin(&rq->iowait_lock);
> +		if (rq->nr_iowait)
> +			delta = ktime_sub(now, rq->iowait_start);
> +		iowait = ktime_add(rq->iowait_time, delta);
> +	} while (read_seqretry(&rq->iowait_lock, seq));
> +
> +	if (last_update_time)
> +		*last_update_time = ktime_to_us(now);
> +
> +	return ktime_to_us(iowait);
> +}
> +EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
> +
> +static void cpu_iowait_start(struct rq *rq)
> +{
> +	write_seqlock(&rq->iowait_lock);
> +	if (!rq->nr_iowait++)
> +		rq->iowait_start = ktime_get();
> +	write_sequnlock(&rq->iowait_lock);
> +}
> +
> +static void cpu_iowait_end(struct rq *rq)
> +{
> +	ktime_t delta;
> +	write_seqlock(&rq->iowait_lock);
> +	if (!--rq->nr_iowait) {
> +		delta = ktime_sub(ktime_get(), rq->iowait_start);
> +		rq->iowait_time = ktime_add(rq->iowait_time, delta);
> +	}
> +	write_sequnlock(&rq->iowait_lock);
> +}

Yeah, so using ktime_get() for this is completely insane ;-)

I just had a look at delayacct; wth wrote that crap; that too uses
gtod.

