Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaEPN5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:57:35 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42899 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbaEPN5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140516080424.GM11096@twins.programming.kicks-ass.net>
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
	<20140516080424.GM11096@twins.programming.kicks-ass.net>
Date: Fri, 16 May 2014 19:27:32 +0530
Message-ID: <CAM4v1pPNfpB+DumFHhi2UZS97zgfBFHEwQYsmQ5E1c2gZFbBww@mail.gmail.com>
Subject: Re: [PATCH] sched: fix exec_start/task_hot on migrated tasks
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 16, 2014 at 1:34 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, May 15, 2014 at 03:59:20PM -0700, Ben Segall wrote:
>> task_hot checks exec_start on any runnable task, but if it has been
>> migrated since the it last ran, then exec_start is a clock_task from
>> another cpu. If the old cpu's clock_task was sufficiently far ahead of
>> this cpu's then the task will not be considered for another migration
>> until it has run. Instead reset exec_start whenever a task is migrated,
>> since it is presumably no longer hot anyway.
>>
>> Signed-off-by: Ben Segall <bsegall@google.com>
>> ---
>>  kernel/sched/fair.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 28ccf50..9f8dfeb 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>>               atomic_long_add(se->avg.load_avg_contrib,
>>                                               &cfs_rq->removed_load);
>>       }
>> +
>> +     /* We have migrated, no longer consider this task hot */
>> +     se.exec_start = 0;
>>  }
>
> 0 isn't strictly the right thing to do here, since the clock can wrap,
> but being wrong every ~585 years isn't too big an issue for this.

I don't understand this. Will setting it to 0 not indicate beginning
of ticking? So when you find out for how long the task has run, the
difference would be larger than what would have been had you
let exec_start be at its previous value of the old cpu's clock_task right?

Will not setting exec_start to the clock_task of the destination rq
during migration be better? This would be the closest we could
come to estimating the amount of time the task has run on this new
cpu while deciding task_hot or not no?

Regards
Preeti U Murthy

>
> Thanks!
