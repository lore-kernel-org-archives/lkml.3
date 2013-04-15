Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3DOHw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:52:56 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46768 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3DOHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <516BAA36.9030500@intel.com>
References: <1365860309-21261-1-git-send-email-linkinjeon@gmail.com>
	<516BAA36.9030500@intel.com>
Date: Mon, 15 Apr 2013 16:52:54 +0900
Message-ID: <CAKYAXd8EPHoeKY3GUZof+uzHRQ78EW68DuJfjKx=xXs45uYkOQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] mmc: fix max_discard_sectors
From: Namjae Jeon <linkinjeon@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/15, Adrian Hunter <adrian.hunter@intel.com>:
> On 13/04/13 16:38, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> https://lkml.org/lkml/2013/4/1/292
>> As per above discussion, there is possibility that request's __data_len
>> field may overflow when max_discard_sectors greater than UINT_MAX >> 9
>>
>> If multiple discard requests get merged, merged discard request's
>> size exceeds 4GB, there is possibility that merged discard request's
>> __data_len field may overflow.
>>
>> This patch fixes this issue.
>>
>> Reported-by: Max Filippov <jcmvbkbc@gmail.com>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
>> Tested-by: Max Filippov <jcmvbkbc@gmail.com>
>> ---
>>  drivers/mmc/card/queue.c |    2 +-
>>  drivers/mmc/core/core.c  |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
>> index 9447a0e..54726b7 100644
>> --- a/drivers/mmc/card/queue.c
>> +++ b/drivers/mmc/card/queue.c
>> @@ -166,7 +166,7 @@ static void mmc_queue_setup_discard(struct
>> request_queue *q,
>>  		return;
>>
>>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>> -	q->limits.max_discard_sectors = max_discard;
>> +	blk_queue_max_discard_sectors(q, max_discard);
>>  	if (card->erased_byte == 0 && !mmc_can_discard(card))
>>  		q->limits.discard_zeroes_data = 1;
>>  	q->limits.discard_granularity = card->pref_erase << 9;
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index 7b435a3..6ee530c 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -2058,7 +2058,7 @@ static unsigned int mmc_do_calc_max_discard(struct
>> mmc_card *card,
>>  	if (card->erase_shift)
>>  		max_qty = UINT_MAX >> card->erase_shift;
>>  	else if (mmc_card_sd(card))
>> -		max_qty = UINT_MAX;
>> +		max_qty = UINT_MAX >> 9;
>
> No.  This function calculates max discard for the card not the block layer.
>  Apply the block layer limitation at the block layer interface e.g.
> in mmc_queue_setup_discard()
Hi Adrian,
Okay, I will remove change in mmc_do_calc_max_discard and mmc_calc_max_discard.

>> @@ -166,7 +166,7 @@ static void mmc_queue_setup_discard(struct
>> request_queue *q,
>>  		return;
>>
>>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>> -	q->limits.max_discard_sectors = max_discard;
>> +	blk_queue_max_discard_sectors(q, max_discard);
>>  	if (card->erased_byte == 0 && !mmc_can_discard(card))
>>  		q->limits.discard_zeroes_data = 1;
Above change will handle max discard sectors as we have updated
blk_queue_max_discard_sectors to check upper limit of max discard
sectors as UINT_MAX >> 9.

Thanks.
>
>>  	else
>>  		max_qty = UINT_MAX / card->erase_size;
>>
>> @@ -2100,7 +2100,7 @@ unsigned int mmc_calc_max_discard(struct mmc_card
>> *card)
>>  	unsigned int max_discard, max_trim;
>>
>>  	if (!host->max_discard_to)
>> -		return UINT_MAX;
>> +		return UINT_MAX >> 9;
>
> Ditto.
>
>>
>>  	/*
>>  	 * Without erase_group_def set, MMC erase timeout depends on clock
>>
>
>
