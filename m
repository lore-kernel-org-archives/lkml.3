Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3HPQhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:37:15 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59075 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3HPQhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130816163217.GF24210@somewhere>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
	<1376667753-29014-3-git-send-email-fweisbec@gmail.com>
	<20130816160201.GA31682@redhat.com>
	<20130816163217.GF24210@somewhere>
Date: Fri, 16 Aug 2013 18:37:10 +0200
Message-ID: <CAFTL4hyPisoLN_K2uS4xmq_vQjQBc2Smd6896zYTNGA37ujVFw@mail.gmail.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/16 Frederic Weisbecker <fweisbec@gmail.com>:
> On Fri, Aug 16, 2013 at 06:02:01PM +0200, Oleg Nesterov wrote:
>> Thanks Frederic!
>>
>> I'll try to read this series carefully later. Not that I think
>> I can help, you certainly understand this much better.
>>
>> Just one question below,
>>
>> On 08/16, Frederic Weisbecker wrote:
>> >
>> > @@ -499,12 +509,15 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>> >     if (last_update_time)
>> >             *last_update_time = ktime_to_us(now);
>> >
>> > -   if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
>> > -           ktime_t delta = ktime_sub(now, ts->idle_entrytime);
>> > -           iowait = ktime_add(ts->iowait_sleeptime, delta);
>> > -   } else {
>> > -           iowait = ts->iowait_sleeptime;
>> > -   }
>> > +   do {
>> > +           seq = read_seqcount_begin(&ts->sleeptime_seq);
>> > +           if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
>> > +                   ktime_t delta = ktime_sub(now, ts->idle_entrytime);
>> > +                   iowait = ktime_add(ts->iowait_sleeptime, delta);
>> > +           } else {
>> > +                   iowait = ts->iowait_sleeptime;
>> > +           }
>> > +   } while (read_seqcount_retry(&ts->sleeptime_seq, seq));
>>
>> Unless I missread this patch, this is still racy a bit.
>>
>> Suppose it is called on CPU_0 and cpu == 1. Suppose that
>> ts->idle_active == T and nr_iowait_cpu(cpu) == 1.
>>
>> So we return iowait_sleeptime + delta.
>>
>> Suppose that we call get_cpu_iowait_time_us() again. By this time
>> the task which incremented ->nr_iowait can be woken up on another
>> CPU, and it can do atomic_dec(rq->nr_iowait). So the next time
>> we return iowait_sleeptime, and this is not monotonic again.
>>
>> No?
>
> OTOH, io_schedule() does:
>
>       atomic_inc(&rq->nr_iowait);
>       schedule();
>       atomic_dec(&rq->nr_iowait);
>
> How do we handle that when the task is migrated after it goes to sleep? I don't
> see the nr_iowait is decreased from the src CPU and increased on the dest CPU.
>
> I don't either see that iowait tasks can't be migrated.

My bad, The decrement happens on the src CPU anyway.
