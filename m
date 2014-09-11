Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaIKLVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:21:15 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37981 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaIKLVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140911100721.GT3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org> <20140911100721.GT3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 11 Sep 2014 13:20:54 +0200
Message-ID: <CAKfTPtDtw2kE9DtGB-ZHa=0+oWY+1-753eoRFDs=mz0qFuiwiQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 12:07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 26, 2014 at 01:06:51PM +0200, Vincent Guittot wrote:
>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 18db43e..60ae1ce 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -6049,6 +6049,14 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>>                       return true;
>>       }
>>
>> +     /*
>> +      * The group capacity is reduced probably because of activity from other
>> +      * sched class or interrupts which use part of the available capacity
>> +      */
>> +     if ((sg->sgc->capacity_orig * 100) > (sgs->group_capacity *
>> +                             env->sd->imbalance_pct))
>> +             return true;
>> +
>>       return false;
>>  }
>
> This is unlikely to have worked as intended. You will never reach this,
> except on PowerPC >= 7. All other machines will have bailed at the
> !ASYM_PACKING check above this.

Ah yes, i miss that change while rebasing on rik patches. My use case
fall in this wider test now that we always select a busiest group
