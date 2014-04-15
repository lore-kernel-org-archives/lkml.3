Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaDOOna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:43:30 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:51910 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:43:29 -0400
Date: Tue, 15 Apr 2014 10:43:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] workqueue: fix double unlock bug
Message-ID: <20140415144324.GJ1863@htj.dyndns.org>
References: <1798086.IHnGGWGxmu@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1798086.IHnGGWGxmu@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 08:17:43AM +0900, Daeseok Youn wrote:
> 
> Use default pwq when alloc_unbound_pwq() is failed.
> 
> And remove "if" condition for whether "pwq" is same as "wq->dfl_pwq"
> when wq_calc_node_cpumask() returns false and just use "goto use_dfl_pwq"
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

This is an awfully inadequate patch description.  Can you change it to
something like the following?

  workqueue: fix bugs in wq_update_unbound_numa() failure path

  wq_update_unbound_numa() failure path has the following two bugs.

  * alloc_unbound_pwq() is called without holding wq->mutex; however, if
    the allocation fails, it jumps to out_unlock which tries to unlock
    wq->mutex.

  * The function should switch to dfl_pwq on failure but didn't do so
    after alloc_unbound_pwq() failure.

  Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
  alloc_unbound_pwq() failure.
      

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

And please put this in a separate patch.  Patches which are to be
backported through -stable should be minimal.  Also, please update the
comment above to reflect the change.

Thanks.

-- 
tejun
