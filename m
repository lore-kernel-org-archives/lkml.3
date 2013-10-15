Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab3JOJgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:36:24 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48331 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab3JOJgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:36:23 -0400
Message-ID: <525D0C91.1090700@gmail.com>
Date: Tue, 15 Oct 2013 11:36:17 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 04/14] sched: SCHED_DEADLINE SMP-related data structures
 & logic.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-5-git-send-email-juri.lelli@gmail.com> <20131014120306.GH3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014120306.GH3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 02:03 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:36PM +0200, Juri Lelli wrote:
>> +static inline void dl_set_overload(struct rq *rq)
>> +{
>> +	if (!rq->online)
>> +		return;
>> +
>> +	cpumask_set_cpu(rq->cpu, rq->rd->dlo_mask);
>> +	/*
>> +	 * Must be visible before the overload count is
>> +	 * set (as in sched_rt.c).
>> +	 */
>> +	wmb();
>> +	atomic_inc(&rq->rd->dlo_count);
>> +}
> 
> Please, make that smp_wmb() and modify the comment to point to the
> matching barrier ; I couldn't find one! Which suggests something is
> amiss.
> 
> Ideally we'd have something like smp_wmb__after_set_bit() but alas.
> 

The only user of this function is pull_dl_task (that tries to pull only if at
least one runqueue of the root_domain is overloaded). Surely makes sense to
ensure that changes in the dlo_mask have to be visible before we check if we
should look at that mask. Am I right if I say that the matching barrier is
constituted by the spin_lock on this_rq acquired by schedule() before calling
pre_schedule()?

Same thing in rt_set_overload(), do we need to modify the comment also there?

Thanks,

- Juri
