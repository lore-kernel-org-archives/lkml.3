Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3HMEpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:45:15 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40340 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3HMEpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130812144309.GK27162@twins.programming.kicks-ass.net>
References: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
	<20130812144309.GK27162@twins.programming.kicks-ass.net>
Date: Tue, 13 Aug 2013 12:45:12 +0800
Message-ID: <CALZhoSRyfE78GbiJqVRvUrbJRq_NhSqYbK8vnxNP8kS9xz9qVQ@mail.gmail.com>
Subject: Re: false nr_running check in load balance?
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Mon, Aug 12, 2013 at 10:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 06, 2013 at 09:23:46PM +0800, Lei Wen wrote:
>> Hi Paul,
>>
>> I notice in load_balance function, it would check busiest->nr_running
>> to decide whether to perform the real task movement.
>>
>> But in some case, I saw the nr_running is not matching with
>> the task in the queue, which seems make scheduler to do many redundant
>> checking.
>> What I means is like there is only one task in the queue, but nr_running
>> shows it has two. So if that task cannot be moved, it would be still checked
>> for twice.
>>
>> With further checking, I find there is one patch you submit before:
>> commit 953bfcd10e6f3697233e8e5128c611d275da39c1
>> Author: Paul Turner <pjt@google.com>
>> Date:   Thu Jul 21 09:43:27 2011 -0700
>>
>>     sched: Implement hierarchical task accounting for SCHED_OTHER
>>
>> In this patch, you increase nr_running when enqueue enqueue_task_stop,
>> which is the reason nr_running is increase while task not be increased.
>> It is true at that time, the stopper has been waken up and enqueue again
>> into cpu, and do the migration job. So the logic should be right there.
>>
>> My question is whether we could change the judgment into cfs_rq->nr_running?
>> Since the load_balance is only for cfs, right?
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index bb456f4..ffc0d35 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5096,7 +5096,7 @@ redo:
>>         schedstat_add(sd, lb_imbalance[idle], env.imbalance);
>>
>>         ld_moved = 0;
>> -       if (busiest->nr_running > 1) {
>> +       if (busiest->cfs.nr_running > 1) {
>>                 /*
>>                  * Attempt to move tasks. If find_busiest_group has found
>>                  * an imbalance but busiest->nr_running <= 1, the group is
>>
>
> Not quite right; I think you need busiest->cfs.h_nr_running.
> cfs.nr_running is the number of entries running in this 'group'. If
> you've got nested groups like:
>
>  'root'
>    \
>    'A'
>    / \
>   t1 t2
>
> root.nr_running := 1 'A', even though you've got multiple running tasks.
>

You're absolutely right for this. :)
I miss it for not considering the group case...

Then do you think it is necessary to do below change in load_balance() code?
 -       if (busiest->nr_running > 1) {
 +       if (busiest->cfs.h_nr_running > 1) {


Thanks,
Lei
