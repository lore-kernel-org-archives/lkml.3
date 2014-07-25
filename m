Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaGYOaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:30:12 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:49413 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaGYOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <53D25CC4.1010306@redhat.com>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <CAKfTPtDdAzZcMA5bJvhyrdH9J1F69jMy5q3w5xc4t+PSKPQ0eA@mail.gmail.com> <53D25CC4.1010306@redhat.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 25 Jul 2014 16:29:49 +0200
Message-ID: <CAKfTPtB-okCg5dei3xDQbpWaCVb0oLZ6Ud5iFt8iN2yVR4HTpg@mail.gmail.com>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2014 15:33, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 07/23/2014 03:41 AM, Vincent Guittot wrote:
>> On 22 July 2014 20:45, Rik van Riel <riel@redhat.com> wrote:
>>> Currently update_sd_pick_busiest only returns true when an sd is
>>> overloaded, or for SD_ASYM_PACKING when a domain is busier than
>>> average and a higher numbered domain than the target.
>>>
>>> This breaks load balancing between domains that are not
>>> overloaded, in the !SD_ASYM_PACKING case. This patch makes
>>> update_sd_pick_busiest return true when the busiest sd yet is
>>> encountered.
>>>
>>> On a 4 node system, this seems to result in the load balancer
>>> finally putting 1 thread of a 4 thread test run of "perf bench
>>> numa mem" on each node, where before the load was generally not
>>> spread across all nodes.
>>>
>>> Behaviour for SD_ASYM_PACKING does not seem to match the
>>> comment, in that groups with below average load average are
>>> ignored, but I have no hardware to test that so I have left the
>>> behaviour of that code unchanged.
>>>
>>> Cc: mikey@neuling.org Cc: peterz@infradead.org Signed-off-by: Rik
>>> van Riel <riel@redhat.com> --- kernel/sched/fair.c | 18
>>> +++++++++++------- 1 file changed, 11 insertions(+), 7
>>> deletions(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index
>>> fea7d33..ff4ddba 100644 --- a/kernel/sched/fair.c +++
>>> b/kernel/sched/fair.c @@ -5942,16 +5942,20 @@ static bool
>>> update_sd_pick_busiest(struct lb_env *env, * numbered CPUs in the
>>> group, therefore mark all groups * higher than ourself as busy.
>>> */ -       if ((env->sd->flags & SD_ASYM_PACKING) &&
>>> sgs->sum_nr_running && -           env->dst_cpu <
>>> group_first_cpu(sg)) { -               if (!sds->busiest) -
>>> return true; +       if (env->sd->flags & SD_ASYM_PACKING) { +
>>> if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
>>> +                       if (!sds->busiest) +
>>> return true;
>>>
>>> -               if (group_first_cpu(sds->busiest) >
>>> group_first_cpu(sg)) -                       return true; +
>>> if (group_first_cpu(sds->busiest) > group_first_cpu(sg)) +
>>> return true; +               } + +               return false; }
>>>
>>> -       return false; +       /* See above: sgs->avg_load >
>>> sds->busiest_stat.avg_load */ +       return true;
>>
>> Hi Rik,
>>
>> I can see one issue with a default return set to true.  You
>> increase the number of time where we will not effectively migrate a
>> task because we don't ensure that we will take the overloaded group
>> if there is one. We can be in a situation where a group is
>> overloaded but the load_balance will select a not overloaded group
>> with an average load higher than sched_domain average value just
>> because it is checked after.
>
> Look at the first line of update_sd_pick_busiest()
>
> static bool update_sd_pick_busiest(struct lb_env *env,
>                                    struct sd_lb_stats *sds,
>                                    struct sched_group *sg,
>                                    struct sg_lb_stats *sgs)
> {
>         if (sgs->avg_load <= sds->busiest_stat.avg_load)
>                 return false;
>
> If the group load is less than the busiest, we have already
> returned false, and will not get to the code that I changed.


My point was that if a sched_group A with 1 task has got a higher
avg_load than a sched_group with 2 tasks, we will select sched_group A
whereas we should select the other group

Furthermore, update_sd_lb_stats will always return a busiest group
even an idle one. This will increase the number of failed load balance
and the time spent in the it.

Vincent

>
>> Regarding your issue with "perf bench numa mem" that is not spread
>> on all nodes, SD_PREFER_SIBLING flag (of DIE level) should do the
>> job by reducing the capacity of  "not local DIE" group at NUMA
>> level to 1 task during the load balance computation. So you should
>> have 1 task per sched_group at NUMA level.
>
> That did not actually happen in my tests. I almost always
> ended up having only 0 tasks on one node.
>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQEcBAEBAgAGBQJT0lzDAAoJEM553pKExN6D/8oH/3TmBwlIpj/H7pbs4ucvfigx
> WBgjkA0U/snXA8D/oRicIpX2+N42wwnmME/E20mhVjqUAvrDLbfaWoJC3UJ6Qx08
> GUeKxOBxbf1FypOmLyfKuQrMOojO585TX76n43MZnsfxzCJUIL6x6MQOE+Tbutx9
> 6Y0VCz1uw9BdwnEuP0fObMrExMOlmb2JSiWiCuf8uAorWiArv8TZvBxt5W093ONO
> bRDywJ8sMFVwgQ0TZLPEBFsRAcGuPhHx/FJZuOb/F/NWopaaZD3tt4gM3VDaq4ir
> z+Qvhboql2EdydoYZV+O4VBWI7gFtT2+vLpUteaYmFR3Zx5VtneSwyCwtk6yk0c=
> =tZ6L
> -----END PGP SIGNATURE-----
