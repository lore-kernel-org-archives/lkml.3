Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3JXEHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 00:07:18 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47669 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3JXEHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 00:07:16 -0400
Message-ID: <52689C38.5010108@linux.vnet.ibm.com>
Date: Thu, 24 Oct 2013 09:34:08 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/3] sched: Aggressive balance in domains whose groups
 share package resources
References: <20131021114002.13291.31478.stgit@drishya> <20131021114502.13291.60794.stgit@drishya> <20131022222326.GL2490@laptop.programming.kicks-ass.net>
In-Reply-To: <20131022222326.GL2490@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102404-1618-0000-0000-000004DAEF8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/23/2013 03:53 AM, Peter Zijlstra wrote:
> On Mon, Oct 21, 2013 at 05:15:02PM +0530, Vaidyanathan Srinivasan wrote:
>>  kernel/sched/fair.c |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 828ed97..bbcd96b 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5165,6 +5165,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>>  {
>>  	int ld_moved, cur_ld_moved, active_balance = 0;
>>  	struct sched_group *group;
>> +	struct sched_domain *child;
>> +	int share_pkg_res = 0;
>>  	struct rq *busiest;
>>  	unsigned long flags;
>>  	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
>> @@ -5190,6 +5192,10 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>>  
>>  	schedstat_inc(sd, lb_count[idle]);
>>  
>> +	child = sd->child;
>> +	if (child && child->flags & SD_SHARE_PKG_RESOURCES)
>> +		share_pkg_res = 1;
>> +
>>  redo:
>>  	if (!should_we_balance(&env)) {
>>  		*continue_balancing = 0;
>> @@ -5202,6 +5208,7 @@ redo:
>>  		goto out_balanced;
>>  	}
>>  
>> +redo_grp:
>>  	busiest = find_busiest_queue(&env, group);
>>  	if (!busiest) {
>>  		schedstat_inc(sd, lb_nobusyq[idle]);
>> @@ -5292,6 +5299,11 @@ more_balance:
>>  			if (!cpumask_empty(cpus)) {
>>  				env.loop = 0;
>>  				env.loop_break = sched_nr_migrate_break;
>> +				if (share_pkg_res &&
>> +					cpumask_intersects(cpus,
>> +						to_cpumask(group->cpumask)))
> 
> sched_group_cpus()
> 
>> +					goto redo_grp;
>> +
>>  				goto redo;
>>  			}
>>  			goto out_balanced;
>> @@ -5318,9 +5330,15 @@ more_balance:
>>  			 */
>>  			if (!cpumask_test_cpu(this_cpu,
>>  					tsk_cpus_allowed(busiest->curr))) {
>> +				cpumask_clear_cpu(cpu_of(busiest), cpus);
>>  				raw_spin_unlock_irqrestore(&busiest->lock,
>>  							    flags);
>>  				env.flags |= LBF_ALL_PINNED;
>> +				if (share_pkg_res &&
>> +					cpumask_intersects(cpus,
>> +						to_cpumask(group->cpumask)))
>> +					goto redo_grp;
>> +
>>  				goto out_one_pinned;
>>  			}
> 
> Man this retry logic is getting annoying.. isn't there anything saner we
> can do?

Let me give this a thought and get back.

Regards
Preeti U Murthy
> 

