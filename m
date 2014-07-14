Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaGNIK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:10:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaGNIKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:10:51 -0400
Date: Mon, 14 Jul 2014 10:10:37 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: linux-mmc@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris@printf.net
Subject: Re: [PATCH] mmc: Do not advertise secure discard if it is
 blacklisted
In-Reply-To: <1403090287-10673-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1407141008180.13527@localhost.localdomain>
References: <1403090287-10673-1-git-send-email-lczerner@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Lukas Czerner wrote:

> Date: Wed, 18 Jun 2014 13:18:07 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-mmc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org, chris@printf.net,
>     Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] mmc: Do not advertise secure discard if it is blacklisted
> 
> Currently when the device secure discard implementation is
> blacklisted (MMC_QUIRK_SEC_ERASE_TRIM_BROKEN quirk is set)
> instead of secure discard we're going to do normal discard,
> which is wrong.
> 
> When the secure discard is known to be broken we should just
> disallow it entirely and not advertise this functionality to
> the user. Fix it.
> 
> Also move mmc_fixup_device() in from of mmc_blk_alloc() so we
> can get quirks set before we attempt to set queue information.

Where should I send it to get noticed ? It's sitting here for a
month now.

Thanks!
-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  drivers/mmc/card/block.c | 6 +++---
>  drivers/mmc/core/core.c  | 3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 452782b..ede41f0 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -2028,8 +2028,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>  		/* complete ongoing async transfer before issuing discard */
>  		if (card->host->areq)
>  			mmc_blk_issue_rw_rq(mq, NULL);
> -		if (req->cmd_flags & REQ_SECURE &&
> -			!(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
> +		if (req->cmd_flags & REQ_SECURE)
>  			ret = mmc_blk_issue_secdiscard_rq(mq, req);
>  		else
>  			ret = mmc_blk_issue_discard_rq(mq, req);
> @@ -2432,6 +2431,8 @@ static int mmc_blk_probe(struct mmc_card *card)
>  	if (!(card->csd.cmdclass & CCC_BLOCK_READ))
>  		return -ENODEV;
>  
> +	mmc_fixup_device(card, blk_fixups);
> +
>  	md = mmc_blk_alloc(card);
>  	if (IS_ERR(md))
>  		return PTR_ERR(md);
> @@ -2446,7 +2447,6 @@ static int mmc_blk_probe(struct mmc_card *card)
>  		goto out;
>  
>  	mmc_set_drvdata(card, md);
> -	mmc_fixup_device(card, blk_fixups);
>  
>  	if (mmc_add_disk(md))
>  		goto out;
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 7dc0c85..d03a080 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2102,7 +2102,8 @@ EXPORT_SYMBOL(mmc_can_sanitize);
>  
>  int mmc_can_secure_erase_trim(struct mmc_card *card)
>  {
> -	if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN)
> +	if ((card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN) &&
> +	    !(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
>  		return 1;
>  	return 0;
>  }
> 
