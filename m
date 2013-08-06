Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3HFFKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:10:04 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:50495 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3HFFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <87d2prqvse.fsf@rustcorp.com.au>
References: <1374910011-72985-1-git-send-email-xtfeng@gmail.com>
	<CAJn8CcF4E6JiRrU6gaawQSnzR9GsQaOy+1yo=+dFmSoy=hSodQ@mail.gmail.com>
	<87d2prqvse.fsf@rustcorp.com.au>
Date: Tue, 6 Aug 2013 13:10:00 +0800
Message-ID: <CAJn8CcFfXqT3dfKauNN_Jsq7uF3YyhzcBr91Dsd83xVtGObcDA@mail.gmail.com>
Subject: Re: [PATCH] cpumask: fix cpumask leak in partition_sched_domains
From: Xiaotian Feng <xtfeng@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 12:37 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Xiaotian Feng <xtfeng@gmail.com> writes:
>> On Sat, Jul 27, 2013 at 3:26 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>>> If doms_new is NULL, partition_sched_domains() will reset ndoms_cur
>>> to 0, and free old sched domains with free_sched_domains(doms_cur, ndoms_cur).
>>> As ndoms_cur is 0, the cpumask will not be freed.
>>>
>>> Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: linux-kernel@vger.kernel.org
>>
>> Any comments? Cc'ed Rusty.
>
> The code is a little convoluted, but your fix is logical.
>

Yes, it's quite convoluted :(

>>> ---
>>>  kernel/sched/core.c |    5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index b7c32cb..3d6c57b 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -6184,8 +6184,9 @@ match1:
>>>                 ;
>>>         }
>>>
>>> +       n= ndoms_cur;
>
> You're missing a ' ' here:
>         n = ndoms_cur;
>

I'll update this, thanks :)

>>>         if (doms_new == NULL) {
>>> -               ndoms_cur = 0;
>>> +               n = 0;
>>>                 doms_new = &fallback_doms;
>>>                 cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
>>>                 WARN_ON_ONCE(dattr_new);
>>> @@ -6193,7 +6194,7 @@ match1:
>>>
>>>         /* Build new domains */
>>>         for (i = 0; i < ndoms_new; i++) {
>>> -               for (j = 0; j < ndoms_cur && !new_topology; j++) {
>>> +               for (j = 0; j < n && !new_topology; j++) {
>>>                         if (cpumask_equal(doms_new[i], doms_cur[j])
>>>                             && dattrs_equal(dattr_new, i, dattr_cur, j))
>>>                                 goto match2;
>>> --
>>> 1.7.9.6 (Apple Git-31.1)
>>>
>
> Cheers,
> Rusty.
