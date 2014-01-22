Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaAVKKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:10:23 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42511 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751773AbaAVKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:10:22 -0500
Message-ID: <52DF990B.4060703@arm.com>
Date: Wed, 22 Jan 2014 10:10:19 +0000
From: Chris Redpath <Chris.Redpath@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] sched: fix sched_entity avg statistics update
References: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/14 16:12, Vincent Guittot wrote:
> With the current implementation, the load average statistics of a sched entity
> change according to other activity on the CPU even if this activity is done
> between the running window of the sched entity and have no influence on the
> running duration of the task.
>
> When a task wakes up on the same CPU, we currently update last_runnable_update
> with the return  of __synchronize_entity_decay without updating the
> runnable_avg_sum and runnable_avg_period accordingly. In fact, we have to sync
> the load_contrib of the se with the rq's blocked_load_contrib before removing
> it from the latter (with __synchronize_entity_decay) but we must keep
> last_runnable_update unchanged for updating runnable_avg_sum/period during the
> next update_entity_load_avg.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>   kernel/sched/fair.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e64b079..5b0ef90 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2370,8 +2370,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>   		 * would have made count negative); we must be careful to avoid
>   		 * double-accounting blocked time after synchronizing decays.
>   		 */
> -		se->avg.last_runnable_update += __synchronize_entity_decay(se)
> -							<< 20;
> +		__synchronize_entity_decay(se);
>   	}
>
>   	/* migrated tasks did not contribute to our blocked load */
>

I've noticed this problem too. It becomes more apparent if you are 
closely inspecting load signals and comparing against ideal signals 
generated from task runtime traces. IMO it should be fixed.

