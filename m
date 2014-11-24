Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaKXOEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:04:45 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54918 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaKXOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:04:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141121123509.GC23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-3-git-send-email-vincent.guittot@linaro.org> <20141121123509.GC23177@e105550-lin.cambridge.arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 24 Nov 2014 15:04:21 +0100
Message-ID: <CAKfTPtBZWDSWVYQ9VE8=rsnsb2kLyUAsc5d_bvcypXE2JgarYQ@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] sched: Track group sched_entity usage contributions
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 at 13:35, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> s/usage/utilization/ in subject.
>
> On Mon, Nov 03, 2014 at 04:54:39PM +0000, Vincent Guittot wrote:
>> From: Morten Rasmussen <morten.rasmussen@arm.com>
>>
>> Adds usage contribution tracking for group entities. Unlike
>
> s/usage contribution/utilization/
>
>> se->avg.load_avg_contrib, se->avg.utilization_avg_contrib for group
>> entities is the sum of se->avg.utilization_avg_contrib for all entities on the
>> group runqueue. It is _not_ influenced in any way by the task group
>> h_load. Hence it is representing the actual cpu usage of the group, not
>
> s/usage/utilization/
>
>> its intended load contribution which may differ significantly from the
>> utilization on lightly utilized systems.
>>
>> cc: Paul Turner <pjt@google.com>
>> cc: Ben Segall <bsegall@google.com>
>>
>> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/debug.c | 2 ++
>>  kernel/sched/fair.c  | 3 +++
>>  2 files changed, 5 insertions(+)
>>
>> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
>> index f384452..efb47ed 100644
>> --- a/kernel/sched/debug.c
>> +++ b/kernel/sched/debug.c
>> @@ -94,8 +94,10 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>>       P(se->load.weight);
>>  #ifdef CONFIG_SMP
>>       P(se->avg.runnable_avg_sum);
>> +     P(se->avg.running_avg_sum);
>>       P(se->avg.avg_period);
>>       P(se->avg.load_avg_contrib);
>> +     P(se->avg.utilization_avg_contrib);
>>       P(se->avg.decay_count);
>>  #endif
>>  #undef PN
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 3a91ae6..a171e1b 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2529,6 +2529,9 @@ static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
>>
>>       if (entity_is_task(se))
>>               __update_task_entity_utilization(se);
>> +     else
>> +             se->avg.utilization_avg_contrib =
>> +                                     group_cfs_rq(se)->utilization_load_avg;
>>
>>       return se->avg.utilization_avg_contrib - old_contrib;
>>  }
>
> What happened to the update of se->avg.utilization_avg_contrib in
> __synchronize_entity_decay()? It seems to have disapperead after v7.

It was moved in patch 1 where it is is right place
