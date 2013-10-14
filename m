Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3JNQ65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:58:57 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36420 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3JNQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:58:56 -0400
Message-ID: <525C22CB.7000200@gmail.com>
Date: Mon, 14 Oct 2013 18:58:51 +0200
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
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-4-git-send-email-juri.lelli@gmail.com> <20131014114433.GE3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014114433.GE3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:44 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
>> +static void update_curr_dl(struct rq *rq)
>> +{
>> +	struct task_struct *curr = rq->curr;
>> +	struct sched_dl_entity *dl_se = &curr->dl;
>> +	u64 delta_exec;
>> +
>> +	if (!dl_task(curr) || !on_dl_rq(dl_se))
>> +		return;
>> +
>> +	/*
>> +	 * Consumed budget is computed considering the time as
>> +	 * observed by schedulable tasks (excluding time spent
>> +	 * in hardirq context, etc.)
>> +	 */
>> +	delta_exec = rq->clock_task - curr->se.exec_start;
> 
> Oh, cute.. So we compute deadlines from rq->clock but compute runtime
> from rq->clock_task.
> 
> So won't that give funny results in that clock_task is generally slower
> than clock; so people get more 'time'.
> 
> Maybe there's some illumination on this point further on; I'll continue
> reading.
> 

We discussed on this point in the past...

On 04/23/2012 12:31 PM, Peter Zijlstra wrote:> On Fri, 2012-04-06 at 09:14
+0200, Juri Lelli wrote:
>> +       dl_se->deadline = rq->clock + dl_se->dl_deadline;
>
> You might want to use rq->clock_task, this clock excludes times spend in
> hardirq context and steal-time (when paravirt).
>
> Then again, it might not want to use that.. but its something you might
> want to consider and make explicit by means of a comment.
>

On 04/24/2012 08:29 AM, Dario Faggioli wrote:> On Tue, 2012-04-24 at 00:25
+0100, Tommaso Cucinotta wrote:
>>> The idea is that ->clock_task gives the time as observed by schedulable
>>> tasks and excludes other muck.
>>
>> so clock_task might be better to compute the consumed budget at task
>> deschedule, but for setting deadlines one period ahead in the future
>> guess the regular wall-time rq->clock is the one to be used?
>>
> Yep, that was the idea, unless my recollection has completely gone
> flaky! :-P
>
> Perhaps adding a comment saying right this thing above, as Peter
> suggested?

And we kind of agreed on the current use of the different clocks. Do you think
we have to reason (test) more about this? Or do we live with that and see if
something strange happens? (I actually didn't see anything suspiciuos in my
use of the patchset).

Thanks,

- Juri
