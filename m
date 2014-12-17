Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaLQNvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:51:47 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:53574 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaLQNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:51:45 -0500
Date: Wed, 17 Dec 2014 10:51:35 -0300
From: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
Message-ID: <20141217135135.GA19525@fox>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
 <1416835236-25185-3-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416835236-25185-3-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mon, Nov 24, 2014 at 02:20:32PM +0100, Richard Weinberger wrote:
> If the WL pool runs out of PEBs we schedule a fastmap write
> to refill it as soon as possible.
> Ensure that only one at a time is scheduled otherwise we might end in
> a fastmap write storm because writing the fastmap can schedule another
> write if bitflips are detected.

Reviewed-by: Guido Martínez <guido@vanguardiasur.com.ar>

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/ubi.h | 4 +++-
>  drivers/mtd/ubi/wl.c  | 8 +++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index f80ffab..04c4c05 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -427,6 +427,7 @@ struct ubi_debug_info {
>   * @fm_size: fastmap size in bytes
>   * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
>   * @fm_work: fastmap work queue
> + * @fm_work_scheduled: non-zero if fastmap work was scheduled
>   *
>   * @used: RB-tree of used physical eraseblocks
>   * @erroneous: RB-tree of erroneous used physical eraseblocks
> @@ -438,7 +439,7 @@ struct ubi_debug_info {
>   * @pq_head: protection queue head
>   * @wl_lock: protects the @used, @free, @pq, @pq_head, @lookuptbl, @move_from,
>   *	     @move_to, @move_to_put @erase_pending, @wl_scheduled, @works,
> - *	     @erroneous, and @erroneous_peb_count fields
> + *	     @erroneous, @erroneous_peb_count, and @fm_work_scheduled fields
>   * @move_mutex: serializes eraseblock moves
>   * @work_sem: used to wait for all the scheduled works to finish and prevent
>   * new works from being submitted
> @@ -533,6 +534,7 @@ struct ubi_device {
>  	void *fm_buf;
>  	size_t fm_size;
>  	struct work_struct fm_work;
> +	int fm_work_scheduled;
>  
>  	/* Wear-leveling sub-system's stuff */
>  	struct rb_root used;
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 834f6fe..7f135df 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -149,6 +149,9 @@ static void update_fastmap_work_fn(struct work_struct *wrk)
>  {
>  	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
>  	ubi_update_fastmap(ubi);
> +	spin_lock(&ubi->wl_lock);
> +	ubi->fm_work_scheduled = 0;
> +	spin_unlock(&ubi->wl_lock);
>  }
>  
>  /**
> @@ -660,7 +663,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
>  		/* We cannot update the fastmap here because this
>  		 * function is called in atomic context.
>  		 * Let's fail here and refill/update it as soon as possible. */
> -		schedule_work(&ubi->fm_work);
> +		if (!ubi->fm_work_scheduled) {
> +			ubi->fm_work_scheduled = 1;
> +			schedule_work(&ubi->fm_work);
> +		}
>  		return NULL;
>  	} else {
>  		pnum = pool->pebs[pool->used++];
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Guido Martínez, VanguardiaSur
www.vanguardiasur.com.ar
