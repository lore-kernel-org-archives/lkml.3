Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbaGYOrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760590AbaGYOri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:47:38 -0400
Message-ID: <53D26DDF.5070001@redhat.com>
Date: Fri, 25 Jul 2014 10:46:55 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a busier
 sd
References: <20140722144559.382c5243@annuminas.surriel.com> <CAKfTPtDdAzZcMA5bJvhyrdH9J1F69jMy5q3w5xc4t+PSKPQ0eA@mail.gmail.com> <53D25CC4.1010306@redhat.com> <CAKfTPtB-okCg5dei3xDQbpWaCVb0oLZ6Ud5iFt8iN2yVR4HTpg@mail.gmail.com>
In-Reply-To: <CAKfTPtB-okCg5dei3xDQbpWaCVb0oLZ6Ud5iFt8iN2yVR4HTpg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/25/2014 10:29 AM, Vincent Guittot wrote:
> On 25 July 2014 15:33, Rik van Riel <riel@redhat.com> wrote: On
> 07/23/2014 03:41 AM, Vincent Guittot wrote:
>>>> On 22 July 2014 20:45, Rik van Riel <riel@redhat.com> wrote:
>>>>> Currently update_sd_pick_busiest only returns true when an
>>>>> sd is overloaded, or for SD_ASYM_PACKING when a domain is
>>>>> busier than average and a higher numbered domain than the
>>>>> target.
>>>>> 
>>>>> This breaks load balancing between domains that are not 
>>>>> overloaded, in the !SD_ASYM_PACKING case. This patch makes 
>>>>> update_sd_pick_busiest return true when the busiest sd yet
>>>>> is encountered.
>>>>> 
>>>>> On a 4 node system, this seems to result in the load
>>>>> balancer finally putting 1 thread of a 4 thread test run of
>>>>> "perf bench numa mem" on each node, where before the load
>>>>> was generally not spread across all nodes.
>>>>> 
>>>>> Behaviour for SD_ASYM_PACKING does not seem to match the 
>>>>> comment, in that groups with below average load average
>>>>> are ignored, but I have no hardware to test that so I have
>>>>> left the behaviour of that code unchanged.
>>>>> 
>>>>> Cc: mikey@neuling.org Cc: peterz@infradead.org
>>>>> Signed-off-by: Rik van Riel <riel@redhat.com> ---
>>>>> kernel/sched/fair.c | 18 +++++++++++------- 1 file changed,
>>>>> 11 insertions(+), 7 deletions(-)
>>>>> 
>>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>>> index fea7d33..ff4ddba 100644 --- a/kernel/sched/fair.c
>>>>> +++ b/kernel/sched/fair.c @@ -5942,16 +5942,20 @@ static
>>>>> bool update_sd_pick_busiest(struct lb_env *env, * numbered
>>>>> CPUs in the group, therefore mark all groups * higher than
>>>>> ourself as busy. */ -       if ((env->sd->flags &
>>>>> SD_ASYM_PACKING) && sgs->sum_nr_running && -
>>>>> env->dst_cpu < group_first_cpu(sg)) { -               if
>>>>> (!sds->busiest) - return true; +       if (env->sd->flags &
>>>>> SD_ASYM_PACKING) { + if (sgs->sum_nr_running &&
>>>>> env->dst_cpu < group_first_cpu(sg)) { +
>>>>> if (!sds->busiest) + return true;
>>>>> 
>>>>> -               if (group_first_cpu(sds->busiest) > 
>>>>> group_first_cpu(sg)) -                       return true;
>>>>> + if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
>>>>> + return true; +               } + +               return
>>>>> false; }
>>>>> 
>>>>> -       return false; +       /* See above: sgs->avg_load
>>>>> > sds->busiest_stat.avg_load */ +       return true;
>>>> 
>>>> Hi Rik,
>>>> 
>>>> I can see one issue with a default return set to true.  You 
>>>> increase the number of time where we will not effectively
>>>> migrate a task because we don't ensure that we will take the
>>>> overloaded group if there is one. We can be in a situation
>>>> where a group is overloaded but the load_balance will select
>>>> a not overloaded group with an average load higher than
>>>> sched_domain average value just because it is checked after.
> 
> Look at the first line of update_sd_pick_busiest()
> 
> static bool update_sd_pick_busiest(struct lb_env *env, struct
> sd_lb_stats *sds, struct sched_group *sg, struct sg_lb_stats *sgs) 
> { if (sgs->avg_load <= sds->busiest_stat.avg_load) return false;
> 
> If the group load is less than the busiest, we have already 
> returned false, and will not get to the code that I changed.
> 
> 
>> My point was that if a sched_group A with 1 task has got a
>> higher avg_load than a sched_group with 2 tasks, we will select
>> sched_group A whereas we should select the other group

The code already does that, with or without my patch.

If it runs into group A first, that "return false" above will
be hit for group B.

>> Furthermore, update_sd_lb_stats will always return a busiest
>> group even an idle one. This will increase the number of failed
>> load balance and the time spent in the it.

If the busiest group found is idle, surely find_busiest_group
will see that and goto out_balanced ?

There are several safety checks in find_busiest_group to make
sure NULL is returned when the imbalance found is too small to
bother doing anything about.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT0m3fAAoJEM553pKExN6D1xMH/3BOTeD9aiu/nVCWnfJIdRUB
2owogPLFDlcbUekzGkjIxc4lYWj/ANVk5jOibcOLutckSJXphDc1KhqYYXaNM6rm
NfoFM0//HGxJgIWMKGWYWJosPdFdrvLxNRwn8+yBnZh9el15GQSBvhKjrCeolNo2
Yy6AqicqvoMXMnzcONcAxyxwH0b6CRFuGHIOAvzjXGUvSKTU7fs1zPRAVxfORbbp
HfiOybqNJW+EnH7xhJU+GSZi+X+agnRS4/axfc48FZH01/P+k21cYougC7kMxxHA
MGP1YtnNYGFBqCX5QwGgw5NkMgHYNCCREh+uLwsgGCN/bkmuHJm+JcbQOQlRoRY=
=v9O8
-----END PGP SIGNATURE-----
