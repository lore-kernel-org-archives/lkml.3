Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaBKMHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:07:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43854 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaBKMHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:07:15 -0500
Message-ID: <52FA1270.9020806@linaro.org>
Date: Tue, 11 Feb 2014 13:07:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        alex.shi@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 3/3] sched: Move idle_stamp up to the core
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>	<1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pPPOE9xrH3AKc6sHAThPq43Ws_L_KuicRa5Ktr5nMBmtQ@mail.gmail.com>
In-Reply-To: <CAM4v1pPPOE9xrH3AKc6sHAThPq43Ws_L_KuicRa5Ktr5nMBmtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 11:04 AM, Preeti Murthy wrote:
> Hi Daniel,
>
> On Fri, Feb 7, 2014 at 4:40 AM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> The idle_balance modifies the idle_stamp field of the rq, making this
>> information to be shared across core.c and fair.c. As we can know if the
>> cpu is going to idle or not with the previous patch, let's encapsulate the
>> idle_stamp information in core.c by moving it up to the caller. The
>> idle_balance function returns true in case a balancing occured and the cpu
>> won't be idle, false if no balance happened and the cpu is going idle.
>>
>> Cc: mingo@kernel.org
>> Cc: alex.shi@linaro.org
>> Cc: peterz@infradead.org
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> ---
>>   kernel/sched/core.c  |   13 +++++++++++--
>>   kernel/sched/fair.c  |   14 ++++++--------
>>   kernel/sched/sched.h |    8 +-------
>>   3 files changed, 18 insertions(+), 17 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 16b97dd..428ee4c 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2704,8 +2704,17 @@ need_resched:
>>
>>          pre_schedule(rq, prev);
>>
>> -       if (unlikely(!rq->nr_running))
>> -               idle_balance(rq);
>> +#ifdef CONFIG_SMP
>> +       if (unlikely(!rq->nr_running)) {
>> +               /*
>> +                * We must set idle_stamp _before_ calling idle_balance(), such
>> +                * that we measure the duration of idle_balance() as idle time.
>
> Should not this be "such that we *do not* measure the duration of idle_balance()
> as idle time?"

Actually, the initial code was including the idle balance time 
processing in the idle stamp. When I moved the idle stamp in core.c, 
idle balance was no longer measured (an unwanted change). That has been 
fixed and to prevent that to occur again, we added a comment.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

