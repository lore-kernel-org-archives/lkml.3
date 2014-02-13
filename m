Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaBMKSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:18:02 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34660 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBMKR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:17:59 -0500
Message-ID: <52FC9AFA.2010504@linux.vnet.ibm.com>
Date: Thu, 13 Feb 2014 15:44:18 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        alex.shi@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH V2 3/3] sched: Move idle_stamp up to the core
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org> <1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pPPOE9xrH3AKc6sHAThPq43Ws_L_KuicRa5Ktr5nMBmtQ@mail.gmail.com> <52FA1270.9020806@linaro.org>
In-Reply-To: <52FA1270.9020806@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021310-4790-0000-0000-00000CB5D854
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 02/11/2014 05:37 PM, Daniel Lezcano wrote:
> On 02/10/2014 11:04 AM, Preeti Murthy wrote:
>> Hi Daniel,
>>
>> On Fri, Feb 7, 2014 at 4:40 AM, Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>> The idle_balance modifies the idle_stamp field of the rq, making this
>>> information to be shared across core.c and fair.c. As we can know if the
>>> cpu is going to idle or not with the previous patch, let's
>>> encapsulate the
>>> idle_stamp information in core.c by moving it up to the caller. The
>>> idle_balance function returns true in case a balancing occured and
>>> the cpu
>>> won't be idle, false if no balance happened and the cpu is going idle.
>>>
>>> Cc: mingo@kernel.org
>>> Cc: alex.shi@linaro.org
>>> Cc: peterz@infradead.org
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>>> ---
>>>   kernel/sched/core.c  |   13 +++++++++++--
>>>   kernel/sched/fair.c  |   14 ++++++--------
>>>   kernel/sched/sched.h |    8 +-------
>>>   3 files changed, 18 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 16b97dd..428ee4c 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -2704,8 +2704,17 @@ need_resched:
>>>
>>>          pre_schedule(rq, prev);
>>>
>>> -       if (unlikely(!rq->nr_running))
>>> -               idle_balance(rq);
>>> +#ifdef CONFIG_SMP
>>> +       if (unlikely(!rq->nr_running)) {
>>> +               /*
>>> +                * We must set idle_stamp _before_ calling
>>> idle_balance(), such
>>> +                * that we measure the duration of idle_balance() as
>>> idle time.
>>
>> Should not this be "such that we *do not* measure the duration of
>> idle_balance()
>> as idle time?"
> 
> Actually, the initial code was including the idle balance time
> processing in the idle stamp. When I moved the idle stamp in core.c,
> idle balance was no longer measured (an unwanted change). That has been
> fixed and to prevent that to occur again, we added a comment.

Oh sorry! Yes you are right.

Thanks

Regards
Preeti U Murthy
> 

