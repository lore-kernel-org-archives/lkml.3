Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaGVMEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:04:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36104 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaGVMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:04:52 -0400
Date: Tue, 22 Jul 2014 14:04:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@parallels.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mingo@kernel.org,
        pjt@google.com
Subject: Re: [PATCH] sched: update last_balance only when actually balanced
Message-ID: <20140722120445.GB3935@laptop>
References: <20140722022121.4589c63b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722022121.4589c63b@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:21:21AM -0400, Rik van Riel wrote:
> Currently rebalance_domains will happily update sd->last_balance
> even if should_we_balance() decides that this CPU should not do
> any load balancing for the sd.
> 
> This can prevent the CPU that should load balance for the sd from
> doing load balancing, which can delay active balancing essentially
> forever.
> 
> The solution is to only update sd->last_balance when load_balance()
> actually did something.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 45943b2..4f7fee2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -7187,7 +7187,9 @@ static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
>  				 */
>  				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
>  			}
> -			sd->last_balance = jiffies;
> +			/* Only update if we actually balanced. */
> +			if (continue_balancing)
> +				sd->last_balance = jiffies;
>  			interval = get_sd_balance_interval(sd, idle != CPU_IDLE);
>  		}
>  		if (need_serialize)

Did you actually see any difference with this patch?

The reason I'm asking is that the sched_domains are per cpu, so the
above assignment is only visible to that particular cpu, not other cpus.
