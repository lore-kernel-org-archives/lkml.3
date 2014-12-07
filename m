Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaLGIOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 03:14:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42494 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaLGIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 03:14:00 -0500
Message-ID: <54840C44.4090406@codeaurora.org>
Date: Sun, 07 Dec 2014 10:13:56 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UBI: Fastmap: Fix memory leaks while closing the
 WL sub-system
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-2-git-send-email-richard@nod.at>
In-Reply-To: <1417347340-6872-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 1:35 PM, Richard Weinberger wrote:
> Add a ubi_fastmap_close() to free all resources used by fastmap
> at WL shutdown.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/wl.c | 21 ++++++++++++++++++---
>   1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index c2822f7..47b215f 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -2064,6 +2064,23 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>   	}
>   }
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

kfree(ubi->fm_buf)?

> +#endif
> +}
> +
>   /**
>    * ubi_wl_close - close the wear-leveling sub-system.
>    * @ubi: UBI device description object
> @@ -2071,9 +2088,7 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>   void ubi_wl_close(struct ubi_device *ubi)
>   {
>   	dbg_wl("close the WL sub-system");
> -#ifdef CONFIG_MTD_UBI_FASTMAP
> -	flush_work(&ubi->fm_work);
> -#endif
> +	ubi_fastmap_close(ubi);
>   	shutdown_work(ubi);
>   	protection_queue_destroy(ubi);
>   	tree_destroy(&ubi->used);
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
