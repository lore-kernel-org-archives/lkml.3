Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEESO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:14:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaEESO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:14:56 -0400
Message-ID: <5367D4FB.9010407@redhat.com>
Date: Mon, 05 May 2014 20:14:19 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] nohz: Fix iowait overcounting if iowait task migrates
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com> <1398365158-12568-4-git-send-email-dvlasenk@redhat.com> <20140429161959.GD6129@localhost.localdomain>
In-Reply-To: <20140429161959.GD6129@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:20 PM, Frederic Weisbecker wrote:
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
> 
> Note that even using seqlock doesn't alone help to fix the preemption issue
> when the above may overwrite the exittime of the next last iowait task from
> the old rq.

Meaning: between atomic_dec_and_test(&rq->nr_iowait) going to zero
and tick_nohz_iowait_to_idle(), CPU left idle, acquired a new task,
this task submitted IO, IO completed, this second task also reached
this place, its atomic_dec_and_test(&rq->nr_iowait) went to zero
and now we race doing

	ts->iowait_exittime = now;

from two tasks?

This shouldn't be a problem anyway since the value of "now"
in this situation will be nearly the same - provided that
(a) store is atomic (no corruption due to the race) and
(b) we are careful when we are using it (for example, we
clamp it to be not earlier than idle start time).

Do you see a problem here which I miss?

