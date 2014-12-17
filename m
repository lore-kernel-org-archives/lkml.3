Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLQUB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 15:01:59 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51942 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaLQUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:01:57 -0500
Date: Wed, 17 Dec 2014 17:01:47 -0300
From: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UBI: Fastmap: Fix memory leaks while closing the WL
 sub-system
Message-ID: <20141217200147.GA11301@fox>
References: <1417347340-6872-1-git-send-email-richard@nod.at>
 <1417347340-6872-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417347340-6872-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 12:35:35PM +0100, Richard Weinberger wrote:
> Add a ubi_fastmap_close() to free all resources used by fastmap
> at WL shutdown.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Either for this patch, or for a v3 if you move the
-flush_work/+ubi_fastmap_close to shutdown_work:

Tested-by: Guido Martínez <guido@vanguardiasur.com.ar>
Reviewed-by: Guido Martínez <guido@vanguardiasur.com.ar>

> ---
>  drivers/mtd/ubi/wl.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index c2822f7..47b215f 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -2064,6 +2064,23 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>  	}
>  }
>  
> +static void ubi_fastmap_close(struct ubi_device *ubi)
> +{
> +#ifdef CONFIG_MTD_UBI_FASTMAP
> +	int i;
> +
> +	flush_work(&ubi->fm_work);
> +	return_unused_pool_pebs(ubi, &ubi->fm_pool);
> +	return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
> +
> +	if (ubi->fm) {
> +		for (i = 0; i < ubi->fm->used_blocks; i++)
> +			kfree(ubi->fm->e[i]);
> +	}
> +	kfree(ubi->fm);
> +#endif
> +}
> +
>  /**
>   * ubi_wl_close - close the wear-leveling sub-system.
>   * @ubi: UBI device description object
> @@ -2071,9 +2088,7 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>  void ubi_wl_close(struct ubi_device *ubi)
>  {
>  	dbg_wl("close the WL sub-system");
> -#ifdef CONFIG_MTD_UBI_FASTMAP
> -	flush_work(&ubi->fm_work);
> -#endif
> +	ubi_fastmap_close(ubi);
>  	shutdown_work(ubi);
>  	protection_queue_destroy(ubi);
>  	tree_destroy(&ubi->used);

-- 
Guido Martínez, VanguardiaSur
www.vanguardiasur.com.ar
