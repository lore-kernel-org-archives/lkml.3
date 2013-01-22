Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3AVDng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:43:36 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58265 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3AVDnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:43:35 -0500
Message-ID: <50FE0ADC.6060701@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 11:43:24 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net>
In-Reply-To: <1358761496.4994.118.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012203-2674-0000-0000-0000078ED333
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 05:44 PM, Mike Galbraith wrote:
> On Mon, 2013-01-21 at 17:22 +0800, Michael Wang wrote: 
>> On 01/21/2013 05:09 PM, Mike Galbraith wrote:
>>> On Mon, 2013-01-21 at 15:45 +0800, Michael Wang wrote: 
>>>> On 01/21/2013 03:09 PM, Mike Galbraith wrote:
>>>>> On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
>>>>>> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
>>>>>
>>>>>>> May be we could try change this back to the old way later, after the aim
>>>>>>> 7 test on my server.
>>>>>>
>>>>>> Yeah, something funny is going on.
>>>>>
>>>>> Never entering balance path kills the collapse.  Asking wake_affine()
>>>>> wrt the pull as before, but allowing us to continue should no idle cpu
>>>>> be found, still collapsed.  So the source of funny behavior is indeed in
>>>>> balance_path.
>>>>
>>>> Below patch based on the patch set could help to avoid enter balance path
>>>> if affine_sd could be found, just like the old logical, would you like to
>>>> take a try and see whether it could help fix the collapse?
>>>
>>> No, it does not.
>>
>> Hmm...what have changed now compared to the old logical?
> 
> What I did earlier to confirm the collapse originates in balance_path is
> below.  I just retested to confirm.
> 
> Tasks    jobs/min  jti  jobs/min/task      real       cpu
>     1      435.34  100       435.3448     13.92      3.76   Mon Jan 21 10:24:00 2013
>     1      440.09  100       440.0871     13.77      3.76   Mon Jan 21 10:24:22 2013
>     1      440.41  100       440.4070     13.76      3.75   Mon Jan 21 10:24:45 2013
>     5     2467.43   99       493.4853     12.28     10.71   Mon Jan 21 10:24:59 2013
>     5     2445.52   99       489.1041     12.39     10.98   Mon Jan 21 10:25:14 2013
>     5     2475.49   99       495.0980     12.24     10.59   Mon Jan 21 10:25:27 2013
>    10     4963.14   99       496.3145     12.21     20.64   Mon Jan 21 10:25:41 2013
>    10     4959.08   99       495.9083     12.22     21.26   Mon Jan 21 10:25:54 2013
>    10     5415.55   99       541.5550     11.19     11.54   Mon Jan 21 10:26:06 2013
>    20     9934.43   96       496.7213     12.20     33.52   Mon Jan 21 10:26:18 2013
>    20     9950.74   98       497.5369     12.18     36.52   Mon Jan 21 10:26:31 2013
>    20     9893.88   96       494.6939     12.25     34.39   Mon Jan 21 10:26:43 2013
>    40    18937.50   98       473.4375     12.80     84.74   Mon Jan 21 10:26:56 2013
>    40    18996.87   98       474.9216     12.76     88.64   Mon Jan 21 10:27:09 2013
>    40    19146.92   98       478.6730     12.66     89.98   Mon Jan 21 10:27:22 2013
>    80    37610.55   98       470.1319     12.89    112.01   Mon Jan 21 10:27:35 2013
>    80    37321.02   98       466.5127     12.99    114.21   Mon Jan 21 10:27:48 2013
>    80    37610.55   98       470.1319     12.89    111.77   Mon Jan 21 10:28:01 2013
>   160    69109.05   98       431.9316     14.03    156.81   Mon Jan 21 10:28:15 2013
>   160    69505.38   98       434.4086     13.95    155.33   Mon Jan 21 10:28:29 2013
>   160    69207.71   98       432.5482     14.01    155.79   Mon Jan 21 10:28:43 2013
>   320   108033.43   98       337.6045     17.95    314.01   Mon Jan 21 10:29:01 2013
>   320   108577.83   98       339.3057     17.86    311.79   Mon Jan 21 10:29:19 2013
>   320   108395.75   98       338.7367     17.89    312.55   Mon Jan 21 10:29:37 2013
>   640   151440.84   98       236.6263     25.61    620.37   Mon Jan 21 10:30:03 2013
>   640   151440.84   97       236.6263     25.61    621.23   Mon Jan 21 10:30:29 2013
>   640   151145.75   98       236.1652     25.66    622.35   Mon Jan 21 10:30:55 2013
>  1280   190117.65   98       148.5294     40.80   1228.40   Mon Jan 21 10:31:36 2013
>  1280   189977.96   98       148.4203     40.83   1229.91   Mon Jan 21 10:32:17 2013
>  1280   189560.12   98       148.0938     40.92   1231.71   Mon Jan 21 10:32:58 2013
>  2560   217857.04   98        85.1004     71.21   2441.61   Mon Jan 21 10:34:09 2013
>  2560   217338.19   98        84.8977     71.38   2448.76   Mon Jan 21 10:35:21 2013
>  2560   217795.87   97        85.0765     71.23   2443.12   Mon Jan 21 10:36:32 2013
> 
> That was with your change backed out, and the q/d below applied.

So that change will help to solve the issue? good to know :)

But it will invoke wake_affine() with out any delay, the benefit
of the patch set will be reduced a lot...

I think this change help to solve the issue because it avoid jump
into balance path when wakeup for any cases, I think we can do
some change like below to achieve this and meanwhile gain benefit
from delay wake_affine().

Since the issue could not been reproduced on my side, I don't know
whether the patch benefit or not, so if you are willing to send out
a formal patch, I would be glad to include it in my patch set ;-)

And another patch below below is a debug one, which will print out
all the sbm info, so we could check whether it was initialized
correctly, just use command "dmesg | grep WYT" to show the map.

Regards,
Michael Wang

---
 kernel/sched/fair.c |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2aa26c1..4361333 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3250,7 +3250,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 }

 /*
- * Try and locate an idle CPU in the sched_domain.
+ * Try and locate an idle CPU in the sched_domain, return -1 if failed.
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
@@ -3292,13 +3292,13 @@ static int select_idle_sibling(struct task_struct *p, int target)

                        target = cpumask_first_and(sched_group_cpus(sg),
                                        tsk_cpus_allowed(p));
-                       goto done;
+                       return target;
 next:
                        sg = sg->next;
                } while (sg != sd->groups);
        }
-done:
-       return target;
+
+       return -1;
 }

 /*
@@ -3342,40 +3342,48 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
                 * may has already been cached on prev_cpu, and usually
                 * they require low latency.
                 *
-                * So firstly try to locate an idle cpu shared the cache
+                * Therefor, balance path in such case will cause damage
+                * and bring benefit synchronously, wakeup on prev_cpu
+                * may better than wakeup on a new lower load cpu for the
+                * cached memory, and we never know.
+                *
+                * So the principle is, try to find an idle cpu as close to
+                * prev_cpu as possible, if failed, just take prev_cpu.
+                *
+                * Firstly try to locate an idle cpu shared the cache
                 * with prev_cpu, it has the chance to break the load
                 * balance, fortunately, select_idle_sibling() will search
                 * from top to bottom, which help to reduce the chance in
                 * some cases.
                 */
                new_cpu = select_idle_sibling(p, prev_cpu);
-               if (idle_cpu(new_cpu))
+               if (new_cpu != -1)
                        goto unlock;

                /*
                 * No idle cpu could be found in the topology of prev_cpu,
-                * before jump into the slow balance_path, try search again
-                * in the topology of current cpu if it is the affine of
-                * prev_cpu.
+                * before take the prev_cpu, try search again in the
+                * topology of current cpu if it is the affine of prev_cpu.
                 */
-               if (cpu == prev_cpu ||
-                               !sbm->affine_map[prev_cpu] ||
+               if (cpu == prev_cpu || !sbm->affine_map[prev_cpu] ||
                                !cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-                       goto balance_path;
+                       goto take_prev;

                new_cpu = select_idle_sibling(p, cpu);
-               if (!idle_cpu(new_cpu))
-                       goto balance_path;
-
                /*
                 * Invoke wake_affine() finally since it is no doubt a
                 * performance killer.
                 */
-               if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
+               if ((new_cpu != -1) &&
+                       wake_affine(sbm->affine_map[prev_cpu], p, sync))
                        goto unlock;
+
+take_prev:
+               new_cpu = prev_cpu;
+               goto unlock;
        }

-balance_path:
+       /* Balance path. */
        new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
        sd = sbm->sd[type][sbm->top_level[type]];

-- 
1.7.4.1

DEBUG PATCH:

---
 kernel/sched/core.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c63303..f251f29 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5578,6 +5578,35 @@ static void update_top_cache_domain(int cpu)
 static int sbm_max_level;
 DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);

+static void debug_sched_balance_map(int cpu)
+{
+       int i, type, level = 0;
+       struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+
+       printk("WYT: sbm of cpu %d\n", cpu);
+
+       for (type = 0; type < SBM_MAX_TYPE; type++) {
+               if (type == SBM_EXEC_TYPE)
+                       printk("WYT: \t exec map\n");
+               else if (type == SBM_FORK_TYPE)
+                       printk("WYT: \t fork map\n");
+               else if (type == SBM_WAKE_TYPE)
+                       printk("WYT: \t wake map\n");
+
+               for (level = 0; level < sbm_max_level; level++) {
+                       if (sbm->sd[type][level])
+                               printk("WYT: \t\t sd %x, idx %d, level %d, weight %d\n", sbm->sd[type][level], level, sbm->sd[type][level]->level, sbm->sd[type][level]->span_weight);
+               }
+       }
+
+       printk("WYT: \t affine map\n");
+
+       for_each_possible_cpu(i) {
+               if (sbm->affine_map[i])
+                       printk("WYT: \t\t affine with cpu %x in sd %x, weight %d\n", i, sbm->affine_map[i], sbm->affine_map[i]->span_weight);
+       }
+}
+
 static void build_sched_balance_map(int cpu)
 {
        struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
@@ -5688,6 +5717,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
         * destroy_sched_domains() already do the work.
         */
        build_sched_balance_map(cpu);
+       debug_sched_balance_map(cpu);
        rcu_assign_pointer(rq->sbm, sbm);
 }

-- 
1.7.4.1

> 
> ---
>  kernel/sched/fair.c |   27 ++++++---------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3337,6 +3337,8 @@ select_task_rq_fair(struct task_struct *
>  		goto unlock;
> 
>  	if (sd_flag & SD_BALANCE_WAKE) {
> +		new_cpu = prev_cpu;
> +
>  		/*
>  		 * Tasks to be waked is special, memory it relied on
>  		 * may has already been cached on prev_cpu, and usually
> @@ -3348,33 +3350,16 @@ select_task_rq_fair(struct task_struct *
>  		 * from top to bottom, which help to reduce the chance in
>  		 * some cases.
>  		 */
> -		new_cpu = select_idle_sibling(p, prev_cpu);
> +		new_cpu = select_idle_sibling(p, new_cpu);
>  		if (idle_cpu(new_cpu))
>  			goto unlock;
> 
> -		/*
> -		 * No idle cpu could be found in the topology of prev_cpu,
> -		 * before jump into the slow balance_path, try search again
> -		 * in the topology of current cpu if it is the affine of
> -		 * prev_cpu.
> -		 */
> -		if (!sbm->affine_map[prev_cpu] ||
> -				!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
> -			goto balance_path;
> -
> -		new_cpu = select_idle_sibling(p, cpu);
> -		if (!idle_cpu(new_cpu))
> -			goto balance_path;
> +		if (wake_affine(sbm->affine_map[cpu], p, sync))
> +			new_cpu = select_idle_sibling(p, cpu);
> 
> -		/*
> -		 * Invoke wake_affine() finally since it is no doubt a
> -		 * performance killer.
> -		 */
> -		if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
> -			goto unlock;
> +		goto unlock;
>  	}
> 
> -balance_path:
>  	new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
>  	sd = sbm->sd[type][sbm->top_level[type]];
> 
> 
> 
> 
> 

