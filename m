Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaDOD31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:29:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15282 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbaDOD30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:29:26 -0400
X-IronPort-AV: E=Sophos;i="4.97,860,1389715200"; 
   d="scan'208";a="29267959"
Message-ID: <534CA87A.6050106@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 11:33:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] workqueue: fix double unlock bug
References: <1798086.IHnGGWGxmu@daeseok-laptop.cloud.net>
In-Reply-To: <1798086.IHnGGWGxmu@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: stable@kernel.org

Thanks,
Lai

On 04/15/2014 07:17 AM, Daeseok Youn wrote:
> 
> Use default pwq when alloc_unbound_pwq() is failed.
> 
> And remove "if" condition for whether "pwq" is same as "wq->dfl_pwq"
> when wq_calc_node_cpumask() returns false and just use "goto use_dfl_pwq"
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> V2: replace "if condition" with "goto" as Lai's comment.
> V3: Use default pwq when alloc_unbound_pwq() is failed.
> 
>  kernel/workqueue.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..0679854 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4087,10 +4087,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>  		if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
>  			goto out_unlock;
>  	} else {
> -		if (pwq == wq->dfl_pwq)
> -			goto out_unlock;
> -		else
> -			goto use_dfl_pwq;
> +		goto use_dfl_pwq;
>  	}
>  
>  	mutex_unlock(&wq->mutex);
> @@ -4100,7 +4097,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>  	if (!pwq) {
>  		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
>  			   wq->name);
> -		goto out_unlock;
> +		mutex_lock(&wq->mutex);
> +		goto use_dfl_pwq;
>  	}
>  
>  	/*

