Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3BCOSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:18:55 -0500
Received: from linode.aoot.com ([69.164.194.13]:53367 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3BCOSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:18:53 -0500
Message-ID: <510E71BD.1010909@opengridcomputing.com>
Date: Sun, 03 Feb 2013 08:18:37 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 25/62] infiniband/cxgb4: convert to idr_alloc()
References: <1359854463-2538-1-git-send-email-tj@kernel.org> <1359854463-2538-26-git-send-email-tj@kernel.org>
In-Reply-To: <1359854463-2538-26-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/2013 7:20 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steve Wise <swise@chelsio.com>
> Cc: linux-rdma@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Is there a git tree somewhere that I can use to test these patches out?

>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 27 ++++++++++++++-------------
>   1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 9c1644f..7f862da 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -260,20 +260,21 @@ static inline int _insert_handle(struct c4iw_dev *rhp, struct idr *idr,
>   				 void *handle, u32 id, int lock)
>   {
>   	int ret;
> -	int newid;
>   
> -	do {
> -		if (!idr_pre_get(idr, lock ? GFP_KERNEL : GFP_ATOMIC))
> -			return -ENOMEM;
> -		if (lock)
> -			spin_lock_irq(&rhp->lock);
> -		ret = idr_get_new_above(idr, handle, id, &newid);
> -		BUG_ON(!ret && newid != id);
> -		if (lock)
> -			spin_unlock_irq(&rhp->lock);
> -	} while (ret == -EAGAIN);
> -
> -	return ret;
> +	if (lock) {
> +		idr_preload(GFP_KERNEL);
> +		spin_lock_irq(&rhp->lock);
> +	}

The idr_preload() needs to be above the 'if (lock)', no?

> +
> +	ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
> +
> +	if (lock) {
> +		spin_unlock_irq(&rhp->lock);
> +		idr_preload_end();
> +	}

And idr_preload_end() should be after the 'if (lock)' block methinks...

> +
> +	BUG_ON(ret == -ENOSPC);
> +	return ret < 0 ? ret : 0;

What would cause ret >  0?

>   }
>   
>   static inline int insert_handle(struct c4iw_dev *rhp, struct idr *idr,

