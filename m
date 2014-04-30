Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbaD3Nqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:46:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47052 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939AbaD3Nqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:46:51 -0400
Message-ID: <5360FECF.6060301@arm.com>
Date: Wed, 30 Apr 2014 14:46:55 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Do not zero sg->cpumask and sg->sgp->power in
 build_sched_groups
References: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
In-Reply-To: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 30 Apr 2014 13:47:03.0758 (UTC) FILETIME=[AB2B8EE0:01CF647A]
X-MC-Unique: 114043014465000501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/14 14:39, Dietmar Eggemann wrote:
> From: Dietmar Eggemann <Dietmar.Eggemann@arm.com>
> 
> There is no need to zero struct sched_group member cpumask and struct
> sched_group_power member power since both structures are already allocated
> as zeroed memory in __sdt_alloc().
> 
> This patch has been tested with
> BUG_ON(!cpumask_empty(sched_group_cpus(sg))); and BUG_ON(sg->sgp->power);
> in build_sched_groups() on ARM TC2 and INTEL i5 M520 platform including
> CPU hotplug scenarios.
> 
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> ---
>  kernel/sched/core.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9cae286824bb..6bc51aebbf1b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5807,8 +5807,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
>  			continue;
>  
>  		group = get_group(i, sdd, &sg);
> -		cpumask_clear(sched_group_cpus(sg));
> -		sg->sgp->power = 0;
>  		cpumask_setall(sched_group_mask(sg));
>  
>  		for_each_cpu(j, span) {
> 

there is also a discrepancy between build_sched_groups() and
build_overlap_sched_groups(). The latter one sets power and power_orig
to SCHED_POWER_SCALE * cpumask_weight(sg_span) (since c3decf0dfbc95
'sched: Always initialize cpu-power' and 8e8339a3a1069 'sched:
Initialize power_orig for overlapping groups').

So we could do the same in build_sched_groups(). IMHO, then the
appropriate check 'if (!group->sgp->power_orig)' in
sched_domain_debug_one() becomes superfluous.

-- Dietmar

Patch proposal against tip_sched_core.

-- >8 --

Subject: [PATCH] sched: Initialize sg->sgp->power and sg->sgp->power_orig for
 non-overlapping groups

---
 kernel/sched/core.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286824bb..ccf9b811ba37 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5206,18 +5206,6 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		/*
-		 * Even though we initialize ->power to something semi-sane,
-		 * we leave power_orig unset. This allows us to detect if
-		 * domain iteration is still funny without causing /0 traps.
-		 */
-		if (!group->sgp->power_orig) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: domain->cpu_power not "
-					"set\n");
-			break;
-		}
-
 		if (!cpumask_weight(sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: empty group\n");
@@ -5807,8 +5795,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		group = get_group(i, sdd, &sg);
-		cpumask_clear(sched_group_cpus(sg));
-		sg->sgp->power = 0;
 		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
@@ -5819,6 +5805,9 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			cpumask_set_cpu(j, sched_group_cpus(sg));
 		}
 
+		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sched_group_cpus(sg));
+		sg->sgp->power_orig = sg->sgp->power;
+
 		if (!first)
 			first = sg;
 		if (last)
-- 
1.7.9.5


