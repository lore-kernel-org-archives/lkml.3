Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaG2PcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:32:20 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55286 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaG2PcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <53D7B551.40703@redhat.com>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com> <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
 <53D7B551.40703@redhat.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 29 Jul 2014 17:31:57 +0200
Message-ID: <CAKfTPtAS-0-9duQgXtri9WxYgFxoKbE05z+4HysCCOS6OaocMQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2014 16:53, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 07/29/2014 05:04 AM, Vincent Guittot wrote:
>> On 28 July 2014 20:16,  <riel@redhat.com> wrote:
>>> From: Rik van Riel <riel@redhat.com>
>>>
>>> There are several ways in which update_sd_pick_busiest can end
>>> up picking an sd as "busiest" that has a below-average per-cpu
>>> load.
>>>
>>> All of those could use the same correction that was previously
>>> only applied when the selected group has a group imbalance.
>>>
>>> Additionally, the load balancing code will balance out the load
>>> between domains that are below their maximum capacity. This
>>> results in the load_above_capacity calculation underflowing,
>>> creating a giant unsigned number, which is then removed by the
>>> min() check below.
>>
>> The load_above capacity can't underflow with current version. The
>> underflow that you mention above, could occur with the change you
>> are doing in patch 2 which can select a group which not overloaded
>> nor imbalanced.
>
> With SD_ASYM_PACKING the current code can already hit the underflow.

I don't think so because AFAICT, SD_ASYM_PACKING is used at sibling
level where the group_capacity_factor will be at most 1
and sum_nr_running is > 1 in calculate_imbalance

>
> You are right though that it does not become common until the second
> patch has been applied.
>
>>> In situations where all the domains are overloaded, or where only
>>> the busiest domain is overloaded, that code is also superfluous,
>>> since the normal env->imbalance calculation will figure out how
>>> much to move. Remove the load_above_capacity calculation.
>>
>> IMHO, we should not remove that part which is used by
>> prefer_sibling
>>
>> Originally, we had 2 type of busiest group: overloaded or
>> imbalanced. You add a new one which has only a avg_load higher than
>> other so you should handle this new case and keep the other ones
>> unchanged
>
> The "overloaded" case will simply degenerate into the first case,
> if we move enough load to make the domain no longer overloaded,
> but still above average.
>
> In the case where the value calculated by the "overloaded" calculation
> is different from the above-average, the old code took the minimum of
> the two as how much to move.
>
> The new case you ask for would simply take the other part of that
> difference, once a domain is no longer overloaded.
>
> I cannot think of any case where keeping the "overloaded" code would
> result in the code behaving differently over the long term.
>
> What am I overlooking?

IIUC the load_above_capacity is there to prevent the busiest group to
become idle and you remove that protection

Vincent
>
>>> Signed-off-by: Rik van Riel <riel@redhat.com> ---
>>> kernel/sched/fair.c | 33 ++++++++------------------------- 1 file
>>> changed, 8 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index
>>> 45943b2..a28bb3b 100644 --- a/kernel/sched/fair.c +++
>>> b/kernel/sched/fair.c @@ -6221,16 +6221,16 @@ void
>>> fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>>> */ static inline void calculate_imbalance(struct lb_env *env,
>>> struct sd_lb_stats *sds) { -       unsigned long max_pull,
>>> load_above_capacity = ~0UL; struct sg_lb_stats *local, *busiest;
>>>
>>> local = &sds->local_stat; busiest = &sds->busiest_stat;
>>>
>>> -       if (busiest->group_imb) { +       if (busiest->avg_load
>>> <= sds->avg_load) {
>>
>> busiest->avg_load <= sds->avg_load is already handled in the
>> fix_small_imbalance function, you should probably handle that here
>
> OK, I will move that code into fix_small_imbalance()
>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQEcBAEBAgAGBQJT17VRAAoJEM553pKExN6DHMgIAI4IQsezUS1B/t8FzgkUR+8K
> 7EPIlOmsKZN/odfC6G4TntfwJojlcOsIQlxJF+PNCoWU4U61THK+NXif2a9/rNUE
> 3ffsrhZVy576HExezkAOzC8Z+g+7Y8O77af1PkSWul6Y3Xb2lQGG8ey+gdkOZytQ
> vwTlGQHGiUqiJaA1aohkz45Zbv2o7m7qCHoNPNvE9qK3WEY0StgLRQgfny6cgHsM
> 079Ecx5A5p7W/zL9kvMELQtU1QI0c7PLEGSy5rT0+8moZdR9biQF9ktDkoNawOD1
> DLPguz+ZbLZUNOLezC18k8FoqLxkBkZiXQ25f20AFnLkJM4HC3A9EP+SsVZVc+M=
> =1hLj
> -----END PGP SIGNATURE-----
