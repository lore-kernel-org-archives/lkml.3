Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbaIOWde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:33:34 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:63442 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbaIOWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140915191541.GA28083@e103687>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org> <20140915191541.GA28083@e103687>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 15 Sep 2014 15:33:09 -0700
Message-ID: <CAKfTPtCj-PzeKb2yMWT64oYe-EoR8rdeAyyJerYOuSgVgzJS5A@mail.gmail.com>
Subject: Re: [PATCH v5 09/12] sched: add usage_load_avg
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 September 2014 21:15, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Tue, Aug 26, 2014 at 12:06:52PM +0100, Vincent Guittot wrote:
>> Add new statistics which reflect the average time a task is running on the
>> CPU and the sum of the tasks' running on a runqueue. The latter is named
>> usage_avg_contrib.
>>
>> This patch is based on the usage metric that was proposed in the 1st
>> versions of the per-entity load tracking patchset but that has be removed
>> afterward. This version differs from the original one in the sense that it's
>> not linked to task_group.
>>
>> The rq's usage_avg_contrib will be used to check if a rq is overloaded or not
>> instead of trying to compute how many task a group of CPUs can handle
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> I should have read this patch before I did almost the same patch for as
> part a series to introduce scale-invariance which I am about to post :(
>
> The only difference I see is slightly different naming and that, AFAICT,
> task group usage is not accounted for in this patch. Can we add the
> support for task groups as well? I can provide a patch based on this one
> if you want.
>
> Also, since more than half this patch comes directly from PJT's original
> patch I would add "by Paul Turner <pjt@google.com>" somewhere in the
> text above.

Sorry, It was obvious for me that per-entity load tracking patchset
were done by pjt but i can surely replace
"the per-entity load tracking patchset" by "the per-entity load
tracking patchset by Paul Turner <pjt@google.com>"

>
> [...]
>
>> +static inline void __update_task_entity_usage(struct sched_entity *se)
>> +{
>> +     u32 contrib;
>> +
>> +     /* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
>> +     contrib = se->avg.running_avg_sum * scale_load_down(SCHED_LOAD_SCALE);
>> +     contrib /= (se->avg.runnable_avg_period + 1);
>> +     se->avg.usage_avg_contrib = scale_load(contrib);
>> +}
>> +
>> +static long __update_entity_usage_avg_contrib(struct sched_entity *se)
>> +{
>> +     long old_contrib = se->avg.usage_avg_contrib;
>> +
>> +     if (entity_is_task(se))
>> +             __update_task_entity_usage(se);
>
> Groups are never updated?
>
> As said above. I have code that does it.

Yes, feel free to send a patch above this one that add group

Vincent
>
> Morten
>
>> +
>> +     return se->avg.usage_avg_contrib - old_contrib;
>> +}
>> +
>
