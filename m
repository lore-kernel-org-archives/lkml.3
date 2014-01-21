Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaAUUGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:06:48 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47265 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaAUUGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:06:40 -0500
MIME-Version: 1.0
In-Reply-To: <xm26d2jlkwn1.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org> <xm26d2jlkwn1.fsf@sword-of-the-dawn.mtv.corp.google.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 21 Jan 2014 21:06:19 +0100
Message-ID: <CAKfTPtBnY_ERdPKbvFeS5V3siFCsV1DeFC=wPThUDnKJq5M_Ng@mail.gmail.com>
Subject: Re: [PATCH] sched: fix sched_entity avg statistics update
To: Benjamin Segall <bsegall@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2014 19:38,  <bsegall@google.com> wrote:
> Vincent Guittot <vincent.guittot@linaro.org> writes:
>
>> With the current implementation, the load average statistics of a sched entity
>> change according to other activity on the CPU even if this activity is done
>> between the running window of the sched entity and have no influence on the
>> running duration of the task.
>>
>> When a task wakes up on the same CPU, we currently update last_runnable_update
>> with the return  of __synchronize_entity_decay without updating the
>> runnable_avg_sum and runnable_avg_period accordingly. In fact, we have to sync
>> the load_contrib of the se with the rq's blocked_load_contrib before removing
>> it from the latter (with __synchronize_entity_decay) but we must keep
>> last_runnable_update unchanged for updating runnable_avg_sum/period during the
>> next update_entity_load_avg.
>
> ... Gah, that's correct, we had this right the first time. Could you do
> this as a full revert of 282cf499f03ec1754b6c8c945c9674b02631fb0f (ie
> remove the now inaccurate comment, or maybe replace it with a correct one).

Ok i'm going to remove comment as well and replace it with a new description

Vincent

>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index e64b079..5b0ef90 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2370,8 +2370,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>>                * would have made count negative); we must be careful to avoid
>>                * double-accounting blocked time after synchronizing decays.
>>                */
>> -             se->avg.last_runnable_update += __synchronize_entity_decay(se)
>> -                                                     << 20;
>> +             __synchronize_entity_decay(se);
>>       }
>>
>>       /* migrated tasks did not contribute to our blocked load */
