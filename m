Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbbASMpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:45:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbASMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:45:41 -0500
Date: Mon, 19 Jan 2015 13:45:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, riel@redhat.com, jason.low2@hp.com,
        fweisbec@gmail.com
Subject: Re: [PATCH v6 5/7] sched/fair: fix idle balance when remaining tasks
 are all non-CFS tasks
Message-ID: <20150119124528.GO25256@twins.programming.kicks-ass.net>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
 <1416962647-76792-6-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416962647-76792-6-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 08:44:05AM +0800, Wanpeng Li wrote:
> The overload indicator is used for knowing when we can totally avoid load
> balancing to a cpu that is about to go idle. We can avoid load balancing
> when no cpu has cfs task and both rt and deadline have push/pull mechanism
> to do their own balancing.
> 
> However, rq->nr_running on behalf of the total number of each class tasks
> on the cpu, do idle balance when remaining tasks are all non-CFS tasks does
> not make any sense.
> 
> This patch fix it by idle balance when there are still other CFS tasks in
> the rq's root domain.
> 

Please always try and Cc the people who touched that code last; for the
idle_balance bits commit 4486edd12b5a ("sched/fair: Implement fast
idling of CPUs when the system is partially loaded") gives a fair clue
as to who that would be.

> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 31f1e4d..f7dd978 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1269,7 +1269,8 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
>  
>  	rq->nr_running = prev_nr + count;
>  
> -	if (prev_nr < 2 && rq->nr_running >= 2) {
> +	if (prev_nr < 2 && rq->nr_running >= 2 &&
> +		rq->cfs.h_nr_running > 0) {
>  #ifdef CONFIG_SMP
>  		if (!rq->rd->overload)
>  			rq->rd->overload = true;

Here 3882ec643997 ("nohz: Use IPI implicit full barrier against
rq->nr_running r/w") might be a clue.

Also, this is wrong, it breaks NOHZ_FULL.
