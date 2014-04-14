Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbaDNGq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:46:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:41120 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbaDNGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:46:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,854,1389715200"; 
   d="scan'208";a="29218138"
Message-ID: <534B8540.4000904@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 14:50:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: fix double unlock bug
References: <5462835.Vnc4dWZRns@daeseok-laptop.cloud.net>
In-Reply-To: <5462835.Vnc4dWZRns@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 08:58 AM, Daeseok Youn wrote:
> 
> mutex_unlock() and put_pwq_unlocked() do not need to be called
> when alloc_unbound_pwq() is failed.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  kernel/workqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..e6e9f6a 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4100,7 +4100,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>  	if (!pwq) {
>  		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
>  			   wq->name);
> -		goto out_unlock;
> +		return;
>  	}
>  
>  	/*


Nice catch!!!

The supposed correct behavior is documented in the head of
this function. We forgot to do it.

 * If NUMA affinity can't be adjusted due to memory allocation failure, it
 * falls back to @wq->dfl_pwq which may not be optimal but is always
 * correct.

Could you use the following code instead of "goto out_unlock":
		mutex_lock(&wq->mutex);
		if (pwq == wq->dfl_pwq)
			goto out_unlock;
		else
			goto use_dfl_pwq;

Correct&BAD. There are two blocks of suck code in this function:
		if (pwq == wq->dfl_pwq)
			goto out_unlock;
		else
			goto use_dfl_pwq;

You can replace both these two blocks code to the following code:
		goto use_dfl_pwq;

The result is the same as before except it adds some small overhead.
I don't care the small overhead in this function.

Thanks
Lai
		
