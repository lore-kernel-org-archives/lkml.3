Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaLDQOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:14:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58243 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbaLDQOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:14:14 -0500
Message-ID: <54808850.5090200@codeaurora.org>
Date: Thu, 04 Dec 2014 18:14:08 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-3-git-send-email-richard@nod.at>
In-Reply-To: <1416835236-25185-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 3:20 PM, Richard Weinberger wrote:
> If the WL pool runs out of PEBs we schedule a fastmap write
> to refill it as soon as possible.
> Ensure that only one at a time is scheduled otherwise we might end in
> a fastmap write storm because writing the fastmap can schedule another
> write if bitflips are detected.
>

Reviewed-by: Tanya Brokhman <tlinder@codeaurora.org>

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/ubi.h | 4 +++-
>   drivers/mtd/ubi/wl.c  | 8 +++++++-
>   2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index f80ffab..04c4c05 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -427,6 +427,7 @@ struct ubi_debug_info {
>    * @fm_size: fastmap size in bytes
>    * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
>    * @fm_work: fastmap work queue
> + * @fm_work_scheduled: non-zero if fastmap work was scheduled
>    *
>    * @used: RB-tree of used physical eraseblocks
>    * @erroneous: RB-tree of erroneous used physical eraseblocks
> @@ -438,7 +439,7 @@ struct ubi_debug_info {
>    * @pq_head: protection queue head
>    * @wl_lock: protects the @used, @free, @pq, @pq_head, @lookuptbl, @move_from,
>    *	     @move_to, @move_to_put @erase_pending, @wl_scheduled, @works,
> - *	     @erroneous, and @erroneous_peb_count fields
> + *	     @erroneous, @erroneous_peb_count, and @fm_work_scheduled fields
>    * @move_mutex: serializes eraseblock moves
>    * @work_sem: used to wait for all the scheduled works to finish and prevent
>    * new works from being submitted
> @@ -533,6 +534,7 @@ struct ubi_device {
>   	void *fm_buf;
>   	size_t fm_size;
>   	struct work_struct fm_work;
> +	int fm_work_scheduled;
>
>   	/* Wear-leveling sub-system's stuff */
>   	struct rb_root used;
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 834f6fe..7f135df 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -149,6 +149,9 @@ static void update_fastmap_work_fn(struct work_struct *wrk)
>   {
>   	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
>   	ubi_update_fastmap(ubi);
> +	spin_lock(&ubi->wl_lock);
> +	ubi->fm_work_scheduled = 0;
> +	spin_unlock(&ubi->wl_lock);
>   }
>
>   /**
> @@ -660,7 +663,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
>   		/* We cannot update the fastmap here because this
>   		 * function is called in atomic context.
>   		 * Let's fail here and refill/update it as soon as possible. */
> -		schedule_work(&ubi->fm_work);
> +		if (!ubi->fm_work_scheduled) {
> +			ubi->fm_work_scheduled = 1;
> +			schedule_work(&ubi->fm_work);
> +		}
>   		return NULL;
>   	} else {
>   		pnum = pool->pebs[pool->used++];
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
