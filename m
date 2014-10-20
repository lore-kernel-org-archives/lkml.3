Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaJTHsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:48:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaJTHsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:48:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5444BE13.8050603@jp.fujitsu.com>
Date: Mon, 20 Oct 2014 16:47:31 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <kernellwp@gmail.com>, <riel@redhat.com>, <tkhai@yandex.ru>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched/fair: Care divide error in update_task_scan_period()
References: <543F945F.4020303@jp.fujitsu.com>
In-Reply-To: <543F945F.4020303@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you review this patch?

(2014/10/16 18:48), Yasuaki Ishimatsu wrote:
> While offling node by hot removing memory, the following divide error
> occurs:
> 
>    divide error: 0000 [#1] SMP
>    [...]
>    Call Trace:
>     [...] handle_mm_fault
>     [...] ? try_to_wake_up
>     [...] ? wake_up_state
>     [...] __do_page_fault
>     [...] ? do_futex
>     [...] ? put_prev_entity
>     [...] ? __switch_to
>     [...] do_page_fault
>     [...] page_fault
>    [...]
>    RIP  [<ffffffff810a7081>] task_numa_fault
>     RSP <ffff88084eb2bcb0>
> 
> The issue occurs as follows:
>    1. When page fault occurs and page is allocated from node 1,
>       task_struct->numa_faults_buffer_memory[] of node 1 is
>       incremented and p->numa_faults_locality[] is also incremented
>       as follows:
> 
>       o numa_faults_buffer_memory[]       o numa_faults_locality[]
>                NR_NUMA_HINT_FAULT_TYPES
>               |      0     |     1     |
>       ----------------------------------  ----------------------
>        node 0 |      0     |     0     |   remote |      0     |
>        node 1 |      0     |     1     |   locale |      1     |
>       ----------------------------------  ----------------------
> 
>    2. node 1 is offlined by hot removing memory.
> 
>    3. When page fault occurs, fault_types[] is calculated by using
>       p->numa_faults_buffer_memory[] of all online nodes in
>       task_numa_placement(). But node 1 was offline by step 2. So
>       the fault_types[] is calculated by using only
>       p->numa_faults_buffer_memory[] of node 0. So both of fault_types[]
>       are set to 0.
> 
>    4. The values(0) of fault_types[] pass to update_task_scan_period().
> 
>    5. numa_faults_locality[1] is set to 1. So the following division is
>       calculated.
> 
>          static void update_task_scan_period(struct task_struct *p,
>                                  unsigned long shared, unsigned long private){
>          ...
>                  ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
>          }
> 
>    6. But both of private and shared are set to 0. So divide error
>       occurs here.
> 
> The divide error is rare case because the trigger is node offline.
> By this patch, when both of private and shared are set to 0,
> denominator is set to 1 for avoiding divide error.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Wanpeng Li <kernellwp@gmail.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
>   kernel/sched/fair.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86..580fc74 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1466,6 +1466,7 @@ static void update_task_scan_period(struct task_struct *p,
> 
>   	unsigned long remote = p->numa_faults_locality[0];
>   	unsigned long local = p->numa_faults_locality[1];
> +	unsigned long total_faults = shared + private;
> 
>   	/*
>   	 * If there were no record hinting faults then either the task is
> @@ -1496,6 +1497,14 @@ static void update_task_scan_period(struct task_struct *p,
>   			slot = 1;
>   		diff = slot * period_slot;
>   	} else {
> +		/*
> +		 * This is a rare case. total_faults might become 0 after
> +		 * offlining node. In this case, total_faults is set to 1
> +		 * for avoiding divide error.
> +		 */
> +		if (unlikely(total_faults == 0))
> +			total_faults = 1;
> +
>   		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
> 
>   		/*
> @@ -1506,7 +1515,7 @@ static void update_task_scan_period(struct task_struct *p,
>   		 * scanning faster if shared accesses dominate as it may
>   		 * simply bounce migrations uselessly
>   		 */
> -		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
> +		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (total_faults));
>   		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
>   	}
> 


