Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3HTHBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:01:42 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:44133 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3HTHBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:01:41 -0400
Message-ID: <52130AD7.1020000@lab.ntt.co.jp>
Date: Tue, 20 Aug 2013 15:21:11 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere>
In-Reply-To: <20130816164626.GH24210@somewhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013年08月17日 01:46), Frederic Weisbecker wrote:
> On Fri, Aug 16, 2013 at 06:26:54PM +0200, Oleg Nesterov wrote:
>> On 08/16, Frederic Weisbecker wrote:
>>> On Fri, Aug 16, 2013 at 06:02:01PM +0200, Oleg Nesterov wrote:
>>>>> +	do {
>>>>> +		seq = read_seqcount_begin(&ts->sleeptime_seq);
>>>>> +		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
>>>>> +			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
>>>>> +			iowait = ktime_add(ts->iowait_sleeptime, delta);
>>>>> +		} else {
>>>>> +			iowait = ts->iowait_sleeptime;
>>>>> +		}
>>>>> +	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
>>>> Unless I missread this patch, this is still racy a bit.
>>>>
>>>> Suppose it is called on CPU_0 and cpu == 1. Suppose that
>>>> ts->idle_active == T and nr_iowait_cpu(cpu) == 1.
>>>>
>>>> So we return iowait_sleeptime + delta.
>>>>
>>>> Suppose that we call get_cpu_iowait_time_us() again. By this time
>>>> the task which incremented ->nr_iowait can be woken up on another
>>>> CPU, and it can do atomic_dec(rq->nr_iowait). So the next time
>>>> we return iowait_sleeptime, and this is not monotonic again.
>>> Hmm, by the time it decrements nr_iowait, it returned from schedule() and
>>> so idle had flushed the pending iowait sleeptime.
>> Suppose a task does io_schedule() on CPU_0, and increments the counter.
>> This CPU becomes idle and nr_iowait_cpu(0) == 1.
>>
>> Then this task is woken up, but try_to_wake_up() selects another CPU != 0.
>>
>> It returns from schedule() and decrements the same counter, it doesn't
>> do raw_rq/etc again. nr_iowait_cpu(0) becomes 0.
>>
>> In fact the task can even migrate to another CPU right after raw_rq().
> Ah I see now. So that indeed yet another race.

I am sorry for chiming in late.

That precisely the race I described here:

https://lkml.org/lkml/2013/7/2/3

I should have been more concise in my explanation. I apologize.

> Should we flush that iowait to the src CPU? But then it means we must handle
> concurrent updates to iowait_sleeptime, idle_sleeptime from the migration
> code and from idle enter / exit.
>
> So I fear we need a seqlock.
>
> Or we can live with that and still account the whole idle time slept until
> tick_nohz_stop_idle() to iowait if we called tick_nohz_start_idle() with nr_iowait > 0.
> All we need is just a new field in ts-> that records on which state we entered
> idle.

Another approach could be to shadow ->iowait_sleeptime as
suggested here: https://lkml.org/lkml/2013/7/2/165
