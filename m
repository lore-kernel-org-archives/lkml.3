Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaJUJVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:21:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaJUJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:21:17 -0400
Date: Tue, 21 Oct 2014 11:21:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: mingo@redhat.com, kernellwp@gmail.com, riel@redhat.com, tkhai@yandex.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched/fair: Care divide error in
 update_task_scan_period()
Message-ID: <20141021092112.GO23531@worktop.programming.kicks-ass.net>
References: <543F945F.4020303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F945F.4020303@jp.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 06:48:15PM +0900, Yasuaki Ishimatsu wrote:
> +++ b/kernel/sched/fair.c
> @@ -1466,6 +1466,7 @@ static void update_task_scan_period(struct task_struct *p,
> 
>  	unsigned long remote = p->numa_faults_locality[0];
>  	unsigned long local = p->numa_faults_locality[1];
> +	unsigned long total_faults = shared + private;
> 
>  	/*
>  	 * If there were no record hinting faults then either the task is
> @@ -1496,6 +1497,14 @@ static void update_task_scan_period(struct task_struct *p,
>  			slot = 1;
>  		diff = slot * period_slot;
>  	} else {
> +		/*
> +		 * This is a rare case. total_faults might become 0 after
> +		 * offlining node. In this case, total_faults is set to 1
> +		 * for avoiding divide error.
> +		 */
> +		if (unlikely(total_faults == 0))
> +			total_faults = 1;
> +
>  		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
> 
>  		/*
> @@ -1506,7 +1515,7 @@ static void update_task_scan_period(struct task_struct *p,
>  		 * scanning faster if shared accesses dominate as it may
>  		 * simply bounce migrations uselessly
>  		 */
> -		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
> +		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (total_faults));
>  		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;

So what was wrong with the 'normal' unconditional +1 approach? Also
you've got superfluous parenthese.
