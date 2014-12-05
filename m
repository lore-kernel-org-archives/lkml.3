Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaLENJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:09:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLENJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:09:20 -0500
Message-ID: <5481AE79.1090900@codeaurora.org>
Date: Fri, 05 Dec 2014 15:09:13 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] UBI: Fastmap: Fix races in ubi_wl_get_peb()
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-5-git-send-email-richard@nod.at>
In-Reply-To: <1416835236-25185-5-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 3:20 PM, Richard Weinberger wrote:
> ubi_wl_get_peb() has two problems, it reads the pool
> size and usage counters without any protection.
> While reading one value would be perfectly fine it reads multiple
> values and compares them. This is racy and can lead to incorrect
> pool handling.
> Furthermore ubi_update_fastmap() is called without wl_lock held,
> before incrementing the used counter it needs to be checked again.

I didn't see where you fixed the ubi_update_fastmap issue you just 
mentioned.

> It could happen that another thread consumed all PEBs from the
> pool and the counter goes beyond ->size.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/ubi.h |  3 ++-
>   drivers/mtd/ubi/wl.c  | 34 +++++++++++++++++++++++-----------
>   2 files changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index 04c4c05..d672412 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -439,7 +439,8 @@ struct ubi_debug_info {
>    * @pq_head: protection queue head
>    * @wl_lock: protects the @used, @free, @pq, @pq_head, @lookuptbl, @move_from,
>    *	     @move_to, @move_to_put @erase_pending, @wl_scheduled, @works,
> - *	     @erroneous, @erroneous_peb_count, and @fm_work_scheduled fields
> + *	     @erroneous, @erroneous_peb_count, @fm_work_scheduled, @fm_pool,
> + *	     and @fm_wl_pool fields
>    * @move_mutex: serializes eraseblock moves
>    * @work_sem: used to wait for all the scheduled works to finish and prevent
>    * new works from being submitted
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index cb2e571..7730b97 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -629,24 +629,36 @@ void ubi_refill_pools(struct ubi_device *ubi)
>    */
>   int ubi_wl_get_peb(struct ubi_device *ubi)
>   {
> -	int ret;
> +	int ret, retried = 0;
>   	struct ubi_fm_pool *pool = &ubi->fm_pool;
>   	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
>
> -	if (!pool->size || !wl_pool->size || pool->used == pool->size ||
> -	    wl_pool->used == wl_pool->size)
> +again:
> +	spin_lock(&ubi->wl_lock);
> +	/* We check here also for the WL pool because at this point we can
> +	 * refill the WL pool synchronous. */
> +	if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
> +		spin_unlock(&ubi->wl_lock);
>   		ubi_update_fastmap(ubi);
> -
> -	/* we got not a single free PEB */
> -	if (!pool->size)
> -		ret = -ENOSPC;
> -	else {
>   		spin_lock(&ubi->wl_lock);
> -		ret = pool->pebs[pool->used++];
> -		prot_queue_add(ubi, ubi->lookuptbl[ret]);
> +	}
> +
> +	if (pool->used == pool->size) {

Im confused about this "if" condition. You just tested pool->used == 
pool->size in the previous "if". If in the previous if pool->used != 
pool->size and wl_pool->used != wl_pool->size, you didn't enter, the 
lock is still held so pool->used != pool->size still. If in the previos 
"if" wl_pool->used == wl_pool->size was true nd tou released the lock,
ubi_update_fastmap(ubi) was called, which refills the pools. So again, 
if pools were refilled pool->used would be 0 here and pool->size > 0.

So in both cases I don't see how at this point pool->used == pool->size 
could ever be true?

>   		spin_unlock(&ubi->wl_lock);
> +		if (retried) {
> +			ubi_err(ubi, "Unable to get a free PEB from user WL pool");
> +			ret = -ENOSPC;
> +			goto out;
> +		}
> +		retried = 1;

Why did you decide to retry in this function? and why only 1 retry 
attempt? I'm not against it, trying to understand the logic.

> +		goto again;
>   	}
>
> +	ubi_assert(pool->used < pool->size);
> +	ret = pool->pebs[pool->used++];
> +	prot_queue_add(ubi, ubi->lookuptbl[ret]);
> +	spin_unlock(&ubi->wl_lock);
> +out:
>   	return ret;
>   }
>
> @@ -659,7 +671,7 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
>   	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
>   	int pnum;
>
> -	if (pool->used == pool->size || !pool->size) {
> +	if (pool->used == pool->size) {
>   		/* We cannot update the fastmap here because this
>   		 * function is called in atomic context.
>   		 * Let's fail here and refill/update it as soon as possible. */
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
