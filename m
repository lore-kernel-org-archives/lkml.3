Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaDYS5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbaDYS5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:57:03 -0400
Message-ID: <535AAFD6.9050900@redhat.com>
Date: Fri, 25 Apr 2014 20:56:22 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] nohz: Fix iowait overcounting if iowait task migrates
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com> <1398365158-12568-4-git-send-email-dvlasenk@redhat.com> <20140424191856.GD26782@laptop.programming.kicks-ass.net>
In-Reply-To: <20140424191856.GD26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 09:18 PM, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 08:45:58PM +0200, Denys Vlasenko wrote:
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 268a45e..ffea757 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4218,7 +4218,14 @@ void __sched io_schedule(void)
>>  	current->in_iowait = 1;
>>  	schedule();
>>  	current->in_iowait = 0;
>> +#ifdef CONFIG_NO_HZ_COMMON
>> +	if (atomic_dec_and_test(&rq->nr_iowait)) {
>> +		if (raw_smp_processor_id() != cpu_of(rq))
>> +			tick_nohz_iowait_to_idle(cpu_of(rq));
>> +	}
>> +#else
>>  	atomic_dec(&rq->nr_iowait);
>> +#endif
>>  	delayacct_blkio_end();
>>  }
> 
> You're really refusing to collapse that stuff eh?

I'm sending two patches on top of my last patch set
which tidies up a few such aspects (another one
is where we fetch a percpu variable before knowing
that we'll need it, potentially wasting a few cycles).


>> +void tick_nohz_iowait_to_idle(int cpu)
>> +{
>> +	struct tick_sched *ts = tick_get_tick_sched(cpu);
>> +	ktime_t now = ktime_get();
>> +
>> +	write_seqcount_begin(&ts->idle_sleeptime_seq);
>> +	ts->iowait_exittime = now;
>> +	write_seqcount_end(&ts->idle_sleeptime_seq);
>> +}
>
>
> So what again was wrong with this one?
>
>   http://marc.info/?l=linux-kernel&m=139772917211023

That code has no provision to record when last iowait task
left the rq.

Therefore it can undercount iowait - it's very similar
to the problem I had before patch #4 in my patch series.

My patches 1-3 can overcount iowait because they consider
the entire idle period "iowait" if nr_iowait_cpu() != 0
at the *beginning*.

Hidetoshi's patches consider the entire idle period "iowait"
if nr_iowait_cpu() != 0 at the *end*.

He needs to code carefully so that this delayed decision
doesn't make reader functions return wrong results.

However, if nr_iowait_cpu() was 0 at the end it does not mean
that most of this time period it was also 0. It could have been
mostly !0 - and in this case iowait will be undercounted.

I personally thought that both over- or undercounting iowait
might be acceptable.

If not, then *some* form of recording and accounting
for exact moment when last iowait task left the rq is necessary.
That's what I did in patch #4.

-- 
vda

