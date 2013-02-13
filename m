Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3BMHyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:54:54 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61292 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3BMHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130213061853.GA4043@brouette>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
	<20130213061853.GA4043@brouette>
Date: Wed, 13 Feb 2013 08:54:50 +0100
Message-ID: <CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Damien Wyart <damien.wyart@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Damien,

Thanks for the test and the feedback.
Could you send me the sched_domain configuration of your machine with
the kernel that boots on your machine ?
It's available in /proc/sys/kernel/sched_domain/cpu*/

This should not have any impact on your machine but it looks like it have one.

Regards,
Vincent


On 13 February 2013 07:18, Damien Wyart <damien.wyart@gmail.com> wrote:
> Hi,
>
> I tested this on top of 3.8-rc7 and this made the machine (x86_64, Core
> i7 920) unable to boot (very early as nothing at all is displayed on
> screen). Nothing in the kernel log (after booting with a working
> kernel).
>
> Double-checked by just backing out only this patch and this made the
> machine boot again.
>
> Damien
>
>> need_active_balance uses env->src_cpu which is set only if there is more
>> than 1 task on the run queue. We must set the src_cpu field unconditionnally
>> otherwise the test "env->src_cpu > env->dst_cpu" will always fail if there is
>> only 1 task on the run queue
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 81fa536..32938ea 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5044,6 +5044,10 @@ redo:
>>
>>       ld_moved = 0;
>>       lb_iterations = 1;
>> +
>> +     env.src_cpu   = busiest->cpu;
>> +     env.src_rq    = busiest;
>> +
>>       if (busiest->nr_running > 1) {
>>               /*
>>                * Attempt to move tasks. If find_busiest_group has found
>> @@ -5052,8 +5056,6 @@ redo:
>>                * correctly treated as an imbalance.
>>                */
>>               env.flags |= LBF_ALL_PINNED;
>> -             env.src_cpu   = busiest->cpu;
>> -             env.src_rq    = busiest;
>>               env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
>>
>>               update_h_load(env.src_cpu);
