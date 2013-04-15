Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172Ab3DOHPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:15:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:48100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab3DOHPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,473,1363158000"; 
   d="scan'208";a="227201882"
Message-ID: <516BAA36.9030500@intel.com>
Date: Mon, 15 Apr 2013 10:20:22 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: Re: [PATCH 2/8] mmc: fix max_discard_sectors
References: <1365860309-21261-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1365860309-21261-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/13 16:38, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> https://lkml.org/lkml/2013/4/1/292
> As per above discussion, there is possibility that request's __data_len
> field may overflow when max_discard_sectors greater than UINT_MAX >> 9
> 
> If multiple discard requests get merged, merged discard request's
> size exceeds 4GB, there is possibility that merged discard request's
> __data_len field may overflow.
> 
> This patch fixes this issue.
> 
> Reported-by: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> Tested-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  drivers/mmc/card/queue.c |    2 +-
>  drivers/mmc/core/core.c  |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 9447a0e..54726b7 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -166,7 +166,7 @@ static void mmc_queue_setup_discard(struct request_queue *q,
>  		return;
>  
>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
> -	q->limits.max_discard_sectors = max_discard;
> +	blk_queue_max_discard_sectors(q, max_discard);
>  	if (card->erased_byte == 0 && !mmc_can_discard(card))
>  		q->limits.discard_zeroes_data = 1;
>  	q->limits.discard_granularity = card->pref_erase << 9;
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 7b435a3..6ee530c 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2058,7 +2058,7 @@ static unsigned int mmc_do_calc_max_discard(struct mmc_card *card,
>  	if (card->erase_shift)
>  		max_qty = UINT_MAX >> card->erase_shift;
>  	else if (mmc_card_sd(card))
> -		max_qty = UINT_MAX;
> +		max_qty = UINT_MAX >> 9;

No.  This function calculates max discard for the card not the block layer.
 Apply the block layer limitation at the block layer interface e.g.
in mmc_queue_setup_discard()

>  	else
>  		max_qty = UINT_MAX / card->erase_size;
>  
> @@ -2100,7 +2100,7 @@ unsigned int mmc_calc_max_discard(struct mmc_card *card)
>  	unsigned int max_discard, max_trim;
>  
>  	if (!host->max_discard_to)
> -		return UINT_MAX;
> +		return UINT_MAX >> 9;

Ditto.

>  
>  	/*
>  	 * Without erase_group_def set, MMC erase timeout depends on clock
> 

