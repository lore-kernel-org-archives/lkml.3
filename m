Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3AXHBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:01:05 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42117 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AXHA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:00:58 -0500
Message-ID: <5100DC1A.9070906@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2013 15:00:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net> <50FF7086.4020509@linux.vnet.ibm.com> <1358922520.5752.91.camel@marge.simpson.net> <50FF8CD8.4060105@linux.vnet.ibm.com>	 <1358929257.5752.109.camel@marge.simp! son.net>	 <50FF9F92.60202@linux.vnet.ibm.com> <1358930968.5752.123.camel@marge.simpson.net> <50FFA695.6010407@linux.vnet.ibm.com> <1358932694.5752.126.camel@marge.simpson.net> <1358933555.5752.132.camel@marge.simpson.net> <5100CE1F.7080704@linux.vnet.ibm.com>
In-Reply-To: <5100CE1F.7080704@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012406-9264-0000-0000-0000030DFCF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 02:01 PM, Michael Wang wrote:
> On 01/23/2013 05:32 PM, Mike Galbraith wrote:
> [snip]
>> ---
>>  include/linux/topology.h |    6 ++---
>>  kernel/sched/core.c      |   41 ++++++++++++++++++++++++++++++-------
>>  kernel/sched/fair.c      |   52 +++++++++++++++++++++++++++++------------------
>>  3 files changed, 70 insertions(+), 29 deletions(-)
>>
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -95,7 +95,7 @@ int arch_update_cpu_topology(void);
>>  				| 1*SD_BALANCE_NEWIDLE			\
>>  				| 1*SD_BALANCE_EXEC			\
>>  				| 1*SD_BALANCE_FORK			\
>> -				| 0*SD_BALANCE_WAKE			\
>> +				| 1*SD_BALANCE_WAKE			\
>>  				| 1*SD_WAKE_AFFINE			\
>>  				| 1*SD_SHARE_CPUPOWER			\
>>  				| 1*SD_SHARE_PKG_RESOURCES		\
>> @@ -126,7 +126,7 @@ int arch_update_cpu_topology(void);
>>  				| 1*SD_BALANCE_NEWIDLE			\
>>  				| 1*SD_BALANCE_EXEC			\
>>  				| 1*SD_BALANCE_FORK			\
>> -				| 0*SD_BALANCE_WAKE			\
>> +				| 1*SD_BALANCE_WAKE			\
>>  				| 1*SD_WAKE_AFFINE			\
>>  				| 0*SD_SHARE_CPUPOWER			\
>>  				| 1*SD_SHARE_PKG_RESOURCES		\
>> @@ -156,7 +156,7 @@ int arch_update_cpu_topology(void);
>>  				| 1*SD_BALANCE_NEWIDLE			\
>>  				| 1*SD_BALANCE_EXEC			\
>>  				| 1*SD_BALANCE_FORK			\
>> -				| 0*SD_BALANCE_WAKE			\
>> +				| 1*SD_BALANCE_WAKE			\
>>  				| 1*SD_WAKE_AFFINE			\
>>  				| 0*SD_SHARE_CPUPOWER			\
>>  				| 0*SD_SHARE_PKG_RESOURCES		\
> 
> I've enabled WAKE flag on my box like you did, but still can't see
> regression, and I've just tested on a power server with 64 cpu, also
> failed to reproduce the issue (not compared with virgin yet, but can't
> see collapse).
> 
> I will do more testing on the power box to confirm it.

I still can't reproduce the issue, but there are some difference
according to my default sd topology:

WYT: sbm of cpu 0
WYT: 	 exec map
WYT: 		 sd f051be80, idx 0, level 0, weight 4
WYT: 		 sd f08b3700, idx 1, level 1, weight 32
WYT: 		 sd f08b3700, idx 2, level 1, weight 32
WYT: 	 fork map
WYT: 		 sd f051be80, idx 0, level 0, weight 4
WYT: 		 sd f08b3700, idx 1, level 1, weight 32
WYT: 		 sd f08b3700, idx 2, level 1, weight 32
WYT: 	 wake map
WYT: 		 sd f051be80, idx 0, level 0, weight 4
WYT: 		 sd f08b3700, idx 1, level 1, weight 32
WYT: 		 sd f08b6300, idx 2, level 2, weight 64
WYT: 	 affine map
WYT: 		 affine with cpu 0 in sd f051be80, weight 4
WYT: 		 affine with cpu 1 in sd f051be80, weight 4
WYT: 		 affine with cpu 2 in sd f051be80, weight 4
WYT: 		 affine with cpu 3 in sd f051be80, weight 4
		...

And there are only sibling, cpu and numa level, no mc level while your
box have, but that looks harmless to me... isn't it?

This is the aim 7 results of the patched kernel, it's just fine.

Tasks    jobs/min  jti  jobs/min/task      real       cpu
    1      424.07  100       424.0728     14.29      4.29   Thu Jan 24
01:52:22 2013
    5     2561.28   99       512.2570     11.83      8.82   Thu Jan 24
01:52:35 2013
   10     5033.22   97       503.3223     12.04     16.35   Thu Jan 24
01:52:47 2013
   20    10350.13   98       517.5064     11.71     28.54   Thu Jan 24
01:52:59 2013
   40    20116.18   98       502.9046     12.05     62.06   Thu Jan 24
01:53:11 2013
   80    39255.06   98       490.6883     12.35    122.18   Thu Jan 24
01:53:24 2013
  160    69405.87   97       433.7867     13.97    234.41   Thu Jan 24
01:53:38 2013
  320   111192.66   92       347.4771     17.44    463.18   Thu Jan 24
01:53:56 2013
  640   158044.01   86       246.9438     24.54    920.38   Thu Jan 24
01:54:20 2013
 1280   199763.07   87       156.0649     38.83   1833.75   Thu Jan 24
01:54:59 2013
 2560   229933.30   81        89.8177     67.47   3665.30   Thu Jan 24
01:56:07 2013

And this is my cpu info:
processor	: 63
cpu		: POWER7 (raw), altivec supported
clock		: 8.388608MHz
revision	: 2.3 (pvr 003f 0203)

Regards,
Michael Wang

> 
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5609,11 +5609,39 @@ static void update_top_cache_domain(int
>>  static int sbm_max_level;
>>  DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
>>
>> +static void debug_sched_balance_map(int cpu)
>> +{
>> +	int i, type, level = 0;
>> +	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
>> +
>> +	printk("WYT: sbm of cpu %d\n", cpu);
>> +
>> +	for (type = 0; type < SBM_MAX_TYPE; type++) {
>> +		if (type == SBM_EXEC_TYPE)
>> +			printk("WYT: \t exec map\n");
>> +		else if (type == SBM_FORK_TYPE)
>> +			printk("WYT: \t fork map\n");
>> +		else if (type == SBM_WAKE_TYPE)
>> +			printk("WYT: \t wake map\n");
>> +
>> +		for (level = 0; level < sbm_max_level; level++) {
>> +			if (sbm->sd[type][level])
>> +				printk("WYT: \t\t sd %x, idx %d, level %d, weight %d\n", sbm->sd[type][level], level, sbm->sd[type][level]->level, sbm->sd[type][level]->span_weight);
>> +		}
>> +	}
>> +
>> +	printk("WYT: \t affine map\n");
>> +
>> +	for_each_possible_cpu(i) {
>> +		if (sbm->affine_map[i])
>> +			printk("WYT: \t\t affine with cpu %x in sd %x, weight %d\n", i, sbm->affine_map[i], sbm->affine_map[i]->span_weight);
>> +	}
>> +}
>> +
>>  static void build_sched_balance_map(int cpu)
>>  {
>>  	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
>>  	struct sched_domain *sd = cpu_rq(cpu)->sd;
>> -	struct sched_domain *top_sd = NULL;
>>  	int i, type, level = 0;
>>
>>  	memset(sbm->top_level, 0, sizeof((*sbm).top_level));
>> @@ -5656,11 +5684,9 @@ static void build_sched_balance_map(int
>>  	 * fill the hole to get lower level sd easily.
>>  	 */
>>  	for (type = 0; type < SBM_MAX_TYPE; type++) {
>> -		level = sbm->top_level[type];
>> -		top_sd = sbm->sd[type][level];
>> -		if ((++level != sbm_max_level) && top_sd) {
>> -			for (; level < sbm_max_level; level++)
>> -				sbm->sd[type][level] = top_sd;
>> +		for (level = 1; level < sbm_max_level; level++) {
>> +			if (!sbm->sd[type][level])
>> +				sbm->sd[type][level] = sbm->sd[type][level - 1];
>>  		}
>>  	}
>>  }
>> @@ -5719,6 +5745,7 @@ cpu_attach_domain(struct sched_domain *s
>>  	 * destroy_sched_domains() already do the work.
>>  	 */
>>  	build_sched_balance_map(cpu);
>> +//MIKE	debug_sched_balance_map(cpu);
>>  	rcu_assign_pointer(rq->sbm, sbm);
>>  }
>>
>> @@ -6220,7 +6247,7 @@ sd_numa_init(struct sched_domain_topolog
>>  					| 1*SD_BALANCE_NEWIDLE
>>  					| 0*SD_BALANCE_EXEC
>>  					| 0*SD_BALANCE_FORK
>> -					| 0*SD_BALANCE_WAKE
>> +					| 1*SD_BALANCE_WAKE
>>  					| 0*SD_WAKE_AFFINE
>>  					| 0*SD_SHARE_CPUPOWER
>>  					| 0*SD_SHARE_PKG_RESOURCES
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3312,7 +3312,7 @@ static int select_idle_sibling(struct ta
>>  static int
>>  select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>>  {
>> -	struct sched_domain *sd = NULL;
>> +	struct sched_domain *sd = NULL, *tmp;
>>  	int cpu = smp_processor_id();
>>  	int prev_cpu = task_cpu(p);
>>  	int new_cpu = cpu;
>> @@ -3376,31 +3376,45 @@ select_task_rq_fair(struct task_struct *
>>
>>  balance_path:
>>  	new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
>> -	sd = sbm->sd[type][sbm->top_level[type]];
>> +	sd = tmp = sbm->sd[type][sbm->top_level[type]];
>>
>>  	while (sd) {
>>  		int load_idx = sd->forkexec_idx;
>> -		struct sched_group *sg = NULL;
>> +		struct sched_group *group;
>> +		int weight;
>> +
>> +		if (!(sd->flags & sd_flag)) {
>> +			sd = sd->child;
>> +			continue;
>> +		}
>>
>>  		if (sd_flag & SD_BALANCE_WAKE)
>>  			load_idx = sd->wake_idx;
>>
>> -		sg = find_idlest_group(sd, p, cpu, load_idx);
>> -		if (!sg)
>> -			goto next_sd;
>> -
>> -		new_cpu = find_idlest_cpu(sg, p, cpu);
>> -		if (new_cpu != -1)
>> -			cpu = new_cpu;
>> -next_sd:
>> -		if (!sd->level)
>> -			break;
>> -
>> -		sbm = cpu_rq(cpu)->sbm;
>> -		if (!sbm)
>> -			break;
>> -
>> -		sd = sbm->sd[type][sd->level - 1];
> 
> May be we could test part by part? I'm planing to write another debug
> patch, by which we could compare just part of the two ways, will send to
> you when I finished it.
> 
> Regards,
> Michael Wang
> 
>> +		group = find_idlest_group(sd, p, cpu, load_idx);
>> +		if (!group) {
>> +			sd = sd->child;
>> +			continue;
>> +		}
>> +
>> +		new_cpu = find_idlest_cpu(group, p, cpu);
>> +		if (new_cpu == -1 || new_cpu == cpu) {
>> +			/* Now try balancing at a lower domain level of cpu */
>> +			sd = sd->child;
>> +			continue;
>> +		}
>> +
>> +		/* Now try balancing at a lower domain level of new_cpu */
>> +		cpu = new_cpu;
>> +		weight = sd->span_weight;
>> +		sd = NULL;
>> +		for_each_domain(cpu, tmp) {
>> +			if (weight <= tmp->span_weight)
>> +				break;
>> +			if (tmp->flags & sd_flag)
>> +				sd = tmp;
>> +		}
>> +		/* while loop will break here if sd == NULL */
>>  	}
>>
>>  unlock:
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

