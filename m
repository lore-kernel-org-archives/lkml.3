Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaAMF5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:57:42 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54676 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaAMF5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:57:40 -0500
Message-ID: <52D3804A.8060700@linaro.org>
Date: Mon, 13 Jan 2014 13:57:30 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        lkp@linux.intel.com
Subject: Re: [sched] 73628fba4: +69% context switches
References: <20140111101956.GA11150@localhost>
In-Reply-To: <20140111101956.GA11150@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2014 06:19 PM, Fengguang Wu wrote:
> Alex,
> 
> FYI, we find much increased interrupts and context switches introduced
> by commit 73628fba4 ("sched: unify imbalance bias for target group")
> in your noload branch:

Many thanks for the generous and quick testing! :)

few questions for the results and give a testing patch for try. it also push on github. 

What's about the aim7 shell_rtns_1 and shared throughput?
> 
> 7bea8c18805a5f1  73628fba451ae72221b155696  
> ---------------  -------------------------  
>      14979 ~ 4%   +1304.8%     210434 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
>       2748 ~ 5%    +977.4%      29607 ~ 0%  nhm-white/micro/aim7/shared
>      17727        +1254.1%     240041       TOTAL interrupts.RES

RES interrupt increased about 200,000, but vmstat's interrupt increased a little. guess the vmstat data is per seconds, right? If so, it is better give how long time the vmstat running.

The same problem on the time.involuntary_context_switches and vmstat cs.

According to involuntary CS definition in time, RES interrupt will cause involuntary CS. but here 29607 RES of aim7/shared cause 233218 time inv CS, does sth I missed or the data is incorrect?

> 
> 7bea8c18805a5f1  73628fba451ae72221b155696  
> ---------------  -------------------------  
>       3617 ~ 0%     +69.2%       6118 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
>       3617          +69.2%       6118       TOTAL vmstat.system.in
> 
> 7bea8c18805a5f1  73628fba451ae72221b155696  
> ---------------  -------------------------  
>     132746 ~ 0%     +69.0%     224346 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
>     220038 ~ 0%      +6.0%     233218 ~ 0%  nhm-white/micro/aim7/shared
>     352785          +29.7%     457564       TOTAL time.involuntary_context_switches
> 
> 7bea8c18805a5f1  73628fba451ae72221b155696  
> ---------------  -------------------------  
>    1424581 ~ 0%      +8.6%    1546786 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
>    1424581           +8.6%    1546786       TOTAL time.voluntary_context_switches
> 
> 7bea8c18805a5f1  73628fba451ae72221b155696  
> ---------------  -------------------------  
>      20982 ~ 0%     +12.5%      23599 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
>       6005 ~ 0%      +4.2%       6256 ~ 0%  nhm-white/micro/aim7/shared
>      26988          +10.6%      29856       TOTAL vmstat.system.cs
> 
>                                   vmstat.system.cs
> 

commit c5a8778a132cfa882609fbccb4ee6542eac9866d
Author: Alex Shi <alex.shi@linaro.org>
Date:   Mon Jan 13 13:54:30 2014 +0800

    more bias towards local cpu group

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2b216ad..046ca2c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4008,7 +4008,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
        struct task_group *tg;
        unsigned long weight;
        int balanced;
-       int bias = 100 + (sd->imbalance_pct -100) / 2;
 
        /*
         * If we wake multiple tasks be careful to not bounce
@@ -4020,7 +4019,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
        this_cpu  = smp_processor_id();
        prev_cpu  = task_cpu(p);
        load      = source_load(prev_cpu);
-       this_load = target_load(this_cpu, bias);
+       this_load = target_load(this_cpu, sd->imbalance_pct);
 
        /*
         * If sync wakeup then subtract the (maximum possible)
@@ -4055,7 +4054,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
                this_eff_load *= this_load +
                        effective_load(tg, this_cpu, weight, weight);
 
-               prev_eff_load = bias;
+               prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
                prev_eff_load *= power_of(this_cpu);
                prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
 
@@ -4100,7 +4099,6 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 {
        struct sched_group *idlest = NULL, *group = sd->groups;
        unsigned long min_load = ULONG_MAX, this_load = 0;
-       int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
        do {
                unsigned long load, avg_load;
@@ -4123,7 +4121,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
                        if (local_group)
                                load = source_load(i);
                        else
-                               load = target_load(i, imbalance);
+                               load = target_load(i, sd->imbalance_pct);
 
                        avg_load += load;
                }

-- 
Thanks
    Alex
